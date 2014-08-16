//
//  AKDataSource.m
//  AKMailClientApp
//
//  Created by Arcilite on 11.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "AKMailManager.h"
#import "AKMailMessage.h"
#import "AKCoreDataProvider.h"


@implementation AKCoreDataProvider

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

-(id)init{
    self = [super init];
    
    if(self){
        [self managedObjectContext];
    }
       return self;
}
#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AKMailClientApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AKMailClientApp.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
    }
    
    return _persistentStoreCoordinator;
}

- (void)saveContext
{
   
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    [self.persistentStoreCoordinator lock];
    
    if (managedObjectContext != nil) {
       
        
        [managedObjectContext performBlock:^{
            //make changes
             NSError *error = nil;
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {

                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }];
    }
      [self.persistentStoreCoordinator unlock];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AKMailMessage" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"recivedData" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
   
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Common operations

- (void)removeAllEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate
{
	NSFetchRequest *allEntieties = [[NSFetchRequest alloc] init];
	[allEntieties setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext]];
	[allEntieties setIncludesPropertyValues:YES];
    
    //only fetch the managedObjectID
	NSError *error = nil;
	NSArray *entities = [self.managedObjectContext executeFetchRequest:allEntieties error:&error];
    
	NSLog(@"%d", entities.count);
    
	if (predicate) {
		NSArray *arr = [entities filteredArrayUsingPredicate:predicate];
		entities = arr;
	}
    //error handling goes here
	for (NSManagedObject *entity in entities) {
		[self.managedObjectContext deleteObject:entity];
	}
    
	[self saveContext];
}


- (NSArray *)getAllByName:(NSString *)objectName predicate:(NSPredicate *)predicate
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:objectName inManagedObjectContext:self.managedObjectContext];
    
	[request setEntity:entity];
	[request setPredicate:predicate];
	[request setIncludesPropertyValues:YES];
	[request setReturnsObjectsAsFaults:NO];
	[request setShouldRefreshRefetchedObjects:YES];
    
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
	if (mutableFetchResults == nil) {
		NSLog(@"Error: %@", [error localizedDescription]);
	}
    
	return mutableFetchResults;
}

-(NSArray*)coreDataEntriesForEntityName:(NSString*)entityName{
    NSFetchRequest *request = [[NSFetchRequest alloc] init] ;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (!results) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    
    return results;
}



- (BOOL)coreDataHasEntriesForEntityName:(NSString *)entityName {
    
  
    NSArray *results = [self coreDataEntriesForEntityName:entityName];
   
    if ([results count] == 0) {
        return NO;
    }
    
    return YES;
}

#pragma mark - MAIL operations

-(BOOL)isMailMessagesPresentInDB{

    return [self coreDataHasEntriesForEntityName:@"AKMailMessage"];
}

-(NSInteger)countOfMailsInCoreData{
    return [[self coreDataEntriesForEntityName:@"AKMailMessage"] count];
}

-(NSArray*)arrayOfMailsInCoreData{
    return [self coreDataEntriesForEntityName:@"AKMailMessage"];
}

-(void)removeAllMailInDB{
    
    [self removeAllEntityName:@"AKMailMessage" withPredicate:nil];
    [self saveContext];
}

-(AKMailMessage*)getMessageForManagedID:(NSManagedObjectID*)uid{
    NSError * error = nil;
    
    AKMailMessage * mailObject =  (AKMailMessage *)[self.managedObjectContext existingObjectWithID:uid error:&error];
    
    if (error) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    
    return mailObject;
}

-(void)saveNewMailArrayToDB:(NSArray*)msgArray{
    
    for (int i = 0; i< [msgArray count]; i++) {
        
        MCOIMAPMessage *msg = [msgArray objectAtIndex:i];
        
        NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
        AKMailMessage *mailMessage = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:self.managedObjectContext];
        
        mailMessage.from = msg.header.sender.displayName;
        mailMessage.subject = msg.header.subject;
        mailMessage.uid =  [NSNumber numberWithUnsignedInt: [msg uid]];
        mailMessage.recivedData = msg.header.receivedDate;
        NSLog(@"description %@",msg.header.description);
        
        
    }
    [self saveContext];
}

@end
