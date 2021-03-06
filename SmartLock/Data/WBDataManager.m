//
//  WBDataManager.m
//  SmartLock
//
//  Created by Richard Shen on 2018/10/30.
//  Copyright © 2018 Richard Shen. All rights reserved.
//

#import "WBDataManager.h"
#import "WBStoreManager.h"
#import "RAccountInfo.h"
#import "RUserInfo.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "WBAPIManager.h"

#define PATH_OF_USERS               [PATH_OF_DOCUMENTS stringByAppendingPathComponent:@"列表json.txt"]
#define PATH_OF_ACCOUNT             [PATH_OF_DOCUMENTS stringByAppendingPathComponent:@"账户json.txt"]
#define PATH_OF_INTRODUCTION        [PATH_OF_DOCUMENTS stringByAppendingPathComponent:@"使用说明.txt"]

@interface WBDataManager ()

@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) NSMutableDictionary *accounts;
@end


@implementation WBDataManager

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [WBDataManager sharedManager];
    });
}

+ (instancetype)sharedManager
{
    static WBDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WBDataManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if(self){
        NSError *error = nil;
        NSData *userData = nil;
        NSData *accountData = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:PATH_OF_USERS]){
           userData = [[NSData alloc] initWithContentsOfFile:PATH_OF_USERS];
        }
        if(error || !userData){
            userData = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"user" ofType:@"json"]];
        }
        id jsonObject = [NSJSONSerialization JSONObjectWithData:userData options:NSJSONReadingMutableContainers error:&error];
        self.users = [RUserInfo mj_objectArrayWithKeyValuesArray:jsonObject];

        self.accounts = [NSMutableDictionary dictionary];
        if([fileManager fileExistsAtPath:PATH_OF_ACCOUNT]){
            accountData = [[NSData alloc] initWithContentsOfFile:PATH_OF_ACCOUNT];
        }
        if(error || !accountData){
            accountData = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"account" ofType:@"json"]];
        }
        jsonObject = [NSJSONSerialization JSONObjectWithData:accountData options:NSJSONReadingMutableContainers error:&error];
        NSArray *array = [RAccountInfo mj_objectArrayWithKeyValuesArray:jsonObject];
        [array enumerateObjectsUsingBlock:^(RAccountInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.password && obj.mobile){
                [self.accounts setObject:obj forKey:obj.mobile];
            }
        }];
        
        if(![fileManager fileExistsAtPath:PATH_OF_INTRODUCTION]){
            NSData *data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"account" ofType:@"json"]];
            [data writeToFile:PATH_OF_INTRODUCTION atomically:YES];
        }
        
        [self initAllUsers];
    }
    return self;
}

- (void)initLoginUsers:(RAccountInfo *)account
{
    self.loginUsers = [NSMutableDictionary dictionary];
    NSMutableArray *defaultUsers = [NSMutableArray array];
    NSMutableArray *successUsers = [NSMutableArray array];
    NSMutableArray *failUsers = [NSMutableArray array];
    
    for (RUserInfo *obj in self.users) {
        if([obj.opeartorNo isEqualToString:account.operatorNo]){
            switch (obj.status) {
                case RCheckStatusSuccess:
                    [successUsers addObject:obj];
                    break;
                case RCheckStatusSuspicion:
                    [failUsers addObject:obj];
                    break;
                default:
                    [defaultUsers addObject:obj];
                    break;
            }
        }
    }
    if(defaultUsers.count > 0){
        [self.loginUsers setObject:defaultUsers forKey:@(RCheckStatusUnknow)];
    }
    if(successUsers.count > 0){
        [self.loginUsers setObject:successUsers forKey:@(RCheckStatusSuccess)];
    }
    if(failUsers.count > 0){
        [self.loginUsers setObject:failUsers forKey:@(RCheckStatusSuspicion)];
    }
}

