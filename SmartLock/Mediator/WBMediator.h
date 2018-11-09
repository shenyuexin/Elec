//
//  WBMediator.h
//  Weimai
//
//  Created by Richard Shen on 16/3/24.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBMediator : NSObject

@property (nonatomic, weak) UIViewController *topViewController;

+ (instancetype)sharedManager;

//前往登录页
- (void)gotoLoginControllerWithAnimate:(BOOL)animate;

//前往设置页
- (void)gotoSettingController;

////前往修改密码页
//- (void)gotoModifyPasswordController;

//前往地图页
- (void)gotoMapViewController;

//前往详情页
- (void)gotoDetailViewController:(id)user;

//前往图片选择页
- (void)gotoPhotoSelectController:(NSMutableArray *)photos maxCount:(NSInteger)count;
@end
