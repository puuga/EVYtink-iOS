//
//  P2Event.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 5/24/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P1D1TableViewCell.h"
#import "P1D2TableViewCell.h"
#import "P1D3TableViewCell.h"
#import "PromoteTableViewCell.h"

@interface P2Event : UITableViewController

@property (nonatomic,strong) NSMutableArray *arrEvent;
@property (nonatomic,strong) NSMutableArray *arrShowEvent;
- (IBAction)postBtAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postBtProperties;


@end
