//
//  CommentViewController.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 6/22/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "CommentPostViewController.h"
#import <UIImageView+AFNetworking.h>
#import "FBSDKCoreKit.framework/Headers/FBSDKCoreKit.h"
#import "FBSDKLoginKit.framework/Headers/FBSDKLoginKit.h"
#import "FBSDKShareKit.framework/Headers/FBSDKShareKit.h"
#import "LoginFacebook.h"
#import <AFNetworking.h>
#import "P5ProfilePostViewController.h"
#import "ViewWeb.h"

@interface CommentViewController ()

@end

@implementation CommentViewController
@synthesize userId,newsId,arrComment,tableViewComment,urlImg1,urlImg2,urlimgUser,strObj,txtDate,txtname,txtDetail,urlToShow,userPostId,statusShared;
- (void)viewDidLoad {
    [super viewDidLoad];
    static NSString *CellIdentifier1 = @"idenCell1";
    static NSString *CellIdentifier2 = @"idenCell2";
    static NSString *CellIdentifier3 = @"idenCell3";
    UINib *nib1 = [UINib nibWithNibName:@"CustomCell1" bundle:nil];
    [self.tableViewComment registerNib:nib1 forCellReuseIdentifier:CellIdentifier1];
    
    UINib *nib2 = [UINib nibWithNibName:@"CustomCell2" bundle:nil];
    [self.tableViewComment registerNib:nib2 forCellReuseIdentifier:CellIdentifier2];
    
    UINib *nib3 = [UINib nibWithNibName:@"CustomCell3" bundle:nil];
    [self.tableViewComment registerNib:nib3 forCellReuseIdentifier:CellIdentifier3];
    
    [self.tableViewComment reloadData];
    self.navigationController.navigationBar.topItem.title = @"ย้อนกลับ";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor clearColor]}];
}

-(void)viewDidAppear:(BOOL)animated{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://evbt.azurewebsites.net/docs/page/theme/betajsonnewscomment.aspx?evarnid=%@&chlogin=true&evyid=%@",newsId,userId]]];
    NSLog(@"news ID - %@,user Id - %@",newsId,userId);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        arrComment = [[NSMutableArray alloc] init];
        for (int Cou = 0; Cou<[responseObject count]; Cou++) {
            //[self addArrComment:[responseObject objectAtIndex:Cou]];
            [arrComment addObject:[responseObject objectAtIndex:Cou]];
            [self.tableViewComment reloadData];
            [self.tableViewComment scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[arrComment count]-1 inSection:0]
                                         atScrollPosition:UITableViewScrollPositionBottom
                                                 animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Not Success afnetworking.,%@",error);
    }];
    [operation start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 1;
    return [arrComment count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"idenCell1";
    static NSString *CellIdentifier2 = @"idenCell2";
    static NSString *CellIdentifier3 = @"idenCell3";
    if (indexPath.row==0) {
        if ([urlImg1 isEqualToString:@"no"]) {
            P1CellCustom1 *cell = (P1CellCustom1 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            cell.delegate = self;
            cell.indexAction = indexPath;
            cell.EvyUserId = userId;
            cell.strObjId = newsId;
            cell.txtName.text = txtname;
            cell.userPostId = userPostId;
            cell.txtDate.text = txtDate;
            cell.txtDetail.text = txtDetail;
            cell.urlToShow = urlToShow;
            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlimgUser]]];
            return cell;
        }else if ([urlImg2 isEqualToString:@"no"]){
            P1CellCustom2 *cell = (P1CellCustom2 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
            cell.delegate = self;
            cell.indexAction = indexPath;
            cell.EvyUserId = userId;
            cell.strObjId = newsId;
            cell.txtName.text = txtname;
            cell.userPostId = userPostId;
            cell.txtDate.text = txtDate;
            cell.txtDetail.text = txtDetail;
            cell.urlToShow = urlToShow;
            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlimgUser]]];
            [cell.imgPic1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlImg1]]];
            return cell;
        }else{
            P1CellCustom3 *cell = (P1CellCustom3 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
            cell.delegate = self;
            cell.indexAction = indexPath;
            cell.EvyUserId = userId;
            cell.strObjId = newsId;
            cell.txtName.text = txtname;
            cell.userPostId = userPostId;
            cell.txtDate.text = txtDate;
            cell.txtDetail.text = txtDetail;
            cell.urlToShow = urlToShow;
            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlimgUser]]];
            [cell.imgPic1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlImg1]]];
            [cell.imgPic2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlImg2]]];
            return cell;
        }
    }else{
        static NSString *simpleTableIdentifier = @"cellShowComment";
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        NSLog(@"com - %@",[[arrComment objectAtIndex:(indexPath.row - 1)] objectForKey:@"imgprofile"]);
        [cell.imageUser setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrComment objectAtIndex:(indexPath.row - 1)] objectForKey:@"imgprofile"]]]];
        cell.imageUser.layer.cornerRadius = 30;
        cell.imageUser.clipsToBounds = YES;
        cell.imageUser.layer.borderWidth = 1.0f;
        cell.imageUser.layer.borderColor = [UIColor grayColor].CGColor;
        cell.txtUserName.text = [[arrComment objectAtIndex:(indexPath.row - 1)] objectForKey:@"fname"];
        cell.txtComment.text = [[arrComment objectAtIndex:(indexPath.row - 1)] objectForKey:@"comment"];
        cell.txtTime.text = [[arrComment objectAtIndex:(indexPath.row - 1)] objectForKey:@"timecomment"];
        
        
        UILongPressGestureRecognizer *longPressCell = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCellAction)];
        [cell addGestureRecognizer:longPressCell];
        
        return cell;
    }
}

