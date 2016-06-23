//
//  P1News.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 5/20/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P1CellCustom1.h"
#import "P1CellCustom2.h"
#import "P1CellCustom3.h"

@interface P1News : UITableViewController<UITableViewDataSource,UITabBarDelegate,FBSDKLoginButtonDelegate>
@property (nonatomic,strong) NSMutableArray *arrNews;
@property (nonatomic,strong) NSMutableArray *arrShowNews;

- (IBAction)BtLogout:(id)sender;

@end
