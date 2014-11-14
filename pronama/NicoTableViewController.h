//
//  NicoTableViewController.h
//  pronama
//
//  Created by 大翼 野村 on 12/01/22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NicoVideoItem.h"
#import "GDataXMLNode.h"
#import "DetailVideoViewController.h"
#import "VideoPlayerViewController.h"
#import "Setting.h"
#import "NicoVideo.h"

#define NICO_VIDEO_ITEM_COUNT_FORMAT @"再生：%@　コメント：%@　マイリスト：%@"

@interface NicoTableViewController : UITableViewController <UITableViewDelegate> {
    NSMutableArray *videoArray;
    int selectedIndex;
    NSString *link;
}
@property (weak, nonatomic) IBOutlet UITableView *nicoTableView;
@property NSString *link;
@property (weak, nonatomic) IBOutlet UINavigationItem *nicoNavItem;
@property (weak, nonatomic) IBOutlet UIView *IndicatorView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;

+ (NSMutableArray *)readData;

@end
