//
//  P1CellCustom2.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 5/23/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "P1CellCustom2.h"
#import "FBSDKCoreKit.framework/Headers/FBSDKCoreKit.h"
#import "FBSDKLoginKit.framework/Headers/FBSDKLoginKit.h"

#import "LoginFacebook.h"

@implementation P1CellCustom2
@synthesize strObjId,indexAction,btLikeOutlet,urlToShow;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btLike:(id)sender {
    if ([self.delegate ChkFacebookLoginStatus]) {
        NSLog(@"");
        NSLog(@"login facebook แล้ว");
        if ([btLikeOutlet.titleLabel.text isEqualToString:@"Normal"]) {
            [btLikeOutlet setImage:[UIImage imageNamed:@"iconFavClick.png"] forState:UIControlStateNormal];
            [btLikeOutlet setTitle:@"Like" forState:UIControlStateNormal];
            [self LikeData];
        }else if([btLikeOutlet.titleLabel.text isEqualToString:@"Like"]){
            [btLikeOutlet setImage:[UIImage imageNamed:@"iconFav.png"] forState:UIControlStateNormal];
            [btLikeOutlet setTitle:@"Normal" forState:UIControlStateNormal];
            NSLog(@"Normal");
        }else{
            [btLikeOutlet setImage:[UIImage imageNamed:@"iconFavClick.png"] forState:UIControlStateNormal];
            [btLikeOutlet setTitle:@"Like" forState:UIControlStateNormal];
            [self LikeData];
        }
    }else{
        NSLog(@"ยังไม่ได้ Login Facebook");
    }
}

-(void)LikeData{
    NSLog(@"Like Data - %@",strObjId);
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://evbt.azurewebsites.net/docs/page/theme/evycheckfbloginjson.aspx?evarfid=%@",[[FBSDKAccessToken currentAccessToken] userID]]]];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSString *strLike = [NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonlikejson.aspx?evaracid=%@&evarnc=clike&evarnsid=%@",[[jsonObjects objectAtIndex:0] objectForKey:@"evyaccountid"],strObjId];
    NSData *jsonLikeData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strLike]];
    id jsonLikeObject = [NSJSONSerialization JSONObjectWithData:jsonLikeData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"Success Like : %@",jsonLikeObject);
}

- (IBAction)btShare:(id)sender {
    if ([self.delegate ChkFacebookLoginStatus]) {
        [self.delegate shareToFacebook:urlToShow];
    }
}

- (IBAction)btComment:(id)sender {
    if ([self.delegate ChkFacebookLoginStatus]) {
        [self.delegate commentTo:indexAction];
    }
}
@end
