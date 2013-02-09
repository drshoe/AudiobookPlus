//
//  ABAudioPlayer.h
//  Audiobook+
//
//  Created by Sheng Xu on 12-07-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
@interface ABAudioPlayer : AVQueuePlayer

@property (copy, nonatomic) NSNumber *currentTrackNumber;
@property (copy, nonatomic) NSArray *allAVPlayerItems;
@property (copy, nonatomic) NSArray *allMPMediaPlayerItems;
@property (nonatomic, assign) BOOL playing;

// properties that gives the current info of the track
@property (copy, nonatomic) NSString *trackTitle;
@property (copy, nonatomic) NSString *albumTitle;
@property (copy, nonatomic) NSNumber *playbackDuration;
@property (copy, nonatomic) NSNumber *trackNumber;
@property (copy, nonatomic) NSNumber *discNumber;
@property (copy, nonatomic) NSString *artist;
@property (strong, nonatomic) MPMediaItemArtwork *artwork;

@property (assign, nonatomic) BOOL doubleSpeed;
@property (assign, nonatomic) BOOL onePointFiveSpeed;
@property (nonatomic, strong) NSTimer *timer;


- (id)initWithItems: (NSArray *)avPlayerItems withCurrentTrackNumber: (NSNumber *)currentTrackNumber;
- (NSArray *)avPlayerItemsFromMPMediaItems:(NSArray *) tracks;
- (void)playTrack;
- (void)pauseTrack;
- (void)nextTrack;
- (void)previousTrack;
- (void)startTimer: (NSTimeInterval) seconds;
- (void)stopTimer;
- (void)newTrackNumber: (NSNumber *)currentTrackNumber;
- (void)playNewAlbum: (NSArray *)mpMediaItems withCurrentTrackNumber: (NSNumber *)currentTrackNumber;
- (NSDictionary *) getTrackInfo;
@end
