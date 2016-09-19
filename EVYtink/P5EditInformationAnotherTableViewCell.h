//
//  P5EditInformationAnotherTableViewCell.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 9/14/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface P5EditInformationAnotherTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbWillFollow;
@property (weak, nonatomic) IBOutlet UILabel *lbFollow;
@property (weak, nonatomic) IBOutlet UILabel *lbAboutUs;

@property (nonatomic,strong) NSString *EvyId;

@end
