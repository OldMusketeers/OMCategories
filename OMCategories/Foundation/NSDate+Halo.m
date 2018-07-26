//
//  NSDate+Halo.m
//  HaloSlimFramework
//
//  Created by Jet on 16/1/21.
//
//

#import "NSDate+Halo.h"
#import <objc/runtime.h>
#import "NSDateFormatter+Halo.h"
#import "NSCalendar+Halo.h"

@implementation NSDate (Halo)

- (NSDateFormatter *)hlDataFormater
{
    return [NSDateFormatter defaultHLFormatter];
}

- (NSCalendar *)hlCalender
{
    return [NSCalendar defaultHLCalendar];
}

+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond
{
    NSDate *ret = nil;
    double timeInterval = timeIntervalInMilliSecond;
    // judge if the argument is in secconds(for former data structure).
    if(timeIntervalInMilliSecond > 140000000000) {
        timeInterval = timeIntervalInMilliSecond / 1000;
    }
    ret = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    return ret;
}

+ (NSDate *)dateFromString:(NSString *)string
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [inputFormatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

- (NSDateComponents *)dateComponents
{
    return [[NSCalendar currentCalendar] components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
}

- (NSString *)formate:(NSString *)formatterString
{
    self.hlDataFormater.dateFormat = formatterString;
    //	DDLogInfo(@"self.hlDataFormater.dateFormat is %@",self.hlDataFormater.dateFormat);
    return [self.hlDataFormater stringFromDate:self];
    
}

+ (BOOL) isLeapYear:(NSInteger)year {
    return (year%4==0&&year%100!=0)||(year%400==0);
}

+ (NSInteger) numberOfDays:(NSInteger)year month:(NSInteger)month {
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
        {
            return 31;
            break;
        }
        case 4:
        case 6:
        case 9:
        case 11:
        {
            return 30;
            break;
        }
        case 2:
        {
            if ([self isLeapYear:year])
                return 29;
            else
                return 28;
            break;
        }
        default: return 0;
    }
}

+ (NSInteger) numberOfWeeks:(NSInteger)year month:(NSInteger)month firstWeekDay:(HaloFirstWeekDay)firstWeekDay {
    
    NSInteger days = [self numberOfDays:year month:month];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.firstWeekday = firstWeekDay;
    NSDateComponents *components = [calendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    components.year = year;
    components.month = month;
    components.day = days;
    
    NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit|NSWeekOfMonthCalendarUnit fromDate:[calendar dateFromComponents:components]];
    
    return (NSInteger)comps.weekOfMonth;
}

+ (NSInteger) numberOfDaysForFirstWeekPrefix:(NSInteger)year month:(NSInteger)month firstWeekDay:(HaloFirstWeekDay)firstWeekDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    components.year = year;
    components.month = month;
    components.day = 1;
    
    NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:[calendar dateFromComponents:components]];
    
    // 周日为1，周一为2，周二为3，周三为4，周四为5，周五为6，周六为7
    NSInteger day = (NSInteger)[comps weekday] - firstWeekDay;
    if (day < 0)
    {
        day += 7;
    }
    return day;
}

+ (NSString *) weekNameForDate:(NSDate *)date
{
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
    NSArray *array = [self getWeekFullNamesArray];
    if (comps.weekday < array.count)
    {
        return array[comps.weekday - 1];
    }
    return @"";
}

+ (NSInteger) numberOfDaysForLastWeekSuffix:(NSInteger)year month:(NSInteger)month firstWeekDay:(HaloFirstWeekDay)firstWeekDay {
    return [self numberOfWeeks:year month:month firstWeekDay:firstWeekDay]*7
    - [self numberOfDaysForFirstWeekPrefix:year month:month firstWeekDay:firstWeekDay]
    - [self numberOfDays:year month:month];
}

+ (float) viewTopOffset {
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)) {
        if ([UIApplication sharedApplication].statusBarHidden)
            return 0;
        else
            return 20;
    }
    
    return 0;
}

+ (NSArray *)getWeekNamesArrayByFirstWeekDay:(HaloFirstWeekDay)firstWeekDay {
    NSArray *fullTitle = [self getWeekFullNamesArrayByFirstWeekDay:firstWeekDay];
    NSMutableArray *ret = [NSMutableArray array];
    [fullTitle enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [ret addObject:[obj substringFromIndex:1]];
    }];
    return  ret;
}

