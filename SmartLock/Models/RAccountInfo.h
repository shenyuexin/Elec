//
//  RAccountInfo.h
//  SmartLock
//
//  Created by Richard Shen on 2018/10/30.
//  Copyright © 2018 Richard Shen. All rights reserved.
//

#import "RBaseInfo.h"

NS_ASSUME_NONNULL_BEGIN


//{"operatorNo":"P00000001","operatorName":"罗玄","mobile":"13906523619","password":"1111"}
@interface RAccountInfo : RBaseInfo

@property (nonatomic, strong) NSString *operatorNo;
@property (nonatomic, strong) NSString *operatorName;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *password;

@end

NS_ASSUME_NONNULL_END
