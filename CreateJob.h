//
//  CreateJob.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "AddNotes.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "GlobalDirector.h"
#import "PostCodePopupController.h"
#import "AddSelPopupController.h"


@class SWRevealViewController;


@interface CreateJob : ViewController<SWRevealViewControllerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate,UIPopoverControllerDelegate,UITextViewDelegate,AddNotesDelegates,PostCodePopupControllerDelegate,AddSelPopupControllerDelegate>
{
    UITextField *Activetxtfld,*ActvTextfldOthr;
    UITableView *tblView;
    NSArray *arrFeedTblPopup;
    UIDatePicker *datepicker;
    
    UITextView *actvTxtvw;
    
    NSMutableDictionary *dicOwnerDetails,*dicLandLordDetails,*dicTenantDetails,*dicJobAddress,*dicBillingAddress,*dicLandLordAdress,*SelectedUserDic,*selectedAddressDic;
    
    id actvtextbox;
    
    NSMutableArray *arrCustomeradditionalNotes;
    BOOL copyJobAddr;
    
    MBProgressHUD *hud;;
    NSMutableData *_responseData;
    NSURLConnection *connPostNote;
    
    NSString *connIdentifier;
    
    NSMutableArray *arrMSavedContactNumber;
    BOOL isContactsave;
   
    
    
}

@property (strong, nonatomic) IBOutlet UITextField *txtPurchOrder;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (nonatomic) NSUInteger totalBytes;
@property (nonatomic) NSUInteger receivedBytes;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UIScrollView *scrolVw;
@property (strong, nonatomic) IBOutlet UIButton *btnCreateJOb;
@property(strong,nonatomic)IBOutlet UIButton *btnSlideMenu;
@property (strong, nonatomic) IBOutlet UIButton *btnCancelCreateJob;
@property (strong, nonatomic) IBOutlet UITextField *txtStartDate;
@property (strong, nonatomic) IBOutlet UITextField *txtAdvertiseChannel;
@property (strong, nonatomic) IBOutlet UITextField *txtTypeofOrganization;
@property (strong, nonatomic) IBOutlet UITextField *txtJobStatus;
@property (strong, nonatomic) IBOutlet UITextField *txtCountry;
@property (strong, nonatomic) IBOutlet UITextField *txtCityTown;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtContactNo;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;

@property (strong, nonatomic) IBOutlet UITextField *txtTypeOfAddress;

@property (strong, nonatomic) IBOutlet UITextView *txtAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtzipCode;
@property (strong, nonatomic) IBOutlet UITextField *txtNatureOfJob;
@property (strong, nonatomic) IBOutlet UITextField *txtNameOfOrganisation;
@property (strong, nonatomic) IBOutlet UIView *vwAddress;

@property (strong, nonatomic) IBOutlet UITextField *txtContactPerson;
@property (strong, nonatomic) IBOutlet UITextField *txtTimeAllowance;

@property (strong, nonatomic) IBOutlet UITextField *txtAddrContactNo;
@property (strong, nonatomic) IBOutlet UITextField *txtRecreatedFromInvoice;
@property (strong, nonatomic) IBOutlet UITextField *txtPaymentMode;
@property (strong, nonatomic) IBOutlet UITextField *txtTitle;

@property (strong, nonatomic) IBOutlet UITextField *txtTypeOfCustomer;

@property (strong, nonatomic) IBOutlet UITextView *txtvJobDescription;
@property (strong, nonatomic) IBOutlet UITextView *txtvRemarks;
@property (strong, nonatomic) IBOutlet UITextView *txtvwUserNote;

- (IBAction)jobSubmitPress:(id)sender;
- (IBAction)jobCancelPress:(id)sender;

-(IBAction)backPress:(id)sender;


//+(NSArray *)FetchDropDowns:(NSString *)key;

@property (strong, nonatomic) IBOutlet UIButton *btnAddJobNote;
- (IBAction)addJobNoteTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblJobDetails;
@property (strong, nonatomic) IBOutlet UILabel *lblCustomerdetails;
@property (strong, nonatomic) IBOutlet UILabel *lblAddressDetails;
@property (strong, nonatomic) IBOutlet UILabel *lblRemarks;
@property (strong, nonatomic) IBOutlet UILabel *lblJobDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblRemarks1;
@property (strong, nonatomic) IBOutlet UIControl *vwCopyJobAddr;


- (IBAction)btnOwnerTapped:(id)sender;
- (IBAction)btnLandlordTapped:(id)sender;
- (IBAction)btnTenantTapped:(id)sender;
- (IBAction)btnJobAdressTapped:(id)sender;
- (IBAction)btnBillingAdressTapped:(id)sender;
- (IBAction)btnLandlordAdressTapped:(id)sender;
- (IBAction)CopyJobAdress:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imgvwTickCopyJobAdrr;



@property (strong, nonatomic) IBOutlet UIView *viewCusType;
@property (strong, nonatomic) IBOutlet UIButton *btnOwner;
@property (strong, nonatomic) IBOutlet UIButton *btnLandlord;
@property (strong, nonatomic) IBOutlet UIButton *btnTenant;
@property (strong, nonatomic) IBOutlet UIImageView *selected,*selected2;
@property (strong, nonatomic) IBOutlet UIButton *btnJobAdress;
@property (strong, nonatomic) IBOutlet UIButton *btnBillingAdress;

@property (strong, nonatomic) IBOutlet UIButton *btnLandlordAdress;



@end
