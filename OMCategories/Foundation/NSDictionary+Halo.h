//
//  NSDictionary+Halo.h
//  HaloSlimFramework
//
//  Created by Jet on 16/1/21.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Halo)
//升序排列的key值数组
- (NSArray *)allKeysSorted;

- (NSArray *)allValuesSortedByKeys;

- (BOOL)containsObjectForKey:(id)key;

//如果keys为空或nil，返回空
- (NSDictionary *)entriesForKeys:(NSArray *)keys;

//删除null
- (NSDictionary *)removeNullValues;

- (NSString *)jsonStringEncoded;

- (NSString *)jsonPrettyStringEncoded;

#pragma mark - Dictionary Value Getter
///=============================================================================
/// @name Dictionary Value Getter
///=============================================================================

- (BOOL)boolValueForKey:(NSString *)key default:(BOOL)def;

- (char)charValueForKey:(NSString *)key default:(char)def;
- (unsigned char)unsignedCharValueForKey:(NSString *)key default:(unsigned char)def;

- (short)shortValueForKey:(NSString *)key default:(short)def;
- (unsigned short)unsignedShortValueForKey:(NSString *)key default:(unsigned short)def;

- (int)intValueForKey:(NSString *)key default:(int)def;
- (unsigned int)unsignedIntValueForKey:(NSString *)key default:(unsigned int)def;

- (long)longValueForKey:(NSString *)key default:(long)def;
- (unsigned long)unsignedLongValueForKey:(NSString *)key default:(unsigned long)def;

- (long long)longLongValueForKey:(NSString *)key default:(long long)def;
- (unsigned long long)unsignedLongLongValueForKey:(NSString *)key default:(unsigned long long)def;

- (float)floatValueForKey:(NSString *)key default:(float)def;
- (double)doubleValueForKey:(NSString *)key default:(double)def;

- (NSInteger)integerValueForKey:(NSString *)key default:(NSInteger)def;
- (NSUInteger)unsignedIntegerValueForKey:(NSString *)key default:(NSUInteger)def;

- (NSNumber *)numverValueForKey:(NSString *)key default:(NSNumber *)def;
- (NSString *)stringValueForKey:(NSString *)key default:(NSString *)def;

@end

@interface NSMutableDictionary (SafeMul)

- (void)setObjectSafe:(id)anObject forKey:(id<NSCopying>)aKey;

@end

