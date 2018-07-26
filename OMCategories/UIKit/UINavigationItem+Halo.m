//
//  UINavigationItem+Halo.m
//  HaloSlimFramework
//
//  Created by Jet on 16/1/24.
//
//

#import "UINavigationItem+Halo.h"
#import <objc/runtime.h>

@implementation UINavigationItem (Halo)

- (BOOL)isIOS7
{
    return ([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] != NSOrderedAscending && [[[UIDevice currentDevice] systemVersion] compare:@"11" options:NSNumericSearch] == NSOrderedAscending);
}

- (UIBarButtonItem *)spacer
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -4;
    return space;
}

- (void)mk_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    if ([self isIOS7] && leftBarButtonItem.customView) {
        [self mk_setLeftBarButtonItem:nil];
        [self mk_setLeftBarButtonItems:@[[self spacer], leftBarButtonItem]];
    } else {
        if ([self isIOS7]) {
            [self mk_setLeftBarButtonItems:nil];
        }
        [self mk_setLeftBarButtonItem:leftBarButtonItem];
    }
}

- (void)mk_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem animated:(BOOL)animated
{
    if ([self isIOS7] && leftBarButtonItem.customView)
    {
        [self mk_setLeftBarButtonItem:nil animated:animated];
        [self mk_setLeftBarButtonItems:@[[self spacer], leftBarButtonItem] animated:animated];
    } else {
        if ([self isIOS7]) {
            [self mk_setLeftBarButtonItems:nil animated:animated];
        }
        [self mk_setLeftBarButtonItem:leftBarButtonItem animated:animated];
    }
}

- (void)mk_setLeftBarButtonItems:(NSArray *)leftBarButtonItems
{
    if ([self isIOS7] && leftBarButtonItems && leftBarButtonItems.count > 0) {
        
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:leftBarButtonItems.count + 1];
        [items addObject:[self spacer]];
        [items addObjectsFromArray:leftBarButtonItems];
        
        [self mk_setLeftBarButtonItems:items];
    } else {
        [self mk_setLeftBarButtonItems:leftBarButtonItems];
    }
}

- (void)mk_setLeftBarButtonItems:(NSArray *)leftBarButtonItems animated:(BOOL)animated
{
    if ([self isIOS7] && leftBarButtonItems && leftBarButtonItems.count > 0) {
        
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:leftBarButtonItems.count + 1];
        [items addObject:[self spacer]];
        [items addObjectsFromArray:leftBarButtonItems];
        
        [self mk_setLeftBarButtonItems:items animated:animated];
    } else {
        [self mk_setLeftBarButtonItems:leftBarButtonItems animated:animated];
    }
}

- (void)mk_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    if ([self isIOS7] && rightBarButtonItem.customView) {
        [self mk_setRightBarButtonItem:nil];
        
        // Fix position issue in system vc, eg. cancel button in UIImagePickerController
        if (rightBarButtonItem.customView) {
            [self mk_setRightBarButtonItems:@[[self spacer], rightBarButtonItem]];
        } else {
            [self mk_setRightBarButtonItem:rightBarButtonItem];
        }
    } else {
        if ([self isIOS7]) {
            [self mk_setRightBarButtonItems:nil];
        }
        [self mk_setRightBarButtonItem:rightBarButtonItem];
    }
}

- (void)mk_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem animated:(BOOL)animated
{
    if ([self isIOS7] && rightBarButtonItem.customView) {
        [self mk_setRightBarButtonItem:nil];
        
        // Fix position issue in system vc, eg. cancel button in UIImagePickerController
        if (rightBarButtonItem.customView) {
            [self mk_setRightBarButtonItems:@[[self spacer], rightBarButtonItem] animated:animated];
        } else {
            [self mk_setRightBarButtonItem:rightBarButtonItem animated:animated];
        }
    } else {
        if ([self isIOS7]) {
            [self mk_setRightBarButtonItems:nil animated:animated];
        }
        [self mk_setRightBarButtonItem:rightBarButtonItem animated:animated];
    }
}

- (void)mk_setRightBarButtonItems:(NSArray *)rightBarButtonItems
{
    if ([self isIOS7] && rightBarButtonItems && rightBarButtonItems.count > 0) {
        
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:rightBarButtonItems.count + 1];
        [items addObject:[self spacer]];
        [items addObjectsFromArray:rightBarButtonItems];
        
        [self mk_setRightBarButtonItems:items];
    } else {
        [self mk_setRightBarButtonItems:rightBarButtonItems];
    }
}

- (void)mk_setRightBarButtonItems:(NSArray *)rightBarButtonItems animated:(BOOL)animated
{
    if ([self isIOS7] && rightBarButtonItems && rightBarButtonItems.count > 0) {
        
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:rightBarButtonItems.count + 1];
        [items addObject:[self spacer]];
        [items addObjectsFromArray:rightBarButtonItems];
        
        [self mk_setRightBarButtonItems:items animated:animated];
    } else {
        [self mk_setRightBarButtonItems:rightBarButtonItems animated:animated];
    }
}

+ (void)mk_swizzle:(SEL)aSelector
{
    SEL bSelector = NSSelectorFromString([NSString stringWithFormat:@"mk_%@", NSStringFromSelector(aSelector)]);
    
    Method m1 = class_getInstanceMethod(self, aSelector);
    Method m2 = class_getInstanceMethod(self, bSelector);
    
    method_exchangeImplementations(m1, m2);
}

+ (void)load
{
    [self mk_swizzle:@selector(setLeftBarButtonItem:)];
    [self mk_swizzle:@selector(setLeftBarButtonItems:)];
    [self mk_swizzle:@selector(setLeftBarButtonItem:animated:)];
    [self mk_swizzle:@selector(setLeftBarButtonItems:animated:)];
    
    [self mk_swizzle:@selector(setRightBarButtonItem:)];
    [self mk_swizzle:@selector(setRightBarButtonItems:)];
    [self mk_swizzle:@selector(setRightBarButtonItem:animated:)];
    [self mk_swizzle:@selector(setRightBarButtonItems:animated:)];
}


@end
