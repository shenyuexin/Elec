//
//  UIImage+Resize.m
//  Weimai
//
//  Created by Richard Shen on 16/4/24.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)


- (UIImage *)fillSize:(CGSize)size
{
    CGSize imageSize = self.size;
    
    CGFloat scalex = size.width / imageSize.width;
    CGFloat scaley = size.height / imageSize.height;
    CGFloat scale = MAX(scalex, scaley);

    CGFloat width = imageSize.width * scale;
    CGFloat height = imageSize.height * scale;
    
    float dwidth = ((size.width - width) / 2.0f);
    float dheight = ((size.height - height) / 2.0f);
    
    CGRect rect = CGRectMake(dwidth, dheight, imageSize.width * scale, imageSize.height * scale);

    UIGraphicsBeginImageContext(size);
    [self drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

- (UIImage *)maxSize:(CGSize)size
{
    if(self.size.width < size.width && self.size.height < size.height){
        return self;
    }
    return [self fillSize:size];
}

- (UIImage *)thumImage
{
    return [self maxSize:CGSizeMake(200, 200)];
}
@end
