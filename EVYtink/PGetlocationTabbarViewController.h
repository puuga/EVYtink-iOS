//
//  PGetlocationTabbarViewController.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 8/31/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PGetlocationTabbarViewController : UITabBarController<CLLocationManagerDelegate,UITabBarControllerDelegate,UITabBarDelegate>{
    CLLocationManager *locationManager;
}

@property (nonatomic,strong) CLLocation *currentLocation;

@end
