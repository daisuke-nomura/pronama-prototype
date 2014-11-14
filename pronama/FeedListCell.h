//
//  FeedListCell.h
//  pronama
//
//  Created by 大翼 野村 on 12/01/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedListCell : UITableViewCell {
    
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *subLabel;
    __weak IBOutlet UIImageView *videoImage;
    __weak IBOutlet UILabel *countLabel;
    __weak IBOutlet UILabel *postLabel;
    __weak IBOutlet UILabel *lengthLabel;
}
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *subLabel;
@property (weak, nonatomic) UIImageView *videoImage;
@property (weak, nonatomic) UILabel *countLabel;
@property (weak, nonatomic) UILabel *postLabel;
@property (weak, nonatomic) UILabel *lengthLabel;
@end


@interface FeedListCellController : UIViewController {
    IBOutlet FeedListCell *cell;
}

@property (nonatomic, retain) FeedListCell *cell;
@end