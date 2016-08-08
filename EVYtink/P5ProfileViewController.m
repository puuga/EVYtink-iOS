//
//  P5ProfileViewController.m
//  EVYtink
//
//  Created by roomlinksaas_dev on 7/15/2559 BE.
//  Copyright © 2559 roomlinksaas_dev. All rights reserved.
//

#import "P5ProfileViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "LoginFacebook.h"
#import <UIImageView+AFNetworking.h>
#import "P5ProfilePostViewController.h"
#import "FBSDKCoreKit.framework/Headers/FBSDKCoreKit.h"
#import "FBSDKLoginKit.framework/Headers/FBSDKLoginKit.h"
#import "FBSDKShareKit.framework/Headers/FBSDKShareKit.h"
#import "CommentViewController.h"
#import "ViewWeb.h"
#import <AFNetworking.h>
#import <AFHTTPRequestOperationManager.h>

@interface P5ProfileViewController (){
    BOOL _didStartMonitoringRegion;
    NSMutableArray *arrProfileContent;
    BOOL chkEffect;
    NSString *evyUId;
}

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation P5ProfileViewController
@synthesize locationManager,notificationGeofence,imgUser,imgBGUser,tableView,imgVNotlogin,loginBtProperties,postBtProperties,lbUserName;

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"Did Update locations.");
    if (locations && [locations count] && !_didStartMonitoringRegion) {
        // Update Helper
        _didStartMonitoringRegion = YES;
        
        // Fetch Current Location
        CLLocation *location = [locations objectAtIndex:0];
        
        // Initialize Region to Monitor
        //CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:[location coordinate] radius:250.0 identifier:[[NSUUID UUID] UUIDString]];
        /*
         CLLocationCoordinate2D coordinate;
         coordinate.latitude = 13.841302;
         coordinate.longitude = 100.557236;
         CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:coordinate radius:200 identifier:@"Bank"];
         
         
         // Start Monitoring Region
         //[locationManager startMonitoringForRegion:region];
         //[locationManager stopMonitoringForRegion:region];
         [locationManager stopUpdatingLocation];
         */
        // Update Table View
        //[geofences addObject:region];
        
        NSLog(@"update location");
        
    }
}

-(void)notificationAction:(NSString *)place messageForNotification:(NSString *)message{
    UIUserNotificationType types = UIUserNotificationTypeBadge| UIUserNotificationTypeSound| UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = [NSString stringWithFormat:@"%@ - %@",place,message];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval= NSCalendarUnitDay;
    localNotification.soundName= UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Entered Regoin : %@",region.identifier);
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Geofence" inManagedObjectContext:context];
    NSFetchRequest *NSrequest = [[NSFetchRequest alloc] init];
    [NSrequest setEntity:entityDesc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"placeName LIKE '%@'",region.identifier]];
    [NSrequest setPredicate:predicate];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:NSrequest error:&error];
    NSLog(@"object count - %lu, show Id: %@",[objects count],[[objects objectAtIndex:0] valueForKey:@"objId"]);
    
    
    if ([FBSDKAccessToken currentAccessToken]) {
         NSLog(@"Login Facebook");
         NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/evycheckfbloginjson.aspx?evarfid=%@",[[FBSDKAccessToken currentAccessToken] userID]]]];
         
         id jsData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
         NSString *post = [NSString stringWithFormat:@"location_id=%@&user_id=%@&action=%@&app_id=5",[[objects objectAtIndex:0] valueForKey:@"objId"],[[jsData objectAtIndex:0] objectForKey:@"evyaccountid"],@"ENTER"];
         [self postGeofenceToServer:post];
     }else{
         NSString *post = [NSString stringWithFormat:@"location_id=%@&user_id=%@&action=%@&app_id=5",[[objects objectAtIndex:0] valueForKey:@"objId"],@"0",@"ENTER"];
         [self postGeofenceToServer:post];
     }
    [self notificationAction:[NSString stringWithFormat:@"%@",region.identifier] messageForNotification:@"เข้าสู่"];
}

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data{
    NSLog(@"Receive data");
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Fail with error");
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"Finish Connection");
}
-(void)postGeofenceToServer:(NSString *)urlString{
    NSLog(@"POST - %@",urlString);
    NSData *postData = [urlString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://128.199.133.166/roomlink/track_geo.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
    NSLog(@"Success post");
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Entered Regoin : %@",region.identifier);
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Geofence" inManagedObjectContext:context];
    NSFetchRequest *NSrequest = [[NSFetchRequest alloc] init];
    [NSrequest setEntity:entityDesc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"placeName LIKE '%@'",region.identifier]];
    [NSrequest setPredicate:predicate];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:NSrequest error:&error];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Login Facebook");
        NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/evycheckfbloginjson.aspx?evarfid=%@",[[FBSDKAccessToken currentAccessToken] userID]]]];
        
        id jsData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSString *post = [NSString stringWithFormat:@"location_id=%@&user_id=%@&action=%@&app_id=5",[[objects objectAtIndex:0] valueForKey:@"objId"],[[jsData objectAtIndex:0] objectForKey:@"evyaccountid"],@"EXIT"];
        [self postGeofenceToServer:post];
    }else{
        NSString *post = [NSString stringWithFormat:@"location_id=%@&user_id=%@&action=%@&app_id=5",[[objects objectAtIndex:0] valueForKey:@"objId"],@"0",@"EXIT"];
        [self postGeofenceToServer:post];
    }
    [self notificationAction:[NSString stringWithFormat:@"%@",region.identifier] messageForNotification:@"ออกจาก"];
    
    
    
    
    [locationManager stopUpdatingLocation];
}

