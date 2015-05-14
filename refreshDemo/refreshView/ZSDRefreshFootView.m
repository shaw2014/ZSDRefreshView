//
//  ZSDRefreshFootView.m
//  demo
//
//  Created by shaw on 15/4/11.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import "ZSDRefreshFootView.h"

@interface ZSDRefreshFootView ()

@end

@implementation ZSDRefreshFootView

+(instancetype)footer
{
    return [[ZSDRefreshFootView alloc]init];
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:kContentSizeObserveKey context:nil];
    
    if (newSuperview) { // 新的父控件
        // 监听
        [newSuperview addObserver:self forKeyPath:kContentSizeObserveKey options:NSKeyValueObservingOptionNew context:nil];
        
        // 重新调整frame
        [self adjustFrameWithContentSize];
    }

    // 设置位置和尺寸
    CGRect frect = self.frame;
    frect.size.height = kRefreshFooterHeight;
    self.frame = frect;
}

-(void)adjustFrameWithContentSize
{
    // 内容的高度
    CGFloat contentHeight = self.scrollView.contentSize.height;
    // 表格的高度
    CGFloat scrollHeight = self.scrollView.frame.size.height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom;
    
    CGRect frect = self.frame;
    frect.origin.y = MAX(contentHeight, scrollHeight);
    self.frame = frect;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.arrowCircleView setHidden:YES];
    [self.backgroundImageView setHidden:YES];
    
    self.textLabel.backgroundColor = UIColorFromRGB(0xecedf1);
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.frame = self.bounds;
}

-(void)settingLabelText
{
    switch (self.state)
    {
        case ZSDRefreshStateNormal:
        case ZSDRefreshStatePulling:
            self.textLabel.text = @"上拉加载更多...";
            break;
        case ZSDRefreshStateWillRefreshing:
            self.textLabel.text = @"上拉加载更多...";
            break;
        case ZSDRefreshStateRefreshing:
            self.textLabel.text = @"正在努力加载...";
            break;
        default:
            break;
    }
}

/**
 *  调整状态
 */
- (void)adjustStateWithContentOffset
{
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = 0;
    // 内容的高度
    CGFloat contentHeight = self.scrollView.contentSize.height;
    // 表格的高度
    CGFloat scrollHeight = self.scrollView.frame.size.height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom;
    CGFloat distance = contentHeight - scrollHeight;
    if(distance > 0)
    {
        happenOffsetY = distance - self.scrollViewOriginalInset.top;
    }
    else
    {
        happenOffsetY = -self.scrollViewOriginalInset.top;
    }
    
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.contentOffset.y;
    
    // 如果是向下滚动到看不见头部控件，直接返回
    if (currentOffsetY <= happenOffsetY)
    {
        return;
    }
    
    CGFloat normal2pullingOffsetY = happenOffsetY + self.bounds.size.height;
    if (self.scrollView.isDragging)
    {
        // 普通 和 即将刷新 的临界点
        if (self.state == ZSDRefreshStateNormal && currentOffsetY > happenOffsetY)
        {
            //转为下拉状态
            self.state = ZSDRefreshStatePulling;
        }
        if(currentOffsetY <= normal2pullingOffsetY)
        {
            self.state = ZSDRefreshStatePulling;
        }
        if(self.state == ZSDRefreshStatePulling && currentOffsetY >= normal2pullingOffsetY)
        {
            // 转为即将刷新状态
            self.state = ZSDRefreshStateWillRefreshing;
        }
    }
    else
    {
        if (self.state == ZSDRefreshStatePulling)
        {
            if (currentOffsetY < normal2pullingOffsetY) {
                // 转为普通状态
                self.state = ZSDRefreshStateNormal;
            }
        }
        else if(self.state == ZSDRefreshStateWillRefreshing)
        {
            // 即将刷新 && 手松开
            self.state = ZSDRefreshStateRefreshing;
        }
    }
}

-(void)setState:(ZSDRefreshState)state
{
    if(state == ZSDRefreshStatePulling && self.state == ZSDRefreshStatePulling)
    {
        [super setState:state];
    }
    if(self.state != state)
    {
        ZSDRefreshState oldState = self.state;
        
        [super setState:state];
        
        switch (state) {
            case ZSDRefreshStateNormal:
            {
                if(oldState == ZSDRefreshStateRefreshing)
                {
                    [UIView animateWithDuration:0.3f animations:^{
                        UIEdgeInsets insets = self.scrollView.contentInset;
                        insets.bottom = self.scrollViewOriginalInset.bottom;
                        self.scrollView.contentInset = insets;
                    }];
                }
            }
                break;
            case ZSDRefreshStatePulling:
                break;
            case ZSDRefreshStateRefreshing:
            {
                [UIView animateWithDuration:0.3f animations:^{
                    UIEdgeInsets inset = self.scrollView.contentInset;
                    inset.bottom = self.scrollViewOriginalInset.bottom + self.bounds.size.height;
                    
                    // 内容的高度
                    CGFloat contentHeight = self.scrollView.contentSize.height;
                    // 表格的高度
                    CGFloat scrollHeight = self.scrollView.frame.size.height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom;
                    CGFloat distance = contentHeight - scrollHeight;
                    if(distance < 0)
                    {
                        inset.bottom -= distance;
                    }
                    self.scrollView.contentInset = inset;
                }];
            }
                break;
            default:
                break;
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:kContentSizeObserveKey])
    {
        if(self.state != ZSDRefreshStateRefreshing)
        {
            [self adjustFrameWithContentSize];
        }
    }
    else if ([keyPath isEqualToString:kOffsetObserveKey])
    {
        if(self.state != ZSDRefreshStateRefreshing)
        {
            [self adjustStateWithContentOffset];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
