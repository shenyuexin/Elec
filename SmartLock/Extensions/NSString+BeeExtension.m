//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "NSString+BeeExtension.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreText/CTFramesetter.h>

//#import "Bee_UnitTest.h"
#import "NSData+BeeExtension.h"
//#import "NSObject+BeeTypeConversion.h"

// ----------------------------------
// Source code
// ----------------------------------

@interface NSObject(BeeTypeConversion)
@end

@implementation NSObject(BeeTypeConversion)

- (NSString *)asNSString
{
	if ( [self isKindOfClass:[NSNull class]] )
		return nil;
    
	if ( [self isKindOfClass:[NSString class]] )
	{
		return (NSString *)self;
	}
	else if ( [self isKindOfClass:[NSData class]] )
	{
		NSData * data = (NSData *)self;
		return [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
	}
	else
	{
		return [NSString stringWithFormat:@"%@", self];
	}
}
@end

#pragma mark -

@implementation NSString(BeeExtension)

@dynamic data;
@dynamic date;

@dynamic MD5;
@dynamic MD5Data;

@dynamic SHA1;

@dynamic APPEND;
@dynamic LINE;
@dynamic REPLACE;

@dynamic containIntegers;
@dynamic containInteger;

@dynamic chineseLength;

- (NSData *)data
{
	return [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
}

- (NSDate *)date
{
	NSTimeZone * local = [NSTimeZone localTimeZone];
	
	NSString * format = @"yyyy-MM-dd HH:mm:ss";
	NSString * text = [(NSString *)self substringToIndex:format.length];
	
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:format];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	return [NSDate dateWithTimeInterval:(3600 + [local secondsFromGMT])
							  sinceDate:[dateFormatter dateFromString:text]];
}

- (NSArray *)containIntegers
{
    NSString *onlyNumStr = [self stringByReplacingOccurrencesOfString:@"[^0-9,]" withString:@"," options:NSRegularExpressionSearch range:NSMakeRange(0, [self length])];
    NSArray *numArr = [onlyNumStr componentsSeparatedByString:@","];
    if([numArr count]>0)
    {
        NSMutableArray *mutableNumArray = [NSMutableArray arrayWithArray:numArr];
        NSMutableIndexSet *removeSet = [[NSMutableIndexSet alloc] init];
        [mutableNumArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if([obj isEqualToString:@""])
            {
                [removeSet addIndex:idx];
            }
        }];
        [mutableNumArray removeObjectsAtIndexes:removeSet];
        return mutableNumArray;
    }
    return numArr;
}

- (NSInteger)containInteger
{
    NSArray *numArr = [self containIntegers];
    if([numArr count]>0)
        return [[numArr firstObject] integerValue];
    return -1;
}

- (NSInteger)chineseLength
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [self dataUsingEncoding:enc];
    return data.length;
}

- (NSStringAppendBlock)APPEND
{
	NSStringAppendBlock block = ^ NSString * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
				
		NSString * append = [[NSString alloc] initWithFormat:first arguments:args];
		
		NSMutableString * copy = [self mutableCopy];
		[copy appendString:append];

		va_end( args );
		
		return copy;
	};

	return [block copy];
}

- (NSStringAppendBlock)LINE
{
	NSStringAppendBlock block = ^ NSString * ( id first, ... )
	{
		NSMutableString * copy = [self mutableCopy];

		if ( first )
		{
			va_list args;
			va_start( args, first );
			
			NSString * append = [[NSString alloc] initWithFormat:first arguments:args];
			[copy appendString:append];

			va_end( args );
		}

		[copy appendString:@"\n"];

		return copy;
	};
	
	return [block copy];
}

- (NSStringReplaceBlock)REPLACE
{
	NSStringReplaceBlock block = ^ NSString * ( NSString * string1, NSString * string2 )
	{
		return [self stringByReplacingOccurrencesOfString:string1 withString:string2];
	};
	
	return [block copy];
}

