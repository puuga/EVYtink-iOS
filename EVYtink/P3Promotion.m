//
//  P3Promotion.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 5/24/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "P3Promotion.h"
#import "ViewWeb.h"
#import "SWRevealViewController.h"
#import <UIImageView+AFNetworking.h>
#import <AFNetworking.h>
#import "LoginFacebook.h"
#import "PostToEventViewController.h"
#import <AFHTTPRequestOperationManager.h>
#import "AnotherProfileViewController.h"

@interface P3Promotion (){
    BOOL chkLogin;
    NSString *evyUId;
}

@end

@implementation P3Promotion

@synthesize arrPromotion,arrShowPromotion,postBtProperties;

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
    arrPromotion = [[NSMutableArray alloc] init];
    arrShowPromotion = [[NSMutableArray alloc] init];
    self.tableView.userInteractionEnabled = NO;
    [self setArrPromotion:arrPromotion];
    if ([arrPromotion count]<5) {
        [self startArrShowPromotion:arrPromotion startAt:0 endAt:([arrPromotion count]-1)];
    }else{
        [self startArrShowPromotion:arrPromotion startAt:0 endAt:4];
    }
}

-(void)reloadPromotionData{
    arrPromotion = [[NSMutableArray alloc] init];
    arrShowPromotion = [[NSMutableArray alloc] init];
    [self setArrPromotion:arrPromotion];
    if ([arrPromotion count]<5) {
        [self startArrShowPromotion:arrPromotion startAt:0 endAt:([arrPromotion count]-1)];
    }else{
        [self startArrShowPromotion:arrPromotion startAt:0 endAt:4];
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

-(void)startArrShowPromotion:(NSMutableArray *)arrS startAt:(int)start endAt:(int)end{
    for (int count = start; count <= end; count++) {
        [arrShowPromotion addObject:[arrPromotion objectAtIndex:count]];
        if ([[[arrShowPromotion objectAtIndex:count] objectForKey:@"imageurl"]isEqualToString:@"no"]){
            NSLog(@"Pic - ไม่มีรูป");
        }else if ([[[arrShowPromotion objectAtIndex:count] objectForKey:@"imageurl2"]isEqualToString:@"no"]){
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

-(void)setArrPromotion:(NSMutableArray *)arrP{
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://evbt.azurewebsites.net/docs/page/theme/betajsonpromotion.aspx"]];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    for (int i=0; i<[jsonObjects count]; i++) {
        [arrP addObject:[jsonObjects objectAtIndex:i]];
        [self.tableView reloadData];
    }
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
    
    return [arrShowPromotion count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"idenDefCell1";
    static NSString *CellIdentifier2 = @"idenDefCell2";
    static NSString *CellIdentifier3 = @"idenDefCell3";
    
    if ((indexPath.row == ([arrShowPromotion count])-1)&&([arrPromotion count]!=[arrShowPromotion count])) {
        if (([arrShowPromotion count] + 5) <= [arrPromotion count]) {
            [self startArrShowPromotion:arrPromotion startAt:(indexPath.row + 1) endAt:(indexPath.row + 5)];
            NSLog(@"บวกเพิ่ม 5");
        }else{
            [self startArrShowPromotion:arrPromotion startAt:(indexPath.row + 1) endAt:([arrPromotion count] - 1)];
            NSLog(@"บวกเพิ่ม %lu",[arrPromotion count]);
        }
    }
    
    NSLog(@"Cell - %@",[arrShowPromotion objectAtIndex:indexPath.row]);
    if ([[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"imageurl"]isEqualToString:@"no"]) {
        P1D1TableViewCell *cell = (P1D1TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        cell.delegate = self;
        if (![cell.txtDetail.text isEqualToString:[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];
            cell.indexAction = indexPath;
            cell.strObjId = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"eventevyid"];
            cell.txtName.text = [[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"promotitle"];
            cell.txtDate.text = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.urlToShow = [NSString stringWithFormat:@"%@",[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"url"]];
            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]]];
            cell.userPostId = [[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
        }
        return cell;
    }else if ([[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]isEqualToString:@"no"]){
        P1D2TableViewCell *cell = (P1D2TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        cell.delegate = self;
        if (![cell.txtDetail.text isEqualToString:[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];
            
            cell.indexAction = indexPath;
            cell.strObjId = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"eventevyid"];
            cell.txtName.text = [[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"promotitle"];
            cell.txtDate.text = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.urlToShow = [NSString stringWithFormat:@"%@",[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"url"]];
            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]]];
            [cell.imgPic1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"imageurl"]]]];
            cell.userPostId = [[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
        }
        return cell;
        
    }else{
        P1D3TableViewCell *cell = (P1D3TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        cell.delegate = self;
        if (![cell.txtDetail.text isEqualToString:[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];
            NSURL *urlUser = [NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]];
            
            cell.indexAction = indexPath;
            cell.strObjId = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"eventevyid"];
            cell.txtName.text = [[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"promotitle"];
            cell.txtDate.text = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.urlToShow = [NSString stringWithFormat:@"%@",[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"url"]];
            
            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]]];
            [cell.imgPic1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"imageurl"]]]];
            [cell.imgPic2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]]]];
            cell.userPostId = [[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
        }
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"imageurl"]isEqualToString:@"no"]) {
        return 148;
    }else if ([[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]isEqualToString:@"no"]){
        return 360;
    }else{
        return 251;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self ChkFacebookLoginStatusLoginPage]) {
        ViewWeb *sendWebView = [self.storyboard instantiateViewControllerWithIdentifier:@"openWebView"];
        
        sendWebView.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/evytinkpromoview.aspx/?evarid=%@&evaracid=%@",[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"eventevyid"],evyUId]];
        [self presentViewController:sendWebView animated:YES completion:NULL];
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
    addEvent.navigationItem.title = @"เพิ่ม Promotion";
    addEvent.statusPOST = @"promotion";
    [self.navigationController pushViewController:addEvent animated:YES];
}

