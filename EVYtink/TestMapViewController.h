//
//  TestMapViewController.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 6/17/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface TestMapViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapV;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *geofences;
- (IBAction)addGeo:(id)sender;

@end
