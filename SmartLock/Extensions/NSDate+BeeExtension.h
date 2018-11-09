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

#pragma mark -

#define SECOND	(1)
#define MINUTE	(60 * SECOND)
#define HOUR	(60 * MINUTE)
#define DAY		(24 * HOUR)
#define MONTH	(30 * DAY)

#pragma mark -

@interface NSDate(BeeExtension)

@property (nonatomic, readonly) NSInteger	year;
@property (nonatomic, readonly) NSInteger	month;
@property (nonatomic, readonly) NSInteger	day;
@property (nonatomic, readonly) NSInteger	hour;
@property (nonatomic, readonly) NSInteger	minute;
@property (nonatomic, readonly) NSInteger	second;
@property (nonatomic, readonly) NSInteger	weekday;
@property (nonatomic, readonly) NSInteger	weekdayOrdinal;         //这个月的第几周

- (NSString *)stringWithDateFormat:(NSString *)format;
- (NSString *)timeAgo;
- (NSString *)imTimeAgo;
- (NSString *)recordTimeAgo;

+ (long long)timeStamp;
+ (NSString *)timeStampString;

//与当前时间相比，过了多久（秒数）
- (NSInteger)diffWithNow;

//string must follow the format: yyyy-MM-dd HH:mm:ss
+ (NSDate *)dateWithString:(NSString *)string;
+ (NSDate *)dateWithYYYYMMDDString:(NSString *)string;

+ (NSDate *)now;

+ (NSString *)dateWithMinuteString:(NSInteger)string;

+ (NSString *)dateWithSecString:(NSInteger)string;
+ (NSString *)dateWithSec:(long long)time;

+ (NSDate *)dateWithMMDDString:(NSString *)string;

+ (NSString *)formateDate:(NSDate *)needFormatDate;

+ (NSString *)timeShow:(NSString *)timeString;

+ (NSString *)timeCompare:(NSString *)needTime;

+ (NSInteger)compareTime:(NSString *)needFormatTime;

/** 比较时间和当前时间早晚 */
+ (BOOL)compareDate:(NSString *)compareTimeString;

//几天几小时
+ (NSString *)leftDateStringWithInterval:(NSTimeInterval)time;
@end
