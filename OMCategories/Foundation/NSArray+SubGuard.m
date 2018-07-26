//
//  NSArray+SubGuard.m
//  TestArray2
//
//  Created by Jet on 2017/9/26.
//  Copyright © 2017年 MegFace. All rights reserved.
//

#import "NSArray+SubGuard.h"
#import <objc/runtime.h>

@implementation NSArray (SubGuard)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //替换 objectAtIndex
        NSString *objAtIndex = @"objectAtIndex:";
        [self swizzleMethod:@"__NSArray0" originalMethodStr:objAtIndex newMethodStr:@"safe_zeroObjectAtIndex:"];
        [self swizzleMethod:@"__NSSingleObjectArrayI" originalMethodStr:objAtIndex newMethodStr:@"safe_singleObjectAtIndex:"];
        [self swizzleMethod:@"__NSArrayI" originalMethodStr:objAtIndex newMethodStr:@"safe_objectAtIndex:"];
//        [self swizzleMethod:@"__NSArrayM" originalMethodStr:objAtIndex newMethodStr:@"safe_mObjectAtIndex:"];
        
        NSString *subscript = @"objectAtIndexedSubscript:";
        [self swizzleMethod:@"__NSArray0" originalMethodStr:subscript newMethodStr:@"safe_zeroObjectAtIndexedSubscript:"];
        [self swizzleMethod:@"__NSSingleObjectArrayI" originalMethodStr:subscript newMethodStr:@"safe_singleObjectAtIndexedSubscript:"];
        [self swizzleMethod:@"__NSArrayI" originalMethodStr:subscript newMethodStr:@"safe_objectAtIndexedSubscript:"];
        [self swizzleMethod:@"__NSArrayM" originalMethodStr:subscript newMethodStr:@"safe_mObjectAtIndexedSubscript:"];
        
//        NSString *setSubscript = @"setObject:atIndexedSubscript:";
//        [self swizzleMethod:@"__NSArrayM" originalMethodStr:setSubscript newMethodStr:@"safe_mSetObject:atIndexedSubscript:"];
        
        
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

#pragma mark- ObjectAtIndex
- (id)safe_objectAtIndex:(NSUInteger)index {
    if (index < self.count){
        return [self safe_objectAtIndex:index];
    }
    return nil;
}


- (id)safe_mObjectAtIndex:(NSInteger)index{
    if (index < self.count){
        return [self safe_mObjectAtIndex:index];
    }
    return nil;
}

- (id)safe_singleObjectAtIndex:(NSUInteger)index {
    if (index < self.count){
        return [self safe_singleObjectAtIndex:index];
    }
    return nil;
}

- (id)safe_zeroObjectAtIndex:(NSUInteger)index {
    return nil;
}

#pragma mark- objectAtIndexedSubscript
- (id)safe_objectAtIndexedSubscript:(NSUInteger)index{
    if (index < self.count){
        return [self safe_objectAtIndex:index];
    }
    return nil;
}

- (id)safe_singleObjectAtIndexedSubscript:(NSUInteger)index{
    if (index < self.count){
        return [self safe_singleObjectAtIndex:index];
    }
    return nil;
}

- (id)safe_mObjectAtIndexedSubscript:(NSUInteger)index{
    if (index < self.count){
        return [self safe_mObjectAtIndex:index];
    }
    return nil;
}

- (id)safe_zeroObjectAtIndexedSubscript:(NSUInteger)index{
    return  nil;
}


 
@end
