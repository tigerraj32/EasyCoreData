//
//  CoreDataHandler.h
//  CoreData
//
//  Created by Rajan on 7/17/15.
//  Copyright (c) 2015 Rajan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>



@interface CoreDataHandler : NSObject

+ (NSURL *)applicationDocumentsDirectory;
+(NSString *) databaseFileName;
+ (NSManagedObjectModel *)managedObjectModel;
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
+ (NSManagedObjectContext *)managedObjectContext ;


//Create
+(id) insertManagedObjectOfClass:(Class) aClass inManagedObjectContext:(NSManagedObjectContext *) managedObjectCOntext;

+(BOOL) saveManagedObjectContext:(NSManagedObjectContext *) managedObjectContext;

//Read
+(NSArray *) fetchEntitiesForClass:(Class) aclass  withPredicate:(NSPredicate *) predicate inManageObjectCOntext:(NSManagedObjectContext *) managedObjectContext;
+(NSArray *) fetchEntitiesForClass:(Class) aclass  withPredicate:(NSPredicate *) predicate andSortDescriprotArray:(NSArray *) sortDescriptors inManageObjectCOntext:(NSManagedObjectContext *) managedObjectContext;


//Delete
+(void) deleteManagedObject:(Class) class    withPredicate:(NSPredicate *) predicate inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext;
+(void) deleteAllManagedObjects:(Class) class inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext;


//Update

@end