- (void)initAllUsers
{
    self.allUsers = [NSMutableDictionary dictionary];
    NSMutableArray *defaultUsers = [NSMutableArray array];
    NSMutableArray *successUsers = [NSMutableArray array];
    NSMutableArray *failUsers = [NSMutableArray array];
    
    for (RUserInfo *obj in self.users) {
        switch (obj.status) {
            case RCheckStatusSuccess:
                [successUsers addObject:obj];
                break;
            case RCheckStatusSuspicion:
                [failUsers addObject:obj];
                break;
            default:
                [defaultUsers addObject:obj];
                break;
        }
    }
    [self.allUsers setObject:defaultUsers forKey:@(RCheckStatusUnknow)];
    [self.allUsers setObject:successUsers forKey:@(RCheckStatusSuccess)];
    [self.allUsers setObject:failUsers forKey:@(RCheckStatusSuspicion)];
}

- (void)updateArrays
{
    [self initAllUsers];
    [self initLoginUsers:[WBAPIManager sharedManager].loginUser];
}


- (RAccountInfo *)loginWithPhone:(NSString *)phone pwd:(NSString *)pwd
{
    RAccountInfo *account = self.accounts[phone];
    if(account && [account.password isEqualToString:pwd]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self initLoginUsers:account];
        });
        return account;
    }
    return nil;
}

- (NSString *)picFolderPathWithUser:(RUserInfo *)user
{
    NSString *path = [PATH_OF_DOCUMENTS stringByAppendingPathComponent:[NSString stringWithFormat:@"备注图片_%@_%@",user.consNo,user.consName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil
                                     error: nil];
        [WBStoreManager addSkipBackupAttributeToItemAtPath:path];
    }
    return path;
}

- (void)saveUsers
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *allValues = [NSMutableArray array];
    for(NSArray *users in self.allUsers.allValues){
        [allValues addObjectsFromArray:users];
    }
    
    [allValues enumerateObjectsUsingBlock:^(RUserInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.status == RCheckStatusUnknow){
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"consNo == %@", obj.consNo];
            NSArray *filtered = [self.loginUsers[@(RCheckStatusSuccess)] filteredArrayUsingPredicate:predicate];
            RUserInfo *filterUser = filtered.firstObject;
            if(!filterUser){
                filtered =  [self.loginUsers[@(RCheckStatusSuspicion)] filteredArrayUsingPredicate:predicate];
                filterUser = filtered.firstObject;
            }
            
            if(filterUser){
                [array addObject:filterUser.mj_JSONString];
            }
            else{
                [array addObject:obj.mj_JSONString];
            }
        }
        else{
            [array addObject:obj.mj_JSONString];
        }
    }];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    [jsonData writeToFile:PATH_OF_USERS atomically:YES];
    
    [self updateArrays];
}

- (void)updatePics:(NSArray *)array user:(RUserInfo *)user
{
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[self picFolderPathWithUser:user] error:&error];
    NSString *folderPath = [self picFolderPathWithUser:user];
    
    NSMutableArray *assetIdentifiers = [NSMutableArray array];
    PHImageRequestOptions *option = [PHImageRequestOptions new];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    [array enumerateObjectsUsingBlock:^(PHAsset * _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            [imageData writeToFile:[folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu.jpg",(unsigned long)idx]] atomically:YES];
            [assetIdentifiers addObject:asset.localIdentifier];
            
            if(idx == array.count-1){
                NSString *arrayPath = [folderPath stringByAppendingPathComponent:@"data"];
                BOOL save = [NSKeyedArchiver archiveRootObject:assetIdentifiers toFile:arrayPath];
                if(!save){
                    NSLog(@"save pic array error!");
                }
            }
        }];
    }];
}

- (NSArray *)picsWithUser:(RUserInfo *)user
{
    NSString *folderPath = [self picFolderPathWithUser:user];
    if([[NSFileManager defaultManager] fileExistsAtPath:folderPath]){
        NSString *path = [folderPath stringByAppendingPathComponent:@"data"];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        PHFetchResult* assetResult = [PHAsset fetchAssetsWithLocalIdentifiers:array options:nil];
        NSArray *assets = [assetResult objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
        return assets;
    }
    return nil;
}

@end
