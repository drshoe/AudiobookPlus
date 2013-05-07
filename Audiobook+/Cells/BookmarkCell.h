//
//  BookmarkCell.h
//  Audiobook+
//
//  Created by Sheng Xu on 2013-05-07.
//
//

#import <UIKit/UIKit.h>

@interface BookmarkCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *chapterLabel;
@property (nonatomic, strong) IBOutlet UILabel *progressLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UIButton *noteButton;
@property (nonatomic, strong) NSString *note;
- (void)initDateLabel:(NSDate *)date;
+ (CGFloat) cellHeightForNote:(NSString *)note andButton:(UIButton *)button;
@end
