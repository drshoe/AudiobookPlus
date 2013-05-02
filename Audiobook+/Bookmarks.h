//
//  Bookmarks.h
//  Audiobook+
//
//  Created by Sheng Xu on 2013-05-01.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book;

@interface Bookmarks : NSManagedObject

@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSDate * bookmarkTime;
@property (nonatomic, retain) NSString * bookmarkTitle;
@property (nonatomic, retain) NSNumber * bookmarkTrackTime;
@property (nonatomic, retain) NSNumber * discNumber;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSNumber * playbackDuration;
@property (nonatomic, retain) NSNumber * trackNumber;
@property (nonatomic, retain) NSString * trackTitle;
@property (nonatomic, retain) Book *fromBook;

@end
