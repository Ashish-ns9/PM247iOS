//
//  AppDelegate.m
//  Partner Maintenance


#import "AppDelegate.h"

#import "SWRevealViewController.h"

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <UNUserNotificationCenterDelegate>
@end
#endif

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()<SWRevealViewControllerDelegate>

@end

@implementation AppDelegate
@synthesize frontNavigationController,nav,classidentifier;
@synthesize isDatabase,strMsgCount;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize currentUserlatitude,currentUserlongitude,arrApplianceInspection;

@synthesize locationManager,currentLocation;

NSString *const kGCMMessageIDKey = @"gcm.message_id";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //******************** Fire base notification setup
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // [START configure_firebase]
    [FIRApp configure];
    // [END configure_firebase]
    
    // [START set_messaging_delegate]
    [FIRMessaging messaging].delegate = self ;
    // [FIRMessaging messaging].delegate = self;
    //[FIRMessaging messaging].shouldEstablishDirectChannel = YES;
    // [END set_messaging_delegate]
    
    // Register for remote notifications. This shows a permission dialog on first run, to
    // show the dialog at a more appropriate time move this registration accordingly.
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier. Disable the deprecation warnings.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
#pragma clang diagnostic pop
    } else {
        // iOS 8 or later
        // [START register_for_notifications]
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [application registerUserNotificationSettings:settings];
        } else {
            // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            // For iOS 10 display notification (sent via APNS)
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            }];
#endif
        }
        
        [application registerForRemoteNotifications];
        // [END register_for_notifications]
    }
    
    //**********************************
    //[self getUniqueDeviceIdentifierAsString:@""];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        //Location setup
        if (locationManager==nil) {
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
        }
        locationManager.distanceFilter =100;
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        [self requestAlwaysAuthorization];
        [locationManager startUpdatingLocation];
        isRunning=NO;
    }
              
    isDatabase=@"1";
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = _window;
    self.window.backgroundColor=[UIColor whiteColor];
    
    [self registerForRemoteNotification];
    NSDictionary *pushDict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(pushDict)
    {
        [self application:application didReceiveRemoteNotification:pushDict];
    }
    _menuCount=0;
    Login *frontViewController;
    CGSize screenSize=[[UIScreen mainScreen]bounds].size;
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if (screenSize.height==568.0f)
        {
            frontViewController=[[Login alloc]initWithNibName:@"Login" bundle:nil];
        }
        else if(screenSize.height == 667.0f)
        {
            frontViewController=[[Login alloc]initWithNibName:@"Login6" bundle:nil];
        }
        else if(screenSize.height == 736.0f)
        {
            frontViewController=[[Login alloc]initWithNibName:@"Login6Plus" bundle:nil];
        }
        else
        {
            frontViewController=[[Login alloc]initWithNibName:@"Login4S" bundle:nil];
        }
    }
    else
    {
        //iPad
    }
    frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    frontNavigationController.navigationBar.hidden=YES;
    revealController = [[SWRevealViewController alloc] initWithfrontViewController:frontNavigationController];
    revealController.delegate = self;
    
    Menu *rightViewController;
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if (screenSize.height==568.0f)
        {
            rightViewController =[[Menu alloc] initWithNibName:@"Menu" bundle:nil];
        }
        else if(screenSize.height == 667.0f)
        {
            rightViewController =[[Menu alloc] initWithNibName:@"Menu6" bundle:nil];
        }
        else if(screenSize.height == 736.0f)
        {
            rightViewController =[[Menu alloc] initWithNibName:@"Menu6Plus" bundle:nil];
        }
        else
        {
            rightViewController =[[Menu alloc] initWithNibName:@"Menu4S" bundle:nil];
        }
    }
    else
    {
        //iPad
    }
    
    rightViewController.tab_Menu.backgroundColor = [UIColor clearColor];
    revealController.rightViewController = rightViewController;
    self.viewController = revealController;
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    NSString *text = [[url host] stringByRemovingPercentEncoding];
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Text"
                                                                        message:text
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle: @"OK"
                                                                style: UIAlertActionStyleDestructive
                                                              handler: ^(UIAlertAction *action) {
        // NSLog(@"Dismiss button tapped!");
    }];
    [controller addAction: alertActionCancel];
    [self.viewController presentViewController: controller animated: YES completion: nil];
    return YES;
}


