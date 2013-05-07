//
//  Bookmarks+Create.m
//  Audiobook+
//
//  Created by Sheng Xu on 2012-08-02.
//
//

#import "Bookmarks+Create.h"
#import "Book+Create.h"

@implementation Bookmarks (Create)

+ (Bookmarks *)bookmarkWithTrackInfo: (NSDictionary *)trackInfo inManagedObjectContext:(NSManagedObjectContext*)context {
    
    Bookmarks *bookmark = nil;
    // the followings are used to query to ensure there are no duplicate
    NSString *trackTitle = [trackInfo objectForKey:@"trackTitle"];
    NSString *albumTitle = [trackInfo objectForKey:@"albumTitle"];
    NSNumber *playbackDuration = [trackInfo objectForKey:@"playbackDuration"];
    NSNumber *trackNumber = [trackInfo objectForKey:@"trackNumber"];
    NSNumber *discNumber = [trackInfo objectForKey:@"discNumber"];
    NSString *artist = [trackInfo objectForKey:@"artist"];
    // bookmark track time is the where the track has been played when the user bookmark the track
    NSNumber *bookmarkTrackTime = [trackInfo objectForKey:@"bookmarkTrackTime"];
    
    // the following is NOT used for quering but are added as additional info for the bookmark
    // we must set bookmark
    NSDate *bookmarkTime = [trackInfo objectForKey:@"bookmarkTime"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bookmarks"];
    request.predicate = [NSPredicate predicateWithFormat:@"(trackTitle = %@) AND (fromBook.albumTitle = %@) AND (playbackDuration = %@) AND (trackNumber = %@) AND (discNumber = %@) AND (artist = %@) AND (bookmarkTrackTime = %@)", trackTitle, albumTitle, playbackDuration, trackNumber, discNumber, artist, bookmarkTrackTime];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"trackTitle" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@"we have duplicate bookmarks");
        // handle error
    } else if ([matches count] == 0) {
        NSLog(@"creating new bookmark");
        bookmark = [NSEntityDescription insertNewObjectForEntityForName:@"Bookmarks" inManagedObjectContext:context];
        bookmark.trackTitle = trackTitle;
        bookmark.playbackDuration = playbackDuration;
        bookmark.trackNumber = trackNumber;
        bookmark.discNumber = discNumber;
        bookmark.artist = artist;
        bookmark.bookmarkTrackTime = bookmarkTrackTime;
        bookmark.bookmarkTime = bookmarkTime;
        bookmark.fromBook = [Book bookWithAlbumTitle:albumTitle inManagedObjectContext:context];
        //bookmark.note = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin eget urna orci. Aenean vel luctus quam. Integer mollis ante in neque tincidunt at vulputate lectus ultrices. Nunc vitae diam purus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam elementum tempor neque, in volutpat magna vestibulum in. Cras vel lacus ligula. Proin enim turpis, sollicitudin vitae ultrices ac, venenatis nec mi. Integer sodales, felis non mollis fringilla, elit dolor placerat dolor, nec pulvinar nunc tellus eget erat. Integer porttitor elit a nulla ornare eleifend. Praesent laoreet, nibh et auctor interdum, neque odio ornare dolor, quis ultrices augue nulla id velit. Integer felis dui, molestie vitae malesuada nec, mollis et risus. Proin quis dui sed velit iaculis blandit et interdum metus.";
        bookmark.bookmarkTitle = [NSString stringWithFormat:@"Chapter %i",[trackNumber integerValue]];
    } else {
        NSLog(@"bookmark already exists");
        bookmark = [matches lastObject];
    }
    
    return bookmark;
}


@end
