//
//  RDetailViewController.h
//  SmartLock
//
//  Created by Richard Shen on 2018/10/31.
//  Copyright © 2018 Richard Shen. All rights reserved.
//

#import "RBaseViewController.h"
#import "RUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface RDetailViewController : RBaseViewController

@property (nonatomic, strong) RUserInfo *user;
@end

NS_ASSUME_NONNULL_END
