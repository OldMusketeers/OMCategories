//
//  UIColor+Halo.h
//  HaloSlimFramework
//
//  Created by Jet on 16/1/22.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (Halo)

#pragma mark - Create color
+ (UIColor *)colorWithRGB:(uint32_t)rgbValue;

+ (UIColor *)colorWithRGBA:(NSUInteger)color;

+ (UIColor *)randomColor;

/**
 Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 The `#` or "0x" sign is not required.
 The alpha will be set to 1.0 if there is no alpha component.
 It will return nil when an error occurs in parsing.
 
 Example: @"0xF0F", @"66ccff", @"#66CCFF88"
 */
+ (UIColor *)colorWithString:(NSString *)string;

+ (UIColor *)systemBlue;

#pragma mark - Get color's description
/**
  hex value of RGB,such as 0x66ccff.
 */
- (uint32_t)rgbValue;

/**
  hex value of RGBA,such as 0x66ccffff.
 */
- (uint32_t)rgbaValue;

- (NSString *)hexString;
- (NSString *)hexStringWithAlpha;
@end
