//
//  GEOFencing.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 5/20/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "GEOFencing.h"

@implementation GEOFencing
@synthesize locationManager,im;
-(void)viewDidLoad{
    NSString *dataUrl = @"http://koratstartup.com/wp-content/uploads/2016/04/NjpUs24nCQKx5e1EaLRzVmhEaudlUAKrWs0nDIVOAVQ.jpg";
    NSURL *url = [NSURL URLWithString:dataUrl];
    NSData *dat = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *ime = [[UIImage alloc] initWithData:dat];
    NSLog(@"show data - %@, %@",dat,ime);
    im.image = ime;
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }else{
        [self setupGeoFence];
    }
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            [self showSorryAlert];
            return;
    }
    NSLog(@"%@", [locations lastObject]);
}

-(void)showSorryAlert{
    NSLog(@"SORRY");
}

- (IBAction)get:(id)sender {
    NSLog(@"push");
    
}

-(void)setupGeoFence{
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(42.280597, -83.751891);
    CLRegion *bridge = [[CLCircularRegion alloc]initWithCenter:center radius:100.0 identifier:@"Bridge"];
    [locationManager startMonitoringForRegion:bridge];
}


/*
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        NSLog(@"LAT : %.8f ,LONG : %.8f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    }
}
*/
@end
