//
//  SecondViewController.m
//  pronama
//
//  Created by 大翼 野村 on 12/01/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController
@synthesize blogWebView;
@synthesize blogNavItem;
@synthesize link;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
//    btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    [btn1 setImage:[UIImage imageNamed:@"l"] forState:UIControlStateNormal];
//    [btn1 addTarget:self action:@selector(hoge:) forControlEvents:UIControlEventTouchUpInside];
//    [btn1 setEnabled:NO];
//    UIBarButtonItem *ubi = [[UIBarButtonItem alloc] initWithCustomView:btn1];
//    
//    btn12 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    [btn12 setImage:[UIImage imageNamed:@"r"] forState:UIControlStateNormal];
//    [btn12 addTarget:self action:@selector(hoge2:) forControlEvents:UIControlEventTouchUpInside];
//    [btn12 setEnabled:NO];
//    UIBarButtonItem *ubi2 = [[UIBarButtonItem alloc] initWithCustomView:btn12];
    
//    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:ubi, ubi2, nil];
//    [blogNavItem setLeftBarButtonItems:array animated:YES];
//    
    
    }

- (void)viewDidUnload
{
    [self setBlogWebView:nil];
    [self setBlogNavItem:nil];
    
    [self setLink:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (link != NULL)
        [blogWebView loadRequest:[[NSURLRequest alloc] initWithURL:link]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            TWTweetComposeViewController *tw = [[TWTweetComposeViewController alloc] init];
            NSString *str = [[NSString alloc] initWithFormat:@"%@ %@", [blogWebView stringByEvaluatingJavaScriptFromString:@"document.title"], [blogWebView stringByEvaluatingJavaScriptFromString:@"document.URL"]];
            
            [tw setInitialText:str];
            [self presentModalViewController:tw animated:YES];
            
            tw.completionHandler = ^(TWTweetComposeViewControllerResult res) {
                if (res == TWTweetComposeViewControllerResultDone)
                    NSLog(@"tweeted");
                else {
                    
                }
                
                [self dismissModalViewControllerAnimated:YES];
            };
        };
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[blogWebView stringByEvaluatingJavaScriptFromString:@"document.URL"]]];
            break;
        default:
            break;
    }
}

- (void)blogActionBtn:(id)sender {
    NSString *str = [blogWebView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    [sheet setTitle:str];
    sheet.delegate = self;
    [sheet addButtonWithTitle:ACTION_SHEET_BUTTON_NAME1];
    [sheet addButtonWithTitle:ACTION_SHEET_BUTTON_NAME2];
    [sheet addButtonWithTitle:ACTION_SHEET_BUTTON_NAME3];
    sheet.destructiveButtonIndex = 2;
    [sheet showInView:self.view.window];
}

- (void)backbuttonPush:(id)sender {
    if (blogWebView.canGoBack)
        [blogWebView goBack];
}

- (void)forwardbuttonPush:(id)sender {
    if (blogWebView.canGoForward)
        [blogWebView goForward];
}
@end
