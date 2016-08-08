//
//  LMP5AboutUsViewController.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/9/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "LMP5AboutUsViewController.h"
#import "SWRevealViewController.h"

@interface LMP5AboutUsViewController ()

@end

@implementation LMP5AboutUsViewController

@synthesize WebV;

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

-(void)hideTabbar{
    [self.tabBarController.tabBar setTranslucent:YES];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle];
    [self hideTabbar];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/evytinkabout.aspx"]]];
    [WebV loadRequest:requestObj];
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
