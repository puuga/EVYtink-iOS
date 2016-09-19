//
//  PostToEventViewController.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/28/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "PostToEventViewController.h"
#import "FBSDKCoreKit.framework/Headers/FBSDKCoreKit.h"
#import "FBSDKLoginKit.framework/Headers/FBSDKLoginKit.h"
#import "FBSDKShareKit.framework/Headers/FBSDKShareKit.h"
#import <UIImageView+AFNetworking.h>
#import <AFNetworking.h>
#import <AFHTTPRequestOperationManager.h>

@interface PostToEventViewController (){
    NSString *startDate;
    NSString *startTime;
    NSString *endDate;
    NSString *endTime;
    NSString *EvyId;
    BOOL statusChooseImg;
}

@end

@implementation PostToEventViewController
@synthesize imgPreview,imgAddToserver,startDateTimeProperties,endDateTimeProperties,txtName,txtTag,statusPOST,scrollV,Adderss;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //
    [self addHideKeyboardGestureRecognizer];
    EvyId = [self getEvyId];
    statusChooseImg = NO;
    self.navigationController.navigationBar.topItem.title = @"ย้อนกลับ";
    if (_upObjid != nil) {
        txtName.text = _upTitle;
        txtTag.text = _upDetail;
        startDate = _upDateStart;
        startTime = _upTimeStart;
        endDate = _upDateEnd;
        endTime = _upTimeEnd;
        Adderss = _upPosition;
        [_btGetPositionProperties setTitle:_upPosition forState:UIControlStateNormal];
        [startDateTimeProperties setTitle:[NSString stringWithFormat:@"%@, %@",startDate,startTime] forState:UIControlStateNormal];
        [endDateTimeProperties setTitle:[NSString stringWithFormat:@"%@, %@",endDate,endTime] forState:UIControlStateNormal];
        [imgPreview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_upUrlImage]]];
        statusChooseImg = YES;
    }else{
        [self addPickerTapGestureRecognizer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get EVY Account ID

-(NSString *)getEvyId{
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/evycheckfbloginjson.aspx?evarfid=%@",[[FBSDKAccessToken currentAccessToken] userID]]]];
    NSLog(@"U ID - %@",[[FBSDKAccessToken currentAccessToken] userID]);
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"show event form facebook : %@",[[jsonObjects objectAtIndex:0] objectForKey:@"evyaccountid"]);
    
    return [NSString stringWithFormat:@"%@",[[jsonObjects objectAtIndex:0] objectForKey:@"evyaccountid"]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma setting Camera

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    imgAddToserver = info[UIImagePickerControllerEditedImage];
    picker.allowsEditing = YES;
    [imgPreview setImage:imgAddToserver];
    statusChooseImg = YES;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)chooseImageFromCameraRoll{
    NSLog(@"อัลบั้ม");
    pickerCameraRoll = [[UIImagePickerController alloc]init];
    pickerCameraRoll.delegate = self;
    [pickerCameraRoll setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    pickerCameraRoll.allowsEditing = YES;
    [self presentViewController:pickerCameraRoll animated:YES completion:NULL];
}

-(void)chooseImageFromCamera{
    NSLog(@"กล้องถ่ายรูป");
    pickerCamera = [[UIImagePickerController alloc]init];
    pickerCamera.delegate = self;
    [pickerCamera setSourceType:UIImagePickerControllerSourceTypeCamera];
    pickerCamera.allowsEditing = YES;
    [self presentViewController:pickerCamera animated:YES completion:NULL];
}

-(void)tapChooseImage{
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"เลือกรูปภาพ" message: @"เลือกแหล่งรูปภาพที่ต้องการใช้งาน" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"จากกล้องถ่ายรูป" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                             [self chooseImageFromCamera];
                             
                         }];
    UIAlertAction *cameraRoll = [UIAlertAction actionWithTitle:@"จากอัลบั้ม" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 [self chooseImageFromCameraRoll];
                                 
                             }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
    [myAlertController addAction:camera];
    [myAlertController addAction:cameraRoll];
    [myAlertController addAction:cancle];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:myAlertController animated:YES completion:nil];
    });
}

-(void)addHideKeyboardGestureRecognizer{
    [scrollV setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHideKeyboard)];
    [singleTap setNumberOfTapsRequired:1];
    [scrollV addGestureRecognizer:singleTap];
}

-(void)addPickerTapGestureRecognizer{
    [imgPreview setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapChooseImage)];
    [singleTap setNumberOfTapsRequired:1];
    [imgPreview addGestureRecognizer:singleTap];
}

-(void)tapHideKeyboard{
    [txtTag resignFirstResponder];
    [txtName resignFirstResponder];
}

