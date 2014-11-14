//
//  VideoPlayerViewController.m
//  pronama
//
//  Created by 大翼 野村 on 12/01/30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VideoPlayerViewController.h"

@implementation VideoPlayerViewController
@synthesize videoDetail;

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
    [super didReceiveMemoryWarning];
}

- (void)loadView
{
    [super loadView];
    moviePlayerController = [[MPMoviePlayerController alloc] init];
    
    int width = [UIScreen mainScreen].bounds.size.height;
    [moviePlayerController.view setFrame:CGRectMake(0, 0, width, 320)];
    [self.view addSubview:moviePlayerController.view];
    [moviePlayerController setControlStyle:MPMovieControlStyleFullscreen];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    commentHidden = false;
    commentArray = [[NSMutableArray alloc] init];
    
    [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationLandscapeLeft;
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    
    //id arr = [moviePlayerController.view subviews];
    //NSLog([[NSString alloc] initWithFormat:@"%d", [arr count]]);
    
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    
    dispatch_async(global_queue, ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *str = [[NSString alloc] initWithFormat:@"mail=%@&password=%@", [defaults objectForKey:@"USERNAME"], [defaults objectForKey:@"PASSWORD"]];
        
        NSURL *url = [[NSURL alloc] initWithString:@"https://secure.nicovideo.jp/secure/login?site=niconico"];
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
        [req setHTTPMethod:@"POST"];
        [req setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
        //con = [[NSURLConnection alloc] initWithRequest:req delegate:self];
        NSURLResponse *res;
        NSError *error;
        
        NSData *result = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
        
        if (error)
            return;
        
        NSDictionary *video = [videoDetail objectForKey:@"video"];
        
        url = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"http://flapi.nicovideo.jp/api/getflv/%@", [video valueForKey:@"id"]]];
        
        
        req = [NSMutableURLRequest requestWithURL:url];
        result = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
        if (error)
            return;
        
        str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSArray *array = [str componentsSeparatedByString:@"&"];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < [array count]; i++) {
            NSArray *item = [[array objectAtIndex:i] componentsSeparatedByString:@"="];
            NSString *target = [item objectAtIndex:1];
            target = (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)target, CFSTR(""), kCFStringEncodingUTF8);
            
            [dictionary setValue:target forKey:[item objectAtIndex:0]];
        }
        
        url = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"http://www.nicovideo.jp/watch/%@", [video valueForKey:@"id"]]];
        req = [NSMutableURLRequest requestWithURL:url];
        result = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
        
        if (error)
            return;
        
        
        dispatch_async(main_queue, ^{
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(moviePlayBackDidFinish:)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:moviePlayerController];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish3:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:moviePlayerController];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish2:) name:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey object:moviePlayerController];
            
            
            NSURL *fileURL = [[NSURL alloc] initWithString:[dictionary objectForKey:@"url"]];
            [moviePlayerController setContentURL:fileURL];
            [moviePlayerController play];
            
//            
//            timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(hoge:) userInfo:nil repeats:YES];
//            [timer fire];
        });
        
        url = [[NSURL alloc] initWithString:[[NSString alloc] initWithString:[dictionary objectForKey:@"ms"]]];
        req = [NSMutableURLRequest requestWithURL:url];
        [req setHTTPMethod:@"POST"];
        
        //NSLog([dictionary objectForKey:@"ms"]);
        str = [[NSString alloc] initWithFormat:@"<thread thread=\"%@\" res_from=\"-200\" version=\"20061206\" />", [dictionary objectForKey:@"thread_id"]];
        
        //NSLog(str);
        [req setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
        [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *res, NSData *data, NSError *error) {
            
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
            
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"コメントが取得できません" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                dispatch_async(main_queue, ^{
                    [alert show]; 
                });
                return;
            }
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSMutableDictionary *elements = nil;
            for (GDataXMLElement *item in [document nodesForXPath:@"//packet/chat" error:&error]) {
                elements = [NSMutableDictionary dictionary];
                
                [elements setObject:[item stringValue] forKey:[item name]];
                GDataXMLNode *node = [item attributeForName:@"mail"];
                [elements setObject:[node stringValue] forKey:[node name]];
                node = [item attributeForName:@"vpos"];
                [elements setObject:[node stringValue] forKey:[node name]];
                
                [array addObject:elements];
            }
            
            //vpos順に並べ替え
            sortedComment = [self SortComment:array];
            
            for (int i = 0; i < [array count]; i++) {
                NSDictionary *dict = [array objectAtIndex:i];
                //NSLog([dict valueForKey:@"chat"]);
            }
        }];
        
        
    });
}

