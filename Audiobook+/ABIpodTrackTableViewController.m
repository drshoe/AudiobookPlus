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
#import "Appirater.h"
 
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
    self.screenName = @"TracksView";
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = self.albumTitle;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // find the last play indexPath if it exists
    [self updateLastPlayedAndNowPlayingStatus];
    [DataManager sharedManager].delegate = self;
    // reload the data every 10s to update the database
    [self reloadTableViewAndUpdateStatus];
    [self startReloadTimer:kTimer5s];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewAndUpdateStatus) name:kAudioBookDidChangeNotification object:nil];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // [self.theTableView scrollToRowAtIndexPath:self.lastPlayedIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [DataManager sharedManager].delegate = nil;
    [self stopReloadTimer];
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
#pragma mark - table reload timer
- (void) startReloadTimer:(NSTimeInterval) seconds{
    // the timer is started in audioplayer class
    NSLog(@"reload track table view timer is called");
    [self.reloadTimer invalidate];
    self.reloadTimer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(reloadTableView) userInfo:nil
                                                           repeats:YES];
}

- (void) stopReloadTimer {
    if (self.reloadTimer != nil){
        [self.reloadTimer invalidate];
    }
}

- (void) reloadTableViewAndUpdateStatus {
    [self updateLastPlayedAndNowPlayingStatus];
    [self.theTableView reloadData];
}

