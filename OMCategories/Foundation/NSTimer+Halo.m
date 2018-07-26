//
//  NSTimer+Halo.m
//  HaloSlimFramework
//
//  Created by Jet on 16/1/22.
//
//

#import "NSTimer+Halo.h"

@implementation NSTimer (Halo)
+ (void)_haloExecBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;
{
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(_haloExecBlock:) userInfo:[block copy] repeats:repeats];
}

@end
