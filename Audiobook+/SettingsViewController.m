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
    self.trackedViewName = @"SettingsView";
    // Do any additional setup after loading the view from its nib.
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    switch (section) {
        case SettingsSectionManageSettings:
            return 2;
            break;
        case SettingsSectionHelp:
            return 6;
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
        // manage connections
        case SettingsSectionManageSettings:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Sync Bookmarks with iCloud";
                    break;
                case 1:
                    cell.textLabel.text = @"Disable Auto-lock";
                    break;
                default:
                    break;
            }
            break;
        // help
        case SettingsSectionHelp:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"How to Sync with iTunes";
                    break;
                case 1:
                    cell.textLabel.text = @"FAQ";
                    break;
                case 2:
                    cell.textLabel.text = @"User Guide";
                    break;
                case 3:
                    cell.textLabel.text = @"Contact Us";
                    break;
                case 4:
                    cell.textLabel.text = @"About Us";
                    break;
                case 5:
                    cell.textLabel.text = @"Share";
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
