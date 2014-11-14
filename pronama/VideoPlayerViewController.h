//
//  VideoPlayerViewController.h
//  pronama
//
//  Created by 大翼 野村 on 12/01/30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>
#import "GDataXMLNode.h"

@interface VideoPlayerViewController : UIViewController {
    MPMoviePlayerController *moviePlayerController;
    NSTimer *timer;
    NSMutableArray *commentArray;
    NSArray *sortedComment;
    void *QuickSort;
    BOOL commentHidden;
    uint time;
    uint n;
}

- (NSArray *)SortComment:(NSMutableArray *)array;
- (void)QuickSort:(NSMutableArray *)array, int left, int right;

- (NSUInteger)supportedInterfaceOrientations;
- (BOOL)shouldAutorotate;
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation;

@property (strong, nonatomic) NSDictionary *videoDetail;
@end
