//
//  P5ProfilePostViewController.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/21/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface P5ProfilePostViewController : UIViewController<UITextViewDelegate>

- (IBAction)switchStatus:(id)sender;
@property (nonatomic, strong) NSString *evyId;
@property (weak, nonatomic) IBOutlet UISwitch *switchStatusProperties;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UITextView *txtPost;
@property (weak, nonatomic) IBOutlet UILabel *lbDetail;
@property (nonatomic,strong) NSString *statusToServer;
@property (nonatomic,strong) NSString *strUpdate;
@property (nonatomic,strong) NSString *statusShared;
@property (nonatomic,strong) NSString *objId;
@end
