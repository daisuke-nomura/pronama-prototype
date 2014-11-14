//
//  LTViewController.h
//  pronama
//
//  Created by 大翼 野村 on 12/01/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import <CFNetwork/CFNetwork.h>
#import "GDataXMLNode.h"
#import "Setting.h"
#import "NicoLive.h"
#import "NSMutableArrayWithQueue.h"

#define THREAD_REQUEST_OLD_COUNT -1
#define THREAD_REQUEST_FORMAT @"<thread thread=\"%@\" res_from=\"%d\" version=\"20061206\" />"
#define RESUME_BUTTON @"再開"
#define PAUSE_BUTTON @"一時停止"
#define LTTIMER_ALERT_TITLE @"LTタイマー"
#define LTTIMER_ALERT_MESSAGE @"LT終了!"
#define LTTIMER_ALERT_BUTTON @"確認"

#define COMMENT_MAX_COUNT 30
#define COMMENT_LAYER_WIDTH 320
#define COMMENT_ANIMATION_FROM 0
#define COMMENT_ANIMATION_DURATION 4
#define TIMER_INTERVAL 1.0f
#define COUNT_TIMER_FORMAT @"%02d:%02d"

@interface LTViewController : UIViewController <NSStreamDelegate, NSNetServiceDelegate> {
    CFSocketContext CTX;
    CFSocketRef client;
    bool connectFlag;
    NSString *sendData;
    
    CFReadStreamRef reader;
    CFWriteStreamRef writer;
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    NSMutableData *data;
    NSString *thread;
}

@property (nonatomic, assign) int time;
@property (nonatomic, assign) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *countLabelArea;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *countResumeBtn;

- (IBAction)Resume:(id)sender;
+ (NSEnumerator *)getComment;
+ (int)getCommentCount;

@end
