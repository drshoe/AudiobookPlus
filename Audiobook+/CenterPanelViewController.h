//
//  CenterPanelViewController.h
//  AudiobookPlus
//
//  Created by Sheng Xu on 2013-04-03.
//  Copyright (c) 2013 ShengXu. All rights reserved.
//

#import "JADebugViewController.h"
#import "SidePanelViewController.h"
#import "LibraryViewController.h"
@interface CenterPanelViewController : JADebugViewController <SidePanelViewControllerDelegate> {
    
}
@property (nonatomic, strong) UINavigationController *libraryViewController;
@end
