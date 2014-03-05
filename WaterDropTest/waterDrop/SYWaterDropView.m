//
//  SYWaterDropView.m
//
//
//  Created by ljh on 14-1-1.
//  Copyright (c) 2014年 linggan. All rights reserved.
//

#import "SYWaterDropView.h"

#ifndef RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#endif

#ifndef RGBCOLORA
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#endif

@interface SYWaterDropView()
{
    float _minOffset;
    float _maxOffset;
    float _radius;
    BOOL _animationing;
    BOOL _isRefresh;
}
@property(strong,nonatomic)CAShapeLayer* doudongLayer;
@property(strong,nonatomic)NSTimer* timer;
@end

@implementation SYWaterDropView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self cinit];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self cinit];
    }
    return self;
}
-(BOOL)isRefreshing
{
    return _isRefresh;
}
-(void)cinit
{
    _maxOffset = 60;
    _radius = 3.5;
    
    CGRect frame = self.frame;
    frame.size = CGSizeMake(30, 100);  //固定 30 * 100
    self.frame = frame;
    
    _lineLayer = [CAShapeLayer layer];
    _lineLayer.fillColor = RGBACOLOR(222, 216, 211, 0.5).CGColor;
    [self.layer addSublayer:_lineLayer];
    
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.fillColor = RGBCOLOR(222, 216, 211).CGColor;
    _shapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
    _shapeLayer.lineWidth = 3;
    [self.layer addSublayer:_shapeLayer];
    
    _doudongLayer = [CAShapeLayer layer];
    _doudongLayer.fillColor = RGBCOLOR(222, 216, 211).CGColor;
    _doudongLayer.strokeColor = [[UIColor whiteColor] CGColor];
    _doudongLayer.lineWidth = 3;
    _doudongLayer.frame = CGRectMake(15-_radius,self.bounds.size.height-20-_radius*2, _radius*2, _radius*2);
    _doudongLayer.path = CGPathCreateWithEllipseInRect(_doudongLayer.bounds, NULL);
    _doudongLayer.opacity = 0;
    [self.layer addSublayer:_doudongLayer];
    
    self.currentOffset = 0;
}

-(CGMutablePathRef)createPathWithOffset:(float)currentOffset
{
    CGMutablePathRef path = CGPathCreateMutable();
    float top = self.bounds.size.height - 20 - _radius*2 - currentOffset;
    float wdiff = currentOffset* 0.2;
    
    if(currentOffset==0)
    {
        CGPathAddEllipseInRect(path, NULL, CGRectMake(15-_radius, top, _radius*2, _radius*2));
    }
    else
    {
        CGPathAddArc(path, NULL, 15,top+_radius, _radius, 0, M_PI, YES);
        float bottom = top + wdiff+_radius*2;
        if(currentOffset<10)
        {
            CGPathAddCurveToPoint(path, NULL,15-_radius,bottom,15,bottom, 15,bottom);
            CGPathAddCurveToPoint(path, NULL, 15,bottom,15+_radius,bottom, 15+_radius, top+_radius);
        }
        else
        {
            CGPathAddCurveToPoint(path, NULL,15-_radius ,top +_radius, 15 - _radius ,bottom-2,15 , bottom);
            CGPathAddCurveToPoint(path,NULL, 15 + _radius, bottom-2, 15+_radius,top +_radius , 15+_radius, top+_radius);
        }
    }
    CGPathCloseSubpath(path);
    
    return path;
}
-(void)setCurrentOffset:(float)currentOffset
{
    if(_isRefresh)
        return;
    
    [self privateSetCurrentOffset:currentOffset];
}
-(void)privateSetCurrentOffset:(float)currentOffset
{
    currentOffset = currentOffset>0?0:currentOffset;
    currentOffset = -currentOffset;
    _currentOffset =  currentOffset;
    if(currentOffset < _maxOffset)
    {
        float wdiff = currentOffset* 0.2;
        float top = self.bounds.size.height - 20 - _radius*2 - currentOffset;
        
        CGMutablePathRef path = [self createPathWithOffset:currentOffset];
        _shapeLayer.path = path;
        CGPathRelease(path);
        
        
        CGMutablePathRef line = CGPathCreateMutable();
        float w = ((_maxOffset - currentOffset)/_maxOffset) + 1;
        if(currentOffset==0)
        {
            CGPathAddRect(line, NULL, CGRectMake(15-w/2, top + wdiff + _radius*2,w, currentOffset-wdiff+20));
        }
        else{
            float lt = top+wdiff+_radius*2;
            float lb = currentOffset-wdiff+20 + lt;
            CGPathMoveToPoint(line, NULL, 15- w/2,lt);
            CGPathAddLineToPoint(line, NULL, 15 + w/2,lt);
            
            CGPathAddCurveToPoint(line, NULL,15 + w/2,lt, 15 + w/2,lt+10, 15+1 , lb);
            CGPathAddLineToPoint(line,  NULL, 15 - 1, lb);
            CGPathAddCurveToPoint(line, NULL,15 - w/2,lt, 15 - w/2,lt+10,15-w/2, lt);
        }
        CGPathCloseSubpath(line);
        _lineLayer.path = line;
        CGPathRelease(line);
        self.transform = CGAffineTransformMakeScale(0.85+0.15*(w-1), 1);
    }
    else
    {
        if(self.timer == nil)
        {
            _isRefresh = YES;
            self.transform = CGAffineTransformIdentity;
            self.timer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(resetWater) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            [_timer fire];
        }
    }
}
-(void)resetWater
{
    [self privateSetCurrentOffset:-(_currentOffset-(_maxOffset/8))];
    if(_currentOffset==0)
    {
        [self.timer invalidate];
        self.timer = nil;
        
        if(self.handleRefreshEvent!= nil)
        {
            self.handleRefreshEvent();
        }
        [self doudong];
    }
}
-(void)stopRefresh
{
    _isRefresh = NO;
    
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim.fromValue = @(1);
    anim.toValue = @(0);
    anim.duration = 0.2;
    anim.delegate = self;
    [_refreshView.layer addAnimation:anim forKey:nil];
    _refreshView.layer.opacity = 0;
    
    
    anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim.fromValue = @(0);
    anim.toValue = @(1);
    anim.beginTime = 0.2;
    anim.duration = 0.2;
    anim.delegate = self;
    [_shapeLayer addAnimation:anim forKey:nil];
    _shapeLayer.opacity = 0;
}
-(void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag
{
    if(anim.beginTime > 0)
    {
        _shapeLayer.opacity = 1;
    }
    else
    {
        [_refreshView.layer removeAllAnimations];
    }
}

-(void)startRefreshAnimation
{
    if(self.refreshView == nil)
    {
        self.refreshView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"first_timetowlight"]];
        [self addSubview:_refreshView];
    }
    
    _doudongLayer.opacity = 0;
    _shapeLayer.opacity = 0;
    
    _refreshView.center = CGPointMake(15,self.bounds.size.height - 20 - _radius);
    [_refreshView.layer removeAllAnimations];
    _refreshView.layer.opacity = 1;
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 1;
    animation.fromValue = @0;
    animation.toValue = @(M_PI*2);
    animation.repeatCount = INT_MAX;
    
    [_refreshView.layer addAnimation:animation forKey:@"rotation"];
}

