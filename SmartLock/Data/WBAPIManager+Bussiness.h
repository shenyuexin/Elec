//
//  WBAPIManager+Bussiness.h
//  Weimai
//
//  Created by Richard Shen on 16/1/14.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#import "WBAPIManager.h"

@interface WBAPIManager (Bussiness)

//获取验证码
+ (RACSignal *)getSmsCode:(NSString *)phone;

//登录
+ (RACSignal *)loginWithPhone:(NSString *)phone code:(NSString *)code;

//获取首页数据
+ (RACSignal *)getHomeData;

//获取客服电话
+ (RACSignal *)getServicePhoneNum;

//开锁记录
+ (RACSignal *)getLockRecords:(NSString *)serialNum
                      keyWord:(NSString *)keyword
                    beginDate:(NSString *)begin
                      endDate:(NSString *)end
                         page:(NSInteger)page;

//申报异常
+ (RACSignal *)reportBug:(NSString *)reason serialNum:(NSString *)serialNum;

//获取系统消息列表
+ (RACSignal *)getMessagesWithPage:(NSInteger)page;

//修改密码
+ (RACSignal *)modifyPassword:(NSString *)password serialNum:(NSString *)serialNum;

@end
