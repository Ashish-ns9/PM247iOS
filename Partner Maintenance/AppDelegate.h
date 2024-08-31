//
//  AppDelegate.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "Login.h"
#import "Menu.h"
#import <CoreData/CoreData.h>
#import "DefaultSettings.h"
#import "SSKeychain.h"
#import <CoreLocation/CoreLocation.h>
#import "GlobalDirector.h"

@import Firebase;


@class Login;
@class SWRevealViewController;



@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    double currentUserlatitude,currentUserlongitude;
     NSDictionary *UserInfoNotification;
    SWRevealViewController *revealController;
    bool isRunning;
    
}

@property(retain,nonatomic)CLLocationManager *locationManager;
@property(retain,nonatomic) CLLocation *currentLocation;
@property(nonatomic)NSString *strMsgCount;

 @property(nonatomic,assign)double currentUserlatitude,currentUserlongitude;
@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,retain)NSString *classidentifier;
@property(nonatomic, assign) int menuCount;
@property(nonatomic,retain)UINavigationController *nav;
@property (strong, nonatomic) SWRevealViewController *viewController;
@property(nonatomic,retain)UINavigationController *frontNavigationController;
@property(nonatomic,retain)NSString *isDatabase;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(retain,nonatomic) NSTimer *statusTimer;
//@property(retain ,nonatomic)NSString *DeviceToken;
@property(assign)BOOL fromNotification;

@property (strong, nonatomic)NSArray *arrApplianceInspection;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)GetMessageCount;
-(void)UpdateEngineerLocation;
-(void)requestAlwaysAuthorization;

@end

