//
//  P1D2TableViewCell.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/26/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "P1D2TableViewCell.h"

@implementation P1D2TableViewCell
@synthesize img,userPostId,indexAction;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    img.layer.cornerRadius = img.frame.size.width / 2;
    img.clipsToBounds = YES;
    img.layer.borderWidth = 1.0f;
    img.layer.borderColor = [UIColor grayColor].CGColor;
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

- (IBAction)btEditAction:(id)sender {
    [self.delegate editPost:userPostId indexpath:indexAction];
}
@end