-(void)userPost:(NSString *)idUserPost{
    NSString *urlString = [NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonencode.aspx?evarid=%@&evarpass=evy21m",idUserPost];
    NSString *urlStringEncode = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStringEncode]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];//Hide this not error but return object.
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"obj success - %@",responseObject);
        AnotherProfileViewController *profile = [self.storyboard instantiateViewControllerWithIdentifier:@"openProfileView"];
        profile.urlProfileshow = [NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonnewsbyid.aspx?evarid=%@",[[responseObject objectAtIndex:0] objectForKey:@"promotionid"]];
        profile.evyUId = [[responseObject objectAtIndex:0] objectForKey:@"promotionid"];
        UINavigationController *navigationcontroller = [[UINavigationController alloc] initWithRootViewController:profile];
        
        [self presentViewController:navigationcontroller animated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Not Success afnetworking. - %@",error);
    }];
    [operation start];
}


#pragma mark - button edit
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
                                  [self deletePost:idUserPost objId:[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"eventevyid"]];
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
                                 
                                 [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betadeletepromo.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
                                 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     [self reloadPromotionData];
                                     NSLog(@"ลบ Promotion เสร็จสิ้น");
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
    addEvent.navigationItem.title = @"แก้ไข Promotion";
    addEvent.statusPOST = @"promotion";
    addEvent.upObjid = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"eventevyid"];
    addEvent.upTitle = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"title"];
    addEvent.upDetail = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"description"];
    addEvent.upPosition = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"location"];
    addEvent.upUrlImage = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"imageurl"];
    addEvent.upDateStart = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"istartdate"];
    addEvent.upTimeStart = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"timestart"];
    addEvent.upDateEnd = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"istopdate"];
    addEvent.upTimeEnd = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"timeend"];
    
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
        NSDictionary *jsonParameter = @{@"evyaccountid":userId,@"postid":[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"eventevyid"],@"reportdetail":@"รายงานนี้ไม่เหมาะสม สำหรับ EVYtink",@"posttype":@"Promotion",@"adddatetime":sendDate,@"command":@"savereport"};
        NSLog(@"Action 2");
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonevyreport.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success POST Report");
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST Report - %@",error);
        }];
    }else if ([detail isEqualToString:@"2"]){
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSDictionary *jsonParameter = @{@"evyaccountid":userId,@"postid":[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"eventevyid"],@"reportdetail":@"เป็นแสปม การหลอกลวงหรือบัญชีปลอม",@"posttype":@"Promotion",@"adddatetime":sendDate,@"command":@"savereport"};
        
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonevyreport.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success POST Report");
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST Report - %@",error);
        }];
    }else if ([detail isEqualToString:@"3"]){
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSDictionary *jsonParameter = @{@"evyaccountid":userId,@"postid":[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"eventevyid"],@"reportdetail":@"บัญผู้ใช้อาจโดนแฮก",@"posttype":@"Promotion",@"adddatetime":sendDate,@"command":@"savereport"};
        
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonevyreport.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success POST Report");
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST Report - %@",error);
        }];
    }
    
}

@end
