//
//  LMP2NotificationViewController.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/9/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "LMP2NotificationViewController.h"
#import "FBSDKLoginKit.framework/Headers/FBSDKLoginKit.h"
#import "FBSDKCoreKit.framework/Headers/FBSDKCoreKit.h"
#import "SWRevealViewController.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import "LMP2NotiTableViewCell.h"
#import "ViewWeb.h"

@interface LMP2NotificationViewController ()

@end

@implementation LMP2NotificationViewController
@synthesize arrNoti,tableView;
-(void)setNavigationTitle{
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(revealToggle:)];
    anotherButton.image = [[UIImage imageNamed:@"LeftMenuevylogo.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    anotherButton.target = self.revealViewController;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.navigationItem.leftBarButtonItem = anotherButton;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:nil action:nil];
    UIImage* logoImage = [UIImage imageNamed:@"TopCenterlogoevytink.png"];
    UIImageView *uiimagelogoImage = [[UIImageView alloc] initWithImage:logoImage];
    uiimagelogoImage.frame = CGRectMake(75, 0, 100, 44);
    [uiimagelogoImage setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = uiimagelogoImage;
}

-(NSString *)getEvyId{
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/evycheckfbloginjson.aspx?evarfid=%@",[[FBSDKAccessToken currentAccessToken] userID]]]];
    NSLog(@"U ID - %@",[[FBSDKAccessToken currentAccessToken] userID]);
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"show event form facebook : %@",[[jsonObjects objectAtIndex:0] objectForKey:@"evyaccountid"]);
    
    return [NSString stringWithFormat:@"%@",[[jsonObjects objectAtIndex:0] objectForKey:@"evyaccountid"]];
}

-(void)hideTabbar{
    [self.tabBarController.tabBar setTranslucent:YES];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle];
    [self hideTabbar];
}

-(void)viewDidAppear:(BOOL)animated{
    arrNoti = [[NSMutableArray alloc] init];
    if ([FBSDKAccessToken currentAccessToken]) {
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonnotilist.aspx?evarid=%@",[self getEvyId]]]];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            for (int Cou = 0; Cou<[responseObject count]; Cou++) {
                [arrNoti addObject:[responseObject objectAtIndex:Cou]];
                NSLog(@"Show data Input - %@",[responseObject objectAtIndex:Cou]);
                [tableView reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not Success afnetworking.,%@",error);
        }];
        [operation start];

    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrNoti count];
}

- (UITableViewCell *)tableView:(UITableView *)tableV cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"cellShowNoti";
    LMP2NotiTableViewCell *cell = [tableV dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrNoti objectAtIndex:indexPath.row] objectForKey:@"image"]]]];
    cell.img.layer.cornerRadius = 30;
    cell.img.clipsToBounds = YES;
    cell.img.layer.borderWidth = 1.0f;
    cell.img.layer.borderColor = [UIColor grayColor].CGColor;
    cell.lbMessage.text = [[arrNoti objectAtIndex:indexPath.row] objectForKey:@"notimessage"];
    cell.lbDate.text = [[arrNoti objectAtIndex:indexPath.row] objectForKey:@"datetimeadd"];
    if ([[[arrNoti objectAtIndex:indexPath.row] objectForKey:@"readstatus"] isEqualToString:@"0"]) {
        [cell setBackgroundColor:[UIColor colorWithRed:250.0f/255.0f green:248.0f/255.0f blue:245.0f/255.0f alpha:1.0f]];
    }else{
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //StickersCoordinate *sendUnlock = [arrStickerSore objectAtIndex:indexPath.row];
    NSString *str = [NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/evynotiview.aspx?evarid=%@",[[arrNoti objectAtIndex:indexPath.row] objectForKey:@"notilistid"]];
        ViewWeb *sendWebView = [self.storyboard instantiateViewControllerWithIdentifier:@"openWebView"];
        sendWebView.url = [NSURL URLWithString:str];
        [self presentViewController:sendWebView animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