-(void)longPressCellAction{
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"แก้ไขคอมเม้นต์" message:nil preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction* edit = [UIAlertAction actionWithTitle:@"แก้ไข" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    [myAlertController addAction: edit];
    UIAlertAction* del = [UIAlertAction actionWithTitle:@"ลบ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    [myAlertController addAction: del];
    UIAlertAction* cancle = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    [myAlertController addAction: cancle];
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:myAlertController animated:YES completion:nil];
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        if ([urlImg1 isEqualToString:@"no"]) {
            return 168;
        }else if ([urlImg2 isEqualToString:@"no"]){
            return 400;
        }else{
            return 291;
        }
    }else{
        return 70;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)gotoCommentPost:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CommentPostViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"commentPost"];
    viewController.newsId = newsId;
    viewController.userId = userId;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - social.
-(BOOL)ChkFacebookLoginStatus{
    if ([FBSDKAccessToken currentAccessToken]) {
        return TRUE;
    }else{
        LoginFacebook *LoginFacebookView = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInF"];
        [self presentViewController:LoginFacebookView animated:YES completion:nil];
        return FALSE;
    }
}

-(void)shareToFacebook:(NSString *)urlToShare{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:urlToShare];
    content.placeID = [NSString stringWithFormat:@"%@",[[FBSDKAccessToken currentAccessToken] userID]];
    [FBSDKShareDialog showFromViewController:self withContent:content delegate:nil];
}

-(void)commentTo:(NSIndexPath *)indexPath{
    NSLog(@"bt comment");
}

#pragma mark - edit social
-(void)editPost:(NSString *)idUserPost indexpath:(NSIndexPath *)indexPath{
    if ([userPostId isEqualToString:userId]) {
        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"จัดการโพส" message:nil preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* edit = [UIAlertAction actionWithTitle:@"แก้ไขโพสต์" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                               {
                                   [self updatePost:idUserPost indexpath:indexPath];
                               }];
        [myAlertController addAction: edit];
        UIAlertAction* del = [UIAlertAction actionWithTitle:@"ลบโพสต์" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  UIAlertController *alertDelete = [UIAlertController alertControllerWithTitle:@"ลบโพสต์" message:@"ยืนยันการลบโพสต์ ?" preferredStyle:UIAlertControllerStyleAlert];
                                  UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"ลบ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                                            {
                                                                [self deletePost:idUserPost objId:strObj];
                                                            }];
                                  UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                                           {
                                                               
                                                           }];
                                  [alertDelete addAction:confirm];
                                  [alertDelete addAction:cancle];
                                  dispatch_async(dispatch_get_main_queue(), ^ {
                                      [self presentViewController:alertDelete animated:YES completion:nil];
                                  });
                              }];
        [myAlertController addAction: del];
        UIAlertAction* report = [UIAlertAction actionWithTitle:@"รายงานปัญหา" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     [self reportPost:idUserPost indexpath:indexPath];
                                 }];
        [myAlertController addAction: report];
        UIAlertAction* cancle = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     NSLog(@"ยกเลิก");
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        [myAlertController addAction: cancle];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:myAlertController animated:YES completion:nil];
        });
    }else{
        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"จัดการโพส" message:nil preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* report = [UIAlertAction actionWithTitle:@"รายงานปัญหา" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     [self reportPost:idUserPost indexpath:indexPath];
                                 }];
        [myAlertController addAction: report];
        UIAlertAction* cancle = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     NSLog(@"ยกเลิก");
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        [myAlertController addAction: cancle];
        
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:myAlertController animated:YES completion:nil];
        });
    }
}

