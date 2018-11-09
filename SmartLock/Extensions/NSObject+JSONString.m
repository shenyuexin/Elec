//
//  NSObject+JSONString.m
//  Weimai
//
//  Created by Richard Shen on 16/4/8.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "NSObject+JSONString.h"

@implementation NSObject (JSONString)

- (NSString *)JSONString
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (jsonData == nil) {
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
@end
