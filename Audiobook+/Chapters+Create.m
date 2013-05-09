//
//  Chapters+Create.m
//  Audiobook+
//
//  Created by Sheng Xu on 2013-04-30.
//
//

#import "Chapters+Create.h"
#import "Book+Create.h"

@implementation Chapters (Create)

+ (Chapters *)chapterWithTrackInfo: (NSDictionary *)trackInfo inManagedObjectContext:(NSManagedObjectContext*)context {
    
    Chapters *chapter = nil;
    // the followings are used to query to ensure there are no duplicate
    NSString *trackTitle = [trackInfo objectForKey:@"trackTitle"];
    NSString *albumTitle = [trackInfo objectForKey:@"albumTitle"];
    NSNumber *playbackDuration = [trackInfo objectForKey:@"playbackDuration"];
    NSNumber *trackNumber = [trackInfo objectForKey:@"trackNumber"];
    NSNumber *discNumber = [trackInfo objectForKey:@"discNumber"];
    NSString *artist = [trackInfo objectForKey:@"artist"];
    // bookmark track time is the where the track has been played when the user bookmark the track
    NSNumber *lastPlayedTrackTime = [trackInfo objectForKey:@"bookmarkTrackTime"];
    NSNumber *completed = [trackInfo objectForKey:@"completed"];
    
    // the following is NOT used for quering but are added as additional info for the bookmark
    // we must set bookmark
    NSDate *lastPlayedTime = [trackInfo objectForKey:@"bookmarkTime"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Chapters"];
    request.predicate = [NSPredicate predicateWithFormat:@"(trackTitle = %@) AND (fromBook.albumTitle = %@) AND (playbackDuration = %@) AND (trackNumber = %@) AND (discNumber = %@) AND (artist = %@)", trackTitle, albumTitle, playbackDuration, trackNumber, discNumber, artist];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"trackTitle" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@"we have duplicate chapter when creating");
        chapter = [matches lastObject];
        chapter.lastPlayedTrackTime = lastPlayedTrackTime;
        chapter.lastPlayedTime = lastPlayedTime;
        chapter.completed = completed;
        [context deleteObject:[matches objectAtIndex:0]];
        // handle error
    } else if ([matches count] == 0) {
        NSLog(@"creating new chapter");
        chapter = [NSEntityDescription insertNewObjectForEntityForName:@"Chapters" inManagedObjectContext:context];
        chapter.trackTitle = trackTitle;
        chapter.playbackDuration = playbackDuration;
        chapter.trackNumber = trackNumber;
        chapter.discNumber = discNumber;
        chapter.artist = artist;
        chapter.lastPlayedTrackTime = lastPlayedTrackTime;
        chapter.lastPlayedTime = lastPlayedTime;
        chapter.fromBook = [Book bookWithAlbumTitle:albumTitle inManagedObjectContext:context];
        chapter.completed = completed;
        //chapter.bookmarkTitle = [NSString stringWithFormat:@"Chapter %i",[trackNumber integerValue]];
    } else {
        NSLog(@"chapter already exists when creating");
        chapter = [matches lastObject];
        chapter.lastPlayedTrackTime = lastPlayedTrackTime;
        chapter.lastPlayedTime = lastPlayedTime;
        chapter.completed = completed;
    }
    
    return chapter;
}

@end
