//
//  SettingsViewController.m
//  Audiobook+
//
//  Created by Sheng Xu on 2013-04-22.
//
//

#import "SettingsViewController.h"


@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"SettingsView";
    // Do any additional setup after loading the view from its nib.
    self.title = @"Settings";
    
    // reduce the top margin of the tableview so it is visually consistent
    self.theTableView.contentInset = UIEdgeInsetsMake(-15, 0, -15, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview delegate and data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return SettingGroupCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    switch (section) {
        case SettingGroupHelp:
            return SettingGroupHelpCellCount;
            break;
        case SettingGroupFeedback:
            return SettingGroupFeedbackCellCount;
            break;
        default:
            return 0;
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.section) {
        // help
        case SettingGroupHelp:
            switch (indexPath.row) {
                case SettingGroupHelpCellQuickStart:
                    cell.textLabel.text = @"Quick Start Guide";
                    break;
                case SettingGroupHelpCellFullGuide:
                    cell.textLabel.text = @"Help";
                    break;
                case 2:
                    cell.textLabel.text = @"App Version";
                    break;
                default:
                    break;
            }
            break;
        case SettingGroupFeedback:
            switch (indexPath.row) {
                case SettingGroupFeedbackCellTellFriends:
                    cell.textLabel.text = @"Tell Friends About Audiobook+";
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    break;
                case SettingGroupFeedbackCellSendFeedback:
                    cell.textLabel.text = @"Send Feedback";
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    break;
                default:
                    break;
            }
            break;

        default:
            break;
    }
    
    return cell;
}

@end
