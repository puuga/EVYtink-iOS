//
//  ViewWeb.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 5/26/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewWeb : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webV;
@property (nonatomic,strong) NSURL *url;
- (IBAction)btClose:(id)sender;

@end
