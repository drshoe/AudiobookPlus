//
//  AlbumTableCell.m
//  Audiobook+
//
//  Created by Sheng Xu on 2013-04-22.
//
//

#import "AlbumTableCell.h"

@implementation AlbumTableCell

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

- (IBAction)accessoryButtonPressed:(id)sender {
    [self.delegate accessoryButtonPressedAtIndexPath:self.indexPath];
}

@end
