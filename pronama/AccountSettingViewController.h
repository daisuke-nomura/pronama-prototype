//
//  AccountSettingViewController.h
//  pronama
//
//  Created by 大翼 野村 on 12/03/05.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MENU_ACCOUNT @"アカウント"
#define MENU_OTHER @"LTタイマー"
#define BUTTON_LOGIN @"ログイン"

@interface AccountSettingViewController : UITableViewController <UITextFieldDelegate> {
    UITextField *textField1, *textField2;
}

@end
