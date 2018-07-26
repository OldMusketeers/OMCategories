//
//  NSDateFormatter+Halo.m
//  Pods
//
//  Created by Jet on 16/9/7.
//
//

#import "NSDateFormatter+Halo.h"

@implementation NSDateFormatter (Halo)

+ (NSDateFormatter *)defaultHLFormatter
{
    static NSDateFormatter *staticFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticFormatter = [[NSDateFormatter alloc] init];
        [staticFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    });
    return staticFormatter;
}

@end
