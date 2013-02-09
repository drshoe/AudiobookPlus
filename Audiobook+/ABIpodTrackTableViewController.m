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
@interface ABIpodTrackTableViewController ()
@end

@implementation ABIpodTrackTableViewController
@synthesize tracks = _tracks;
@synthesize appDelegate = _appDelegate;
@synthesize albumTitle = _albumTitle;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    // get the title of the track
    MPMediaItem *track = [self.tracks objectAtIndex:indexPath.row];
    NSString *trackTitle = [track valueForProperty:MPMediaItemPropertyTitle];
    NSString *trackNumber = [[track valueForProperty:MPMediaItemPropertyAlbumTrackNumber] stringValue];
    NSString *discNumber = [[track valueForProperty:MPMediaItemPropertyDiscNumber] stringValue];
    NSString *discCount = [[track valueForProperty:MPMediaItemPropertyDiscCount] stringValue];
    cell.textLabel.text = trackTitle;
    NSString *trackText = [[@"Track " stringByAppendingString:trackNumber] stringByAppendingString:@" of "];
    NSString *discText = [[[@"Disc " stringByAppendingString:discNumber] stringByAppendingString:@" of "] stringByAppendingString:discCount];
    // we must add 1 because indexpath.row starts with 0
    NSString *partText = [[[@"Part " stringByAppendingString:[[NSNumber numberWithInt:indexPath.row+1] stringValue]] stringByAppendingString:@" of "] stringByAppendingString:[[NSNumber numberWithInt:self.tracks.count] stringValue]];
    cell.detailTextLabel.text = [[partText stringByAppendingString:trackText] stringByAppendingString:discText];
    return cell;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowPlayer"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
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
        /*
        // we need to extract the subarray from the total tracks
        NSArray *subTracks = [self.tracks subarrayWithRange:NSMakeRange(indexPath.row, self.tracks.count-indexPath.row)];
        // put our new subarray into a collection
        NSLog(@"the number of tracks in the queue will be %i", subTracks.count);
        MPMediaItemCollection *trackCollection = [MPMediaItemCollection collectionWithItems:subTracks];
        [segue.destinationViewController setTrackCollection:trackCollection];
        NSLog(@"tracks have been set");
        */
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
}

@end
