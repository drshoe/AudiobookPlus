//
//  ABAudioPlayerViewController.h
//  Audiobook+
//
//  Created by Sheng Xu on 12-07-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMedia/CoreMedia.h>
#import "ABAppDelegate.h"
#import "OBSlider.h"
#import "ABTimerViewController.h"
#import "DataManager.h"
#import "GAITrackedViewController.h"
@interface ABAudioPlayerViewController : GAITrackedViewController <DataManagerDelegate>
//@property (nonatomic, strong) MPMediaItemCollection *trackCollection;
@property (nonatomic, weak) ABAppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet OBSlider *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *albumTitle;
@property (weak, nonatomic) IBOutlet UIImageView *albumArt;

@property (nonatomic, strong) id playbackObserver;
//@property (weak, nonatomic) IBOutlet UIPickerView *sleepTimerPicker;
//@property (strong, nonatomic) IBOutlet TDDatePickerController* datePickerView;
//@property (

@property (nonatomic, copy) NSArray *tracks;

@property (nonatomic, strong) ABTimerViewController *timerViewController;
@property (nonatomic, assign) BOOL shouldResumePlaying;

@property (nonatomic, strong) NSTimer *lastPlayedTimer;

@property (nonatomic, strong) IBOutlet UILabel *timePlayed;
@property (nonatomic, strong) IBOutlet UILabel *timeRemaining;

@property (nonatomic, strong) IBOutlet UILabel *scrubbingLabel;
+ (ABAudioPlayerViewController *) sharedController;
- (IBAction)playOrPause;
- (IBAction)next;
- (IBAction)previous;
- (IBAction)progressBar:(OBSlider *)sender;
- (IBAction)sleepTimer;
- (IBAction)fasterTimes;
- (IBAction)bookmark;
- (IBAction)progressBarTouchDown:(OBSlider *)sender;
- (IBAction)progressBarTouchUpInside:(OBSlider *)sender;
- (IBAction)progressBarTouchUpOutside:(OBSlider *)sender;
- (IBAction)showChaptersAndBookmarks: (id) sender;
- (IBAction)back:(id)sender;
- (void) startLastPlayedTimer:(NSTimeInterval) seconds;
- (void) stopLastPlayedTimer;


@end
