//
//  ChapterAndBookmarkViewController.m
//  Audiobook+
//
//  Created by Sheng Xu on 2013-04-23.
//
//

#import "ChapterAndBookmarkViewController.h"
#import "Bookmarks.h"
#import "ABAudioPlayerViewController.h"
#import "ChapterCell.h"
#import "BookmarkCell.h"
@interface ChapterAndBookmarkViewController ()

@end
static ChapterAndBookmarkViewController *sharedController;
@implementation ChapterAndBookmarkViewController
//@synthesize book = _book;
@synthesize albumTitle = _albumTitle;
@synthesize appDelegate = _appDelegate;

@synthesize tracks = _tracks;
@synthesize theTableView = _theTableView;

+(ChapterAndBookmarkViewController *)sharedController {
    if (!sharedController) {
        sharedController = [[ChapterAndBookmarkViewController alloc] init];
    }
    return sharedController;
}

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
    self.screenName = @"ChapterAndBookmarkView";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.sampleBookmarkCell = [[BookmarkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [DataManager sharedManager].delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:kAudioBookDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [DataManager sharedManager].delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAudioBookDidChangeNotification object:nil];
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

#pragma mark - Table view data source
- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bookmarks"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"bookmarkTime"
                                                                                     ascending:NO
                                                                                      selector:@selector(compare:)]];
    // we fetch with complete trackInfo
    
    NSString *trackTitle = [self.trackInfo objectForKey:@"trackTitle"];
    NSString *albumTitle = [self.trackInfo objectForKey:@"albumTitle"];
    NSNumber *playbackDuration = [self.trackInfo objectForKey:@"playbackDuration"];
    NSNumber *trackNumber = [self.trackInfo objectForKey:@"trackNumber"];
    NSNumber *discNumber = [self.trackInfo objectForKey:@"discNumber"];
    NSString *artist = [self.trackInfo objectForKey:@"artist"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"(trackTitle = %@) AND (fromBook.albumTitle = %@) AND (playbackDuration = %@) AND (trackNumber = %@) AND (discNumber = %@) AND (artist = %@)", trackTitle, albumTitle, playbackDuration, trackNumber, discNumber, artist];
    // if we have not initialized the managedObjectContext
    NSLog (@"initiating fetchresultcontroller");
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[DataManager sharedManager].bookmarkDatabase.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.selectedIndex == ChapterAndBookmarkTableBookmarkSelected) {
        return [[self.fetchedResultsController sections] count];
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectedIndex == ChapterAndBookmarkTableBookmarkSelected) {
        NSInteger rows = [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
        // make sure we dont show editing button when there is no bookmarks
        if (rows == 0) {
            [self.editButton setHidden:YES];
            [self.theTableView setEditing:NO animated:YES];
        }
        else {
            [self.editButton setHidden:NO];
        }
        return rows;
        NSLog(@"%i",[[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects]);
    }
    else {
        NSLog(@"-------there are %i tracks",self.tracks.count);
        return [self.tracks count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex == ChapterAndBookmarkTableBookmarkSelected) {
        //Bookmarks *bookmark = [self.fetchedResultsController objectAtIndexPath:indexPath];
        //return [BookmarkCell cellHeightForNote:bookmark.note andButton:self.sampleBookmarkCell.noteButton];
        return 44;
    }
    else {
        return 44;
    }

}
/*
 - (void)setAlbumTitle:(NSString *)albumTitle
 {
 _albumTitle = albumTitle;
 self.title = albumTitle;
 [self setupFetchedResultsController];
 }*/

- (void)setTrackInfo:(NSDictionary *)trackInfo
{
    _trackInfo = trackInfo;
    //self.title = [self.trackInfo objectForKey:@"albumTitle"];
    [self setupFetchedResultsController];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex == ChapterAndBookmarkTableBookmarkSelected) {
        static NSString *CellIdentifier = @"Bookmarks Cell";
        
        BookmarkCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BookmarkCell" owner:self options:nil];
            cell = (BookmarkCell *)[nib objectAtIndex:0];
        }
        // Configure the cell...
        // Configure the cell...
        NSLog(@"show bookmarks");
        Bookmarks *bookmark = [self.fetchedResultsController objectAtIndexPath:indexPath]; // ask NSFRC for the NSMO at the row in question
        
        // set chapter title
        cell.chapterLabel.text = bookmark.trackTitle;
        
        // set bookmark date and time
        [cell initDateLabel:bookmark.bookmarkTime];
    
        // set the time played
        NSTimeInterval timeRemain = [bookmark.bookmarkTrackTime doubleValue] * [bookmark.playbackDuration doubleValue];
        cell.progressLabel.text = [self stringFromTimeInterval:timeRemain];
        
        // set the note
        cell.note = bookmark.note;
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"IpodChapterCell";
        ChapterCell *cell;
        cell = (ChapterCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChapterCell" owner:self options:nil];
            cell = (ChapterCell *)[nib objectAtIndex:0];
        }
        
        // Configure the cell...
        // get the title of the track
        MPMediaItem *track = [self.tracks objectAtIndex:indexPath.row];
        NSString *trackTitle = [track valueForProperty:MPMediaItemPropertyTitle];
        NSString *trackNumber = [[track valueForProperty:MPMediaItemPropertyAlbumTrackNumber] stringValue];
        NSString *trackCount = [[track valueForProperty:MPMediaItemPropertyAlbumTrackCount] stringValue];
        NSString *discNumber = [[track valueForProperty:MPMediaItemPropertyDiscNumber] stringValue];
        NSString *discCount = [[track valueForProperty:MPMediaItemPropertyDiscCount] stringValue];
        cell.titleLabel.text = trackTitle;
        NSString *discText = @"";
        NSString *trackText = @"";
        if (trackNumber) {
            trackText = [[@"Track " stringByAppendingString:trackNumber] stringByAppendingString:@" of "];
        }
        if (trackNumber && trackCount) {
            trackText = [[trackText stringByAppendingString:@" of "] stringByAppendingString:trackCount];
        }
        if (discNumber) {
            discText = [@"Disc " stringByAppendingString:discNumber];
        }
        if (discNumber && discCount) {
            discText = [[discText stringByAppendingString:@" of "] stringByAppendingString:discCount];
        }
        // we must add 1 because indexpath.row starts with 0
        NSString *partText = [[[@"Part " stringByAppendingString:[[NSNumber numberWithInt:indexPath.row+1] stringValue]] stringByAppendingString:@" of "] stringByAppendingString:[[NSNumber numberWithInt:self.tracks.count] stringValue]];
        cell.detailTextLabel.text = [[partText stringByAppendingString:trackText] stringByAppendingString:discText];
        
        // set the cell now playing indicator
        if (self.appDelegate.audioPlayer.playing) {
            cell.isNowPlaying = [self trackInfoForTrack:track matchesTrackInfo:[self.appDelegate.audioPlayer getTrackInfo]];
        }
        else {
            cell.isNowPlaying = NO;
        }
        return cell;

    }
}

