//
//  UIImage+QRCode.m
//  Weimai
//
//  Created by Richard Shen on 16/9/21.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "UIImage+QRCode.h"

@implementation UIImage (QRCode)

+ (UIImage *)QRCodeFromString:(NSString *)code size:(CGFloat)size{
    //创建CIFilter 指定filter的名称为CIQRCodeGenerator
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //指定二维码的inputMessage,即你要生成二维码的字符串
    [filter setValue:[code dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    //输出CIImage
    CIImage *ciImage = [filter outputImage];
    //对CIImage进行处理
    return [self createfNonInterpolatedImageFromCIImage:ciImage withSize:size];
}

+ (UIImage *) createfNonInterpolatedImageFromCIImage:(CIImage *)iamge withSize:(CGFloat)size{
    CGRect extent = iamge.extent;
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t with = scale * CGRectGetWidth(extent);
    size_t height = scale * CGRectGetHeight(extent);
    
    UIGraphicsBeginImageContext(CGSizeMake(with, height));
    CGContextRef bitmapContextRef = UIGraphicsGetCurrentContext();
    
    CIContext *context = [CIContext contextWithOptions:nil];
    //通过CIContext 将CIImage生成CGImageRef
    CGImageRef bitmapImage = [context createCGImage:iamge fromRect:extent];
    //在对二维码放大或缩小处理时,禁止插值
    CGContextSetInterpolationQuality(bitmapContextRef, kCGInterpolationNone);
    //对二维码进行缩放
    CGContextScaleCTM(bitmapContextRef, scale, scale);
    //将二维码绘制到图片上下文
    CGContextDrawImage(bitmapContextRef, extent, bitmapImage);
    //获得上下文中二维码
    UIImage *retVal =  UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(bitmapImage);
//    CGContextRelease(bitmapContextRef);
    
    // Rotate the image旋转图像
    UIImage *qrImage = [UIImage imageWithCGImage:[retVal CGImage] scale:[retVal scale] orientation:UIImageOrientationDownMirrored];
    return qrImage;
}
@end
