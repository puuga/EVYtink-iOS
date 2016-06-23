//
//  testTableView.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 5/26/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "testTableView.h"
#import "TestCell.h"

@interface testTableView ()

@end

@implementation testTableView
@synthesize arrNews;

- (void)viewDidLoad {
    [super viewDidLoad];
    arrNews = [[NSMutableArray alloc] init];
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://evbt.azurewebsites.net/docs/page/theme/betajsonnews.aspx"]];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    for (int i=0; i<[jsonObjects count]; i++) {
        [arrNews addObject:[jsonObjects objectAtIndex:i]];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [arrNews count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (cell.imageView.image == NULL) {
        NSLog(@"ไม่พบรูปภาพ");
        NSString *dataUrl = [[arrNews objectAtIndex:indexPath.row] objectForKey:@"imageurl"];
        NSURL *url = [NSURL URLWithString:dataUrl];
        
        NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            UIImage *imgChange = [UIImage imageWithData:data];
            float oldWidth = imgChange.size.width;
            float scaleFactor = self.view.frame.size.width / oldWidth;
            float newHeight = imgChange.size.height * scaleFactor;
            float newWidth = oldWidth * scaleFactor;
            UIGraphicsBeginImageContext(CGSizeMake(200, 200));
            [imgChange drawInRect:CGRectMake(0, 0, 200, 200)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            cell.imageView.image = newImage;
            [tableView reloadData];
        }];
        [downloadTask resume];

    }else{
        NSLog(@"พบรูปภาพแล้ว");
    }
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
