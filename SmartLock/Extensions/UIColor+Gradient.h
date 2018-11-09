//
//  UIColor+Gradient.h
//  IOS-Categories
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Gradient)
//渐变
//size控制方向，
//CGSizeMake(x,1)则渐变方向为横向
//CGSizeMake(1,x)则渐变方向为纵向
//CGSizeMake(x,x)则渐变方向为对角
+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 size:(CGSize)size;


+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;
+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withWidth:(int)width;

@end
