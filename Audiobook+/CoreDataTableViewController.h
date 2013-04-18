//
//  CoreDataTableViewController.h
//  Audiobook+
//
//  Created by Sheng Xu on 12-07-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataTableViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *theTableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;


- (void)performFetch;


@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;

// Set to YES to get some debugging output in the console.
@property BOOL debug;

@end
