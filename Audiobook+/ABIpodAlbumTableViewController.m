//
//  ABIpodAlbumTableViewController.m
//  Audiobook+
//
//  Created by Sheng Xu on 12-07-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ABIpodAlbumTableViewController.h"
#import "ABIpodTrackTableViewController.h"

@interface ABIpodAlbumTableViewController ()

@end

@implementation ABIpodAlbumTableViewController
@synthesize albums = _albums;

- (NSArray *) albums {
    if (_albums==nil) {
        // we query the albums from music library
        MPMediaQuery *query = [MPMediaQuery audiobooksQuery];
        [query setGroupingType:MPMediaGroupingAlbum];
        _albums = [query collections];
    }
    return _albums;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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

#pragma mark - Class methods


#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *info = [NSString string];
    if (section == 0) {
        info = @"Now Playing";
    }
    else if (section == 1) {
        info = @"Books";
    }
    return info;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if (section == 1) {
        NSLog(@"there are %i albums",[self.albums count]);
        return [self.albums count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    if (indexPath.section != 0) {
        static NSString *CellIdentifier = @"IpodAlbumCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        // get the information about this particular album
        MPMediaItemCollection *album = [self.albums objectAtIndex:indexPath.row];
        // get the representative item for this album
        MPMediaItem *representativeItem = [album representativeItem];
        // get the name of the album
        NSString *albumName = [representativeItem valueForProperty: MPMediaItemPropertyAlbumTitle];
        // get the album artwork
        MPMediaItemArtwork *artwork = [representativeItem valueForProperty:MPMediaItemPropertyArtwork];
        UIImage *artworkImage = [artwork imageWithSize:cell.imageView.bounds.size];
        if (artworkImage) {
            // set the artwork image on the cell
            cell.imageView.image = artworkImage;
        }
        else {
            // there is no artwork image
        }
        // set the cell attributes
        cell.textLabel.text = albumName;
        NSLog(@"the name of the album is %@",albumName);
        // set the cell's accessory type
    }
    else {
        static NSString *CellIdentifier = @"IpodLastPlayedCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text = @"Now playing";
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowTracks"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        MPMediaItemCollection *album = [self.albums objectAtIndex:indexPath.row];
        // set the tracks, we need to import the destinationviewcontroller's h file to make this happen
        // it only works with message, not dot notation
        // get the representative item for this album
        MPMediaItem *representativeItem = [album representativeItem];
        // get the name of the album
        NSString *albumName = [representativeItem valueForProperty: MPMediaItemPropertyAlbumTitle];
        [segue.destinationViewController setTracks:[album items]];
        [segue.destinationViewController setAlbumTitle:albumName];
        NSLog(@"the album title is %@",albumName);
        NSLog(@"tracks have been set");
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


