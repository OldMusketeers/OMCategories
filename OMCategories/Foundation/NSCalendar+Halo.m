//
//  NSCalendar+Halo.m
//  Pods
//
//  Created by Jet on 16/9/7.
//
//

#import "NSCalendar+Halo.h"

@implementation NSCalendar (Halo)

+ (NSCalendar *)defaultHLCalendar
{
    static id staticObj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticObj = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [staticObj setTimeZone:[NSTimeZone systemTimeZone]];
    });
    return staticObj;
}

@end
