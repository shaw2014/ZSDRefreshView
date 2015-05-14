//
//  UIScrollView+ZSDRefresh.m
//  demo
//
//  Created by zhaoxiao on 15/3/2.
//  Copyright (c) 2015年 zhaoxiao. All rights reserved.
//

#import "UIScrollView+ZSDRefresh.h"
#import "ZSDRefreshHeadView.h"
#import "ZSDRefreshFootView.h"
#import <objc/runtime.h>

@interface UIScrollView()

@property (weak, nonatomic) ZSDRefreshHeadView *header;
@property (weak, nonatomic) ZSDRefreshFootView *footer;

@end

@implementation UIScrollView (ZSDRefresh)

#pragma mark - 运行时相关
static char ZSDRefreshHeaderViewKey;
static char ZSDRefreshFooterViewKey;

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

- (void)setFooter:(ZSDRefreshFootView *)footer {
    [self willChangeValueForKey:@"ZSDRefreshFooterViewKey"];
    objc_setAssociatedObject(self, &ZSDRefreshFooterViewKey,
                             footer,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"ZSDRefreshFooterViewKey"];
}

- (ZSDRefreshHeadView *)footer {
    return objc_getAssociatedObject(self, &ZSDRefreshFooterViewKey);
}

/**
 *  添加一个下拉刷新头部控件
 *
 *  @param callback 回调
 */
- (void)addHeadWithCallback:(void (^)())callback
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
- (void)headBeginRefreshing
{
    [self.header beginRefresh];
}

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)headEndRefreshing
{
    [self.header endRefresh];
}

- (BOOL)isHeadRefreshing
{
    return self.header.state == ZSDRefreshStateRefreshing;
}

-(void)addFootWithCallback:(void (^)())callback
{
    // 1.创建新的footer
    if (!self.footer) {
        ZSDRefreshFootView *footer = [ZSDRefreshFootView footer];
        [self addSubview:footer];
        self.footer = footer;
    }
    
    // 2.设置block回调
    self.footer.beginRefreshCallback = callback;
}

-(void)footBeginRefreshing
{
    [self.footer beginRefresh];
}

-(void)footEndRefreshing
{
    [self.footer endRefresh];
}

- (BOOL)isFootRefreshing
{
    return self.footer.state == ZSDRefreshStateRefreshing;
}

@end
