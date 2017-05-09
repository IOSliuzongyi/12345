//
//  AppColor.h
//  takedaApp
//
//  Created by user001 on 2017/5/8.
//  Copyright © 2017年 user001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppColor : NSObject

+ (UIColor *)customViewBgColor;//通用背景色
+ (UIColor *)naviBarBarTintColor;//导航栏背景颜色
+ (UIColor *)naviBarTintColor;//导航栏tint颜色
+ (UIColor *)naviBarTitleTextColor;//导航栏标题文字颜色
+ (UIColor *)tabBarBarTintColor;//tab栏背景颜色
+ (UIColor *)tabBarTintColor;//tab栏tint颜色

+ (UIColor *)cherryColor;//樱桃红 #DC402A
+ (UIColor *)darkRedColor;//暗红色 #BA311F 辅助色#aa3a3b
+ (UIColor *)brownColor;//棕色 #80000
+ (UIColor *)pinkColor;//粉红色 #FAE6E3
+ (UIColor *)gray2aColor;//黑色   #2A2A2A
+ (UIColor *)gray31Color;//黑色   #313131
+ (UIColor *)royalblueColor;//宝蓝色  #096EF5
+ (UIColor *)darkTurquoiseColor;//暗宝石绿 #00C4D5
+ (UIColor *)seaGreenColor;//海洋绿 #25901a
+ (UIColor *)powderblueColor;//粉蓝色 #B4F7FB
+ (UIColor *)tomatoRedColor;//番茄红 #F65B52 主色 #eo3e3f
+ (UIColor *)gray66Color;//暗灰色 #666666
+ (UIColor *)grayDCColor;//亮灰色 #DCDCDC
+ (UIColor *)grayC9Color;//浅灰色 #C9C9C9
+ (UIColor *)grayEEColor;//灰白色 #EEEEEE
+ (UIColor *)grayDisableColor;//220,220,220

+ (UIColor *)darkOrange;//深橙色 #ff6634
+ (UIColor *)sideAndSplitLineColor;//边线或者分割线颜色

+ (UIColor *)listSelectColor;//列表选中时的颜色

@end
