//
//  ABAudioPlayer.m
//  Audiobook+
//
//  Created by Sheng Xu on 12-07-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ABAudioPlayer.h"
#import "ABAudioPlayerViewController.h"
#import "Appirater.h"

@implementation ABAudioPlayer
@synthesize currentTrackNumber = _currentTrackNumber;
@synthesize allAVPlayerItems = _allTracks;
@synthesize allMPMediaPlayerItems = _allMPMediaPlayerItems;
// instance bool variable is always initialized to NO, but bool playing will be initialized to garbage
@synthesize playing = _playing;
@synthesize trackTitle = _trackTitle;
@synthesize albumTitle = _albumTitle;
@synthesize playbackDuration = _playbackDuration;
@synthesize trackNumber = _trackNumber;
@synthesize discNumber = _discNumber;
@synthesize artist = _artist;
@synthesize doubleSpeed = _doubleSpeed;
@synthesize onePointFiveSpeed = _onePointFiveSpeed;
@synthesize normalSpeed = _normalSpeed;
@synthesize timer=_timer;
@synthesize artwork = _artwork;

- (id)initWithItems: (NSArray *)mpMediaItems withCurrentTrackNumber: (NSNumber *)currentTrackNumber {
    // first we create a subarray (starting from the current track number) then add it to the queue
    NSArray *avPlayerItems = [self avPlayerItemsFromMPMediaItems:mpMediaItems];
    NSArray *avPlayerItemsSubArray = [avPlayerItems subarrayWithRange:NSMakeRange([currentTrackNumber intValue],avPlayerItems.count-[currentTrackNumber intValue])];
    NSLog(@"the beginning of the range %i", [currentTrackNumber intValue]);
    NSLog(@"the length of the range is %i",avPlayerItems.count-[currentTrackNumber intValue]);
    if (self = [super initWithItems:avPlayerItemsSubArray]) {
        self.allAVPlayerItems = avPlayerItems;
        self.currentTrackNumber = currentTrackNumber;
        self.allMPMediaPlayerItems = mpMediaItems;
        self.actionAtItemEnd = AVPlayerActionAtItemEndAdvance;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEndAndPrepareToAdvance:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[self currentItem]];
        self.normalSpeed = YES;
        self.doubleSpeed = NO;
        self.onePointFiveSpeed = NO;
    }
    return self;
}

- (void) playNewAlbum: (NSArray *)mpMediaItems withCurrentTrackNumber: (NSNumber *)currentTrackNumber {
    NSArray *avPlayerItems = [self avPlayerItemsFromMPMediaItems:mpMediaItems];
    self.allAVPlayerItems = avPlayerItems;
    self.currentTrackNumber = currentTrackNumber;
    self.allMPMediaPlayerItems = mpMediaItems;
    [self newTrackNumber:currentTrackNumber];
    
}

- (void)newTrackNumber: (NSNumber *)currentTrackNumber {
    self.currentTrackNumber = currentTrackNumber;
    [self removeAllItems];
    for (int i=[currentTrackNumber intValue];i<self.allAVPlayerItems.count; i++) {
        [self insertItem:[self.allAVPlayerItems objectAtIndex:i] afterItem:nil];
    }
    NSLog(@"jump to the new track number %i", [currentTrackNumber intValue]);
    MPMediaItem *track = [self.allMPMediaPlayerItems objectAtIndex:[self.currentTrackNumber intValue]];
    [self setNowPlayingInfo:track];
}

// method that converts mpmediaitems to avplayeritems
- (NSArray *)avPlayerItemsFromMPMediaItems:(NSArray *) mpMediaItems{
    // use a loop to add all tracks after and including the current track to the queue
    NSMutableArray *playerItems = [NSMutableArray array];
    for (int i=0; i<mpMediaItems.count; i++) {
        MPMediaItem *track = [mpMediaItems objectAtIndex:i];
        NSURL *trackURL = [track valueForProperty:MPMediaItemPropertyAssetURL];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:trackURL];
        [playerItems addObject:playerItem];
    }
    return playerItems;
}

