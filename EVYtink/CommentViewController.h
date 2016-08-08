//
//  CommentViewController.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 6/22/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P1CellCustom1.h"
#import "P1CellCustom2.h"
#import "P1CellCustom3.h"

@interface CommentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *newsId;
@property (nonatomic,strong) NSMutableArray *arrComment;

@property (weak, nonatomic) IBOutlet UITableView *tableViewComment;
- (IBAction)gotoCommentPost:(id)sender;

@property (nonatomic,strong) NSString *urlimgUser;
@property (nonatomic,strong) NSString *urlImg1;
@property (nonatomic,strong) NSString *urlImg2;
@property (nonatomic,strong) NSString *strObj;
@property (nonatomic,strong) NSString *txtname;
@property (nonatomic,strong) NSString *userPostId;
@property (nonatomic,strong) NSString *txtDate;
@property (nonatomic,strong) NSString *txtDetail;
@property (nonatomic,strong) NSString *urlToShow;
@property (nonatomic,strong) NSString *statusShared;


@end
