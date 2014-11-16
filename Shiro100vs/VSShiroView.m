//
//  VSShiroView.m
//  Shiro100vs
//
//  Created by 寺内 信夫 on 2014/11/14.
//  Copyright (c) 2014年 寺内 信夫. All rights reserved.
//

#import "VSShiroView.h"

@implementation VSShiroView

- (void)setDic_Data:(NSDictionary *)dic_Data_
{
	
	if ( [dic_Data_ count] == 0 ) {
		
		NSLog( @"なし" );
		
	} else {
		
		NSLog( @"%@", dic_Data_ );
		
	}
	
}

- (NSDictionary *)dic_Data
{
	
	return self.dic_Data;
	
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