+ (NSArray *)getWeekFullNamesArray
{
    return [self getWeekFullNamesArrayByFirstWeekDay:EHaloFirstWeekDaySunday];
}

+ (NSArray *)getWeekFullNamesArrayByFirstWeekDay:(HaloFirstWeekDay)firstWeekDay
{
    switch (firstWeekDay) {
        case EHaloFirstWeekDayMonday:
        {
            return @[
                     NSLocalizedStringFromTable(@"week_monday", @"Calendar", nil),
                     NSLocalizedStringFromTable(@"week_tusday", @"Calendar", nil),
                     NSLocalizedStringFromTable(@"week_wednesday", @"Calendar", nil),
                     NSLocalizedStringFromTable(@"week_thursday", @"Calendar", nil),
                     NSLocalizedStringFromTable(@"week_friday", @"Calendar", nil),
                     NSLocalizedStringFromTable(@"week_saturday", @"Calendar", nil),
                     NSLocalizedStringFromTable(@"week_sunday", @"Calendar", nil),
                     ];
            break;
        }
        case EHaloFirstWeekDaySunday:
        default:
        {
            return @[
                     NSLocalizedStringFromTable(@"week_sunday", @"Calendar", nil),
                     NSLocalizedStringFromTable(@"week_monday", @"Calendar", nil),
                     NSLocalizedStringFromTable(@"week_tusday", @"Calendar", nil),
                     NSLocalizedStringFromTable(@"week_wednesday", @"Calendar", nil),
                     NSLocalizedStringFromTable(@"week_thursday", @"Calendar", nil),
                     NSLocalizedStringFromTable(@"week_friday", @"Calendar", nil),
                     NSLocalizedStringFromTable(@"week_saturday", @"Calendar", nil),
                     ];
            break;
        }
    }
    
}

+ (NSTimeInterval)getDateBeginTimeInterval:(NSDate *)date
{
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    comps.hour = 0;
    NSDate *newDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    return [newDate timeIntervalSince1970];
}

+ (NSTimeInterval)getDateMidTimeInterval:(NSDate *)date
{
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    comps.hour = 12;
    NSDate *newDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    return [newDate timeIntervalSince1970];
}

+ (NSTimeInterval)getDateEndTimeInterval:(NSDate *)date
{
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    comps.hour = 24;
    NSDate *newDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    return [newDate timeIntervalSince1970];
}

+ (NSDate *) dateWith:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    comps.year = year;
    comps.month = month;
    comps.day = day;
    comps.hour = 0;
    
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

+ (NSDate *) firstWeekDate:(HaloFirstWeekDay)firstWeekDay withDate:(NSDate *)date {
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
    // 周日为1，周一为2，周二为3，周三为4，周四为5，周五为6，周六为7
    
    NSInteger offsetDays = firstWeekDay-[comps weekday];
    if (offsetDays == 0)
        return date;
    else if (offsetDays > 0)
        return [self addDateOffset:offsetDays-7 byUnit:NSCalendarUnitDay toDate:date];
    else
        return [self addDateOffset:offsetDays byUnit:NSCalendarUnitDay toDate:date];
}

+ (NSInteger) currentYear {
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    
    return comps.year;
}

+ (BOOL) isCurrentMonth:(NSInteger)year month:(NSInteger)month {
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    
    return (year == comps.year && month == comps.month);
}

+ (BOOL) isCurrentDay:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    
    return (year == comps.year && month == comps.month && day == comps.day);
}

+ (BOOL)isCurrentDayWithDate:(NSDate *)curDate
{
    return [self isDateEqual:curDate compareDate:[NSDate date] unit:NSCalendarUnitDay];
}


+ (BOOL) isDateEqual:(NSDate *)date compareDate:(NSDate *)comDate unit:(NSCalendarUnit)unit
{
    if (date == nil || comDate == nil)
    {
        return NO;
    }
    if ([[NSCalendar currentCalendar] respondsToSelector:@selector(isDate:equalToDate:toUnitGranularity:)])
    {
        return [[NSCalendar currentCalendar] isDate:date equalToDate:comDate toUnitGranularity:unit];
    }
    else
    {
        NSDateComponents *comp1 = [self dayComponents:date];
        NSDateComponents *comp2 = [self dayComponents:comDate];
        
        switch (unit) {
            case NSCalendarUnitYear:
            {
                return comp1.year == comp2.year;
                break;
            }
            case NSCalendarUnitMonth:
            {
                return comp1.year == comp2.year && comp1.month == comp2.month;
                break;
            }
            default:
            {
                return comp1.year == comp2.year && comp1.month == comp2.month && comp1.day == comp2.day;
                break;
            }
        }
    }
}


