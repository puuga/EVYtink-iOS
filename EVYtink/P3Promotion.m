//
//  P3Promotion.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 5/24/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "P3Promotion.h"
#import "P1CellCustom1.h"
#import "P1CellCustom2.h"
#import "P1CellCustom3.h"
#import "ViewWeb.h"

@interface P3Promotion ()

@end

@implementation P3Promotion

@synthesize arrPromotion,arrShowPromotion;

- (void)viewDidLoad {
    [super viewDidLoad];
    static NSString *CellIdentifier1 = @"idenCell1";
    static NSString *CellIdentifier2 = @"idenCell2";
    static NSString *CellIdentifier3 = @"idenCell3";
    UINib *nib = [UINib nibWithNibName:@"CustomCell1" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier1];
    
    nib = [UINib nibWithNibName:@"CustomCell2" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier2];
    
    nib = [UINib nibWithNibName:@"CustomCell3" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier3];
    
    [self.tableView reloadData];
    
    
    arrPromotion = [[NSMutableArray alloc] init];
    arrShowPromotion = [[NSMutableArray alloc] init];
    [self setArrPromotion:arrPromotion];
    if ([arrPromotion count]<5) {
        [self startArrShowPromotion:arrPromotion startAt:0 endAt:([arrPromotion count]-1)];
    }else{
        [self startArrShowPromotion:arrPromotion startAt:0 endAt:4];
    }
}

-(void)startArrShowPromotion:(NSMutableArray *)arrS startAt:(int)start endAt:(int)end{
    for (int count = start; count <= end; count++) {
        [arrShowPromotion addObject:[arrPromotion objectAtIndex:count]];
        if ([[[arrShowPromotion objectAtIndex:count] objectForKey:@"imageurl"]isEqualToString:@"no"]){
            NSLog(@"Pic - ไม่มีรูป");
        }else if ([[[arrShowPromotion objectAtIndex:count] objectForKey:@"imageurl2"]isEqualToString:@"no"]){
            NSLog(@"%d Pic - มีรูปที่ 1",count);
        }else{
            NSLog(@"Pic - มีรูป 2 รูป");
        }
    }
    [self.tableView reloadData];
}

-(void)setArrPromotion:(NSMutableArray *)arrP{
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://evbt.azurewebsites.net/docs/page/theme/betajsonpromotion.aspx"]];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    for (int i=0; i<[jsonObjects count]; i++) {
        [arrP addObject:[jsonObjects objectAtIndex:i]];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [arrShowPromotion count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"idenCell1";
    static NSString *CellIdentifier2 = @"idenCell2";
    static NSString *CellIdentifier3 = @"idenCell3";
    
    if ((indexPath.row == ([arrShowPromotion count])-1)&&([arrPromotion count]!=[arrShowPromotion count])) {
        if (([arrShowPromotion count] + 5) <= [arrPromotion count]) {
            [self startArrShowPromotion:arrPromotion startAt:(indexPath.row + 1) endAt:(indexPath.row + 5)];
            NSLog(@"บวกเพิ่ม 5");
        }else{
            [self startArrShowPromotion:arrPromotion startAt:(indexPath.row + 1) endAt:([arrPromotion count] - 1)];
            NSLog(@"บวกเพิ่ม %lu",[arrPromotion count]);
        }
    }
    
    if ([[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"imageurl"]isEqualToString:@"no"]) {
        P1CellCustom1 *cell = (P1CellCustom1 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (![cell.txtDetail.text isEqualToString:[[arrPromotion objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];
            NSURL *urlUser = [NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]];
            NSData *datUrlUser = [[NSData alloc] initWithContentsOfURL:urlUser];
            cell.img.image = [UIImage imageWithData:datUrlUser];
            
            cell.indexAction = indexPath;
            cell.strObjId = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"eventevyid"];
            cell.txtName.text = [[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"promotitle"];
            cell.txtDate.text = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"title"];
        }
        return cell;
    }else if ([[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]isEqualToString:@"no"]){
        P1CellCustom2 *cell = (P1CellCustom2 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (![cell.txtDetail.text isEqualToString:[[arrPromotion objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];
            NSURL *urlUser = [NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]];
            NSData *datUrlUser = [[NSData alloc] initWithContentsOfURL:urlUser];
            cell.img.image = [UIImage imageWithData:datUrlUser];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrPromotion objectAtIndex:indexPath.row] objectForKey:@"imageurl"]]];
            NSData *dat = [[NSData alloc] initWithContentsOfURL:url];
            UIImage *imgChange = [[UIImage alloc] initWithData:dat];
            if (imgChange.size.width>imgChange.size.height) {
                float oldHeight = imgChange.size.height;
                float scaleFactor = 254 / oldHeight;
                float newHeight = oldHeight * scaleFactor;
                float newWidth = imgChange.size.width * scaleFactor;
                UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
                [imgChange drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
                UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                cell.imgPic1.image = newImage;
            }else{
                float oldWidth = imgChange.size.width;
                float scaleFactor = self.view.frame.size.width / oldWidth;
                float newHeight = imgChange.size.height * scaleFactor;
                float newWidth = oldWidth * scaleFactor;
                UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
                [imgChange drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
                UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                cell.imgPic1.image = newImage;
            }
            cell.indexAction = indexPath;
            cell.strObjId = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"eventevyid"];
            cell.txtName.text = [[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"promotitle"];
            cell.txtDate.text = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"title"];
        }
        return cell;
    }else{
        P1CellCustom3 *cell = (P1CellCustom3 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        if (![cell.txtDetail.text isEqualToString:[[arrPromotion objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];
            NSURL *urlUser = [NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]];
            NSData *datUrlUser = [[NSData alloc] initWithContentsOfURL:urlUser];
            cell.img.image = [UIImage imageWithData:datUrlUser];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrPromotion objectAtIndex:indexPath.row] objectForKey:@"imageurl"]]];
            NSData *dat = [[NSData alloc] initWithContentsOfURL:url];
            UIImage *imgChange = [[UIImage alloc] initWithData:dat];
            float oldWidth = imgChange.size.width;
            float scaleFactor = (self.view.frame.size.width/2) / oldWidth;
            float newHeight = imgChange.size.height * scaleFactor;
            float newWidth = oldWidth * scaleFactor;
            UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
            [imgChange drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrPromotion objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]]];
            NSData *dat2 = [[NSData alloc] initWithContentsOfURL:url2];
            UIImage *imgChange2 = [[UIImage alloc] initWithData:dat2];
            UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
            [imgChange2 drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
            UIImage *newImage2 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            cell.indexAction = indexPath;
            cell.strObjId = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"eventevyid"];
            cell.imgPic1.image = newImage;
            cell.imgPic2.image = newImage2;
            cell.txtName.text = [[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"promotitle"];
            cell.txtDate.text = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"title"];
        }
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[[arrPromotion objectAtIndex:indexPath.row] objectForKey:@"imageurl"]isEqualToString:@"no"]) {
        return 168;
    }else if ([[[arrPromotion objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]isEqualToString:@"no"]){
        return 400;
    }else{
        return 291;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //StickersCoordinate *sendUnlock = [arrStickerSore objectAtIndex:indexPath.row];
    ViewWeb *sendWebView = [self.storyboard instantiateViewControllerWithIdentifier:@"openWebView"];
    
    sendWebView.url = [NSURL URLWithString:[[arrShowPromotion objectAtIndex:indexPath.row] objectForKey:@"url"]];
    [self presentViewController:sendWebView animated:YES completion:NULL];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
