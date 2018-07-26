//
//  UIWindow+Resign.m
//  HaloSlimFramework
//
//  Created by Chengwen.Y on 16/7/14.
//
//

#import "UIWindow+Resign.h"
#import <objc/runtime.h>

@implementation UIWindow (Resign)

- (BOOL)willResign
{
    NSNumber *boolNum = objc_getAssociatedObject(self, @selector(willResign));
    return boolNum.boolValue;
}

- (void)setWillResign:(BOOL)willResign
{
    objc_setAssociatedObject(self, @selector(willResign), @(willResign), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
