//
//  UIFont+Halo.m
//  HaloSlimFramework
//
//  Created by Jet on 16/1/24.
//
//

#import "UIFont+Halo.h"
#import "NSString+Halo.h"

NSString *UI7FontAttributeNone = nil;
NSString *UI7FontAttributeUltraLight = @"UltraLight";
NSString *UI7FontAttributeUltraLightItalic = @"UltraLightItalic";
NSString *UI7FontAttributeLight = @"Light";
NSString *UI7FontAttributeLightItalic = @"LightItalic";
NSString *UI7FontAttributeMedium = @"Medium";
NSString *UI7FontAttributeItalic = @"Italic";
NSString *UI7FontAttributeBold = @"Bold";
NSString *UI7FontAttributeBoldItalic = @"BoldItalic";
NSString *UI7FontAttributeCondensedBold = @"CondensedBold";
NSString *UI7FontAttributeCondensedBlack = @"CondensedBlack";

@implementation UIFont (Halo)
+ (UIFont *)iOS7SystemFontOfSize:(CGFloat)fontSize attribute:(NSString *)attribute {
    NSString *fontName = attribute ? [@"HelveticaNeue-%@" format:attribute] : @"Helvetica Neue";
    return [UIFont fontWithName:fontName size:fontSize];
}

+ (UIFont *)lightSystemFontOfSize:(CGFloat)fontSize;
{
    return [self iOS7SystemFontOfSize:fontSize attribute:UI7FontAttributeLight];
}

+ (UIFont *)fontOfNormalSize:(CGFloat)fontSize
{
    BOOL iOS8Later = ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending);
    if (iOS8Later)
    {
        return [UIFont systemFontOfSize:fontSize];
    }
    else
    {
        return [UIFont iOS7SystemFontOfSize:fontSize attribute:UI7FontAttributeLight];
    }
}

+ (UIFont *)fontOfMediumSize:(CGFloat)fontSize
{
    BOOL iOS8Later = ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending);
    if (iOS8Later)
    {
        return [UIFont boldSystemFontOfSize:fontSize];
    }
    else
    {
        return [UIFont iOS7SystemFontOfSize:fontSize attribute:UI7FontAttributeMedium];
    }
}

+ (UIFont *)fontOfBlodSize:(CGFloat)fontSize
{
    BOOL iOS8Later = ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending);
    if (iOS8Later)
    {
        return [UIFont boldSystemFontOfSize:fontSize];
    }
    else
    {
        return [UIFont iOS7SystemFontOfSize:fontSize attribute:UI7FontAttributeBold];
    }
}

+ (UIFont *)font9
{
    return [UIFont fontOfNormalSize:9];
}

+ (UIFont *)font10
{
    return [UIFont fontOfNormalSize:10];
}

+ (UIFont *)font10M
{
    return [UIFont fontOfMediumSize:10];
}

+ (UIFont *)font10B
{
    return [UIFont fontOfBlodSize:10];
}

+ (UIFont *)font11
{
    return [UIFont fontOfNormalSize:11];
}

+ (UIFont *)font12
{
    return [UIFont fontOfNormalSize:12];
}

+ (UIFont *)font12M
{
    return [UIFont fontOfMediumSize:12];
}

+ (UIFont *)font12B
{
    return [UIFont fontOfBlodSize:12];
}

+ (UIFont *)font13
{
    return [UIFont fontOfNormalSize:13];
}

+ (UIFont *)font13M
{
    return [UIFont fontOfMediumSize:13];
}

+ (UIFont *)font13B
{
    return [UIFont fontOfBlodSize:13];
}


+ (UIFont *)font14
{
    return [UIFont fontOfNormalSize:14];
}

+ (UIFont *)font14M
{
    return [UIFont fontOfMediumSize:14];
}

+ (UIFont *)font14B
{
    return [UIFont fontOfBlodSize:14];
}

+ (UIFont *)font15
{
    return [UIFont fontOfNormalSize:15];
}

+ (UIFont *)font15M
{
    return [UIFont fontOfMediumSize:15];
}

+ (UIFont *)font15B
{
    return [UIFont fontOfBlodSize:15];
}

+ (UIFont *)font16
{
    return [UIFont fontOfNormalSize:16];
}

+ (UIFont *)font16M
{
    return [UIFont fontOfMediumSize:16];
}

+ (UIFont *)font16B
{
    return [UIFont fontOfBlodSize:16];
}

+ (UIFont *)font17
{
    return [UIFont fontOfNormalSize:17];
}

+ (UIFont *)font17M;
{
    return [UIFont fontOfMediumSize:17];
}

+ (UIFont *)font17B
{
    return [UIFont fontOfBlodSize:17];
}


+ (UIFont *)font18
{
    return [UIFont fontOfNormalSize:18];
}

+ (UIFont *)font18M;
{
    return [UIFont fontOfMediumSize:18];
}

+ (UIFont *)font18B
{
    return [UIFont fontOfBlodSize:18];
}


+ (UIFont *)font20
{
    return [UIFont fontOfNormalSize:20];
}

+ (UIFont *)font20M
{
    return [UIFont fontOfMediumSize:20];
}

+ (UIFont *)font20B
{
    return [UIFont fontOfBlodSize:20];
}
@end

@implementation UIFont (LoadFont)

+ (BOOL)loadFontFromPath:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    CFErrorRef error;
    BOOL suc = CTFontManagerRegisterFontsForURL((__bridge CFTypeRef)url, kCTFontManagerScopeNone, &error);
    if (!suc) {
        NSLog(@"Failed to load font: %@", error);
    }
    return suc;
}

+ (void)unloadFontFromPath:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    CTFontManagerUnregisterFontsForURL((__bridge CFTypeRef)url, kCTFontManagerScopeNone, NULL);
}

+ (UIFont *)loadFontFromData:(NSData *)data {
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    if (!provider) return nil;
    CGFontRef fontRef = CGFontCreateWithDataProvider(provider);
    CGDataProviderRelease(provider);
    if (!fontRef) return nil;
    
    CFErrorRef errorRef;
    BOOL suc = CTFontManagerRegisterGraphicsFont(fontRef, &errorRef);
    if (!suc) {
        CFRelease(fontRef);
        NSLog(@"%@", errorRef);
        return nil;
    } else {
        CFStringRef fontName = CGFontCopyPostScriptName(fontRef);
        UIFont *font = [UIFont fontWithName:(__bridge NSString *)(fontName) size:[UIFont systemFontSize]];
        if (fontName) CFRelease(fontName);
        CGFontRelease(fontRef);
        return font;
    }
}

+ (BOOL)unloadFontFromData:(UIFont *)font {
    CGFontRef fontRef = CGFontCreateWithFontName((__bridge CFStringRef)font.fontName);
    if (!fontRef) return NO;
    CFErrorRef errorRef;
    BOOL suc = CTFontManagerUnregisterGraphicsFont(fontRef, &errorRef);
    CFRelease(fontRef);
    if (!suc) NSLog(@"%@", errorRef);
    return suc;
}


@end
