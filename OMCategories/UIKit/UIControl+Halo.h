//
//  UIControl+Halo.h
//  HaloSlimFramework
//
//  Created by Jet on 16/1/24.
//
//

#import <UIKit/UIKit.h>

@interface UIControl (Halo)
//删掉所有的target
- (void)removeAllTargets;

//删掉其他action并设置唯一的action
- (void)setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

//添加一个block,为了兼容与setBlock一样
- (void)addBlock:(void (^)(id sender))block forControlEvents:(UIControlEvents)controlEvents;

//添加一个block
- (void)addMutiBlock:(void (^)(id sender))block forControlEvents:(UIControlEvents)controlEvents;

//删掉其他action并设置唯一的一个block
- (void)setBlock:(void (^)(id sender))block forControlEvents:(UIControlEvents)controlEvents;

//删掉所有的block
- (void)removeAllBlocksForControlEvents:(UIControlEvents)controlEvents;
@end
