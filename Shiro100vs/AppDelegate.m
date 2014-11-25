//
//  AppDelegate.m
//  Shiro_100
//
//  Created by 寺内 信夫 on 2014/11/02.
//  Copyright (c) 2014年 寺内 信夫. All rights reserved.
//

#import "AppDelegate.h"

#import "NXOAuth2.h"

//for Feedly Oauth2(sandbox)
//account type
NSString * const kOauth2ClientAccountType = @"Instagram";//@"Test App";//
//clientId
static NSString * const kOauth2ClientClientId = @"6cf2fe852f4b4b7898d5f36cb3b3ccad";
//Client Secret
static NSString * const kOauth2ClientClientSecret = @"eabe40cb7dc341369588e017eb998103";
//Redirect Url
static NSString * const kOauth2ClientRedirectUrl = @"http://localhost";//@"nxdevchallange://oauth";//
//base url
static NSString * const kOauth2ClientBaseUrl = @"https://api.instagram.com/oauth";
//auth url
static NSString * const kOauth2ClientAuthUrl = @"/authorize";
//token url
static NSString * const kOauth2ClientTokenUrl = @"/access_token";
//scope url
static NSString * const kOauth2ClientScopeUrl = @"basic";//@"likes+relationships+comments+basic";// @"likes", @"relationships", @"comments"@"basic";//@"https://api.instagram.com/subscriptions";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

	// Override point for customization after application launch.

	[self shiroData];
	
	self.bool_Ranking = self.bool_MyRank = NO;

	return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)shiroData
{

	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	
	self.string_Shikan = [ud objectForKey: @"shiro100_shikan"];

//	NSLog( @"1 get %@", self.string_Shikan );
	
	if ( self.string_Shikan == nil ) {
		
		self.string_Shikan = @"徳島城";
		
	}

//	NSLog( @"2 get %@", self.string_Shikan );
	
}

- (void)setShiroData
{
	
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	
	[ud setObject: self.string_Shikan forKey: @"shiro100_shikan"];
	
//	NSLog( @"put %@", self.string_Shikan );
	
}

- (void)setShiroBool
{

	self.bool_Ranking = self.bool_MyRank = YES;
	
}

+ (void)initialize
{
	
	NSString *authUrl  = [kOauth2ClientBaseUrl stringByAppendingString: kOauth2ClientAuthUrl];
	NSString *tokenUrl = [kOauth2ClientBaseUrl stringByAppendingString: kOauth2ClientTokenUrl];
	
	//setup oauth2client
	//	[[NXOAuth2AccountStore sharedStore] setClientID:kOauth2ClientClientId
	//											 secret:kOauth2ClientClientSecret
	//											  scope:[NSSet setWithObjects:kOauth2ClientScopeUrl, nil]
	//								   authorizationURL:[NSURL URLWithString:authUrl]
	//										   tokenURL:[NSURL URLWithString:tokenUrl]
	//										redirectURL:[NSURL URLWithString:kOauth2ClientRedirectUrl]
	//									 forAccountType:kOauth2ClientAccountType];
	
	[[NXOAuth2AccountStore sharedStore] setClientID: kOauth2ClientClientId
											 secret: kOauth2ClientClientSecret
											  scope: [NSSet setWithObjects:kOauth2ClientScopeUrl, nil]//[NSSet setWithObjects: @"basic", @"likes", @"relationships", @"comments", nil]
								   authorizationURL: [NSURL URLWithString: authUrl]//@"https://api.instagram.com/oauth/authorize"]
										   tokenURL: [NSURL URLWithString: tokenUrl]//@"https://api.instagram.com/oauth/access_token"]
										redirectURL: [NSURL URLWithString: kOauth2ClientRedirectUrl] //@"myapp://instagram-callback"]@"http://localhost"] //@"nxdevchallange://oauth"
									  keyChainGroup: @"Instagram"
									 forAccountType: kOauth2ClientAccountType];//@"Test App"];//@"Instagram"];
	
	//	[[NXOAuth2AccountStore sharedStore] setClientID: kOauth2ClientClientId
	//											 secret: kOauth2ClientClientSecret
	//								   authorizationURL: [NSURL URLWithString: authUrl]
	//										   tokenURL: [NSURL URLWithString: tokenUrl]
	//										redirectURL: [NSURL URLWithString: kOauth2ClientRedirectUrl]
	//									 forAccountType: kOauth2ClientAccountType];
	
	//	[[NXOAuth2AccountStore sharedStore] setClientID: kOauth2ClientClientId
	//											 secret: kOauth2ClientClientSecret
	//											  scope: [NSSet setWithObjects:kOauth2ClientScopeUrl, nil]
	//								   authorizationURL: [NSURL URLWithString:authUrl]
	//										   tokenURL: [NSURL URLWithString: tokenUrl]
	//										redirectURL: [NSURL URLWithString: kOauth2ClientRedirectUrl]
	//									  keyChainGroup: @"Instagram"
	//									 forAccountType: kOauth2ClientAccountType];
	
	//	[[NXOAuth2AccountStore sharedStore] setClientID: kOauth2ClientClientId
	//											 secret: kOauth2ClientClientSecret
	////											  scope: [NSSet setWithObjects:@"likes", @"relationships", @"comments", nil]
	//								   authorizationURL: [NSURL URLWithString: @"https://api.instagram.com/oauth/authorize"]
	//										   tokenURL: [NSURL URLWithString: @"https://api.instagram.com/oauth/access_token"]
	//										redirectURL: [NSURL URLWithString: @"nxdevchallange://oauth"] //@"myapp://instagram-callback"] @"http://localhost"] //
	//									 forAccountType: @"Test App"];//@"Instagram"];
	
}

@end
