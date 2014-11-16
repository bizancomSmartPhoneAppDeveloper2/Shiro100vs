//
//  MyShiroView.m
//  Shiro100vs
//
//  Created by 寺内 信夫 on 2014/11/14.
//  Copyright (c) 2014年 寺内 信夫. All rights reserved.
//

#import "MyShiroView.h"

@implementation MyShiroView

- (void)setDic_Data:(NSDictionary *)dic_Data_
{

//	if ( [dic_Data_ count] == 0 ) {
//		
//		NSLog( @"なし" );
//		
//	} else {
//		
//		NSLog( @"%@", dic_Data_ );
//		
//		dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//		dispatch_queue_t q_main   = dispatch_get_main_queue();
//		
//		cell.imageView_Shiro.image = nil;
//		
//		dispatch_async( q_global, ^{
//			
//			UIImage *image = [self WebImage:[dic_Data_ objectForKey: @"imagename"]];
//			
//			dispatch_async( q_main, ^{
//				
//				cell.imageView_Shiro.image = image;
//				cell.imageView_Shiro.contentMode = UIViewContentModeScaleAspectFit;
//				
//			});
//			
//		});
//		
//	}
	
}

- (NSDictionary *)dic_Data
{
	
	return self.dic_Data;
	
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	
}

@end
