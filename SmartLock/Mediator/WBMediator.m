//
//  WBMediator.m
//  Weimai
//
//  Created by Richard Shen on 16/3/24.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#import "WBMediator.h"

@implementation WBMediator

+ (instancetype)sharedManager
{
    static WBMediator *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [WBMediator new];
    });
    return manager;
}

- (UIViewController *)topViewController
{
    UINavigationController *navController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    if(navController.presentedViewController){
//        UINavigationController *presentedNavController = (UINavigationController *)selectNavController.presentedViewController;
//        return presentedNavController.topViewController;
//    }
    return navController.topViewController;
}

- (void)gotoController:(UIViewController *)controller
{
    controller.hidesBottomBarWhenPushed = YES;
    [self.topViewController.navigationController pushViewController:controller animated:YES];
}

- (UIViewController *)controllerWithName:(NSString *)name
{
    Class targetClass = NSClassFromString(name);
    UIViewController *contoller = [[targetClass alloc] init];
    return contoller;
}

#pragma mark - Method
- (void)gotoLoginControllerWithAnimate:(BOOL)animate
{
    UIViewController *controller = [self controllerWithName:@"RLoginViewController"];
    [self.topViewController presentViewController:controller animated:animate completion:nil];
}

- (void)gotoSettingController
{
    UIViewController *controller = [self controllerWithName:@"RSettingViewController"];
    [self gotoController:controller];
}

//前往地图页
- (void)gotoMapViewController
{
    UIViewController *controller = [self controllerWithName:@"RMapViewController"];
    [self gotoController:controller];
}

//前往详情页
- (void)gotoDetailViewController:(id)user
{
    UIViewController *controller = [self controllerWithName:@"RDetailViewController"];
    SEL action = NSSelectorFromString(@"setUser:");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [controller performSelector:action withObject:user];
#pragma clang diagnostic pop
    [self gotoController:controller];
}

- (void)gotoPhotoSelectController:(NSMutableArray *)photos maxCount:(NSInteger)count
{
    UIViewController *controller = [self controllerWithName:@"WBPhotoSelectController"];
    SEL action = NSSelectorFromString(@"setSelectPhotos:");
    SEL actiona = NSSelectorFromString(@"setMaxCount:");
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [controller performSelector:action withObject:photos];
    [controller performSelector:actiona withObject:@(count)];
#pragma clang diagnostic pop
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.topViewController presentViewController:navController animated:YES completion:nil];
}
@end
