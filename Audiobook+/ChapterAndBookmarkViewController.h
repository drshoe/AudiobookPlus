//
//  ChapterAndBookmarkViewController.h
//  Audiobook+
//
//  Created by Sheng Xu on 2013-04-23.
//
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "ABAppDelegate.h"
@interface ChapterAndBookmarkViewController : CoreDataTableViewController
// model is the core data database of bookmarks
@property (nonatomic, copy) NSString *albumTitle;
@property (nonatomic, copy) NSDictionary *trackInfo;
//@property (nonatomic, retain) Book *book;
@property (nonatomic, strong) UIManagedDocument *bookmarkDatabase;
@property (nonatomic, weak) ABAppDelegate *appDelegate;

// code below is for chapters info
@property (nonatomic, copy) NSArray *tracks;

@property (nonatomic, assign) ChapterAndBookmarkTable selectedIndex;
+(ChapterAndBookmarkViewController *)sharedController;
@end
