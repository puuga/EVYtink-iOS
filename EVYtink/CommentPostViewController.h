//
//  CommentPostViewController.h
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/21/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentPostViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *txtPost;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *newsId;

@end
