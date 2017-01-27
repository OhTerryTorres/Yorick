//
//  AppDelegate.h
//  monologues
//
//  Created by TerryTorres on 6/27/14.
//  Copyright (c) 2014 Terry Torres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonologueManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

// These \/ things help use core data

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// *****
// Consider setting this to weak, so that once it's passed the manger on to ther other screens,
// App Delegate doesn't have to worry about it?
@property (strong, nonatomic) MonologueManager *manager;

-(void)saveContext;
-(NSURL *)applicationDocumentsDirectory;


@end
