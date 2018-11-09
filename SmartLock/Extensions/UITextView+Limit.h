//
//  UITextView+Limit.h
//  Zhifujia
//
//  Created by Richard Shen on 15/9/5.
//  Copyright (c) 2015年 Chutong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Limit)

//设置UITextView的最大可输入长度
@property (assign, nonatomic) NSUInteger maxLength;
@end
