//
//  CommentViewController.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 6/22/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"

@interface CommentViewController ()

@end

@implementation CommentViewController
@synthesize userId,newsId,arrComment,tableViewComment;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://evbt.azurewebsites.net/docs/page/theme/betajsonnewscomment.aspx?evarnid=%@&chlogin=true&evyid=%@",newsId,userId]]];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    arrComment = [[NSMutableArray alloc] init];
    if ([jsonObjects count]==0) {
        NSLog(@"ไม่มีข้อมูล");
    }else{
        NSLog(@"มีข้อมูล %lu คอมเม้นท์",[jsonObjects count]);
        for (int Cou = 0; Cou<[jsonObjects count]; Cou++) {
            [self addArrComment:[jsonObjects objectAtIndex:Cou]];
        }
    }
}

-(void)addArrComment:(NSSet *)objects{
    NSArray *arrInsert = [[NSArray alloc] initWithObjects:objects,[self returnImage:[objects valueForKey:@"imgprofile"]], nil];
    [arrComment addObject:arrInsert];
}

-(UIImage *)returnImage:(NSString *)urlString{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]];
    NSData *dat = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *imageReturn = [[UIImage alloc] initWithData:dat];
    return imageReturn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrComment count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"cellShowComment";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    cell.imageUser.image = [[arrComment objectAtIndex:indexPath.row] objectAtIndex:1];
    cell.txtUserName.text = [[[arrComment objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"fname"];
    cell.txtComment.text = [[[arrComment objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"comment"];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