+ (NSDateComponents *) dayComponents:(NSDate *)date {
    return [[NSCalendar currentCalendar] components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ) fromDate:date];
}

+ (NSDateComponents *) dateComponents:(NSDate *)date
{
    return [[NSCalendar currentCalendar] components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
}

+ (NSDateComponents *) weekComponents:(NSDate *)date
{
    return [[NSCalendar currentCalendar] components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekdayCalendarUnit) fromDate:date];
}

+ (NSDateComponents *) addMonth:(NSInteger)year month:(NSInteger)month offset:(NSInteger)offset {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.month = offset;
    
    NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:[self dateWith:year month:month day:1] options:0];
    
    return [self dateComponents:date];
}

+ (NSDate *) calStartDate:(NSDate *)date {
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    return [self dateWith:comps.year month:comps.month day:comps.day];
}

+ (NSDate *) calEndDate:(NSDate *)date {
    return [self calStartDate:[self addDateOffset:1 byUnit:NSCalendarUnitDay toDate:date]];
}

+ (NSDate *) addDateOffset:(NSInteger)offset byUnit:(NSCalendarUnit)unit toDate:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    switch (unit) {
        case NSCalendarUnitYear:
            comps.year = offset;
            break;
            
        case NSCalendarUnitMonth:
            comps.month = offset;
            break;
            
        case NSCalendarUnitDay:
            comps.day = offset;
            break;
            
        case NSCalendarUnitHour:
            comps.hour = offset;
            break;
            
        case NSCalendarUnitMinute:
            comps.minute = offset;
            break;
            
        case NSCalendarUnitSecond:
            comps.second = offset;
            break;
            
        default: break;
    }
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:date options:0];
}

+ (NSInteger) dateCompare:(NSDate *)date1 to:(NSDate *)date2 {
    if (date1 == nil && date2 == nil) return 0;
    if (date1 == nil) return 1;
    if (date2 == nil) return -1;
    
    // 1:gt 0:eq -1:lt
    NSDateComponents *comps1 = [self dayComponents:date1];
    NSDateComponents *comps2 = [self dayComponents:date2];
    
    if (comps1.year<comps2.year) return -1;
    if (comps1.year>comps2.year) return 1;
    
    if (comps1.month<comps2.month) return -1;
    if (comps1.month>comps2.month) return 1;
    
    if (comps1.day<comps2.day) return -1;
    if (comps1.day>comps2.day) return 1;
    
    return 0;
}

//new

+ (BOOL)compareDate:(NSDate *)firstDate date:(NSDate *)secDate unit:(NSCalendarUnit)unit
{
    NSDateComponents *comFir = [self dateComponents:firstDate];
    NSDateComponents *comSec = [self dateComponents:secDate];
    switch (unit) {
        case NSCalendarUnitYear: {
            return comFir.year == comSec.year;
            break;
        }
        case NSCalendarUnitMonth: {
            return comFir.year == comSec.year && comFir.month == comSec.month;
            break;
        }
        case NSCalendarUnitDay: {
            return comFir.year == comSec.year
            && comFir.month == comSec.month
            && comFir.day == comSec.day;
            break;
        }
        case NSCalendarUnitHour: {
            return comFir.year == comSec.year
            && comFir.month == comSec.month
            && comFir.day == comSec.day
            && comFir.hour == comSec.hour;
            break;
        }
        case NSCalendarUnitMinute: {
            return comFir.year == comSec.year
            && comFir.month == comSec.month
            && comFir.day == comSec.day
            && comFir.hour == comSec.hour
            && comFir.minute == comSec.minute;
            break;
        }
        case NSCalendarUnitSecond: {
            return comFir.year == comSec.year
            && comFir.month == comSec.month
            && comFir.day == comSec.day
            && comFir.hour == comSec.hour
            && comFir.minute == comSec.minute
            && comFir.second == comSec.second;
            break;
        }
        default: {
            return NO;
            break;
        }
    }
}
@end
