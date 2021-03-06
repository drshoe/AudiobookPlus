//
//  AlbumTableCell.h
//  Audiobook+
//
//  Created by Sheng Xu on 2013-04-22.
//
//

#import <UIKit/UIKit.h>

@interface AlbumTableCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *albumArt;
@property (nonatomic, strong) IBOutlet UIImageView *nowPlayingIcon;
@property (nonatomic, strong) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *detailedLabel;
@property (nonatomic, assign) BOOL isNowPlaying;
@property (nonatomic, assign) BOOL isLastPlayed;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) IBOutlet UILabel *timeLeftLabel;
@property (nonatomic, strong) IBOutlet UILabel *lastPlayedLabel;
@end
