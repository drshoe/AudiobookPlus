//
//  BookmarkCell.m
//  Audiobook+
//
//  Created by Sheng Xu on 2013-05-07.
//
//

#import "BookmarkCell.h"
#define MAX_BUTTON_HEIGHT 60
#define CELL_BUTTON_PADDING 10
#define CELL_DEFAULT_HEIGHT 44
@implementation BookmarkCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.noteButton.titleLabel.numberOfLines = 0;
        self.noteButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        self.noteButton.titleLabel.textAlignment = UITextAlignmentLeft;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initDateLabel:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm a"];
    NSString *dateText = [formatter stringFromDate:date];
    self.dateLabel.text = dateText;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.noteButton setTitle:self.note forState:UIControlStateNormal];
    CGSize constraintSize = CGSizeMake(self.noteButton.frame.size.width, MAX_BUTTON_HEIGHT);
    CGSize size = [self.note sizeWithFont:self.noteButton.titleLabel.font constrainedToSize:constraintSize lineBreakMode:self.noteButton.titleLabel.lineBreakMode];
    CGRect frame = self.noteButton.frame;
    frame.size.height = size.height;
    self.noteButton.frame = frame;
}

+ (CGFloat) cellHeightForNote:(NSString *)note andButton:(UIButton *)button{
    CGSize constraintSize = CGSizeMake(button.frame.size.width, MAX_BUTTON_HEIGHT);
    CGSize size = [note sizeWithFont:button.titleLabel.font constrainedToSize:constraintSize lineBreakMode:button.titleLabel.lineBreakMode];
    return CELL_DEFAULT_HEIGHT + CELL_BUTTON_PADDING + size.height;
}

- (IBAction)editNote:(id)sender {
    
}
@end
