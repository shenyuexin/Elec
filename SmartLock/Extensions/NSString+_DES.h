//
//  NSString+_DES.h
//  Weimai
//
//  Created by Richard Shen on 2017/4/28.
//  Copyright © 2017年 Weibo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (_DES)

//3DES加密
- (NSString *)doEncrypt_3DES;

//3DES解密
- (NSString*)doDecEncrypt_3DES;
@end
