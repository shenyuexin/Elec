//
//  WBAPIUserManger.m
//  Weimai
//
//  Created by Richard Shen on 16/1/12.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#import "WBAPIManager+User.h"
#import "NSString+BeeExtension.h"
#import "WBWeiboManager.h"
#import "WBWeixinManager.h"
#import "WBAddress.h"
//#import "WBTaobaoManager.h"
#import "WBQQManager.h"
#import "WBChartUserInfo.h"
#import "NSDate+BeeExtension.h"

@implementation WBAPIManager (User)

+ (RACSignal *)loginMobilenum:(NSString *)mobilenum
                     password:(NSString *)password
{
    WBAPIManager *manager = [self sharedManager];
    manager.accessToken = nil;
    
    NSDictionary *params = @{@"mobilenum":mobilenum,
                             @"password":password};

    NSURLRequest *request = [manager requestWithMethod:@"/client/sso/verifynew" params:params uploadImage:nil];
    return [[[manager signalWithRequest:request] map:^id(NSDictionary *data) {
        WBAccessToken *token = [WBAccessToken mj_objectWithKeyValues:data];
        manager.accessToken = token;
        return token?@(YES):@(NO);
    }] catch:^RACSignal *(NSError *error) {
        switch (error.code) {
            case 10001:
                return [RACSignal error:[NSError errorWithDomain:@"手机未注册，请先注册" code:error.code userInfo:nil]];
            case 10002:
                return [RACSignal error:[NSError errorWithDomain:@"密码错误，请重试" code:error.code userInfo:nil]];
            default:
                return [RACSignal error:error];;
        }
        
    }];
}

+ (RACSignal *)loginWithAccesstoken:(WBAccessToken *)accesstoken
{
    WBAPIManager *manager = [self sharedManager];
    manager.accessToken = nil;

    NSDictionary *params = nil;
    NSString *method = @"/client/sso/weibo/verify";
    params = @{@"uid":accesstoken.uid,
               @"wbtoken":accesstoken.token};
    
    NSURLRequest *request = [manager requestWithMethod:method params:params uploadImage:nil];
    
    return [[manager signalWithRequest:request] map:^id(NSDictionary *data) {
        WBAccessToken *token = [WBAccessToken mj_objectWithKeyValues:data];
        if(token.uid.isNotEmpty && token.token.isNotEmpty)
        {
            manager.accessToken = token;
            return token;
        }
        else{
            return nil;
        }
    }];
}

+ (RACSignal *)registerMobilenum:(NSString *)mobilenum
                        password:(NSString *)password
                        passcode:(NSString *)passcode
{
    WBAPIManager *manager = [self sharedManager];
    manager.accessToken = nil;

    NSMutableDictionary *params = [@{@"mobilenum":mobilenum,
                                     @"password":password,
                                     @"passcode":passcode,} mutableCopy];
    
    NSURLRequest *request = [manager requestWithMethod:@"/client/sso/registernew" params:params uploadImage:nil];
    return [[manager signalWithRequest:request] map:^id(NSDictionary *data) {
        WBAccessToken *token = [WBAccessToken mj_objectWithKeyValues:data];
        manager.accessToken = token;
        return token?@(YES):@(NO);
    }];
}

+ (RACSignal *)registerThirdToken:(WBAccessToken *)token
                        mobilenum:(NSString *)mobilenum
                        password:(NSString *)password
                        passcode:(NSString *)passcode
                        nickName:(NSString *)name
{
    WBAPIManager *manager = [self sharedManager];
    manager.accessToken = nil;
    
    NSMutableDictionary *params = [@{@"mobilenum":mobilenum,
                                     @"password":password,
                                     @"passcode":passcode} mutableCopy];
    NSString *method = @"/client/sso/weibo/register";
    [params setObject:token.uid forKey:@"uid"];
    [params setObject:token.token forKey:@"wbtoken"];
    if([name isNotEmpty]){
        [params setObject:name forKey:@"nick"];
    }
    
    NSURLRequest *request = [manager requestWithMethod:method params:params uploadImage:nil];
    return [[manager signalWithRequest:request] map:^id(NSDictionary *data) {
        WBAccessToken *token = [WBAccessToken mj_objectWithKeyValues:data];
        manager.accessToken = token;
        return token?@(YES):@(NO);
    }];
}

