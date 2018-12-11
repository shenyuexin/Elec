//
//  WBDataManager.h
//  SmartLock
//
//  Created by Richard Shen on 2018/10/30.
//  Copyright © 2018 Richard Shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAccountInfo.h"
#import "RUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBDataManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *allUsers;
@property (nonatomic, strong) NSMutableDictionary *loginUsers;


+ (instancetype)sharedManager;
- (RAccountInfo *)loginWithPhone:(NSString *)phone pwd:(NSString *)pwd;

- (void)saveUsers;
- (void)updatePics:(NSArray *)array user:(RUserInfo *)user;
- (NSArray *)picsWithUser:(RUserInfo *)user;
@end

NS_ASSUME_NONNULL_END
