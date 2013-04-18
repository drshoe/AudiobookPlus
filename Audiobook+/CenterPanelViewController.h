//
//  CenterPanelViewController.h
//  AudiobookPlus
//
//  Created by Sheng Xu on 2013-04-03.
//  Copyright (c) 2013 ShengXu. All rights reserved.
//

#import "JADebugViewController.h"
#import "SidePanelViewController.h"
#import "JASidePanelController.h"
#import "TVNavigationController.h"

@interface CenterPanelViewController : TVNavigationController <SidePanelViewControllerDelegate, JASidePanelControllerDelegate> {
    SidePanelButtonType indexToSwitch;
}
+ (CenterPanelViewController *)sharedController;



@end
