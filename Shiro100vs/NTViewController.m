//
//  NTViewController.m
//  FeedlyClientExample
//
// Copyright (c) 2014 Naoyuki Takura
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "NTViewController.h"
#import "NXOauth2.h"
#import "objc/message.h"
#import "AFNetworking.h"

@interface NTViewController ()<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *authTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)editAction:(id)sender;
- (IBAction)getInfomation:(id)sender;

@end

@implementation NTViewController

- (void)viewDidLoad
{
 
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //set datasource
    _authTableView.dataSource = self;

    //tableview inset
    _authTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
}

- (void)didReceiveMemoryWarning
{

	[super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (void)viewWillAppear:(BOOL)animated
{

	//reload account data
	[_authTableView reloadData];

	[super viewWillAppear: animated];

}

- (IBAction)editAction:(id)sender
{

	if (_authTableView.editing) {
		
		[_authTableView setEditing:NO animated:YES];
		
		_editButton.title = @"Edit";

    } else {
		
		[_authTableView setEditing:YES animated:YES];
		
		_editButton.title = @"Done";
		
	}

}

- (IBAction)getInfomation:(id)sender {
	
	//get authinticate userinfo
	NXOAuth2Account *account = [[[NXOAuth2AccountStore sharedStore] accounts] objectAtIndex: 0];

	//get user profile
	[self p_getUserProfile: account];
	
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView: (UITableView *)tableView
		 cellForRowAtIndexPath: (NSIndexPath *)indexPath
{

//	static NSString *cellId = @"accountViewCell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    
//    if (!cell) {
//		
//		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellId];
//		
//	}
//	
//	NXOAuth2Account *account = [[[NXOAuth2AccountStore sharedStore] accounts] objectAtIndex:indexPath.row];
//	
//	NSDictionary *userData = (id)account.userData;
//	
//	NSString *name = [NSString stringWithFormat:@"%@:%d",
//					  [userData objectForKey:@"fullName"], ( int )indexPath.row ];
//	
//	cell.textLabel.text = name;
//    
//    cell.detailTextLabel.text = account.identifier;
//    
//    return cell;

	static NSString *cellId = @"accountViewCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellId];
	
	if ( ! cell ) {
		
		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: cellId];
	
	}
	
	NXOAuth2Account *account = [[[NXOAuth2AccountStore sharedStore] accounts] objectAtIndex: indexPath.row];
	
	NSDictionary *userData = (id)account.userData;
	
	NSString *name = [NSString stringWithFormat: @"%@:%ld",
					  [userData objectForKey: @"fullName"], ( long )indexPath.row ];
	
	cell.textLabel.text = name;
	
	cell.detailTextLabel.text = account.identifier;
	
	return cell;
	
}

- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{

	//number of account
    return [[[NXOAuth2AccountStore sharedStore] accounts] count];

}

- (void) tableView: (UITableView *)tableView
commitEditingStyle: (UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath: (NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

	NSArray *accounts = [[NXOAuth2AccountStore sharedStore] accounts];
	
	for (NXOAuth2Account *account in accounts) {
		
		if ([account.identifier isEqualToString:cell.detailTextLabel.text]) {
			
			//delete account
            [[NXOAuth2AccountStore sharedStore] removeAccount:account];
			
			break;
			
		}
		
	}
    
    //delete tableview cell
    NSArray *deleteIndexs = [NSArray arrayWithObject:indexPath];
	
	[tableView deleteRowsAtIndexPaths:deleteIndexs withRowAnimation: UITableViewRowAnimationFade];

}

- (void)p_getUserProfile:(NXOAuth2Account *)account {
	//get user profile
	NSLog(@"account info : %@", account);
	NSLog(@"accessToken=%@",account.accessToken.accessToken);
	
	// AFNetworkingライブラリ使用箇所
	// AFHTTPRequestOperationManagerを利用して、InstagramからJSONデータを取得する
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	//get profile
	NSDictionary *params = @{@"access_token":account.accessToken.accessToken};
	
	[manager GET:@"https://api.instagram.com/v1/users/27069716/"
	  parameters:params
		 success:^(AFHTTPRequestOperation *operation, id responseObject) {
			 // 通信に成功した場合の処理
			 NSLog(@"responseObject: %@", responseObject);
			 NSString *url = responseObject[@"data"][@"profile_picture"];
			 NSURL *imageURL = [NSURL URLWithString:url];
			 
			 // SDWebImage使用箇所
			 UIImage *placeholderImage = [UIImage imageNamed: nil];
			 
			 [_imageView setImageWithURL: imageURL
						placeholderImage: placeholderImage];
			 
		 }
		 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			 // エラーの場合はエラーの内容をコンソールに出力する
			 NSLog(@"Error: %@", error);
		 }];
}

- (UIImage *)imageManager: (SDWebImageManager *)imageManager
 transformDownloadedImage: (UIImage *)image
				  withURL: (NSURL *)imageURL
{
	
	/*イメージをリサイズする*/
	CGSize resizedImageSize = CGSizeMake(90, 90);
	UIGraphicsBeginImageContextWithOptions(resizedImageSize, NO, 0.0);
	[image drawInRect:CGRectMake(0, 0, resizedImageSize.width, resizedImageSize.height)];
	UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	image = resizedImage;
	return image;
	
}

@end
