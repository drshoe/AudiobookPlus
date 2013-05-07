//
//  DataManager.m
//  Audiobook+
//
//  Created by Sheng Xu on 2013-05-01.
//
//

#import "DataManager.h"
#import "Bookmarks+Create.h"
#import "Book+Create.h"
#import "ABAppDelegate.h"

static DataManager *sharedManager;
@implementation DataManager

// bookmark database has a custom setter
// first we check if the database that is being set is in fact identical. so we dont waste resources
// then we open or create the document for this database
/*
 - (void)setBookmarkDatabase:(UIManagedDocument *)bookmarkDatabase
 {
 if (_bookmarkDatabase != bookmarkDatabase) {
 _bookmarkDatabase = bookmarkDatabase;
 }
 }*/

+(DataManager *) sharedManager {
    if (!sharedManager) {
        sharedManager = [[DataManager alloc] init];
        [sharedManager initDataBase];
    }
    return sharedManager;
}

- (void) initDataBase {
    if (!self.bookmarkDatabase) {  // for demo purposes, we'll create a default database if none is set
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Bookmark Database"];
        // url is now "<Documents Directory>/Default Photo Database"
        self.bookmarkDatabase = [[UIManagedDocument alloc] initWithFileURL:url]; // setter will create this for us on disk
    }
    [self initBookmarkDatabase];
}

- (void) initBookmarkDatabase {
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.bookmarkDatabase.fileURL path]]) {
        // does not exist on disk, so create it
        [self.bookmarkDatabase saveToURL:self.bookmarkDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            // creation successful, now let's populate the database
            if (success) {
                NSLog(@"create database");
                [self.delegate didFinishedCreatingOrOpeningDatabase];
            }
            else {
                NSLog(@"failed to create the database");
            }
            
            
        }];
    } else if (self.bookmarkDatabase.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        [self.bookmarkDatabase openWithCompletionHandler:^(BOOL success) {
            // open successful, lets populate the database
            if (success) {
                NSLog (@"successfully opened the database");
                [self.delegate didFinishedCreatingOrOpeningDatabase];
            }
            else {
                NSLog (@"failed to open the database");
            }
            
        }];
    }
    
}

