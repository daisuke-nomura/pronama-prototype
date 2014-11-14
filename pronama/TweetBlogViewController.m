//
//  TweetBlogViewController.m
//  pronama
//
//  Created by 大翼 野村 on 12/01/22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TweetBlogViewController.h"


@implementation TweetBlogViewController
@synthesize feedTableView;

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    sectionName = [[NSArray alloc] initWithObjects:PRONAMA_NAME, PRONAMA_NAME2, nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t main_queue = dispatch_get_main_queue();
        
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    dispatch_async(global_queue, ^{
        feedArray = [Feed readData];

        dispatch_async(main_queue, ^{
            [feedTableView reloadData];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    });
}

- (void)viewDidUnload
{
    feedArray = nil;
    sectionName = nil;
    [self setFeedTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}

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
    return SECTION_COUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int c = 0;
    
    if (section == 0)
        c = SECTION_COUNT;
    else if (section == 1) {
        c = [feedArray count];
    }
    
    // Return the number of rows in the section.
    return c;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *str = [sectionName objectAtIndex:section];
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
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = TWEET_MENU_NAME;
                break;
            case 1:
                cell.textLabel.text = WALLPAPER_MENU_NAME;
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 1) {
        cell.textLabel.text = [[feedArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                selectedIndex = -1;
                [self performSegueWithIdentifier:@"Tweet2Segue" sender:nil];
                break;
            case 1:
                [self performSegueWithIdentifier:@"WallpaperSegue" sender:nil];
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 1) {
        selectedIndex = indexPath.row;
        [self performSegueWithIdentifier:@"Tweet2Segue" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Tweet2Segue"] && selectedIndex != -1) {
        WebViewController *controller = (WebViewController *)[segue destinationViewController];
        [controller setLink:[[NSURL alloc] initWithString:[[[feedArray objectAtIndex:selectedIndex] valueForKey:@"link"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
        [controller.blogNavItem setTitle:[[feedArray objectAtIndex:selectedIndex] valueForKey:@"title"]];
        [controller setHidesBottomBarWhenPushed:YES];
    }
    else if ([[segue identifier] isEqualToString:@"Tweet2Segue"] && selectedIndex == -1) {
        WebViewController *controller = (WebViewController *)[segue destinationViewController];
        [controller setLink:[[NSURL alloc] initWithString:TWITTER_URL]];
        [controller.blogNavItem setTitle:TWEET_MENU_NAME];
        [controller setHidesBottomBarWhenPushed:YES];
    }
    else if ([[segue identifier] isEqualToString:@"WallpaperSegue"]) {
        WallpaperViewController *controller = (WallpaperViewController *)[segue destinationViewController];
        [controller.WallNavItem setTitle:PRONAMA_NAME];
        [controller setHidesBottomBarWhenPushed:YES];
    }
}

@end
