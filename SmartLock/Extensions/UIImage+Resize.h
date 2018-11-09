//
//  UIImage+Resize.h
//  Weimai
//
//  Created by Richard Shen on 16/4/24.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage *)fillSize:(CGSize)size;

- (UIImage *)maxSize:(CGSize)size;

/** 400x400 */
- (UIImage *)thumImage;
@end
