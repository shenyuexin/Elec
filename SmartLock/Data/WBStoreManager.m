//
//  WBStoreManager.m
//  Weimai
//
//  Created by Richard Shen on 16/1/18.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#import "WBStoreManager.h"

@implementation WBStoreManager

//+ (void)load
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        if(![fileManager fileExistsAtPath:PATH_OF_HRTDATA]){
//            [fileManager createDirectoryAtPath:PATH_OF_HRTDATA withIntermediateDirectories:YES attributes:nil error:nil];
//            [WBStoreManager addSkipBackupAttributeToItemAtPath:PATH_OF_HRTDATA];
//        }
//    });
//}

+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)path
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: path]);
    
    NSURL *URL = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}


+ (NSString *)pathWithKey:(NSString *)key
{
    NSString *path = [PATH_OF_HRTDATA stringByAppendingPathComponent:key.MD5];
    return path;
}

+ (NSString *)videoPathWithKey:(NSString *)key
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                               NSUserDomainMask, YES) firstObject];
    cachePath = [cachePath stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"];
    return [cachePath stringByAppendingPathComponent:key.MD5];
}

+ (void)saveObject:(id)object forKey:(NSString *)key
{
    if(!key) return;
    
    NSString *path = [WBStoreManager pathWithKey:key];
    [WBStoreManager saveObject:object toPath:path];
}

+ (void)saveObject:(id)object toPath:(NSString *)path
{
    if(!path) return;
    if(!object){
        [[[NSFileManager alloc] init] removeItemAtPath:path error:nil];
    }
    
    dispatch_queue_t apiCacheQueue = dispatch_queue_create("com.weibo.apicache", 0);
    dispatch_async(apiCacheQueue, ^{
        BOOL save = [NSKeyedArchiver archiveRootObject:object toFile:path];
        if(!save){
            NSLog(@"save %@ error!", object);
        }
    });
}

+ (void)removeObjectForKey:(NSString *)key
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];

    NSString *path = [WBStoreManager pathWithKey:key];
    if([fileManager fileExistsAtPath:path]){
        [fileManager removeItemAtPath:path error:nil];
    }
}

+ (id)loadObjectForKey:(NSString *)key
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSString *path = [WBStoreManager pathWithKey:key];
    if([fileManager fileExistsAtPath:path])
    {
        @try {
            id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
            return obj;

        } @catch (NSException *exception) {
            NSLog(@"loadobject Error! key:%@",key);
            return nil;
        }
    }
    return nil;
}
@end
