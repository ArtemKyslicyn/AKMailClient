//
//  MasterViewController.m
//  AKMailClientApp
//
//  Created by Arcilite on 11.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import "AKMailListViewController.h"
#import "AKCoreDataProvider.h"
#import "AKMailCell.h"
#import "AKMailDetailViewController.h"
#import "AKMailMessage.h"
#import "AKModel.h"


@interface AKMailListViewController ()

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext     *managedObjectContext;
@property (nonatomic, strong) UIRefreshControl           *refreshControl;

@end


@implementation AKMailListViewController;

#pragma mark - Custom properties

- (NSFetchedResultsController *)fetchedResultsController
{
    NSFetchedResultsController *aFetchedResultsController = [[[AKModel sharedManager] dataSource] fetchedResultsController];
    return aFetchedResultsController;
}

- (NSManagedObjectContext *)managedObjectContext
{
    return [[[AKModel sharedManager] dataSource] managedObjectContext];
}

#pragma mark Lifecycle VC

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    
    self.detailViewController = (AKMailDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
        // Configure Refresh Control
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
        // Configure View Controller
    [self setRefreshControl:self.refreshControl];
    
    self.fetchedResultsController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mergeChanges:)
                                                 name:NSManagedObjectContextWillSaveNotification
                                               object:self.managedObjectContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mergeChanges:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:self.managedObjectContext];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:NSManagedObjectContextWillSaveNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:NSManagedObjectContextDidSaveNotification];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AKMailMessage *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    self.detailViewController.messageItem = object;
}

#pragma mark - Fetched results controller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo> )sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)configureCell:(AKMailCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    AKMailMessage *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:object.recivedData
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    cell.dataLabel.text = dateString;
    cell.subjectLabel.text = object.subject;
    cell.fromLabel.text = object.from;
}

#pragma mark - model operations methods

- (void)syncMailOperation
{
    __weak AKMailListViewController *wSelf = self;
    
    [[AKModel sharedManager] syncInboxComplete: ^(BOOL isNewMailRecived) {
        if (!isNewMailRecived) {
            [wSelf.refreshControl endRefreshing];
            [wSelf.tableView reloadData];
        }
        [self loadBodyOperation];
    } fail: ^(NSError *fail) {
        [wSelf.refreshControl endRefreshing];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:fail.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)loadBodyOperation
{
    __weak AKMailListViewController *wSelf = self;
    
    [[AKModel sharedManager] loadBodyForMailsComplete: ^() {
        [wSelf.tableView reloadData];
    } fail: ^(NSError *fail) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:fail.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

    //commit changes recived from Core Data
- (void)mergeChanges:(id)object
{
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

#pragma mark - control Actions

- (void)refresh:(id)sender
{
    [self syncMailOperation];
    [self loadBodyOperation];
}

@end