+ (RACSignal *)bindOpenID:(NSString *)weiboid token:(NSString *)token type:(NSUInteger)type
{
    WBAPIManager *manager = [self sharedManager];
    
    NSDictionary *params = nil;
    NSString *method = nil;
    switch (type) {
        case 0:{
            method = @"/user/weibo/bind";
            params = @{@"weibo_id":weiboid,
                       @"token":token};
            break;
        }
        case 1:{
            method = @"/user/weixin/bind";
            params = @{@"open_id":weiboid,
                       @"weixin_token":token};
            break;
        }
        case 2:{
            method = @"/user/taobao/bind";
            params = @{@"taobao_id":weiboid,
                       @"taobao_token":token};
            break;
        }
        case 3:{
            method = @"/user/qq/bind";
            params = @{@"open_id":weiboid,
                       @"qq_token":token};
            break;
        }
    }
    
    NSURLRequest *request = [manager requestWithMethod:method params:params uploadImage:nil];
    return [[manager signalWithRequest:request] map:^id(NSDictionary *data) {
        if(data[@"token"]){
            manager.accessToken.token = data[@"token"];
        }
        return data;
    }];
}

+ (RACSignal *)cancelBindWithType:(NSUInteger)type
{
    WBAPIManager *manager = [self sharedManager];
    NSString *method = nil;
    switch (type) {
        case 0:{
            method = @"/user/weibo/unbind";
            break;
        }
        case 1:{
            method = @"/user/weixin/unbind";
            break;
        }
        case 2:{
            method = @"/user/taobao/unbind";
            break;
        }
        case 3:{
            method = @"/user/qq/unbind";
            break;
        }
    }
    NSURLRequest *request = [manager requestWithMethod:method params:nil uploadImage:nil];
    return [[manager signalWithRequest:request] map:^id(NSDictionary *data) {
        if(data[@"token"]){
            manager.accessToken.token = data[@"token"];
        }
        return data;
    }];
}

+ (RACSignal *)getUserInfo
{
    WBAPIManager *manager = [self sharedManager];
    NSURLRequest *request = [manager requestWithMethod:@"/client/others/user" params:nil uploadImage:nil];
    return [[manager signalWithRequest:request] map:^id(NSDictionary *data) {
        WBUserInfo *user = [WBUserInfo mj_objectWithKeyValues:data];
        //更新用户信息
        manager.accessToken.nick = user.nickname;
        manager.loginUser = user;
                
        return user;
    }];
}

+ (RACSignal *)getUserInfoWithUid:(NSString *)uid
{
    WBAPIManager *manager = [self sharedManager];
    NSURLRequest *request = [manager requestWithMethod:@"/client/user/info" params:@{@"uid":uid?:@""} uploadImage:nil];
    return [[manager signalWithRequest:request] map:^id(NSDictionary *data) {
        WBChartUserInfo *user = [WBChartUserInfo new];
        user.uid = uid;
        if(data[@"shoplogo"] && [data[@"shoplogo"] isKindOfClass:[NSNull class]]){
            user.icon = @"";
        }
        else{
            user.icon = data[@"shoplogo"];
        }
        if(data[@"username"] && [data[@"username"] isKindOfClass:[NSNull class]]){
            user.name = @"";
        }
        else{
            user.name = data[@"username"];
        }
        return user;
    }];
}

+ (RACSignal *)getShopInfo
{
    WBAPIManager *manager = [self sharedManager];
    NSURLRequest *request = [manager requestWithMethod:@"/client/shop/info" params:nil uploadImage:nil];
    return [[manager signalWithRequest:request] map:^id(NSDictionary *data) {
        WBShopInfo *shop = [WBShopInfo mj_objectWithKeyValues:data];
        shop.shopId = manager.loginUser.userid;
        manager.loginUser.shop = shop;
        [WBStoreManager saveObject:manager.loginUser forKey:kSaveUser];
        return manager.loginUser;
    }];
}

+ (RACSignal *)getShopServiceInfo
{
    WBAPIManager *manager = [self sharedManager];
    NSURLRequest *request = [manager requestWithMethod:@"/client/shop/gettermservice" params:nil uploadImage:nil];
    return [[manager signalWithRequest:request] map:^id(NSArray *data) {
        for(NSDictionary *dic in data){
            if(dic[@"1"]){
                manager.loginUser.shop.isSupportTrade = [dic[@"1"] boolValue];
            }
            if(dic[@"2"]){
                manager.loginUser.shop.isSupportReturn = [dic[@"2"] boolValue];
            }
            if(dic[@"3"]){
                manager.loginUser.shop.isSupportShip = [dic[@"3"] boolValue];
            }
        }
        [WBStoreManager saveObject:manager.loginUser forKey:kSaveUser];
        return manager.loginUser;
    }];
}

