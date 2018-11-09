//
//  RReportView.h
//  SmartLock
//
//  Created by Richard Shen on 2018/10/31.
//  Copyright © 2018 Richard Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface RReportView : UIView

@property (nonatomic, strong) RUserInfo *user;

- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
