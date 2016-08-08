//
//  CommentTableViewCell.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 6/22/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageUser;
@property (weak, nonatomic) IBOutlet UILabel *txtUserName;
@property (weak, nonatomic) IBOutlet UILabel *txtComment;
@property (weak, nonatomic) IBOutlet UILabel *txtTime;

@end
