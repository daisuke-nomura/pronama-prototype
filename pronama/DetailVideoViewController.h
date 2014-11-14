//
//  DetailVideoViewController.h
//  pronama
//
//  Created by 大翼 野村 on 12/01/30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedDescCell.h"
#import "FeedDetailCell.h"
#import "VideoPlayerViewController.h"
#import "NicoTableViewController.h"
#import <Twitter/Twitter.h>

@interface DetailVideoViewController : UITableViewController <UIActionSheetDelegate> {
    int descHeight;
    int selectedIndex;
}

@property (strong, nonatomic) NSDictionary *videoDetail;
- (IBAction)actionDetailVideo:(id)sender;

@end
