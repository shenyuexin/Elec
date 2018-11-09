//
//  RMessageCell.h
//  SmartLock
//
//  Created by Richard Shen on 2018/1/19.
//  Copyright © 2018年 Richard Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUserInfo.h"

FOUNDATION_EXTERN NSString * const RUserCellIdentifier;

@interface RUserCell : UITableViewCell

@property (nonatomic, strong) RUserInfo *user;
@end
