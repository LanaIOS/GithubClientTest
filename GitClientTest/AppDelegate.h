//
//  AppDelegate.h
//  GitClientTest
//
//  Created by kristyna on 11/29/17.
//  Copyright © 2017 kristyna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

