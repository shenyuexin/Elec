//
//  NSDecimalNumber+helper.m
//  Weimai
//
//  Created by Richard Shen on 16/10/25.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "NSDecimalNumber+helper.h"

@implementation NSDecimalNumber (helper)

- (NSDecimalNumberHandler *)handler
{
    static NSDecimalNumberHandler *aHalder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aHalder = [NSDecimalNumberHandler
                   decimalNumberHandlerWithRoundingMode:NSRoundUp
                   scale:2
                   raiseOnExactness:NO
                   raiseOnOverflow:NO
                   raiseOnUnderflow:NO
                   raiseOnDivideByZero:YES];
    });
    return aHalder;
}


- (NSString *)dot2FString
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *roundedOunces;
    roundedOunces = [self decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    NSString *string = [NSString stringWithFormat:@"%@",roundedOunces];
    if ([string rangeOfString:@"."].length == 0) {
        string=  [string stringByAppendingString:@".00"];
    }
    return string;
}
@end
