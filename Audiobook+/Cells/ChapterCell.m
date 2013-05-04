//
//  ChapterCell.m
//  Audiobook+
//
//  Created by Sheng Xu on 2013-05-03.
//
//

#import "ChapterCell.h"

@implementation ChapterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setIsNowPlaying:(BOOL)isNowPlaying {
    _isNowPlaying = isNowPlaying;
    [self.nowPlayingIcon setHidden:!_isNowPlaying];
}

@end
