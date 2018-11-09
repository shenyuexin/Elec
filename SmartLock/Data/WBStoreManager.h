//
//  WBStoreManager.h
//  Weimai
//
//  Created by Richard Shen on 16/1/18.
//  Copyright © 2016年 Weibo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PATH_OF_DOCUMENTS    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]
#define PATH_OF_HRTDATA      [PATH_OF_DOCUMENTS stringByAppendingPathComponent:@"sldata"]

@interface WBStoreManager : NSObject


+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)path;

/**
 *  获取本地保存的路径
 *
 *  @param key 文件保存读取key，自动对key md5加密
 *
 *  @return 路径
 */
+ (NSString *)pathWithKey:(NSString *)key;

/**
 *  视频路径
 *
 *  @param key 文件保存读取key，自动对key md5加密
 *
 *  @return 路径
 */
+ (NSString *)videoPathWithKey:(NSString *)key;

/**
 *  保存数据
 *
 *  @param object 须支持encode,decode; object为nil时，则移除保存的文件
 *  @param key    不能为nil
 */
+ (void)saveObject:(id)object forKey:(NSString *)key;

+ (void)saveObject:(id)object toPath:(NSString *)path;

/**
 *  移除数据
 *
 *  @param key    不能为nil
 */
+ (void)removeObjectForKey:(NSString *)key;

/**
 *  读取数据
 */
+ (id)loadObjectForKey:(NSString *)key;

@end
