//
//  AKDataSource.h
//  AKMailClientApp
//
//  Created by Arcilite on 11.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//


@class AKMailMessage;

@interface AKCoreDataProvider : NSObject 

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *privatManagedObjectContext;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)saveNewMailArrayToDB:(NSArray*)msgArray;
- (BOOL)isMailMessagesPresentInDB;
- (NSInteger)countOfMailsInCoreData;
- (AKMailMessage*)getMessageForManagedID:(NSManagedObjectID*)uid;
- (void)removeAllMailInDB;
- (NSArray*)arrayOfMailsInCoreData;

@end
