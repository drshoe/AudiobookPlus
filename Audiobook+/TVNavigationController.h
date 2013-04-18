//
//  TVNavigationController.h
//  Audiobook+
//
//  Created by Sheng Xu on 2013-04-18.
//
//

#import <UIKit/UIKit.h>

@interface TVNavigationController : UINavigationController {
    UIViewController *fakeRootViewController;
}

@property(nonatomic, retain) UIViewController *fakeRootViewController;

-(void)setRootViewController:(UIViewController *)rootViewController;

@end
