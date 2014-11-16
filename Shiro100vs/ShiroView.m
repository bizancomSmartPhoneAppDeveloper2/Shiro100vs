//
//  ShiroView.m
//  Shiro100vs
//
//  Created by 寺内 信夫 on 2014/11/15.
//  Copyright (c) 2014年 寺内 信夫. All rights reserved.
//

#import "ShiroView.h"

@implementation ShiroView

//url先にある画像のデータを返すメソッド
- (UIImage *)WebImage: (NSString *)url
{
	
	//url先にあるデータをNSDataとして格納
	NSData *data = [self webdata: url];
	
	//dataを元にUIImageを生成
	UIImage *img = [UIImage imageWithData: data];
	
	//値を返す
	return img;
	
}

//url先にあるデータを返すメソッド
- (NSData *)webdata: (NSString *)url
{
	
	//URLを生成
	NSURL *dataurl = [NSURL URLWithString: url];
	
	//リクエスト生成
	NSURLRequest *request = [NSURLRequest requestWithURL: dataurl
											 cachePolicy: NSURLRequestUseProtocolCachePolicy
										 timeoutInterval: 10];
	
	//レスポンスを生成
	NSHTTPURLResponse *response;
	//NSErrorの初期化
	NSError *err = nil;
	
	//requestによって返ってきたデータを生成
	NSData *data = [NSURLConnection sendSynchronousRequest: request
										 returningResponse: &response
													 error: &err];
	
	if ( err ) {
		
		bool_Error = YES;
		
	}
	
	return data;
}

@end