+ (RACSignal *)checkNicName:(NSString *)nick
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"nick":nick};
    NSURLRequest *request = [manager requestWithMethod:@"/user/checknick" params:params uploadImage:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)updateShopInfo:(NSDictionary *)params image:(NSDictionary *)image
{
    WBAPIManager *manager = [self sharedManager];
    
    NSMutableDictionary *mParams = [NSMutableDictionary dictionaryWithDictionary:params];
    if(!params[@"shopname"]){
        [mParams setObject:manager.loginUser.shop.name?:@"" forKey:@"shopname"];
    }
    
    NSURLRequest *request = [manager requestWithMethod:@"/client/shop/add" params:mParams uploadImage:image];
    return [[manager signalWithRequest:request] map:^id(NSDictionary *data) {
        manager.loginUser.shop.icon = data[@"shopicon"];
        manager.loginUser.shop.banner = data[@"shopbg"];
        [WBStoreManager saveObject:manager.loginUser forKey:kSaveUser];
        return manager.loginUser.shop;
    }];
}

+ (RACSignal *)updateShopService:(NSDictionary *)params
{
    WBAPIManager *manager = [self sharedManager];
    NSURLRequest *request = [manager requestWithMethod:@"/client/shop/termservice" params:params uploadImage:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)authUserName:(NSString *)name idNum:(NSString *)idnum
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"username":name,
                             @"idnum":idnum};
    NSURLRequest *request = [manager requestWithMethod:@"/client/user/updateinfo" params:params uploadImage:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)createAddress:(NSDictionary *)params
{
    WBAPIManager *manager = [self sharedManager];
    NSURLRequest *request = [manager requestWithMethod:@"/client/address/create" params:params uploadImage:nil];
    return [manager signalWithRequest:request];

    
}

+ (RACSignal *)updateAddress:(NSDictionary *)params
{
    WBAPIManager *manager = [self sharedManager];
    NSURLRequest *request = [manager requestWithMethod:@"/client/address/update" params:params uploadImage:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)getDefaultAddress:(NSDictionary *)info
{
    WBAPIManager *manager = [self sharedManager];
    
    NSMutableDictionary *params = [@{@"uid":[WBAPIManager sharedManager].loginUser.userid} mutableCopy];
    [params addEntriesFromDictionary:info];
    NSURLRequest *request = [manager requestWithMethod:@"/client/address/default" params:params uploadImage:nil];
    return [[manager signalWithRequest:request] map:^id(NSDictionary *response) {
        WBAddress *address = [WBAddress mj_objectWithKeyValues:response];
        return address;
    }];
}

+ (RACSignal *)getAddressList
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"uid":[WBAPIManager sharedManager].loginUser.userid};
    NSURLRequest *request = [manager requestWithMethod:@"/client/address/list" params:params uploadImage:nil];
    //NSArray *addresslist = [WBAddress mj_keyValuesArrayWithObjectArray:<#(NSArray *)#>]
    return [[manager signalWithRequest:request] map:^id(NSDictionary *response) {
        NSArray *addresslist = [WBAddress mj_objectArrayWithKeyValuesArray:response[@"addresses"]];
        NSLog(@"%@",addresslist);
        return addresslist;
    }];
}

+ (RACSignal *)getShopOverview
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"uid":[WBAPIManager sharedManager].loginUser.userid};
    NSURLRequest *request = [manager requestWithMethod:@"/client/shop/overview" params:params uploadImage:nil];
    return [[manager signalWithRequest:request] map:^id(NSDictionary *data) {
        WBShopInfo *shop = [WBAPIManager sharedManager].loginUser.shop.copy;
        shop.visitCount = [data[@"uv"] longValue];
        shop.orderCount = [data[@"order_count"] longValue];
        
        [WBAPIManager sharedManager].loginUser.shop = shop;
        return data;
    }];
}

+ (RACSignal *)delAddress:(NSString *)addressid
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"uid":[WBAPIManager sharedManager].loginUser.userid,@"address_id":addressid};
    NSURLRequest *request = [manager requestWithMethod:@"/client/address/delete" params:params uploadImage:nil];
    //NSArray *addresslist = [WBAddress mj_keyValuesArrayWithObjectArray:<#(NSArray *)#>]
    return [[manager signalWithRequest:request] map:^id(NSDictionary *response) {
        NSArray *addresslist = [WBAddress mj_objectArrayWithKeyValuesArray:response[@"addresses"]];
        NSLog(@"%@",addresslist);
        return addresslist;
    }];
}


