//
//  WBAPIManager+Other.h
//  Weimai
//
//  Created by Richard Shen on 16/2/3.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#import "WBAPIManager.h"

@interface WBAPIManager (Other)

/**
 *  上传图片
 *
 *  @return url
 */
+ (RACSignal *)uploadImage:(UIImage *)image;

/**
 *  上传聊天图片
 *
 *  @return url
 */
+ (RACSignal *)uploadIMImage:(UIImage *)image;

/**
 *  意见反馈
 *
 *  @param content 反馈内容
 *  @param content 反馈类型1代表功能异常 2代表其他问题
 *  @param content 反馈图片
 *
 *  @return 是否成功
 */
+ (RACSignal *)feedback:(NSString *)content type:(NSInteger)type imgUrls:(NSArray *)urls;

/**
 *  获取淘宝商品信息
 *
 *  @param content 反馈内容
 *
 *  @return @{@"":@"":@"":@""}
 */
+ (RACSignal *)getDispathInfo:(NSString *)pid;

/**
 *  举报
 *
 *  @param type     举报类型 1广告骚扰 2有害信息 3违法信息 4 色情低俗 5 人身攻击我 6 谣言
 *  @param feedid   Feedid
 *  @param feedtype FeedType
 *  @param feeduid  发布此Feed的用户
 *
 *  @return BOOL
 */
+ (RACSignal *)reportType:(NSInteger)type
                   feedID:(NSString *)feedid
                 feedType:(NSInteger)feedtype
                  feedUid:(NSString *)feeduid;
/**
 *  抽奖分享接口
 *
 *  @param uid 抽奖分享成功
 *
 *  @return BOOL
 */
+ (RACSignal *)shareRewards:(NSString *)uid;

/**
 *  获取运营活动接口
 *
 *  @return @[@{@"image":@"运营图片",@"link":@"活动页面地址"}]
 */
+ (RACSignal *)getActivitys;

/**
 *  获取运营活动接口
 *
 *  @return @[@{@"image":@"运营图片",@"link":@"活动页面地址"}]
 */
+ (RACSignal *)getActivityDetail:(NSUInteger)actId;

/**
 *  获取运营活动接口
 *
 *  @return @[@{@"image":@"运营图片",@"link":@"活动页面地址"}]
 */
+ (RACSignal *)getTopicDetail:(NSUInteger)topicId;

/**
 *  设备注册
 *
 *  @param deviceToken 设备token
 *  @param uid         当前用户id，退出登录为0
 *
 *  @return BOOL
 */
+ (RACSignal *)bindDeviceToken:(NSString *)deviceToken uid:(NSString *)uid;

/**
 *  设备注册
 *
 *  @param deviceToken 设备token
 *  @param uid        用户uid
 *
 *  @return BOOL
 */
+ (RACSignal *)registerDeviceToken:(NSString *)deviceToken uid:(NSString *)uid;


/**
 *  统计分享Feed数
 *
 *  @param feedid Feedid
 *  @param type   Feed类型
 *
 *  @return BOOL
 */
+ (RACSignal *)countShareFeed:(NSString*)feedid type:(NSInteger)type;

/**
 *  获取热修复JS文件
 *
 *  @return JS
 */
+ (RACSignal *)getHotFixJscript;

/**
 *  上传崩溃日志
 *
 *  @param log                  崩溃日志
 *  @param phoneType            手机型号
 *  @param phoneos              手机系统
 *  @param networkType          网络类型
 *  @param version              app版本号
 *
 *  @return BOOL
 */
+ (RACSignal *)uploadCrashLog:(NSString *)log
                    phoneType:(NSString *)phoneType
                      phoneOS:(NSString *)phoneos
                  networkType:(NSString *)networkType
                      version:(NSString *)version;
@end