- (NSArray *)SortComment:(NSMutableArray *)array {
    //QuickSort
    [self QuickSort:array, 0, [array count] - 1];
    
    return array;
}

- (void)QuickSort:(NSMutableArray *)array, int left, int right 
{
    if (left <= right) {
        id p = [array objectAtIndex:((left + right) / 2)];
        int l = left;
        int r = right;
        
        while (l <= r) {
            while ([[array objectAtIndex:l] valueForKey:@"vpos"] < [p valueForKey:@"vpos"])
                l++;
            while ([[array objectAtIndex:r] valueForKey:@"vpos"] > [p valueForKey:@"vpos"])
                r--;
            
            if (l <= r) {
                id tmp = [array objectAtIndex:l];
                [array replaceObjectAtIndex:l withObject:[array objectAtIndex:r]];
                [array replaceObjectAtIndex:r withObject:tmp];
                l++;
                r--;
            }
        }
        
        [self QuickSort:array, left,r];
        [self QuickSort:array, l, right];
    }
}

- (void)hoge:(NSTimer*)countTimer {
    ushort interval = 1;//ミリ秒　コメントのvposをx10してないので1　サーバから得る値は10ms単位
    time += interval;
    
    //if (sortedComment == NULL)
        return;
    
    while (sortedComment != NULL && n <= [sortedComment count] && (int)([[sortedComment objectAtIndex:n] valueForKey:@"vpos"]) <= time) {
        //コメント流す
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(480, 0, 20, 20)];
        [text setText:[[NSString alloc] initWithFormat:@"%@", [[sortedComment objectAtIndex:n] valueForKey:@"chat"]]];
        //[text setText:[[NSString alloc] initWithFormat:@"%d", time]];
        [text setFont:[UIFont systemFontOfSize:24]];
        [text sizeToFit];
        [text setTextColor:[UIColor colorWithWhite:1 alpha:1]];
        [text setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
        [text setShadowColor:[UIColor blackColor]];
        [text setShadowOffset:CGSizeMake(1, 1)];
        [moviePlayerController.view addSubview:text];
        
        int from = 0;//text.frame.size.width / 2 + 480;//480を画面の横幅サイズに
        int to = (text.frame.size.width) * -1 - 480;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        animation.fromValue = [NSNumber numberWithInt:from];
        animation.toValue = [NSNumber numberWithInt:to];
        animation.duration = 4;
        animation.removedOnCompletion = YES;
        animation.delegate = self;
        [[text layer] addAnimation:animation forKey:@"transform.translation.y"];
        
        //listにadd
        [commentArray addObject:text];
        n++;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    UILabel *label = [commentArray objectAtIndex:0];
    [label removeFromSuperview];
    [commentArray removeObjectAtIndex:0];
}

- (void)finishPreload:(NSNotification *)aNotification {
    MPMoviePlayerController *player = [aNotification object];
    //[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    //name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  //object:player];
    [player play];
}


- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    [moviePlayerController stop];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) moviePlayBackDidFinish2:(NSNotification*)notification {
    //ムービー完了原因の取得
    NSDictionary* userInfo=[notification userInfo];
    int reason=[[userInfo objectForKey:
                 @"MPMovieFinishReason"] intValue];
    if (reason==MPMovieFinishReasonPlaybackEnded) {
        NSLog(@"再生終了");
    } else if (reason==MPMovieFinishReasonPlaybackError) {
        NSLog(@"エラー");
    } else if (reason==MPMovieFinishReasonUserExited) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) moviePlayBackDidFinish3:(NSNotification*)notification {
    //ムービー完了原因の取得
    MPMoviePlayerController *player = [notification object];
    
    
    NSString* userInfo=[notification userInfo];
    //int reason=[[userInfo objectForKey:
   //              @"MPMoviePlayerPlaybackDidFinishReasonUserInfoKey"] intValue];
//    if (reason==MPMovieFinishReasonPlaybackEnded) {
//        NSLog(@"再生終了");
//    } else if (reason==MPMovieFinishReasonPlaybackError) {
//        NSLog(@"エラー");
//    } else if (reason==MPMovieFinishReasonUserExited) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    //[moviePlayerController stop];
    //[[UIApplication sharedApplication] setStatusBarHidden:NO];
    //[self dismissViewControllerAnimated:YES completion:nil];
    NSLog(userInfo);
}

- (void)hiddenComment
{
    NSArray *array = [moviePlayerController.view subviews];
    
    for (int i = 0; i < [array count]; i++) {
        if (commentHidden)
            [[array objectAtIndex:i] setHidden:YES];
        else
            [[array objectAtIndex:i] setHidden:NO];
    }
    
    commentHidden += commentHidden;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

@end
