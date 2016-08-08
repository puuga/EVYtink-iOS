//
//  CommentPostViewController.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/21/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "CommentPostViewController.h"

@interface CommentPostViewController ()

@end

@implementation CommentPostViewController
@synthesize userId,newsId,txtPost;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"โพสต์" style:UIBarButtonItemStyleDone target:self action:@selector(postToComment:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    NSLog(@"user - %@, news - %@",userId,newsId);
    
    self.navigationController.navigationBar.topItem.title = @"ย้อนกลับ";
    [txtPost becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)postToComment:(id)sender{
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonnewscomment.aspx?evarnid=%@&chlogin=false&evcommand=save&evyid=%@&enewscomment=%@",newsId,userId,[[NSString stringWithFormat:@"%@",txtPost.text] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]]];
    NSLog(@"Show comment - %@",[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonnewscomment.aspx?evarnid=%@&chlogin=false&evcommand=save&evyid=%@&enewscomment=%@",newsId,userId,[NSString stringWithFormat:@"%@",txtPost.text]]);
    //id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    [self performSelector:@selector(backToComment:) withObject:nil afterDelay:1.0f];
}

-(void)backToComment:(id)sender{
    NSLog(@"back");
    [self.navigationController popViewControllerAnimated:YES];
}
@end
