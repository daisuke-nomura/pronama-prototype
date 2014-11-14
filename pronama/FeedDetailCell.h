//
//  FeedDetailCell.h
//  pronama
//
//  Created by 大翼 野村 on 12/02/05.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedDetailCell : UITableViewCell {
    
    __weak IBOutlet UILabel *feedDetailTitle;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UIImageView *videoImage;
    __weak IBOutlet UILabel *postLabel;
    __weak IBOutlet UITextView *countLabel;
}
@property (weak, nonatomic) UILabel *feedDetailTitle;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UITextView *countLabel;

@end

@interface FeedDetailCellController : UIViewController {
    IBOutlet FeedDetailCell *cell;
}

@property (nonatomic, retain) FeedDetailCell *cell;

@end
