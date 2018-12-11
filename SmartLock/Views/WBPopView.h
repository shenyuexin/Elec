//
//  WBPopView.h
//  Weimai
//
//  Created by Richard Shen on 16/9/19.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBPopView : UIView

@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSString *selectTitle;

- (instancetype)initWithPopFrame:(CGRect)frame;
@end
