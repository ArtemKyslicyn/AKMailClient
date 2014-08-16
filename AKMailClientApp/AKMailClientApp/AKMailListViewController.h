//
//  MasterViewController.h
//  AKMailClientApp
//
//  Created by Arcilite on 11.08.14.
//  Copyright (c) 2014 Arcilite. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKMailDetailViewController;

#import <CoreData/CoreData.h>

@interface AKMailListViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) AKMailDetailViewController *detailViewController;




@end