- (void)setNowPlayingInfo:(MPMediaItem *)track{
    MPNowPlayingInfoCenter *nowPlayingInfoCentre = [MPNowPlayingInfoCenter defaultCenter];
    // lets get the info for the current track
    NSString *albumTitle = [track valueForProperty:MPMediaItemPropertyAlbumTitle];
    NSNumber *albumTrackCount = [track valueForProperty:MPMediaItemPropertyAlbumTrackCount];
    NSNumber *albumTrackNumber = [track valueForProperty:MPMediaItemPropertyAlbumTrackNumber];
    NSString *artist = [track valueForProperty:MPMediaItemPropertyArtist];
    MPMediaItemArtwork *artwork = [track valueForProperty:MPMediaItemPropertyArtwork];
    NSString *composer = [track valueForProperty:MPMediaItemPropertyComposer];
    NSNumber *discCount = [track valueForProperty:MPMediaItemPropertyDiscCount];
    NSNumber *discNumber = [track valueForProperty:MPMediaItemPropertyDiscNumber];
    NSString *genre = [track valueForProperty:MPMediaItemPropertyGenre];
    NSNumber *persistentID = [track valueForProperty:MPMediaItemPropertyPersistentID];
    NSNumber *playbackDuration = [track valueForProperty:MPMediaItemPropertyPlaybackDuration];
    NSString *title = [track valueForProperty:MPMediaItemPropertyTitle];
    self.trackTitle = title;
    self.albumTitle = albumTitle;
    self.artist = artist;
    self.trackNumber = albumTrackNumber;
    self.playbackDuration = playbackDuration;
    self.discNumber = discNumber;
    //if (title) {
    self.trackTitle = title;
    self.albumTitle = albumTitle;
    self.artist = artist;
    self.trackNumber = albumTrackNumber;
    self.playbackDuration = playbackDuration;
    self.discNumber = discNumber;
    self.artwork = artwork;
    
    /////////////////////// additional metadata needs to be filled, see documentation
    
    // save all the info
    NSMutableDictionary *nowPlayingInfo = [[NSMutableDictionary alloc] init];
    if (albumTitle) {
        [nowPlayingInfo setObject:albumTitle forKey:MPMediaItemPropertyAlbumTitle];
    }
    
    if (albumTrackNumber && [albumTrackNumber integerValue] !=-1) {
        [nowPlayingInfo setObject:albumTrackNumber forKey:MPMediaItemPropertyAlbumTrackNumber];
    }
    if (albumTrackCount && [albumTrackCount integerValue] !=-1) {
        [nowPlayingInfo setObject:albumTrackCount forKey:MPMediaItemPropertyAlbumTrackCount];
    }
    if (artist) {
        [nowPlayingInfo setObject:artist forKey:MPMediaItemPropertyArtist];
    }
    if (artwork) {
        [nowPlayingInfo setObject:artwork forKey:MPMediaItemPropertyArtwork];
    }
    if (composer) {
        [nowPlayingInfo setObject:composer forKey:MPMediaItemPropertyComposer];
    }
    if (discCount && [discCount integerValue] !=-1) {
        [nowPlayingInfo setObject:discCount forKey:MPMediaItemPropertyDiscCount];
    }
    if (discNumber && [discNumber integerValue] != -1) {
        [nowPlayingInfo setObject:discNumber forKey:MPMediaItemPropertyDiscNumber];
    }
    if (genre) {
        [nowPlayingInfo setObject:genre forKey:MPMediaItemPropertyGenre];
    }
    if (persistentID) {
        [nowPlayingInfo setObject:persistentID forKey:MPMediaItemPropertyPersistentID];
    }
    if (playbackDuration) {
        [nowPlayingInfo setObject:playbackDuration forKey:MPMediaItemPropertyPlaybackDuration];
    }
    if (title) {
        [nowPlayingInfo setObject:title forKey:MPMediaItemPropertyTitle];
    }
    
    if (self.normalSpeed) {
        [nowPlayingInfo setObject:[NSNumber numberWithFloat:1.0f] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    }
    else if (self.doubleSpeed) {
        [nowPlayingInfo setObject:[NSNumber numberWithFloat:2.0f] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    }
    else if (self.onePointFiveSpeed) {
        [nowPlayingInfo setObject:[NSNumber numberWithFloat:1.5f] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    }
    nowPlayingInfoCentre.nowPlayingInfo = nowPlayingInfo;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAudioBookDidChangeNotification object:nil];
}

- (void)playTrack {
    
    // get the track number from the global currentTrackNumber
    MPMediaItem *track = [self.allMPMediaPlayerItems objectAtIndex:[self.currentTrackNumber intValue]];
    //NSURL *trackURL = [track valueForProperty:MPMediaItemPropertyAssetURL];
    //NSLog(@"the title of the track is %@",[track valueForProperty:MPMediaItemPropertyTitle]);
    //NSLog(@"the URL of the track is %@",trackURL);
    // initialize the playerItem
    //AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:trackURL];
    //NSMutableArray *playerItems = [NSMutableArray arrayWithObject:playerItem];
    // initialize the audioplayer
    // we use the audioplayer instance from the app delegate so that our audio remains playing even when the user goes back
    [self play];
    [self setNowPlayingInfo:track];
    self.playing = YES;

    // ensures that our audio does not play along side with any other audio sources from other apps
    NSError *setCategoryError = nil;
    NSError *setActiveError = nil;
    //NSLog(@"the category error is %@", setCategoryError);
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    [[AVAudioSession sharedInstance] setActive:YES error:&setActiveError];
    NSLog(@"play");
    // set pause at the end if this is the last track
    if ([self.currentTrackNumber integerValue] == [self.allMPMediaPlayerItems count]-1) {
        self.actionAtItemEnd = AVPlayerActionAtItemEndPause;
    }
    // start timer to save the last played time to database
    [[ABAudioPlayerViewController sharedController] startLastPlayedTimer:kTimer10s];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAudioBookWillResumeNotification object:nil];
}

- (void)pauseTrack {
    [self pause];
    self.playing = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kAudioBookWillPauseNotification object:nil];
    NSLog(@"paused");
    NSError *setActiveError = nil;
    [[AVAudioSession sharedInstance] setActive:NO error:&setActiveError];
    [[ABAudioPlayerViewController sharedController] stopLastPlayedTimer];
    
}