- (void) reloadTableView {
    if (self.appDelegate.audioPlayer.playing) {
        [self.theTableView reloadData];
    }
}
#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.nowPlayingIndexPath) {
            return @"Now Playing";
        }
        else if (self.lastPlayedIndexPath) {
            return @"Last Played";
        }
        else {
            return nil;
        }
    }
    else {
        return @"Parts";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.nowPlayingIndexPath || self.lastPlayedIndexPath) {
        return 2;
    }
    else {
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"there are %i number of tracks",[self.tracks count]);
    if (section == 0) {
        if (self.nowPlayingIndexPath || self.lastPlayedIndexPath) {
            return 1;
        }
        else {
            return self.tracks.count;
        }
    }
    else {
        return self.tracks.count;
    }
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
    MPMediaItem *track;
    if (indexPath.section == 0 && (self.nowPlayingIndexPath || self.lastPlayedIndexPath)) {
        if (self.nowPlayingIndexPath) {
            track = [self.tracks objectAtIndex:self.nowPlayingIndexPath.row];
        }
        else {
            track = [self.tracks objectAtIndex:self.lastPlayedIndexPath.row];
        }
    }
    else {
        track = [self.tracks objectAtIndex:indexPath.row];
    }
    
    NSString *trackTitle = [track valueForProperty:MPMediaItemPropertyTitle];
    NSString *trackNumber = [[track valueForProperty:MPMediaItemPropertyAlbumTrackNumber] stringValue];
    NSString *trackCount = [[track valueForProperty:MPMediaItemPropertyAlbumTrackCount] stringValue];
    NSString *discNumber = [[track valueForProperty:MPMediaItemPropertyDiscNumber] stringValue];
    NSString *discCount = [[track valueForProperty:MPMediaItemPropertyDiscCount] stringValue];
    NSString *trackText = [NSString string];
    NSString *discText = [NSString string];
    if (trackNumber) {
        trackText = [@"Track " stringByAppendingString:trackNumber];
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
    MPMediaItemArtwork *artwork = [track valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *artworkImage = [artwork imageWithSize:cell.albumArt.bounds.size];
    // we must add 1 because indexpath.row starts with 0
    
    int partTextIndexPath = indexPath.row+1;
    
    if (indexPath.section == 0 && (self.nowPlayingIndexPath || self.lastPlayedIndexPath)) {
        if (self.nowPlayingIndexPath) {
            track = [self.tracks objectAtIndex:self.nowPlayingIndexPath.row];
            partTextIndexPath = self.nowPlayingIndexPath.row +1;
            
        }
        else {
            track = [self.tracks objectAtIndex:self.lastPlayedIndexPath.row];
            partTextIndexPath = self.lastPlayedIndexPath.row +1;
        }
    }
    NSString *partText = [[[@"Part " stringByAppendingString:[[NSNumber numberWithInt:partTextIndexPath] stringValue]] stringByAppendingString:@" of "] stringByAppendingString:[[NSNumber numberWithInt:self.tracks.count] stringValue]];
    
    if (artworkImage) {
        // set the artwork image on the cell
        cell.albumArt.image = artworkImage;
    }
    else {
        // there is no artwork image
        cell.albumArt.image = nil;
    }
    cell.titleLabel.text = partText;
    //cell.detailedLabel.text = [[partText stringByAppendingString:trackText] stringByAppendingString:discText];
    cell.detailedLabel.text = trackTitle;
    
    // chapter could be nil if it was never initialized
    Chapters *chapter = [[DataManager sharedManager] getChapterWithTrack:track];
    // lastPlayedTrackTime is normalized time
    
    double progress = 0.0;
    if (chapter) {
        if (![chapter.completed boolValue]) {
            progress = [chapter.lastPlayedTrackTime doubleValue];
        }
        else {
            progress = 1.0;
        }
    }
    
    [cell.progressView setProgress:[chapter.lastPlayedTrackTime doubleValue]];
    
    // set the cell now playing indicator
    //if (self.appDelegate.audioPlayer.playing) {
        BOOL isNowPlaying = [[DataManager sharedManager] trackInfoForTrack:track matchesTrackInfo:[self.appDelegate.audioPlayer getTrackInfo]];
        cell.isNowPlaying = isNowPlaying;
    /*if (isNowPlaying) {
        [self.theTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }*/
    //}
    //else {
    //    cell.isNowPlaying = NO;
    //}
    
    // set time played and time remain
    if (chapter) {
        NSTimeInterval timeRemain = [chapter.playbackDuration doubleValue]* (1.0-progress);
        if ([chapter.completed boolValue]) {
            cell.timeLeftLabel.text = @"Completed";
        }
        else {
            cell.timeLeftLabel.text = [[self stringFromTimeInterval:timeRemain] stringByAppendingString:@" left"];
        }
    }
    else {
        // for the case if chapter is not initialized in the database yet. therefore the time remain is equal to the playbackduration of that track
        NSTimeInterval timeRemain = [[track valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
        cell.timeLeftLabel.text = [self stringFromTimeInterval:timeRemain];
    }
    
    // set last played indicator
    /*
    if (![self.appDelegate.audioPlayer.albumTitle isEqualToString: self.albumTitle]) {
        if (self.lastPlayedIndexPath && indexPath.row == self.lastPlayedIndexPath.row) {
            cell.isLastPlayed = YES;
        }
    }*/
    return cell;
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
    if (indexPath.section == 0 && (self.lastPlayedIndexPath || self.nowPlayingIndexPath)) {
        if (self.nowPlayingIndexPath) {
            currentTrackNumber = [NSNumber numberWithInteger:self.nowPlayingIndexPath.row];
        }
        else if (self.lastPlayedIndexPath) {
            currentTrackNumber = [NSNumber numberWithInteger:self.lastPlayedIndexPath.row];
        }
    }
    Chapters *chapter = [[DataManager sharedManager] getChapterWithTrack:[self.tracks objectAtIndex:[currentTrackNumber integerValue]]];
    
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
                chapter = nil;
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
            // seek to last played position
        }
    }
    
    ABAudioPlayerViewController *audioPlayerViewController = [ABAudioPlayerViewController sharedController];
    audioPlayerViewController.tracks = self.tracks; // set it so that audioplayer can also present a tracktableviewcontroller
    //audioPlayerViewController.navigationItem.leftBarButtonItem = nil;
    //audioPlayerViewController.navigationItem.hidesBackButton = NO;
    //[self.navigationController pushViewController:audioPlayerViewController animated:YES];
    
    // resume from last played time
    if (chapter && ![chapter.completed boolValue]) {
        // tell appirator that the user just resumed playing a track, which is a significant event
        [Appirater userDidSignificantEvent:YES];

        double newTime = [chapter.lastPlayedTrackTime doubleValue] * [self.appDelegate.audioPlayer.playbackDuration doubleValue];
        CMTime newCMTime = CMTimeMake(newTime*self.appDelegate.audioPlayer.currentTime.timescale, self.appDelegate.audioPlayer.currentTime.timescale);
        [self.appDelegate.audioPlayer seekToTime:newCMTime];
        
    }
    // playtrack immediately
    [self.appDelegate.audioPlayer playTrack];
    // for the case using uitabbarviewcontroller
    UIViewController *presentingController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    //audioPlayerViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [presentingController presentViewController:audioPlayerViewController animated:YES completion:nil];
}

#pragma mark - datamanager delegate
- (void)didFinishedCreatingOrOpeningDatabase {
    [self.theTableView reloadData];
}

#pragma mark - update last played or now playing status
- (void) updateLastPlayedAndNowPlayingStatus {
    self.lastPlayedIndexPath = [[DataManager sharedManager] indexPathForLastPlayedTrackForTracks:self.tracks inAlbum:self.albumTitle];
    self.nowPlayingIndexPath = [[DataManager sharedManager] indexPathForNowPlayingTrackForTracks:self.tracks inAlbum:self.albumTitle];
    if (self.nowPlayingIndexPath) {
        self.lastPlayedIndexPath = nil;
    }
}

@end
