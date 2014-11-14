//
//  TimerViewController.m
//  pronama
//
//  Created by 野村 大翼 on 12/07/07.
//
//

#import "TimerViewController.h"

@implementation TimerViewController
@synthesize ltPicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [ltPicker setCountDownDuration:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLtPicker:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)hoge:(id)sender {
    [self performSegueWithIdentifier:@"LTSegue" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LTViewController *controller = (LTViewController *)[segue destinationViewController];
    controller.time = ltPicker.countDownDuration;
    [super prepareForSegue:segue sender:sender];
}

@end
