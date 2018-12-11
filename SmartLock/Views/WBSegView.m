//
//  WBSegView.m
//  Weimai
//
//  Created by Richard Shen on 16/4/10.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#import "WBSegView.h"

@interface  WBSegView ()

@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UIButton *lastSelectButton;
@end

static NSUInteger ktagSuffix = 99;

@implementation WBSegView

- (void)setItmes:(NSArray<NSString *> *)itmes
{
    if(_itmes == itmes){
        return;
    }
    
    _itmes = itmes;
    
    [self removeAllSubviews];
    [self addSubview:self.selectView];
    
    NSUInteger width = ceil(self.width/itmes.count);
    [_itmes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(idx*width, 0, width, self.height)];
        btn.tag = idx + ktagSuffix;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:obj forState:UIControlStateNormal];
        
        [btn setTitleColor:HEX_RGB(0X999999) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:btn];
        [btn layoutIfNeeded];
        
        if(idx == 0){
            [self buttonClick:btn];
        }
    }];
}

- (void)setSelectIndex:(NSInteger)index
{
    UIButton *sender = [self viewWithTag:index+ktagSuffix];
    if(_lastSelectButton == sender){
        return;
    }
    _selectedIndex = index;

    if (!_selectColor) {
        [sender setTitleColor:RGB(0xff, 0x76, 0x53) forState:UIControlStateNormal];
    }else
    {
        [sender setTitleColor:_selectColor forState:UIControlStateNormal];
        
    }

    [_lastSelectButton setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
    
    _lastSelectButton = sender;
    
    [self bringSubviewToFront:self.selectView];
    [UIView animateWithDuration:0.2 animations:^{
        if (_isFavMode) {
            self.selectView.frame = CGRectMake(sender.left , self.height-1, sender.width, 1);
        }else{
           self.selectView.frame = CGRectMake(sender.left + sender.titleLabel.left - 10, self.height-2, sender.titleLabel.width+20, 2); 
        }
    }];
}

- (void)buttonClick:(UIButton *)sender
{
    if(_lastSelectButton == sender){
        return;
    }
    _selectedIndex = sender.tag - ktagSuffix;
    
    if(self.delegate){
        [self.delegate segView:self selectIndex:sender.tag-ktagSuffix];
    }
    [self setSelectIndex:sender.tag - ktagSuffix];
}

#pragma mark Getter
- (UIView *)selectView
{
    if(!_selectView){
        _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-2, 30, 2)];
        if (!_selectColor) {
           _selectView.backgroundColor = RGB(0xff, 0x76, 0x53);
        }
        else{
            _selectView.backgroundColor = _selectColor;
        }
        [self addSubview:_selectView];
    }
    return _selectView;
}
@end
