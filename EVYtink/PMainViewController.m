//
//  PMainViewController.m
//  EVYbook
//
//  Created by roomlinksaas_dev on 8/22/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "PMainViewController.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import "StyleVerticalCollectionTableViewCell.h"
#import "DetailBookViewController.h"
#import "SWRevealViewController.h"
#import "LoginFacebook.h"

#define rowsDef 4;

@interface PMainViewController (){
    NSString *typeShow;
    double CellHeight;
    double rowCollection;
    NSString *EvyId;
}

@end

@implementation PMainViewController
@synthesize arrBook,TablePMain;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:117.0f/255.0f green:60.0f/255.0f blue:17.0f/255.0f alpha:1.0f];
    
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0., 0., 320., 44.)];
    searchBar.barTintColor = [UIColor colorWithRed:117.0f/255.0f green:60.0f/255.0f blue:17.0f/255.0f alpha:1.0f];
    searchBar.delegate = self;
    self.TablePMain.tableHeaderView = searchBar;
    self.TablePMain.backgroundColor = [UIColor colorWithRed:117.0f/255.0f green:60.0f/255.0f blue:17.0f/255.0f alpha:1.0f];
    
    CellHeight = 180;
    static NSString *identifier1 = @"identifierStyleCollectionVertical";
    
    UINib *nib1 = [UINib nibWithNibName:@"StyleVerticalCollectionTableViewCell" bundle:nil];
    [self.TablePMain registerNib:nib1 forCellReuseIdentifier:identifier1];
    [self.TablePMain reloadData];
    
    typeShow = @"vertical";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    UIView *headerContentView = self.TablePMain.tableHeaderView.subviews[0];
    headerContentView.transform = CGAffineTransformMakeTranslation(0, MIN(offsetY, 0));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    if ([self ChkFacebookLoginStatus]) {
        EvyId = [self getEvyId];
        [self loadDataBook];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length] == 0) {
        NSLog(@"hide keyboard");
        [searchBar performSelector:@selector(resignFirstResponder) withObject:nil afterDelay:0.01];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)loadDataBook{
    self.TablePMain.userInteractionEnabled = NO;
    arrBook = [[NSMutableArray alloc] init];
    [TablePMain reloadData];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonevybook.aspx?evarid=%@",EvyId]]];
    NSLog(@"EVY id - %@",EvyId);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success afnetworking.");
        for (int i = 0; i<[responseObject count]; i++) {
            [arrBook addObject:[responseObject objectAtIndex:i]];
            [self.TablePMain reloadData];
            if (i == ([responseObject count] - 1)) {
                self.TablePMain.userInteractionEnabled = YES;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Not Success afnetworking.");
    }];
    [operation start];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([typeShow isEqualToString:@"vertical"]) {
        if ([arrBook count]>0) {
            NSNumber *val1 = [NSNumber numberWithInteger:([arrBook count] / 5)];
            NSNumber *val2 = [NSNumber numberWithInteger:([arrBook count] % 5)];
            NSLog(@"val 2 - %f",[val2 floatValue]);
            if ([val2 intValue]>0) {
                NSNumber *val3 = [NSNumber numberWithInteger:([val1 integerValue] + 1)];
                rowCollection = [val3 integerValue];
                NSLog(@"if 2 แสดง %f",rowCollection);
                if ([val3 integerValue] < 3) {
                    return rowsDef;
                }else{
                    return [val3 integerValue];
                }
            }else{
                rowCollection = [val1 integerValue];
                NSLog(@"if 1 แสดง %f",rowCollection);
                if ([val1 integerValue] < 3) {
                    return rowsDef;
                }else{
                    return [val1 integerValue];
                }
            }
        }else{
            return 0;
        }
    }else{
        return [arrBook count];
    }
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString *identifier1 = @"identifierStyleCollectionVertical";
     //NSLog(@"arr C - %lu",[arrBook count]);
     StyleVerticalCollectionTableViewCell *cell = (StyleVerticalCollectionTableViewCell *)[TablePMain dequeueReusableCellWithIdentifier:identifier1 forIndexPath:indexPath];
     NSNumber *start = [NSNumber numberWithInteger:indexPath.row];
     start = [NSNumber numberWithInteger:[start integerValue] * 5];
     NSNumber *final;
     NSLog(@"ค่า start = %d",[start intValue]);
     
     if ([start intValue] > [self.arrBook count]) {
         
     }else{
         if ([start intValue] == [self.arrBook count]) {
             NSLog(@"case ไม่มีข้อมูลในแถว");
             final = [NSNumber numberWithInteger:0];
         }else if ((([start intValue] + 5) < [self.arrBook count])||([start intValue] + 5) == [self.arrBook count]){
             NSLog(@"case มีข้อมูลในแถว 5 ข้อมูล");
             final = [NSNumber numberWithInteger:5];
         }else{
             NSLog(@"case มีข้อมูลในแถว %d ข้อมูล",[self.arrBook count] % 5);
             final = [NSNumber numberWithInteger:([self.arrBook count] % 5)];
         }
         cell.arrBook = [self.arrBook subarrayWithRange:NSMakeRange([start intValue], [final intValue])];
         cell.indexRow = indexPath;
         cell.delegate = self;
         [cell.CollectionStyleVertical reloadData];
     }
     
     return cell;
 }

