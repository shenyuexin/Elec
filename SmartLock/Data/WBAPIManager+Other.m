//
//  WBAPIManager+Other.m
//  Weimai
//
//  Created by Richard Shen on 16/2/3.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#import "WBAPIManager+Other.h"
#import "AppUtil.h"

@implementation WBAPIManager (Other)

+ (RACSignal *)uploadImage:(UIImage *)image
{
    WBAPIManager *manager = [self sharedManager];
    NSURLRequest *request = [manager requestWithMethod:@"/tool/pic/upload" params:nil uploadImage:@{@"img":image}];
    return [[manager signalWithRequest:request] map:^id(NSDictionary *data) {
        return data[@"pic"];
    }];
}

+ (RACSignal *)uploadIMImage:(UIImage *)image
{
    WBAPIManager *manager = [self sharedManager];
    NSURLRequest *request = [manager requestWithMethod:@"/client/others/upload" params:nil uploadImage:@{@"img":image}];
    return [[manager signalWithRequest:request] map:^id(NSString *url) {
        return url;
    }];
}


+ (RACSignal *)feedback:(NSString *)content type:(NSInteger)type imgUrls:(NSArray *)urls
{
    WBAPIManager *manager = [self sharedManager];
    
    NSMutableDictionary *params = @{@"version":currentVersionString(),
                                    @"device_version":[AppUtil deviceModelName],
                                    @"os_version":[UIDevice currentDevice].systemVersion,
                                    @"text":content,
                                    @"others_question":@(type)}.mutableCopy;
    if(urls.count > 0){
        NSString *imgString = [urls componentsJoinedByString:@"|"];
        [params setObject:imgString forKey:@"img_path"];
    }
    
    NSURLRequest *request = [manager requestWithMethod:@"/client/others/fankui" params:params uploadImage:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)getDispathInfo:(NSString *)pid
{
    WBAPIManager *manager = [self sharedManager];
    
    NSDictionary *params = @{@"iid":pid, @"device":@(2)};
    
    NSURLRequest *request = [manager requestWithMethod:@"/product/dispatcher" params:params uploadImage:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)reportType:(NSInteger)type
                   feedID:(NSString *)feedid
                 feedType:(NSInteger)feedtype
                  feedUid:(NSString *)feeduid
{
    WBAPIManager *manager = [self sharedManager];
    
    NSDictionary *params = @{@"type":@(type),
                             @"feed_id":feedid,
                             @"feed_type":@(feedtype),
                             @"to_user_id":feeduid};
    
    NSURLRequest *request = [manager requestWithMethod:@"/proxy/op/interface/api/report/report" params:params uploadImage:nil];
    return [manager signalWithRequest:request];

}

+ (RACSignal *)shareRewards:(NSString *)uid
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{};
    NSURLRequest *request = [manager requestWithMethod:@"/proxy/op/interface/api/userprize/share" params:params uploadImage:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)getActivitys
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{};
    NSURLRequest *request = [manager requestWithMethod:@"/recommend/activity/info" params:params uploadImage:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)getActivityDetail:(NSUInteger)actId
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"activity_id":@(actId)};
    NSURLRequest *request = [manager requestWithMethod:@"/proxy/op/interface/api/activity/activitydetail" params:params uploadImage:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)getTopicDetail:(NSUInteger)topicId
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"topic_id":@(topicId)};
    NSURLRequest *request = [manager requestWithMethod:@"/proxy/op/interface/api/topic/detail" params:params uploadImage:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)bindDeviceToken:(NSString *)deviceToken uid:(NSString *)uid
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"clientID":deviceToken,@"currentUserID":uid};
    NSURLRequest *request = [manager requestWithMethod:@"/proxy/op/interface/api/push/switchuser" params:params uploadImage:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)registerDeviceToken:(NSString *)deviceToken uid:(NSString *)uid
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"client_id":deviceToken,
                             @"uid":uid,
                             @"type":@(1)};
    NSURLRequest *request = [manager requestWithMethod:@"/client/push/updateclient" params:params uploadImage:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)countShareFeed:(NSString*)feedid type:(NSInteger)type
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"iid":feedid,
                             @"type":@(type)};
    NSURLRequest *request = [manager requestWithMethod:@"/product/share" params:params uploadImage:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)getHotFixJscript
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"version":currentVersionString(),
                             @"type":@"1"};
    NSURLRequest *request = [manager requestWithMethod:@"/client/hotfix/check" params:params uploadImage:nil];
    return [[manager signalWithRequest:request] map:^id(NSDictionary *data) {
        if(data.allValues.count >0 && [data[@"is_update"] boolValue]){
            NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:data];
            [param removeObjectForKey:@"code"];
            NSString *code = [manager signWithParams:param key:@"6dea270f433a2258d6bj"];
            if([code isEqualToString:data[@"code"]]){
                return data[@"content"];
            }
        }
        return nil;
    }];

}

+ (RACSignal *)uploadCrashLog:(NSString *)log
                    phoneType:(NSString *)phoneType
                      phoneOS:(NSString *)phoneos
                  networkType:(NSString *)networkType
                      version:(NSString *)version
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"string_crash":log,
                             @"platform":@"iOS",
                             @"phone_type":phoneType,
                             @"phone_os":phoneos,
                             @"phone_network":networkType,
                             @"version":networkType,
                             };
    NSURLRequest *request = [manager requestWithMethod:@"/client/others/crash" params:params uploadImage:nil];
    return [manager signalWithRequest:request];
}
@end
