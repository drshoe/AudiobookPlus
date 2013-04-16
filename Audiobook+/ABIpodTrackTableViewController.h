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

@interface ABIpodTrackTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *theTableView;
@property (nonatomic, copy) NSArray *tracks;
@property (nonatomic, weak) ABAppDelegate *appDelegate;
@property (nonatomic, copy) NSString *albumTitle;

@end