-(void)navigateToControllerWithUserInfo:(NSDictionary*)userInfo
{
    NSDictionary *dic=[userInfo objectForKey:@"aps"];
    NSString *string = [dic objectForKey:@"alert"];
    
    if ([string rangeOfString:@"message"].location != NSNotFound)
    {
        
        Messages *mssg =[[Messages alloc] initWithNibName:@"Messages" bundle:Nil];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mssg];
        [revealController setFrontViewController:navigationController animated:YES];
        
    }
    else
    {
        frontNavigationController = (id)revealController.frontViewController;
        
        if ( ![frontNavigationController.topViewController isKindOfClass:[DashBoard class]] )
        {
            DashBoard *frontViewController;
            CGSize screenSize=[[UIScreen mainScreen]bounds].size;
            if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
            {
                if (screenSize.height==568.0f)
                {
                    frontViewController=[[DashBoard alloc] initWithNibName:@"DashBoard" bundle:Nil];
                }
                else if(screenSize.height == 667.0f)
                {
                    frontViewController=[[DashBoard alloc] initWithNibName:@"DashBoard6" bundle:Nil];
                }
                else if(screenSize.height == 736.0f)
                {
                    frontViewController=[[DashBoard alloc] initWithNibName:@"DashBoard6Plus" bundle:Nil];
                }
                else
                {
                    frontViewController=[[DashBoard alloc] initWithNibName:@"DashBoard4S" bundle:Nil];
                }
            }
            
            else
            {
                //iPad
            }
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
            [revealController setFrontViewController:navigationController animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadView" object:self userInfo:UserInfoNotification];
        }
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        [locationManager stopUpdatingLocation];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locationManager setDistanceFilter:kCLDistanceFilterNone];
        locationManager.pausesLocationUpdatesAutomatically = NO;
        locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")){
            
            if ([self.locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
                [self.locationManager setAllowsBackgroundLocationUpdates:YES];
            }
        }
        [locationManager startMonitoringSignificantLocationChanges];
        [locationManager startUpdatingLocation];
        
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        [locationManager startUpdatingLocation];
    }
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        [locationManager stopUpdatingLocation];
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self requestAlwaysAuthorization];
        [locationManager startUpdatingLocation];
    }
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    UIViewController* root = _window.rootViewController;
    SWRevealViewController* Controller = (SWRevealViewController*)root;
    UINavigationController *navC =(UINavigationController *)Controller.frontViewController;
    Login *mycontroller=(Login *)[[navC viewControllers]objectAtIndex:0];
    [mycontroller reloadInputViews];
    [self GetMessageCount];
    
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Databse Save Context Method
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Core Data stack
// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Partner" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Partner.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)registerForRemoteNotification
{
    [[UIApplication sharedApplication]  registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}
#endif

// Delegation methods
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    /* NSString* deviceToken = [[[[devToken description]
     stringByReplacingOccurrencesOfString: @"<" withString: @""]
     stringByReplacingOccurrencesOfString: @">" withString: @""]
     stringByReplacingOccurrencesOfString: @" " withString: @""];*/
    
    // self.DeviceToken=deviceToken;
    
    // [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceToken"];
    // [self getUniqueDeviceIdentifierAsString:deviceToken];
    
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ( application.applicationState == UIApplicationStateActive )
    {
        // app was already in the foreground
        NSString *message = nil;
        NSDictionary *dic=[userInfo objectForKey:@"aps"];
        UserInfoNotification =[NSDictionary dictionaryWithDictionary:dic];
        
        id alert = [dic objectForKey:@"alert"];
        if ([alert isKindOfClass:[NSString class]]) {
            message = alert;
        } else if ([alert isKindOfClass:[NSDictionary class]]) {
            message = [alert objectForKey:@"body"];
        }
        if (alert)
        {
            
            NSString *string = [UserInfoNotification objectForKey:@"alert"];
            NSString *msg = @"";
            
            if ([string rangeOfString:@"Message"].location != NSNotFound)
            {
                msg=[NSString stringWithFormat:@"Unread messages:%@",[GlobalDirector ReplaceStringNull:[userInfo valueForKey:@"Count"]]];
                strMsgCount = [GlobalDirector ReplaceStringNull:[userInfo valueForKey:@"Count"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCount" object:self userInfo:nil];
            }
            
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:message
                                                                                message:msg
                                                                         preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle: @"OK"
                                                                        style: UIAlertActionStyleDestructive
                                                                      handler: ^(UIAlertAction *action) {
                NSLog(@"Dismiss button tapped!");
            }];
            
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Check Now"
                                                                  style: UIAlertActionStyleDestructive
                                                                handler: ^(UIAlertAction *action) {
                NSLog(@"Dismiss button tapped!");
                
                [self alertCall];
            }];
            
            [controller addAction: alertActionCancel];
            [controller addAction: alertAction];
            [self.viewController presentViewController: controller animated: YES completion: nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadView" object:self userInfo:dic];
        }
    }
    [self performSelector:@selector(UpdateEngineerLocation) withObject:nil];
}
-(void)alertCall{
    {
        
        NSString *string = [UserInfoNotification objectForKey:@"alert"];
        if ([string rangeOfString:@"Message"].location != NSNotFound)
        {
            Messages *mssg =[[Messages alloc] initWithNibName:@"Messages" bundle:Nil];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mssg];
            [revealController setFrontViewController:navigationController animated:YES];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadView" object:self userInfo:UserInfoNotification];
            frontNavigationController = (id)revealController.frontViewController;
            
            if ( ![frontNavigationController.topViewController isKindOfClass:[DashBoard class]] )
            {
                DashBoard *frontViewController;
                CGSize screenSize=[[UIScreen mainScreen]bounds].size;
                if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
                {
                    if (screenSize.height==568.0f)
                    {
                        frontViewController=[[DashBoard alloc] initWithNibName:@"DashBoard" bundle:Nil];
                    }
                    else if(screenSize.height == 667.0f)
                    {
                        frontViewController=[[DashBoard alloc] initWithNibName:@"DashBoard6" bundle:Nil];
                    }
                    else if(screenSize.height == 736.0f)
                    {
                        frontViewController=[[DashBoard alloc] initWithNibName:@"DashBoard6Plus" bundle:Nil];
                    }
                    else
                    {
                        frontViewController=[[DashBoard alloc] initWithNibName:@"DashBoard4S" bundle:Nil];
                    }
                }
                else
                {
                    //iPad
                }
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                [revealController setFrontViewController:navigationController animated:YES];
            }
        }
        
    }
}
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    
    DLog(@"Error in registration. Error: %@", err);
}



