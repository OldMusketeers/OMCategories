//
//  UIGestureRecognizer+Halo.h
//  HaloSlimFramework
//
//  Created by Jet on 16/1/24.
//
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (Halo)

- (instancetype)initWithActionBlock:(void (^)(id sender))block;

- (void)addActionBlock:(void (^)(id sender))block;

- (void)removeAllActionBlocks;

@end
