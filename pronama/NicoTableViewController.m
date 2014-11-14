//
//  NicoTableViewController.m
//  pronama
//
//  Created by 大翼 野村 on 12/01/22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NicoTableViewController.h"
#import "FeedListCell.h"

@implementation NicoTableViewController
@synthesize nicoTableView;
@synthesize link;
@synthesize nicoNavItem;
@synthesize IndicatorView;
@synthesize loadIndicator;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [loadIndicator startAnimating];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;


    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t main_queue = dispatch_get_main_queue();

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    dispatch_async(global_queue, ^{
        NSMutableArray *array = [NicoVideo readMylistData:link];
        
        if ([Setting getSessionKey] != nil) {
            if (![Setting lightLogin])
                return;
        }
        
        if ([array count] > 0 && [Setting getSessionKey]) {
            videoArray = [NicoVideo readVideoData: array];
        }
        
        dispatch_async(main_queue, ^{
            [IndicatorView setHidden:YES];
            [nicoTableView reloadData];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    });
}

- (void)viewDidUnload
{
    [self setNicoTableView:nil];
    [self setNicoNavItem:nil];
    [self setIndicatorView:nil];
    [self setLoadIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [videoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"FeedListCell";
    
	FeedListCell *cell = (FeedListCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		FeedListCellController *controller = [[FeedListCellController alloc] initWithNibName:identifier bundle:nil];
		cell = (FeedListCell *)controller.view;
	}
    
    if ([videoArray count] > 0) {
        NSDictionary *item = [videoArray objectAtIndex:indexPath.row];
        NSDictionary *feed = [item valueForKey:@"video"];
        
        cell.titleLabel.text = [feed valueForKey:@"title"];
        cell.subLabel.text = [feed valueForKey:@"link"];
        
        NSString *str = [[item objectForKey:@"thread"] valueForKey:@"num_res"];
        
        NSString *count = [[NSString alloc] initWithFormat:NICO_VIDEO_ITEM_COUNT_FORMAT, [feed valueForKey:@"view_counter"], str, [feed valueForKey:@"mylist_counter"]];
        cell.countLabel.text = count;
        
//        NSRange match = [[[feedArray objectAtIndex:indexPath.row] valueForKey:@"description"] rangeOfString:@"src=\"[a-zA-Z0-9.?=:\"/-]+\"" options:NSRegularExpressionSearch];
//        if (match.location != NSNotFound) {
//            NSString *str = [[[feedArray objectAtIndex:indexPath.row] valueForKey:@"description"] substringWithRange:match];
//            NSRange range = NSMakeRange(5, [str length] - 6);
//            str = [str substringWithRange:range];
//            
//            [cell.videoImage setImage:[[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:str]]]];
//        }
        
        if (![[videoArray objectAtIndex:indexPath.row] objectForKey:@"loaded_image"]) {
            dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_queue_t main_queue = dispatch_get_main_queue();
            
            dispatch_async(global_queue, ^{
                UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                indicator.frame = cell.videoImage.bounds;
                indicator.hidesWhenStopped = YES;
                indicator.contentMode = UIViewContentModeCenter;
                [indicator startAnimating];
                
                dispatch_async(main_queue, ^{
                    cell.videoImage.image = nil;
                    [cell.videoImage addSubview:indicator];
                });
                
                UIImage *image = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:[feed valueForKey:@"thumbnail_url"]]]];
                
                if (image) {
                    [[videoArray objectAtIndex:indexPath.row] setObject:image forKey:@"loaded_image"];
                }
                
                dispatch_async(main_queue, ^{
                    [cell.videoImage setImage:image];
                    [indicator removeFromSuperview];
                });
            });
        }
        else {
            [cell.videoImage setImage:[[videoArray objectAtIndex:indexPath.row] objectForKey:@"loaded_image"]];
        }
        
        
//        NSRange match = [[[feedArray objectAtIndex:indexPath.row] valueForKey:@"description"] rangeOfString:@"<strong class=\"nico-info-length\">[0-9.?=:\"/-]+</strong>" options:NSRegularExpressionSearch];
//        if (match.location != NSNotFound) {
//            NSString *str = [[[feedArray objectAtIndex:indexPath.row] valueForKey:@"description"] substringWithRange:match];
//            NSRange range = NSMakeRange(33, [str length] - 42);
//            str = [str substringWithRange:range];
//            
//            cell.lengthLabel.text = str;
//        }
        
        cell.lengthLabel.text = [[videoArray objectAtIndex:indexPath.row] valueForKey:@"length_in_seconds"];
        
        
//        NSRange match = [[[feedArray objectAtIndex:indexPath.row] valueForKey:@"description"] rangeOfString:@"<strong class=\"nico-info-date\">[a-zA-Z0-9.?=:\"/-]+</strong>" options:NSRegularExpressionSearch];
//        if (match.location != NSNotFound) {
//            NSString *str = [[[feedArray objectAtIndex:indexPath.row] valueForKey:@"description"] substringWithRange:match];
//            NSRange range = NSMakeRange(32, [str length] - 42);
//            str = [str substringWithRange:range];
//            
//            cell.postLabel.text = str;
//        }
        
        NSInteger interval = [[feed valueForKey:@"length_in_seconds"] intValue];
        NSInteger interval2 = interval % 60;
        interval /= 60;
        cell.lengthLabel.text = [[NSString alloc] initWithFormat:@"%02d:%02d", interval, interval2];
        
        
        //NSLog([feed valueForKey:@"upload_time"]);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        NSDate *dept_dateNsdate = [dateFormatter dateFromString:[feed valueForKey:@"upload_time"]];
//        dateFormatter = nil;
//        dateFormatter = [[NSDateFormatter alloc] init];
//        dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
        //cell.postLabel.text = [dept_dateNsdate description];
        cell.postLabel.text = [feed valueForKey:@"upload_time"];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    [super performSegueWithIdentifier:@"VideoWatchSegue" sender:nil];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = indexPath.row;
    [super performSegueWithIdentifier:@"DetailViewSegue" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 102;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"DetailViewSegue"]) {
        DetailVideoViewController *controller = (DetailVideoViewController *)[segue destinationViewController];
        [controller setVideoDetail:[videoArray objectAtIndex:selectedIndex]];
    }
    else if ([[segue identifier] isEqualToString:@"VideoWatchSegue"]) {
        VideoPlayerViewController *controller = (VideoPlayerViewController *)[segue destinationViewController];
        [controller setVideoDetail:[videoArray objectAtIndex:selectedIndex]];
        
    }
    
    [super prepareForSegue:segue sender:segue];
}

@end
