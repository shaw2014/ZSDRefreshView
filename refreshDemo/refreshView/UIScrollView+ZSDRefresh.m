//
//  UIScrollView+ZSDRefresh.m
//  demo
//
//  Created by zhaoxiao on 15/3/2.
//  Copyright (c) 2015年 zhaoxiao. All rights reserved.
//

#import "UIScrollView+ZSDRefresh.h"
#import "ZSDRefreshHeadView.h"
#import <objc/runtime.h>

@interface UIScrollView()

@property (weak, nonatomic) ZSDRefreshHeadView *header;

@end

@implementation UIScrollView (ZSDRefresh)

#pragma mark - 运行时相关
static char ZSDRefreshHeaderViewKey;

- (void)setHeader:(ZSDRefreshHeadView *)header {
    [self willChangeValueForKey:@"ZSDRefreshHeaderViewKey"];
    objc_setAssociatedObject(self, &ZSDRefreshHeaderViewKey,
                             header,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"ZSDRefreshHeaderViewKey"];
}

- (ZSDRefreshHeadView *)header {
    return objc_getAssociatedObject(self, &ZSDRefreshHeaderViewKey);
}

/**
 *  添加一个下拉刷新头部控件
 *
 *  @param callback 回调
 */
- (void)addHeaderWithCallback:(void (^)())callback
{
    // 1.创建新的header
    if (!self.header) {
        ZSDRefreshHeadView *header = [ZSDRefreshHeadView header];
        [self addSubview:header];
        self.header = header;
    }
    
    // 2.设置block回调
    self.header.beginRefreshCallback = callback;
}

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)headerBeginRefreshing
{
    [self.header beginRefresh];
}

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)headerEndRefreshing
{
    [self.header endRefresh];
}

@end
