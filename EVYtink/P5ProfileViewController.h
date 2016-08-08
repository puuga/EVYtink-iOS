//
//  P5ProfileViewController.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/15/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "P1CellCustom1.h"
#import "P1CellCustom2.h"
#import "P1CellCustom3.h"
#import "DefaultTableViewCell.h"
#import <AFNetworking.h>

@interface P5ProfileViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,FBSDKLoginButtonDelegate>


@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *notificationGeofence;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGUser;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *varLogout;

@property (weak, nonatomic) IBOutlet UIImageView *imgVNotlogin;
- (IBAction)loginBT:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginBtProperties;
- (IBAction)logoutBT:(id)sender;
- (IBAction)postBTAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postBtProperties;
@property (weak, nonatomic) IBOutlet UILabel *lbUserName;




@end
