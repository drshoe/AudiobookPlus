//
//  ABBookmarkTableViewController.h
//  Audiobook+
//
//  Created by Sheng Xu on 2012-07-27.
//
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Book.h"
#import "ABAppDelegate.h"
#import "DataManager.h"
@interface ABBookmarkTableViewController : CoreDataTableViewController <DataManagerDelegate>

// model is the core data database of bookmarks
@property (nonatomic, copy) NSString *albumTitle;
@property (nonatomic, copy) NSDictionary *trackInfo;
//@property (nonatomic, retain) Book *book;
@property (nonatomic, weak) ABAppDelegate *appDelegate;

+(ABBookmarkTableViewController *)sharedController;
@end
