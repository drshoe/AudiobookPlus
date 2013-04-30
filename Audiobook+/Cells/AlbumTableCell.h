//
//  AlbumTableCell.h
//  Audiobook+
//
//  Created by Sheng Xu on 2013-04-22.
//
//

#import <UIKit/UIKit.h>
@protocol AlbumTableCellDelegate
- (void) accessoryButtonPressedAtIndexPath:(NSIndexPath *) indexPath;
@end
@interface AlbumTableCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *albumArt;
@property (nonatomic, strong) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *detailedLabel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) id <AlbumTableCellDelegate> delegate;
@end
