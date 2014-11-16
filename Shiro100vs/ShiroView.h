//
//  ShiroView.h
//  Shiro100vs
//
//  Created by 寺内 信夫 on 2014/11/15.
//  Copyright (c) 2014年 寺内 信夫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShiroView : UIView
{

@protected
	
	BOOL bool_Error;
	
}

- (UIImage *)WebImage: (NSString *)url;
- (NSData *)webdata: (NSString *)url;

@end
