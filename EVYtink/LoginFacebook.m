//
//  LoginFacebook.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 5/19/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "LoginFacebook.h"
#import "FBSDKCoreKit.framework/Headers/FBSDKCoreKit.h"
#import "FBSDKLoginKit.framework/Headers/FBSDKLoginKit.h"

@implementation LoginFacebook{
    NSString *valFirst;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    loginButton.delegate = self;
}

-(void) loginButton:  (FBSDKLoginButton *)loginButton didCompleteWithResult:  (FBSDKLoginManagerLoginResult *)result error:  (NSError *)error{
    [self checkStatusFacebookLogin];
}

-(void) loginButtonDidLogOut:  (FBSDKLoginButton *)loginButton{
    NSLog(@"success logout");
    [self dismissViewControllerAnimated:YES completion:nil];
    [self removeFromParentViewController];
}

-(void)checkStatusFacebookLogin{
    if ([FBSDKAccessToken currentAccessToken]) {
        [self LoginSuccess];
        NSLog(@"has data");
    }else{
        NSLog(@"Not has data");
    }
}

-(void)LoginSuccess{
    NSLog(@"FB : %@",[[FBSDKAccessToken currentAccessToken] userID]);
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email,first_name,last_name" forKey:@"fields"];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                  id result, NSError *error) {
         if (!error) {
             NSLog(@"results All - %@",result);
             NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/evycheckfbloginjson.aspx?evarfid=%@&fname=%@%@%@",[result objectForKey:@"id"],[result objectForKey:@"first_name"],@"%20",[result objectForKey:@"last_name"]]]];
             id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
             NSLog(@"json add - %@",jsonObjects);
             UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"เข้าสู่ระบบ" message:@"เข้าสู่ระบบเรียบร้อย ท่านสามารถใช้งานแอพพลิเคชันในส่วนอื่นได้" delegate:nil cancelButtonTitle:@"ตกลง" otherButtonTitles:nil, nil];
             [alertV show];
             [self dismissViewControllerAnimated:YES completion:nil];
             [self removeFromParentViewController];
         }
     }];
    
}



- (IBAction)BtConfirm:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self removeFromParentViewController];
}
@end
