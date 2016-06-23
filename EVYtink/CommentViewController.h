//
//  CommentViewController.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 6/22/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *newsId;
@property (nonatomic,strong) NSMutableArray *arrComment;

@property (weak, nonatomic) IBOutlet UITableView *tableViewComment;


@end
