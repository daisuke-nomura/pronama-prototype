//
//  FeedDescCell.h
//  pronama
//
//  Created by 大翼 野村 on 12/02/04.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedDescCell : UITableViewCell {
    __weak IBOutlet UITextView *descTextView;
}

@property (weak, nonatomic) UITextView *descTextView;

@end


@interface FeedDescCellController : UIViewController {
    IBOutlet FeedDescCell *cell;
}

@property (nonatomic, retain) FeedDescCell *cell;

@end
