//
//  AuthWebViewController.h
//  OAuthTest
//
//  Created by Jun Takahashi on 2014/07/09.
//  Copyright (c) 2014年 Jun Takahashi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NXOAuth2.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

@interface AuthWebViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end
