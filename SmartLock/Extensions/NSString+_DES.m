//
//  NSString+_DES.m
//  Weimai
//
//  Created by Richard Shen on 2017/4/28.
//  Copyright © 2017年 Weibo. All rights reserved.
//

#import "NSString+_DES.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
#import "GTMBase64.h"

//密匙 key
#define gkey            @"Richard"
//偏移量
#define gIv             @"iv"

@implementation NSString (_DES)

- (NSString *)doEncrypt_3DES
{
    //把string 转NSData
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    //length
    size_t plainTextBufferSize = [data length];
    
    const void *vplainText = (const void *)[data bytes];
    
//    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [gkey UTF8String];
    //偏移量
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    //配置CCCrypt
    CCCrypt(kCCEncrypt,
            kCCAlgorithm3DES, //3DES
            kCCOptionECBMode|kCCOptionPKCS7Padding, //设置模式
            vkey,    //key
            kCCKeySize3DES,
            vinitVec,     //偏移量，这里不用，设置为nil;不用的话，必须为nil,不可以为@“”
            vplainText,
            plainTextBufferSize,
            (void *)bufferPtr,
            bufferPtrSize,
            &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [GTMBase64 stringByEncodingData:myData];
    return result;
}

- (NSString*)doDecEncrypt_3DES
{
    
    NSData *encryptData = [GTMBase64 decodeData:[self dataUsingEncoding:NSUTF8StringEncoding]];
    
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
//    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [gkey UTF8String];
    
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    CCCrypt(kCCDecrypt,
            kCCAlgorithm3DES,
            kCCOptionPKCS7Padding|kCCOptionECBMode,
            vkey,
            kCCKeySize3DES,
            vinitVec,
            vplainText,
            plainTextBufferSize,
            (void *)bufferPtr,
            bufferPtrSize,
            &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                     length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    
    
    return result;
}
@end