#pragma mark - helper method to convert time interval to string
- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    if (hours < 1) {
        return [NSString stringWithFormat:@"%02i:%02i", minutes, seconds];
    }
    else {
        return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
    }
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

#pragma mark - tableview editing delegate and method
- (IBAction)enableAndDisableEditing:(id)sender {
    if (self.theTableView.isEditing) {
        [self.theTableView setEditing:NO animated:YES];
        [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    }
    else {
        [self.theTableView setEditing:YES animated:YES];
        [self.editButton setTitle:@"Done" forState:UIControlStateNormal];
    }
}
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
     if (self.selectedIndex == ChapterAndBookmarkTableBookmarkSelected) {
         return YES;
     }
     else {
         return NO;
     }
 }
 


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         // Delete the row from the data source
         [[DataManager sharedManager].bookmarkDatabase.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
         //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
     }
     //else if (editingStyle == UITableViewCellEditingStyleInsert) {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     //}
 }
 

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
    
    if (self.selectedIndex == ChapterAndBookmarkTableBookmarkSelected) {
        // we seek to the bookmarked time using our audioplayer class
        Bookmarks *bookmark = [self.fetchedResultsController objectAtIndexPath:indexPath];
        double bookmarkTrackTime = [bookmark.bookmarkTrackTime doubleValue];
        double newTime = bookmarkTrackTime * [self.appDelegate.audioPlayer.playbackDuration doubleValue];
        CMTime newCMTime = CMTimeMake(newTime*self.appDelegate.audioPlayer.currentTime.timescale, self.appDelegate.audioPlayer.currentTime.timescale);
        [self.appDelegate.audioPlayer seekToTime:newCMTime];
        [self.appDelegate.audioPlayer playTrack];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
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
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)segmentedControlPressed:(UISegmentedControl *)sender {
    self.selectedIndex = sender.selectedSegmentIndex;
    if (self.selectedIndex == ChapterAndBookmarkTableBookmarkSelected) {
        [self.editButton setHidden:NO];
        [self.theTableView setEditing:NO animated:YES];
        [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    }
    else {
        [self.editButton setHidden:YES];
    }
    [self.theTableView reloadData];
}

#pragma mark - datamanager delegate
- (void)didFinishedCreatingOrOpeningDatabase {
    [self.theTableView reloadData];
}

#pragma mark - nsnotification
- (void)reloadTableView {
    [self.theTableView reloadData];
}

@end

