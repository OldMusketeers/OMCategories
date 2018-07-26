//
//  UIButton+Halo.m
//  HaloSlimFramework
//
//  Created by Jet on 16/1/24.
//
//

#import "UIButton+Halo.h"
#import "UIImage+Halo.h"
#import <objc/runtime.h>
#import "UIView+Halo.h"

@implementation ButtonBuilder

- (instancetype)init
{
    if (self = [super init])
    {
        self.font = [UIFont systemFontOfSize:14];
        self.textColor = [UIColor blackColor];
    }
    return self;
}

- (UIButton *)build
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button.titleLabel setFont:self.font];
    
    if (self.text.length > 0)
    {
        [button setTitle:self.text forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.backgroundColor = [UIColor clearColor];
        [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];
        //        [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        
    }
    
    if (self.textColor)
    {
        [button setTitleColor:self.textColor forState:UIControlStateNormal];
        [button setTitleColor:[self.textColor colorWithAlphaComponent:0.6] forState:UIControlStateDisabled];
    }
    if (self.textColorHighLight)
    {
        [button setTitleColor:self.textColorHighLight forState:UIControlStateHighlighted];
    }
    
    if (self.bgColor)
    {
        if (self.bgColorHighLight || self.bgColorDisable)
        {
            UIImage *imgNoraml = [UIImage imageWithColor:self.bgColor];
            [button setBackgroundImage:imgNoraml forState:UIControlStateNormal];
            if (self.bgColorHighLight)
            {
                UIImage *img = [UIImage imageWithColor:self.bgColorHighLight];
                [button setBackgroundImage:img forState:UIControlStateSelected];
                [button setBackgroundImage:img forState:UIControlStateHighlighted];
            }
            if (self.bgColorDisable)
            {
                UIImage *imgDisable = [UIImage imageWithColor:self.bgColorDisable];
                [button setBackgroundImage:imgDisable forState:UIControlStateDisabled];
            }
        }
        else
        {
            [button setBackgroundColor:self.bgColor];
        }
    }
    
    
    if (self.image)
    {
        [button setImage:self.image forState:UIControlStateNormal];
        if (!self.imageHighLight)
        {
            self.imageHighLight = [self.image imageByApplyingAlpha:0.8];
        }
    }
    
    if (self.imageHighLight)
    {
        [button setImage:self.imageHighLight forState:UIControlStateHighlighted];
        [button setImage:self.imageHighLight forState:UIControlStateSelected];
    }
    
    if (self.backImage)
    {
        self.backImage = [self.backImage stretchableMiddleImage];
        
        [button setBackgroundImage:self.backImage forState:UIControlStateNormal];
        if (!self.backImageHighLight)
        {
            self.backImageHighLight = [self.backImage imageByApplyingAlpha:0.8];
        }
    }
    
    if(self.backImageHighLight)
    {
        self.backImageHighLight = [self.backImageHighLight stretchableMiddleImage];
        [button setBackgroundImage:self.backImageHighLight forState:UIControlStateHighlighted];
        [button setBackgroundImage:self.backImageHighLight forState:UIControlStateSelected];
        [button setBackgroundImage:self.backImageHighLight forState:UIControlStateDisabled];
    }
    
    [button sizeToFit];
    
    if (!CGSizeEqualToSize(self.minSize, CGSizeZero))
    {
        if (button.width < self.minSize.width)
        {
            button.width = self.minSize.width;
        }
        if (button.height < self.minSize.height)
        {
            button.height = self.minSize.height;
        }
    }
    if(!CGSizeEqualToSize(self.maxSize, CGSizeZero))
    {
        if(button.width > self.maxSize.width)
        {
            button.width = self.maxSize.width;
        }
        if(button.height > self.maxSize.height)
        {
            button.height = self.maxSize.height;
        }
    }
    
    return button;
}

@end

@implementation UIButton (Halo)

+ (UIButton *)buttonWithBuilder:(void(^)(ButtonBuilder *builder))builderBlock
{
    NSParameterAssert(builderBlock!=nil);
    ButtonBuilder *builder = [[ButtonBuilder alloc] init];
    builderBlock(builder);
    return [builder build];
}

@end
