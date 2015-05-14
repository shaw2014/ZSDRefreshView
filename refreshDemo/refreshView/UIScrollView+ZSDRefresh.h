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
- (void)addHeadWithCallback:(void (^)())callback;

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)headBeginRefreshing;

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)headEndRefreshing;

/**
 *  是否正在下拉刷新
 */
@property (nonatomic, assign, readonly, getter = isHeadRefreshing) BOOL headRefreshing;

/**
 *  添加一个上拉加载头部控件
 *
 *  @param callback 回调
 */
- (void)addFootWithCallback:(void (^)())callback;

/**
 *  主动让上拉加载头部控件进入刷新状态
 */
- (void)footBeginRefreshing;

/**
 *  让上拉加载头部控件停止刷新状态
 */
- (void)footEndRefreshing;

/**
 *  是否正在上拉刷新
 */
@property (nonatomic, assign, readonly, getter = isFootRefreshing) BOOL footRefreshing;

@end
