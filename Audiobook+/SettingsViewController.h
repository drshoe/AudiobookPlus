//
//  SettingsViewController.h
//  Audiobook+
//
//  Created by Sheng Xu on 2013-04-22.
//
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *theTableView;

@end
