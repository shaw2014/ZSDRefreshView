//
//  ZSDRefreshBaseView.h
//  demo
//
//  Created by zhaoxiao on 15/2/28.
//  Copyright (c) 2015年 zhaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRefreshViewHeight 100.0f
#define kOffsetObserveKey @"contentOffset"

typedef NS_ENUM(NSInteger, ZSDRefreshState)
{
    ZSDRefreshStateNone,
    ZSDRefreshStatePulling,        // 松开就可以进行刷新的状态
    ZSDRefreshStateNormal,         // 普通状态
    ZSDRefreshStateRefreshing,     // 正在刷新中的状态
    ZSDRefreshStateWillRefreshing
};

@interface ZSDRefreshBaseView : UIView

@property (nonatomic,weak,readonly) UIScrollView *scrollView;
@property (nonatomic,assign,readonly) UIEdgeInsets scrollViewOriginalInset;

@property (nonatomic,assign) ZSDRefreshState state;

@property (nonatomic,copy) void (^beginRefreshCallback)();

-(void)beginRefresh;
-(void)endRefresh;

@end
