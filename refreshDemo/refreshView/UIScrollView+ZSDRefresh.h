//
//  UIScrollView+ZSDRefresh.h
//  demo
//
//  Created by zhaoxiao on 15/3/2.
//  Copyright (c) 2015年 zhaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ZSDRefresh)

/**
 *  添加一个下拉刷新头部控件
 *
 *  @param callback 回调
 */
- (void)addHeaderWithCallback:(void (^)())callback;

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)headerBeginRefreshing;

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)headerEndRefreshing;

@end
