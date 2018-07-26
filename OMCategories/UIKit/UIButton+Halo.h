//
//  UIButton+Halo.h
//  HaloSlimFramework
//
//  Created by Jet on 16/1/24.
//
//

#import <UIKit/UIKit.h>

@interface ButtonBuilder : NSObject
@property(nonatomic,strong)NSString *text;
@property(nonatomic,strong)UIFont *font;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)UIImage *imageHighLight;
@property(nonatomic,strong)UIImage *backImage;
@property(nonatomic,strong)UIImage *backImageHighLight;
@property(nonatomic,strong)UIColor *bgColor;
@property(nonatomic,strong)UIColor *bgColorHighLight;
@property(nonatomic,strong)UIColor *bgColorDisable;
@property(nonatomic,strong)UIColor *textColor;
@property(nonatomic,strong)UIColor *textColorHighLight;
@property(nonatomic,assign)CGSize minSize;
@property(nonatomic,assign)CGSize maxSize;
- (UIButton *)build;
@end

@interface UIButton (Halo)

+ (UIButton *)buttonWithBuilder:(void(^)(ButtonBuilder *builder))builderBlock;

@end
