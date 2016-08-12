//
//  PGetLocationViewController.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 8/12/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "PGetLocationViewController.h"

@interface PGetLocationViewController (){
    double zoom;
}

@end

@implementation PGetLocationViewController
@synthesize MapV,BtgotoCurrentLocationProperties;

- (void)viewDidLoad {
    [super viewDidLoad];
    zoom = 0.1;
    [MapV setShowsUserLocation:YES];
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

- (IBAction)BTsaveLocationAction:(id)sender {
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(MapV.centerCoordinate.latitude, MapV.centerCoordinate.longitude);
    NSLog(@"lat - %.8f, long - %.8f",coord.latitude,coord.longitude);

}

- (IBAction)BtgotoCurrentLocationAction:(id)sender {
    if (zoom==0.1) {
        zoom = 0.02;
        NSLog(@"Zoom 1");
        CGRect buttonFrame = BtgotoCurrentLocationProperties.frame;
        buttonFrame.size = CGSizeMake(40, 40);
        BtgotoCurrentLocationProperties.frame = buttonFrame;
    }else{
        zoom = 0.1;
        CGRect buttonFrame = BtgotoCurrentLocationProperties.frame;
        buttonFrame.size = CGSizeMake(30, 30);
        BtgotoCurrentLocationProperties.frame = buttonFrame;
        NSLog(@"Zoom 2");
    }
    MKCoordinateRegion mapRegion;
    mapRegion.center = MapV.userLocation.coordinate;
    mapRegion.span.latitudeDelta = zoom;
    mapRegion.span.longitudeDelta = zoom;
    
    [MapV setRegion:mapRegion animated: YES];
}
@end
