//
//  UILabel+Halo.m
//  HaloSlimFramework
//
//  Created by Jet on 16/1/24.
//
//

#import "UILabel+Halo.h"

@implementation UILabel (Halo)

+ (UILabel *)createLabelWithFont:(UIFont *)font textColor:(UIColor *)textColor numberLine:(NSInteger)line;
{
    UILabel *label = [UILabel new];
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = line;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

@end
