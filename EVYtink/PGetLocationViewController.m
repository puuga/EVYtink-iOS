//
//  PGetLocationViewController.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 8/12/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "PGetLocationViewController.h"
#import <AFNetworking.h>

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

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f",coord.latitude,coord.longitude]]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"เลือกพิกัดสถานที่" message: nil preferredStyle: UIAlertControllerStyleAlert];
        for (int i = 0; i<[[responseObject objectForKey:@"results"] count]; i++) {
            NSString *str = [[[responseObject objectForKey:@"results"] objectAtIndex:i] objectForKey:@"formatted_address"];
            UIAlertAction *alertChoice = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                     {
                                         NSString *strAddress = [[[responseObject objectForKey:@"results"] objectAtIndex:i] objectForKey:@"formatted_address"];
                                         UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"ยืนยันสถานที่" message: strAddress preferredStyle: UIAlertControllerStyleAlert];
                                             UIAlertAction *alertCancle = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                                                           {
                                                                               
                                                                           }];
                                             [myAlertController addAction:alertCancle];
                                         UIAlertAction *alertConfirm = [UIAlertAction actionWithTitle:@"ยืนยัน" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                                                       {
                                                                           [self.delegate setAddress:strAddress];
                                                                           [self.navigationController popViewControllerAnimated:YES];
                                                                       }];
                                         [myAlertController addAction:alertConfirm];

                                         dispatch_async(dispatch_get_main_queue(), ^ {
                                             [self presentViewController:myAlertController animated:YES completion:nil];
                                         });
                                         
                                         
                                     }];
            [myAlertController addAction:alertChoice];
        }
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:myAlertController animated:YES completion:nil];
        });
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Not Success afnetworking.,%@",error);
    }];
    [operation start];

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
