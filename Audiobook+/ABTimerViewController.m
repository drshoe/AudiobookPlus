//
//  ABTimerViewController.m
//  Audiobook+
//
//  Created by Sheng Xu on 2012-07-31.
//
//

#import "ABTimerViewController.h"

@interface ABTimerViewController ()

@end

@implementation ABTimerViewController
@synthesize timePicker=_timePicker;
@synthesize pickerViewText = _pickerViewText;
@synthesize seconds = _seconds;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSArray *)pickerViewText {
    if (!_pickerViewText) {
        NSMutableArray *pickerViewText = [NSMutableArray array];
        [pickerViewText addObject:@"Sleep mode off"];
        [pickerViewText addObject:@"15 minutes"];
        [pickerViewText addObject:@"30 minutes"];
        [pickerViewText addObject:@"45 minutes"];
        [pickerViewText addObject:@"60 minutes"];
        [pickerViewText addObject:@"End of this track"];
        _pickerViewText = pickerViewText;
    }
    return _pickerViewText;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)viewDidUnload
{
    [self setTimePicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSInteger result = 0;
    if ([pickerView isEqual:self.timePicker]){
        result = 1;
    }
    return result;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger result = 0;
    if ([pickerView isEqual:self.timePicker]) {
        result = self.pickerViewText.count;
        NSLog (@"there are %i rows",result);
    }
    return result;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *result = nil;
    if ([pickerView isEqual:self.timePicker]){
 
        /* Row is zero-based and we want the first row (with index 0) to be rendered as Row 1 so we have to +1 every row index */
        result = [self.pickerViewText objectAtIndex:row];
        //result = [NSString stringWithFormat:@"Row %ld", (long)row + 1];
    }
    return result;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (row) {
        // sleep Mode Off
        case 0: {
            self.seconds = 0;
            break;
        }
        // 15 min
        case 1: {
            self.seconds = 15*60;
            NSLog(@"Timer is set to 10 seconds");
            break;
        }
        // 30 min
        case 2: {
            self.seconds = 30*60;
            break;
        }
        // 45 min
        case 3: {
            self.seconds = 45*60;
            break;
        }
        // 60 min
        case 4: {
            self.seconds = 60*60;
            break;
        }
        // stop at the end of the part
        case 5: {
            self.seconds = 100;
            break;
        }
    }
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)done:(UIBarButtonItem *)sender {
    ABAppDelegate *appDelegate = (ABAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.seconds == 0) {
        [appDelegate.audioPlayer stopTimer];
        NSLog(@"timer is invalidated");
    }
    else {
        [appDelegate.audioPlayer startTimer:self.seconds];
        NSLog(@"timer is set");
    }
    [self dismissModalViewControllerAnimated:YES];
}
@end
