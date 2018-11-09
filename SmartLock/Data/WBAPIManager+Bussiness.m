//
//  WBAPIManager+Bussiness.m
//  Weimai
//
//  Created by Richard Shen on 16/1/14.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#import "WBAPIManager+Bussiness.h"
#import "RMessageInfo.h"
#import "RUtils.h"
#import "RRecordInfo.h"

@implementation WBAPIManager (Bussiness)

+ (RACSignal *)getSmsCode:(NSString *)phone
{
    WBAPIManager *manager = [self sharedManager];
    NSString *method = [NSString stringWithFormat:@"/sms/sendLoginSmsCode/%@",phone];
    NSURLRequest *request = [manager requestWithMethod:method params:nil uploadImages:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)loginWithPhone:(NSString *)phone code:(NSString *)code
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"mobile":phone,
                             @"code":code,
                             @"model":[RUtils deviceModelName],
                             @"version":[RUtils deviceVersion],
                             @"resolutionRatio":[RUtils deviceScreenSize],
                             @"remarks":@""
                             };
    NSURLRequest *request = [manager requestWithMethod:@"/member/login" params:params uploadImages:nil];
    return [[manager signalWithRequest:request] map:^id(NSDictionary *data) {
        RPersonInfo *person = [RPersonInfo mj_objectWithKeyValues:data];
        manager.loginUser = person;
        return person;
    }];
}


+ (RACSignal *)getHomeData
{
    WBAPIManager *manager = [self sharedManager];
    NSURLRequest *request = [manager requestWithMethod:@"/home" params:nil uploadImages:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)getServicePhoneNum
{
    WBAPIManager *manager = [self sharedManager];
    NSURLRequest *request = [manager requestWithMethod:@"/tel" params:nil uploadImages:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)reportBug:(NSString *)reason serialNum:(NSString *)serialNum
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"content":reason, @"serialNo":serialNum};
    NSURLRequest *request = [manager requestWithMethod:@"/declare" params:params uploadImages:nil];
    return [manager signalWithRequest:request];
}


+ (RACSignal *)getLockRecords:(NSString *)serialNum
                      keyWord:(NSString *)keyword
                    beginDate:(NSString *)begin
                      endDate:(NSString *)end
                         page:(NSInteger)page
{
    WBAPIManager *manager = [self sharedManager];
    NSMutableDictionary *params = @{@"serialNo":serialNum,
                                    @"offset":@(page*kDefaultPageNum),
                                    @"limit":@(kDefaultPageNum)}.mutableCopy;
    [params setObject:manager.loginUser.pid forKey:@"memberId"];
    
    if(keyword.isNotEmpty){
        [params setObject:keyword forKey:@"param"];
    }
    if(begin.isNotEmpty && end.isNotEmpty){
        [params setObject:begin forKey:@"startUnlockTime"];
        [params setObject:end forKey:@"endUnlockTime"];
    }
    NSURLRequest *request = [manager requestWithMethod:@"/unlockrecord/search" params:params uploadImages:nil];
    return [[manager signalWithRequest:request] map:^id(NSDictionary *data) {
        NSArray *array = [RRecordInfo mj_objectArrayWithKeyValuesArray:data[@"rows"]];
        return array;
    }];
}

+ (RACSignal *)getMessagesWithPage:(NSInteger)page
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"offset":@(page*kDefaultPageNum),
                             @"limit":@(kDefaultPageNum)};
    NSURLRequest *request = [manager requestWithMethod:@"/notice/search" params:params uploadImages:nil];
    return [[manager signalWithRequest:request] map:^id(NSDictionary *data) {
        NSArray *array = [RMessageInfo mj_objectArrayWithKeyValuesArray:data[@"rows"]];
        return array;
    }];
}

+ (RACSignal *)modifyPassword:(NSString *)password serialNum:(NSString *)serialNum
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"pinCode":password, @"serialNo":serialNum};
    NSURLRequest *request = [manager requestWithMethod:@"/changeInfo" params:params uploadImages:nil];
    return [manager signalWithRequest:request];
}

@end
