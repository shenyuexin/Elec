//
//  RBaseViewController.h
//  SmartLock
//
//  Created by Richard Shen on 2018/1/9.
//  Copyright © 2018年 Richard Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBMediator.h"

@interface RBaseViewController : UIViewController

@property (nonatomic, strong) UIButton *backButton;

- (void)backClick;
@end
