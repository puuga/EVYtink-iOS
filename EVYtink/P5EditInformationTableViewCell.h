//
//  P5EditInformationTableViewCell.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 9/6/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol P5EditInformationTableViewCellControllerDelegate <NSObject>
-(void)editPersonalInformation:(NSString *)EvyUserId;
@required
@end

@interface P5EditInformationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbWillFollow;
@property (weak, nonatomic) IBOutlet UILabel *lbFollow;
@property (weak, nonatomic) IBOutlet UILabel *lbAboutUs;
- (IBAction)btEditPersonalInformationAction:(id)sender;

@property (nonatomic,strong) NSString *EvyId;

@property (assign, nonatomic) id<P5EditInformationTableViewCellControllerDelegate> delegate;


@end
