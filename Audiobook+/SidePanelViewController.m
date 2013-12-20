//
//  SidePanelViewController.m
//  AudiobookPlus
//
//  Created by Sheng Xu on 2013-04-03.
//  Copyright (c) 2013 ShengXu. All rights reserved.
//



#import "SidePanelViewController.h"


@interface SidePanelViewController ()

@end
static SidePanelViewController *sharedController;
@implementation SidePanelViewController
@synthesize delegate;
@synthesize buttons;
+ (SidePanelViewController *) sharedController {
    if (!sharedController) {
        sharedController = [[SidePanelViewController alloc] init];
    }
    return sharedController;
}

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
    self.screenName = @"SidePanelView";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sidePanelButtonPressed:(UIButton *)sender {
    [self disableButtons];
    [self.delegate showViewControllerForType:sender.tag];
}

- (void) disableButtons {
    for (UIButton *button in buttons) {
        button.enabled = NO;
    }
}

- (void) enableButtons {
    for (UIButton *button in buttons) {
        button.enabled = YES;
    }
}

@end
