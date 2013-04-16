//
//  ABIpodAlbumTableViewController.h
//  Audiobook+
//
//  Created by Sheng Xu on 12-07-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface ABIpodAlbumTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
}
@property (nonatomic, strong) IBOutlet UITableView *theTableView;
@property (nonatomic, copy) NSArray *albums;
@end
