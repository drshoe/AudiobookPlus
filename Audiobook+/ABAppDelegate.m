//
//  ABAppDelegate.m
//  Audiobook+
//
//  Created by Sheng Xu on 12-07-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ABAppDelegate.h"
#import "JASidePanelController.h"
#import "SidePanelViewController.h"
#import "CenterPanelViewController.h"
#import "Appirater.h"
#import "AnalyticsManager.h"
#import "ShareThis.h"
#import "ABIpodAlbumTableViewController.h"
#import "SettingsViewController.h"
#import "ABAudioPlayerViewController.h"
#import "MainTabBarViewController.h"
@implementation ABAppDelegate

@synthesize window = _window;
@synthesize audioPlayer = _audioPlayer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // we must enable remote control event so that lock screen and ipod control would work with our app
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    // use tab bar view controller
    
    ABIpodAlbumTableViewController *iatvc = [[ABIpodAlbumTableViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:iatvc];
    UIImage *audiobookDeselectedImage = [UIImage imageNamed:@"audiobook_deselected"];
    UIImage *audiobookSelectedImage = [UIImage imageNamed:@"audiobook_selected"];
    nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Library" image:audiobookDeselectedImage tag:0];
    nav.tabBarItem.selectedImage = audiobookSelectedImage;
    nav.tabBarItem.imageInsets = UIEdgeInsetsMake(0,0,0,3);
    
    //ABAudioPlayerViewController *apvc = [ABAudioPlayerViewController sharedController];
    UIViewController *centerController = [[UIViewController alloc] init];
    centerController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Now Playing" image:nil tag:1];
    
    SettingsViewController *svc = [[SettingsViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:svc];
    UIImage *settingsDeselectedImage = [UIImage imageNamed:@"settings_deselected"];
    UIImage *settingsSelectedImage = [UIImage imageNamed:@"settings_selected"];
    nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:settingsDeselectedImage tag:2];
    nav2.tabBarItem.selectedImage = settingsSelectedImage;
    nav2.tabBarItem.imageInsets = UIEdgeInsetsMake(0,0,0,3);
    
    
    NSArray *viewControllersArray = [[NSArray alloc] initWithObjects:nav, centerController,nav2, nil];
    MainTabBarViewController *tabController = [[MainTabBarViewController alloc] init];
    [tabController setViewControllers:viewControllersArray animated:YES];
    
    self.window.rootViewController = tabController;
    
    /* use side panel controller instead, uncomment to use it
    JASidePanelController *panelController = [JASidePanelController sharedController];
    panelController.shouldDelegateAutorotateToVisiblePanel = NO;
    CenterPanelViewController *centerPanelController = [CenterPanelViewController sharedController];
    panelController.delegate = centerPanelController;
    panelController.centerPanel = centerPanelController;
    SidePanelViewController *sidePanelController = [SidePanelViewController sharedController];
    sidePanelController.delegate = centerPanelController;
    panelController.leftPanel = sidePanelController;
    self.window.rootViewController = panelController;
    */
    
    [self.window makeKeyAndVisible];

    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    // appirater
    [Appirater setAppId:@"0000"];
    [Appirater setDaysUntilPrompt:15];
    [Appirater setUsesUntilPrompt:20];
    // significant events are when user resumes a track, or user finishes a track, or user bookmark
    [Appirater setSignificantEventsUntilPrompt:20];
    // 2 = 2 days
    [Appirater setTimeBeforeReminding:2];
    // can set debug to yes to test appirater immediately after launch
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
    
    // setup google analytics
    [[AnalyticsManager sharedManager]initWithTrackingId:@"UA-40741080-1"];
    
    // setup share this
    [ShareThis startSessionWithFacebookURLSchemeSuffix:nil pocketAPI:nil readabilityKey:nil readabilitySecret:nil];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:AppDidBecomeActiveNotificationName object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSNotificationCenter defaultCenter] postNotificationName:AppWillTerminateNotificationName object:nil];
}

// receive remote control events
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    switch(event.subtype) {
        case UIEventSubtypeRemoteControlTogglePlayPause:
            if(self.audioPlayer.playing) {
                [self.audioPlayer pauseTrack];
            }
            else {
                [self.audioPlayer playTrack];
            }
            break;
        case UIEventSubtypeRemoteControlPlay:
            if (!self.audioPlayer.playing) {
                [self.audioPlayer playTrack];
            }
            break;
        case UIEventSubtypeRemoteControlPause:
            if (self.audioPlayer.playing) {
                [self.audioPlayer pauseTrack];
            }
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self.audioPlayer nextTrack];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self.audioPlayer previousTrack];
            break;
        case UIEventSubtypeRemoteControlBeginSeekingForward:
            break;
        case UIEventSubtypeRemoteControlEndSeekingForward:
            break;
        case UIEventSubtypeRemoteControlBeginSeekingBackward:
            break;
        case UIEventSubtypeRemoteControlEndSeekingBackward:
            break;
        case UIEventSubtypeMotionShake:
            break;
        case UIEventSubtypeNone:
            break;
        case UIEventSubtypeRemoteControlStop:
            break;
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [ShareThis handleFacebookOpenUrl:url];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}
@end
