//
//  NSObject+HaloForARC.h
//  HaloSlimFramework
//
//  Created by Jet on 16/1/22.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (HaloForARC)

/// Same as `retain`
- (instancetype)arcDebugRetain;

/// Same as `release`
- (oneway void)arcDebugRelease;

/// Same as `autorelease`
- (instancetype)arcDebugAutorelease;

/// Same as `retainCount`
- (NSUInteger)arcDebugRetainCount;

@end