-(void)viewDidAppear:(BOOL)animated{
    [self checkLocationGeofence];
    if ([FBSDKAccessToken currentAccessToken]) {
        evyUId = [self getEvyId];
        [self showUserLogin];
    }else{
        [self viewnotlogin];
    }
    if (chkEffect!=YES) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
        effectView.frame = imgBGUser.frame;
        effectView.alpha = 0.95f;
        [imgBGUser addSubview:effectView];
        chkEffect = YES;
    }
}

-(void)viewnotlogin{
    imgUser.image = nil;
    imgBGUser.image = nil;
    imgBGUser.hidden = YES;
    _varLogout.hidden = YES;
    imgUser.hidden = YES;
    tableView.hidden = YES;
    imgVNotlogin.hidden = NO;
    loginBtProperties.hidden = NO;
    postBtProperties.enabled = NO;
    [postBtProperties setTintColor:[UIColor clearColor]];
}

-(void)showUserLogin{
    imgBGUser.hidden = NO;
    _varLogout.hidden = NO;
    imgUser.hidden = NO;
    tableView.hidden = NO;
    imgVNotlogin.hidden = YES;
    loginBtProperties.hidden = YES;
//    postBtProperties.enabled = YES;
//    [postBtProperties setTintColor:nil];
    postBtProperties.enabled = NO;
    [postBtProperties setTintColor:[UIColor clearColor]];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email,picture.width(200).height(200)" forKey:@"fields"];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             lbUserName.text = [result objectForKey:@"name"];
             [imgUser setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]]]];
             [imgBGUser setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]]]];
         }
     }];
    
    arrProfileContent = [[NSMutableArray alloc] init];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonnewsbyid.aspx?evarid=%@",[self getEvyId]]]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"show count - %d",[responseObject count]);
        if ([responseObject count]==0) {
            [tableView reloadData];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ยังไม่มีโพสของคุณ" message:@"กดแชร์ข้อความเพื่อเพิ่มโพสแรกของคุณ" delegate:nil cancelButtonTitle:@"ยืนยัน" otherButtonTitles:nil, nil];
            [alert show];
        }
        for (int i = 0; i<[responseObject count]; i++) {
            NSLog(@"arrprofile No.%d - %@",i,[responseObject objectAtIndex:i]);
            [arrProfileContent addObject:[responseObject objectAtIndex:i]];
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Not Success afnetworking.,%@",error);
    }];
    [operation start];
    
}

