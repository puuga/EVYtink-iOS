//
//  P4TimelineViewController.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/28/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "P4TimelineViewController.h"
#import "SWRevealViewController.h"
#import <UIImageView+AFNetworking.h>
#import <AFNetworking.h>
#import "ViewWeb.h"
#import "FBSDKCoreKit.framework/Headers/FBSDKCoreKit.h"
#import "FBSDKLoginKit.framework/Headers/FBSDKLoginKit.h"
#import "FBSDKShareKit.framework/Headers/FBSDKShareKit.h"
#import "LoginFacebook.h"
#import "CommentViewController.h"
#import "P5ProfilePostViewController.h"
#import <AFHTTPRequestOperationManager.h>
#import "AnotherProfileViewController.h"

@interface P4TimelineViewController (){
    BOOL chkLogin;
    NSString *evyUId;
}

@end

@implementation P4TimelineViewController
@synthesize loginBtProperties,imgVNotlogin,TableView,arrTimeline,postBtProperties;

-(void)setNavigationTitle{
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:self action:@selector(revealToggle:)];
    anotherButton.image = [[UIImage imageNamed:@"LeftMenuevylogo.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    anotherButton.target = self.revealViewController;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.navigationItem.leftBarButtonItem = anotherButton;
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"    " style:UIBarButtonItemStyleDone target:nil action:nil];
    UIImage* logoImage = [UIImage imageNamed:@"TopCenterlogoevytink.png"];
    UIImageView *uiimagelogoImage = [[UIImageView alloc] initWithImage:logoImage];
    uiimagelogoImage.frame = CGRectMake(75, 0, 100, 44);
    [uiimagelogoImage setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = uiimagelogoImage;
}

-(void)viewDidAppear:(BOOL)animated{
    if ([FBSDKAccessToken currentAccessToken]) {
        chkLogin = YES;
        evyUId = [self getEvyId];
        [self showUserLogin];
    }else{
        chkLogin = NO;
        [self viewnotlogin];
    }
}

-(void)viewnotlogin{
    TableView.hidden = YES;
    imgVNotlogin.hidden = NO;
    loginBtProperties.hidden = NO;
    postBtProperties.enabled = NO;
    [postBtProperties setTintColor:[UIColor clearColor]];
}

-(void)showUserLogin{
    TableView.hidden = NO;
    imgVNotlogin.hidden = YES;
    loginBtProperties.hidden = YES;
    postBtProperties.enabled = YES;
    [postBtProperties setTintColor:nil];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/betajsontimeline.aspx?evarid=%@",[self getEvyId]]]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"show count - %d",[responseObject count]);
        if ([responseObject count]==0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ยังไม่มีข้อมูลบน Timeline" message:@"กดไลค์ข้อมูล News เพื่อให้ปรากฎอยู่บน Timeline ของคุณ" delegate:nil cancelButtonTitle:@"ยืนยัน" otherButtonTitles:nil, nil];
            [alert show];
        }
        arrTimeline = [[NSMutableArray alloc] init];
        self.TableView.userInteractionEnabled = NO;
        for (int i = 0; i<[responseObject count]; i++) {
            NSLog(@"arrprofile No.%d - %@",i,[responseObject objectAtIndex:i]);
            [arrTimeline addObject:[responseObject objectAtIndex:i]];
            [TableView reloadData];
            if (i==([responseObject count] - 1)) {
                self.TableView.userInteractionEnabled = YES;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Not Success afnetworking.,%@",error);
    }];
    [operation start];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    static NSString *CellIdentifier1 = @"idenCell1";
    static NSString *CellIdentifier2 = @"idenCell2";
    static NSString *CellIdentifier3 = @"idenCell3";
    UINib *nib1 = [UINib nibWithNibName:@"CustomCell1" bundle:nil];
    [TableView registerNib:nib1 forCellReuseIdentifier:CellIdentifier1];
    
    UINib *nib2 = [UINib nibWithNibName:@"CustomCell2" bundle:nil];
    [TableView registerNib:nib2 forCellReuseIdentifier:CellIdentifier2];
    
    UINib *nib3 = [UINib nibWithNibName:@"CustomCell3" bundle:nil];
    [TableView registerNib:nib3 forCellReuseIdentifier:CellIdentifier3];
    [TableView reloadData];
    
    [self setNavigationTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getEvyId{
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/evycheckfbloginjson.aspx?evarfid=%@",[[FBSDKAccessToken currentAccessToken] userID]]]];
    NSLog(@"U ID - %@",[[FBSDKAccessToken currentAccessToken] userID]);
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"show event form facebook : %@",[[jsonObjects objectAtIndex:0] objectForKey:@"evyaccountid"]);
    
    return [NSString stringWithFormat:@"%@",[[jsonObjects objectAtIndex:0] objectForKey:@"evyaccountid"]];
}

#pragma mark - Social

-(void)shareToFacebook:(NSString *)urlToShare{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:urlToShare];
    content.placeID = [NSString stringWithFormat:@"%@",[[FBSDKAccessToken currentAccessToken] userID]];
    [FBSDKShareDialog showFromViewController:self withContent:content delegate:nil];
}
-(void)commentTo:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CommentViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"storyComment"];
    
    NSString *string = [NSString stringWithFormat:@"%@",[[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
    NSArray *subString = [string componentsSeparatedByString:@"?"];
    NSString *urlimg = subString[0];
    if ([[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"evyprivacy"] isEqualToString:@"1"]) {
        viewController.statusShared = @"public";
    }else{
        viewController.statusShared = @"private";
    }
    viewController.userId = evyUId;
    viewController.newsId = [[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"newsevyid"];
    viewController.txtname = [[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"publishtitle"];
    viewController.userPostId = [[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
    viewController.txtDate = [[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
    viewController.txtDetail = [[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"title"];
    viewController.urlToShow = [NSString stringWithFormat:@"%@",[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"url"]];
    viewController.urlimgUser = [NSString stringWithFormat:@"%@?",urlimg];
    viewController.urlImg1 = [NSString stringWithFormat:@"%@",[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"imageurl"]];
    viewController.urlImg2 = [NSString stringWithFormat:@"%@",[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(BOOL)ChkFacebookLoginStatus{
    if ([FBSDKAccessToken currentAccessToken]) {
        return TRUE;
    }else{
        //LoginFacebook *LoginFacebookView = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInF"];
        //[self presentViewController:LoginFacebookView animated:YES completion:nil];
        return FALSE;
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

#pragma mark - Open Web View

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //StickersCoordinate *sendUnlock = [arrStickerSore objectAtIndex:indexPath.row];
    NSLog(@"URL - %@",[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"url"]);
    NSString *str = [NSString stringWithFormat:@"%@",[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"url"]];
    NSLog(@"count - %ld",[str length]);
    if ([str length] != 4000) {
        ViewWeb *sendWebView = [self.storyboard instantiateViewControllerWithIdentifier:@"openWebView"];
        sendWebView.url = [NSURL URLWithString:[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"url"]];
        [self presentViewController:sendWebView animated:YES completion:NULL];
    }else{
        NSLog(@"======= not have url");
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrTimeline count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"idenCell1";
    static NSString *CellIdentifier2 = @"idenCell2";
    static NSString *CellIdentifier3 = @"idenCell3";
    if ([[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"imageurl"]isEqualToString:@"no"]) {
        P1CellCustom1 *cell = (P1CellCustom1 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        cell.delegate = self;
        if (![cell.txtDetail.text isEqualToString:[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];
            
            cell.indexAction = indexPath;
            cell.EvyUserId = evyUId;
            cell.strObjId = [[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"newsevyid"];
            cell.txtName.text = [[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"publishtitle"];
            cell.txtDate.text = [[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.urlToShow = [NSString stringWithFormat:@"%@",[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"url"]];
            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]]];
            cell.userPostId = [[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
        }
        return cell;
    }else if ([[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]isEqualToString:@"no"]){
        P1CellCustom2 *cell = (P1CellCustom2 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        cell.delegate = self;
        if (![cell.txtDetail.text isEqualToString:[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];
            
            cell.indexAction = indexPath;
            cell.EvyUserId = evyUId;
            cell.strObjId = [[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"newsevyid"];
            cell.txtName.text = [[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"publishtitle"];
            cell.txtDate.text = [[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.urlToShow = [NSString stringWithFormat:@"%@",[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"url"]];
            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]]];
            [cell.imgPic1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"imageurl"]]]];
            cell.userPostId = [[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
        }
        return cell;
    }else{
        P1CellCustom3 *cell = (P1CellCustom3 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        cell.delegate = self;
        if (![cell.txtDetail.text isEqualToString:[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];
            NSURL *urlUser = [NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]];
            
            cell.indexAction = indexPath;
            cell.EvyUserId = evyUId;
            cell.strObjId = [[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"newsevyid"];
            cell.txtName.text = [[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"publishtitle"];
            cell.txtDate.text = [[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.urlToShow = [NSString stringWithFormat:@"%@",[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"url"]];
            
            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]]];
            [cell.imgPic1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"imageurl"]]]];
            [cell.imgPic2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]]]];
            cell.userPostId = [[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
        }
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([arrTimeline count]==0) {
        return 100;
    }
    if ([[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"imageurl"]isEqualToString:@"no"]) {
        return 168;
    }else if ([[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]isEqualToString:@"no"]){
        return 400;
    }else{
        return 291;
    }
}

- (IBAction)loginBT:(id)sender {
    LoginFacebook *LoginFacebookView = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInF"];
    [self presentViewController:LoginFacebookView animated:YES completion:nil];
}

-(void)userPost:(NSString *)idUserPost{
    AnotherProfileViewController *profile = [self.storyboard instantiateViewControllerWithIdentifier:@"openProfileView"];
    profile.urlProfileshow = [NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonnewsbyid.aspx?evarid=%@",idUserPost];
    
    UINavigationController *navigationcontroller = [[UINavigationController alloc] initWithRootViewController:profile];
    
    [self presentViewController:navigationcontroller animated:YES completion:nil];
}

-(void)editPost:(NSString *)idUserPost indexpath:(NSIndexPath *)indexPath{
    if ([idUserPost isEqualToString:evyUId]) {
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
                                                                [self deletePost:idUserPost objId:[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"newsevyid"]];
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

-(void)deletePost:(NSString *)userId objId:(NSString *)objectId{
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"ยืนยันการลบโพสต์" message:nil preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction* report = [UIAlertAction actionWithTitle:@"ยืนยัน" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 
                                 
                                 AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
                                 NSLog(@"user ID - %@, objectId - %@",userId,objectId);
                                 NSDictionary *jsonParameter = @{@"evarid":userId,@"evarnewsid":objectId,@"evarcommand":@"deletenews",@"evarnewscontent":@""};
                                 
                                 [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonnewsedit.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
                                 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     NSLog(@"Success POST Delete");
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     [self.navigationController popViewControllerAnimated:YES];
                                     [self showUserLogin];
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

-(void)updatePost:(NSString *)userId indexpath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    P5ProfilePostViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"storyPostProfile"];
    viewController.evyId = userId;
    viewController.statusToServer = @"updatenews";
    if ([[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"evyprivacy"] isEqualToString:@"1"]) {
        viewController.statusShared = @"public";
    }else{
        viewController.statusShared = @"private";
    }
    
    viewController.objId = [NSString stringWithFormat:@"%@",[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"newsevyid"]];
    viewController.strUpdate = [NSString stringWithFormat:@"%@",[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"title"]];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)reportPost:(NSString *)userId indexpath:(NSIndexPath *)indexPath{
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"รายงานปัญหาโพสต์" message:@"ทำไมคุณถึงต้องรายงาน ?" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"รายงานนี้ไม่เหมาะสม สำหรับ EVYtink" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  [self reportList:userId detailOfReport:@"1" indexpath:indexPath];
                              }];
    UIAlertAction* action2 = [UIAlertAction actionWithTitle:@"เป็นแสปม การหลอกลวงหรือบัญชีปลอม" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  [self reportList:userId detailOfReport:@"2" indexpath:indexPath];
                              }];
    UIAlertAction* action3 = [UIAlertAction actionWithTitle:@"บัญผู้ใช้อาจโดนแฮก" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  [self reportList:userId detailOfReport:@"3" indexpath:indexPath];
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
-(void)reportList:(NSString *)userId detailOfReport:(NSString *)detail indexpath:(NSIndexPath *)indexPath{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatToDate = [[NSDateFormatter alloc] init];
    [formatToDate setDateFormat:@"M/dd/yyyy"];
    NSString *sendDate = [formatToDate stringFromDate:currentDate];
    if ([detail isEqualToString:@"1"]) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSDictionary *jsonParameter = @{@"evyaccountid":userId,@"postid":[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"newsevyid"],@"reportdetail":@"รายงานนี้ไม่เหมาะสม สำหรับ EVYtink",@"posttype":@"news",@"adddatetime":sendDate,@"command":@"savereport"};
        
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonevyreport.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success POST Report");
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST Report - %@",error);
        }];
    }else if ([detail isEqualToString:@"2"]){
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSDictionary *jsonParameter = @{@"evyaccountid":userId,@"postid":[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"newsevyid"],@"reportdetail":@"เป็นแสปม การหลอกลวงหรือบัญชีปลอม",@"posttype":@"news",@"adddatetime":sendDate,@"command":@"savereport"};
        
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonevyreport.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success POST Report");
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST Report - %@",error);
        }];
    }else if ([detail isEqualToString:@"3"]){
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSDictionary *jsonParameter = @{@"evyaccountid":userId,@"postid":[[arrTimeline objectAtIndex:indexPath.row] objectForKey:@"newsevyid"],@"reportdetail":@"บัญผู้ใช้อาจโดนแฮก",@"posttype":@"news",@"adddatetime":sendDate,@"command":@"savereport"};
        
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonevyreport.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success POST Report");
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST Report - %@",error);
        }];
    }
}
- (IBAction)postBtAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    P5ProfilePostViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"storyPostProfile"];
    viewController.evyId = [self getEvyId];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
