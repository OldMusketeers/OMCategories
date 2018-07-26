//
//  UIFont+Halo.h
//  HaloSlimFramework
//
//  Created by Jet on 16/1/24.
//
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

UIKIT_EXTERN NSString *UI7FontAttributeNone;
UIKIT_EXTERN NSString *UI7FontAttributeUltraLight;
UIKIT_EXTERN NSString *UI7FontAttributeUltraLightItalic;
UIKIT_EXTERN NSString *UI7FontAttributeLight;
UIKIT_EXTERN NSString *UI7FontAttributeLightItalic;
UIKIT_EXTERN NSString *UI7FontAttributeMedium;
UIKIT_EXTERN NSString *UI7FontAttributeItalic;
UIKIT_EXTERN NSString *UI7FontAttributeBold;
UIKIT_EXTERN NSString *UI7FontAttributeBoldItalic;
UIKIT_EXTERN NSString *UI7FontAttributeCondensedBold;
UIKIT_EXTERN NSString *UI7FontAttributeCondensedBlack;

#define UIFontWithHeight(height) [UIFont systemFontOfSize:height]
#define UIBoldFontWithHeight(height) [UIFont boldSystemFontOfSize:height]

@interface UIFont (Halo)
+ (UIFont *)iOS7SystemFontOfSize:(CGFloat)fontSize attribute:(NSString *)attribute;
+ (UIFont *)lightSystemFontOfSize:(CGFloat)fontSize;

+ (UIFont *)font9;

+ (UIFont *)font10;
+ (UIFont *)font10M;
+ (UIFont *)font10B;

+ (UIFont *)font11;

+ (UIFont *)font12;
+ (UIFont *)font12M;
+ (UIFont *)font12B;

+ (UIFont *)font13;
+ (UIFont *)font13M;
+ (UIFont *)font13B;

+ (UIFont *)font14;
+ (UIFont *)font14M;
+ (UIFont *)font14B;

+ (UIFont *)font15;
+ (UIFont *)font15M;
+ (UIFont *)font15B;

+ (UIFont *)font16;
+ (UIFont *)font16M;
+ (UIFont *)font16B;

+ (UIFont *)font17;
+ (UIFont *)font17M;
+ (UIFont *)font17B;

+ (UIFont *)font18;
+ (UIFont *)font18M;
+ (UIFont *)font18B;

+ (UIFont *)font20;
+ (UIFont *)font20M;
+ (UIFont *)font20B;
@end

@interface UIFont (LoadFont)
/**
 Load the font from file path. Support format:TTF,OTF.
 If return YES, font can be load use it PostScript Name: [UIFont fontWithName:...]
 
 @param path    font file's full path
 */
+ (BOOL)loadFontFromPath:(NSString *)path;

/**
 Unload font from file path.
 
 @param path    font file's full path
 */
+ (void)unloadFontFromPath:(NSString *)path;

/**
 Load the font from data. Support format:TTF,OTF.
 
 @param data  Font data.
 
 @return UIFont object if load succeed, otherwise nil.
 */
+ (UIFont *)loadFontFromData:(NSData *)data;

/**
 Unload font which is loaded by loadFontFromData: function.
 
 @param font the font loaded by loadFontFromData: function
 
 @return YES if succeed, otherwise NO.
 */
+ (BOOL)unloadFontFromData:(UIFont *)font;
@end
