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
    self.centerButton = [self addCenterButtonWithImage:[UIImage imageNamed:@"center_button"] highlightImage:nil];
    /*
    UIImage *audiobookSelectedImage = [UIImage imageNamed:@"audiobook_selected"];
    UIImage *audiobookDeselectedImage = [UIImage imageNamed:@"audiobook_deselected"];
    
    self.tabBarItem.image = audiobookDeselectedImage;
    self.tabBarItem.selectedImage = audiobookSelectedImage;
    
 
    UIImage *settingsSelectedImage = [UIImage imageNamed:@"settings_selected"];
    UIImage *settingsDeselectedImage = [UIImage imageNamed:@"settings_deselected"];
    UITabBarItem *settings = [self.tabBar.items objectAtIndex:2];
    settings.image = settingsSelectedImage;
    settings.selectedImage = settingsDeselectedImage;*/
    
    /*
    UITabBar *tabBar = self.tabBar;
    
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:3];
    item0.badgeValue = @"1";
    
    UIImage *audiobookSelectedImage = [UIImage imageNamed:@"testImage"];
    UIImage *audiobookDeselectedImage = [UIImage imageNamed:@"testImage"];
    
    [item0 setImage:audiobookSelectedImage];
     [item1 setImage:audiobookSelectedImage];
     [item2 setImage:audiobookSelectedImage];
     [item3 setImage:audiobookSelectedImage];*/
    

    
}

-(void)willAppearIn:(UINavigationController *)navigationController
{
    [self addCenterButtonWithImage:[UIImage imageNamed:@"cameraTabBarItem.png"] highlightImage:nil];
}


@end
