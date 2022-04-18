//
//  CustomerRegistration.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import "GlobalDirector.h"
#import "ViewController.h"
#import "PostCodePopupController.h"
@class GlobalDirector;
@interface CustomerRegistration : ViewController <PostCodePopupControllerDelegate,SWRevealViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIPickerViewDelegate>
{
    id actvtextbox;
    UITableView *tblView;
    NSURLSessionDataTask * dataTask;
    NSArray *arrFeedTblPopup,*arrOrgType,*arrOrgTypeId;
    NSString *strPerTypeID,*strOrgTypeID,*strPersonTypeID,*strTitleTypeID,*strGenderTypeID;
    bool keyboardIsShown;
    
    NSArray *pickerArray;
  
    
}


@property (strong, nonatomic) IBOutlet UITextField *txtPerType;
@property (strong, nonatomic) IBOutlet UITextField *txtOrgType;
@property (strong, nonatomic) IBOutlet UITextField *txtOrgName;
@property (strong, nonatomic) IBOutlet UITextField *txtTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtGender;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtMobile;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;
@property (strong, nonatomic) IBOutlet UITextView *txtVAddress;

@property (strong, nonatomic) IBOutlet UITextField *txtTown;
@property (strong, nonatomic) IBOutlet UITextField *txtPost;
@property (strong, nonatomic) IBOutlet UITextField *txtcont;
@property (strong, nonatomic) IBOutlet UITextView *txtVNote;
@property (strong, nonatomic) IBOutlet UITextField *txtUserName;
@property (strong, nonatomic) IBOutlet UITextField *txtpwd;
@property (strong, nonatomic) IBOutlet UITextField *txtPwdCon;
@property (strong, nonatomic) IBOutlet UIButton *btnSlideMenu;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollVw;
@property (strong, nonatomic) IBOutlet UILabel *lblAddMan;





//popup mobile
@property (strong, nonatomic) IBOutlet UIView *mobileMainView;
@property (strong, nonatomic) IBOutlet UITextField *txtPopMob;
- (IBAction)ClickMobileVerify:(UIButton *)sender;

- (IBAction)CrossClick:(UIButton *)sender;


//popupPostcode

@property (strong, nonatomic) IBOutlet UIView *postMainView;
@property (strong, nonatomic) IBOutlet UITextField *txtPopPost;

//- (IBAction)ClickPostVerify:(UIButton *)sender;
//- (IBAction)CrossClickPost:(UIButton *)sender;


//Address

@property (strong, nonatomic) IBOutlet UIView *viewAddre;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;


//- (IBAction)ClickSubmitPicker:(UIButton *)sender;
//- (IBAction)CrossAddressPicker:(UIButton *)sender;


@end
