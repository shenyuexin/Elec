//
//  UIView+Loading.h
//  Weimai
//
//  Created by Richard Shen on 16/2/3.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Loading)

- (void)startLoading;
- (void)startLoadingWithStyle:(UIActivityIndicatorViewStyle)style;

- (void)stopLoading;
@end
