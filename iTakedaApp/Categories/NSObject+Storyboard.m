//
//  NSObject+Storyboard.m
//  takedaApp
//
//  Created by user001 on 2017/5/8.
//  Copyright © 2017年 user001. All rights reserved.
//

#import "NSObject+Storyboard.h"

@implementation NSObject (Storyboard)

- (UIViewController *)instantiateViewControlleWithId:(NSString *)identifier andStoryboardName:(NSString *)storyboard
{
    return [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:identifier];
}

@end
