//
//  SecondViewController.h
//  pronama
//
//  Created by 大翼 野村 on 12/01/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>

#define ACTION_SHEET_BUTTON_NAME1 @"ツイート"
#define ACTION_SHEET_BUTTON_NAME2 @"Safariで開く"
#define ACTION_SHEET_BUTTON_NAME3 @"キャンセル"

@interface WebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {
}

@property (weak, nonatomic) IBOutlet UIWebView *blogWebView;
@property (weak, nonatomic) IBOutlet UINavigationItem *blogNavItem;
- (void)blogActionBtn:(id)sender;
@property NSURL *link;

@end
