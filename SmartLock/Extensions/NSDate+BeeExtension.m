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

#import "NSDate+BeeExtension.h"

//#import "Bee_UnitTest.h"
//#import "NSNumber+BeeExtension.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSDate(BeeExtension)

@dynamic year;
@dynamic month;
@dynamic day;
@dynamic hour;
@dynamic minute;
@dynamic second;
@dynamic weekday;

- (NSInteger)year
{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)minute {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)second {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)weekday {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSInteger)weekdayOrdinal {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}


- (NSString *)stringWithDateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [NSDate formatter];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}

- (NSString *)timeAgo
{
	NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self];
	
	if (delta < 1 * MINUTE)
	{
		return @"刚刚";
	}
	else if (delta < 1 * HOUR)
	{
		int minutes = floor((double)delta/MINUTE);
		return [NSString stringWithFormat:@"%d分钟前", minutes];
	}
	else if (delta < 24 * HOUR)
	{
		int hours = floor((double)delta/HOUR);
		return [NSString stringWithFormat:@"%d小时前", hours];
	}
	else if (delta < 2 * DAY)
	{
        NSString *string = [self stringWithDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"昨天 %@",string];
	}
	else if (delta < 12 * MONTH)
	{
		return [self stringWithDateFormat:@"MM月dd日 HH:mm"];
	}

	return [self stringWithDateFormat:@"yyyy年MM月dd日 HH:mm"];
}

- (NSString *)recordTimeAgo
{
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self];
    
//    if (delta < 1 * MINUTE)
//    {
//        return @"刚刚";
//    }
//    else
    if (self.day == [NSDate date].day)
    {
        return [self stringWithDateFormat:@"HH:mm"];
    }
    else if (delta < 7 * DAY)
    {
        NSInteger index = self.weekday;
        NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];        
        return weekdays[index];
    }
    
    return [self stringWithDateFormat:@"yyyy/MM/dd"];
}


- (NSString *)imTimeAgo
{
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self];
    
//    if (delta < 1 * MINUTE)
//    {
//        return @"刚刚";
//    }
//    else
    if (self.day == [NSDate date].day)
    {
        return [self stringWithDateFormat:@"HH:mm"];
    }
    else if (delta < 7 * DAY)
    {
        NSInteger index = self.weekday;
        NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
        
        NSString *time = [self stringWithDateFormat:@"HH:mm"];

        return [NSString stringWithFormat:@"%@ %@",weekdays[index], time];
    }
    
    return [self stringWithDateFormat:@"yyyy/MM/dd HH:mm"];

}

+ (long long)timeStamp
{
	return (long long)[[NSDate date] timeIntervalSince1970];
}

+ (NSString *)timeStampString
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
    NSString *curTime = [NSString stringWithFormat:@"%llu",dTime];
    return curTime;
    return [NSString stringWithFormat:@"%llu",[NSDate timeStamp]*1000];
}

- (NSInteger)diffWithNow
{
    return [NSDate timeStamp] -  self.timeIntervalSince1970;
}

+ (NSDateFormatter *)formatter
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return formatter;
}

+ (NSDate *)dateWithString:(NSString *)string
{
    if(!string) return nil;
    
    return [[NSDate formatter] dateFromString:string];
}

