//
//  NSArray+Halo.m
//  HaloSlimFramework
//
//  Created by Jet on 16/1/21.
//
//

#import "NSArray+Halo.h"

@implementation NSArray (Halo)

+ (NSArray *)arrayByFilteringArray:(NSArray *)source predictBlock:(BOOL (^)(id))predictBlock
{
    if (source.count == 0)
    {
        return nil;
    }
    
    NSMutableArray *result = [NSMutableArray array];
    id element;
    for(element in result)
    {
        if (predictBlock(element) == YES)
        {
            [result addObject:element];
        }
    }
    
    return result;
}

- (id)objectOrNilAtIndex:(NSUInteger)index {
    return index < self.count ? self[index] : nil;
}

- (NSString *)jsonStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

- (NSString *)jsonPrettyStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}


@end


@implementation NSMutableArray (Halo)

- (void)removeFirstObject;
{
    if (self.count)
    {
        [self removeObjectAtIndex:0];
    }
}

- (void)removeLastObject;
{
    if (self.count)
    {
        [self removeObjectAtIndex:self.count - 1];
    }
}

- (void)insertObjects:(NSArray *)objects atIndex:(NSUInteger)index;
{
    NSUInteger i = index;
    for (id obj in objects)
    {
        [self insertObject:obj atIndex:i++];
    }
}

- (void)insertObjects:(NSArray*)array
{
    NSRange range = NSMakeRange(0, [array count]);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self insertObjects:array atIndexes:indexSet];
}

- (void)insertObjectSafely:(id)anObject atIndex:(NSUInteger)index;
{
    if (index < self.count)
    {
        [self insertObject:anObject atIndex:index];
    }
    else
    {
        [self addObject:anObject];
    }
}

- (void)addObjectSafely:(id)obj
{
    if (obj)
    {
        [self addObject:obj];
    }
}


@end