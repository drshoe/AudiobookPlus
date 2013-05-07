//
//  DataManager.h
//  Audiobook+
//
//  Created by Sheng Xu on 2013-05-01.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Chapters+Create.h"
@protocol DataManagerDelegate
- (void) didFinishedCreatingOrOpeningDatabase;
@end
@interface DataManager : NSObject
@property (nonatomic, strong) UIManagedDocument *bookmarkDatabase;
@property (nonatomic, weak) id <DataManagerDelegate> delegate;
+ (DataManager *) sharedManager;
- (void)bookmarkWithTrackInfo:(NSDictionary *)trackInfo;
- (void)chapterWithTrackInfo:(NSDictionary *)trackInfo;
- (Chapters *)getChapterWithTrack: (MPMediaItem *)track;
- (Chapters *)lastPlayedChapterForAlbumTitle:(NSString *)albumTitle;
- (BOOL) trackInfoForTrack:(MPMediaItem *)track matchesTrackInfo:(NSDictionary *)trackInfo;
- (BOOL) isLastPlayedTrack:(MPMediaItem *)track forAlbum:(NSString *)albumTitle;
- (NSIndexPath *)indexPathForLastPlayedTrackForTracks: (NSArray *)tracks inAlbum: (NSString *)albumTitle;
- (NSIndexPath *)indexPathForNowPlayingTrackForTracks: (NSArray *)tracks inAlbum: (NSString *)albumTitle;
@end
