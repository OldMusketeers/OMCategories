//
//  UITableViewCell+Halo.h
//  Pods
//
//  Created by Jet on 16/8/19.
//
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Halo)

+ (NSString *)cellIdentifier;

/**
 *  使cell分割线没有10像素的偏移，需要tableView.separatorInset = UIEdgeInsetsZero
 */
- (void)halo_fixSeperator;


@end
