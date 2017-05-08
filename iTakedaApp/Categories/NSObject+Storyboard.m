//
//  NSObject+Storyboard.m
//  
//
//  Created by czm on 15/7/3.
//  Copyright (c) 2015年 czm. All rights reserved.
//

#import "NSObject+Storyboard.h"

@implementation NSObject (Storyboard)

- (UIViewController *)instantiateViewControlleWithId:(NSString *)identifier andStoryboardName:(NSString *)storyboard
{
    return [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:identifier];
}

@end