-(void)userPost:(NSString *)idUserPost{
    NSString *strUrl = [NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/evytinkprofile.aspx?evarid=%@",idUserPost];
    ViewWeb *sendWebView = [self.storyboard instantiateViewControllerWithIdentifier:@"openWebView"];
    sendWebView.url = [NSURL URLWithString:strUrl];
    [self presentViewController:sendWebView animated:YES completion:NULL];
}

-(void)deletePost:(NSString *)userObjId objId:(NSString *)objectId{
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"ยืนยันการลบโพสต์" message:nil preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction* report = [UIAlertAction actionWithTitle:@"ยืนยัน" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 
                                 
                                 AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
                                 NSLog(@"user ID - %@, objectId - %@",userObjId,objectId);
                                 NSDictionary *jsonParameter = @{@"evarid":userObjId,@"evarnewsid":objectId,@"evarcommand":@"deletenews",@"evarnewscontent":@""};
                                 
                                 [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonnewsedit.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
                                 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     NSLog(@"Success POST Delete");
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     [self.navigationController popViewControllerAnimated:YES];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"Not success POST delete - %@",error);
                                 }];
                                 
                             }];
    [myAlertController addAction: report];
    UIAlertAction* cancle = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    [myAlertController addAction: cancle];
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:myAlertController animated:YES completion:nil];
    });
}

-(void)updatePost:(NSString *)userObjId indexpath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    P5ProfilePostViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"storyPostProfile"];
    viewController.evyId = userObjId;
    viewController.statusToServer = @"updatenews";
    viewController.statusShared = statusShared;
    viewController.objId = strObj;
    viewController.strUpdate = txtDetail;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)reportPost:(NSString *)userObjId indexpath:(NSIndexPath *)indexPath{
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"รายงานปัญหาโพสต์" message:@"ทำไมคุณถึงต้องรายงาน ?" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"รายงานนี้ไม่เหมาะสม สำหรับ EVYtink" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  [self reportList:userObjId detailOfReport:@"1" indexpath:indexPath];
                              }];
    UIAlertAction* action2 = [UIAlertAction actionWithTitle:@"เป็นแสปม การหลอกลวงหรือบัญชีปลอม" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  [self reportList:userObjId detailOfReport:@"2" indexpath:indexPath];
                              }];
    UIAlertAction* action3 = [UIAlertAction actionWithTitle:@"บัญผู้ใช้อาจโดนแฮก" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  [self reportList:userObjId detailOfReport:@"3" indexpath:indexPath];
                              }];
    UIAlertAction* action4 = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  
                              }];
    [myAlertController addAction: action1];
    [myAlertController addAction: action2];
    [myAlertController addAction: action3];
    [myAlertController addAction: action4];
    
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:myAlertController animated:YES completion:nil];
    });
}
-(void)reportList:(NSString *)userObjId detailOfReport:(NSString *)detail indexpath:(NSIndexPath *)indexPath{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatToDate = [[NSDateFormatter alloc] init];
    [formatToDate setDateFormat:@"d/M/yyyy"];
    NSString *sendDate = [formatToDate stringFromDate:currentDate];
    if ([detail isEqualToString:@"1"]) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSDictionary *jsonParameter = @{@"evyaccountid":userObjId,@"postid":[[arrComment objectAtIndex:indexPath.row] objectForKey:@"newsevyid"],@"reportdetail":@"รายงานนี้ไม่เหมาะสม สำหรับ EVYtink",@"posttype":@"news",@"adddatetime":sendDate,@"command":@"savereport"};
        
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonevyreport.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success POST Report");
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST Report - %@",error);
        }];
    }else if ([detail isEqualToString:@"2"]){
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSDictionary *jsonParameter = @{@"evyaccountid":userObjId,@"postid":[[arrComment objectAtIndex:indexPath.row] objectForKey:@"newsevyid"],@"reportdetail":@"เป็นแสปม การหลอกลวงหรือบัญชีปลอม",@"posttype":@"news",@"adddatetime":sendDate,@"command":@"savereport"};
        
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonevyreport.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success POST Report");
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST Report - %@",error);
        }];
    }else if ([detail isEqualToString:@"3"]){
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSDictionary *jsonParameter = @{@"evyaccountid":userObjId,@"postid":[[arrComment objectAtIndex:indexPath.row] objectForKey:@"newsevyid"],@"reportdetail":@"บัญผู้ใช้อาจโดนแฮก",@"posttype":@"news",@"adddatetime":sendDate,@"command":@"savereport"};
        
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonevyreport.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success POST Report");
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST Report - %@",error);
        }];
    }
}


@end
