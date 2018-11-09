//
//  DeviceMacro.h
//  Weimai
//
//  Created by Richard Shen on 16/4/22.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#ifndef DeviceMacro_h
#define DeviceMacro_h

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define WIDTH_SCREEN ([[UIScreen mainScreen] bounds].size.width)
#define HEIGHT_SCREEN ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(WIDTH_SCREEN, HEIGHT_SCREEN))
#define SCREEN_MIN_LENGTH (MIN(WIDTH_SCREEN, HEIGHT_SCREEN))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define RATIO  (WIDTH_SCREEN/375)

#endif /* DeviceMacro_h */
