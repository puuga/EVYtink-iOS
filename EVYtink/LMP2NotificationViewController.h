//
//  LMP2NotificationViewController.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/9/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMP2NotificationViewController : UIViewController<UITabBarDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *arrNoti;

@end
