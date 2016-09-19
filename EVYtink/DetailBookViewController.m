//
//  DetailBookViewController.m
//  EVYbook
//
//  Created by roomlinksaas_dev on 8/19/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "DetailBookViewController.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import <AFURLSessionManager.h>
#import <UIProgressView+AFNetworking.h>
#import "AppDelegate.h"

@interface DetailBookViewController (){
    float percentdownload;
}


@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation DetailBookViewController
@synthesize txtView,imgCover,strTextView,urlImgCover,urlDownload,fileName,downloadBtProperties,progressBar,objBookId,EvyId,deleteBookBtProperties;

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBar.topItem.title = @"ย้อนกลับ";
    txtView.text = strTextView;
    [imgCover setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlImgCover]]];
    [self chkTestCoredata];
    downloadBtProperties.layer.cornerRadius = 4;
    downloadBtProperties.layer.borderWidth = 1;
    downloadBtProperties.layer.borderColor = [UIColor colorWithRed:51.0f/255.0f green:153.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor;
    deleteBookBtProperties.layer.cornerRadius = 4;
    deleteBookBtProperties.layer.borderWidth = 1;
    deleteBookBtProperties.layer.borderColor = [UIColor colorWithRed:204.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f].CGColor;
}

-(void)chkTestCoredata{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"TableBook" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if ([objects count] == 0) {
        NSLog(@"ไม่มีข้อมูล");
    } else {
        NSLog(@"มีข้อมูล");
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"objId LIKE '%@'",objBookId]];
        [request setPredicate:predicate];
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        if ([objects count]>0) {
            NSLog(@"object count - %d, show Id: %@",[objects count],[[objects objectAtIndex:0] valueForKey:@"objId"]);
            [downloadBtProperties setTitle:@"เปิดอ่าน" forState:UIControlStateNormal];
        }else{
            NSLog(@"ยังไม่มีข้อมูลหนังสือนี้");
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSData *)convertFileBookToData:(NSURL *)url{
    NSData *dataFile = [NSData dataWithContentsOfURL:url];
    return dataFile;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)downloadBtAction:(id)sender {
    if ([downloadBtProperties.titleLabel.text isEqualToString:@"เปิดอ่าน"]) {
        NSLog(@"เปิดอ่าน");
    }else{
        NSLog(@"ดาวน์โหลด");
    }
}

- (IBAction)deleteBookBtAction:(id)sender {
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"ยืนยันการลบหนังสือ" message:nil preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction* report = [UIAlertAction actionWithTitle:@"ยืนยัน" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 
                                 
                                 AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
                                 NSDictionary *jsonParameter = @{@"evytinkebookshelfId":objBookId,@"evyaccountid":EvyId};
                                 
                                 [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsondeletebookonshelf.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
                                 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     NSLog(@"Success POST Delete");
                                     
                                     //Delete Current Book.
                                     AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                                     NSManagedObjectContext *context = [appDelegate managedObjectContext];
                                     NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"TableBook" inManagedObjectContext:context];
                                     NSFetchRequest *request = [[NSFetchRequest alloc] init];
                                     [request setEntity:entityDesc];
                                     NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"objId LIKE '%@'",objBookId]];
                                     [request setPredicate:predicate];
                                     NSError *error;
                                     NSArray *objects = [context executeFetchRequest:request error:&error];
                                     for (NSManagedObject *managedObject in objects) {
                                         [context deleteObject:managedObject];
                                         NSLog(@"ลบใน Coredata เรียบร้อย");
                                     }
                                     
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     [self.navigationController popViewControllerAnimated:YES];
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"Not success POST delete - %@",error);
                                 }];
                                 
                             }];
    [myAlertController addAction: report];
    UIAlertAction* cancle = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    [myAlertController addAction: cancle];
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:myAlertController animated:YES completion:nil];
    });
}

@end
