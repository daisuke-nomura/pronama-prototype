//
//  AboutViewController.m
//  pronama
//
//  Created by 大翼 野村 on 12/01/30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "Setting.h"

@implementation AccountSettingViewController


dispatch_queue_t  global_queue;
dispatch_queue_t main_queue;

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
    [self.navigationItem setTitle:@"アカウント設定"];
    
    global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    main_queue =  dispatch_get_main_queue();
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int c = 0;
    
    if (section == 0)
        c = 3;
    else if (section == 1)
        c = 1;//本来は2
    
    return c;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *str;
    
    switch (section) {
        case 0:
            str = MENU_ACCOUNT;
            break;
        case 1:
            str = MENU_OTHER;
            break;
        default:
            break;
    }
    
    return str;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            case 1: {
                static NSString *CellIdentifier = @"Cell";
                
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[UIColor whiteColor]];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 120, 30)];
                    label.font = [UIFont boldSystemFontOfSize:16];
                    //[label setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
                    [label setBackgroundColor:cell.backgroundColor];
                    
                    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(130, 10, 150, 30)];
                    textField.returnKeyType = UIReturnKeyDone; // ReturnキーをDoneに変える
                    
                    textField.delegate = self;
                    textField.tag = [indexPath row];
                    
                    // ユーザが既に設定済みであればその情報を表示する
                    if ([indexPath row] == 0) {
                        label.text = @"メールアドレス";
                        [textField setKeyboardType:UIKeyboardTypeEmailAddress];
                        [textField setPlaceholder:@"メールアドレス"];
                        textField.text = [Setting getMailAddr];
                        textField1 = textField;
                    } else if ([indexPath row] == 1) {
                        label.text = @"パスワード";
                        textField.secureTextEntry = YES;    // パスワードを画面に表示しないようにする
                        [textField setKeyboardType:UIKeyboardTypeDefault];
                        [textField setPlaceholder:@"パスワード"];
                        textField.text = [Setting getPassword];
                        textField2 = textField;
                    }
                    
                    [cell.contentView addSubview:label];
                    [cell.contentView addSubview:textField];
                }
            }
                break;
            case 2: {
                static NSString *CellIdentifier = @"Cell";
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                cell.textLabel.text = BUTTON_LOGIN;
                [cell.textLabel setTextAlignment:UITextAlignmentCenter];
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
                break;
            default:
                break;
        }

    }
    else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"Cell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBackgroundColor:[UIColor whiteColor]];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 120, 30)];
            label.font = [UIFont boldSystemFontOfSize:16];
            [label setBackgroundColor:cell.backgroundColor];
            //[label setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(130, 10, 150, 30)];
            textField.returnKeyType = UIReturnKeyDone; // ReturnキーをDoneに変える
            textField.delegate = self;
            textField.tag = [indexPath row] + 10;
            
            // ユーザが既に設定済みであればその情報を表示する
            if ([indexPath row] == 0) {
                label.text = @"コミュニティ";
                [textField setKeyboardType:UIKeyboardTypeNamePhonePad];
                [textField setPlaceholder:@"co9320"];
                textField.text = [Setting getCommunityId];
            } else if ([indexPath row] == 1) {
                label.text = @"ハッシュタグ";
                [textField setKeyboardType:UIKeyboardTypeTwitter];
                [textField setPlaceholder:@"#tag"];
                textField.text = [Setting getHashTag];
            }
            
            [cell.contentView addSubview:label];
            [cell.contentView addSubview:textField];
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
    [self textFieldDidEndEditing:textField1];
    [self textFieldDidEndEditing:textField2];
    
    switch (indexPath.row) {
        case 2: {
            //フォーカスを外す
            [tableView selectRowAtIndexPath:0 animated:NO scrollPosition:UITableViewScrollPositionNone];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            dispatch_async(global_queue, ^{
                BOOL res = [Setting lightLogin];
                
                dispatch_async(main_queue, ^{
                    NSString *str;
                    
                    if (res)
                        str = @"ログインしました";
                    else
                        str = @"ログインに失敗しました";
                   
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"プロ生" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                });
            });
                
            }
            break;
            
        default:
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //textFieldのタグ名で処理を分ける
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //Enterを押したら編集終わり
    
    switch (textField.tag) {
        case 0:
            [Setting setMailAddr:textField.text];
            break;
        case 1:
            [Setting setPassword:textField.text];
            break;
        case 10:
            [Setting setCommunityId:textField.text];
            break;
        case 11:
            [Setting setHashTag:textField.text];
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //textFieldのタグ名で処理を分ける
    switch (textField.tag) {
        case 0:
            [Setting setMailAddr:textField.text];
            break;
        case 1:
            [Setting setPassword:textField.text];
            break;
        case 10:
            [Setting setCommunityId:textField.text];
            break;
        case 11:
            [Setting setHashTag:textField.text];
            break;
        default:
            break;
    }
}

@end
