//
//  ZSDRefreshBaseView.m
//  demo
//
//  Created by zhaoxiao on 15/2/28.
//  Copyright (c) 2015年 zhaoxiao. All rights reserved.
//

#import "ZSDRefreshBaseView.h"
#import "ZSDRefreshCircleView.h"

#define kArrowSize CGSizeMake(22.0f,22.0f)

@interface ZSDRefreshBaseView ()

@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,strong) ZSDRefreshCircleView *arrowCircleView;
@property (nonatomic,strong) UILabel *textLabel;

@end

@implementation ZSDRefreshBaseView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        frame.size.width = [UIScreen mainScreen].bounds.size.width;
        frame.size.height = kRefreshViewHeight;
        self.frame = frame;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self setup];
        
        self.state = ZSDRefreshStateNormal;
    }
    
    return self;
}

-(void)setup
{
    if(!_backgroundImageView)
    {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kRefreshViewHeight)];
        _backgroundImageView.image = [UIImage imageNamed:@"refreshBG"];
        [self addSubview:_backgroundImageView];
    }
    
    if(!_arrowCircleView)
    {
        _arrowCircleView = [[ZSDRefreshCircleView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - 80.0f, 50.0f, kArrowSize.width, kArrowSize.height)];
        _arrowCircleView.image = [UIImage imageNamed:@"arrow"];
        [self addSubview:_arrowCircleView];
    }
    
    if(!_textLabel)
    {
        _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_arrowCircleView.frame) + 13.0f, CGRectGetMinY(_arrowCircleView.frame), 150.0f, kArrowSize.height)];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont systemFontOfSize:17.0f];
        _textLabel.textColor = [UIColor grayColor];
        [self addSubview:_textLabel];
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:kOffsetObserveKey context:nil];
    
    if (newSuperview) { // 新的父控件
        [newSuperview addObserver:self forKeyPath:kOffsetObserveKey options:NSKeyValueObservingOptionNew context:nil];
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        _scrollViewOriginalInset = _scrollView.contentInset;
    }
}

- (void)settingLabelText
{
    // 设置文字
    switch (self.state) {
        case ZSDRefreshStateNormal:
        case ZSDRefreshStatePulling:
            self.textLabel.text = @"下拉刷新...";
            break;
        case ZSDRefreshStateWillRefreshing:
            self.textLabel.text = @"释放即可刷新...";
            break;
        case ZSDRefreshStateRefreshing:
            self.textLabel.text = @"正在努力加载...";
            break;
        default:
            break;
    }
}

-(void)setState:(ZSDRefreshState)state
{
    if(_scrollView.isDragging && state == ZSDRefreshStatePulling)
    {
        CGFloat offset = _scrollView.contentOffset.y - _scrollViewOriginalInset.top;
        _arrowCircleView.progress = MIN(-offset / kRefreshViewHeight, 1);
        [_arrowCircleView setNeedsDisplay];
    }
    
    if(_state != state)
    {
        //存储当前的contentInset
        if (_state != ZSDRefreshStateRefreshing) {
            _scrollViewOriginalInset = self.scrollView.contentInset;
        }
        
        switch (state) {
            case ZSDRefreshStateNormal:
            {
                _arrowCircleView.progress = 0;
                [_arrowCircleView setNeedsDisplay];
                
                [_arrowCircleView stopAnimation];
            }
                break;
            case ZSDRefreshStatePulling:
            {
                
            }
                break;
            case ZSDRefreshStateRefreshing:
            {
                _arrowCircleView.progress = 1;
                [_arrowCircleView setNeedsDisplay];
                
                [_arrowCircleView startAnimation];
                
                if(_beginRefreshCallback)
                {
                    _beginRefreshCallback();
                }
            }
                break;
            case ZSDRefreshStateWillRefreshing:
                break;
            default:
                break;
        }
        
        _state = state;
        
        [self settingLabelText];
    }
}

#pragma mark 开始刷新
- (void)beginRefresh
{
    if (self.state == ZSDRefreshStateRefreshing) {
        if (_beginRefreshCallback) {
            _beginRefreshCallback();
        }
    } else {
        if (self.window) {
            self.state = ZSDRefreshStateRefreshing;
        }
    }
}

#pragma mark 结束刷新
- (void)endRefresh
{
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.state = ZSDRefreshStateNormal;
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
