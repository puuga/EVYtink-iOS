//
//  PostToEventViewController.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/28/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "PostToEventSelectDateTimeViewController.h"
#import "PGetLocationViewController.h"

@interface PostToEventViewController : UIViewController<PostToEventSelectDateTimeViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIImagePickerController *pickerCamera;
    UIImagePickerController *pickerCameraRoll;
}

@property (nonatomic,strong) UIImage *imgAddToserver;
@property (nonatomic,strong) NSString *statusPOST;
@property (nonatomic,strong) NSString *objEVYid;
@property (weak, nonatomic) IBOutlet UIImageView *imgPreview;

- (IBAction)startDateTimeAction:(id)sender;
- (IBAction)endDateTimeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *startDateTimeProperties;
@property (weak, nonatomic) IBOutlet UIButton *endDateTimeProperties;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtTag;
@property (nonatomic,strong) NSString *Adderss;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;

@property (nonnull,strong) NSString *upObjid;
@property (nonnull,strong) NSString *upUserId;
@property (nonnull,strong) NSString *upTitle;
@property (nonnull,strong) NSString *upDetail;
@property (nonnull,strong) NSString *upPosition;
@property (nonnull,strong) NSString *upUrlImage;
@property (nonnull,strong) NSString *upDateStart;
@property (nonnull,strong) NSString *upTimeStart;
@property (nonnull,strong) NSString *upDateEnd;
@property (nonnull,strong) NSString *upTimeEnd;

- (IBAction)btSave:(id)sender;
- (IBAction)btGetPositionAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btGetPositionProperties;



@end
