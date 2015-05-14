//
//  ZSDRefreshBaseView.h
//  demo
//
//  Created by zhaoxiao on 15/2/28.
//  Copyright (c) 2015年 zhaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSDRefreshCircleView.h"

#define kRefreshHeaderHeight 100.0f
#define kRefreshFooterHeight 80.0f
#define kOffsetObserveKey @"contentOffset"
#define kContentSizeObserveKey @"contentSize"

typedef NS_ENUM(NSInteger, ZSDRefreshState)
{
    ZSDRefreshStateNone,
    ZSDRefreshStatePulling,        // 松开就可以进行刷新的状态
    ZSDRefreshStateNormal,         // 普通状态
    ZSDRefreshStateRefreshing,     // 正在刷新中的状态
    ZSDRefreshStateWillRefreshing
};

@interface ZSDRefreshBaseView : UIView

@property (nonatomic,strong,readonly) UILabel *textLabel;
@property (nonatomic,strong,readonly) UIImageView *backgroundImageView;
@property (nonatomic,strong,readonly) ZSDRefreshCircleView *arrowCircleView;

@property (nonatomic,weak,readonly) UIScrollView *scrollView;
@property (nonatomic,assign,readonly) UIEdgeInsets scrollViewOriginalInset;

@property (nonatomic,assign) ZSDRefreshState state;
@property (nonatomic,assign) BOOL isInitFooter;

@property (nonatomic,copy) void (^beginRefreshCallback)();

- (void)settingLabelText;

-(void)beginRefresh;
-(void)endRefresh;

@end
