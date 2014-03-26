//
//  SettingsViewController.m
//  Audiobook+
//
//  Created by Sheng Xu on 2013-04-22.
//
//

#import "SettingsViewController.h"
#import "CTFeedbackViewController.h"
#import "ShareThis.h"
#import "QuickStartControllerViewController.h"
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
            return SettingGroupHelpCellCount-1;
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
                    /*
                case SettingGroupHelpCellFullGuide:
                    cell.textLabel.text = @"Help";
                    break;*/
                case 1:
                    cell.textLabel.text = @"App Version                                 1.0";
                    //cell.detailTextLabel.text = @"1.0";
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SettingGroupHelp:
            switch (indexPath.row) {
                case SettingGroupHelpCellQuickStart: {
                    QuickStartControllerViewController *quickStartController = [[QuickStartControllerViewController alloc] init];
                    [self.navigationController pushViewController:quickStartController animated:YES];
                    break;
                }
                case SettingGroupHelpCellAppVersion:
                    break;
                default:
                    break;
            }
            break;
        case SettingGroupFeedback:
            switch (indexPath.row) {
                case SettingGroupFeedbackCellTellFriends: {
                    NSString *title = @"Get Audiobook+ for iOS, never lose your audiobook progress again. http://www.audiobookplusapp.com";
                    [ShareThis showShareOptionsToShareUrl:[NSURL URLWithString:@"www.audiobookplusapp.com"] title:title image:[UIImage imageNamed:@"centerButton@2x"] onViewController:self];
                    break;
                }
                case SettingGroupFeedbackCellSendFeedback: {
                    CTFeedbackViewController *feedbackViewController = [CTFeedbackViewController controllerWithTopics:CTFeedbackViewController.defaultTopics localizedTopics:CTFeedbackViewController.defaultLocalizedTopics];
                    feedbackViewController.toRecipients = @[@"audiobookplus@apprena.com"];
                    feedbackViewController.useHTML = NO;
                    [self.navigationController pushViewController:feedbackViewController animated:YES];
                
                    break;
                }
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

@end
