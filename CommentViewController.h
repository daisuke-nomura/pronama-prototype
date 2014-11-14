//
//  CommentViewController.h
//  pronama
//
//  Created by 野村 大翼 on 12/07/14.
//
//

#import <UIKit/UIKit.h>
#import "LTViewController.h"

#define NICO_LIVE_COMMENT @"ニコ生コメント"
#define SECTION_COUNT 1

@interface CommentViewController : UITableViewController {
    NSEnumerator *comment;
    int count;
}
- (IBAction)refreshComment:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *commentTableView;

@end
