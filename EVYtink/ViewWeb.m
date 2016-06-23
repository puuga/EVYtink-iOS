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
@synthesize webV,url;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webV loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
