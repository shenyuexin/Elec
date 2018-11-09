//
//  RUserInfo.h
//  SmartLock
//
//  Created by Richard Shen on 2018/10/30.
//  Copyright © 2018 Richard Shen. All rights reserved.
//

#import "RBaseInfo.h"

NS_ASSUME_NONNULL_BEGIN

//{"YM":"201810","orgNo":"33411010102","consNo":"46120587781","consName":"罗璇","pq4":"600","mrSectNo":"33411010001","mrSectName":"测试抄表段","opeartorNo":"P39260511","opeartorName":"罗玄","elecAddr":"浙江省舟山市定海区白泉镇","createDate":"20181018"}
//排查年月、单位编码、户号、户名、当期电量、抄表段编号、抄表段名称、抄表段负责人、负责人名称、地址、生成日期

typedef NS_ENUM(NSInteger, RCheckStatus){
    RCheckStatusUnknow = 0,                     //未排查
    RCheckStatusSuccess = 1,                    //未见异常
    RCheckStatusSuspicion = 2,                  //疑似用户
};


@interface RUserInfo : RBaseInfo

@property (nonatomic, strong, nullable) NSString *YM;                             //排查年月
@property (nonatomic, strong, nullable) NSString *orgNo;                          //单位编码
@property (nonatomic, strong, nullable) NSString *consNo;                         //户号
@property (nonatomic, strong, nullable) NSString *consName;                       //户名
@property (nonatomic, strong, nullable) NSString *pq4;                            //当期电量
@property (nonatomic, strong, nullable) NSString *mrSectNo;                       //抄表段编号
@property (nonatomic, strong, nullable) NSString *mrSectName;                     //抄表段名称
@property (nonatomic, strong, nullable) NSString *opeartorNo;                     //抄表段负责人
@property (nonatomic, strong, nullable) NSString *opeartorName;                   //抄表段负责人名
@property (nonatomic, strong, nullable) NSString *elecAddr;                       //地址
@property (nonatomic, strong, nullable) NSString *createDate;                     //生成日期,20181018

@property (nonatomic, strong, nullable) NSString *remark;                         //备注
@property (nonatomic, assign) RCheckStatus status;                                //状态
@property (nonatomic, strong, nullable) NSString *latitude;                       //维度
@property (nonatomic, strong, nullable) NSString *longitude;                      //经度

@end

NS_ASSUME_NONNULL_END