#pragma mark - Show height for cell

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (IBAction)changeTypeAction:(id)sender {
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"การแสดงผล" message:nil preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction* horizon = [UIAlertAction actionWithTitle:@"จัดเรียงรูปแบบแนวตั้ง" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                  typeShow = @"vertical";
                                  [TablePMain reloadData];
                              }];
    [myAlertController addAction: horizon];
    UIAlertAction* vertical = [UIAlertAction actionWithTitle:@"จัดเรียงรูปแบบละเอียด" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                               {
                                   [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                   typeShow = @"horizontal";
                                   [TablePMain reloadData];
                               }];
    [myAlertController addAction: vertical];
    UIAlertAction* filterName = [UIAlertAction actionWithTitle:@"จัดเรียงตามชื่อหนังสือ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
    [myAlertController addAction: filterName];
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:myAlertController animated:YES completion:nil];
    });
}

#pragma mark - When selected table view

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailBookViewController *detailBook = [self.storyboard instantiateViewControllerWithIdentifier:@"idenDetailBook"];
    detailBook.urlImgCover = [NSString stringWithFormat:@"%@",[[arrBook objectAtIndex:indexPath.row] objectForKey:@"coverfilename"]];
    NSString *str = [NSString stringWithFormat:@"ชื่อหนังสือ: %@\n\nผู้แต่ง: %@\n",[[arrBook objectAtIndex:indexPath.row] objectForKey:@"title"],[[arrBook objectAtIndex:indexPath.row] objectForKey:@"author"]];
    detailBook.strTextView = str;
    detailBook.urlDownload = [[arrBook objectAtIndex:indexPath.row] objectForKey:@"filename"];
    detailBook.fileName = [[arrBook objectAtIndex:indexPath.row] objectForKey:@"ebookfilename"];
    detailBook.EvyId = EvyId;
    detailBook.objBookId = [[arrBook objectAtIndex:indexPath.row] objectForKey:@"bookshelfid"];
    [self.navigationController pushViewController:detailBook animated:YES];
}

-(void)showSelected:(NSIndexPath *)indexPath indexRows:(NSIndexPath *)indexRow{
    NSInteger rowsSelected = indexPath.row + (indexRow.row * 5);
    
    DetailBookViewController *detailBook = [self.storyboard instantiateViewControllerWithIdentifier:@"idenDetailBook"];
    detailBook.urlImgCover = [NSString stringWithFormat:@"%@",[[arrBook objectAtIndex:rowsSelected] objectForKey:@"coverfilename"]];
    NSString *str = [NSString stringWithFormat:@"ชื่อหนังสือ: %@\n\nผู้แต่ง: %@\n",[[arrBook objectAtIndex:rowsSelected] objectForKey:@"title"],[[arrBook objectAtIndex:rowsSelected] objectForKey:@"author"]];
    detailBook.strTextView = str;
    detailBook.urlDownload = [[arrBook objectAtIndex:rowsSelected] objectForKey:@"filename"];
    detailBook.fileName = [[arrBook objectAtIndex:rowsSelected] objectForKey:@"ebookfilename"];
    detailBook.EvyId = EvyId;
    detailBook.objBookId = [[arrBook objectAtIndex:indexPath.row] objectForKey:@"bookshelfid"];
    [self.navigationController pushViewController:detailBook animated:YES];
    
}

#pragma mark - Check Facebook Login.
-(BOOL)ChkFacebookLoginStatus{
    if ([FBSDKAccessToken currentAccessToken]) {
        return TRUE;
    }else{
        LoginFacebook *LoginFacebookView = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInF"];
        [self presentViewController:LoginFacebookView animated:YES completion:nil];
        return FALSE;
    }
}

#pragma mark - Get EvyId.
-(NSString *)getEvyId{
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/evycheckfbloginjson.aspx?evarfid=%@",[[FBSDKAccessToken currentAccessToken] userID]]]];
    NSLog(@"U ID - %@",[[FBSDKAccessToken currentAccessToken] userID]);
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"show event form facebook : %@",[[jsonObjects objectAtIndex:0] objectForKey:@"evyaccountid"]);
    
    return [NSString stringWithFormat:@"%@",[[jsonObjects objectAtIndex:0] objectForKey:@"evyaccountid"]];
}

@end
