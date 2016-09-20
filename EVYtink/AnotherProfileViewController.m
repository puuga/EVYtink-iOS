//
//  AnotherProfileViewController.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 8/9/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "AnotherProfileViewController.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import "LoginFacebook.h"
#import "FBSDKCoreKit.framework/Headers/FBSDKCoreKit.h"
#import "FBSDKLoginKit.framework/Headers/FBSDKLoginKit.h"
#import "FBSDKShareKit.framework/Headers/FBSDKShareKit.h"
#import "CommentViewController.h"


@interface AnotherProfileViewController (){
    NSMutableArray *arrProfileContent;
}

@end

@implementation AnotherProfileViewController
@synthesize urlProfileshow,imgUser,imgUserBg,labelUserName,tableView,evyUId,idForPost;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage* logoImage = [UIImage imageNamed:@"TopCenterlogoevytink.png"];
    UIImageView *uiimagelogoImage = [[UIImageView alloc] initWithImage:logoImage];
    uiimagelogoImage.frame = CGRectMake(75, 0, 100, 44);
    [uiimagelogoImage setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = uiimagelogoImage;
    
    imgUser.layer.cornerRadius = 50;
    imgUser.clipsToBounds = YES;
    imgUser.layer.borderWidth = 3.0f;
    imgUser.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    static NSString *CellIdentifier1 = @"idenCell1";
    static NSString *CellIdentifier2 = @"idenCell2";
    static NSString *CellIdentifier3 = @"idenCell3";
    static NSString *CellIdentifier4 = @"idenEditAnotherInformation";
    
    UINib *nib1 = [UINib nibWithNibName:@"CustomCell1" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:CellIdentifier1];
    
    UINib *nib2 = [UINib nibWithNibName:@"CustomCell2" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:CellIdentifier2];
    
    UINib *nib3 = [UINib nibWithNibName:@"CustomCell3" bundle:nil];
    [self.tableView registerNib:nib3 forCellReuseIdentifier:CellIdentifier3];
    
    UINib *nib4 = [UINib nibWithNibName:@"P5EditInformationAnotherTableViewCell" bundle:nil];
    [self.tableView registerNib:nib4 forCellReuseIdentifier:CellIdentifier4];
    
    [self.tableView reloadData];
    
    
    NSURLRequest *urlRequestAc = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonloadaccountprofile.aspx?evarid=%@",evyUId]]];
    AFHTTPRequestOperation *operationAc = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequestAc];
    operationAc.responseSerializer = [AFJSONResponseSerializer serializer];
    [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    [operationAc setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Loading.. Success - %@",evyUId);
        labelUserName.text = [NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:0] objectForKey:@"fname"]];
        [imgUser setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:0] objectForKey:@"imgprofile"]]]];
        [imgUserBg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[responseObject objectAtIndex:0] objectForKey:@"imgprofile"]]]];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
        effectView.frame = imgUserBg.frame;
        effectView.alpha = 0.95f;
        [imgUserBg addSubview:effectView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Not Success afnetworking.,%@",error);
    }];
    [operationAc start];
    
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlProfileshow]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        /*
        [imgUser setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[responseObject objectAtIndex:0] objectForKey:@"user"] objectForKey:@"imgprofile"]]]];
        [imgUserBg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[responseObject objectAtIndex:0] objectForKey:@"user"] objectForKey:@"imgprofile"]]]];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
        effectView.frame = imgUserBg.frame;
        effectView.alpha = 0.95f;
        [imgUserBg addSubview:effectView];
        
        
        labelUserName.text = [[[responseObject objectAtIndex:0] objectForKey:@"user"] objectForKey:@"publishtitle"];
        */
        /*for (int i = 0; i<[responseObject count]; i++) {
            NSLog(@"arrprofile No.%d - %@",i,[responseObject objectAtIndex:i]);
        }
        
        //NSLog(@"show count - %d",[responseObject count]);
        */
        if ([responseObject count]==0) {
            [tableView reloadData];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ยังไม่มีโพส" message:nil delegate:nil cancelButtonTitle:@"ยืนยัน" otherButtonTitles:nil, nil];
            [alert show];
        }
        arrProfileContent = [[NSMutableArray alloc] init];
        for (int i = 0; i<[responseObject count]; i++) {
            NSLog(@"arrprofile No.%d - %@",i,[responseObject objectAtIndex:i]);
            [arrProfileContent addObject:[responseObject objectAtIndex:i]];
            [self.tableView reloadData];
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

-(void)viewDidAppear:(BOOL)animated{
    if (idForPost==nil) {
        idForPost = [self getEvyId];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"SSS count - %ld",[arrProfileContent count]);
    return [arrProfileContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"SSS 3");
    static NSString *CellIdentifier1 = @"idenCell1";
    static NSString *CellIdentifier2 = @"idenCell2";
    static NSString *CellIdentifier3 = @"idenCell3";
    static NSString *CellIdentifier4 = @"idenEditAnotherInformation";
    
    if (indexPath.row==0) {
        P5EditInformationAnotherTableViewCell *cell = (P1CellCustom1 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier4];
        
        return cell;
    }
    
    if ([[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"imageurl"]isEqualToString:@"no"]) {
        P1CellCustom1 *cell = (P1CellCustom1 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        cell.delegate = self;
        if (![cell.txtDetail.text isEqualToString:[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];
            
            cell.indexAction = indexPath;
            cell.EvyUserId = evyUId;
            cell.strObjId = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"newsevyid"];
            cell.txtName.text = [[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"publishtitle"];
            cell.userPostId = [[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
            cell.txtDate.text = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.urlToShow = [NSString stringWithFormat:@"%@",[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"url"]];
            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]]];
        }
        return cell;
    }else if ([[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]isEqualToString:@"no"]){
        P1CellCustom2 *cell = (P1CellCustom2 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        cell.delegate = self;
        if (![cell.txtDetail.text isEqualToString:[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];
            
            cell.indexAction = indexPath;
            cell.EvyUserId = evyUId;
            cell.strObjId = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"newsevyid"];
            cell.txtName.text = [[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"publishtitle"];
            cell.userPostId = [[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
            cell.txtDate.text = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.urlToShow = [NSString stringWithFormat:@"%@",[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"url"]];
            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]]];
            [cell.imgPic1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"imageurl"]]]];
        }
        return cell;
    }else{
        P1CellCustom3 *cell = (P1CellCustom3 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        cell.delegate = self;
        if (![cell.txtDetail.text isEqualToString:[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];
            NSURL *urlUser = [NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]];
            
            cell.indexAction = indexPath;
            cell.EvyUserId = evyUId;
            cell.strObjId = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"newsevyid"];
            cell.txtName.text = [[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"publishtitle"];
            cell.userPostId = [[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
            cell.txtDate.text = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.urlToShow = [NSString stringWithFormat:@"%@",[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"url"]];
            
            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]]];
            [cell.imgPic1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"imageurl"]]]];
            [cell.imgPic2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]]]];
        }
        return cell;
    }
    
}

