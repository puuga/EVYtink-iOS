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
    //NSLog(@"FB : %@",[[FBSDKAccessToken currentAccessToken] userID]);
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://evbt.azurewebsites.net/docs/page/theme/evycheckfbloginjson.aspx?evarfid=%@",[[FBSDKAccessToken currentAccessToken] userID]]]];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"show event form facebook : %@",jsonObjects);
    /*
    for (int i=0; i<[jsonObjects count]; i++) {
        [arrNews addObject:[jsonObjects objectAtIndex:i]];
        [self.tableView reloadData];
    }*/
    NSLog(@"Show Back Pages.");
    /*
    UITabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
    tbc.selectedIndex = 0;
    tbc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:tbc animated:YES completion:nil];
     */
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"เข้าสู่ระบบ" message:@"เข้าสู่ระบบเรียบร้อย ท่านสามารถใช้งานแอพพลิเคชันในส่วนอื่นได้" delegate:nil cancelButtonTitle:@"ตกลง" otherButtonTitles:nil, nil];
    [alertV show];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self removeFromParentViewController];
}



- (IBAction)BtConfirm:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self removeFromParentViewController];
}
@end