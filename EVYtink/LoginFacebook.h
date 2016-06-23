//
//  LoginFacebook.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 5/19/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBSDKLoginKit.framework/Headers/FBSDKLoginKit.h"

@interface LoginFacebook : UIViewController<FBSDKLoginButtonDelegate>
- (IBAction)BtConfirm:(id)sender;

@end
