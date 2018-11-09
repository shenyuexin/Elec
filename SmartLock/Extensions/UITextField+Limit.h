//
//  UITextField+Limit.h
//  BlockDemo
//
//  Created by Richard Shen on 15/9/5.
//  Copyright (c) 2015年 Richard Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Limit)

//设置UITextField的最大可输入长度
@property (nonatomic, assign) NSUInteger maxLength;
@end
