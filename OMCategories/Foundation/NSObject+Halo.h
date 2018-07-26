//
//  NSObject+Halo.h
//  HaloSlimFramework
//
//  Created by Jet on 16/1/21.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (Halo)

/**
 Swap two instance method's implementation in one class. Dangerous, be careful.
 
 @param originalSel   Selector 1.
 @param newSel        Selector 2.
 @return              YES if swizzling succeed; otherwise, NO.
 */
+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;

/**
 Swap two class method's implementation in one class. Dangerous, be careful.
 
 @param originalSel   Selector 1.
 @param newSel        Selector 2.
 @return              YES if swizzling succeed; otherwise, NO.
 */
+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;

/**
 Returns the class name in NSString.
 */
+ (NSString *)className;

/**
 Returns the class name in NSString.
 
 @discussion Apple has implemented this method in NSObject(NSLayoutConstraintCallsThis),
 but did not make it public.
 */
- (NSString *)className;

@end


@interface NSObject (CancelableScheduledBlock)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay cancelPreviousRequest:(BOOL)cancel;

@end