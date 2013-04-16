//
//  CenterPanelViewController.m
//  AudiobookPlus
//
//  Created by Sheng Xu on 2013-04-03.
//  Copyright (c) 2013 ShengXu. All rights reserved.
//

#import "CenterPanelViewController.h"

@interface CenterPanelViewController ()

@end

@implementation CenterPanelViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - child view controllers display and transitions
- (void)showViewControllerForType:(SidePanelButtonType)index {
    switch (index) {
        case SidePanelButtonTypeNowPlaying:
            self displayContentController:<#(UIViewController *)#>
            break;
        case SidePanelButtonTypeLibrary:
            
            break;
        case SidePanelButtonTypeBookmarks:
            
            break;
        case SidePanelButtonTypeSettings:
            
            break;
        case SidePanelButtonTypeStats:
            
            break;
        default:
            break;
    }
    
}

- (void) displayContentController: (UIViewController*) content;
{
    [self addChildViewController:content];                 // 1
    //content.view.frame = [self frameForContentController]; // 2
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];          // 3
}

- (void) hideContentController: (UIViewController*) content
{
    [content willMoveToParentViewController:nil];  // 1
    [content.view removeFromSuperview];            // 2
    [content removeFromParentViewController];      // 3
}
@end
