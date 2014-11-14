//
//  DetailVideoViewController.m
//  pronama
//
//  Created by 大翼 野村 on 12/01/30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DetailVideoViewController.h"


@implementation DetailVideoViewController
@synthesize videoDetail;

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
    
    NSDictionary *item = [videoDetail objectForKey:@"video"];
    [self.navigationItem setTitle:[item valueForKey:@"title"]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
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
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str;
    
    switch (section) {
        case 0:
            str = [[NSString alloc] initWithFormat:@"動画情報"];
            break;
        case 1:
            str = [[NSString alloc] initWithFormat:@"説明文"];
            break;
        case 2:
            str = [[NSString alloc] initWithFormat:@"タグ"];
            break;
        default:
            break;
    }
    
    return str;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int c = 0;
    
    switch (section) {
        case 0:
            c = 1;
            break;
        case 1:
            c = 1;
            break;
        case 2: {
            NSDictionary *item = ([videoDetail objectForKey:@"tags"]);
            NSArray *item2 = [item objectForKey:@"tag_info"];
            c = [item2 count];
        }
            break;
        default:
            break;
    }
    
    return c;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int height = 0;
    
    switch (indexPath.section) {
        case 0:
            height = 130;
            break;
        case 1: 
            height = 324;
            break;
        case 2:
            height = 50;
            break;
        default:
            break;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"FeedDetailCell";
        FeedDetailCell *cell = (FeedDetailCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            FeedDetailCellController *controller = [[FeedDetailCellController alloc] initWithNibName:identifier bundle:nil];
            cell = (FeedDetailCell *)controller.view;
        }
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        NSDictionary *item = videoDetail;
        NSDictionary *feed = [item valueForKey:@"video"];
        
        cell.titleLabel.text = [feed valueForKey:@"title"];
        //cell.subLabel.text = [feed valueForKey:@"link"];
        
        NSString *str = [[item objectForKey:@"thread"] valueForKey:@"num_res"];
        
        NSInteger interval = [[feed valueForKey:@"length_in_seconds"] intValue];
        NSInteger interval2 = interval % 60;
        interval /= 60;
        
        NSString *count = [[NSString alloc] initWithFormat:@"再生：%@\nコメント：%@\nマイリスト：%@\n再生時間：%@", [feed valueForKey:@"view_counter"], str, [feed valueForKey:@"mylist_counter"], [[NSString alloc] initWithFormat:@"%02d:%02d", interval, interval2]];
        cell.countLabel.text = count;
        
        
        if (![videoDetail objectForKey:@"loaded_image"]) {
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
                    [videoDetail setValue:image forKey:@"loaded_image"];
                }
                
                dispatch_async(main_queue, ^{
                    [cell.videoImage setImage:image];
                    [indicator removeFromSuperview];
                });
            });
        }
        else {
            [cell.videoImage setImage:[videoDetail objectForKey:@"loaded_image"]];
        }
        
        
        //NSLog([feed valueForKey:@"upload_time"]);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        NSDate *dept_dateNsdate = [dateFormatter dateFromString:[feed valueForKey:@"upload_time"]];
        //        dateFormatter = nil;
        //        dateFormatter = [[NSDateFormatter alloc] init];
        //        dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
        //cell.postLabel.text = [dept_dateNsdate description];
        //cell.postLabel.text = [dept_dateNsdate description];
        cell.postLabel.text = [feed valueForKey:@"upload_time"];
        
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString *identifier = @"FeedDescCell";
        FeedDescCell *cell = (FeedDescCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            FeedDescCellController *controller = [[FeedDescCellController alloc] initWithNibName:identifier bundle:nil];
            cell = (FeedDescCell *)controller.view;
        }

        NSDictionary *item = [videoDetail objectForKey:@"video"];
        NSString *str = [item objectForKey:@"description"];
        cell.descTextView.text = str;
        CGRect frame = cell.descTextView.frame;
        
        if (cell.descTextView.contentSize.height < 300)
            frame.size.height = cell.descTextView.contentSize.height;
        else frame.size.height = 300;
        
        descHeight = cell.descTextView.contentSize.height;
        cell.descTextView.frame = frame;
        
        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"Cell";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        switch (indexPath.section) {
//            case 1: {
//                NSDictionary *item = [videoDetail objectForKey:@"video"];
//                NSString *str = [item objectForKey:@"description"];
//                //cell.textLabel.text = str;
//                
//                UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 280, 300)];
//                text.text =str;
//                [cell addSubview:text];
//            }
//                break;
            case 2: {
                NSDictionary *item = [videoDetail objectForKey:@"tags"];
                NSArray *item2 = [item objectForKey:@"tag_info"];
                NSDictionary *item3 = [item2 objectAtIndex:indexPath.row];
                cell.textLabel.text = [item3 objectForKey:@"tag"];
//                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//                [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                [cell setSelectionStyle:UITableViewCellEditingStyleNone];
            }
                break;
            default:
                break;
        }
        
        return cell;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [super performSegueWithIdentifier:@"VideoWatchSegue1" sender:tableView];
    }
//    else if (indexPath.section == 2) {
//        selectedIndex = indexPath.row;
//        [super performSegueWithIdentifier:@"VideoListSegue" sender:tableView];
//    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"VideoWatchSegue1"]) {
        VideoPlayerViewController *controller = (VideoPlayerViewController *)[segue destinationViewController];
        [controller setVideoDetail:videoDetail];
    }
    else if ([[segue identifier] isEqualToString:@"VideoListSegue"]) {
        NSDictionary *item = [videoDetail objectForKey:@"tags"];
        NSArray *item2 = [item objectForKey:@"tag_info"];
        NSDictionary *item3 = [item2 objectAtIndex:selectedIndex];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[item3 objectForKey:@"tag"] message:[item3 objectForKey:@"tag"] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        
        return;
//        NicoTableViewController *controller = (NicoTableViewController *)[segue destinationViewController];
//        [controller setLink:[[NSString alloc] initWithFormat:[[]]];
    }
    
    [super prepareForSegue:segue sender:sender];
}

- (IBAction)actionDetailVideo:(id)sender {
    NSDictionary *item = [videoDetail objectForKey:@"video"];
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    [sheet setTitle:[item valueForKey:@"title"]];
    sheet.delegate = self;
    [sheet addButtonWithTitle:@"ツイート"];
    [sheet addButtonWithTitle:@"Safariで開く"];
    [sheet addButtonWithTitle:@"公式アプリで開く"];
//    [sheet addButtonWithTitle:@"iNicoで開く"];
    [sheet addButtonWithTitle:@"キャンセル"];
    sheet.destructiveButtonIndex = 3;
    [sheet showInView:self.view.window];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSDictionary *item = [videoDetail objectForKey:@"video"];
    
    switch (buttonIndex) {
        case 0:
        {
            TWTweetComposeViewController *tw = [[TWTweetComposeViewController alloc] init];
            NSMutableString *str = [NSMutableString string];
            [str appendString:[item valueForKey:@"title"]];
            [str appendFormat:@" #%@", [item valueForKey:@"id"]];
            [str appendFormat:@" http://nico.ms/%@", [item valueForKey:@"id"]];
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
            [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"http://i.nicovideo.jp/watch/%@", [item valueForKey:@"id"]]]];
            break;
        case 2:
            [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"nicovideo://%@/", [item valueForKey:@"id"]]]];
            break;
//        case 3:
//            [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"inico://%@", [item valueForKey:@"id"]]]];
//            break;
        default:
            break;
    }
}

@end
