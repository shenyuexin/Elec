//
//  UIView+BorderLine.h
//  Weimai
//
//  Created by Richard Shen on 2017/6/15.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, BorderType) {
    BorderLeft     = 1 << 0,
    BorderRight    = 1 << 1,
    BorderTop      = 1 << 2,
    BorderBottom   = 1 << 3,
};

@interface UIView (BorderLine)

- (void)addBorderLine:(BorderType)type;
- (void)addBorderLine:(BorderType)type withHeight:(CGFloat)height;
- (void)addBorderLine:(BorderType)type withWidth:(CGFloat)width;
- (void)removeBorderLine:(BorderType)type;

- (void)setLineColor:(UIColor *)color;
@end
