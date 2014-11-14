//
//  WallpaperViewController.h
//  pronama
//
//  Created by 野村 大翼 on 12/07/04.
//
//

#import <UIKit/UIKit.h>
//#import "ScrollWallpaperViewController.h"
#import "GDataXMLNode.h"

#define PRONAMA_WALLPAPER_URL @"http://pronama.jp/wallpaper/iphone.xml"

@interface WallpaperViewController : UIViewController <UIScrollViewDelegate> {    
    NSMutableArray *feedArray;
    int selectedIndex;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
- (IBAction)changePage:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationItem *WallNavItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *downloadBtn;
- (IBAction)downloadWallpaper:(id)sender;
- (IBAction)hideBars:(id)sender;
//@property (weak, nonatomic) IBOutlet UIToolbar *WallBottomBar;
@end
