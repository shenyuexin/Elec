//
//  WBAPIManager.h
//  Weimai
//
//  Created by Richard Shen on 16/1/11.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
//#import <AFNetworking/AFNetworking.h>
//#import "WBAccessToken.h"
#import "RAccountInfo.h"
#import "WBStoreManager.h"

@interface WBAPIManager : NSObject

@property (nonatomic, strong) RAccountInfo *loginUser;
@property (nonatomic, strong) NSString *servicePhoneNum;
@property (nonatomic, strong) NSString *serialNum;
//@property (nonatomic, strong) AFNetworkReachabilityManager *reachManager;

+ (instancetype)sharedManager;

- (void)updateSaveUserInfo;

- (void)startNetworkMonitoring;

+ (BOOL)isLogin;

+ (void)notifyLogin;

- (NSString *)signWithParams:(NSDictionary *)params key:(NSString *)key;

- (NSURLRequest *)requestWithMethod:(NSString *)method
                             params:(NSDictionary *)params
                       uploadImages:(NSArray *)images;

- (RACSignal *)signalWithRequest:(NSURLRequest *)request;

@end

