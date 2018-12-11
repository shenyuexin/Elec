//
//  WBPopView.m
//  Weimai
//
//  Created by Richard Shen on 16/9/19.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#import "WBPopView.h"


@interface WBArrowView : UIView

@end

@implementation WBArrowView

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint   (ctx, 0, self.height);
    CGContextAddLineToPoint(ctx, self.width/2, 3);
    CGContextAddLineToPoint(ctx, self.width, self.height);
    CGContextAddLineToPoint(ctx, 0, self.height);
    CGContextClosePath(ctx);
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    CGContextFillPath(ctx);
}

@end


@interface WBPopView ()

@property (nonatomic, strong) UIView *popView;
@property (nonatomic, strong) UIButton *lastButton;
@property (nonatomic, strong) WBArrowView *arrowView;
@end

static NSInteger kTagButtonSuffix = 99;
@implementation WBPopView

- (instancetype)initWithPopFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if(self){
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
        self.popView.frame = frame;
        self.arrowView.frame = CGRectMake(CGRectGetMidX(frame)-8, frame.origin.y-8, 8, 8);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setTitles:(NSArray<NSString *> *)titles
{
    _titles = titles;
    CGFloat height = self.popView.height /_titles.count;
    [_titles enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, idx*height, self.popView.width, height)];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:HEX_RGB(0x333333) forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        [_popView addSubview:button];
        
        button.tag = kTagButtonSuffix + idx;
        
        if(idx != _titles.count -1){
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, button.bottom+PX1, button.width-20, PX1)];
            lineView.backgroundColor = HEX_RGB(0Xdddddd);
            [_popView addSubview:lineView];
        }
    }];
    
    _selectIndex = 0;
    _selectTitle = _titles.firstObject;
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    
    _lastButton.selected = NO;
    _lastButton = [_popView viewWithTag:selectIndex+kTagButtonSuffix];
    _lastButton.selected = YES;
    
    self.selectTitle = _titles[_selectIndex];
}

#pragma mark - Event
- (void)buttonClick:(UIButton *)sender
{
    NSInteger index = sender.tag - kTagButtonSuffix;
    self.selectIndex = index;
    [self removeFromSuperview];
}

- (void)tapClick:(UIGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateEnded){
        if(recognizer.view != _popView){
            [self removeFromSuperview];
        }
    }
}

#pragma mark - Getter
- (UIView *)popView
{
    if(!_popView){
        _popView = [UIView new];
        _popView.backgroundColor = [UIColor whiteColor];
        _popView.layer.cornerRadius = 3;
        _popView.layer.masksToBounds = YES;
        [self addSubview:_popView];
    }
    return _popView;
}

- (WBArrowView *)arrowView
{
    if(!_arrowView){
        _arrowView = [WBArrowView new];
        _arrowView.backgroundColor = [UIColor clearColor];
        [self addSubview:_arrowView];
    }
    return _arrowView;
}
@end
