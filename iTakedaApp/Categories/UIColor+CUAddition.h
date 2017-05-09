//
//  UIColor+CUAddition.h
//  takedaApp
//
//  Created by user001 on 2017/5/8.
//  Copyright © 2017年 user001. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Creates and returns a color object using using the 1.0 opacity and RGB component values.
 *
 *  @param r    red component, specified as a value from 0 to 255.
 *  @param g    green component, specified as a value from 0 to 255.
 *  @param b    blue component, specified as a value from 0 to 255.
 *
 *  @return The color object.
 */
extern UIColor* RGBColor(CGFloat r, CGFloat g, CGFloat b);

/**
 *  Creates and returns a color object using using the specified opacity and RGB component values.
 *
 *  @param r    red component, specified as a value from 0 to 255.
 *  @param g    green component, specified as a value from 0 to 255.
 *  @param b    blue component, specified as a value from 0 to 255.
 *  @param a    opacity, specified as a value from 0.0 to 1.0.
 *
 *  @return The color object.
 */
extern UIColor* RGBAColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a);

/**
 *  Creates and returns a color using the hex(ARGB or RGB) string.
 *
 *  @param hexValue  The hex string (ARGB or RGB), such as "0xff0000" or "0xffff0000".
 *
 *  @return The color object.
 */
extern UIColor* HEXColor(NSInteger hexValue);


@interface UIColor (CUAddition)

/**
 *  Creates and returns a color using the hex(ARGB or RGB) value.
 *
 *  @param hexValue  The hex value (ARGB or RGB), such as 0xff0000 or 0xffff0000.
 *
 *  @return The color object.
 */
+ (UIColor *)cu_colorWithHex:(NSInteger)hexValue;

/**
 *  Creates and returns a color using the hex(ARGB or RGB) string.
 *
 *  @param hexValue  The hex string (ARGB or RGB), such as "0xff0000" or "0xffff0000".
 *
 *  @return The color object.
 */
+ (UIColor *)cu_colorWithHexString:(NSString *)hexStr;

/**
 * Creates and returns a random color.
 */
+ (UIColor *)cu_randomColor;


@end

NS_ASSUME_NONNULL_END
