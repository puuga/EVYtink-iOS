//
//  P2Event.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 5/24/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "P2Event.h"
#import "ViewWeb.h"

#import "SWRevealViewController.h"
#import <UIImageView+AFNetworking.h>
#import <AFNetworking.h>
#import "LoginFacebook.h"
#import "PostToEventViewController.h"
#import <AFHTTPRequestOperationManager.h>
#import "AnotherProfileViewController.h"


@interface P2Event (){
    BOOL chkLogin;
    NSString *evyUId;
}

@end

@implementation P2Event
@synthesize arrEvent,arrShowEvent,postBtProperties;

-(void)setNavigationTitle{
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:self action:@selector(revealToggle:)];
    anotherButton.image = [[UIImage imageNamed:@"LeftMenuevylogo.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    anotherButton.target = self.revealViewController;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.navigationItem.leftBarButtonItem = anotherButton;


    UIImage* logoImage = [UIImage imageNamed:@"TopCenterlogoevytink.png"];
    UIImageView *uiimagelogoImage = [[UIImageView alloc] initWithImage:logoImage];
    uiimagelogoImage.frame = CGRectMake(75, 0, 100, 44);
    [uiimagelogoImage setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = uiimagelogoImage;
}

-(NSString *)checkUserId{
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://evbt.azurewebsites.net/docs/page/theme/evycheckfbloginjson.aspx?evarfid=%@",[[FBSDKAccessToken currentAccessToken] userID]]]];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return [[jsonObjects objectAtIndex:0] objectForKey:@"evyaccountid"];
}

-(void)notLogin{
    evyUId = nil;
    postBtProperties.enabled = NO;
    [postBtProperties setTintColor:[UIColor clearColor]];
}

-(void)Login{
    evyUId = [self checkUserId];
    postBtProperties.enabled = YES;
    [postBtProperties setTintColor:nil];
}

-(BOOL)ChkFacebookLoginStatus{
    if ([FBSDKAccessToken currentAccessToken]) {
        [self Login];
        return TRUE;
    }else{
        [self notLogin];
        return FALSE;
    }
}

-(BOOL)ChkFacebookLoginStatusLoginPage{
    if ([FBSDKAccessToken currentAccessToken]) {
        [self Login];
        return TRUE;
    }else{
        [self notLogin];
        LoginFacebook *LoginFacebookView = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInF"];
        [self presentViewController:LoginFacebookView animated:YES completion:nil];
        return FALSE;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [self ChkFacebookLoginStatus];
    arrEvent = [[NSMutableArray alloc] init];
    arrShowEvent = [[NSMutableArray alloc] init];
    self.tableView.userInteractionEnabled = YES;
    [self setArrEvent:arrEvent];


    if ([arrEvent count]<5) {
        [self startArrShowEvent:arrEvent startAt:0 endAt:([arrEvent count] - 1)];
    }else{
        [self startArrShowEvent:arrEvent startAt:0 endAt:4];
    }
}

-(void)reloadEventData{
    arrEvent = [[NSMutableArray alloc] init];
    arrShowEvent = [[NSMutableArray alloc] init];
    [self setArrEvent:arrEvent];

    if ([arrEvent count]<5) {
        [self startArrShowEvent:arrEvent startAt:0 endAt:([arrEvent count] - 1)];
    }else{
        [self startArrShowEvent:arrEvent startAt:0 endAt:4];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle];
    static NSString *CellIdentifier1 = @"idenDefCell1";
    static NSString *CellIdentifier2 = @"idenDefCell2";
    static NSString *CellIdentifier3 = @"idenDefCell3";
    UINib *nib = [UINib nibWithNibName:@"P1D1TableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier1];

    nib = [UINib nibWithNibName:@"P1D2TableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier2];

    nib = [UINib nibWithNibName:@"P1D3TableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier3];

    [self.tableView reloadData];
}

-(void)startArrShowEvent:(NSMutableArray *)arrS startAt:(int)start endAt:(int)end{
    for (int count = start; count <= end; count++) {
        [arrShowEvent addObject:[arrEvent objectAtIndex:count]];
        if ([[[arrShowEvent objectAtIndex:count] objectForKey:@"imageurl"]isEqualToString:@"no"]){
            NSLog(@"Pic - ไม่มีรูป");
        }else if ([[[arrShowEvent objectAtIndex:count] objectForKey:@"imageurl2"]isEqualToString:@"no"]){
            NSLog(@"%d Pic - มีรูปที่ 1",count);
        }else{
            NSLog(@"Pic - มีรูป 2 รูป");
        }
        if (count==end) {
            self.tableView.userInteractionEnabled = YES;
        }
    }
    [self.tableView reloadData];
}

-(void)setArrEvent:(NSMutableArray *)arrE{

    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://evbt.azurewebsites.net/docs/page/theme/betajsonevent.aspx"]];
    NSError *error;
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    for (int i=0; i<[jsonObjects count]; i++) {
        [arrE addObject:[jsonObjects objectAtIndex:i]];
        [self.tableView reloadData];
    }

    /*
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://evbt.azurewebsites.net/docs/page/theme/betajsonevent.aspx"]]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        for (int Cou = 0; Cou<[responseObject count]; Cou++) {
            [arrE addObject:[responseObject objectAtIndex:Cou]];
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Not Success afnetworking.,%@",error);
    }];
    [operation start];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"how row - %lu",[arrEvent count]);
    return [arrShowEvent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"idenDefCell1";
    static NSString *CellIdentifier2 = @"idenDefCell2";
    static NSString *CellIdentifier3 = @"idenDefCell3";

    if ((indexPath.row == ([arrShowEvent count])-1)&&([arrEvent count]!=[arrShowEvent count])) {
        if (([arrShowEvent count] + 5) <= [arrEvent count]) {
            [self startArrShowEvent:arrEvent startAt:(indexPath.row + 1) endAt:(indexPath.row + 5)];
            NSLog(@"บวกเพิ่ม 5");
        }else{
            [self startArrShowEvent:arrEvent startAt:(indexPath.row + 1) endAt:([arrEvent count] - 1)];
            NSLog(@"บวกเพิ่ม %lu",[arrEvent count]);
        }
    }

    NSLog(@"Cell - %@",[arrShowEvent objectAtIndex:indexPath.row]);
    NSLog(@"user post id - %@",[[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"]);
    if ([[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"imageurl"]isEqualToString:@"no"]) {
        P1D1TableViewCell *cell = (P1D1TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        cell.delegate = self;
        if (![cell.txtDetail.text isEqualToString:[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];
            cell.indexAction = indexPath;
            cell.strObjId = [[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"eventevyid"];
            cell.txtName.text = [[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"organizatitle"];
            cell.txtDate.text = [[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.urlToShow = [NSString stringWithFormat:@"%@",[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"url"]];
            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]]];
            cell.userPostId = [[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
        }
        return cell;
    }else if ([[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]isEqualToString:@"no"]){
        P1D2TableViewCell *cell = (P1D2TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        cell.delegate = self;
        if (![cell.txtDetail.text isEqualToString:[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];

            cell.indexAction = indexPath;
            cell.strObjId = [[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"eventevyid"];
            cell.txtName.text = [[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"organizatitle"];
            cell.txtDate.text = [[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.urlToShow = [NSString stringWithFormat:@"%@",[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"url"]];
            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]]];
            [cell.imgPic1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"imageurl"]]]];
            cell.userPostId = [[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
        }
        return cell;

    }else{
        P1D3TableViewCell *cell = (P1D3TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        cell.delegate = self;
        if (![cell.txtDetail.text isEqualToString:[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];
            NSURL *urlUser = [NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]];

            cell.indexAction = indexPath;
            cell.strObjId = [[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"eventevyid"];
            cell.txtName.text = [[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"organizatitle"];
            cell.txtDate.text = [[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.urlToShow = [NSString stringWithFormat:@"%@",[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"url"]];

            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]]];
            [cell.imgPic1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"imageurl"]]]];
            [cell.imgPic2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]]]];
            cell.userPostId = [[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[[arrEvent objectAtIndex:indexPath.row] objectForKey:@"imageurl"]isEqualToString:@"no"]) {
        return 148;
    }else if ([[[arrEvent objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]isEqualToString:@"no"]){
        return 360;
    }else{
        return 251;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self ChkFacebookLoginStatusLoginPage]) {
        ViewWeb *sendWebView = [self.storyboard instantiateViewControllerWithIdentifier:@"openWebView"];

        sendWebView.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/evytinkeventdetail.aspx/?evarid=%@&evaracid=%@",[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"eventevyid"],evyUId]];
        [self presentViewController:sendWebView animated:YES completion:NULL];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)postBtAction:(id)sender {
    PostToEventViewController *addEvent = [self.storyboard instantiateViewControllerWithIdentifier:@"addActivity"];
    addEvent.navigationItem.title = @"เพิ่ม Event";
    addEvent.statusPOST = @"event";
    [self.navigationController pushViewController:addEvent animated:YES];
}

-(void)userPost:(NSString *)idUserPost{
    AnotherProfileViewController *profile = [self.storyboard instantiateViewControllerWithIdentifier:@"openProfileView"];
    profile.urlProfileshow = [NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonnewsbyid.aspx?evarid=%@",idUserPost];
    
    UINavigationController *navigationcontroller = [[UINavigationController alloc] initWithRootViewController:profile];
    
    [self presentViewController:navigationcontroller animated:YES completion:nil];
}

#pragma mark - button edit
-(void)editPost:(NSString *)idUserPost indexpath:(NSIndexPath *)indexPath{
    NSLog(@"iduser post - %@, evyUID - %@",idUserPost,evyUId);
    if ([idUserPost isEqualToString:evyUId]) {
        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"จัดการโพส" message:nil preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* edit = [UIAlertAction actionWithTitle:@"แก้ไขโพสต์" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                               {
                                   [self updatePost:idUserPost indexpath:indexPath];
                               }];
        [myAlertController addAction: edit];
        UIAlertAction* del = [UIAlertAction actionWithTitle:@"ลบโพสต์" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  [self deletePost:idUserPost objId:[[arrEvent objectAtIndex:indexPath.row] objectForKey:@"eventevyid"]];
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
                                 NSDictionary *jsonParameter = @{@"Id":objectId,@"status":@"0"};

                                 [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsoneventdelete.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
                                 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     [self reloadEventData];
                                     NSLog(@"ลบ Event เสร็จ");
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
    PostToEventViewController *addEvent = [self.storyboard instantiateViewControllerWithIdentifier:@"addActivity"];
    addEvent.navigationItem.title = @"แก้ไข Event";
    addEvent.statusPOST = @"event";
    addEvent.upObjid = [[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"eventevyid"];
    addEvent.upTitle = [[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"title"];
    addEvent.upDetail = [[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"description"];
    addEvent.upPosition = [[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"location"];
    addEvent.upUrlImage = [[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"imageurl"];
    addEvent.upDateStart = [[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"startdate"];
    addEvent.upTimeStart = [[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"timestart"];
    addEvent.upDateEnd = [[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"stopdate"];
    addEvent.upTimeEnd = [[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"timeend"];

    [self.navigationController pushViewController:addEvent animated:YES];
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
    [formatToDate setDateFormat:@"d/M/yyyy"];
    NSString *sendDate = [formatToDate stringFromDate:currentDate];
    NSLog(@"Report date - %@",sendDate);
    if ([detail isEqualToString:@"1"]) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSDictionary *jsonParameter = @{@"evyaccountid":userId,@"postid":[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"eventevyid"],@"reportdetail":@"รายงานนี้ไม่เหมาะสม สำหรับ EVYtink",@"posttype":@"event",@"adddatetime":sendDate,@"command":@"savereport"};
        NSLog(@"Action 2");
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonevyreport.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success POST Report");

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST Report - %@",error);
        }];
    }else if ([detail isEqualToString:@"2"]){
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSDictionary *jsonParameter = @{@"evyaccountid":userId,@"postid":[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"eventevyid"],@"reportdetail":@"เป็นแสปม การหลอกลวงหรือบัญชีปลอม",@"posttype":@"event",@"adddatetime":sendDate,@"command":@"savereport"};

        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonevyreport.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success POST Report");


        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST Report - %@",error);
        }];
    }else if ([detail isEqualToString:@"3"]){
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSDictionary *jsonParameter = @{@"evyaccountid":userId,@"postid":[[arrShowEvent objectAtIndex:indexPath.row] objectForKey:@"eventevyid"],@"reportdetail":@"บัญผู้ใช้อาจโดนแฮก",@"posttype":@"event",@"adddatetime":sendDate,@"command":@"savereport"};

        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonevyreport.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success POST Report");


        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST Report - %@",error);
        }];
    }

}
@end
