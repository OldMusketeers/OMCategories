//
//  UITableViewCell+Halo.m
//  Pods
//
//  Created by Jet on 16/8/19.
//
//

#import "UITableViewCell+Halo.h"

@implementation UITableViewCell (Halo)

+ (NSString *)cellIdentifier
{
    return NSStringFromClass([self class]);
}

- (void)halo_fixSeperator
{
    self.separatorInset = UIEdgeInsetsZero;
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending &&
        ([[[UIDevice currentDevice] systemVersion] compare:@"9" options:NSNumericSearch] == NSOrderedAscending))
    {
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = false; /// 只有 iOS8 需要这样
    }
}


@end