-(BOOL)ChkFacebookLoginStatus{
    if ([FBSDKAccessToken currentAccessToken]) {
        return TRUE;
    }else{
        LoginFacebook *LoginFacebookView = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInF"];
        [self presentViewController:LoginFacebookView animated:YES completion:nil];
        return FALSE;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        NSLog(@"rows height 100");
        return 100;
    }else if ([[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"imageurl"]isEqualToString:@"no"]) {
        return 168;
    }else if ([[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]isEqualToString:@"no"]){
        return 400;
    }else{
        return 291;
    }
}

-(void)shareToFacebook:(NSString *)urlToShare{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:urlToShare];
    content.placeID = [NSString stringWithFormat:@"%@",[[FBSDKAccessToken currentAccessToken] userID]];
    [FBSDKShareDialog showFromViewController:self withContent:content delegate:nil];
}

-(void)commentTo:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CommentViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"storyComment"];
    
    NSString *string = [NSString stringWithFormat:@"%@",[[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
    NSArray *subString = [string componentsSeparatedByString:@"?"];
    NSString *urlimg = subString[0];
    viewController.statusShared = @"private";
    viewController.userId = idForPost;
    viewController.newsId = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"newsevyid"];
    viewController.txtname = [[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"publishtitle"];
    viewController.userPostId = [[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
    viewController.txtDate = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
    viewController.txtDetail = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"title"];
    viewController.urlToShow = [NSString stringWithFormat:@"%@",[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"url"]];
    viewController.urlimgUser = [NSString stringWithFormat:@"%@?",urlimg];
    viewController.urlImg1 = [NSString stringWithFormat:@"%@",[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"imageurl"]];
    viewController.urlImg2 = [NSString stringWithFormat:@"%@",[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)userPost:(NSString *)idUserPost{

}

-(NSString *)getEvyId{
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/evycheckfbloginjson.aspx?evarfid=%@",[[FBSDKAccessToken currentAccessToken] userID]]]];
    NSLog(@"U ID - %@",[[FBSDKAccessToken currentAccessToken] userID]);
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"show event form facebook : %@",[[jsonObjects objectAtIndex:0] objectForKey:@"evyaccountid"]);
    
    return [NSString stringWithFormat:@"%@",[[jsonObjects objectAtIndex:0] objectForKey:@"evyaccountid"]];
}


- (IBAction)btClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
