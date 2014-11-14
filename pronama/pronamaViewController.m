//
//  pronamaViewController.m
//  pronama
//
//  Created by 大翼 野村 on 12/01/22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "pronamaViewController.h"


@implementation pronamaViewController
@synthesize feedTableView;
@synthesize feedNavItem;

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    dispatch_async(global_queue, ^{
        mylistArray = [NicoVideo readMylistRSS];
        liveArray = [NicoLive readData];
        
        dispatch_async(main_queue, ^{
            [feedTableView reloadData];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    });
}

- (void)viewDidUnload
{
    [self setFeedTableView:nil];
    feedNavItem = nil;
    [self setFeedNavItem:nil];
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
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int c = 0;
    
    if (section == 0)
        c = [mylistArray count];
    else if (section == 1) {
        c = [liveArray count];
     
        if (c == 0)
            c = 1;
    }
    
    return c;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *str = NULL;
    
    if (section == 0)
        str = NICO_VIDEO;
    else if (section == 1)
        str = NICO_LIVE;
    
    return  str;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [[mylistArray objectAtIndex:indexPath.row] valueForKey:@"title"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    else if (indexPath.section == 1) {
        if ([liveArray count] > 0) {
            cell.textLabel.text = [[liveArray objectAtIndex:indexPath.row] valueForKey:@"title"];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        }
        else {
            cell.textLabel.text = LIVE_CANCELED;
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    }
    
    return cell;
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
    selectedIndex = indexPath.row;
    
    if (indexPath.section == 0) {
        NSString *str = [Setting getSessionKey];
        if (str)
            [self performSegueWithIdentifier:@"NicoFeedSegue" sender:nil];
        else {
            [tableView selectRowAtIndexPath:0 animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME message:LOGIN_MESSAGE delegate:self cancelButtonTitle:CANCEL otherButtonTitles:OK, nil];
            [alert show];
        }
    }
    else if (indexPath.section == 1) {
        //ニコ生
        if ([liveArray count] > 0) {
            
            //フォーカスを外す
            [tableView selectRowAtIndexPath:0 animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            NSDictionary *item = [liveArray objectAtIndex:0];
            [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:NICO_LIVE_APP_URL, [item valueForKey:@"id"]]]];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"NicoFeedSegue"]) {
        NicoTableViewController *controller = (NicoTableViewController *)[segue destinationViewController];
        [controller setLink:[[NSString alloc] initWithFormat:NICO_MYLIST_URL, [[mylistArray objectAtIndex:selectedIndex] valueForKey:@"id"]]];
        [controller.nicoNavItem setTitle:[[mylistArray objectAtIndex:selectedIndex] valueForKey:@"title"]];
    }
    
    //[super prepareForSegue:segue sender:sender];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
        [self performSegueWithIdentifier:@"NotLoginSegue" sender:nil];
}

@end
