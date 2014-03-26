//
//  ABAudioPlayerViewController.m
//  Audiobook+
//
//  Created by Sheng Xu on 12-07-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ABAudioPlayerViewController.h"
#import "Bookmarks.h"
#import "Book.h"
#import "Bookmarks+Create.h"

#import "ABBookmarkTableViewController.h"
#import "ChapterAndBookmarkViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "CenterPanelViewController.h"
#import "Chapters+Create.h"
#import "ShareThis.h"

@interface ABAudioPlayerViewController ()
@end

static ABAudioPlayerViewController *sharedController;
@implementation ABAudioPlayerViewController
//@synthesize trackCollection = _trackCollection;
@synthesize progressBar = _progressBar;
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
    self.bookmarkAlertView.alpha = 0.0;
    self.screenName = @"PlayerView";
    [self addPeriodicTimeObserverToUpdateProgressBar];
    
    // set navigation controller tab bar item
    UIBarButtonItem *chapterAndBookmarkButton = [[UIBarButtonItem alloc] initWithTitle:@"Bookmarks" style:UIBarButtonItemStylePlain target:self action:@selector(showChaptersAndBookmarks:)];
    self.customNavigationBarItem.rightBarButtonItem = chapterAndBookmarkButton;
    
    // setup custom uinavbar back button
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 30.0f)];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -60.0, 0, 0)];
    [backButton setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.customNavigationBarItem.LeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    self.shouldResumePlaying = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audiobookDidChange) name:kAudioBookDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerWillBegin) name:kAudioBookTimerWillBeginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerWillEnd) name:kAudioBookTimerWillEndNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPausePlaying) name:kAudioBookWillPauseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerResumePlaying) name:kAudioBookWillResumeNotification object:nil];
    
    if (self.appDelegate.audioPlayer.playing) {
        [self playerResumePlaying];
    }
    else {
        [self playerPausePlaying];
    }
    
    [self setupTopAndBottomLabels];
}


// prepare before the view appears, however the user will experience delay, in this case, it would be small
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MarqueeLabel controllerViewWillAppear:self];
    
    [DataManager sharedManager].delegate = self;

    // use AVPlayer to play the tracks because applicationplayer in MPMediaPlayer does not play in the background
    // resume playback whenever this reappears
    if (!self.appDelegate.audioPlayer.playing && self.shouldResumePlaying) {
        [self.appDelegate.audioPlayer playTrack];
        [self saveLastPlayedProgressForCurrentTrack];
    }
    self.shouldResumePlaying = NO;
    
    [self updateAuthorAlbumTrackLabels];
    // show album art
    [self updateArtwork];
    
    [self addPeriodicTimeObserverToUpdateProgressBar];
    
    [self updatePartLabel];
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [DataManager sharedManager].delegate = nil;
    [self removePeriodicTimeObserverToUpdateProgressBar];
}

// prepare after the view appears, user might see a incomplete view but we can use activity indicator to tell the user that we
// are loading more info
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // init marquee label animation, must be put under viewdidappear
    [MarqueeLabel controllerViewDidAppear:self];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // add fading effect to the album art
    
     CAGradientLayer *l = [CAGradientLayer layer];
     l.frame = self.albumArt.bounds;
     l.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor], nil];
     
     l.startPoint = CGPointMake(0.0, 0.0f);
     l.endPoint = CGPointMake(0.0f, 1.0f);
     
     //you can change the direction, obviously, this would be top to bottom fade
     self.albumArt.layer.mask = l;

}


- (void)viewDidUnload
{
    [self setProgressBar:nil];
    //[self setSleepTimerPicker:nil];
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
        [self saveLastPlayedProgressForCurrentTrack];
    }
    else {
        [self.appDelegate.audioPlayer playTrack];
    }
}

- (IBAction)next {
    [self.appDelegate.audioPlayer nextTrack];
    [self updateArtwork];
    [self updatePartLabel];
}

- (IBAction)previous {
    [self.appDelegate.audioPlayer previousTrack];
    [self updateArtwork];
    [self updatePartLabel];
}



