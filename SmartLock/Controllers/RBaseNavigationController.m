//
//  RBaseNavigationController.m
//  SmartLock
//
//  Created by Richard Shen on 2018/1/9.
//  Copyright © 2018年 Richard Shen. All rights reserved.
//

#import "RBaseNavigationController.h"

@interface RBaseNavigationController ()

@end

@implementation RBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationBar.tintColor = COLOR_BAR;
    self.navigationBar.barTintColor = COLOR_BAR;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                               NSFontAttributeName:[UIFont systemFontOfSize:17]};
    [self.navigationBar setBackgroundImage:[UIImage new]
                            forBarPosition:UIBarPositionAny
                                barMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
//    self.navigationBar.clipsToBounds = YES;
    self.navigationBar.translucent = NO;
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateHighlighted];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