- (NSArray *)allURLs
{
	NSMutableArray * array = [NSMutableArray array];
	
	NSInteger stringIndex = 0;
	while ( stringIndex < self.length )
	{
		NSRange searchRange = NSMakeRange(stringIndex, self.length - stringIndex);
		NSRange httpRange = [self rangeOfString:@"http://" options:NSCaseInsensitiveSearch range:searchRange];
		NSRange httpsRange = [self rangeOfString:@"https://" options:NSCaseInsensitiveSearch range:searchRange];
		
		NSRange startRange;
		if ( httpRange.location == NSNotFound )
		{
			startRange = httpsRange;
		}
		else if ( httpsRange.location == NSNotFound )
		{
			startRange = httpRange;
		}
		else
		{
			startRange = (httpRange.location < httpsRange.location) ? httpRange : httpsRange;
		}
		
		if (startRange.location == NSNotFound)
		{
			break;			
		}
		else
		{
			NSRange beforeRange = NSMakeRange( searchRange.location, startRange.location - searchRange.location );
			if ( beforeRange.length )
			{
				//				NSString * text = [string substringWithRange:beforeRange];
				//				[array addObject:text];
			}
			
			NSRange subSearchRange = NSMakeRange(startRange.location, self.length - startRange.location);
			NSRange endRange = [self rangeOfString:@" " options:NSCaseInsensitiveSearch range:subSearchRange];
			if ( endRange.location == NSNotFound)
			{
				NSString * url = [self substringWithRange:subSearchRange];
				[array addObject:url];
				break;				
			}
			else
			{
				NSRange URLRange = NSMakeRange(startRange.location, endRange.location - startRange.location);
				NSString * url = [self substringWithRange:URLRange];
				[array addObject:url];
				
				stringIndex = endRange.location;
			}
		}
	}
	
	return array;
}

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict
{
    NSMutableArray * pairs = [NSMutableArray array];
	for ( NSString * key in dict.allKeys )
	{
		NSString * value = [((NSObject *)[dict objectForKey:key]) asNSString];
		NSString * urlEncoding = [value URLEncoding];
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncoding]];
	}
	
	return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)queryStringFromArray:(NSArray *)array
{
	NSMutableArray *pairs = [NSMutableArray array];
	
	for ( NSUInteger i = 0; i < [array count]; i += 2 )
	{
		NSObject * obj1 = [array objectAtIndex:i];
		NSObject * obj2 = [array objectAtIndex:i + 1];
		
		NSString * key = nil;
		NSString * value = nil;
		
		if ( [obj1 isKindOfClass:[NSNumber class]] )
		{
			key = [(NSNumber *)obj1 stringValue];
		}
		else if ( [obj1 isKindOfClass:[NSString class]] )
		{
			key = (NSString *)obj1;
		}
		else
		{
			continue;
		}
		
		if ( [obj2 isKindOfClass:[NSNumber class]] )
		{
			value = [(NSNumber *)obj2 stringValue];
		}
		else if ( [obj1 isKindOfClass:[NSString class]] )
		{
			value = (NSString *)obj2;
		}
		else
		{
			continue;
		}
		
		NSString * urlEncoding = [value URLEncoding];
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncoding]];
	}
	
	return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)queryStringFromKeyValues:(id)first, ...
{
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	
	va_list args;
	va_start( args, first );
	
	for ( ;; )
	{
		NSObject<NSCopying> * key = [dict count] ? va_arg( args, NSObject * ) : first;
		if ( nil == key )
			break;
		
		NSObject * value = va_arg( args, NSObject * );
		if ( nil == value )
			break;
		
		[dict setObject:value forKey:key];
	}
	va_end( args );
	return [NSString queryStringFromDictionary:dict];
}


+ (NSString *)stringWithNum:(NSInteger)num
{
    if(num >= 10000){
        return [NSString stringWithFormat:@"%.1fW",num/10000.0];
    }
    return [NSString stringWithFormat:@"%ld",(long)num];
}

- (NSString *)urlByAppendingDict:(NSDictionary *)params
{
    NSURL * parsedURL = [NSURL URLWithString:self];
	NSString * queryPrefix = parsedURL.query ? @"&" : @"?";
	NSString * query = [NSString queryStringFromDictionary:params];
	return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];	
}

- (NSString *)urlByAppendingArray:(NSArray *)params
{
    NSURL * parsedURL = [NSURL URLWithString:self];
	NSString * queryPrefix = parsedURL.query ? @"&" : @"?";
	NSString * query = [NSString queryStringFromArray:params];
	return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];		
}

- (NSString *)urlByAppendingKeyValues:(id)first, ...
{
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	
	va_list args;
	va_start( args, first );
	
	for ( ;; )
	{
		NSObject<NSCopying> * key = [dict count] ? va_arg( args, NSObject * ) : first;
		if ( nil == key )
			break;
		
		NSObject * value = va_arg( args, NSObject * );
		if ( nil == value )
			break;

		[dict setObject:value forKey:key];
	}
    va_end( args );
	return [self urlByAppendingDict:dict];
}

- (BOOL)isNotEmpty
{
	return [self trim].length > 0? YES : NO;
}

- (BOOL)is:(NSString *)other
{
	return [self isEqualToString:other];
}

- (BOOL)isNot:(NSString *)other
{
	return NO == [self isEqualToString:other];
}

- (BOOL)isValueOf:(NSArray *)array
{
	return [self isValueOf:array caseInsens:NO];
}

- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens
{
	NSStringCompareOptions option = caseInsens ? NSCaseInsensitiveSearch : 0;
	
	for ( NSObject * obj in array )
	{
		if ( NO == [obj isKindOfClass:[NSString class]] )
			continue;
		
		if ( [(NSString *)obj compare:self options:option] )
			return YES;
	}
	
	return NO;
}

- (NSString *)URLEncoding
{  
    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        /**
         AFNetworking/AFURLRequestSerialization.m
         
         Returns a percent-escaped string following RFC 3986 for a query string key or value.
         RFC 3986 states that the following characters are "reserved" characters.
         - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
         - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
         In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
         query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
         should be percent-escaped in the query string.
         - parameter string: The string to be percent-escaped.
         - returns: The percent-escaped string.
         */
        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < self.length) {
            NSUInteger length = MIN(self.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            // To avoid breaking up character sequences such as 👴🏻👮🏽
            range = [self rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [self substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)self,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop

}
}

- (NSString *)URLDecoding
{
	NSMutableString * string = [NSMutableString stringWithString:self]; 
    [string replaceOccurrencesOfString:@"+"  
							withString:@" "  
							   options:NSLiteralSearch  
								 range:NSMakeRange(0, [string length])];  
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

- (NSData *)MD5Data
{
	// TODO:
	return nil;
}

// thanks to @uxyheaven
- (NSString *)SHA1
{
    const char *	cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *		data = [NSData dataWithBytes:cstr length:self.length];

    uint8_t			digest[CC_SHA1_DIGEST_LENGTH] = { 0 };
	CC_LONG			digestLength = (CC_LONG)data.length;

    CC_SHA1( data.bytes, digestLength, digest );

    NSMutableString * output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	
    for ( int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++ )
	{
		[output appendFormat:@"%02x", digest[i]];
	}

    return output;
}

- (NSString *)adaptPirce
{
    NSString *newPrice = self;
    NSRange pRange = [self rangeOfString:@"."];
    if (pRange.location != NSNotFound) {
        if (self.length - pRange.location > 3) {
            newPrice = [self substringToIndex:pRange.location+3];
        }
    }
    return newPrice;
}

- (NSString *)trim
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimSpecialCharacter
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；￥（）¥……「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSString *)unwrap
{
	if ( self.length >= 2 )
	{
		if ( [self hasPrefix:@"\""] && [self hasSuffix:@"\""] )
		{
			return [self substringWithRange:NSMakeRange(1, self.length - 2)];
		}

		if ( [self hasPrefix:@"'"] && [self hasSuffix:@"'"] )
		{
			return [self substringWithRange:NSMakeRange(1, self.length - 2)];
		}
	}

	return self;
}

- (BOOL)isUserName
{
	NSString *		regex = [NSString regexUserName];
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

+ (NSString *)regexUserName
{
    return @"(^[A-Za-z0-9]{2,16}$)";
}

- (BOOL)isUserNameContainChinese:(NSInteger)min maxLength:(NSInteger)max
{
	NSString *		regex = [NSString regexUserNameContainChinese:min max:max];
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

+ (NSString *)regexUserNameContainChinese:(NSInteger)min max:(NSInteger)max
{
    //不支持空格
    return [NSString stringWithFormat:@"(^[\\u0391-\\uFFE5A-Za-z0-9]{%@,%@}$)",@(min),@(max)];
    
    //支持空格
//    return [NSString stringWithFormat:@"(^[\\x20\\u4E00-\\u9FA5\\uF900-\\uFA2D\\w]{%@,%@}$)",@(min),@(max)];
}

- (BOOL)isChinese
{
    NSString *		regex = [NSString regexChinese];
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

+ (NSString *)regexChinese
{
    return [NSString stringWithFormat:@"(^[\\u0391-\\uFFE5]$)"];
}

- (BOOL)isSchoolName:(NSInteger)min maxLength:(NSInteger)max
{
	NSString *		regex = [NSString regexSchoolName:min max:max];
    //  \\x20为空格
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

+ (NSString *)regexSchoolName:(NSInteger)min max:(NSInteger)max
{
    return [NSString stringWithFormat:@"(^[\\x20\\u4E00-\\u9FA5\\uF900-\\uFA2D\\w]{%@,%@}$)",@(min),@(max)];
}

- (BOOL)isCardNum:(NSInteger)min maxLength:(NSInteger)max
{
    NSString *		regex = [NSString regexCardNum:min max:max];
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

+ (NSString *)regexCardNum:(NSInteger)min max:(NSInteger)max
{
    return [NSString stringWithFormat:@"(^[A-Za-z0-9]{%@,%@}$)",@(min),@(max)];
}

- (BOOL)isPassword
{
	NSString *		regex = [NSString regexPassword];
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];	
}

+ (NSString *)regexPassword
{
    //只要是中文或字母，6~18位即可
//    return @"(^[A-Za-z0-9]{6,30}$)";
    
    return @"(^[0-9A-Za-z!@#$%^&*.~]{6,30}$)";

//    //6-16位字母，数字，符号，3者不能单独使用，区分大小写
//    return @"(^(?![0-9]+$)(?![a-zA-Z]+$)(?![!#$%^&*.~]+$)[0-9A-Za-z!#$%^&*.~]{6,16}$)";
}

- (BOOL)isNumber
{
	NSString *		regex = [NSString regexNumber];
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

+ (NSString *)regexNumber
{
    return @"(^[0-9]\\d*$)";
}

+ (NSString *)regexVerifyCode
{
    return @"(^[0-9]{6}$)";
}

- (BOOL)isVerifyCode
{
    NSString *		regex = [NSString regexVerifyCode];
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)isIdNum
{
    NSString *		regex = @"(^[0-9]{15}$)|(^[0-9]{17}([0-9]|X)$)";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

- (NSString *)URLDecodedString
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}



- (BOOL)isEmail
{
	NSString *		regex = [NSString regexEmail];
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

+ (NSString *)regexEmail
{
    return @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
}

- (BOOL)isUrl
{
    NSString *		regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

-(BOOL) isOlderVersionThan:(NSString*)otherVersion
{
    return ([self compare:otherVersion options:NSNumericSearch] == NSOrderedAscending);
}

- (BOOL)isTelephone
{
    NSString * MOBILE = @"^1(3[0-9]|4[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return  [regextestmobile evaluateWithObject:self];
}

- (NSString *)securePhone
{
    if(self.length > 8){
        return [self stringByReplacingCharactersInRange:NSMakeRange(4, 4) withString:@"****"];
    }
    return self;
}

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width
{
    return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                              options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                attributes:@{NSFontAttributeName:font}
                   context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height
{
    return  [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                               options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                attributes:@{NSFontAttributeName:font}
                   context:nil].size;
}
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

- (BOOL)match:(NSString *)expression
{
	NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expression
																			options:NSRegularExpressionCaseInsensitive
																			  error:nil];
	if ( nil == regex )
		return NO;
	
	NSUInteger numberOfMatches = [regex numberOfMatchesInString:self
														options:0
														  range:NSMakeRange(0, self.length)];
	if ( 0 == numberOfMatches )
		return NO;

	return YES;
}

- (BOOL)matchAnyOf:(NSArray *)array
{
	for ( NSString * str in array )
	{
		if ( NSOrderedSame == [self compare:str options:NSCaseInsensitiveSearch] )
		{
			return YES;
		}
	}
	
	return NO;
}

@end


@implementation NSAttributedString (Helpers)

- (UITextView *)sizeTextView
{
    static UITextView *textView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    });
    return textView;
}

- (CGSize)sizeByWidth:(CGFloat)width
{
    return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size;
    
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self);
//    CGSize targetSize = CGSizeMake(width, CGFLOAT_MAX);
//    CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [self length]), NULL, targetSize, NULL);
//    CFRelease(framesetter);
    
//    UITextView *view = [self sizeTextView];
//    view.attributedText = self;
//    CGSize size = [view sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
//    return size;
}

- (CGSize)sizeByHeight:(CGFloat)height
{
    return [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size;
}

@end

#pragma mark -

@implementation NSMutableString(BeeExtension)

@dynamic APPEND;
@dynamic LINE;
@dynamic REPLACE;

- (NSMutableStringAppendBlock)APPEND
{
	NSMutableStringAppendBlock block = ^ NSMutableString * ( id first, ... )
	{
		va_list args;
		va_start( args, first );
		
		NSString * append = [[NSString alloc] initWithFormat:first arguments:args];
		[self appendString:append];
		
		va_end( args );

		return self;
	};
	
	return [block copy];
}

- (NSMutableStringAppendBlock)LINE
{
	NSMutableStringAppendBlock block = ^ NSMutableString * ( id first, ... )
	{
		if ( first )
		{
			va_list args;
			va_start( args, first );
			
			NSString * append = [[NSString alloc] initWithFormat:first arguments:args];
			[(NSMutableString *)self appendString:append];
			va_end( args );
		}
		
		[(NSMutableString *)self appendString:@"\n"];

		return self;
	};
	
	return [block copy];
}

- (NSMutableStringReplaceBlock)REPLACE
{
	NSMutableStringReplaceBlock block = ^ NSMutableString * ( NSString * string1, NSString * string2 )
	{
		[self replaceOccurrencesOfString:string1
							  withString:string2
								 options:NSCaseInsensitiveSearch
								   range:NSMakeRange(0, self.length)];
		
		return self;
	};
	
	return [block copy];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( NSString_BeeExtension )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
