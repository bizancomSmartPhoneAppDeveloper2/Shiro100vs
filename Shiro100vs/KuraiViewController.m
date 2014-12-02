//
//  KuraiViewController.m
//  Shiro100vs
//
//  Created by 寺内 信夫 on 2014/11/30.
//  Copyright (c) 2014年 寺内 信夫. All rights reserved.
//

#import "KuraiViewController.h"

#import "NXOauth2.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface KuraiViewController ()

@end

@implementation KuraiViewController

- (void)viewDidLoad
{

	[super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{

	[super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (void)viewWillAppear: (BOOL)animated
{
	
	NSInteger count = [[[NXOAuth2AccountStore sharedStore] accounts] count];
	if ( count == 0 ) {
		
		return;
	
	}
	
	NXOAuth2Account *account = [[[NXOAuth2AccountStore sharedStore] accounts] objectAtIndex: 0];

	NSDictionary *params = @{ @"access_token": account.accessToken.accessToken };
	
	// AFNetworkingライブラリ使用箇所
	// AFHTTPRequestOperationManagerを利用して、InstagramからJSONデータを取得する
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	[manager GET: @"https://api.instagram.com/v1/users/search"
	  parameters: params
		 success: ^(AFHTTPRequestOperation *operation, id responseObject) {
			 // 通信に成功した場合の処理
			 NSLog(@"responseObject: %@", responseObject);
			 
			 NSString *username = responseObject[@"data"][@"username"];
			 NSString *url      = responseObject[@"data"][@"profile_picture"];
			 NSString *userid   = responseObject[@"data"][@"id"];
			 
			 self.label_FullName.text = username;
			 
			 NSURL *imageURL = [NSURL URLWithString: url];
			 
			 // SDWebImage使用箇所
			 UIImage *image = [UIImage imageNamed: nil];
			 [self.imageView_Profile setImageWithURL: imageURL
									placeholderImage: image];
			 
		 }
		 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			 // エラーの場合はエラーの内容をコンソールに出力する
			 NSLog(@"Error: %@", error);
		 }];
	
//	NSDictionary *userData = (id)account.userData;
//	
//	NSString *name = [userData objectForKey: @"fullName"];
//	
//	//get profile
//	//	[manager GET:@"https://api.instagram.com/v1/users/27069716/"
//	//	[manager GET:@"https://api.instagram.com/v1/users/1545926994/"
//	//	  parameters:params
//	//		 success:^(AFHTTPRequestOperation *operation, id responseObject) {
//	//			 // 通信に成功した場合の処理
//	//			 NSLog(@"responseObject: %@", responseObject);
//	//
//	//			 NSString *url = responseObject[@"data"][@"profile_picture"];
//	//			 NSURL *imageURL = [NSURL URLWithString:url];
//	//
//	//			 // SDWebImage使用箇所
//	//			 UIImage *placeholderImage = [UIImage imageNamed:nil];
//	//			 [_imageView setImageWithURL:imageURL
//	//						placeholderImage:placeholderImage];
//	//
//	//		 }
//	//		 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//	//			 // エラーの場合はエラーの内容をコンソールに出力する
//	//			 NSLog(@"Error: %@", error);
//	//		 }];
//	
//	[manager GET:@"https://api.instagram.com/v1/users/1545926994/media/recent"
//	  parameters:params
//		 success:^(AFHTTPRequestOperation *operation, id responseObject) {
//			 // 通信に成功した場合の処理
//			 NSLog(@"responseObject: %@", responseObject);
//			 
//			 NSString *url = responseObject[@"data"][10][@"images"][@"thumbnail"][@"url"];
//			 NSURL *imageURL = [NSURL URLWithString:url];
//			 
//			 // SDWebImage使用箇所
//			 UIImage *placeholderImage = [UIImage imageNamed:nil];
////			 [_imageView setImageWithURL:imageURL
////						placeholderImage:placeholderImage];
//			 
//		 }
//		 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//			 // エラーの場合はエラーの内容をコンソールに出力する
//			 NSLog(@"Error: %@", error);
//		 }];
	
}

- (void)viewDidAppear: (BOOL)animated
{
	
}

- (void)viewWillDisappear: (BOOL)animated
{
	
}

- (void)viewDidDisappear: (BOOL)animated
{

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
