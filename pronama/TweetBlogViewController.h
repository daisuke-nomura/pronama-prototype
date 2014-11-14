//
//  TweetBlogViewController.h
//  pronama
//
//  Created by 大翼 野村 on 12/01/22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"
#import "WebViewController.h"
#import "WallpaperViewController.h"

#define TWITTER_URL @"https://mobile.twitter.com/pronama"
#define SECTION_COUNT 2
#define PRONAMA_NAME @"プロ生ちゃん"
#define PRONAMA_NAME2 @"ブログ"
#define TWEET_MENU_NAME @"@pronama"
#define WALLPAPER_MENU_NAME @"壁紙"

@interface TweetBlogViewController : UITableViewController <UITableViewDelegate> {
    NSMutableArray *feedArray;
    NSArray *sectionName;
    int selectedIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;

@end
