//
//  ZSDRefreshCircleView.m
//  demo
//
//  Created by zhaoxiao on 15/2/28.
//  Copyright (c) 2015年 zhaoxiao. All rights reserved.
//---------------下拉刷新转动的圆圈--------------

#import "ZSDRefreshCircleView.h"

@interface ZSDRefreshCircleView ()
{
    UIImageView *imageView;
    
    CAShapeLayer *circleLayer;
    CAShapeLayer *arrowLayer;
}

@end

@implementation ZSDRefreshCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.backgroundColor = [UIColor clearColor];
        
        circleLayer = [CAShapeLayer layer];
        circleLayer.frame = self.bounds;
        circleLayer.lineWidth = 2.0f;
        circleLayer.strokeColor = [UIColor grayColor].CGColor;
        circleLayer.fillColor = nil;
        circleLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:circleLayer];
        
        arrowLayer = [CAShapeLayer layer];
        arrowLayer.frame = CGRectMake(4.0f, 3.0f, frame.size.width - 2 * 4.0f, frame.size.height - 2 * 3.0f);
        arrowLayer.fillColor = nil;
        [self.layer addSublayer:arrowLayer];
        
//        [self setup];
    }
    return self;
}

-(void)setup
{
    if(!imageView)
    {
        imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:imageView];
    }
}

-(void)setImage:(UIImage *)image
{
    if(_image != image)
    {
        _image = image;
        
//        imageView.image = _image;
        arrowLayer.contents = (id)_image.CGImage;
    }
}

-(void)setProgress:(CGFloat)progress
{
    if(_progress != progress)
    {
        _progress = progress;
        
        [self drawPath];
    }
}

-(void)drawPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];

    CGFloat startAngle = -M_PI_2;
    CGFloat step = M_PI * 1.8f * self.progress;
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidX(self.bounds));
    [path addArcWithCenter:center radius:self.bounds.size.width / 2.0f startAngle:startAngle endAngle:startAngle + step clockwise:YES];
    
    circleLayer.path = [path CGPath];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self setup];
    }
    return self;
}

/**
 *  开始动画
 */
-(void)startAnimation
{
    [circleLayer removeAnimationForKey:@"RotationAnimation"];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(M_PI * 2);
    animation.repeatCount = MAXFLOAT;
    animation.duration = 0.5f;
    animation.fillMode = kCAFillModeForwards;
    
    [circleLayer addAnimation:animation forKey:@"RotationAnimation"];
}

/**
 *  停止动画
 */
-(void)stopAnimation
{
    [circleLayer removeAnimationForKey:@"RotationAnimation"];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    if(_progress == 0)
//    {
//        return;
//    }
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetLineWidth(context, 3.0f);
//    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
//    CGFloat startAngle = -M_PI_2;
//    CGFloat step = M_PI * 1.9f * self.progress;
//    CGContextAddArc(context, rect.size.width / 2.0f, rect.size.height / 2.0f, rect.size.width / 2.0f - 1, startAngle, startAngle + step, 0);
//    CGContextStrokePath(context);
//}

@end