-(CGPoint)scaleWithIndex:(int)i
{
    float xvalue = 1 - (0.4f- i*0.1f)*(2 * i%2 - 1);
    float yvalue = 1 + (0.4f- i*0.1f)*(2 * i%2 - 1);
    
    if(i%2==0){
        return CGPointMake(yvalue, xvalue);
    }
    else{
        return CGPointMake(xvalue, yvalue);
    }
}

NS_INLINE CATransform3D CATransform3DMakeRotationScale(CGFloat angle,CGFloat sx, CGFloat sy,
                                                       CGFloat sz)
{
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, angle, 0, 0, 1);
    transform = CATransform3DScale(transform, sx, sy, sz);
    transform = CATransform3DRotate(transform, -angle, 0, 0, 1);
    return transform;
}
-(void)doudong
{
    _doudongLayer.opacity = 1;
    _shapeLayer.opacity = 0;
    
    float kDuration = 0.5;
    float angle = M_PI;
    float w = 1.3 , h = 1.3;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = [NSArray arrayWithObjects:
                        [NSValue valueWithCATransform3D:_doudongLayer.transform],
                        [NSValue valueWithCATransform3D:CATransform3DMakeRotationScale(angle,w, 2-h, 1)],
                        [NSValue valueWithCATransform3D:CATransform3DMakeRotationScale(angle,1-(w-1)*0.5, 1+(h-1)*0.5, 1)],
                        [NSValue valueWithCATransform3D:CATransform3DMakeRotationScale(angle,1+(w-1)*0.25, 1-(h-1)*0.25, 1)],
                        [NSValue valueWithCATransform3D:CATransform3DMakeRotationScale(angle,1, 1, 1)], nil];
    animation.keyTimes = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0],
                          [NSNumber numberWithFloat:0.3],
                          [NSNumber numberWithFloat:0.6],
                          [NSNumber numberWithFloat:0.9],
                          [NSNumber numberWithFloat:1], nil];
    _doudongLayer.transform = CATransform3DIdentity;
    animation.timingFunctions = [NSArray arrayWithObjects:
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], nil];
    
    animation.duration = kDuration;
    [_doudongLayer addAnimation:animation forKey:nil];
    
    __weak SYWaterDropView* wself = self;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDuration * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        wself.doudongLayer.opacity = 0;
        [wself startRefreshAnimation];
    });
}
@end
