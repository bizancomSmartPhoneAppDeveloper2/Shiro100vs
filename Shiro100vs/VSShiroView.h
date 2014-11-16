//
//  VSShiroView.h
//  Shiro100vs
//
//  Created by 寺内 信夫 on 2014/11/14.
//  Copyright (c) 2014年 寺内 信夫. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShiroView.h"

@interface VSShiroView : ShiroView

@property NSDictionary *dic_Data;

- (void)setDic_Data:(NSDictionary *)dic_Data_;
- (NSDictionary *)dic_Data;

@end