#pragma mark - bookmark database methods
- (void)bookmarkWithTrackInfo:(NSDictionary *)trackInfo
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[DataManager sharedManager].bookmarkDatabase.fileURL path]]) {
        // does not exist on disk, so create it
        [self.bookmarkDatabase saveToURL:[DataManager sharedManager].bookmarkDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            // creation successful, now let's populate the database
            if (success) {
                [self.bookmarkDatabase.managedObjectContext performBlock:^{
                    [Bookmarks bookmarkWithTrackInfo:trackInfo inManagedObjectContext:self.bookmarkDatabase.managedObjectContext];
                    [self.bookmarkDatabase saveToURL:self.bookmarkDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
                }];
            }
            else {
                NSLog(@"failed to create the database");
            }
            
            
        }];
    } else if (self.bookmarkDatabase.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        [self.bookmarkDatabase openWithCompletionHandler:^(BOOL success) {
            // open successful, lets populate the database
            if (success) {
                NSLog (@"successfully opened the database");
                [self.bookmarkDatabase.managedObjectContext performBlock:^{
                    [Bookmarks bookmarkWithTrackInfo:trackInfo inManagedObjectContext:self.bookmarkDatabase.managedObjectContext];
                    [self.bookmarkDatabase saveToURL:self.bookmarkDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
                }];
            }
            else {
                NSLog (@"failed to open the database");
            }
            
        }];
        
    } else if (self.bookmarkDatabase.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        NSLog (@"database was already opened");
        [self.bookmarkDatabase.managedObjectContext performBlock:^{
            [Bookmarks bookmarkWithTrackInfo:trackInfo inManagedObjectContext:self.bookmarkDatabase.managedObjectContext];
            [self.bookmarkDatabase saveToURL:self.bookmarkDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
            
        }];
    }
}

- (void)chapterWithTrackInfo:(NSDictionary *)trackInfo
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.bookmarkDatabase.fileURL path]]) {
        // does not exist on disk, so create it
        [self.bookmarkDatabase saveToURL:self.bookmarkDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            // creation successful, now let's populate the database
            if (success) {
                [self.bookmarkDatabase.managedObjectContext performBlock:^{
                    [Chapters chapterWithTrackInfo:trackInfo inManagedObjectContext:self.bookmarkDatabase.managedObjectContext];
                    [self.bookmarkDatabase saveToURL:self.bookmarkDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
                }];
            }
            else {
                NSLog(@"failed to create the database");
            }
            
            
        }];
    } else if (self.bookmarkDatabase.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        [self.bookmarkDatabase openWithCompletionHandler:^(BOOL success) {
            // open successful, lets populate the database
            if (success) {
                NSLog (@"successfully opened the database");
                [self.bookmarkDatabase.managedObjectContext performBlock:^{
                    [Chapters chapterWithTrackInfo:trackInfo inManagedObjectContext:self.bookmarkDatabase.managedObjectContext];
                    [self.bookmarkDatabase saveToURL:self.bookmarkDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
                }];
            }
            else {
                NSLog (@"failed to open the database");
            }
            
        }];
        
    } else if (self.bookmarkDatabase.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        NSLog (@"database was already opened");
        [self.bookmarkDatabase.managedObjectContext performBlock:^{
            [Chapters chapterWithTrackInfo:trackInfo inManagedObjectContext:self.bookmarkDatabase.managedObjectContext];
            [self.bookmarkDatabase saveToURL:self.bookmarkDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
            
        }];
    }
}

#pragma mark - get chapters from track item
//this method should be in datamanager class
- (Chapters *)getChapterWithTrack: (MPMediaItem *)track {
    Chapters *chapter = nil;
    
    NSString *trackTitle = [track valueForProperty:MPMediaItemPropertyTitle];
    NSString *albumTitle = [track valueForProperty:MPMediaItemPropertyAlbumTitle];
    NSNumber *playbackDuration = [track valueForProperty:MPMediaItemPropertyPlaybackDuration];
    NSNumber *trackNumber = [track valueForProperty:MPMediaItemPropertyAlbumTrackNumber];
    NSNumber *discNumber = [track valueForProperty:MPMediaItemPropertyDiscNumber];
    NSString *artist = [track valueForProperty:MPMediaItemPropertyArtist];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Chapters"];
    request.predicate = [NSPredicate predicateWithFormat:@"(trackTitle = %@) AND (fromBook.albumTitle = %@) AND (playbackDuration = %@) AND (trackNumber = %@) AND (discNumber = %@) AND (artist = %@)", trackTitle, albumTitle, playbackDuration, trackNumber, discNumber, artist];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"trackTitle" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    NSArray *matches = [self.bookmarkDatabase.managedObjectContext executeFetchRequest:request error:&error];
    if (!matches || ([matches count] > 1)) {
        NSLog(@"we have duplicate track last played info, error!");
        // handle error
        chapter = [matches lastObject];
        [self.bookmarkDatabase.managedObjectContext deleteObject:[matches objectAtIndex:0]];
    } else if ([matches count] == 0) {
        NSLog(@"no last played info found for this track");
        chapter = nil;
    } else {
        NSLog(@"found last played info");
        chapter = [matches lastObject];
    }
    
    return chapter;
}

- (Chapters *)lastPlayedChapterForAlbumTitle:(NSString *)albumTitle {
    Chapters *chapter = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Chapters"];
    request.predicate = [NSPredicate predicateWithFormat:@"(fromBook.albumTitle = %@)",albumTitle];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastPlayedTime" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    NSArray *matches = [self.bookmarkDatabase.managedObjectContext executeFetchRequest:request error:&error];
    chapter = [matches lastObject];
    return chapter;
}

#pragma mark - compare trackinfos to see if they are the same
- (BOOL) trackInfoForTrack:(MPMediaItem *)track matchesTrackInfo:(NSDictionary *)trackInfo {
    NSString *trackTitle = [track valueForProperty:MPMediaItemPropertyTitle];
    NSString *albumTitle = [track valueForProperty:MPMediaItemPropertyAlbumTitle];
    NSNumber *playbackDuration = [track valueForProperty:MPMediaItemPropertyPlaybackDuration];
    NSNumber *trackNumber = [track valueForProperty:MPMediaItemPropertyAlbumTrackNumber];
    NSNumber *discNumber = [track valueForProperty:MPMediaItemPropertyDiscNumber];
    NSString *artist = [track valueForProperty:MPMediaItemPropertyArtist];
    
    NSString *trackTitle2 = [trackInfo objectForKey:@"trackTitle"];
    NSString *albumTitle2 = [trackInfo objectForKey:@"albumTitle"];
    NSNumber *playbackDuration2 = [trackInfo objectForKey:@"playbackDuration"];
    NSNumber *trackNumber2 = [trackInfo objectForKey:@"trackNumber"];
    NSNumber *discNumber2 = [trackInfo objectForKey:@"discNumber"];
    NSString *artist2 = [trackInfo objectForKey:@"artist"];
    
    if ([trackTitle isEqualToString:trackTitle2] && [albumTitle isEqualToString:albumTitle2] && [playbackDuration integerValue] == [playbackDuration2 integerValue] && [trackNumber integerValue] == [trackNumber2 integerValue] && [discNumber integerValue] == [discNumber2 integerValue] && [artist isEqualToString:artist2]) {
        // the track is now being played
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL) trackInfoForTrack:(MPMediaItem *)track matchesChapterInfo:(Chapters *)chapter {
    NSString *trackTitle = [track valueForProperty:MPMediaItemPropertyTitle];
    NSString *albumTitle = [track valueForProperty:MPMediaItemPropertyAlbumTitle];
    NSNumber *playbackDuration = [track valueForProperty:MPMediaItemPropertyPlaybackDuration];
    NSNumber *trackNumber = [track valueForProperty:MPMediaItemPropertyAlbumTrackNumber];
    NSNumber *discNumber = [track valueForProperty:MPMediaItemPropertyDiscNumber];
    NSString *artist = [track valueForProperty:MPMediaItemPropertyArtist];
    
    NSString *trackTitle2 = chapter.trackTitle;
    NSString *albumTitle2 = chapter.fromBook.albumTitle;
    NSNumber *playbackDuration2 = chapter.playbackDuration;
    NSNumber *trackNumber2 = chapter.trackNumber;
    NSNumber *discNumber2 = chapter.discNumber;
    NSString *artist2 = chapter.artist;
    
    // we make sure chapter is not nil
    if (chapter && [trackTitle isEqualToString:trackTitle2] && [albumTitle isEqualToString:albumTitle2] && [playbackDuration integerValue] == [playbackDuration2 integerValue] && [trackNumber integerValue] == [trackNumber2 integerValue] && [discNumber integerValue] == [discNumber2 integerValue] && [artist isEqualToString:artist2]) {
        // the track is now being played
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL) isLastPlayedTrack:(MPMediaItem *)track forAlbum:(NSString *)albumTitle {
    return [self trackInfoForTrack:track matchesChapterInfo:[self lastPlayedChapterForAlbumTitle:albumTitle]];
}

- (NSIndexPath *)indexPathForLastPlayedTrackForTracks: (NSArray *)tracks inAlbum: (NSString *)albumTitle {
    NSInteger row = -1;
    NSInteger counter = 0;
    for (MPMediaItem *track in tracks) {
        if ([self isLastPlayedTrack:track forAlbum:albumTitle]) {
            row = counter;
            break;
        }
        counter ++;
    }
    if (row != -1) {
        return [NSIndexPath indexPathForRow:row inSection:0];
    }
    else {
        return nil;
    }
}

- (NSIndexPath *)indexPathForNowPlayingTrackForTracks: (NSArray *)tracks inAlbum: (NSString *)albumTitle {
    NSInteger row = -1;
    NSInteger counter = 0;
    ABAppDelegate *appDelegate = (ABAppDelegate *)[[UIApplication sharedApplication] delegate];
    for (MPMediaItem *track in tracks) {
        if ([self trackInfoForTrack:track matchesTrackInfo:[appDelegate.audioPlayer getTrackInfo]]) {
            row = counter;
            break;
        }
        counter ++;
    }
    if (row != -1) {
        return [NSIndexPath indexPathForRow:row inSection:0];
    }
    else {
        return nil;
    }
}


@end
