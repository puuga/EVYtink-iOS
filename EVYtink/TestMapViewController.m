//
//  TestMapViewController.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 6/17/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "TestMapViewController.h"
#define METERS_PER_MILE 1609.344
@interface TestMapViewController (){
    BOOL _didStartMonitoringRegion;
    int *countInside;
}

@end

@implementation TestMapViewController

@synthesize mapV,locationManager,geofences;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    countInside = 0;
    NSLog(@"Count - inside = %d",countInside);
    
    mapV = [[MKMapView alloc]init];
    mapV.showsUserLocation = YES;
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    geofences = [NSMutableArray arrayWithArray:[[locationManager monitoredRegions] allObjects]];
}

-(void)addGeo{
    //Create Coordinate and region.
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 13.841302;
    coordinate.longitude = 100.557236;
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:coordinate radius:200 identifier:@"Bank"];
    
    //Add and working Region.
    [locationManager startMonitoringForRegion:region];
    NSLog(@"location manager - %@",locationManager);
    [geofences addObject:region];
    NSLog(@"add GEO");
    //use method Update location.
    //[locationManager startUpdatingLocation];
}

/*
-(void)setUpGeofence{
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(13.841302, 100.557236);
    CLRegion *bridge = [[CLCircularRegion alloc]initWithCenter:center radius:100.0 identifier:@"Bank"];
    [self.locationManager startMonitoringForRegion:bridge];
}
 */
/*
- (void)addGeo:(id)sender {
    // Update Helper
    _didStartMonitoringRegion = NO;
    
    // Start Updating Location
    [self.locationManager startUpdatingLocation];
}
*/
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"Did Update locations.");
    if (locations && [locations count] && !_didStartMonitoringRegion) {
        // Update Helper
        _didStartMonitoringRegion = YES;
        
        // Fetch Current Location
        CLLocation *location = [locations objectAtIndex:0];
        
        // Initialize Region to Monitor
        //CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:[location coordinate] radius:250.0 identifier:[[NSUUID UUID] UUIDString]];
        /*
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = 13.841302;
        coordinate.longitude = 100.557236;
        CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:coordinate radius:200 identifier:@"Bank"];
        
        
        // Start Monitoring Region
        //[locationManager startMonitoringForRegion:region];
        //[locationManager stopMonitoringForRegion:region];
        [locationManager stopUpdatingLocation];
        */
        // Update Table View
        //[geofences addObject:region];

        NSLog(@"update location");
        
    }
}



- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    countInside += (int)1;
    /*if (countInside>12) {
        return;
    }*/
    NSLog(@"Entered Regoin : %@ - %@ ,count - %d",region.identifier,geofences,countInside);
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    /*defaults = [NSUserDefaults standardUserDefaults];*/
    UIUserNotificationType types = UIUserNotificationTypeBadge| UIUserNotificationTypeSound| UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];

    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = [NSString stringWithFormat:@"Entered : %@",region.identifier,geofences];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval= NSCalendarUnitDay;//NSCalendarUnitMinute; //Repeating instructions here.
    localNotification.soundName= UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Exit Regoin : %@ - %@",region.identifier,geofences);
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    
    //remove region, geofence.
    //[geofences removeObject:region];
    //[locationManager stopMonitoringForRegion:region];
    
    //disable method Update location.
    [locationManager stopUpdatingLocation];
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

- (IBAction)addGeo:(id)sender {
    [self addGeo];
}
@end
