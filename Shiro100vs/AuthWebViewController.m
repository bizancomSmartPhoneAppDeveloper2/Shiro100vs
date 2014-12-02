//
//  AuthWebViewController.m
//  OAuthTest
//
//  Created by Jun Takahashi on 2014/07/09.
//  Copyright (c) 2014年 Jun Takahashi. All rights reserved.
//

#import "AuthWebViewController.h"

@interface AuthWebViewController ()

@property (strong, nonatomic) id successObserver;
@property (strong, nonatomic) id failObserver;

@end

@implementation AuthWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _webView.delegate = self;
    
    //init notifications
    [self p_addOauth2Notification];
    [self p_startRequest];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    //hide network activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //remove notifications
    [self p_removeOauth2Notification];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)p_addOauth2Notification
{

	//setup notifications for success or fail
    //for success
    self.successObserver = [[NSNotificationCenter defaultCenter]
							addObserverForName: NXOAuth2AccountStoreAccountsDidChangeNotification
							object: [NXOAuth2AccountStore sharedStore]
                            queue: nil
							usingBlock: ^(NSNotification *notification) {
                                //TODO
                                NSLog(@"Success.");
                                
                                //get authinticate userinfo
                                NSDictionary *dict = notification.userInfo;
                                NXOAuth2Account *account = [dict valueForKey:NXOAuth2AccountStoreNewAccountUserInfoKey];
                                NSLog(@"account=%@",account);
                                
                                //pop navigation controller
                                [self.navigationController popViewControllerAnimated:YES];
								[self p_getUserProfile:account];

							}];
    
    //for fail
    self.failObserver = [[NSNotificationCenter defaultCenter]
                         addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                         object:[NXOAuth2AccountStore sharedStore]
                         queue:nil
                         usingBlock:^(NSNotification *note) {
                             //TODO
                             NSLog(@"Fail.");
                             
                             //TODO error message.
                             
                             //pop navigation controller
                             [self.navigationController popViewControllerAnimated:YES];
                             
                         }];
    
}

- (void)p_startRequest {
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:kOauth2ClientAccountType
                                   withPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
                                       //start authentication request.
                                       [_webView loadRequest:[NSURLRequest requestWithURL:preparedURL]];
                                       
                                   }];
}

- (void)p_getUserProfile:(NXOAuth2Account *)account {
	//get user profile on feedly user
	NSLog(@"account info : %@", account);
	
//	NSURL *targetUrl = [NSURL URLWithString: @"https://sandbox.feedly.com/v3/profile"];
	NSURL *targetUrl = [NSURL URLWithString: @"https://api.instagram.com/v1/profile"];
	[NXOAuth2Request performMethod:@"GET"
						onResource:targetUrl
				   usingParameters:nil
					   withAccount:account
			   sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) {
				   //TODO
			   }
				   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
					   NSLog(@"error : %@", error);
					   NSLog(@"response : %@", response);
					   NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
					   NSLog(@"response data : %@", jsonString);
					   
					   //
					   if (!error) {
						   //success
						   NSLog(@"get profile success.");
						   //json変換してDictionary型をuserDataとして格納する
						   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
						   if (dict) {
							   //set user data
							   [account setUserData:dict];
						   }
						   
						   //pop viewcontroller
						   [self.navigationController popViewControllerAnimated:YES];
						   
					   } else {
						   //error
						   NSLog(@"get profile failer.");
					   }
					   
				   }];
	
}

- (void) p_removeOauth2Notification
{
	
	if ( self.successObserver ) {

		[[NSNotificationCenter defaultCenter] removeObserver:self.successObserver];
		
	}
	
	if ( self.failObserver ) {
		
		[[NSNotificationCenter defaultCenter] removeObserver:self.failObserver];

	}

}

#pragma mark - UIWebViewDelegate

- (BOOL)           webView: (UIWebView *)webView
shouldStartLoadWithRequest: (NSURLRequest *)request
            navigationType: (UIWebViewNavigationType)navigationType
{

	NSLog( @"%@", [request URL] );
	
	if ([[NXOAuth2AccountStore sharedStore] handleRedirectURL:[request URL]]) {
        return NO;
    }

	return YES;

}

- (void) webViewDidStartLoad:(UIWebView *)webView {
	NSURL *url = [webView.request mainDocumentURL];
	NSLog(@"Requested url: %@", url);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
	NSURL *url = [webView.request mainDocumentURL];
	NSLog(@"Loaded url: %@", url);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
