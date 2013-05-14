//
//  MainTabBarViewController.m
//  Audiobook+
//
//  Created by Sheng Xu on 2013-05-13.
//
//

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    self.viewControllers = [NSArray arrayWithObjects:
                            [self viewControllerWithTabTitle:@"Feed" image:[UIImage imageNamed:@"112-group.png"]],
                            [self viewControllerWithTabTitle:@"Popular" image:[UIImage imageNamed:@"29-heart.png"]],
                            [self viewControllerWithTabTitle:@"Share" image:nil],
                            [self viewControllerWithTabTitle:@"News" image:[UIImage imageNamed:@"news.png"]],
                            [self viewControllerWithTabTitle:@"@user" image:[UIImage imageNamed:@"123-id-card.png"]], nil];*/
    [self addCenterButtonWithImage:[UIImage imageNamed:@"cameraTabBarItem.png"] highlightImage:nil];
}

-(void)willAppearIn:(UINavigationController *)navigationController
{
    [self addCenterButtonWithImage:[UIImage imageNamed:@"cameraTabBarItem.png"] highlightImage:nil];
}


@end
