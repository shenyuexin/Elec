//
//  UIView+ScaleAnimation.m
//  Weimai
//
//  Created by Richard Shen on 16/4/9.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "UIView+ScaleAnimation.h"

@implementation UIView (ScaleAnimation)

- (void)doScaleAnimate
{
    [self doScaleAnimateWithScale:0.1];
}

- (void)doScaleAnimateWithScale:(CGFloat)scale
{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.3;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1+scale, 1+scale, 1.0)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1-scale, 1-scale, 1.0)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self.layer addAnimation:popAnimation forKey:nil];
}
@end
