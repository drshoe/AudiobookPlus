//
//  Chapters.h
//  Audiobook+
//
//  Created by Sheng Xu on 2013-04-30.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book;

@interface Chapters : NSManagedObject

@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSNumber * discNumber;
@property (nonatomic, retain) NSNumber * playbackDuration;
@property (nonatomic, retain) NSNumber * trackNumber;
@property (nonatomic, retain) NSString * trackTitle;
@property (nonatomic, retain) NSDate * lastPlayedTime;
@property (nonatomic, retain) NSNumber * lastPlayedTrackTime;
@property (nonatomic, retain) Book *fromBook;

@end
