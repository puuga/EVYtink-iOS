//
//  PGetlocationTabbarViewController.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 8/31/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "PGetlocationTabbarViewController.h"

@interface PGetlocationTabbarViewController ()

@end

@implementation PGetlocationTabbarViewController
@synthesize currentLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Get location user show");
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    NSLog(@"start update location");
    self.tabBarController.delegate = self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"Did Update locations.");
    if (locations && [locations count]) {
        CLLocation *location = [locations objectAtIndex:0];
        NSLog(@"update location Lat - %.8f, Long - %.8f",location.coordinate.latitude,location.coordinate.longitude);
        currentLocation = location;
        [locationManager stopUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSLog(@"Selected index: %d", tabBarController.selectedIndex);
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
