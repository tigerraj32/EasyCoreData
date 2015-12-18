//
//  AppDelegate.h
//  StudentRecord
//
//  Created by IGC Technologies on 12/18/15.
//  Copyright © 2015 IGC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreDataHandler.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong,readonly) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModal;
@property(nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

