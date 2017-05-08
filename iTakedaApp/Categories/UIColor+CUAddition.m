//
//  UIColor+CUAddition.m
//  UIKit+CUAddition
//
//  Created by czm on 15/11/16.
//  Copyright © 2015年 czm. All rights reserved.
//

#import "UIColor+CUAddition.h"

UIColor* RGBColor(CGFloat r, CGFloat g, CGFloat b)
{
    return [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0];
}

UIColor* RGBAColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a)
{
    return [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0];
}

UIColor* HEXColor(NSInteger hexValue)
{
    return [UIColor cu_colorWithHex:hexValue];
}

@implementation UIColor (CUAddition)

+ (UIColor *)cu_colorWithHex:(NSInteger)hexValue
{
    if (hexValue <= 0xFFFFFF)
    {
        return [UIColor colorWithRed:((hexValue & 0xFF0000) >> 16) / 255.0f
                               green:((hexValue & 0xFF00) >> 8) / 255.0f
                                blue:(hexValue & 0xFF) / 255.0f
                               alpha:1.0];
    }
    
    NSInteger rgbHexValue = hexValue & 0xFFFFFF;
    return [UIColor colorWithRed:((rgbHexValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbHexValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbHexValue & 0xFF) / 255.0f
                           alpha:((CGFloat)((hexValue & 0xFF000000) >> 24)) / 255.0];
}


+ (UIColor *)cu_colorWithHexString:(NSString *)hexStr
{
    unsigned colorInt = 0;
    [[NSScanner scannerWithString:hexStr] scanHexInt:&colorInt];

    return [UIColor cu_colorWithHex:colorInt];
}

+ (UIColor *)cu_randomColor
{
    CGFloat red = (arc4random()%256)/256.0;
    CGFloat green = (arc4random()%256)/256.0;
    CGFloat blue = (arc4random()%256)/256.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