-(void)GetMessageCount
{
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    
    
    
    GlobalDirector *globe = [GlobalDirector SharedDirector];
    
    
    
    [globe SyncRequestGet:REQUEST_GetMessageCount withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        
        
        NSLog(@"MSG:%@",result);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            @try {
                BOOL strValue= [result valueForKey:@"ResponseStatus"];
                if (strValue==1)
                {
                    strMsgCount = [GlobalDirector ReplaceStringNull:[result valueForKey:@"ReturnValue"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCount" object:self userInfo:nil];
                    
                }
                
            } @catch (NSException *exception) {
                ;
            }
        });
        
    }];
}


#pragma Location updating

- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:title
                                                                            message:message
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle: @"Cancel"
                                                                    style: UIAlertActionStyleDestructive
                                                                  handler: ^(UIAlertAction *action) {
            NSLog(@"Dismiss button tapped!");
        }];
        
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Settings"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
            NSLog(@"Dismiss button tapped!");
            
            // Send the user to the Settings for this app
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:settingsURL];
        }];
        
        [controller addAction: alertActionCancel];
        [controller addAction: alertAction];
        
        
        
        [self.viewController presentViewController: controller animated: YES completion: nil];
        
        
        
        
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    NSLog(@"Update Latitude:%f Longitude:%f",locations.lastObject.coordinate.latitude,locations.lastObject.coordinate.longitude);
    currentLocation= locations.lastObject;
    // [self performSelector:@selector(UpdateEngineerLocation) withObject:nil];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationUpdate" object:self userInfo:nil];
    }
    
    if (isRunning==NO) {
        isRunning=YES;
        [self performSelector:@selector(UpdateEngineerLocation) withObject:nil afterDelay:60];
    }
    
    
}

