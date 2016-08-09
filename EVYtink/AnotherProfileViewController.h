//
//  AnotherProfileViewController.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 8/9/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P1CellCustom1.h"
#import "P1CellCustom2.h"
#import "P1CellCustom3.h"

@interface AnotherProfileViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btClose:(id)sender;
@property (nonatomic, strong) NSString *urlProfileshow;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserBg;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;

@end
