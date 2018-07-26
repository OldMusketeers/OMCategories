//
//  NSObject+Halo.m
//  HaloSlimFramework
//
//  Created by Jet on 16/1/21.
//
//

#import "NSObject+Halo.h"
#import <objc/runtime.h>

@implementation NSObject (Halo)

+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}

+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel {
    Class class = object_getClass(self);
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originalMethod || !newMethod) return NO;
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}

+ (NSString *)className {
    return NSStringFromClass(self);
}

- (NSString *)className {
    return [NSString stringWithUTF8String:class_getName([self class])];
}

@end


@implementation NSObject (CancelableScheduledBlock)

- (void)delayedAddOperation:(NSOperation *)operation
{
    [[NSOperationQueue currentQueue] addOperation:operation];
}

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(delayedAddOperation:)
               withObject:[NSBlockOperation blockOperationWithBlock:block]
               afterDelay:delay];
}

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay cancelPreviousRequest:(BOOL)cancel
{
    if (cancel)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    [self performBlock:block afterDelay:delay];
}

@end