- (void)previousTrack {
    // need to check the time first
    // we need to check the time first, if the user has been listening to this particular track for more than 5 seconds
    if ([self.currentTrackNumber intValue]>0) {
        self.actionAtItemEnd = AVPlayerActionAtItemEndAdvance;
        int currentTrackNumber = [self.currentTrackNumber intValue];
        currentTrackNumber--;
        self.currentTrackNumber = [NSNumber numberWithInt:currentTrackNumber];
        [self removeAllItems];
        for (int i=currentTrackNumber;i<self.allAVPlayerItems.count; i++) {
            [self insertItem:[self.allAVPlayerItems objectAtIndex:i] afterItem:nil];
        }
        [self seekToTime:kCMTimeZero];
        [self playTrack];
        NSLog(@"previous");
        //NSLog(@"%@",self.items);
    }
}



- (void)nextTrack {
    if ([self.currentTrackNumber intValue]<self.allAVPlayerItems.count-1) {
        int currentTrackNumber = [self.currentTrackNumber intValue];
        currentTrackNumber++;
        if (currentTrackNumber == [self.allMPMediaPlayerItems count]-1) {
            // if we are at the last track, we should throw a warning and stop
            self.actionAtItemEnd = AVPlayerActionAtItemEndPause;
        }
        self.currentTrackNumber = [NSNumber numberWithInt:currentTrackNumber];
        [self advanceToNextItem];
        [self seekToTime:kCMTimeZero];
        MPMediaItem *track = [self.allMPMediaPlayerItems objectAtIndex:[self.currentTrackNumber intValue]];
        [self setNowPlayingInfo:track];
        NSLog(@"next");
    }
}

