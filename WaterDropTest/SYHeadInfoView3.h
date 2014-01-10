//
//  SYHeadInfoView3.h
//  Seeyou
//
//  Created by upin on 13-12-20.
//  Copyright (c) 2013年 linggan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYWaterDropView.h"

@interface SYHeadInfoView3 : UIView
{
    BOOL touch1,touch2,hasStop;
    BOOL isrefreshed;
}
@property (weak, nonatomic) IBOutlet UIImageView *img_banner;
@property (weak, nonatomic) IBOutlet UIButton *bt_avatar;
@property (weak, nonatomic) IBOutlet SYWaterDropView *waterView;
@property (weak, nonatomic) IBOutlet UIView *showView;

//注意看 scrollView 的回调
@property(nonatomic) BOOL touching;
@property(nonatomic) float offsetY;

@property(copy,nonatomic)void(^handleRefreshEvent)(void) ;
-(void)stopRefresh;
@end
