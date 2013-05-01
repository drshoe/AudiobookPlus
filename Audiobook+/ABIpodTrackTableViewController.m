//
//  ABIpodTrackTableViewController.m
//  Audiobook+
//
//  Created by Sheng Xu on 12-07-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ABIpodTrackTableViewController.h"
#import "ABAudioPlayerViewController.h"
#import "ABAppDelegate.h"
#import "ABAudioPlayer.h"
#import "AlbumTableCell.h"
#import "Chapters+Create.h"
@interface ABIpodTrackTableViewController ()
@end

@implementation ABIpodTrackTableViewController
@synthesize tracks = _tracks;
@synthesize appDelegate = _appDelegate;
@synthesize albumTitle = _albumTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (ABAppDelegate *) appDelegate {
    if (!_appDelegate) {
        _appDelegate = (ABAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return _appDelegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initDataBase];
    // reload the data every 10s to update the database
    [self.theTableView reloadData];
    [self startReloadTimer:kTimer10s];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopReloadTimer];
}

#pragma mark - init coredata database

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
                [self.theTableView reloadData];
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
                [self.theTableView reloadData];
            }
            else {
                NSLog (@"failed to open the database");
            }
            
        }];
    }
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - table reload timer
- (void) startReloadTimer:(NSTimeInterval) seconds{
    // the timer is started in audioplayer class
    NSLog(@"start timer is called");
    [self.reloadTimer invalidate];
    self.reloadTimer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(reloadTableView) userInfo:nil
                                                           repeats:YES];
}

- (void) stopReloadTimer {
    if (self.reloadTimer != nil){
        [self.reloadTimer invalidate];
    }
}

- (void) reloadTableView {
    [self.theTableView reloadData];
}
#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"there are %i number of tracks",[self.tracks count]);
    return self.tracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"IpodTrackCell";
    AlbumTableCell *cell;
    cell = (AlbumTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AlbumTableCell" owner:self options:nil];
        cell = (AlbumTableCell *)[nib objectAtIndex:0];
    }
    // Configure the cell...
    cell.indexPath = indexPath;
    
    // Configure the cell...
    // get the title of the track
    MPMediaItem *track = [self.tracks objectAtIndex:indexPath.row];
    NSString *trackTitle = [track valueForProperty:MPMediaItemPropertyTitle];
    NSString *trackNumber = [[track valueForProperty:MPMediaItemPropertyAlbumTrackNumber] stringValue];
    NSString *discNumber = [[track valueForProperty:MPMediaItemPropertyDiscNumber] stringValue];
    NSString *discCount = [[track valueForProperty:MPMediaItemPropertyDiscCount] stringValue];
    
    NSString *trackText = [[@"Track " stringByAppendingString:trackNumber] stringByAppendingString:@" of "];
    NSString *discText = [[[@"Disc " stringByAppendingString:discNumber] stringByAppendingString:@" of "] stringByAppendingString:discCount];
    MPMediaItemArtwork *artwork = [track valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *artworkImage = [artwork imageWithSize:cell.albumArt.bounds.size];
    // we must add 1 because indexpath.row starts with 0
    NSString *partText = [[[@"Part " stringByAppendingString:[[NSNumber numberWithInt:indexPath.row+1] stringValue]] stringByAppendingString:@" of "] stringByAppendingString:[[NSNumber numberWithInt:self.tracks.count] stringValue]];
    if (artworkImage) {
        // set the artwork image on the cell
        cell.albumArt.image = artworkImage;
    }
    else {
        // there is no artwork image
        cell.albumArt.image = nil;
    }
    cell.titleLabel.text = trackTitle;
    cell.detailedLabel.text = [[partText stringByAppendingString:trackText] stringByAppendingString:discText];
    
    Chapters *chapter = [self getChapterWithTrack:track inManagedObjectContext:self.bookmarkDatabase.managedObjectContext];
    // lastPlayedTrackTime is normalized time
    [cell.progressView setProgress:[chapter.lastPlayedTrackTime doubleValue]];
    
    // set the cell now playing indicator
    if (self.appDelegate.audioPlayer.playing) {
        cell.isNowPlaying = [self trackInfoForTrack:track matchesTrackInfo:[self.appDelegate.audioPlayer getTrackInfo]];
    }
    else {
        cell.isNowPlaying = NO;
    }
    return cell;
}

#pragma mark - getter method for chapter entity
- (Chapters *)getChapterWithTrack: (MPMediaItem *)track inManagedObjectContext: (NSManagedObjectContext*)context{
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
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || ([matches count] > 1)) {
        NSLog(@"we have duplicate track last played info, error!");
        // handle error
    } else if ([matches count] == 0) {
        NSLog(@"no last played info found for this track");
        chapter = nil;
    } else {
        NSLog(@"found last played info");
        chapter = [matches lastObject];
    }
    
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    NSNumber *currentTrackNumber = [NSNumber numberWithInteger:indexPath.row];
    // set the currentList of tracks
    // set the player to nil to release it so we do not have multiple instances of the same player
    if (!self.appDelegate.audioPlayer) {
        self.appDelegate.audioPlayer = [[ABAudioPlayer alloc] initWithItems:self.tracks withCurrentTrackNumber:currentTrackNumber];
    }
    else {
        if ([self.appDelegate.audioPlayer.allMPMediaPlayerItems isEqual:self.tracks]) {
            NSLog(@"album has not been changed, only change tracks");
            // do nothing if this is the same album and same track
            if ([self.appDelegate.audioPlayer.currentTrackNumber isEqualToNumber:currentTrackNumber]) {
                //do nothing
                NSLog(@"track is NOT changed");
            }
            // modify the queue with new track at the beginning of the queue
            else {
                NSLog(@"track IS changed");
                [self.appDelegate.audioPlayer newTrackNumber:currentTrackNumber];
            }
        }
        // if different album, we change the queue completely
        else {
            NSLog(@"the album has been changed");
            [self.appDelegate.audioPlayer playNewAlbum:self.tracks withCurrentTrackNumber:currentTrackNumber];
        }
    }
    
    ABAudioPlayerViewController *audioPlayerViewController = [ABAudioPlayerViewController sharedController];
    audioPlayerViewController.tracks = self.tracks; // set it so that audioplayer can also present a tracktableviewcontroller
    audioPlayerViewController.navigationItem.leftBarButtonItem = nil;
    audioPlayerViewController.navigationItem.hidesBackButton = NO;
    [self.navigationController pushViewController:audioPlayerViewController animated:YES];
}

@end