#pragma mark - sleep timer
- (IBAction)sleepTimer {
    //self.modalPresentationStyle = UIModalPresentationCurrentContext;
    //[self presentModalViewController:timer animated:YES];
    [self presentSemiViewController:self.timerViewController withOptions:@{
     KNSemiModalOptionKeys.pushParentBack : @(NO),
     KNSemiModalOptionKeys.parentAlpha : @(0.8)
	 }];
}

- (void)timerWillBegin {
    self.timerLabel.text = @"On";
}

- (void) timerWillEnd {
    self.timerLabel.text = @"Off";
}
#pragma mark - speed control and fast backwards
- (IBAction)fasterTimes {
    // update the playback rate in the MPNowPlayingInfoCenter so that the audioprogressbar in the lock screen is working properly
    NSMutableDictionary *nowPlayingInfo = [[MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo mutableCopy];
    
    double rate = 1;
    
    if (!self.appDelegate.audioPlayer.onePointFiveSpeed && !self.appDelegate.audioPlayer.doubleSpeed) {
        self.appDelegate.audioPlayer.onePointFiveSpeed = YES;
        self.appDelegate.audioPlayer.doubleSpeed = NO;
        self.appDelegate.audioPlayer.normalSpeed = NO;
        //self.appDelegate.audioPlayer.rate = 1.5;
        rate = 1.5;
        [self.speedButton setTitle:@"1.5x" forState:UIControlStateNormal];
        [nowPlayingInfo setObject:[NSNumber numberWithFloat:1.5f] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    }
    else if (!self.appDelegate.audioPlayer.doubleSpeed && self.appDelegate.audioPlayer.onePointFiveSpeed){
        self.appDelegate.audioPlayer.onePointFiveSpeed = NO;
        self.appDelegate.audioPlayer.doubleSpeed = YES;
        self.appDelegate.audioPlayer.normalSpeed = NO;
        //self.appDelegate.audioPlayer.rate = 2.0;
        rate = 2.0;
        [self.speedButton setTitle:@"2.0x" forState:UIControlStateNormal];
        [nowPlayingInfo setObject:[NSNumber numberWithFloat:2.0f] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    }
    else {
        self.appDelegate.audioPlayer.onePointFiveSpeed = NO;
        self.appDelegate.audioPlayer.doubleSpeed = NO;
        self.appDelegate.audioPlayer.normalSpeed = YES;
        //self.appDelegate.audioPlayer.rate = 1.0;
        rate = 1.0;
        [self.speedButton setTitle:@"1.0x" forState:UIControlStateNormal];
        [nowPlayingInfo setObject:[NSNumber numberWithFloat:1.0f] forKey:MPNowPlayingInfoPropertyPlaybackRate];
        
    }
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nowPlayingInfo;
    
    if (self.appDelegate.audioPlayer.playing) {
        self.appDelegate.audioPlayer.rate = rate;
    }
}

- (IBAction)goBackward30s:(id)sender{
    //double newTime = sender.value * [self.appDelegate.audioPlayer.playbackDuration doubleValue];
    //CMTime newCMTime = CMTimeMake(newTime*self.appDelegate.audioPlayer.currentTime.timescale, self.appDelegate.audioPlayer.currentTime.timescale);
    //[self.appDelegate.audioPlayer seekToTime:newCMTime];
    //[self saveLastPlayedProgressForCurrentTrack];
    
    double currentTime = (double)(self.appDelegate.audioPlayer.currentTime.value/self.appDelegate.audioPlayer.currentTime.timescale);
    if (currentTime > 30.0f) {
        NSLog(@"current time is %f", currentTime);
    }
    else {
        currentTime = 0.0f;
    }
    CMTime newCMTime = CMTimeMake(currentTime*self.appDelegate.audioPlayer.currentTime.timescale, self.appDelegate.audioPlayer.currentTime.timescale);
    [self.appDelegate.audioPlayer seekToTime:newCMTime];
    [self saveLastPlayedProgressForCurrentTrack];
}




#pragma mark - bookmark
- (IBAction)bookmark {
    NSDictionary *trackInfo = [self.appDelegate.audioPlayer getTrackInfo];
    
    [[DataManager sharedManager] bookmarkWithTrackInfo:trackInfo];
    [self showBookmarkAlert];
}
     
- (void) showBookmarkAlert {
    self.bookmarkAlertView.alpha = 1.0;
    [UIView animateWithDuration:1.5
                     animations:^{self.bookmarkAlertView.alpha = 0.0;}
                     completion:nil];
}
#pragma mark - add periodic time observer to update progressbar
- (void) addPeriodicTimeObserverToUpdateProgressBar {
    // we add a playback observer to the player and make our UISlider to act like a progress bar
    CMTime interval = CMTimeMake(50, 100);// 3fps
    self.playbackObserver = [self.appDelegate.audioPlayer addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock: ^(CMTime time) {
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
                
                // set time played and time remain
                NSTimeInterval timeRemain = [self.appDelegate.audioPlayer.playbackDuration doubleValue] - currentTime;
                NSTimeInterval timePlayed = currentTime;
                self.timePlayed.text = [self stringFromTimeInterval:timePlayed];
                self.timeRemaining.text = [self stringFromTimeInterval:timeRemain];
            }
        }
    }];
}



- (void) removePeriodicTimeObserverToUpdateProgressBar {
    [self.appDelegate.audioPlayer removeTimeObserver:self.playbackObserver];
}

#pragma mark - helper method to convert time interval to string
- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    if (hours < 1) {
        return [NSString stringWithFormat:@"%02i:%02i", (int)minutes, (int)seconds];
    }
    else {
        return [NSString stringWithFormat:@"%02i:%02i:%02i", (int)hours, (int)minutes, (int)seconds];
    }
}

