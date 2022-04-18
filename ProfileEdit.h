//
//  ProfileEdit.h
//  Partner Maintenance


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@interface ProfileEdit : ViewController<SWRevealViewControllerDelegate>
{
    NSMutableData *_responseData;
    NSURLConnection *connEditProfile;
}

@property (strong, nonatomic) IBOutlet UIButton *btnSlideMenu;
@property (strong, nonatomic) IBOutlet UIScrollView *scrolView;

@property (strong, nonatomic) IBOutlet UILabel *lblFirstname;
@property (strong, nonatomic) IBOutlet UILabel *lblMiddlename;
@property (strong, nonatomic) IBOutlet UILabel *lblLastname;

@property (strong, nonatomic) IBOutlet UILabel *lblAddress1;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress2;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress3;
@property (strong, nonatomic) IBOutlet UILabel *lblCityTown;
@property (strong, nonatomic) IBOutlet UILabel *lblCountry;
@property (strong, nonatomic) IBOutlet UILabel *lblPostcode;
@property (strong, nonatomic) IBOutlet UILabel *lblMobileno;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;

@property (strong, nonatomic) IBOutlet UITextField *txtFirstname;
@property (strong, nonatomic) IBOutlet UITextField *txtMiddlename;
@property (strong, nonatomic) IBOutlet UITextField *txtLastname;

@property (strong, nonatomic) IBOutlet UITextField *txtAddress1;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress2;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress3;
@property (strong, nonatomic) IBOutlet UITextField *txtCityTown;
@property (strong, nonatomic) IBOutlet UITextField *txtCountry;
@property (strong, nonatomic) IBOutlet UITextField *txtPostcode;
@property (strong, nonatomic) IBOutlet UITextField *txtMobileno;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;

@property (strong, nonatomic) IBOutlet UIButton *btnEditUpdate;
-(IBAction)editupdatePress:(id)sender;
- (IBAction)ChangePrflImg:(id)sender;

@end
