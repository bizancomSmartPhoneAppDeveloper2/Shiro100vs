//
//  MyRankTableViewCell.h
//  Shiro_100vs
//
//  Created by 寺内 信夫 on 2014/11/13.
//  Copyright (c) 2014年 寺内 信夫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRankTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView_Shiro;

@property (weak, nonatomic) IBOutlet UILabel *label_Rank;
@property (weak, nonatomic) IBOutlet UILabel *label_Shiro;
@property (weak, nonatomic) IBOutlet UILabel *label_Comment;

@end
