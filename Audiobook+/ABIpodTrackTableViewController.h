//
//  ABIpodTrackTableViewController.h
//  Audiobook+
//
//  Created by Sheng Xu on 12-07-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ABAppDelegate.h"
#import "CoreDataTableViewController.h"

@interface ABIpodTrackTableViewController : CoreDataTableViewController

@property (nonatomic, copy) NSArray *tracks;
@property (nonatomic, weak) ABAppDelegate *appDelegate;
@property (nonatomic, copy) NSString *albumTitle;

@property (nonatomic, strong) UIManagedDocument *bookmarkDatabase;

@end


