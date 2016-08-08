//
//  LeftMenuTableViewController.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/9/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "LeftMenuTableViewController.h"
#import "SWRevealViewController.h"
#import "FBSDKLoginKit.framework/Headers/FBSDKLoginKit.h"
#import "FBSDKCoreKit.framework/Headers/FBSDKCoreKit.h"
#import "ViewWeb.h"

@interface LeftMenuTableViewController (){
    NSMutableArray *menu;
    NSMutableArray *tags;
    BOOL statusFirst;
}

@end

@implementation LeftMenuTableViewController

-(void)viewDidAppear:(BOOL)animated{
    [self loadDataTotableView];
    NSLog(@"appear");
}

-(void)loadDataTotableView{
    
    if ([FBSDKAccessToken currentAccessToken]) {
        NSData *dataUrl = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonhastag.aspx?evarid=%@",[self getEvyId]]]];
        NSLog(@"EVY ID : %@",[self getEvyId]);
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:dataUrl options:NSJSONReadingMutableContainers error:nil];
        tags = [[NSMutableArray alloc] init];
        for (int i = 0; i<[jsonObjects count]; i++) {
            [tags addObject:[[jsonObjects objectAtIndex:i] objectForKey:@"tag"]];
        }
        NSLog(@"json - count = %@",jsonObjects);
    }else{
        tags = [[NSMutableArray alloc] init];
    }
    menu = [[NSMutableArray alloc] init];
    [menu addObject:@"P1Main"];
    [menu addObject:@"P6GiftCard"];
    [menu addObject:@"P2Notification"];
    for (int i =0; i<[tags count]; i++) {
        [menu addObject:@"Cell"];
    }
    [menu addObject:@"P3Setting"];
    [menu addObject:@"P4FAQ"];
    [menu addObject:@"P5AboutUs"];
    [self.tableView reloadData];
    NSLog(@"reload data");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = [menu objectAtIndex:indexPath.row];
    if ([cellIdentifier isEqualToString:@"Cell"]) {
        return 40;
    }
    return 60;
}

-(NSString *)getEvyId{
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/evycheckfbloginjson.aspx?evarfid=%@",[[FBSDKAccessToken currentAccessToken] userID]]]];
    NSLog(@"U ID - %@",[[FBSDKAccessToken currentAccessToken] userID]);
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"show event form facebook : %@",[[jsonObjects objectAtIndex:0] objectForKey:@"evyaccountid"]);
    
    return [NSString stringWithFormat:@"%@",[[jsonObjects objectAtIndex:0] objectForKey:@"evyaccountid"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    statusFirst = YES;
    [self loadDataTotableView];
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
    return [menu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = [menu objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if ((statusFirst==YES)&&([cellIdentifier isEqualToString:@"P1Main"])) {
        cell.userInteractionEnabled = NO;
    }else{
        cell.userInteractionEnabled = YES;
    }
    if ([cellIdentifier isEqualToString:@"Cell"]) {
        int showtags = (int)indexPath.row - (int)3;
        cell.textLabel.text = [NSString stringWithFormat:@"#%@",[tags objectAtIndex:showtags]];
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    statusFirst = NO;
    [self.tableView reloadData];
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        ViewWeb *sendWebView = [self.storyboard instantiateViewControllerWithIdentifier:@"openWebView"];
        sendWebView.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/evytinkallcard.aspx?evarid=%@",[self getEvyId]]];
        [self presentViewController:sendWebView animated:YES completion:NULL];
    }else if (((indexPath.row>2)&&(indexPath.row<([menu count]-3)))) {
        int showtags = (int)indexPath.row - (int)3;
        ViewWeb *sendWebView = [self.storyboard instantiateViewControllerWithIdentifier:@"openWebView"];
        sendWebView.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/evynewtag.aspx?evar=%@",[tags objectAtIndex:showtags]]];
        [self presentViewController:sendWebView animated:YES completion:NULL];
    }
}

@end
