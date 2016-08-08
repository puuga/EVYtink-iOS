//
//  P4TimelineViewController.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/28/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P1CellCustom1.h"
#import "P1CellCustom2.h"
#import "P1CellCustom3.h"

@interface P4TimelineViewController : UIViewController<UITableViewDelegate,UITableViewDelegate,FBSDKLoginButtonDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgVNotlogin;
@property (weak, nonatomic) IBOutlet UIButton *loginBtProperties;
- (IBAction)loginBT:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *TableView;

@property (nonatomic,strong) NSMutableArray *arrTimeline;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postBtProperties;
- (IBAction)postBtAction:(id)sender;

@end
