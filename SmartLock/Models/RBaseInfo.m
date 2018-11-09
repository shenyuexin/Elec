//
//  RBaseInfo.m
//  SmartLock
//
//  Created by Richard Shen on 2018/2/9.
//  Copyright © 2018年 Richard Shen. All rights reserved.
//

#import "RBaseInfo.h"

@implementation RBaseInfo
MJExtensionCodingImplementation

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if (!property.type.isNumberType && ([oldValue isEqual:[NSNull null]] || [oldValue isKindOfClass:[NSNull class]])) {
        return  nil;
    }
    return oldValue;
}

@end
