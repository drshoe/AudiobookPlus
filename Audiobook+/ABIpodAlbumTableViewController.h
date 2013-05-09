//
//  ABIpodAlbumTableViewController.h
//  Audiobook+
//
//  Created by Sheng Xu on 12-07-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AlbumTableCell.h"
#import "DataManager.h"
#import "GAITrackedViewController.h"
@interface ABIpodAlbumTableViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, DataManagerDelegate> {
    
}
@property (nonatomic, strong) IBOutlet UITableView *theTableView;
@property (nonatomic, copy) NSArray *albums;
@property (nonatomic, strong) NSTimer *reloadTimer;
@end
