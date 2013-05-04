//
//  ChapterCell.h
//  Audiobook+
//
//  Created by Sheng Xu on 2013-05-03.
//
//

#import <UIKit/UIKit.h>

@interface ChapterCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *nowPlayingIcon;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) BOOL isNowPlaying;

@end
