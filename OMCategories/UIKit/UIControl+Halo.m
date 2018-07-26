//
//  UIControl+Halo.m
//  HaloSlimFramework
//
//  Created by Jet on 16/1/24.
//
//

#import "UIControl+Halo.h"
#import <objc/runtime.h>

static const int block_key;

@interface _UIControlBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);
@property (nonatomic, assign) UIControlEvents events;

- (id)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events;
- (void)invoke:(id)sender;

@end

@implementation _UIControlBlockTarget

- (id)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events {
    self = [super init];
    if (self) {
        _block = [block copy];
        _events = events;
    }
    return self;
}

- (void)invoke:(id)sender {
    if (_block) _block(sender);
}

@end

@implementation UIControl (Halo)

- (void)removeAllTargets
{
    [[self allTargets] enumerateObjectsUsingBlock: ^(id object, BOOL *stop) {
        [self removeTarget:object action:NULL forControlEvents:UIControlEventAllEvents];
    }];
    [[self _allUIControlBlockTargets] removeAllObjects];
}

- (void)setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    if (!target || !action || !controlEvents) return;
    NSSet *targets = [self allTargets];
    for (id currentTarget in targets) {
        NSArray *actions = [self actionsForTarget:currentTarget forControlEvent:controlEvents];
        for (NSString *currentAction in actions) {
            [self removeTarget:currentTarget action:NSSelectorFromString(currentAction)
              forControlEvents:controlEvents];
        }
    }
    [self addTarget:target action:action forControlEvents:controlEvents];
}

- (void)addMutiBlock:(void (^)(id sender))block forControlEvents:(UIControlEvents)controlEvents;
{
    if (!controlEvents) return;
    _UIControlBlockTarget *target = [[_UIControlBlockTarget alloc]
                                     initWithBlock:block events:controlEvents];
    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
    NSMutableArray *targets = [self _allUIControlBlockTargets];
    [targets addObject:target];
}

- (void)addBlock:(void (^)(id))block forControlEvents:(UIControlEvents)controlEvents
{
    [self setBlock:block forControlEvents:controlEvents];
}

- (void)setBlock:(void (^)(id))block forControlEvents:(UIControlEvents)controlEvents
{
    [self removeAllBlocksForControlEvents:UIControlEventAllEvents];
    [self addMutiBlock:block forControlEvents:controlEvents];
}


- (void)removeAllBlocksForControlEvents:(UIControlEvents)controlEvents
{
    NSMutableArray *targets = [self _allUIControlBlockTargets];
    NSMutableArray *removes = [NSMutableArray array];
    for (_UIControlBlockTarget *target in targets) {
        if (target.events & controlEvents) {
            UIControlEvents newEvent = target.events & (~controlEvents);
            if (newEvent) {
                [self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
                target.events = newEvent;
                [self addTarget:target action:@selector(invoke:) forControlEvents:target.events];
            } else {
                [self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
                [removes addObject:target];
            }
        }
    }
    [targets removeObjectsInArray:removes];
}

- (NSMutableArray *)_allUIControlBlockTargets {
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
