//
//  NSMutableArray+SubGuard.m
//  TestArray2
//
//  Created by Jet on 2018/1/9.
//  Copyright © 2018年 MegFace. All rights reserved.
//

#import "NSMutableArray+SubGuard.h"
#import <objc/runtime.h>

@implementation NSMutableArray (SubGuard)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@"__NSArrayM" originalMethodStr:@"insertObject:atIndex:" newMethodStr:@"safe_mInsertObject:atIndex:"];
        [self swizzleMethod:@"__NSArrayM" originalMethodStr:@"objectAtIndex:" newMethodStr:@"safe_mObjectAtIndex:"];
        [self swizzleMethod:@"__NSArrayM" originalMethodStr:@"removeObjectAtIndex:" newMethodStr:@"safe_mRemoveObjectAtIndex:"];
        [self swizzleMethod:@"__NSArrayM" originalMethodStr:@"replaceObjectAtIndex:withObject:" newMethodStr:@"safe_mReplaceObjectAtIndex:withObject:"];
    });
}

+ (void)swizzleMethod:(NSString *)class originalMethodStr:(NSString *)origin newMethodStr:(NSString *)new{
    Class theClass = NSClassFromString(class);
    SEL originSel = NSSelectorFromString(origin);
    SEL newSel = NSSelectorFromString(new);
    
    Method originalMethod = class_getInstanceMethod(theClass, originSel);
    Method swizzledMethod = class_getInstanceMethod(theClass, newSel);
    
    BOOL didAddMethod = class_addMethod(theClass,
                                        originSel,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(theClass,
                            newSel,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


- (id)safe_mObjectAtIndex:(NSInteger)index{
    if (index < self.count){
        return [self safe_mObjectAtIndex:index];
    }
    return nil;
}

- (void)safe_mRemoveObjectAtIndex:(NSUInteger)index{
    if(index > self.count)
    {
        return;
    }
    [self safe_mRemoveObjectAtIndex:index];
 
}

- (void)safe_mReplaceObjectAtIndex:(NSUInteger)index withObject:(id)obj{
    if(obj == nil || index > self.count)
    {
        return;
    }
    [self safe_mReplaceObjectAtIndex:index withObject:obj];
    
}

#pragma mark- insertObject:atIndex

- (void)safe_mInsertObject:(id)obj atIndex:(NSUInteger)index
{
    if(obj == nil || index > self.count)
    {
        return;
    }
    [self safe_mInsertObject:obj atIndex:index];
}

#pragma mark- setObject:atIndexedSubscript

- (void)safe_mSetObject:(id)obj atIndexedSubscript:(NSUInteger)index
{
    if(obj == nil || index > self.count)
    {
        return;
    }
    [self safe_mSetObject:obj atIndexedSubscript:index];
}

@end
