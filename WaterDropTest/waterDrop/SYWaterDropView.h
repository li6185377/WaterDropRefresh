//
//  SYWaterDropView.h
//  Seeyou
//
//  Created by ljh on 14-1-1.
//  Copyright (c) 2014年 linggan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYWaterDropView : UIView

@property float waterTop;           //水滴 距离底部的距离
@property float maxDropLength;      //最长拖动距离
@property float radius;             //水滴的半径

//设置完参数后  需要手动调用此方法
-(void)loadWaterView;

@property(strong,nonatomic)CAShapeLayer* shapeLayer;
@property(strong,nonatomic)CAShapeLayer* lineLayer;
@property(strong,nonatomic)UIImageView* refreshView;

@property(readonly,nonatomic)BOOL isRefreshing;

-(void)stopRefresh;
-(void)startRefreshAnimation;

@property(copy,nonatomic)void(^handleRefreshEvent)(void) ;
@property(nonatomic) float currentOffset;
@end
