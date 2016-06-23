//
//  P1CellCustom2.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 5/23/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBSDKLoginKit.framework/Headers/FBSDKLoginKit.h"

@protocol P1CellCustom2ControllerDelegate <NSObject>
-(BOOL)ChkFacebookLoginStatus;
-(void)shareToFacebook:(NSString *)urlToShare;
-(void)commentTo:(NSIndexPath *)indexPath;
@required

@end

@interface P1CellCustom2 : UITableViewCell<FBSDKLoginButtonDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *txtName;
@property (weak, nonatomic) IBOutlet UILabel *txtDate;
@property (weak, nonatomic) IBOutlet UILabel *txtDetail;
@property (weak, nonatomic) IBOutlet UIImageView *imgPic1;
- (IBAction)btLike:(id)sender;
- (IBAction)btShare:(id)sender;
- (IBAction)btComment:(id)sender;

@property (nonatomic,strong) NSString *urlToShow;
@property (nonatomic,strong) NSIndexPath *indexAction;
@property (nonatomic,strong) NSString *strObjId;
@property (assign, nonatomic) id<P1CellCustom2ControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *btLikeOutlet;


@end