//
//  WBAPIUserManger.h
//  Weimai
//
//  Created by Richard Shen on 16/1/12.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#import "WBAPIManager.h"

typedef NS_ENUM(NSInteger, WBBindType) {
    WBBindWeibo = 2,    //微博
    WBBindWeixin = 3,   //微信
    WBBindTaobao = 4,   //淘宝
};

@interface WBAPIManager (User)

#pragma mark - 登录注册
/**
 *  登录
 *
 *  @param mobilenum 手机号
 *  @param password  密码
 *
 *  @return NSNumber *success, 是否登录成功
 */
+ (RACSignal *)loginMobilenum:(NSString *)mobilenum
                     password:(NSString *)password;

/**
 *  第三方登录
 *
 *  @param accesstoken 授权token
 *  @param type 第三方类型
 *
 *  @return 是否登录成功
 */
+ (RACSignal *)loginWithAccesstoken:(WBAccessToken *)accesstoken;

/**
 *  第三方登录后注册
 *
 *  @param token     第三方登录后返回token
 *  @param mobilenum 手机号
 *  @param password  密码
 *  @param passcode  手机验证码
 *  @param name      名称
 *
 *  @return 是否注册成功
 */
+ (RACSignal *)registerThirdToken:(WBAccessToken *)token
                        mobilenum:(NSString *)mobilenum
                         password:(NSString *)password
                         passcode:(NSString *)passcode
                         nickName:(NSString *)name;

/**
 *  用户注册
 *
 *  @param mobilenum 手机号
 *  @param password  密码
 *  @param passcode  验证码
 *  @param name      用户昵称
 *  @param avatar    头像url,可选
 *
 *  @return NSNumber *success, 是否注册成功
 */
+ (RACSignal *)registerMobilenum:(NSString *)mobilenum
                        password:(NSString *)password
                        passcode:(NSString *)passcode;


/**
 *  第三方绑定
 *
 *  @param weiboid 第三方id
 *  @param token  第三方token
 *  @param type  第三方类型
 *
 *  @return 是否成功
 */
+ (RACSignal *)bindOpenID:(NSString *)weiboid token:(NSString *)token type:(NSUInteger)type;

/**
 *  取消第三方绑定
 *
 *  @param type  第三方类型
 *
 *  @return 是否成功
 */
+ (RACSignal *)cancelBindWithType:(NSUInteger)type;


#pragma mark - 用户信息获取、修改

/**
 *  获取当前登录用户信息
 *
 *  @return WBUserInfo
 */
+ (RACSignal *)getUserInfo;

/**
 *  获取用户头像名字等信息
 *
 *  @return WBUserInfo
 */
+ (RACSignal *)getUserInfoWithUid:(NSString *)uid;

/**
 *  获取店铺信息
 *
 *  @return WBShopInfo
 */
+ (RACSignal *)getShopInfo;

/**
 *  获取店铺服务信息
 *
 *  @return WBShopInfo
 */
+ (RACSignal *)getShopServiceInfo;

/**
 *  判断用户昵称是否存在
 */
+ (RACSignal *)checkNicName:(NSString *)nick;

/**
 *  修改店铺信息
 *
 *  @param params   @{@"shopname":店铺名称,@"slogan":店铺公告,@"sphone":电话,@"third":第三方信息,}
 *  @image image    @"shopicon":店铺头像,@"shopbg":背景墙
 *
 *  @return YES OR NO
 */
+ (RACSignal *)updateShopInfo:(NSDictionary *)params image:(NSDictionary *)image;


/**
 *  修改店铺服务信息（开关7天无理由退换货等）
 *
 *  @param params   @{@"1":担保交易,@"2":7天无理由退换货,@"3":承担运费}
 *
 *  @return YES OR NO
 */

+ (RACSignal *)updateShopService:(NSDictionary *)params;

/**
 *  身份认证
 *
 *  @param name   姓名
 *  @param idnum  身份证号码
 *
 *  @return YES OR NO
 */
+ (RACSignal *)authUserName:(NSString *)name idNum:(NSString *)idnum;


/**
 *  提现
 *
 *  @return YES OR NO
 */
+ (RACSignal *)withdraw;

/**
 *  新建收货地址
 *
 *  @return YES OR NO
 */
+ (RACSignal *)createAddress:(NSDictionary *)params;
/**
 *  更新收货地址
 *
 *  @return YES OR NO
 */
+ (RACSignal *)updateAddress:(NSDictionary *)params;
/**
 *  获取收货地址
 *
 *  @return YES OR NO
 */
+ (RACSignal *)getDefaultAddress:(NSDictionary *)info;

/**
 *  获取收货地址列表
 *
 *  @return list
 */
+ (RACSignal *)getAddressList;

/**
 *  店铺统计总收入,今日访客,本月订单
 *
 *  @return list
 */
+ (RACSignal *)getShopOverview;

/**
 *  删除收货地址
 *
 *  @return YES OR NO
 */
+ (RACSignal *)delAddress:(NSString *)addressid;

+ (RACSignal *)getPushConfig;
+ (RACSignal *)pushConfig:(BOOL)isSound isShake:(BOOL)isShake;
/**
 *  绑定支付宝
 *
 *  @param alipay  支付宝账号
 *
 *  @return YES OR NO
 */
+ (RACSignal *)bindAlipay:(NSString *)alipay;

/**
 *  验证登录密码
 *
 *  @param password  密码
 *
 *  @return YES OR NO
 */
+ (RACSignal *)verfyPassword:(NSString *)password;

/**
 *  重置密码
 *
 *  @return 成功YES
 */
+ (RACSignal *)resetPassword:(NSString *)password
                   mobilenum:(NSString *)mobilenum
                    passcode:(NSString *)passcode;

/**
 *  绑定手机号
 *
 *  @return 是否成功
 */
+ (RACSignal *)bindPhone:(NSString *)mobilenum
                password:(NSString *)password
                passcode:(NSString *)passcode;

#pragma mark - 手机号
/**
 *  判断手机号是否存在
 *
 *  @return 存在YES，不存在NO
 */
+ (RACSignal *)existMobilenum:(NSString *)mobilenum;

/**
 *  获取手机验证码
 *
 *  @return 获取成功YES, 获取失败NO
 */
+ (RACSignal *)sendCode:(NSString *)mobilenum;


/**
 *  验证手机号，有验证用户是否注册逻辑
 *
 *  @return 验证成功YES, 不成功NO
 */
+ (RACSignal *)verifyMobile:(NSString *)mobilenum
                   passcode:(NSString *)passscode;


/**
 *  验证手机号
 *
 *  @return 验证成功YES, 不成功NO
 */
+ (RACSignal *)verifyMobileOnly:(NSString *)mobilenum
                       passcode:(NSString *)passscode;

@end
