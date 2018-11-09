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

//#import "Bee_Precompile.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#pragma mark -

typedef NSString *			(^NSStringAppendBlock)( id format, ... );
typedef NSString *			(^NSStringReplaceBlock)( NSString * string, NSString * string2 );

typedef NSMutableString *	(^NSMutableStringAppendBlock)( id format, ... );
typedef NSMutableString *	(^NSMutableStringReplaceBlock)( NSString * string, NSString * string2 );

#pragma mark -

@interface NSString(BeeExtension)

@property (nonatomic, readonly) NSStringAppendBlock		APPEND;
@property (nonatomic, readonly) NSStringAppendBlock		LINE;
@property (nonatomic, readonly) NSStringReplaceBlock	REPLACE;

@property (nonatomic, readonly) NSData *				data;
@property (nonatomic, readonly) NSDate *				date;

@property (nonatomic, readonly) NSString *				MD5;
@property (nonatomic, readonly) NSData *				MD5Data;

// thanks to @uxyheaven
@property (nonatomic, readonly) NSString *				SHA1;

//当前字符串中所含整数
@property (nonatomic, readonly) NSArray *               containIntegers;

//当前字符串中获取的第一个整数, 不存在则返回-1
@property (nonatomic, readonly) NSInteger               containInteger;

/** 中文字符长度 */
@property (nonatomic, readonly) NSInteger               chineseLength;


- (NSArray *)allURLs;

- (NSString *)urlByAppendingDict:(NSDictionary *)params;
- (NSString *)urlByAppendingArray:(NSArray *)params;
- (NSString *)urlByAppendingKeyValues:(id)first, ...;

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict;
+ (NSString *)queryStringFromArray:(NSArray *)array;
+ (NSString *)queryStringFromKeyValues:(id)first, ...;

+ (NSString *)stringWithNum:(NSInteger)num;

- (NSString *)URLEncoding;
- (NSString *)URLDecoding;

- (NSString *)adaptPirce;
- (NSString *)trim;
- (NSString *)trimSpecialCharacter;
- (NSString *)unwrap;

- (BOOL)match:(NSString *)expression;
- (BOOL)matchAnyOf:(NSArray *)array;

- (BOOL)isNotEmpty;

- (BOOL)is:(NSString *)other;
- (BOOL)isNot:(NSString *)other;

- (BOOL)isValueOf:(NSArray *)array;
- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens;

- (BOOL)isTelephone;
- (BOOL)isUserName;
- (BOOL)isUserNameContainChinese:(NSInteger)min maxLength:(NSInteger)max;
- (BOOL)isSchoolName:(NSInteger)min maxLength:(NSInteger)max;
- (BOOL)isCardNum:(NSInteger)min maxLength:(NSInteger)max;
- (BOOL)isPassword;
- (BOOL)isNumber;
- (BOOL)isEmail;
- (BOOL)isUrl;
- (BOOL)isChinese;
- (BOOL)isOlderVersionThan:(NSString*)otherVersion;
- (BOOL)isVerifyCode;
- (BOOL)isIdNum;
- (NSString *)URLDecodedString;



- (NSString *)securePhone;

#pragma mark - regex
+ (NSString *)regexUserName;
+ (NSString *)regexUserNameContainChinese:(NSInteger)min max:(NSInteger)max;
+ (NSString *)regexSchoolName:(NSInteger)min max:(NSInteger)max;
+ (NSString *)regexCardNum:(NSInteger)min max:(NSInteger)max;
+ (NSString *)regexPassword;
+ (NSString *)regexNumber;
+ (NSString *)regexEmail;
+ (NSString *)regexChinese;
+ (NSString *)regexVerifyCode;

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width;
- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

@end

@interface NSAttributedString (Helpers)
- (CGSize)sizeByWidth:(CGFloat)width;
- (CGSize)sizeByHeight:(CGFloat)height;
@end

#pragma mark -

@interface NSMutableString(BeeExtension)

@property (nonatomic, readonly) NSMutableStringAppendBlock	APPEND;
@property (nonatomic, readonly) NSMutableStringAppendBlock	LINE;
@property (nonatomic, readonly) NSMutableStringReplaceBlock	REPLACE;

@end