#pragma mark - progres bar
- (IBAction)progressBarTouchDown:(OBSlider *)sender {
    self.progressBar.isTouched = YES;
    NSLog(@"just touched the bar");
}

- (IBAction)progressBarTouchUpInside:(OBSlider *)sender {
    if (self.progressBar.isTouched) {
        NSLog(@"just released the bar upinside");
        double newTime = sender.value * [self.appDelegate.audioPlayer.playbackDuration doubleValue];
        CMTime newCMTime = CMTimeMake(newTime*self.appDelegate.audioPlayer.currentTime.timescale, self.appDelegate.audioPlayer.currentTime.timescale);
        [self.appDelegate.audioPlayer seekToTime:newCMTime];
        [self saveLastPlayedProgressForCurrentTrack];
        self.progressBar.isTouched = NO;
        

    }
}

- (IBAction)progressBarTouchUpOutside:(OBSlider *)sender {
    if (self.progressBar.isTouched) {
        NSLog(@"just released the bar upoutside");
        double newTime = sender.value * [self.appDelegate.audioPlayer.playbackDuration doubleValue];
        CMTime newCMTime = CMTimeMake(newTime*self.appDelegate.audioPlayer.currentTime.timescale, self.appDelegate.audioPlayer.currentTime.timescale);
        [self.appDelegate.audioPlayer seekToTime:newCMTime];
        [self saveLastPlayedProgressForCurrentTrack];
        self.progressBar.isTouched = NO;
        

    }
}

- (IBAction)progressBar:(OBSlider *)sender {
    NSLog(@"progress bar value has been changed, updating timestamp");
    NSTimeInterval timeRemain = (1-sender.value) * [self.appDelegate.audioPlayer.playbackDuration doubleValue];
    NSTimeInterval timePlayed = sender.value * [self.appDelegate.audioPlayer.playbackDuration doubleValue];
    self.timePlayed.text = [self stringFromTimeInterval:timePlayed];
    self.timeRemaining.text = [self stringFromTimeInterval:timeRemain];
}



