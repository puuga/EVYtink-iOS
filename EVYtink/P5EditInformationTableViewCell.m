//
//  P5EditInformationTableViewCell.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 9/6/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "P5EditInformationTableViewCell.h"

@implementation P5EditInformationTableViewCell
@synthesize EvyId;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btEditPersonalInformationAction:(id)sender {
    [self.delegate editPersonalInformation:EvyId];
}
@end
