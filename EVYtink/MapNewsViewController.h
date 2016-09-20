//
//  MapNewsViewController.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 9/20/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapNewsViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapNews;

@end
