//
//  UIView+Loading.m
//  Weimai
//
//  Created by Richard Shen on 16/2/3.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "UIView+Loading.h"
#import <objc/runtime.h>

@implementation UIView (Loading)

static char indicatorViewKey;

- (UIActivityIndicatorView *)indicatorView
{
    return objc_getAssociatedObject(self, &indicatorViewKey);
}

- (void)setIndicatorView:(UIActivityIndicatorView *)indicatorView
{
    objc_setAssociatedObject(self, &indicatorViewKey, indicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)startLoading
{
    [self startLoadingWithStyle:UIActivityIndicatorViewStyleWhite];
}

- (void)startLoadingWithStyle:(UIActivityIndicatorViewStyle)style
{
    if(!self.indicatorView){
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        self.indicatorView.center = CGPointMake(self.width/2, self.height/2);
        [self addSubview:self.indicatorView];
        
        [self setIndicatorView:self.indicatorView];
    }
    [self.indicatorView startAnimating];
}

- (void)stopLoading
{
    [self.indicatorView stopAnimating];
    [self.indicatorView removeFromSuperview];
    self.indicatorView = nil;
}
@end
