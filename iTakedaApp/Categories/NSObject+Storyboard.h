//
//  NSObject+Storyboard.h
//  takedaApp
//
//  Created by user001 on 2017/5/8.
//  Copyright © 2017年 user001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (Storyboard)
- (UIViewController *)instantiateViewControlleWithId:(NSString *)identifier andStoryboardName:(NSString *)storyboard;

@end
