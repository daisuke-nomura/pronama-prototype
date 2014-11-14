//
//  pronamaViewController.h
//  pronama
//
//  Created by 大翼 野村 on 12/01/22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"
#import "NicoTableViewController.h"
#import "WebViewController.h"
#import "NicoLive.h"

#define NICO_MYLIST_URL @"http://www.nicovideo.jp/mylist/%@?rss=2.0"
#define NICO_LIVE_APP_URL @"nicolive://%@"
#define LIVE_CANCELED @"放送はキャンセルされました"
#define APP_NAME @"プロ生"
#define LOGIN_MESSAGE @"ニコニコ動画にログインしていません。アカウント設定を開きますか?"
#define CANCEL @"キャンセル"
#define OK @"OK"
#define NICO_VIDEO @"ニコニコ動画"
#define NICO_LIVE @"ニコニコ生放送"

@interface pronamaViewController : UITableViewController <UITableViewDelegate, UIAlertViewDelegate> {
    NSMutableArray *mylistArray;
    NSArray *liveArray;
    int selectedIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *feedNavItem;

//プロ生マイリスト解析
+ (NSMutableArray *)readData;

@end
