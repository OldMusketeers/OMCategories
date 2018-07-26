//
//  UIColor+Halo.m
//  HaloSlimFramework
//
//  Created by Jet on 16/1/22.
//
//

#import "UIColor+Halo.h"

@implementation UIColor (Halo)

+ (UIColor *)colorWithRGB:(uint32_t)rgbValue {
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:1];
}

+ (UIColor*)colorWithRGBA:(NSUInteger)color
{
    return [UIColor colorWithRed:((color>>24)&0xFF)/255.0
                           green:((color>>16)&0xFF)/255.0
                            blue:((color>>8)&0xFF)/255.0
                           alpha:((color)&0xFF)/255.0];
}


+ (UIColor *)colorWithString:(NSString *)string
{
    NSInteger c = 0;
    sscanf([string UTF8String], "%llu", (unsigned long long *)&c);
    return [UIColor colorWithRGBA:c];
}




+ (UIColor *)systemBlue
{
    UIColor *btnFontColor = [UIColor colorWithRed:0 green:126.0/255 blue:245.0/255 alpha:1];
    return btnFontColor;
}


- (uint32_t)rgbValue {
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    int8_t red = r * 255;
    uint8_t green = g * 255;
    uint8_t blue = b * 255;
    return (red << 16) + (green << 8) + blue;
}

- (uint32_t)rgbaValue {
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    int8_t red = r * 255;
    uint8_t green = g * 255;
    uint8_t blue = b * 255;
    uint8_t alpha = a * 255;
    return (red << 24) + (green << 16) + (blue << 8) + alpha;
}

- (NSString *)hexString
{
//    const CGFloat *components = CGColorGetComponents(self.CGColor);
//    int red = (int)(components[0] * 255);
//    int green = (int)(components[1] * 255);
//    int blue = (int)(components[2] * 255);
//    //    int alpha = (int)(components[3] * 255);
//    return [NSString stringWithFormat:@"#%0.2X%0.2X%0.2X", red, green, blue];
    return [self hexStringWithAlpha:NO];
}

- (NSString *)hexStringWithAlpha {
    return [self hexStringWithAlpha:YES];
}

- (NSString *)hexStringWithAlpha:(BOOL)withAlpha {
    CGColorRef color = self.CGColor;
    size_t count = CGColorGetNumberOfComponents(color);
    const CGFloat *components = CGColorGetComponents(color);
    static NSString *stringFormat = @"#%02x%02x%02x";
    NSString *hex = nil;
    if (count == 2) {
        NSUInteger white = (NSUInteger)(components[0] * 255.0f);
        hex = [NSString stringWithFormat:stringFormat, white, white, white];
    } else if (count == 4) {
        hex = [NSString stringWithFormat:stringFormat,
               (NSUInteger)(components[0] * 255.0f),
               (NSUInteger)(components[1] * 255.0f),
               (NSUInteger)(components[2] * 255.0f)];
    }
    
    if (hex && withAlpha) {
        hex = [hex stringByAppendingFormat:@"%02lx",
               (unsigned long)(self.alpha * 255.0 + 0.5)];
    }
    return hex;
}

- (CGFloat)alpha {
    return CGColorGetAlpha(self.CGColor);
}

+ (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}
@end
