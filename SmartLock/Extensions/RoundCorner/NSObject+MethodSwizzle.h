//
//  NSObject+MethodSwizzle.h
//  NewMai
//
//  Created by Richard Shen on 15/11/4.
//  Copyright © 2015年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MethodSwizzle)

+ (void)swizzleSelector:(SEL)originalSelector
           withSelector:(SEL)swizzledSelector;
@end
