//
//  ZSDRefreshCircleView.h
//  demo
//
//  Created by zhaoxiao on 15/2/28.
//  Copyright (c) 2015年 zhaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSDRefreshCircleView : UIView

@property (nonatomic,copy) UIImage *image;
@property (nonatomic,assign) CGFloat progress;      //圆形进度，值为0~1

-(void)startAnimation;
-(void)stopAnimation;

@end
