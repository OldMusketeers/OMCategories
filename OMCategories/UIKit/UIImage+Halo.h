//
//  UIImage+Halo.h
//  HaloSlimFramework
//
//  Created by Jet on 16/1/22.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Halo)
#pragma mark - Create image
//通过颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageWithBezierPath:(UIBezierPath *)path color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor;

#pragma mark - Image Info

- (BOOL)hasAlphaChannel;

#pragma mark - Modify Image

//合成图片
+ (UIImage *)image:(UIImage *)image mergedWithBgImage:(UIImage *)bgImage topSize:(CGSize)topSize bgSize:(CGSize)bgSize;

- (UIImage*)imageMerged:(UIImage*)image;

- (UIImage*)imageUseMask:(UIImage*)mask;

//圆角
- (UIImage *)imageWithRoundCorner;//default is 3radias

- (UIImage *)imageWithRoundCornerRadias:(CGFloat)radias;

- (UIImage *)imageWithRoundCornerRadias:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType backgroundColor:(UIColor *)backgroundColor;

//缩放
- (UIImage *)imageByResizeToSize:(CGSize)size;

- (UIImage *)imageByResizeToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode;

- (UIImage *)stretchableMiddleImage;

- (UIImage *)stretchableImageWithSize:(CGSize)size;

//切割
- (UIImage *)imageByCropToRect:(CGRect)rect;

- (UIImage *)clipImageToSquare;

//高亮
- (UIImage*)highlightedImage;
- (UIImage*)imageByApplyingAlpha:(CGFloat)alpha;

//旋转
- (UIImage*)mirrorImage:(BOOL)vertical;
- (UIImage*)imageByRotate:(CGFloat)degree;
- (UIImage *)imageByRotate:(CGFloat)degree fitSize:(BOOL)fitSize;


//图片效果
- (UIImage *)imageByTintColor:(UIColor *)color;

- (UIImage *)imageByGrayscale;

- (UIImage *)imageByBlurSoft;

- (UIImage *)imageByBlurLight;

- (UIImage *)imageByBlurExtraLight;

- (UIImage *)imageByBlurDark;

- (UIImage *)imageByBlurWithTint:(UIColor *)tintColor;

/**
 Applies a blur, tint color, and saturation adjustment to this image,
 optionally within the area specified by @a maskImage.
 
 @param blurRadius     The radius of the blur in points, 0 means no blur effect.
 
 @param tintColor      An optional UIColor object that is uniformly blended with
 the result of the blur and saturation operations. The
 alpha channel of this color determines how strong the
 tint is. nil means no tint.
 
 @param tintBlendMode  The @a tintColor blend mode. Default is kCGBlendModeNormal (0).
 
 @param saturation     A value of 1.0 produces no change in the resulting image.
 Values less than 1.0 will desaturation the resulting image
 while values greater than 1.0 will have the opposite effect.
 0 means gray scale.
 
 @param maskImage      If specified, @a inputImage is only modified in the area(s)
 defined by this mask.  This must be an image mask or it
 must meet the requirements of the mask parameter of
 CGContextClipToMask.
 
 @return               image with effect, or nil if an error occurs (e.g. no
 enough memory).
 */
- (UIImage *)imageByBlurRadius:(CGFloat)blurRadius
                     tintColor:(UIColor *)tintColor
                      tintMode:(CGBlendMode)tintBlendMode
                    saturation:(CGFloat)saturation
                     maskImage:(UIImage *)maskImage;


//高速圆角图片
- (UIImage *)cornerRadiusWithCornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType backgroundColor:(UIColor *)backgroundColor;

@end
