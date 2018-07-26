//
//  NSMutableDictionary+Subscript.m
//  Hunter
//
//  Created by Jet on 16/4/22.
//  Copyright © 2016年 Hollo. All rights reserved.
//

#import "NSMutableDictionary+Subscript.h"

@implementation NSMutableDictionary (Subscript)

- (void)setObject:(id)object forKeyedSubscript:(id < NSCopying >)aKey
{
    if (object)
    {
        [self setObject:object forKey:aKey];
    }
}



@end
