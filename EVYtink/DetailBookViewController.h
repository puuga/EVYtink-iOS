//
//  DetailBookViewController.h
//  EVYbook
//
//  Created by roomlinksaas_dev on 8/19/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailBookViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgCover;
@property (weak, nonatomic) IBOutlet UITextView *txtView;

@property (nonatomic,strong) NSString *urlImgCover;
@property (nonatomic,strong) NSString *strTextView;
@property (nonatomic, strong) NSString *urlDownload;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic,strong) NSString *EvyId;
@property (nonatomic,strong) NSString *objBookId;

- (IBAction)downloadBtAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtProperties;
@property (weak, nonatomic) IBOutlet UIButton *deleteBookBtProperties;

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
- (IBAction)deleteBookBtAction:(id)sender;

@end