-(void)checkLocationGeofence{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if ([AFStringFromNetworkReachabilityStatus(status) isEqualToString:@"Not Reachable"]) {
            NSLog(@"Not Connecting.");
        }else{
            NSLog(@"Connecting.");
            
            
            //NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://128.199.133.166/roomlink/location.php?app_id=5"]];
            //id [responseObject objectAtIndex:i] = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://128.199.133.166/roomlink/location.php?app_id=5"]]];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
            operation.responseSerializer = [AFJSONResponseSerializer serializer];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                //Delete Last Geofence.
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                NSManagedObjectContext *context = [appDelegate managedObjectContext];
                NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Geofence" inManagedObjectContext:context];
                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                [request setEntity:entityDesc];
                NSError *error;
                NSArray *objects = [context executeFetchRequest:request error:&error];
                if ([objects count] == 0) {
                    NSLog(@"ไม่มีข้อมูล");
                } else {
                    NSLog(@"มีข้อมูล %lu ข้อมูล",[objects count]);
                    for (int i=0; i<[objects count]; i++) {
                        for (NSManagedObject *managedObject in objects) {
                            CLCircularRegion *region = [self convertDataToCLCircularRegion:[managedObject valueForKey:@"region"]];
                            NSLog(@"ข้อมูล %@",region);
                            [locationManager stopMonitoringForRegion:region];
                            [context deleteObject:managedObject];
                        }
                    }
                    [self removeGeoFence:objects];
                }
                //Insert new Geofence.
                NSLog(@"Count - %d",[[responseObject objectForKey:@"location"] count]);
                for (int i = 0; i<[[responseObject objectForKey:@"location"] count]; i++) {
                    NSArray *addGeofence = [[NSArray alloc]initWithObjects:[[responseObject objectForKey:@"location"] objectAtIndex:i],[NSNumber numberWithInteger:0],[self getCurrentDatetimeToString], nil];
                    NSLog(@"Res - %@",[[responseObject objectForKey:@"location"] objectAtIndex:i]);
                    
                    NSManagedObject *newContact;
                    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Geofence" inManagedObjectContext:context];
                    [newContact setValue:[[[responseObject objectForKey:@"location"] objectAtIndex:i] objectForKey:@"id"] forKey:@"objId"];
                    [newContact setValue:[[[responseObject objectForKey:@"location"] objectAtIndex:i] objectForKey:@"name"] forKey:@"placeName"];
                    [newContact setValue:[NSNumber numberWithDouble:[[[[responseObject objectForKey:@"location"] objectAtIndex:i] objectForKey:@"latitude"] doubleValue]] forKey:@"lattitude"];
                    [newContact setValue:[NSNumber numberWithDouble:[[[[responseObject objectForKey:@"location"] objectAtIndex:i] objectForKey:@"longitude"] doubleValue]] forKey:@"longtitude"];
                    [newContact setValue:[[[responseObject objectForKey:@"location"] objectAtIndex:i] objectForKey:@"enter_message"] forKey:@"messageIn"];
                    [newContact setValue:[[[responseObject objectForKey:@"location"] objectAtIndex:i] objectForKey:@"exit_message"] forKey:@"messageOut"];
                    [newContact setValue:[NSNumber numberWithDouble:[[[[responseObject objectForKey:@"location"] objectAtIndex:i] objectForKey:@"radius"] doubleValue]] forKey:@"radius"];
                    
                    //create region
                    CLLocationCoordinate2D coordinate;
                    coordinate.latitude = (CLLocationDegrees)[[NSNumber numberWithDouble:[[[[responseObject objectForKey:@"location"] objectAtIndex:i] objectForKey:@"latitude"] doubleValue]] doubleValue];
                    coordinate.longitude = (CLLocationDegrees)[[NSNumber numberWithDouble:[[[[responseObject objectForKey:@"location"] objectAtIndex:i] objectForKey:@"longitude"] doubleValue]] doubleValue];
                    
                    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:coordinate radius:[[NSNumber numberWithDouble:[[[[responseObject objectForKey:@"location"] objectAtIndex:i] objectForKey:@"radius"] doubleValue]] doubleValue] identifier:[NSString stringWithFormat:@"%@",[[[responseObject objectForKey:@"location"] objectAtIndex:i] objectForKey:@"name"]]];
                    NSLog(@"degree = %@",region);
                    
                    //Add and working Region.
                    [locationManager startMonitoringForRegion:region];
                    
                    NSData *dataRegion = [self convertCLCircularRegionToData:region];
                    
                    [newContact setValue:dataRegion forKey:@"region"];
                    NSError *error;
                    [context save:&error];
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Not Success afnetworking.");
            }];
            [operation start];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

