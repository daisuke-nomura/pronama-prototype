//
//  FeedDetailCell.m
//  pronama
//
//  Created by 大翼 野村 on 12/02/05.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FeedDetailCell.h"

@implementation FeedDetailCell
@synthesize feedDetailTitle;
@synthesize videoImage;
@synthesize titleLabel;
@synthesize postLabel;
@synthesize countLabel;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

- (void)dealloc {
}


@end

@implementation FeedDetailCellController
@synthesize cell;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