#pragma mark - timers
- (void) startTimer:(NSTimeInterval) seconds{
    [[NSNotificationCenter defaultCenter] postNotificationName:kAudioBookTimerWillBeginNotification object:nil];
    NSLog(@"stop timer is called");
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(stopTimerAndTrack) userInfo:nil
                                                         repeats:NO];
}

- (void) stopTimer {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAudioBookTimerWillEndNotification object:nil];
    if (self.timer != nil){
        [self.timer invalidate];
    }
}

- (void) stopTimerAndTrack {
    [self pauseTrack];
    [self stopTimer];
}

- (NSDictionary *) getTrackInfo {
    NSMutableDictionary *trackInfo = [[NSMutableDictionary alloc] init];
    trackInfo = [self setGeneralTrackInfo:trackInfo];
    [trackInfo setObject:[NSNumber numberWithBool:NO] forKey:@"completed"];
    return trackInfo;
}

- (NSDictionary *)getTrackInfoWithCompletedFlag {
    NSMutableDictionary *trackInfo = [[NSMutableDictionary alloc] init];
    trackInfo = [self setGeneralTrackInfo:trackInfo];
    [trackInfo setObject:[NSNumber numberWithBool:YES] forKey:@"completed"];
    return trackInfo;
}

- (NSMutableDictionary *)setGeneralTrackInfo: (NSMutableDictionary *)trackInfo {
    // trackTitle, albumTitle, playbackDuration, trackNumber, discNumber, artist;
    if (self.albumTitle) {
        [trackInfo setObject:self.albumTitle forKey:@"albumTitle"];
    }
    if (self.trackTitle) {
        [trackInfo setObject:self.trackTitle forKey:@"trackTitle"];
    }
    if (self.playbackDuration) {
        [trackInfo setObject:self.playbackDuration forKey:@"playbackDuration"];
    }
    if (self.trackNumber) {
        [trackInfo setObject:self.trackNumber forKey:@"trackNumber"];
    }
    if (self.discNumber) {
        [trackInfo setObject:self.discNumber forKey:@"discNumber"];
    }
    if (self.artist) {
        [trackInfo setObject:self.artist forKey:@"artist"];
    }
    [trackInfo setObject:[NSDate date] forKey:@"bookmarkTime"];
    // we use the progress bar value to record the point on the particular track. it can later
    // be easily converted to CMTime and then use seekToTime to move to the correct instant.
    double currentTime = (double)(self.currentTime.value/self.currentTime.timescale);
    double normalizedTime =  currentTime / [self.playbackDuration doubleValue];
    [trackInfo setObject: [NSNumber numberWithFloat:normalizedTime] forKey:@"bookmarkTrackTime"];
    NSLog (@"trackInfo has been constructed");
    //NSLog (@"the trackInfo contains %@",trackInfo);
    return trackInfo;
}

- (void)playerItemDidReachEndAndPrepareToAdvance:(NSNotification *)notification {
    //[self seekToTime:kCMTimeZero];
    //[[NSNotificationCenter defaultCenter] postNotificationName:kAudioBookDidChangeNotification object:nil];
    // tell appirater that a user has finished playing a track, which is a significant event
    [Appirater userDidSignificantEvent:YES];

    [[DataManager sharedManager] chapterWithTrackInfo:[self getTrackInfoWithCompletedFlag]];
    if ([self.currentTrackNumber integerValue]+1 <= [self.allMPMediaPlayerItems count]-1) {
        // if we are about to play the last track, we should set the action at the end of next track to be pause
        if ([self.currentTrackNumber integerValue]+1 == [self.allMPMediaPlayerItems count]-1) {
            self.actionAtItemEnd = AVPlayerActionAtItemEndPause;
        }
        else {
            //update now playinginfo to the next track
            self.actionAtItemEnd = AVPlayerActionAtItemEndAdvance;
        }
        [self newTrackNumber:[NSNumber numberWithInteger:[self.currentTrackNumber integerValue]+1]];

    }
    else {
        [self pauseTrack];
    }
    
    // bug in ios 7, must readd the observer. for some reason, it got removed after one call
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEndAndPrepareToAdvance:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self currentItem]];
}


@end
