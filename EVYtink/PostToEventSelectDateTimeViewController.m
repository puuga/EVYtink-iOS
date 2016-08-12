//
//  PostToEventSelectDateTimeViewController.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/29/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "PostToEventSelectDateTimeViewController.h"

@interface PostToEventSelectDateTimeViewController ()

@end

@implementation PostToEventSelectDateTimeViewController
@synthesize dPicker,timePicker,type;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDatePicker:dPicker];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //self.navigationController.navigationBar.topItem.title = @"ย้อนกลับ";
}

-(void)setDatePicker:(UIDatePicker *)picker{
    NSDate *currentDate = [NSDate date];
    NSDate *mindate = currentDate;
    [picker setMinimumDate:mindate];
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

- (IBAction)saveAction:(id)sender {
    [self.delegate setDate:dPicker.date setTime:timePicker.date setType:type];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
