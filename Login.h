//
//  Login.h
//  Partner Maintenance


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "AppDelegate.h"
#import "DashBoard.h"
#import <QuartzCore/QuartzCore.h>
#import "MyTextField.h"
#import "Reachability.h"

@interface Login : ViewController<UITextFieldDelegate,NSURLConnectionDelegate>
{
   
    NSMutableDictionary *dicUserDetails;
    UIView *viewForgotPassword;
    UIButton *btnOk,*btnCancel;
    UILabel *lblPopUpTitle;
    UITextField *txtPopUpEmailAddress;
  
     NSMutableData *_responseData;
    NSURLConnection *connLogin,*connForgetPass;
    
    UIView *mainBg;
    
    
}
@property (strong, nonatomic) IBOutlet UILabel *lblUsernamebg;
@property (strong, nonatomic) IBOutlet UILabel *lblpasswordbg;


@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UILabel *lblPleaseLogin;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
-(IBAction)loginPress:(id)sender;
-(IBAction)forgotpasswordPress:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@property (strong, nonatomic) IBOutlet UILabel *lblRememberMe;
@property (strong, nonatomic) IBOutlet UIButton *btnRememberMe;
@property (strong, nonatomic) IBOutlet UISwitch *offlinechk;
-(IBAction)rememberMePress:(id)sender;


@end
