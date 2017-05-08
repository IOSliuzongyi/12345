//
//  AppDelegate.h
//  iTakedaApp
//
//  Created by user001 on 2017/5/8.
//  Copyright © 2017年 stt. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SAICHTTPRequest.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

//@property (strong, nonatomic) UIWindow *window;
//
//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//@property (strong,nonatomic) SAICHTTPRequest* httpRequest;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

