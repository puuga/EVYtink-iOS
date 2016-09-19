//
//  PMainViewController.h
//  EVYbook
//
//  Created by roomlinksaas_dev on 8/22/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMainViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *TablePMain;
@property (nonatomic, strong) NSMutableArray *arrBook;

- (IBAction)changeTypeAction:(id)sender;

@end