-(void)pushBack{
    UIAlertController *alertConfirm = [UIAlertController alertControllerWithTitle:@"อัพโหลดข้อมูล" message:@"อัพโหลดข้อมูลเรียบร้อย" preferredStyle:UIAlertActionStyleDefault];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"ยืนยัน" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             [alertConfirm dismissViewControllerAnimated:YES completion:nil];
                             [self.navigationController popViewControllerAnimated:YES];
                         }];
    [alertConfirm addAction: ok];
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alertConfirm animated:YES completion:nil];
    });
}

-(void)AddPostEvent{
    if (_upObjid != nil) {
        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"กำลังอัพโหลดแก้ไข Event" message: @"กำลังอัพโหลดแก้ไข Event กรุณารอสักครู่" preferredStyle: UIAlertControllerStyleAlert];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:myAlertController animated:YES completion:nil];
        });
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        //NSData *imageData = UIImageJPEGRepresentation(imgAddToserver, 1);
        NSLog(@"Show chk - !");
        NSString *objId = _upObjid;
        NSLog(@"CHK %@, %@",_upObjid,Adderss);
        NSDictionary *jsonParameter = @{@"Id":objId,@"eventtitle":txtName.text,@"eventtag":@"",@"location":Adderss,@"startdate":startDate,@"stopdate":endDate,@"timestart":startTime,@"timeend":endTime,@"chkOverride":@"1",@"description":txtTag.text,@"eventurl":@""};
        
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/beatajsoneventedit.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
            //[formData appendPartWithFileData:imageData name:@"attrachment" fileName:@"myImage.jpg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [self performSelector:@selector(pushBack) withObject:nil afterDelay:0.5f];
            [myAlertController dismissViewControllerAnimated:YES completion:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST - %@",error);
        }];
        
    }else{
        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"กำลังอัพโหลด Event" message: @"กำลังอัพโหลด Event กรุณารอสักครู่" preferredStyle: UIAlertControllerStyleAlert];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:myAlertController animated:YES completion:nil];
        });
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSData *imageData = UIImageJPEGRepresentation(imgAddToserver, 1);
        NSDictionary *jsonParameter = @{@"evyaccountid":EvyId,@"enentname":txtName.text,@"eventtag":@"",@"locationevent":Adderss,@"datestart":startDate,@"Stoptdate":endDate,@"Timestart":startTime,@"Timeend":endTime,@"chkOverride":@"1",@"description":txtTag.text};
        
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonaddevent.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
            [formData appendPartWithFileData:imageData name:@"attrachment" fileName:@"myImage.jpg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self performSelector:@selector(pushBack) withObject:nil afterDelay:0.5f];
            [myAlertController dismissViewControllerAnimated:YES completion:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST - %@",error);
        }];
    }
}

-(void)AddPostPromotion{
    if (_upObjid != nil) {
        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"กำลังอัพโหลดแก้ไข Promotion" message: @"กำลังอัพโหลดแก้ไข Promotion กรุณารอสักครู่" preferredStyle: UIAlertControllerStyleAlert];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:myAlertController animated:YES completion:nil];
        });
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        //NSData *imageData = UIImageJPEGRepresentation(imgAddToserver, 1);
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateFormatter *formatToDate = [[NSDateFormatter alloc] init];
        [formatToDate setCalendar:gregorianCalendar];
        [formatToDate setDateFormat:@"dd/M/yyyy hh:mm:ss a"];
        NSDictionary *jsonParameter = @{@"Id":_upObjid,@"protitle":txtName.text,@"Location":Adderss,@"Startdate":startDate,@"Stoptdate":endDate,@"Timestart":startTime,@"Timeend":endTime,@"Description":txtTag.text,@"prourl":@""};
        
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonpromoedit.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
            //[formData appendPartWithFileData:imageData name:@"attrachment" fileName:@"myImage.jpg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self performSelector:@selector(pushBack) withObject:nil afterDelay:0.5f];
            [myAlertController dismissViewControllerAnimated:YES completion:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST - %@",error);
        }];
    }else{
        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"กำลังอัพโหลด Promotion" message: @"กำลังอัพโหลด Promotion กรุณารอสักครู่" preferredStyle: UIAlertControllerStyleAlert];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:myAlertController animated:YES completion:nil];
        });
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSData *imageData = UIImageJPEGRepresentation(imgAddToserver, 1);
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateFormatter *formatToDate = [[NSDateFormatter alloc] init];
        [formatToDate setCalendar:gregorianCalendar];
        [formatToDate setDateFormat:@"dd/M/yyyy hh:mm:ss a"];
        NSDictionary *jsonParameter = @{@"evyaccountid":EvyId,@"protitle":txtName.text,@"protag":@"",@"Location":Adderss,@"Startdate":startDate,@"Stoptdate":endDate,@"Timestart":startTime,@"Timeend":endTime,@"chkOverride":@"1",@"Description":txtTag.text,@"prourl":@"",@"Datetimeadd":[NSString stringWithFormat:@"%@",[formatToDate stringFromDate:[NSDate date]]],@"Description":txtTag.text};
        
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonaddpromo.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
            [formData appendPartWithFileData:imageData name:@"attrachment" fileName:@"myImage.jpg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self performSelector:@selector(pushBack) withObject:nil afterDelay:0.5f];
            [myAlertController dismissViewControllerAnimated:YES completion:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST - %@",error);
        }];
    }
}

