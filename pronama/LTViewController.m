//
//  LTViewController.m
//  pronama
//
//  Created by 大翼 野村 on 12/01/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LTViewController.h"

@implementation LTViewController

@synthesize time;
@synthesize timer;
@synthesize countLabelArea;
@synthesize countLabel;
@synthesize countResumeBtn;

static NSMutableArrayWithQueue *commentPlacedArray, *commentQueue, *receivedComment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    commentPlacedArray = [[NSMutableArrayWithQueue alloc] init];
    commentQueue = [[NSMutableArrayWithQueue alloc] initWithCapacity:COMMENT_MAX_COUNT];
    receivedComment = [[NSMutableArrayWithQueue alloc] init];
    inputStream = nil;
    outputStream = nil;
    [self startTimer];

    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    
    dispatch_async(global_queue, ^{
        if (![Setting deepLogin])
            return;
        
        NSDictionary *dictionary = [NicoLive readData:[Setting getCommunityId]];
        if (dictionary == nil)
            return;
        
        NSDictionary *dictionary2 = [NicoLive readLiveData:[dictionary valueForKey:@"id"]];
        dictionary = nil;
        
        NSString *addr = [dictionary2 valueForKey:@"addr"];
        int port = [[dictionary2 valueForKey:@"port"] intValue];
        thread = [dictionary2 valueForKey:@"thread"];//入ってないかも?
        
        dispatch_async(main_queue, ^{
            //ソケットを開くときはメインスレッドの必要がある
            CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef) addr, port, &reader, &writer);
            
            if (reader && writer) {
                CFReadStreamSetProperty(reader, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
                CFWriteStreamSetProperty(writer, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
                
                inputStream = (__bridge NSInputStream *)reader;
                [inputStream setDelegate:self];
                [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                [inputStream open];
                
                outputStream = (__bridge NSOutputStream *)writer;
                [outputStream setDelegate:self];
                [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                [outputStream open];
            }
        });
    });
}

- (void)viewDidUnload
{
    if (inputStream != nil) {
        [inputStream close];
        inputStream = nil;
    }
    
    if (outputStream != nil) {
        [outputStream close];
        outputStream = nil;
    }
    
    commentQueue = nil;
    receivedComment = nil;
    [self setCountLabelArea:nil];
    [self setCountLabel:nil];
    [self setCountResumeBtn:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch(eventCode) {
        case NSStreamEventNone:
            break;
        case NSStreamEventOpenCompleted:
            break;
        case NSStreamEventHasSpaceAvailable: {
            NSString *sendData = [[NSString alloc] initWithFormat:THREAD_REQUEST_FORMAT, thread, THREAD_REQUEST_OLD_COUNT];
            NSData *data = [[NSData alloc] initWithData:[sendData dataUsingEncoding:NSASCIIStringEncoding]];
            [outputStream write:[data bytes] maxLength:[data length]];
            
            uint8_t *rawData[2];
            rawData[0] = 0;
            rawData[1] = 0;
            [outputStream write:rawData maxLength:1];
            [outputStream close];
        }
            break;
        case NSStreamEventErrorOccurred:
            break;
        case NSStreamEventEndEncountered:
            break;
        case NSStreamEventHasBytesAvailable: {
            if (data == nil) {
                data = [[NSMutableData alloc] init];
            }
            
            uint8_t buf[1024];
            unsigned int len = 0;
            len = [(NSInputStream *)aStream read:buf maxLength:1024];
            if(len) {
                [data appendBytes:(const void *)buf length:len];
                int bytesRead;
                bytesRead += len;
            } else {
                NSLog(@"データなし");
            }
            
            NSString *str = [[NSString alloc] initWithData:data
                                                  encoding:NSUTF8StringEncoding];
            str = [str stringByReplacingOccurrencesOfString:@"\0" withString:@""];
            str = [[NSString alloc] initWithFormat:@"<xml>%@</xml>", str];
            
            NSLog(str);
            
            NSError *error = nil;
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
            
            if (!error) {
                for (GDataXMLNode *item in [document nodesForXPath:@"//chat" error:&error]) {
                    for (GDataXMLNode *child in [item children]) {
                        [receivedComment enqueue:[child stringValue]];
                        NSLog([child stringValue]);
                    }
                }
            }
            
            document = nil;
            data = nil;
            error = nil;
            str = nil;
        }
            break;
        default:
            break;
    }
}

- (void)startTimer {
    time = time + 1;//何故か1を足す
    
    [countLabelArea setHidden:NO];
    [countLabel setText:[[NSString alloc] initWithFormat:COUNT_TIMER_FORMAT, time / 60, time % 60]];
    [countResumeBtn setHidden:NO];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(tickCount:) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)tickCount:(NSTimer*)countTimer {
    time--;
    
    if (time != -1)
    {
        int time2 = time;
        if (time2 < 0)
            time2 = 0;
        
        [countLabel setText:[[NSString alloc] initWithFormat:@"%02d:%02d", time2 / 60, time2 % 60]];
        
        if (!([receivedComment getCount] > 0))
            return;
        
        NSString *comment = [receivedComment dequeue];
        
        if ([comment isEqualToString:@"/disconnect"])
            return;
        
        //コメントを流す
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(320, [commentPlacedArray getCount] * 30, 20, 20)];
        //[text setText:[[NSString alloc] initWithFormat:@"%@", [[sortedComment objectAtIndex:n] valueForKey:@"chat"]]];
        [label setText:[[NSString alloc] initWithFormat:@"%@", comment]];
        [label setFont:[UIFont systemFontOfSize:24]];
        [label sizeToFit];
        [label setTextColor:[UIColor colorWithWhite:1 alpha:1]];
        [label setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
        [label setShadowColor:[UIColor blackColor]];
        [label setShadowOffset:CGSizeMake(1, 1)];
        [countLabelArea addSubview:label];
        
        //衝突判定なしでアニメーションさせる
        int from = COMMENT_ANIMATION_FROM;//text.frame.size.width / 2 + 480;//480を画面の横幅サイズに
        int to = (label.frame.size.width) * -1 - COMMENT_LAYER_WIDTH;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        animation.fromValue = [NSNumber numberWithInt:from];
        animation.toValue = [NSNumber numberWithInt:to];
        animation.duration = COMMENT_ANIMATION_DURATION;
        animation.removedOnCompletion = YES;
        animation.delegate = self;
        [[label layer] addAnimation:animation forKey:@"transform.translation.y"];
        
        //listにadd
        [commentPlacedArray enqueue:label];
        [commentQueue enqueue:label.text];
    }
    else if (time == -1){
        //[timer invalidate];
        //timer = nil;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LTTIMER_ALERT_TITLE message:LTTIMER_ALERT_MESSAGE delegate:self cancelButtonTitle:LTTIMER_ALERT_BUTTON otherButtonTitles:nil];
        [alert show];
        
        //NSError *error;
        //NSString *path = @"/System/Library/Audio/UISounds";
        //NSArray *sounds = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
        
        //NSString *file = [sounds objectAtIndex:0];
        //NSString *path2 = [[NSString alloc] initWithFormat:@"/System/Library/Audio/UISounds/%@", file];
        
        //NSURL *url = [[NSURL alloc ] initFileURLWithPath:path2];
        //SystemSoundID sound;
        //OSStatus status = AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sound);
        
        //if (status == kAudioServicesNoError) {
            AudioServicesPlaySystemSound(1000);
        //}
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    UILabel *label = [commentPlacedArray dequeue];
    [label removeFromSuperview];
    label = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView title] == @"通知")
        return;
}

- (IBAction)Resume:(id)sender {
    if (timer != nil && timer.isValid)
    {
        [timer invalidate];
        timer = nil;
        [countResumeBtn setTitle:RESUME_BUTTON forState:UIControlStateNormal];
    }
    else {
        [countResumeBtn setTitle:PAUSE_BUTTON forState:UIControlStateNormal];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(tickCount:) userInfo:nil repeats:YES];
        [timer fire];
    }
}

+ (NSEnumerator *)getComment {
    return [commentQueue objectEnumerator];
}

+ (int)getCommentCount {
    return [commentQueue getCount];
}

@end
