//
//  WBPhotoSelectController.h
//  Weimai
//
//  Created by Richard Shen on 16/4/9.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#import "RBaseViewController.h"

@interface WBPhotoSelectController : RBaseViewController

@property (nonatomic, strong) NSNumber *maxCount;

@property (nonatomic, strong) NSMutableArray *selectPhotos;

@property (nonatomic, assign) BOOL isPresent;
@property (nonatomic, assign) BOOL isFinish;
@property (nonatomic, assign) BOOL isGotoPhoto;
@end