-(NSData *)convertCLCircularRegionToData:(CLCircularRegion *)region{
    NSData *dataRegion = [NSKeyedArchiver archivedDataWithRootObject:region];
    return dataRegion;
}

-(CLCircularRegion *)convertDataToCLCircularRegion:(NSData *)data{
    CLCircularRegion *backtoRegion = (CLCircularRegion *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    return backtoRegion;
}

-(void)removeGeoFence:(NSObject *)objDel{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSLog(@"context show : %@",context);
    
    //[context deleteObject:objDel];
}

-(NSString *)getCurrentDatetimeToString{
    NSDate *currentDateTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:currentDateTime];
}

-(void)setNavigationTitle{
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:self action:@selector(revealToggle:)];
    anotherButton.image = [[UIImage imageNamed:@"LeftMenuevylogo.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    anotherButton.target = self.revealViewController;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.navigationItem.leftBarButtonItem = anotherButton;
    
    UIImage* logoImage = [UIImage imageNamed:@"TopCenterlogoevytink.png"];
    UIImageView *uiimagelogoImage = [[UIImageView alloc] initWithImage:logoImage];
    uiimagelogoImage.frame = CGRectMake(75, 0, 100, 44);
    [uiimagelogoImage setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = uiimagelogoImage;
}

-(void)setTabbar{
    [[self.tabBarController.tabBar.items objectAtIndex:0] setImage:[[UIImage imageNamed:@"TabProfile.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setImage:[[UIImage imageNamed:@"TabTimeline.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[self.tabBarController.tabBar.items objectAtIndex:2] setImage:[[UIImage imageNamed:@"TabNewsicon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[self.tabBarController.tabBar.items objectAtIndex:3] setImage:[[UIImage imageNamed:@"TabEventicon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[self.tabBarController.tabBar.items objectAtIndex:4] setImage:[[UIImage imageNamed:@"TabPromoicon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self.tabBarController.tabBar.items objectAtIndex:0].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [self.tabBarController.tabBar.items objectAtIndex:1].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [self.tabBarController.tabBar.items objectAtIndex:2].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [self.tabBarController.tabBar.items objectAtIndex:3].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [self.tabBarController.tabBar.items objectAtIndex:4].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    locationManager = [[CLLocationManager alloc] init];
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    if (authorizationStatus != kCLAuthorizationStatusAuthorizedAlways) {
        [locationManager requestAlwaysAuthorization];
    }
    
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    [self setNavigationTitle];
    [self setTabbar];

    imgUser.layer.cornerRadius = 50;
    imgUser.clipsToBounds = YES;
    imgUser.layer.borderWidth = 3.0f;
    imgUser.layer.borderColor = [UIColor whiteColor].CGColor;
    
    static NSString *CellIdentifier1 = @"idenCell1";
    static NSString *CellIdentifier2 = @"idenCell2";
    static NSString *CellIdentifier3 = @"idenCell3";
    UINib *nib1 = [UINib nibWithNibName:@"CustomCell1" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:CellIdentifier1];
    
    UINib *nib2 = [UINib nibWithNibName:@"CustomCell2" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:CellIdentifier2];
    
    UINib *nib3 = [UINib nibWithNibName:@"CustomCell3" bundle:nil];
    [self.tableView registerNib:nib3 forCellReuseIdentifier:CellIdentifier3];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSManagedObjectContext *)managedObjectContext{
    return [(AppDelegate *)[[UIApplication sharedApplication]delegate]managedObjectContext];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrProfileContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier1 = @"idenCell1";
    static NSString *CellIdentifier2 = @"idenCell2";
    static NSString *CellIdentifier3 = @"idenCell3";
    if ([[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"imageurl"]isEqualToString:@"no"]) {
        P1CellCustom1 *cell = (P1CellCustom1 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        cell.delegate = self;
        if (![cell.txtDetail.text isEqualToString:[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];
            
            cell.indexAction = indexPath;
            cell.EvyUserId = evyUId;
            cell.strObjId = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"newsevyid"];
            cell.txtName.text = [[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"publishtitle"];
            cell.userPostId = [[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
            cell.txtDate.text = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.urlToShow = [NSString stringWithFormat:@"%@",[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"url"]];
            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]]];
        }
        return cell;
    }else if ([[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]isEqualToString:@"no"]){
        P1CellCustom2 *cell = (P1CellCustom2 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        cell.delegate = self;
        if (![cell.txtDetail.text isEqualToString:[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];
            
            cell.indexAction = indexPath;
            cell.EvyUserId = evyUId;
            cell.strObjId = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"newsevyid"];
            cell.txtName.text = [[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"publishtitle"];
            cell.userPostId = [[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
            cell.txtDate.text = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.urlToShow = [NSString stringWithFormat:@"%@",[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"url"]];
            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]]];
            [cell.imgPic1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"imageurl"]]]];
        }
        return cell;
    }else{
        P1CellCustom3 *cell = (P1CellCustom3 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        cell.delegate = self;
        if (![cell.txtDetail.text isEqualToString:[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"title"]]) {
            NSString *string = [NSString stringWithFormat:@"%@",[[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
            NSArray *subString = [string componentsSeparatedByString:@"?"];
            NSString *urlimg = subString[0];
            NSURL *urlUser = [NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]];
            
            cell.indexAction = indexPath;
            cell.EvyUserId = evyUId;
            cell.strObjId = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"newsevyid"];
            cell.txtName.text = [[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"publishtitle"];
            cell.userPostId = [[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
            cell.txtDate.text = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
            cell.txtDetail.text = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.urlToShow = [NSString stringWithFormat:@"%@",[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"url"]];
            
            [cell.img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?",urlimg]]];
            [cell.imgPic1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"imageurl"]]]];
            [cell.imgPic2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]]]];
        }
        return cell;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([arrProfileContent count]==0) {
        return 100;
    }
    if ([[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"imageurl"]isEqualToString:@"no"]) {
        return 168;
    }else if ([[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]isEqualToString:@"no"]){
        return 400;
    }else{
        return 291;
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

-(NSString *)getEvyId{
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/evycheckfbloginjson.aspx?evarfid=%@",[[FBSDKAccessToken currentAccessToken] userID]]]];
    NSLog(@"U ID - %@",[[FBSDKAccessToken currentAccessToken] userID]);
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"show event form facebook : %@",[[jsonObjects objectAtIndex:0] objectForKey:@"evyaccountid"]);
    
    return [NSString stringWithFormat:@"%@",[[jsonObjects objectAtIndex:0] objectForKey:@"evyaccountid"]];
}

-(BOOL)ChkFacebookLoginStatus{
    if ([FBSDKAccessToken currentAccessToken]) {
        return TRUE;
    }else{
        LoginFacebook *LoginFacebookView = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInF"];
        [self presentViewController:LoginFacebookView animated:YES completion:nil];
        return FALSE;
    }
}

-(void)logout{
    LoginFacebook *LoginFacebookView = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInF"];
    [self presentViewController:LoginFacebookView animated:YES completion:nil];
}

- (IBAction)loginBT:(id)sender {
    LoginFacebook *LoginFacebookView = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInF"];
    [self presentViewController:LoginFacebookView animated:YES completion:nil];
}

- (IBAction)logoutBT:(id)sender {
    [self logout];
}

- (IBAction)postBTAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    P5ProfilePostViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"storyPostProfile"];
    viewController.evyId = [self getEvyId];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)shareToFacebook:(NSString *)urlToShare{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:urlToShare];
    content.placeID = [NSString stringWithFormat:@"%@",[[FBSDKAccessToken currentAccessToken] userID]];
    [FBSDKShareDialog showFromViewController:self withContent:content delegate:nil];
}

-(void)commentTo:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CommentViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"storyComment"];
    
    NSString *string = [NSString stringWithFormat:@"%@",[[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"imgprofile"]];
    NSArray *subString = [string componentsSeparatedByString:@"?"];
    NSString *urlimg = subString[0];
    viewController.statusShared = @"private";
    viewController.userId = [self checkUserId];
    viewController.newsId = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"newsevyid"];
    viewController.txtname = [[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"publishtitle"];
    viewController.userPostId = [[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"evyaccountid"];
    viewController.txtDate = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"evydatetime"];
    viewController.txtDetail = [[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"title"];
    viewController.urlToShow = [NSString stringWithFormat:@"%@",[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"url"]];
    viewController.urlimgUser = [NSString stringWithFormat:@"%@?",urlimg];
    viewController.urlImg1 = [NSString stringWithFormat:@"%@",[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"imageurl"]];
    viewController.urlImg2 = [NSString stringWithFormat:@"%@",[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"imageurl2"]];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(NSString *)checkUserId{
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://evbt.azurewebsites.net/docs/page/theme/evycheckfbloginjson.aspx?evarfid=%@",[[FBSDKAccessToken currentAccessToken] userID]]]];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return [[jsonObjects objectAtIndex:0] objectForKey:@"evyaccountid"];
}

-(void)userPost:(NSString *)idUserPost{
    NSString *strUrl = [NSString stringWithFormat:@"http://evbt.azurewebsites.net/docs/page/theme/evytinkprofile.aspx?evarid=%@",idUserPost];
    ViewWeb *sendWebView = [self.storyboard instantiateViewControllerWithIdentifier:@"openWebView"];
    sendWebView.url = [NSURL URLWithString:strUrl];
    [self presentViewController:sendWebView animated:YES completion:NULL];
}

-(void)editPost:(NSString *)idUserPost indexpath:(NSIndexPath *)indexPath{
    if ([idUserPost isEqualToString:evyUId]) {
        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"จัดการโพส" message:nil preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* edit = [UIAlertAction actionWithTitle:@"แก้ไขโพสต์" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                               {
                                   [self updatePost:idUserPost indexpath:indexPath];
                               }];
        [myAlertController addAction: edit];
        UIAlertAction* del = [UIAlertAction actionWithTitle:@"ลบโพสต์" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  UIAlertController *alertDelete = [UIAlertController alertControllerWithTitle:@"ลบโพสต์" message:@"ยืนยันการลบโพสต์ ?" preferredStyle:UIAlertControllerStyleAlert];
                                  UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"ลบ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                                         {
                                                             [self deletePost:idUserPost objId:[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"newsevyid"]];
                                                         }];
                                  UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                                            {
                                                                
                                                            }];
                                  [alertDelete addAction:confirm];
                                  [alertDelete addAction:cancle];
                                  dispatch_async(dispatch_get_main_queue(), ^ {
                                      [self presentViewController:alertDelete animated:YES completion:nil];
                                  });
                              }];
        [myAlertController addAction: del];
        UIAlertAction* report = [UIAlertAction actionWithTitle:@"รายงานปัญหา" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     [self reportPost:idUserPost indexpath:indexPath];
                                 }];
        [myAlertController addAction: report];
        UIAlertAction* cancle = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     NSLog(@"ยกเลิก");
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        [myAlertController addAction: cancle];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:myAlertController animated:YES completion:nil];
        });
    }else{
        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"จัดการโพส" message:nil preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* report = [UIAlertAction actionWithTitle:@"รายงานปัญหา" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     [self reportPost:idUserPost indexpath:indexPath];
                                 }];
        [myAlertController addAction: report];
        UIAlertAction* cancle = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     NSLog(@"ยกเลิก");
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        [myAlertController addAction: cancle];
        
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:myAlertController animated:YES completion:nil];
        });
    }
}

