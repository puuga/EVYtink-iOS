//
//  P1News.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 5/20/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "P1News.h"
#import "ViewWeb.h"
#import "FBSDKCoreKit.framework/Headers/FBSDKCoreKit.h"
#import "FBSDKLoginKit.framework/Headers/FBSDKLoginKit.h"
#import "FBSDKShareKit.framework/Headers/FBSDKShareKit.h"
#import "LoginFacebook.h"
#import "CommentViewController.h"
<<<<<<< HEAD
#import "SWRevealViewController.h"
#import <UIImageView+AFNetworking.h>
#import <AFNetworking.h>
#import "P5ProfilePostViewController.h"
=======
#import <UIImageView+AFNetworking.h>
#import "SlideOutMenuFiles/SWRevealViewController.h"

>>>>>>> origin/master

@interface P1News (){
    BOOL chkLogin;
    NSString *evyUId;
}

@end

@implementation P1News
@synthesize arrNews,arrShowNews,leftButton;


-(void)setNavigationTitle{
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:self action:@selector(revealToggle:)];
    anotherButton.image = [[UIImage imageNamed:@"LeftMenuevylogo.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    anotherButton.target = self.revealViewController;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.navigationItem.leftBarButtonItem = anotherButton;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"    " style:UIBarButtonItemStyleDone target:nil action:nil];
    UIImage* logoImage = [UIImage imageNamed:@"TopCenterlogoevytink.png"];
    UIImageView *uiimagelogoImage = [[UIImageView alloc] initWithImage:logoImage];
    uiimagelogoImage.frame = CGRectMake(75, 0, 100, 44);
    [uiimagelogoImage setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = uiimagelogoImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
<<<<<<< HEAD
    if ([self chkFacebook]) {
        chkLogin = YES;
        evyUId = [self checkUserId];
    }else{
        chkLogin = NO;
    }
    [self setNavigationTitle];
=======
    leftButton.target = self.revealViewController;
    leftButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    UIImage* logoImage = [UIImage imageNamed:@"TopCenterlogoevytink.png"];
    UIImageView *uiimagelogoImage = [[UIImageView alloc] initWithImage:logoImage];
    uiimagelogoImage.frame = CGRectMake(75, 0, 100, 44);
    [uiimagelogoImage setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = uiimagelogoImage;
    
    //self.tabBarController.tabBarItem.image = [UIImage imageNamed:@"icon_facebook.png"];
    [[self.tabBarController.tabBar.items objectAtIndex:0] setImage:[[UIImage imageNamed:@"TabNewsicon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setImage:[[UIImage imageNamed:@"TabEventicon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[self.tabBarController.tabBar.items objectAtIndex:2] setImage:[[UIImage imageNamed:@"TabPromoicon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[self.tabBarController.tabBar.items objectAtIndex:3] setImage:[[UIImage imageNamed:@"TabFavicon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[self.tabBarController.tabBar.items objectAtIndex:4] setImage:[[UIImage imageNamed:@"TabMoreManu.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    [self.tabBarController.tabBar.items objectAtIndex:0].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [self.tabBarController.tabBar.items objectAtIndex:1].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [self.tabBarController.tabBar.items objectAtIndex:2].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [self.tabBarController.tabBar.items objectAtIndex:3].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [self.tabBarController.tabBar.items objectAtIndex:4].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
>>>>>>> origin/master
    
    static NSString *CellIdentifier1 = @"idenCell1";
    static NSString *CellIdentifier2 = @"idenCell2";
    static NSString *CellIdentifier3 = @"idenCell3";
    
    UINib *nib1 = [UINib nibWithNibName:@"CustomCell1" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:CellIdentifier1];
    
    UINib *nib2 = [UINib nibWithNibName:@"CustomCell2" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:CellIdentifier2];
    
    UINib *nib3 = [UINib nibWithNibName:@"CustomCell3" bundle:nil];
    [self.tableView registerNib:nib3 forCellReuseIdentifier:CellIdentifier3];

    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [self reloadData];
}

-(void)reloadData{
    arrNews = [[NSMutableArray alloc] init];
    arrShowNews = [[NSMutableArray alloc] init];
    [self setArrNews:arrNews];
}

-(void)startArrShowNews:(NSMutableArray *)arrS startAt:(int)start endAt:(int)end{
    for (int count = start; count <= end; count++) {
        [arrShowNews addObject:[arrNews objectAtIndex:count]];
        if ([[[arrShowNews objectAtIndex:count] objectForKey:@"imageurl"]isEqualToString:@"no"]){
            NSLog(@"Pic - ไม่มีรูป");
        }else if ([[[arrShowNews objectAtIndex:count] objectForKey:@"imageurl2"]isEqualToString:@"no"]){
            NSLog(@"%d Pic - มีรูปที่ 1",count);
        }else{
            NSLog(@"Pic - มีรูป 2 รูป");
        }
    }
    [self.tableView reloadData];
}

-(UIImage *)loadImageFormUrl:(NSString *)strURL{
    //NSString *dataUrl = @"http://koratstartup.com/wp-content/uploads/2016/04/NjpUs24nCQKx5e1EaLRzVmhEaudlUAKrWs0nDIVOAVQ.jpg";
    NSURL *url = [NSURL URLWithString:strURL];
    UIImage *imgReturn;
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        UIImage *imgChange = [UIImage imageWithData:data];
        float oldWidth = imgChange.size.width;
        float scaleFactor = self.view.frame.size.width / oldWidth;
        float newHeight = imgChange.size.height * scaleFactor;
        float newWidth = oldWidth * scaleFactor;
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
        [imgChange drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSLog(@"newImage : %@",newImage);
    }];
    [downloadTask resume];
    return imgReturn;
}

-(void)setArrNews:(NSMutableArray *)arrNews{
<<<<<<< HEAD
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://evbt.azurewebsites.net/docs/page/theme/betajsonnews.aspx"]]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success afnetworking.");
        for (int i = 0; i<[responseObject count]; i++) {
            [arrNews addObject:[responseObject objectAtIndex:i]];
            NSLog(@"Arr - %d, %@",i,[arrNews objectAtIndex:i]);
            if (i==([responseObject count]-1)) {
                if ([arrNews count]<5) {
                    [self startArrShowNews:arrNews startAt:0 endAt:([arrNews count] - 1)];
                }else{
                    [self startArrShowNews:arrNews startAt:0 endAt:4];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Not Success afnetworking.");
    }];
    [operation start];
=======
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://evbt.azurewebsites.net/docs/page/theme/betajsonnews.aspx"]];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"JSON DATA - %@,\nJSON OBJECT - %@",jsonData,jsonObjects);
    NSLog(@"COunt json - %@",jsonObjects);
     for (int i=0; i<[jsonObjects count]; i++) {
        [arrNews addObject:[jsonObjects objectAtIndex:i]];
         NSLog(@"รอบที่ - %d",i);
     }
>>>>>>> origin/master
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
    NSLog(@"COUNTTTTT - %lu",[arrShowNews count]);
    return [arrShowNews count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"idenCell1";
    static NSString *CellIdentifier2 = @"idenCell2";
    static NSString *CellIdentifier3 = @"idenCell3";
    
    if ((indexPath.row == ([arrShowNews count])-1)&&([arrNews count]!=[arrShowNews count])) {
        if (([arrShowNews count] + 5) <= [arrNews count]) {
            [self startArrShowNews:arrNews startAt:(indexPath.row + 1) endAt:(indexPath.row + 5)];
            NSLog(@"บวกเพิ่ม 5");
        }else{
            [self startArrShowNews:arrNews startAt:(indexPath.row + 1) endAt:([arrNews count] - 1)];
            NSLog(@"บวกเพิ่ม %lu",[arrNews count]);
        }
    }
    
    if ([[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"imageurl"]isEqualToString:@"no"]) {
        P1CellCustom1 *cell = (P1CellCustom1 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        cell.delegate = self;
        if (![cell.txtDetail.text isEqualToString:[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];
<<<<<<< HEAD
=======
            NSURL *urlUser = [NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]];
            NSData *datUrlUser = [[NSData alloc] initWithContentsOfURL:urlUser];
            
            NSURLRequest *requestImageUser = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
            [cell.img setImageWithURLRequest:requestImageUser placeholderImage:NULL success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull imageShowHere) {
                cell.img.image = imageShowHere;
                
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                NSLog(@"Errorrrrrrrr");
            }];
            
>>>>>>> origin/master
            
            cell.indexAction = indexPath;
            NSLog(@"strObjId - %@",[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"newsevyid"]);
            cell.strObjId = [[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"newsevyid"];
            cell.EvyUserId = evyUId;
            cell.txtName.text = [[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"publishtitle"];
            cell.txtDate.text = [[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.urlToShow = [NSString stringWithFormat:@"%@",[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"url"]];
            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]]];
            cell.userPostId = [[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
        }
        return cell;
    }else if ([[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]isEqualToString:@"no"]){
        P1CellCustom2 *cell = (P1CellCustom2 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        cell.delegate = self;
        if (![cell.txtDetail.text isEqualToString:[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];
<<<<<<< HEAD
            
=======
            NSURL *urlUser = [NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]];
            NSData *datUrlUser = [[NSData alloc] initWithContentsOfURL:urlUser];
            
            NSURLRequest *requestImageUser = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
            [cell.img setImageWithURLRequest:requestImageUser placeholderImage:NULL success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull imageShowHere) {
                cell.img.image = imageShowHere;
                
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                NSLog(@"Errorrrrrrrr");
            }];
            
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrNews objectAtIndex:indexPath.row] objectForKey:@"imageurl"]]];
            NSURLRequest *urlrequest = [NSURLRequest requestWithURL:url];
            [cell.imgPic1 setImageWithURLRequest:urlrequest placeholderImage:NULL success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull imageShowHere) {
                cell.imgPic1.image = imageShowHere;
                
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                NSLog(@"Errorrrrrrrr");
            }];
            
>>>>>>> origin/master
            cell.indexAction = indexPath;
            cell.strObjId = [[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"newsevyid"];
            cell.EvyUserId = evyUId;
            cell.txtName.text = [[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"publishtitle"];
            cell.txtDate.text = [[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.urlToShow = [NSString stringWithFormat:@"%@",[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"url"]];
            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]]];
            [cell.imgPic1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"imageurl"]]]];
            cell.userPostId = [[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
        }
        return cell;
        
    }else{
        P1CellCustom3 *cell = (P1CellCustom3 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        cell.delegate = self;
        if (![cell.txtDetail.text isEqualToString:[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];
            NSURL *urlUser = [NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]];
<<<<<<< HEAD
            
            cell.indexAction = indexPath;
            cell.strObjId = [[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"newsevyid"];
            cell.EvyUserId = evyUId;
=======
            NSData *datUrlUser = [[NSData alloc] initWithContentsOfURL:urlUser];
            
            NSURLRequest *requestImageUser = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
            [cell.img setImageWithURLRequest:requestImageUser placeholderImage:NULL success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull imageShowHere) {
                cell.img.image = imageShowHere;
                
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                NSLog(@"Errorrrrrrrr");
            }];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrNews objectAtIndex:indexPath.row] objectForKey:@"imageurl"]]];
            NSURLRequest *urlrequest = [NSURLRequest requestWithURL:url];
            
            [cell.imgPic1 setImageWithURLRequest:urlrequest placeholderImage:NULL success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull imageShowHere) {
                cell.imgPic1.image = imageShowHere;
                
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                NSLog(@"Errorrrrrrrr");
            }];
            
            NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrNews objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]]];
            NSURLRequest *urlrequest2 = [NSURLRequest requestWithURL:url2];
            
            [cell.imgPic2 setImageWithURLRequest:urlrequest2 placeholderImage:NULL success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull imageShowHere) {
                cell.imgPic2.image = imageShowHere;
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                NSLog(@"Errorrrrrrrr");
            }];
            
            
            
            cell.indexAction = indexPath;
            cell.strObjId = [[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"newsevyid"];
>>>>>>> origin/master
            cell.txtName.text = [[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"publishtitle"];
            cell.txtDate.text = [[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.urlToShow = [NSString stringWithFormat:@"%@",[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"url"]];
            
            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]]];
            [cell.imgPic1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"imageurl"]]]];
            [cell.imgPic2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]]]];
            cell.userPostId = [[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
        }
        return cell;
        
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"imageurl"]isEqualToString:@"no"]) {
        return 168;
    }else if ([[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]isEqualToString:@"no"]){
        return 400;
    }else{
        return 291;
    }
}

