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
@end
