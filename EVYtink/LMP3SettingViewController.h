//
//  LMP3SettingViewController.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/9/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMP3SettingViewController : UIViewController
- (IBAction)Switch1Action:(id)sender;
- (IBAction)Switch2Action:(id)sender;
- (IBAction)Switch3Action:(id)sender;
- (IBAction)Switch4Action:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *Switch1Properties;
@property (weak, nonatomic) IBOutlet UISwitch *Switch2Properties;
@property (weak, nonatomic) IBOutlet UISwitch *Switch3Properties;
@property (weak, nonatomic) IBOutlet UISwitch *Switch4Properties;

@end
