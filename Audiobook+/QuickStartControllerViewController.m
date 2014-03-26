//
//  QuickStartControllerViewController.m
//  Audiobook+
//
//  Created by Daniel Sheng Xu on 2014-03-25.
//
//

#import "QuickStartControllerViewController.h"

@interface QuickStartControllerViewController ()

@end

@implementation QuickStartControllerViewController

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
    [self.scrollView addSubview:self.helpView];
    self.scrollView.contentSize = self.helpView.frame.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
