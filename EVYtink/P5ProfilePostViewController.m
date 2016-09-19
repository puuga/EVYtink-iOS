//
//  P5ProfilePostViewController.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/21/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "P5ProfilePostViewController.h"
#import <AFNetworking.h>

@interface P5ProfilePostViewController ()

@end

@implementation P5ProfilePostViewController
@synthesize lbStatus,txtPost,evyId,switchStatusProperties,lbDetail,statusToServer,strUpdate,statusShared,objId;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"โพสต์" style:UIBarButtonItemStyleDone target:self action:@selector(postToProfile:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    NSLog(@"evyId - %@",evyId);
    txtPost.text = strUpdate;
    self.navigationController.navigationBar.topItem.title = @"ย้อนกลับ";
    [txtPost becomeFirstResponder];
    if ([statusToServer isEqualToString:@"updatenews"]) {
        if ([statusShared isEqualToString:@"private"]) {
            [switchStatusProperties setOn:NO animated:YES];
            lbStatus.text = @"ส่วนตัว";
            lbDetail.text = @"เฉพาะคุณที่จะเห็นโพสต์นี้";
        }
        //switchStatusProperties.enabled = NO;
    }
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

-(void)postToProfile:(id)sender{
    NSString *statusPrivacy;
    if ([switchStatusProperties isOn]) {
        statusPrivacy = @"1";
    }else{
        statusPrivacy = @"0";
    }
    if ([statusToServer isEqualToString:@"updatenews"]) {
        NSLog(@"update");
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSDictionary *jsonParameter = @{@"evarid":evyId,@"evarnewsid":objId,@"evarcommand":statusToServer,@"evarnewscontent":txtPost.text,@"evarprivacy":statusPrivacy};
        
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonnewsedit.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success POST Delete");
            [txtPost resignFirstResponder];
            [self performSelector:@selector(backToProfile:) withObject:nil afterDelay:1.0f];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST delete - %@",error);
        }];
        
        }else{
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSDictionary *jsonParameter = @{@"evyaccountid":evyId,@"newtitle":txtPost.text,@"privacy":statusPrivacy};
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/evytinkapipost.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success POST Delete");
            [txtPost resignFirstResponder];
            [self performSelector:@selector(backToProfile:) withObject:nil afterDelay:1.0f];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST delete - %@",error);
        }];
    }
}

-(void)backToProfile:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchStatus:(id)sender {
    if ([sender isOn]) {
        NSLog(@"On");
        lbStatus.text = @"สาธารณะ";
        lbDetail.text = @"ทุกคนจะเห็นโพสต์ของคุณ";
        CGRect newFrame = txtPost.frame;
        newFrame.size = CGSizeMake(txtPost.frame.size.width, 200);
        txtPost.frame = newFrame;
    }else{
        NSLog(@"Off");
        lbStatus.text = @"ส่วนตัว";
        lbDetail.text = @"เฉพาะคุณที่จะเห็นโพสต์นี้";
    }
    
}
@end
