//
//  CenterPanelViewController.m
//  AudiobookPlus
//
//  Created by Sheng Xu on 2013-04-03.
//  Copyright (c) 2013 ShengXu. All rights reserved.
//

#import "CenterPanelViewController.h"
#import "ABIpodAlbumTableViewController.h"
#import "ABAudioPlayerViewController.h"
#import "SettingsViewController.h"

@interface CenterPanelViewController ()

@end
static CenterPanelViewController *sharedController;
@implementation CenterPanelViewController

+ (CenterPanelViewController *) sharedController {
    if (!sharedController) {
        ABIpodAlbumTableViewController *albumTableViewController = [[ABIpodAlbumTableViewController alloc]init];
        sharedController = [[CenterPanelViewController alloc] initWithRootViewController:albumTableViewController];
    }
    return sharedController;
}
#pragma mark - lazy instatiation


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
    // Do any additional setup after loading the view from its nib.
    ABIpodAlbumTableViewController *albumTableViewController = [[ABIpodAlbumTableViewController alloc]init];
    [self setRootViewController:albumTableViewController];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - child view controllers display and transitions
- (void)showViewControllerForType:(SidePanelButtonType)index {
    //make the center panel disappear
    indexToSwitch = index;
    [[JASidePanelController sharedController] setCenterPanelHiddenThenAppearForDuration:0.3];
}

- (void)loadSelectedViewControllerWhenCenterPanelIsHidden {
    switch (indexToSwitch) {
        case SidePanelButtonTypeNowPlaying: {
            [self popToRootViewControllerAnimated:NO];
            [self setRootViewController:[ABAudioPlayerViewController sharedController]];
            break;
        }
        case SidePanelButtonTypeLibrary: {
            [self popToRootViewControllerAnimated:NO];
            ABIpodAlbumTableViewController *albumTableViewController = [[ABIpodAlbumTableViewController alloc]init];
            [self setRootViewController:albumTableViewController];
            break;
        }
        case SidePanelButtonTypeBookmarks: {
            break;
        }
        case SidePanelButtonTypeSettings: {
            [self popToRootViewControllerAnimated:NO];
            SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
            [self setRootViewController:settingsViewController];
            break;
        }
        case SidePanelButtonTypeStats: {
            
            break;
        }
        default:
            break;
    }
    [[JASidePanelController sharedController] _placeButtonForLeftPanel];
}

@end
