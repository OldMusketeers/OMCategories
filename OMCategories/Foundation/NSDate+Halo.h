//
//  NSDate+Halo.h
//  HaloSlimFramework
//
//  Created by Jet on 16/1/21.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,HaloFirstWeekDay)  {
    EHaloFirstWeekDaySunday = 1,
    EHaloFirstWeekDayMonday = 2,
};

@interface NSDate (Halo)
@property(strong)NSDateFormatter *hlDataFormater;
@property(strong)NSCalendar *hlCalender;

//从毫秒生成时间
+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond;

+ (NSDate *)dateFromString:(NSString *)string;

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

- (NSDateComponents *)dateComponents;

//formatterString=HH:mm
- (NSString *)formate:(NSString *)formatterString;

#pragma mark- Utils

//是否为闰年
+ (BOOL) isLeapYear:(NSInteger)year;

//获取日期天数
+ (NSInteger)numberOfDays:(NSInteger)year month:(NSInteger)month;
+ (NSInteger)numberOfWeeks:(NSInteger)year month:(NSInteger)month firstWeekDay:(HaloFirstWeekDay)firstWeekDay;
+ (NSInteger)numberOfDaysForFirstWeekPrefix:(NSInteger)year month:(NSInteger)month firstWeekDay:(HaloFirstWeekDay)firstWeekDay;
+ (NSInteger)numberOfDaysForLastWeekSuffix:(NSInteger)year month:(NSInteger)month firstWeekDay:(HaloFirstWeekDay)firstWeekDay;

+ (NSDate *)dateWith:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate *)firstWeekDate:(HaloFirstWeekDay)firstWeekDay withDate:(NSDate *)date;

+ (NSInteger)currentYear;

//compare
+ (BOOL)isCurrentMonth:(NSInteger)year month:(NSInteger)month;
+ (BOOL)isCurrentDay:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (BOOL)isCurrentDayWithDate:(NSDate *)curDate;

+ (BOOL) isDateEqual:(NSDate *)date compareDate:(NSDate *)comDate unit:(NSCalendarUnit)unit;
+ (NSInteger) dateCompare:(NSDate *)date1 to:(NSDate *)date2; // 1:gt 0:eq -1:lt

//components
+ (NSDateComponents *)dateComponents:(NSDate *)date;
+ (NSDateComponents *)weekComponents:(NSDate *)date;
+ (NSDateComponents *)addMonth:(NSInteger)year month:(NSInteger)month offset:(NSInteger)offset;

+ (NSDate *)calStartDate:(NSDate *)date;
+ (NSDate *)calEndDate:(NSDate *)date;
+ (NSDate *)addDateOffset:(NSInteger)offset byUnit:(NSCalendarUnit)unit toDate:(NSDate *)date;

+ (NSArray *)getWeekFullNamesArrayByFirstWeekDay:(HaloFirstWeekDay)firstWeekDay;

+ (NSArray *)getWeekNamesArrayByFirstWeekDay:(HaloFirstWeekDay)firstWeekDay;

+ (NSTimeInterval)getDateBeginTimeInterval:(NSDate *)date;

+ (NSTimeInterval)getDateMidTimeInterval:(NSDate *)date;

+ (NSTimeInterval)getDateEndTimeInterval:(NSDate *)date;

@end