-(void)getImageFormUrlForCell:(NSString *)urlString forIndex:(NSIndexPath *)indexPath{
    NSString *dataUrl = @"http://koratstartup.com/wp-content/uploads/2016/04/NjpUs24nCQKx5e1EaLRzVmhEaudlUAKrWs0nDIVOAVQ.jpg";
    NSURL *url = [NSURL URLWithString:dataUrl];
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        UIImage *imgChange = [UIImage imageWithData:data];
        float oldWidth = imgChange.size.width;
        float scaleFactor = self.view.frame.size.width / oldWidth;
        float newHeight = imgChange.size.height * scaleFactor;
        float newWidth = oldWidth * scaleFactor;
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
        [imgChange drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //StickersCoordinate *sendUnlock = [arrStickerSore objectAtIndex:indexPath.row];
    NSLog(@"URL - %@",[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"url"]);
    NSString *str = [NSString stringWithFormat:@"%@",[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"url"]];
    NSLog(@"count - %d",[str length]);
    if ([str length] != 4000) {
        ViewWeb *sendWebView = [self.storyboard instantiateViewControllerWithIdentifier:@"openWebView"];
        sendWebView.url = [NSURL URLWithString:[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"url"]];
        [self presentViewController:sendWebView animated:YES completion:NULL];
    }else{
        NSLog(@"======= not have url");
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

-(void)testShowCell{
    NSLog(@"Show Cell");
}

-(BOOL)chkFacebook{
    if ([FBSDKAccessToken currentAccessToken]) {
        return TRUE;
    }else{
        return FALSE;
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

-(void)shareToFacebook:(NSString *)urlToShare{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:urlToShare];
    content.placeID = [NSString stringWithFormat:@"%@",[[FBSDKAccessToken currentAccessToken] userID]];
    [FBSDKShareDialog showFromViewController:self withContent:content delegate:nil];
}

-(void)logout{
    LoginFacebook *LoginFacebookView = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInF"];
    [self presentViewController:LoginFacebookView animated:YES completion:nil];
}

-(void)commentTo:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CommentViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"storyComment"];
    
    NSString *string = [NSString stringWithFormat:@"%@",[[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
    NSArray *subString = [string componentsSeparatedByString:@"?"];
    NSString *urlimg = subString[0];
    viewController.statusShared = @"public";
    viewController.userId = [self checkUserId];
    viewController.newsId = [[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"newsevyid"];
    viewController.txtname = [[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"publishtitle"];
    viewController.userPostId = [[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
    viewController.txtDate = [[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
    viewController.txtDetail = [[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"title"];
    viewController.urlToShow = [NSString stringWithFormat:@"%@",[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"url"]];
    viewController.urlimgUser = [NSString stringWithFormat:@"%@?",urlimg];
    viewController.urlImg1 = [NSString stringWithFormat:@"%@",[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"imageurl"]];
    viewController.urlImg2 = [NSString stringWithFormat:@"%@",[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(NSString *)checkUserId{
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://evbt.azurewebsites.net/docs/page/theme/evycheckfbloginjson.aspx?evarfid=%@",[[FBSDKAccessToken currentAccessToken] userID]]]];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return [[jsonObjects objectAtIndex:0] objectForKey:@"evyaccountid"];
}

-(void)userPost:(NSString *)idUserPost{
    NSString *strUrl = [NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/evytinkprofile.aspx?evarid=%@",idUserPost];
    ViewWeb *sendWebView = [self.storyboard instantiateViewControllerWithIdentifier:@"openWebView"];
    sendWebView.url = [NSURL URLWithString:strUrl];
    [self presentViewController:sendWebView animated:YES completion:NULL];
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
                                                                [self deletePost:idUserPost objId:[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"newsevyid"]];
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
                                     [self reloadData];
                                     //[self.navigationController popViewControllerAnimated:YES];
                                     //[self showUserLogin];
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
    viewController.statusShared = @"public";
    viewController.objId = [NSString stringWithFormat:@"%@",[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"newsevyid"]];
    viewController.strUpdate = [NSString stringWithFormat:@"%@",[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"title"]];
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
    [formatToDate setDateFormat:@"d/M/yyyy"];
    NSString *sendDate = [formatToDate stringFromDate:currentDate];
    if ([detail isEqualToString:@"1"]) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSDictionary *jsonParameter = @{@"evyaccountid":userId,@"postid":[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"newsevyid"],@"reportdetail":@"รายงานนี้ไม่เหมาะสม สำหรับ EVYtink",@"posttype":@"news",@"adddatetime":sendDate,@"command":@"savereport"};
        
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonevyreport.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success POST Report");
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST Report - %@",error);
        }];
    }else if ([detail isEqualToString:@"2"]){
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSDictionary *jsonParameter = @{@"evyaccountid":userId,@"postid":[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"newsevyid"],@"reportdetail":@"เป็นแสปม การหลอกลวงหรือบัญชีปลอม",@"posttype":@"news",@"adddatetime":sendDate,@"command":@"savereport"};
        
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonevyreport.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success POST Report");
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST Report - %@",error);
        }];
    }else if ([detail isEqualToString:@"3"]){
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSDictionary *jsonParameter = @{@"evyaccountid":userId,@"postid":[[arrShowNews objectAtIndex:indexPath.row] objectForKey:@"newsevyid"],@"reportdetail":@"บัญผู้ใช้อาจโดนแฮก",@"posttype":@"news",@"adddatetime":sendDate,@"command":@"savereport"};
        
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonevyreport.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success POST Report");
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST Report - %@",error);
        }];
    }
    
}
@end
