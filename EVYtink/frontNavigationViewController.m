//
//  frontNavigationViewController.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 6/30/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "frontNavigationViewController.h"
#import "SlideOutMenuFiles/SWRevealViewController.h"

@interface frontNavigationViewController ()

@end

@implementation frontNavigationViewController
@synthesize barButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    barButton.target = self.revealViewController;
    barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
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
