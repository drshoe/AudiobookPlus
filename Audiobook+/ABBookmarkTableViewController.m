//
//  ABBookmarkTableViewController.m
//  Audiobook+
//
//  Created by Sheng Xu on 2012-07-27.
//
//

#import "ABBookmarkTableViewController.h"
#import "Bookmarks.h"
@interface ABBookmarkTableViewController ()

@end

static ABBookmarkTableViewController *sharedController;
@implementation ABBookmarkTableViewController
//@synthesize book = _book;
@synthesize albumTitle = _albumTitle;
@synthesize appDelegate = _appDelegate;

+(ABBookmarkTableViewController *)sharedController {
    if (!sharedController) {
        sharedController = [[ABBookmarkTableViewController alloc] init];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [DataManager sharedManager].delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [DataManager sharedManager].delegate = nil;
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
    self.title = [self.trackInfo objectForKey:@"albumTitle"];
    [self setupFetchedResultsController];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Bookmarks Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    // Configure the cell...
    NSLog(@"show bookmarks");
    Bookmarks *bookmark = [self.fetchedResultsController objectAtIndexPath:indexPath]; // ask NSFRC for the NSMO at the row in question
    cell.textLabel.text = bookmark.bookmarkTitle;
    cell.detailTextLabel.text = [bookmark.bookmarkTime description];
    return cell;
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    
    // we seek to the bookmarked time using our audioplayer class
    Bookmarks *bookmark = [self.fetchedResultsController objectAtIndexPath:indexPath];
    double bookmarkTrackTime = [bookmark.bookmarkTrackTime doubleValue];
    double newTime = bookmarkTrackTime * [self.appDelegate.audioPlayer.playbackDuration doubleValue];
    CMTime newCMTime = CMTimeMake(newTime*self.appDelegate.audioPlayer.currentTime.timescale, self.appDelegate.audioPlayer.currentTime.timescale);
    [self.appDelegate.audioPlayer seekToTime:newCMTime];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - datamanager delegate
- (void)didFinishedCreatingOrOpeningDatabase {
    [self.theTableView reloadData];
}

@end
