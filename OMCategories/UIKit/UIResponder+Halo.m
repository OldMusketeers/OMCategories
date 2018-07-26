//
//  UIResponder+Halo.m
//  HaloSlimFramework
//
//  Created by Jet on 16/1/24.
//
//

#import "UIResponder+Halo.h"

@implementation UIResponder (Halo)
static __weak UIResponder *currentFirstResponder;

+(id)currentFirstResponder
{
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

-(void)findFirstResponder:(id)sender
{
    currentFirstResponder = self;
}

@end
