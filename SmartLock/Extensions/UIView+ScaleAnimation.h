//
//  UIView+ScaleAnimation.h
//  Weimai
//
//  Created by Richard Shen on 16/4/9.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ScaleAnimation)

- (void)doScaleAnimate;

//0.1  -> 1.1,  0.9,  1.0
//0.01 -> 1.01, 0.99, 1.0
- (void)doScaleAnimateWithScale:(CGFloat)scale;
@end