/*- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
 {
 
 NSLog(@"New Location:%@",newLocation);
 
 }*/

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
    NSLog(@"Location Error: %@",error.description);
}






-(void)UpdateEngineerLocation{
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        
        isRunning=NO;
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        NSString *currentTime = [dateFormatter stringFromDate:today];
        
        
        NSString *lat = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
        NSString *log = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
        
        NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
        [dict setObject:@"0" forKey:@"jobID"];
        [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserID"]] forKey:@"userID"];
        [dict setObject:[GlobalDirector ReplaceStringNull:lat] forKey:@"locLat"];
        [dict setObject:[GlobalDirector ReplaceStringNull:log] forKey:@"locLong"];
        [dict setObject:@"5" forKey:@"enggRunningStatusID"];//5
        [dict setObject:@"0" forKey:@"arrivalWithIn"];//0
        [dict setObject:currentTime forKey:@"updatedTime"];// 10:07 AM
        [dict setObject:@"" forKey:@"position"];
        GlobalDirector *globe = [GlobalDirector SharedDirector];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [globe SyncRequestGet:REQUEST_SetEnggCurrentLocation withPrams:dict andCompletionHandler:^(NSDictionary *result) {
            
            NSLog(@"%@",result);
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
        }];
    }
}
#pragma mark- Firebase notification

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}
// [END receive_message]

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    //open call first
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    //***1
    // Print full message.
    NSLog(@"%@", userInfo);
    [self NotificationPopup:userInfo];
    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionNone);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
#if defined(__IPHONE_11_0)
         withCompletionHandler:(void(^)(void))completionHandler {
#else
withCompletionHandler:(void(^)())completionHandler {
#endif
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    // if ( [UIApplication sharedApplication].applicationState == UIApplicationStateActive )
    // app was already in the foreground
    [self NotificationPopup:userInfo];
    
    completionHandler();
}
#endif
    // [END ios_10_message_handling]
    
    // [START refresh_token]
    - (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
        NSLog(@"FCM registration token: %@", fcmToken);
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        NSString *token = [FIRMessaging messaging].FCMToken;
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"deviceToken"];
        
    }
    - (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
        NSLog(@"Received data message: %@", [[remoteMessage.appData valueForKey:@"aps"] valueForKey:@"alert"]);
        
    }
    -(void)NotificationPopup:(NSDictionary*)userInfo{
        
        NSString *message = nil;
        NSDictionary *dic=[userInfo objectForKey:@"aps"];
        UserInfoNotification =[NSDictionary dictionaryWithDictionary:dic];
        
        id alert = [dic objectForKey:@"alert"];
        if ([alert isKindOfClass:[NSString class]]) {
            message = alert;
        } else if ([alert isKindOfClass:[NSDictionary class]]) {
            message = [alert objectForKey:@"body"];
        }
        if (alert)
        {
            NSString *string = [UserInfoNotification objectForKey:@"alert"];
            NSString *msg = @"";
            
            if ([string rangeOfString:@"Message"].location != NSNotFound)
            {
                msg=[NSString stringWithFormat:@"Unread messages:%@",[GlobalDirector ReplaceStringNull:[userInfo valueForKey:@"Count"]]];
                strMsgCount = [GlobalDirector ReplaceStringNull:[userInfo valueForKey:@"Count"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCount" object:self userInfo:nil];
            }
            
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:message
                                                                                message:msg
                                                                         preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle: @"OK"
                                                                        style: UIAlertActionStyleDestructive
                                                                      handler: ^(UIAlertAction *action) {
                NSLog(@"Dismiss button tapped!");
            }];
            
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Check Now"
                                                                  style: UIAlertActionStyleDestructive
                                                                handler: ^(UIAlertAction *action) {
                NSLog(@"Dismiss button tapped!");
                
                [self alertCall];
            }];
            
            [controller addAction: alertActionCancel];
            [controller addAction: alertAction];
            [self.viewController presentViewController: controller animated: YES completion: nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadView" object:self userInfo:dic];
        }
        
        [self performSelector:@selector(UpdateEngineerLocation) withObject:nil];
    }
@end
    