+ (RACSignal *)getPushConfig
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"uid":[WBAPIManager sharedManager].loginUser.userid};
    NSURLRequest *request = [manager requestWithMethod:@"/client/push/getconfig" params:params uploadImage:nil];
    return [manager signalWithRequest:request];
}
+ (RACSignal *)pushConfig:(BOOL)isSound isShake:(BOOL)isShake
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"uid":[WBAPIManager sharedManager].loginUser.userid,
                             @"is_receiveable":@(1),
                             @"sound":isSound?@(1):@(2),
                             @"shake":isShake?@(1):@(2),};
    NSURLRequest *request = [manager requestWithMethod:@"/client/push/config" params:params uploadImage:nil];
    return [manager signalWithRequest:request];
}
+ (RACSignal *)withdraw
{
    WBAPIManager *manager = [self sharedManager];
    NSURLRequest *request = [manager requestWithMethod:@"/client/cash/apply" params:nil uploadImage:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)bindAlipay:(NSString *)alipay
{
    WBAPIManager *manager = [self sharedManager];
    NSURLRequest *request = [manager requestWithMethod:@"/client/cash/updatealipay" params:@{@"alipayid":alipay} uploadImage:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)verfyPassword:(NSString *)password
{
    WBAPIManager *manager = [self sharedManager];
    NSURLRequest *request = [manager requestWithMethod:@"/client/user/verifypassword" params:@{@"password":password} uploadImage:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)resetPassword:(NSString *)password
                   mobilenum:(NSString *)mobilenum
                    passcode:(NSString *)passcode
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"mobilenum":mobilenum,
                             @"password":password,
                             @"passcode":passcode};
    
    NSURLRequest *request = [manager requestWithMethod:@"/client/sso/resetpassword" params:params uploadImage:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)bindPhone:(NSString *)mobilenum
                password:(NSString *)password
                passcode:(NSString *)passcode
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"mobilenum":mobilenum,
                             @"password":password,
                             @"passcode":passcode};
    
    NSURLRequest *request = [manager requestWithMethod:@"/user/mobile/bind" params:params uploadImage:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)checkRelationWithUid:(NSString *)uid
{
    WBAPIManager *manager = [self sharedManager];
    NSDictionary *params = @{@"follow_uid":uid};
    NSURLRequest *request = [manager requestWithMethod:@"/relation/check" params:params uploadImage:nil];
    
    return [[manager signalWithRequest:request] map:^id(NSDictionary *data) {
        return data[@"status"];
    }];
}

+ (RACSignal *)existMobilenum:(NSString *)mobilenum
{
    WBAPIManager *manager = [self sharedManager];
    
    NSDictionary *params = @{@"mobilenum":mobilenum};
    NSURLRequest *request = [manager requestWithMethod:@"/client/user/mobileex" params:params uploadImage:nil];
    return [[manager signalWithRequest:request] map:^id(NSNumber *value) {
        return value;
    }];
}

+ (RACSignal *)sendCode:(NSString *)mobilenum
{
    WBAPIManager *manager = [self sharedManager];
    
    NSDictionary *params = @{@"mobilenum":mobilenum,@"time":[NSDate timeStampString]};
    NSURLRequest *request = [manager requestWithMethod:@"/client/sso/sendcodenew" params:params uploadImage:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)verifyMobile:(NSString *)mobilenum
                   passcode:(NSString *)passscode
{
    WBAPIManager *manager = [self sharedManager];
    
    NSDictionary *params = @{@"mobilenum":mobilenum,
                             @"passcode":passscode};
    NSURLRequest *request = [manager requestWithMethod:@"/client/user/verifypasscode" params:params uploadImage:nil];
    return [manager signalWithRequest:request];
}

+ (RACSignal *)verifyMobileOnly:(NSString *)mobilenum
                       passcode:(NSString *)passscode
{
    WBAPIManager *manager = [self sharedManager];
    
    NSDictionary *params = @{@"mobilenum":mobilenum,
                             @"passcode":passscode};
    NSURLRequest *request = [manager requestWithMethod:@"/client/user/verifysmscode" params:params uploadImage:nil];
    return [[manager signalWithRequest:request] catch:^RACSignal *(NSError *error) {
        return [RACSignal error:[NSError errorWithDomain:@"验证码错误" code:error.code userInfo:nil]];
    }];
}
@end
