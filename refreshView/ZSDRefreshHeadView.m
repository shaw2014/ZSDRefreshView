//
//  ZSDRefreshHeadView.m
//  demo
//
//  Created by zhaoxiao on 15/2/28.
//  Copyright (c) 2015年 zhaoxiao. All rights reserved.
//

#import "ZSDRefreshHeadView.h"

@implementation ZSDRefreshHeadView

+(instancetype)header
{
    return [[ZSDRefreshHeadView alloc]init];
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    CGRect frect = self.frame;
    frect.origin.y = -frect.size.height;
    self.frame = frect;
}

/**
 *  调整状态
 */
- (void)adjustStateWithContentOffset
{
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.contentOffset.y;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = -self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    if (currentOffsetY >= happenOffsetY)
    {
        return;
    }
    
    CGFloat normal2pullingOffsetY = happenOffsetY - self.bounds.size.height;
    if (self.scrollView.isDragging)
    {
        // 普通 和 即将刷新 的临界点
        if (self.state == ZSDRefreshStateNormal && currentOffsetY < happenOffsetY)
        {
            //转为下拉状态
            self.state = ZSDRefreshStatePulling;
        }
        if(currentOffsetY > normal2pullingOffsetY)
        {
            self.state = ZSDRefreshStatePulling;
        }
        if(self.state == ZSDRefreshStatePulling && currentOffsetY < normal2pullingOffsetY)
        {
            // 转为即将刷新状态
            self.state = ZSDRefreshStateWillRefreshing;
        }
    }
    else
    {
        if (self.state == ZSDRefreshStatePulling)
        {
            if (currentOffsetY >= normal2pullingOffsetY) {
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:kOffsetObserveKey])
    {
        if(self.state != ZSDRefreshStateRefreshing)
        {
            [self adjustStateWithContentOffset];
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
                        self.scrollView.contentInset = UIEdgeInsetsZero;
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
                    inset.top = self.scrollViewOriginalInset.top + self.bounds.size.height;
                    self.scrollView.contentInset = inset;
                    
                    CGPoint offset = self.scrollView.contentOffset;
                    offset.y = -inset.top;
                    self.scrollView.contentOffset = offset;
                }];
            }
                break;
            default:
                break;
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
