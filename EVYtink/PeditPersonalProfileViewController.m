//
//  PeditPersonalProfileViewController.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 9/5/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "PeditPersonalProfileViewController.h"
#import <AFNetworking.h>

@interface PeditPersonalProfileViewController ()

@end

@implementation PeditPersonalProfileViewController
@synthesize txtName,txtVAbout,txtWebsite,scrollViewContent,EName,EWebsite,EDescription,EvyId,EAddress,mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    txtName.delegate = self;
    txtVAbout.delegate = self;
    txtWebsite.delegate = self;
    txtWebsite.text = EWebsite;
    txtVAbout.text = EDescription;
    txtName.text = EName;
    
    
    [scrollViewContent setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHideKeyboard)];
    [singleTap setNumberOfTapsRequired:1];
    [scrollViewContent addGestureRecognizer:singleTap];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"บันทึก" style:UIBarButtonItemStyleDone target:self action:@selector(savePersonalData)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    NSURLRequest *urlRequestAc = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@",[[NSString stringWithFormat:@"%@",EAddress] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]]];
    AFHTTPRequestOperation *operationAc = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequestAc];
    operationAc.responseSerializer = [AFJSONResponseSerializer serializer];
    [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [operationAc setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"show position - lat %@, long %@",[[[[[responseObject objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"],[[[[[responseObject objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"]);
        
        [mapView setShowsUserLocation:YES];
        MKCoordinateSpan span;
        span.latitudeDelta = .4;
        span.longitudeDelta = .4;
        //the .001 here represents the actual height and width delta
        MKCoordinateRegion region;
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[[[[[responseObject objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] doubleValue], [[[[[[responseObject objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] doubleValue]);
        region.center = coord;
        region.span = span;
        [mapView setRegion:region animated:TRUE];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Not Success afnetworking.,%@",error);
    }];
    [operationAc start];
}

-(void)savePersonalData{
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude);
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f",coord.latitude,coord.longitude]]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [[[responseObject objectForKey:@"results"] objectAtIndex:0] objectForKey:@"formatted_address"];
        EAddress = str;
        NSLog(@"Eaddress save - %@",EAddress);
        [self saveToServer];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Not Success afnetworking.,%@",error);
    }];
    [operation start];
}

-(void)saveToServer{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSDictionary *jsonParameter = @{@"fname":txtName.text,@"Descrtiption":txtVAbout.text,@"website":txtWebsite.text,@"evyaccountid":EvyId,@"location":EAddress};
    [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonupdateaccount.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        //[formData appendPartWithFileData:imageData name:@"attrachment" fileName:@"myImage.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"แก้ไข้ข้อมูลส่วนตัวเรียบร้อย" message: nil preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *success = [UIAlertAction actionWithTitle:@"เสร็จสิ้น" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     [self performSelector:@selector(dismissController) withObject:nil afterDelay:0.1];
                                 }];
        [myAlertController addAction:success];
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:myAlertController animated:YES completion:nil];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Not success POST - %@",error);
    }];
}

- (void)dismissController {
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)tapHideKeyboard{
    [txtWebsite resignFirstResponder];
    [txtVAbout resignFirstResponder];
    [txtName resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    CGPoint point = textView.frame.origin;
    point.y = point.y - 40;
    point.x = 0;
    scrollViewContent.contentOffset = point;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    CGPoint point = textField.frame.origin;
    point.y = point.y - 40;
    point.x = 0;
    scrollViewContent.contentOffset = point;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
