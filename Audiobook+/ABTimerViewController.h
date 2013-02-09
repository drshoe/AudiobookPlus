//
//  ABTimerViewController.h
//  Audiobook+
//
//  Created by Sheng Xu on 2012-07-31.
//
//

#import <UIKit/UIKit.h>
#import "ABAppDelegate.h"

@interface ABTimerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;
@property (strong, nonatomic) NSArray *pickerViewText;
@property (assign, nonatomic) NSTimeInterval seconds;
- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)done:(UIBarButtonItem *)sender;


@end
