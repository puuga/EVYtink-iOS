//
//  MapNewsViewController.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 9/20/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "MapNewsViewController.h"

@interface MapNewsViewController ()

@end

@implementation MapNewsViewController
@synthesize mapNews;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"ย้อนกลับ";
    
    [mapNews setShowsUserLocation:YES];
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