-(void)deletePost:(NSString *)userId objId:(NSString *)objectId{
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"ยืนยันการลบโพสต์" message:nil preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction* report = [UIAlertAction actionWithTitle:@"ยืนยัน" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 
                                 
                                 AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
                                 NSLog(@"user ID - %@, objectId - %@",userId,objectId);
                                 NSDictionary *jsonParameter = @{@"evarid":userId,@"evarnewsid":objectId,@"evarcommand":@"deletenews",@"evarnewscontent":@""};
                                 
                                 [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonnewsedit.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
                                 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     NSLog(@"Success POST Delete");
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     [self.navigationController popViewControllerAnimated:YES];
                                     [self showUserLogin];
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

-(void)updatePost:(NSString *)userId indexpath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    P5ProfilePostViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"storyPostProfile"];
    viewController.evyId = userId;
    viewController.statusToServer = @"updatenews";
    viewController.statusShared = @"private";
    viewController.objId = [NSString stringWithFormat:@"%@",[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"newsevyid"]];
    viewController.strUpdate = [NSString stringWithFormat:@"%@",[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"title"]];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)reportPost:(NSString *)userId indexpath:(NSIndexPath *)indexPath{
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"รายงานปัญหาโพสต์" message:@"ทำไมคุณถึงต้องรายงาน ?" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"รายงานนี้ไม่เหมาะสม สำหรับ EVYtink" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  [self reportList:userId detailOfReport:@"1" indexpath:indexPath];
                              }];
    UIAlertAction* action2 = [UIAlertAction actionWithTitle:@"เป็นแสปม การหลอกลวงหรือบัญชีปลอม" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  [self reportList:userId detailOfReport:@"2" indexpath:indexPath];
                              }];
    UIAlertAction* action3 = [UIAlertAction actionWithTitle:@"บัญผู้ใช้อาจโดนแฮก" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  [self reportList:userId detailOfReport:@"3" indexpath:indexPath];
                              }];
    UIAlertAction* action4 = [UIAlertAction actionWithTitle:@"ยกเลิก" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  
                              }];
    [myAlertController addAction: action1];
    [myAlertController addAction: action2];
    [myAlertController addAction: action3];
    [myAlertController addAction: action4];
    
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:myAlertController animated:YES completion:nil];
    });
}
-(void)reportList:(NSString *)userId detailOfReport:(NSString *)detail indexpath:(NSIndexPath *)indexPath{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatToDate = [[NSDateFormatter alloc] init];
    [formatToDate setDateFormat:@"d/M/yyyy"];
    NSString *sendDate = [formatToDate stringFromDate:currentDate];
    if ([detail isEqualToString:@"1"]) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSDictionary *jsonParameter = @{@"evyaccountid":userId,@"postid":[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"newsevyid"],@"reportdetail":@"รายงานนี้ไม่เหมาะสม สำหรับ EVYtink",@"posttype":@"news",@"adddatetime":sendDate,@"command":@"savereport"};
        
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonevyreport.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success POST Report");
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST Report - %@",error);
        }];
    }else if ([detail isEqualToString:@"2"]){
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSDictionary *jsonParameter = @{@"evyaccountid":userId,@"postid":[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"newsevyid"],@"reportdetail":@"เป็นแสปม การหลอกลวงหรือบัญชีปลอม",@"posttype":@"news",@"adddatetime":sendDate,@"command":@"savereport"};
        
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonevyreport.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success POST Report");
            

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST Report - %@",error);
        }];
    }else if ([detail isEqualToString:@"3"]){
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSDictionary *jsonParameter = @{@"evyaccountid":userId,@"postid":[[arrProfileContent objectAtIndex:indexPath.row] objectForKey:@"newsevyid"],@"reportdetail":@"บัญผู้ใช้อาจโดนแฮก",@"posttype":@"news",@"adddatetime":sendDate,@"command":@"savereport"};
        
        [manager POST:@"http://evbt.azurewebsites.net/docs/page/theme/betajsonevyreport.aspx" parameters:jsonParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  formData) {
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success POST Report");
            

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Not success POST Report - %@",error);
        }];
    }
    
}

@end
