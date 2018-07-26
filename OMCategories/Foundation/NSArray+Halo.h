//
//  NSArray+Halo.h
//  HaloSlimFramework
//
//  Created by Jet on 16/1/21.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (Halo)
/**
 filter array
 */
+ (NSArray *)arrayByFilteringArray:(NSArray *)source predictBlock:(BOOL(^)(id obj))predictBlock;

/**
 Returns the object located at index, or return nil when out of bounds.
 It's similar to `objectAtIndex:`, but it never throw exception.
 
 @param index The object located at index.
 */
- (id)objectOrNilAtIndex:(NSUInteger)index;

/**
 Convert object to json string. return nil if an error occurs.
 NSString/NSNumber/NSDictionary/NSArray
 */
- (NSString *)jsonStringEncoded;

/**
 Convert object to json string formatted. return nil if an error occurs.
 */
- (NSString *)jsonPrettyStringEncoded;
@end

@interface NSMutableArray (Halo)

- (void)removeFirstObject;
- (void)removeLastObject;

- (void)insertObjects:(NSArray *)objects atIndex:(NSUInteger)index;
- (void)insertObjects:(NSArray*)array;

- (void)insertObjectSafely:(id)anObject atIndex:(NSUInteger)index;
- (void)addObjectSafely:(id)obj;


@end
