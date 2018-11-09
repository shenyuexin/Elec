//
//  APPMacro.h
//  Weimai
//
//  Created by Richard Shen on 16/1/7.
//  Copyright © 2016年 Richard. All rights reserved.
//

#ifndef APPMacro_h
#define APPMacro_h

#define URL_DOMAIN                      @"http://lockapi.veritrans.cn:5555/customer"
#define URL_API(API)                    [NSString stringWithFormat:@"%@%@",URL_DOMAIN,API]
#define APP_KEY                         @"x-ios-customer lU9ZCkpxiL9PW86QevPXhs"

#define COLOR_BAR                       HEX_RGB(0x3684b5)

#define SCREEN_HEIGHT                   [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH                    [UIScreen mainScreen].bounds.size.width
#define SCREEN_BOUNDS                   [UIScreen mainScreen].bounds

#define kTimeoutInterval                10

#define kDefaultPageNum                 10
#define kDefaultPageMinNum              10

#define PX1                             (1.0/[UIScreen mainScreen].scale)
#define PX1_OFFSET                      ((1.0/[UIScreen mainScreen].scale) / 2)

#define kENLARGE_SCALE                  MAX(1, [UIScreen mainScreen].scale/2)
#define kScreenScale                    [UIScreen mainScreen].scale

#define DEGREES_TO_RADIANS(x)           ((x)/180.0*M_PI)

#define __IPHONEX_                      ([[UIScreen mainScreen] bounds].size.height == 812)
#define __IOS11_                        ([UIDevice currentDevice].systemVersion.floatValue >= 11)

#define __POSY_IPHONEX_                 (__IPHONEX_?24:0)

#define kSaveToken                      @"kSaveToken"
#define kSaveUser                       @"kSaveUser"
#define kNotificationInvalidToken       @"kNotificationInvalidToken"
#define kNotificationPicsUpdate         @"kNotificationPicsUpdate"
#define kNotificationReportFinish       @"kNotificationReportFinish"

#endif /* APPMacro_h */

