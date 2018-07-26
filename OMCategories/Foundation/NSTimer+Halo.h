//
//  NSTimer+Halo.h
//  HaloSlimFramework
//
//  Created by Jet on 16/1/22.
//
//

#import <Foundation/Foundation.h>

@interface NSTimer (Halo)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;

@end
