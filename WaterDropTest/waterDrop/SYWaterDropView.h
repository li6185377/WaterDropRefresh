//
//  SYWaterDropView.h
//  Seeyou
//
//  Created by ljh on 14-1-1.
//  Copyright (c) 2014年 linggan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYWaterDropView : UIView

@property(strong,nonatomic)CAShapeLayer* shapeLayer;
@property(strong,nonatomic)CAShapeLayer* lineLayer;
@property(strong,nonatomic)UIImageView* refreshView;

@property(readonly,nonatomic)BOOL isRefreshing;

-(void)stopRefresh;
-(void)startRefreshAnimation;

@property(copy,nonatomic)void(^handleRefreshEvent)(void) ;
@property(nonatomic) float currentOffset;
@end
