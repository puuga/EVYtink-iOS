//
//  PostToEventSelectDateTimeViewController.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/29/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostToEventSelectDateTimeViewControllerDelegate <NSObject>

-(void)setDate:(NSDate *)date setTime:(NSDate *)time setType:(NSString *)type;

@required

@end


@interface PostToEventSelectDateTimeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *dPicker;



@property (nonatomic,strong) NSString *type;

@property (assign, nonatomic) id<PostToEventSelectDateTimeViewControllerDelegate> delegate;

- (IBAction)saveAction:(id)sender;


@end
