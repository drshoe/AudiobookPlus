//
//  SidePanelViewController.h
//  AudiobookPlus
//
//  Created by Sheng Xu on 2013-04-03.
//  Copyright (c) 2013 ShengXu. All rights reserved.
//

#import "JADebugViewController.h"
@protocol SidePanelViewControllerDelegate
- (void) showViewControllerForType: (SidePanelButtonType) index;
@end;

@interface SidePanelViewController : JADebugViewController

+ (SidePanelViewController *)sharedController;
@property (nonatomic, assign) id <SidePanelViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttons;

- (void) enableButtons;
@end
