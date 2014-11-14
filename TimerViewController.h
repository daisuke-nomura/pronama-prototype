//
//  TimerViewController.h
//  pronama
//
//  Created by 野村 大翼 on 12/07/07.
//
//

#import <UIKit/UIKit.h>
#import "LTViewController.h"

@interface TimerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *ltPicker;
- (IBAction)hoge:(id)sender;
@end
