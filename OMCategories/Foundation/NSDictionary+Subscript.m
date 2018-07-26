//
//  NSDictionary+Subscript.m
//  Hunter
//
//  Created by Jet on 16/4/22.
//  Copyright © 2016年 Hollo. All rights reserved.
//

#import "NSDictionary+Subscript.h"

@implementation NSDictionary (Subscript)

- (id)objectForKeyedSubscript:(id)key
{
    return [self objectForKey:key];
}

@end