+ (NSDate *)dateWithYYYYMMDDString:(NSString *)string
{
    if(!string)
        return [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

+ (NSDate *)dateWithMMDDString:(NSString *)string
{
    if(!string)
        return [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

+ (NSDate *)now
{
	return [NSDate date];
}

+ (NSString *)dateWithMinuteString:(NSInteger)minute
{
    NSString *dateString = nil;
    if (minute >= 0 && minute < 60) {
        dateString = [NSString stringWithFormat:@"%ld分钟",(long)minute];
    }
    else if (minute >= 60){
        NSInteger hour = minute / 60;
        minute = minute % 60;
        dateString = [NSString stringWithFormat:@"%li小时%li分钟",(long)hour,(long)minute];
    }
    return dateString;
}

+ (NSString *)dateWithSecString:(NSInteger)time
{
    NSString *dateString = nil;
    
    NSInteger minute = time / 60;
    NSInteger sec = time % 60;
    
    dateString = [NSString stringWithFormat:@"%.2ld:%.2ld",(long)minute,(long)sec];
    
    return dateString;
}

+ (NSString *)dateWithSec:(long long)time
{
    NSString *dateString = nil;
    NSInteger hour = time / 3600;
    NSInteger minute = (time - hour*3600) / 60;
    NSInteger sec = time % 60;
    
    dateString = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",(long)hour,(long)minute,(long)sec];
    
    return dateString;
}

/**
 /////  和当前时间比较
 ///    1）今天或者昨天、前天 显示      :    今天 09:30   昨天 09:30 ,前天
 ///    2) 其他显示                  :   yyyy-MM-dd HH:mm
 **/
+ (NSString *)formateDate:(NSDate *)needFormatDate
{
    // 1.获得年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:needFormatDate];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *dateStr = @"";
    // 2.格式化日期
    if ([cmp1 year] == [cmp2 year]) {
        if ([cmp1 month] == [cmp2 month]) {
            if ([cmp1 day] == [cmp2 day]) { // 今天
                [dateFormatter setDateFormat:@"HH:mm"];
                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }else if ([cmp1 day] == ([cmp2 day] - 1)) { // 1天前
                [dateFormatter setDateFormat:@"HH:mm"];
                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }else if ([cmp1 day] == ([cmp2 day] - 2)) { // 2天前
                [dateFormatter setDateFormat:@"HH:mm"];
                dateStr = [NSString stringWithFormat:@"前天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }else {
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }else {
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }
    }else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        dateStr = [dateFormatter stringFromDate:needFormatDate];
    }
    
    return dateStr;
}

//一天内显示时间，超过不显示时间，如昨天、前天、2015-07-01
+ (NSString *)timeShow:(NSString *)timeString
{
    // 1.获得年月日
    NSDate *needFormatDate = [NSDate dateWithString:timeString];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:needFormatDate];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *dateStr = @"";
    // 2.格式化日期
    if ([cmp1 year] == [cmp2 year]) {
        if ([cmp1 month] == [cmp2 month]) {
            if ([cmp1 day] == [cmp2 day]) { // 今天
                dateStr = [needFormatDate timeAgo];
            }else if ([cmp1 day] == ([cmp2 day] - 1)) { // 1天前
                dateStr = @"昨天";
            }else if ([cmp1 day] == ([cmp2 day] - 2)) { // 2天前
                dateStr = @"前天";
            }else {
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }else {
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }
    }else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        dateStr = [dateFormatter stringFromDate:needFormatDate];
    }
    
    return dateStr;
}

//new
//一天内显示时间，超过不显示时间，如昨天、前天、2015-07-01
+ (NSString *)timeCompare:(NSString *)needTime
{
    NSDate *needFormatDate = [NSDate dateWithString:needTime];
    NSTimeInterval preTime = [needFormatDate timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate date];
    NSTimeInterval now= [dat timeIntervalSince1970]*1;
    
    NSInteger today = now / (24*3600);
    NSInteger yestoday = preTime / (24*3600);
    NSInteger iDiff = today - yestoday;
    NSString *strDiff = nil;
    
    if(iDiff == 0) {
        strDiff= [NSString stringWithFormat:@"今天"];
    }else if (iDiff == 1) {
        strDiff = [NSString stringWithFormat:@"昨天"];
    }else if (iDiff == 2) {
        strDiff = [NSString stringWithFormat:@"前天"];
    }else if (iDiff >= 3 ) {
//        strDiff=  [NSString stringWithFormat:@"大前天"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        strDiff = [dateFormatter stringFromDate:needFormatDate];
    }
    return strDiff;
}


+ (NSInteger)compareTime:(NSString *)needFormatTime
{
    NSDate *compare = [NSDate dateWithString:needFormatTime];
    NSTimeInterval preTime = [compare timeIntervalSince1970]*1;
    NSTimeInterval now= [[NSDate now] timeIntervalSince1970]*1;
    NSTimeInterval resultTime = now - preTime;
    //    return ceil(resultTime/HOUR);
    return resultTime/HOUR;
}

+ (BOOL)compareDate:(NSString *)compareTimeString
{
    NSDate *dateA = [NSDate now];
    NSDate *dateB = [self dateWithString:compareTimeString];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        return YES;  //date1 比 date2 晚
    } else if (result == NSOrderedAscending){
        return NO; //date1 比 date2 早
    }
    return YES; //在当前准确度下，两个时间一致
}

+ (NSString *)leftDateStringWithInterval:(NSTimeInterval)time
{
//    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
//    NSTimeInterval left = (time - now)*1;
    NSTimeInterval left = time;
    
    NSInteger day = floor(left / DAY);
    NSInteger hour = floor((left - day*DAY) / HOUR);
    return [NSString stringWithFormat:@"%ld天%ld小时",(long)day,(long)hour];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( NSDate_BeeExtension )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
