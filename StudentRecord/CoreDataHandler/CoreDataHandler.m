
//
//  CoreDataHandler.m
//  CoreData
//
//  Created by Rajan on 7/17/15.
//  Copyright (c) 2015 Rajan. All rights reserved.
//

#import "CoreDataHandler.h"



@implementation CoreDataHandler

+ (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "test.CoreData" in the application's documents directory.
    NSURL *applicationDocumentDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSLog(@"%s applicationDOcumentDirectory: \n %@",__PRETTY_FUNCTION__, [applicationDocumentDirectory.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""]);
    return applicationDocumentDirectory;
}

+(NSString *) databaseFileName{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CoreDataModelName"];
}


#pragma mark - Core Data stack -


+ (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:[CoreDataHandler databaseFileName] withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[CoreDataHandler databaseFileName]];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[CoreDataHandler managedObjectModel]];
    
    NSError *error = nil;
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:[NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption:[NSNumber numberWithBool:YES]} error:&error]) {
        NSLog(@"%s %@",__PRETTY_FUNCTION__, error.localizedDescription);
        abort();
    }
    
    return persistentStoreCoordinator;
}

+ (NSManagedObjectContext *)managedObjectContext {
    NSPersistentStoreCoordinator *coordinator = [CoreDataHandler persistentStoreCoordinator];
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [managedObjectContext setPersistentStoreCoordinator:coordinator];
    return managedObjectContext;
}





#pragma mark - Core Data Saving support -

#pragma mark - Create Core Data Record
+(id) insertManagedObjectOfClass:(Class) aClass inManagedObjectContext:(NSManagedObjectContext *) managedObjectCOntext{
    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(aClass) inManagedObjectContext:managedObjectCOntext];
    return managedObject;
}


+(BOOL) saveManagedObjectContext:(NSManagedObjectContext *) managedObjectContext{
    NSError *error;
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
        NSLog(@" %s %@",__PRETTY_FUNCTION__, error.localizedDescription);
        [managedObjectContext rollback];
        NSLog(@"Rolled back changes.");
        return NO;
    }
    return YES;
}


#pragma mark - Read Core Data

+(NSArray *) fetchEntitiesForClass:(Class) aclass  withPredicate:(NSPredicate *) predicate inManageObjectCOntext:(NSManagedObjectContext *) managedObjectContext{
    
    NSError *error ;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass(aclass) inManagedObjectContext:managedObjectContext];
    
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setPredicate:predicate];
    
    NSArray *items = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"%s %@",__PRETTY_FUNCTION__,error.localizedDescription);
        return nil;
    }
    return items;
}



+(NSArray *) fetchEntitiesForClass:(Class) aclass  withPredicate:(NSPredicate *) predicate andSortDescriprotArray:(NSArray *) sortDescriptors inManageObjectCOntext:(NSManagedObjectContext *) managedObjectContext{
    
    NSError *error ;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass(aclass) inManagedObjectContext:managedObjectContext];
    
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    
    NSArray *items = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"%s %@",__PRETTY_FUNCTION__,error.localizedDescription);
        return nil;
    }
    return items;
}

#pragma mark - Delete Core Data Record
+(void) deleteManagedObject:(Class) class    withPredicate:(NSPredicate *) predicate inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext{
    
    NSError *error ;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    
    fetch.entity = [NSEntityDescription entityForName:NSStringFromClass(class) inManagedObjectContext:managedObjectContext];
    fetch.predicate = predicate;
    
    NSArray *array = [managedObjectContext executeFetchRequest:fetch error:nil];
    if (error) {
        NSLog(@"%s %@",__PRETTY_FUNCTION__,error.localizedDescription);
        [managedObjectContext rollback];
        NSLog(@"Rolled back changes.");
        return;
    }
    for (NSManagedObject *managedObject in array) {
        [managedObjectContext deleteObject:managedObject];
    }
    [CoreDataHandler saveManagedObjectContext:managedObjectContext];
    
}



+(void) deleteAllManagedObjects:(Class) class inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext{
    NSError *error ;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    fetch.entity = [NSEntityDescription entityForName:NSStringFromClass(class) inManagedObjectContext:managedObjectContext];
    fetch.predicate = nil;
    NSArray *array = [managedObjectContext executeFetchRequest:fetch error:nil];
    if (error) {
        NSLog(@"%s %@",__PRETTY_FUNCTION__,error.localizedDescription);
        [managedObjectContext rollback];
        NSLog(@"Rolled back changes.");
        return;
    }
    
    for (NSManagedObject *managedObject in array) {
        [managedObjectContext deleteObject:managedObject];
    }
    [CoreDataHandler saveManagedObjectContext:managedObjectContext];
    
}

#pragma mark - Update Core Data Record

+(BOOL) updateManagedObjects:(Class) class  withPredicate:(NSPredicate *) predicate  {
    
    return FALSE;
}



@end