//
//  P1D2TableViewCell.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/26/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol P1D2TableViewCellControllerDelegate <NSObject>
-(void)userPost:(NSString *)idUserPost;
-(void)editPost:(NSString *)idUserPost indexpath:(NSIndexPath *)indexPath;
@required

@end

@interface P1D2TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *txtName;
@property (weak, nonatomic) IBOutlet UILabel *txtDate;
@property (weak, nonatomic) IBOutlet UILabel *txtDetail;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic1;
@property (nonatomic,strong) NSString *urlToShow;
@property (nonatomic,strong) NSIndexPath *indexAction;
@property (nonatomic,strong) NSString *strObjId;
- (IBAction)btEditAction:(id)sender;

@property (assign, nonatomic) id<P1D2TableViewCellControllerDelegate> delegate;
@property (nonatomic,strong) NSString *userPostId;

@end
