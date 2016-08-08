//
//  LMP3SettingViewController.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/9/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "LMP3SettingViewController.h"
#import "SWRevealViewController.h"

@interface LMP3SettingViewController ()

@end

@implementation LMP3SettingViewController
@synthesize Switch1Properties,Switch2Properties,Switch3Properties,Switch4Properties;

-(void)setNavigationTitle{
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(revealToggle:)];
    anotherButton.image = [[UIImage imageNamed:@"LeftMenuevylogo.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    anotherButton.target = self.revealViewController;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.navigationItem.leftBarButtonItem = anotherButton;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:nil action:nil];
    UIImage* logoImage = [UIImage imageNamed:@"TopCenterlogoevytink.png"];
    UIImageView *uiimagelogoImage = [[UIImageView alloc] initWithImage:logoImage];
    uiimagelogoImage.frame = CGRectMake(75, 0, 100, 44);
    [uiimagelogoImage setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = uiimagelogoImage;
}

-(void)hideTabbar{
    [self.tabBarController.tabBar setTranslucent:YES];
    [self.tabBarController.tabBar setHidden:YES];
}

-(void)loadDefaultSettingNotification{
    NSUserDefaults *Def = [NSUserDefaults standardUserDefaults];
    if (([Def stringForKey:@"SettingNotificationNormal"] == nil)||([Def stringForKey:@"SettingNotificationNews"] == nil)||([Def stringForKey:@"SettingNotificationPromotion"] == nil)||([Def stringForKey:@"SettingNotificationEvent"] == nil)) {
        [Def setValue:@"On" forKey:@"SettingNotificationNormal"];
        [Def setValue:@"On" forKey:@"SettingNotificationNews"];
        [Def setValue:@"On" forKey:@"SettingNotificationPromotion"];
        [Def setValue:@"On" forKey:@"SettingNotificationEvent"];
        [Def synchronize];
    }else{
        if ([[Def valueForKey:@"SettingNotificationNormal"] isEqualToString:@"Off"]) {
            [Switch1Properties setOn:NO animated:YES];
        }
        if ([[Def valueForKey:@"SettingNotificationNews"] isEqualToString:@"Off"]) {
            [Switch2Properties setOn:NO animated:YES];
        }
        if ([[Def valueForKey:@"SettingNotificationPromotion"] isEqualToString:@"Off"]) {
            [Switch3Properties setOn:NO animated:YES];
        }
        if ([[Def valueForKey:@"SettingNotificationEvent"] isEqualToString:@"Off"]) {
            [Switch4Properties setOn:NO animated:YES];
        }
        NSLog(@"1.%@,2.%@,3.%@,4.%@",[Def valueForKey:@"SettingNotificationNormal"],[Def valueForKey:@"SettingNotificationNews"],[Def valueForKey:@"SettingNotificationPromotion"],[Def valueForKey:@"SettingNotificationEvent"]);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle];
    [self hideTabbar];
    [self loadDefaultSettingNotification];
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

- (IBAction)Switch1Action:(id)sender {
    NSUserDefaults *Def = [NSUserDefaults standardUserDefaults];
    if ([(UISwitch *)sender isOn]) {
        [Def setValue:@"On" forKey:@"SettingNotificationNormal"];
    }else{
        [Def setValue:@"Off" forKey:@"SettingNotificationNormal"];
    }
    [Def synchronize];
}

- (IBAction)Switch2Action:(id)sender {
    NSUserDefaults *Def = [NSUserDefaults standardUserDefaults];
    if ([(UISwitch *)sender isOn]) {
        [Def setValue:@"On" forKey:@"SettingNotificationNews"];
    }else{
        [Def setValue:@"Off" forKey:@"SettingNotificationNews"];
    }
    [Def synchronize];
}

- (IBAction)Switch3Action:(id)sender {
    NSUserDefaults *Def = [NSUserDefaults standardUserDefaults];
    if ([(UISwitch *)sender isOn]) {
        [Def setValue:@"On" forKey:@"SettingNotificationPromotion"];
    }else{
        [Def setValue:@"Off" forKey:@"SettingNotificationPromotion"];
    }
    [Def synchronize];
}

- (IBAction)Switch4Action:(id)sender {
    NSUserDefaults *Def = [NSUserDefaults standardUserDefaults];
    if ([(UISwitch *)sender isOn]) {
        [Def setValue:@"On" forKey:@"SettingNotificationEvent"];
    }else{
        [Def setValue:@"Off" forKey:@"SettingNotificationEvent"];
    }
    [Def synchronize];
}
@end
