//
//  UIImage+QRCode.h
//  Weimai
//
//  Created by Richard Shen on 16/9/21.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QRCode)

+ (UIImage *)QRCodeFromString:(NSString *)code size:(CGFloat)size;
@end
