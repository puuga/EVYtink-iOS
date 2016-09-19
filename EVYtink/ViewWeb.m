//
//  ViewWeb.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 5/26/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "ViewWeb.h"

@interface ViewWeb ()

@end

@implementation ViewWeb
@synthesize webV,url,StatusBarColourStat;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webV loadRequest:requestObj];
    if ([StatusBarColourStat isEqualToString:@"ebook"]) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:117.0f/255.0f green:60.0f/255.0f blue:17.0f/255.0f alpha:1.0f]];
        self.navigationController.navigationBar.translucent = NO;
        self.view.backgroundColor = [UIColor colorWithRed:117.0f/255.0f green:60.0f/255.0f blue:17.0f/255.0f alpha:1.0f];
    }else{
        self.view.backgroundColor = [UIColor colorWithRed:225.0f/255.0f green:27.0f/255.0f blue:40.0f/255.0f alpha:1.0f];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btClose:(id)sender {
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:225.0f/255.0f green:27.0f/255.0f blue:40.0f/255.0f alpha:1.0f]];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
