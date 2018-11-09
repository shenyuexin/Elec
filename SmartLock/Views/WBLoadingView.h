//
//  WBLoadingView.h
//  NewMai
//
//  Created by Richard Shen on 15/11/6.
//  Copyright © 2015年 sina. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WBLoadBgMode)
{
    WBLoadBgDefault,
    WBLoadBgSuccess,
};

@interface WBLoadingView : UIView

+ (void)showErrorStatus:(NSString *)status;

+ (void)showSuccessStatus:(NSString *)status;

+ (void)showStatus:(NSString *)status image:(UIImage *)image autoDismiss:(BOOL)dismiss;

+ (void)showLoading;

+ (void)showLoadingWithString:(NSString *)status;

+ (void)dismiss;
@end