- (IBAction)startDateTimeAction:(id)sender {
    PostToEventSelectDateTimeViewController *dateTime = [self.storyboard instantiateViewControllerWithIdentifier:@"chooseDateTime"];
    dateTime.navigationItem.title = @"วันเริ่มต้น";
    dateTime.type = @"start";
    dateTime.delegate = self;
    [self.navigationController pushViewController:dateTime animated:YES];
}

- (IBAction)endDateTimeAction:(id)sender {
    PostToEventSelectDateTimeViewController *dateTime = [self.storyboard instantiateViewControllerWithIdentifier:@"chooseDateTime"];
    dateTime.navigationItem.title = @"วันสิ้นสุด";
    dateTime.type = @"end";
    dateTime.delegate = self;
    [self.navigationController pushViewController:dateTime animated:YES];
}

-(void)setDate:(NSDate *)date setTime:(NSDate *)time setType:(NSString *)type{
    NSLog(@"date - %@",date);
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateFormatter *formatToDate = [[NSDateFormatter alloc] init];
    [formatToDate setCalendar:gregorianCalendar];
    [formatToDate setDateFormat:@"dd/M/yyyy"];

    NSDateFormatter *formatToTime = [[NSDateFormatter alloc] init];
    [formatToTime setDateFormat:@"hh:mm:00 a"];
    
    if ([type isEqualToString:@"start"]) {
        startDate = [formatToDate stringFromDate:date];
        startTime = [formatToTime stringFromDate:time];
        NSDateFormatter *formatToTimeShow = [[NSDateFormatter alloc] init];
        [formatToTime setDateFormat:@"hh:mm a"];
        [startDateTimeProperties setTitle:[NSString stringWithFormat:@"%@, %@",startDate,[formatToTime stringFromDate:time]] forState:UIControlStateNormal];
    }else{
        endDate = [formatToDate stringFromDate:date];
        endTime = [formatToTime stringFromDate:time];
        NSDateFormatter *formatToTimeShow = [[NSDateFormatter alloc] init];
        [formatToTime setDateFormat:@"hh:mm a"];
        [endDateTimeProperties setTitle:[NSString stringWithFormat:@"%@, %@",endDate,[formatToTime stringFromDate:time]] forState:UIControlStateNormal];
    }
}

- (IBAction)btSave:(id)sender {
    [self tapHideKeyboard];
    NSString *alertNoti = @"";
    if ([txtName.text isEqualToString:@""]) {
        alertNoti = [NSString stringWithFormat:@"%@ชื่อกิจกรรม: กรุณากรอกชื่อกิจกรรม\n",alertNoti];
    }
    if ([txtTag.text isEqualToString:@""]) {
        alertNoti = [NSString stringWithFormat:@"%@Tag: กรุณากรอก Tag\n",alertNoti];
    }
    if (startDate==nil||startTime == nil) {
        alertNoti = [NSString stringWithFormat:@"%@วันเริ่มต้น: กรุณาเลือกวันเริ่มต้น\n",alertNoti];
    }
    if (endDate==nil||endTime==nil) {
        alertNoti = [NSString stringWithFormat:@"%@วันสิ้นสุด: กรุณาเลือกวันสิ้นสุด\n",alertNoti];
    }
    if ([Adderss isEqualToString:@""]) {
        alertNoti = [NSString stringWithFormat:@"%@พิกัดสถานที่: กรุณากำหนดพิกัดสถานที่\n",alertNoti];
    }
    if (statusChooseImg == NO) {
        alertNoti = [NSString stringWithFormat:@"%@รูปภาพ: กรุณาเลือกรูปภาพ\n",alertNoti];
    }
    if ([alertNoti isEqualToString:@""]) {
        if ([statusPOST isEqualToString:@"event"]) {
            NSLog(@"ADD EVENT");
            [self AddPostEvent];
        }else if ([statusPOST isEqualToString:@"promotion"]){
            NSLog(@"ADD PROMOTION");
            [self AddPostPromotion];
        }
    }else{
        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"ข้อมูลไม่ครบถ้วน" message: alertNoti preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"ยืนยัน" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [myAlertController addAction: ok];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:myAlertController animated:YES completion:nil];
        });
    }
}

- (IBAction)btGetPositionAction:(id)sender {
    PGetLocationViewController *getPosition = [self.storyboard instantiateViewControllerWithIdentifier:@"getPosition"];
    getPosition.delegate = self;
    [self.navigationController pushViewController:getPosition animated:YES];

}

-(void)setAddress:(NSString *)addressforSave{
    Adderss = addressforSave;
    [_btGetPositionProperties setTitle:Adderss forState:UIControlStateNormal];
}

@end
