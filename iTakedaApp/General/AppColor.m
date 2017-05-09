//
//  AppColor.m
//  takedaApp
//
//  Created by user001 on 2017/5/8.
//  Copyright © 2017年 user001. All rights reserved.
//

#import "AppColor.h"


@implementation AppColor

//通用背景色
+ (UIColor *)customViewBgColor
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = HEXColor(0xeeeeee);
    });
    
    return color;
}

//导航栏背景颜色
+ (UIColor *)naviBarBarTintColor
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = [self tomatoRedColor];;
    });
    
    return color;
}

//导航栏tint颜色
+ (UIColor *)naviBarTintColor
{
    return [UIColor whiteColor];
}

//导航栏标题文字颜色
+ (UIColor *)naviBarTitleTextColor
{
    return [UIColor whiteColor];
}

//tab栏背景颜色
+ (UIColor *)tabBarBarTintColor
{
    return [UIColor whiteColor];
}

//tab栏tint颜色
+ (UIColor *)tabBarTintColor
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = [UIColor whiteColor];
    });
    
    return color;
}

+ (UIColor *)cherryColor;//樱桃红
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = HEXColor(0xDC402A);
    });
    
    return color;
}

+ (UIColor *)darkRedColor;//暗红色
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = HEXColor(0xaa3a3b);
    });
    
    return color;
}

+ (UIColor *)brownColor;//棕色
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = HEXColor(0x800000);
    });
    
    return color;
}

+ (UIColor *)pinkColor;//粉红色
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = HEXColor(0xFAE6E3);
    });
    
    return color;
}

+ (UIColor *)gray2aColor;//黑色
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = HEXColor(0x2A2A2A);
    });
    
    return color;
}

+ (UIColor *)gray31Color;//黑色
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = HEXColor(0x313131);
    });
    
    return color;
}

+ (UIColor *)royalblueColor;//宝蓝色
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = HEXColor(0x096EF5);
    });
    
    return color;
}

+ (UIColor *)darkTurquoiseColor;//暗宝石绿
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = HEXColor(0x00C4D5);
    });
    
    return color;
}

+ (UIColor *)seaGreenColor//海洋绿
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = HEXColor(0x25901a);
    });
    
    return color;
}

+ (UIColor *)powderblueColor;//粉蓝色
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = HEXColor(0xB4F7FB);
    });
    
    return color;
}

+ (UIColor *)tomatoRedColor;//番茄红
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = HEXColor(0xe03e3f);
    });
    
    return color;
}

+ (UIColor *)gray66Color;//暗灰色
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = HEXColor(0x666666);
    });
    
    return color;
}

+ (UIColor *)grayDCColor;//淡灰色
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = HEXColor(0xdcdcdc);
    });
    
    return color;
}

+ (UIColor *)grayC9Color;//浅灰色
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = HEXColor(0xC9C9C9);
    });
    
    return color;
}

+ (UIColor *)grayEEColor
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = HEXColor(0xeeeeee);
    });
    
    return color;
}

+ (UIColor *)grayDisableColor
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = RGBColor(220, 220, 220);
    });
    
    return color;
}

+ (UIColor *)darkOrange
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = HEXColor(0xff6634);
    });
    
    return color;
}

+ (UIColor *)sideAndSplitLineColor
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = HEXColor(0xc5c5c5);
    });
    
    return color;
}

+ (UIColor *)listSelectColor
{
    static UIColor *color;
    static dispatch_once_t s_once;
    dispatch_once(&s_once, ^{
        color = HEXColor(0xfaefee);
    });
    
    return color;
}


@end
