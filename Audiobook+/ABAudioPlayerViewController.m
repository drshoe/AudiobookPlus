//
//  ABAudioPlayerViewController.m
//  Audiobook+
//
//  Created by Sheng Xu on 12-07-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ABAudioPlayerViewController.h"
#import "Bookmarks.h"
#import "Book.h"
#import "Bookmarks+Create.h"

#import "ABBookmarkTableViewController.h"
#import "ChapterAndBookmarkViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "CenterPanelViewController.h"
#import "Chapters+Create.h"

@interface ABAudioPlayerViewController ()
@end

static ABAudioPlayerViewController *sharedController;
@implementation ABAudioPlayerViewController
//@synthesize trackCollection = _trackCollection;
@synthesize progressBar = _progressBar;
@synthesize albumTitle = _albumTitle;
@synthesize albumArt = _albumArt;
@synthesize appDelegate = _appDelegate;
@synthesize playbackObserver = _playbackObserver;
//@synthesize sleepTimerPicker = _sleepTimerPicker;
//@synthesize datePickerView = _datePickerView;


+ (ABAudioPlayerViewController *)sharedController {
    if (!sharedController) {
        sharedController = [[ABAudioPlayerViewController alloc] init];
    }
    return sharedController;
}

- (ABTimerViewController *) timerViewController {
    if (!_timerViewController) {
        _timerViewController = [[ABTimerViewController alloc] init];
    }
    return _timerViewController;
}
- (ABAppDelegate *) appDelegate {
    if (!_appDelegate) {
        _appDelegate = (ABAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return _appDelegate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPeriodicTimeObserverToUpdateProgressBar];
    
    // set navigation controller tab bar item
    UIBarButtonItem *chapterAndBookmarkButton = [[UIBarButtonItem alloc] initWithTitle:@"Show" style:UIBarButtonItemStylePlain target:self action:@selector(showChaptersAndBookmarks:)];
    self.navigationItem.rightBarButtonItem = chapterAndBookmarkButton;
    self.shouldResumePlaying = YES;
}


// prepare before the view appears, however the user will experience delay, in this case, it would be small
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [DataManager sharedManager].delegate = self;

    // use AVPlayer to play the tracks because applicationplayer in MPMediaPlayer does not play in the background
    // resume playback whenever this reappears
    if (!self.appDelegate.audioPlayer.playing && self.shouldResumePlaying) {
        [self.appDelegate.audioPlayer playTrack];
    }
    self.shouldResumePlaying = YES;
    // we set the current label to the title of the album
    self.albumTitle.text = self.appDelegate.audioPlayer.albumTitle;
    
    // show album art
    if (self.appDelegate.audioPlayer.artwork) {
        UIImage *artworkImage = [self.appDelegate.audioPlayer.artwork imageWithSize: CGSizeMake (120, 120)];
        [self.albumArt setImage:artworkImage];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [DataManager sharedManager].delegate = nil;
}

// prepare after the view appears, user might see a incomplete view but we can use activity indicator to tell the user that we
// are loading more info
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidUnload
{
    [self setProgressBar:nil];
    //[self setSleepTimerPicker:nil];
    [self setAlbumTitle:nil];
    [self setAlbumArt:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // remove the playback observer
    [self.appDelegate.audioPlayer removeTimeObserver:self.playbackObserver];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - playback controls
- (IBAction)playOrPause {
    if (self.appDelegate.audioPlayer.playing) {
        [self.appDelegate.audioPlayer pauseTrack];
    }
    else {
        [self.appDelegate.audioPlayer playTrack];
    }
}

- (IBAction)next {
    [self.appDelegate.audioPlayer nextTrack];
    if (self.appDelegate.audioPlayer.artwork) {
        UIImage *artworkImage = [self.appDelegate.audioPlayer.artwork imageWithSize: CGSizeMake (120, 120)];
        [self.albumArt setImage:artworkImage];
    }
}

- (IBAction)previous {
    [self.appDelegate.audioPlayer previousTrack];
    if (self.appDelegate.audioPlayer.artwork) {
        UIImage *artworkImage = [self.appDelegate.audioPlayer.artwork imageWithSize: CGSizeMake (120, 120)];
        [self.albumArt setImage:artworkImage];
    }
}



- (IBAction)sleepTimer {
    //self.modalPresentationStyle = UIModalPresentationCurrentContext;
    //[self presentModalViewController:timer animated:YES];
    [self presentSemiViewController:self.timerViewController withOptions:@{
     KNSemiModalOptionKeys.pushParentBack : @(NO),
     KNSemiModalOptionKeys.parentAlpha : @(0.8)
	 }];
}

- (IBAction)fasterTimes {
    if (!self.appDelegate.audioPlayer.onePointFiveSpeed && !self.appDelegate.audioPlayer.doubleSpeed) {
        self.appDelegate.audioPlayer.onePointFiveSpeed = YES;
        self.appDelegate.audioPlayer.rate = 1.5;
    }
    else if (!self.appDelegate.audioPlayer.doubleSpeed && self.appDelegate.audioPlayer.onePointFiveSpeed){
        self.appDelegate.audioPlayer.onePointFiveSpeed = NO;
        self.appDelegate.audioPlayer.doubleSpeed = YES;
        self.appDelegate.audioPlayer.rate = 2.0;
    }
    else {
        self.appDelegate.audioPlayer.onePointFiveSpeed = NO;
        self.appDelegate.audioPlayer.doubleSpeed = NO;
        self.appDelegate.audioPlayer.rate = 1.0;
    }
}





- (IBAction)bookmark {
    NSDictionary *trackInfo = [self.appDelegate.audioPlayer getTrackInfo];
    
    [[DataManager sharedManager] bookmarkWithTrackInfo:trackInfo];
}
#pragma mark - add periodic time observer to update progressbar
- (void) addPeriodicTimeObserverToUpdateProgressBar {
    // we add a playback observer to the player and make our UISlider to act like a progress bar
    CMTime interval = CMTimeMake(50, 100);// 3fps
    self.playbackObserver = [self.appDelegate.audioPlayer addPeriodicTimeObserverForInterval:interval queue:dispatch_get_current_queue() usingBlock: ^(CMTime time) {
        // playbackDuration is an NSNumber object representing time in seconds
        if ([self.appDelegate.audioPlayer.playbackDuration intValue]>0) {
            // CMtime is just a struct that contains value, timescale and other variables
            // get the current time in seconds by deviding value by timescale
            double currentTime = (double)(self.appDelegate.audioPlayer.currentTime.value/self.appDelegate.audioPlayer.currentTime.timescale);
            double normalizedTime =  currentTime / [self.appDelegate.audioPlayer.playbackDuration doubleValue];
            //NSLog(@"the current time is %f", currentTime);
            //NSLog(@"the playback duration is %f", self.appDelegate.audioPlayer.playbackDuration.doubleValue);
            
            //NSLog(@"the normalized time is %f", normalizedTime);
            if (!self.progressBar.isTouched) {
                self.progressBar.value = normalizedTime;
            }
        }
    }];
}

- (void) removePeriodicTimeObserverToUpdateProgressBar {
    [self.appDelegate.audioPlayer removeTimeObserver:self.playbackObserver];
}

#pragma mark - progres bar
- (IBAction)progressBarTouchDown:(OBSlider *)sender {
    self.progressBar.isTouched = YES;
    NSLog(@"just touched the bar");
}

- (IBAction)progressBarTouchUpInside:(OBSlider *)sender {
    if (self.progressBar.isTouched) {
        self.progressBar.isTouched = NO;
        NSLog(@"just released the bar upinside");
    }
}

- (IBAction)progressBarTouchUpOutside:(OBSlider *)sender {
    if (self.progressBar.isTouched) {
        self.progressBar.isTouched = NO;
        NSLog(@"just released the bar upoutside");
    }
}

- (IBAction)progressBar:(OBSlider *)sender {
    NSLog(@"progress bar value has been changed");
    double newTime = sender.value * [self.appDelegate.audioPlayer.playbackDuration doubleValue];
    CMTime newCMTime = CMTimeMake(newTime*self.appDelegate.audioPlayer.currentTime.timescale, self.appDelegate.audioPlayer.currentTime.timescale);
    [self.appDelegate.audioPlayer seekToTime:newCMTime];
    [self saveLastPlayedProgressForCurrentTrack];
}

#pragma mark - chapter and bookmarks
- (void) showChaptersAndBookmarks: (id) sender {
    self.shouldResumePlaying = NO;
    NSDictionary *trackInfo = [self.appDelegate.audioPlayer getTrackInfo];
    NSLog(@"this segue is show bookmarks");
    NSString *albumTitle = self.appDelegate.audioPlayer.albumTitle;
    ChapterAndBookmarkViewController *bookmarkViewController = [ChapterAndBookmarkViewController sharedController];
    [bookmarkViewController setAlbumTitle:albumTitle];
    
    // setting chapters info, put this thing infront of track info to make sure self.tracks is updated before the tableview is reloaded
    [bookmarkViewController setTracks:self.tracks];
    
    [bookmarkViewController setTrackInfo:trackInfo];
    
    

    
    bookmarkViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:bookmarkViewController animated:YES completion:nil];
}

#pragma mark - last played data and timer
- (void) startLastPlayedTimer:(NSTimeInterval) seconds{
    // the timer is started in audioplayer class
    NSLog(@"start timer is called");
    [self.lastPlayedTimer invalidate];
    self.lastPlayedTimer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(saveLastPlayedProgressForCurrentTrack) userInfo:nil
                                                           repeats:YES];
}

- (void) stopLastPlayedTimer {
    if (self.lastPlayedTimer != nil){
        [self.lastPlayedTimer invalidate];
    }
}

- (void) saveLastPlayedProgressForCurrentTrack {
    NSDictionary *trackInfo = [self.appDelegate.audioPlayer getTrackInfo];
    
    [[DataManager sharedManager] chapterWithTrackInfo:trackInfo];
}

#pragma mark - datamanager delegate
- (void)didFinishedCreatingOrOpeningDatabase {

}

@end
