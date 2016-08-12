//
//  P1CellCustom1.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 5/23/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "P1CellCustom1.h"
#import "FBSDKCoreKit.framework/Headers/FBSDKCoreKit.h"
#import "FBSDKLoginKit.framework/Headers/FBSDKLoginKit.h"

@implementation P1CellCustom1
@synthesize strObjId,indexAction,btLikeOutlet,urlToShow,img,EvyUserId,lbLike,lbComment,userPostId;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews
{
    img.layer.cornerRadius = img.frame.size.width / 2;
    img.clipsToBounds = YES;
    img.layer.borderWidth = 1.0f;
    img.layer.borderColor = [UIColor grayColor].CGColor;
    [super layoutSubviews];
    [self chkStatusLike];
    [self addGestureUserPost];
}

-(void)addGestureUserPost{
    [img setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openUserPost:)];
    [singleTap setNumberOfTapsRequired:1];
    [img addGestureRecognizer:singleTap];
}

-(void)openUserPost:(NSString *)url{
    [self.delegate userPost:userPostId];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)chkStatusLike{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonlikejson.aspx?evaracid=%@&evarnc=clike&evarnsid=%@",EvyUserId,strObjId]];
    NSLog(@"EvyUserId - %@, strObjId - %@",EvyUserId,strObjId);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil success:^(NSURLSessionTask *task, id responseObject){
        if ([[[responseObject objectAtIndex:0] objectForKey:@"youlikestatus"]isEqualToString:@"0"]) {
            NSLog(@"Status = 0");
        }else if ([[[responseObject objectAtIndex:0] objectForKey:@"youlikestatus"]isEqualToString:@"1"]){
            NSLog(@"Status = 1");
        }
        //NSLog(@"Index row - %ld",indexAction.row);
        lbLike.text = [[responseObject objectAtIndex:0] objectForKey:@"newslikecount"];
        if ([[[responseObject objectAtIndex:0] objectForKey:@"youlikestatus"]isEqualToString:@"0"]) {
            [btLikeOutlet setImage:[UIImage imageNamed:@"iconFav.png"] forState:UIControlStateNormal];
            [btLikeOutlet setTitle:@"Normal" forState:UIControlStateNormal];
        }else{
            [btLikeOutlet setImage:[UIImage imageNamed:@"iconFavClick.png"] forState:UIControlStateNormal];
            [btLikeOutlet setTitle:@"Like" forState:UIControlStateNormal];
        }
    }failure:^(NSURLSessionTask *operation, NSError *error){
        NSLog(@"Failes");
    }];
}

-(void)addLike{
    if (![lbLike.text isEqualToString:@""]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *myNumber = [f numberFromString:lbLike.text];
        NSNumber *sum = [NSNumber numberWithFloat:([myNumber floatValue] + 1)];
        lbLike.text = [NSString stringWithFormat:@"%@",sum];
    }else{
        lbLike.text = @"1";
    }
}

-(void)disLike{
    if (![lbLike.text isEqualToString:@"1"]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *myNumber = [f numberFromString:lbLike.text];
        NSNumber *sum = [NSNumber numberWithFloat:([myNumber floatValue] - 1)];
        lbLike.text = [NSString stringWithFormat:@"%@",sum];
    }else{
        lbLike.text = @"";
    }
}

- (IBAction)btLike:(id)sender {
    if ([self.delegate ChkFacebookLoginStatus]) {
        NSLog(@"login facebook แล้ว");
        if ([btLikeOutlet.titleLabel.text isEqualToString:@"Normal"]) {
            [btLikeOutlet setImage:[UIImage imageNamed:@"iconFavClick.png"] forState:UIControlStateNormal];
            [btLikeOutlet setTitle:@"Like" forState:UIControlStateNormal];
            [self LikeData];
            [self addLike];
        }else if([btLikeOutlet.titleLabel.text isEqualToString:@"Like"]){
            [btLikeOutlet setImage:[UIImage imageNamed:@"iconFav.png"] forState:UIControlStateNormal];
            [btLikeOutlet setTitle:@"Normal" forState:UIControlStateNormal];
            [self LikeData];
            [self disLike];
        }else{
            [btLikeOutlet setImage:[UIImage imageNamed:@"iconFavClick.png"] forState:UIControlStateNormal];
            [btLikeOutlet setTitle:@"Like" forState:UIControlStateNormal];
            [self LikeData];
            [self addLike];
        }
    }else{
        NSLog(@"ยังไม่ได้ Login Facebook");
    }
}

-(void)LikeData{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonlikejson.aspx?evaracid=%@&evarnc=slike&evarnsid=%@",EvyUserId,strObjId]];
    NSLog(@"USER PUSH LIKE : %@, str obj like - %@",EvyUserId,strObjId);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"like success - %@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError * error) {
        NSLog(@"like Unsuccess : %@",error);
    }];
    
    
    /*
    NSLog(@"Like Data - %@",strObjId);
    NSString *strLike = [NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonlikejson.aspx?evaracid=%@&evarnc=slike&evarnsid=%@",EvyUserId,strObjId];
    NSData *jsonLikeData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strLike]];
    id jsonLikeObject = [NSJSONSerialization JSONObjectWithData:jsonLikeData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"Success Like : %@",jsonLikeObject);*/
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

- (IBAction)btEditAction:(id)sender {
    [self.delegate editPost:userPostId indexpath:indexAction];
}
@end
