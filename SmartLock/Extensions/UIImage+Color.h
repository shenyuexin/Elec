//
//  UIImage+Color.h
//  Weimai
//
//  Created by Richard Shen on 16/1/26.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (instancetype)imageWithColor:(UIColor *)color;

+ (instancetype)imageWithColor:(UIColor *)color withSize:(CGSize)size;

- (UIImage *)cornerImageWithRadius:(float)radius;
@end