#pragma mark - chapter and bookmarks
- (IBAction)showChaptersAndBookmarks: (id) sender {
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
    NSLog(@"last played timer is called");
    [self stopLastPlayedTimer];
    self.lastPlayedTimer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(saveLastPlayedProgressForCurrentTrack) userInfo:nil repeats:YES];
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

#pragma mark - sharing
- (IBAction)shareButtonPressed:(id)sender {
    NSString *currentlyPlayingTitle = self.appDelegate.audioPlayer.albumTitle;
    NSString *title = [NSString stringWithFormat:@"I'm listening to \"%@\" with Audiobook+ app on iOS! http://www.audiobookplusapp.com", currentlyPlayingTitle];
    [ShareThis showShareOptionsToShareUrl:[NSURL URLWithString:@"www.audiobookplusapp.com"] title:title image:[UIImage imageNamed:@"centerButton@2x"] onViewController:self];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - update labels
- (void) audiobookDidChange {
    [self updatePartLabel];
    [self updateArtwork];
}

- (void) updateAuthorAlbumTrackLabels {
    self.trackTitleAndScrubbingLabel.text = self.appDelegate.audioPlayer.trackTitle;
    NSString *artistAndAlbumTitle = @"";
    if (self.appDelegate.audioPlayer.artist && self.appDelegate.audioPlayer.artist.length > 0) {
        artistAndAlbumTitle = self.appDelegate.audioPlayer.artist;
        if (self.appDelegate.audioPlayer.albumTitle && self.appDelegate.audioPlayer.albumTitle.length > 0) {
            artistAndAlbumTitle = [artistAndAlbumTitle stringByAppendingString:@" - "];
            artistAndAlbumTitle = [artistAndAlbumTitle stringByAppendingString:self.appDelegate.audioPlayer.albumTitle];
        }
    }
    else {
        if (self.appDelegate.audioPlayer.albumTitle && self.appDelegate.audioPlayer.albumTitle.length > 0) {
            artistAndAlbumTitle = [artistAndAlbumTitle stringByAppendingString:self.appDelegate.audioPlayer.albumTitle];
        }
    }
    self.authorAndAlbumTitleLabel.text = artistAndAlbumTitle;
    //[MarqueeLabel restartLabelsOfController:self];
  
}
- (void) updateArtwork {
    if (self.appDelegate.audioPlayer.artwork) {
        UIImage *artworkImage = [self.appDelegate.audioPlayer.artwork imageWithSize: CGSizeMake (self.appDelegate.audioPlayer.artwork.imageCropRect.size.width, self.appDelegate.audioPlayer.artwork.imageCropRect.size.height)];
        [self.albumArt setImage:artworkImage];
    }
}

- (void)playerPausePlaying {
    [self.playPauseButton setSelected:NO];
}

- (void)playerResumePlaying {
    [self.playPauseButton setSelected:YES];
}

- (void) updatePartLabel {
    NSNumber *currentPartNumber = [NSNumber numberWithInteger:[self.appDelegate.audioPlayer.currentTrackNumber integerValue]+1];
    NSNumber *totalNumber = [NSNumber numberWithInteger:self.appDelegate.audioPlayer.allMPMediaPlayerItems.count];
    self.customNavigationBarItem.title = [[[currentPartNumber stringValue] stringByAppendingString:@" of "]stringByAppendingString:[totalNumber stringValue]];
}

- (void) setupTopAndBottomLabels {
    _authorAndAlbumTitleLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(40 , 114, 240, 21) duration:8.0 andFadeLength:10.0f];
    self.authorAndAlbumTitleLabel.tag = 101;
    self.authorAndAlbumTitleLabel.numberOfLines = 1;
    self.authorAndAlbumTitleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    self.authorAndAlbumTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.authorAndAlbumTitleLabel.textColor = [UIColor blackColor];
    self.authorAndAlbumTitleLabel.backgroundColor = [UIColor clearColor];
    self.authorAndAlbumTitleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:12.0f];
    //self.authorAndAlbumTitleLabel.text = @"This is a test of the label.              view!";
    [self.view addSubview:self.authorAndAlbumTitleLabel];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
