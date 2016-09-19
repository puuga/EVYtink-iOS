//
//  PeditPersonalProfileViewController.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 9/5/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PeditPersonalProfileViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtWebsite;
@property (weak, nonatomic) IBOutlet UITextView *txtVAbout;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContent;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@property (nonatomic,strong) NSString *EName;
@property (nonatomic,strong) NSString *EWebsite;
@property (nonatomic,strong) NSString *EDescription;
@property (nonatomic,strong) NSString *EvyId;
@property (nonatomic,strong) NSString *EAddress;

@end
