//
//  CreateJobEng.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "AddcostViewController.h"
#import "AddMaterials.h"
#import "AddNotes.h"
#import "MBProgressHUD.h"
#import "DashBoard.h"
#import "CustomerRegistration.h"
#import "PostCodePopupController.h"
#import "AddSelPopupController.h"
#import "KLCPopup.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalDirector.h"


@interface CreateJobEng : ViewController<AddSelPopupControllerDelegate,PostCodePopupControllerDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate,UITextViewDelegate,AddNotesDelegates,AddMaterialsDelegates,AddCostDelegates>
{
    
    __weak IBOutlet UIButton *newupdateEta;
    NSString *searchText,*JobID;
     UITextField *Activetxtfld,*ActvTextfldOthr;
    id actvtextbox;
    UITableView *tblView;
    NSArray *arrFeedTblPopup,*arrCustomerList;
    
    UIDatePicker *datepicker,*timePicker;
     NSMutableDictionary *dicOwnerDetails,*dicLandLordDetails,*dicTenantDetails,*dicJobAddress,*dicBillingAddress,*dicLandLordAdress,*SelectedUserDic,*selectedAddressDic;
    UIButton *btnUpdateEtaTime;
   
    AddNotes *addNote;
    AddMaterials *addMat;
    AddCostViewController *addcost;
    IBOutlet UIActivityIndicatorView *searchActivity;
    
    NSMutableArray *arradditionalNotes,*arr,*arradditionalMaterials,*arradditionalCost;
    
    MBProgressHUD *hud;
    
    UIActivityIndicatorView *activityOnTextFields;
    NSMutableData *_responseData;
    NSURLConnection *connPostNote, *connLogin,*connForgetPass;
;
    
    
    NSString *connIdentifier;
    
    NSMutableArray *arrMSavedContactNumber;
    BOOL isContactsave;
    
    
    NSArray *pickerArray;
    NSString *selectedAdd;
    NSDictionary *dictAddress;
    
    NSInteger customerID;
    
    bool isNewAddress;

}


@property (strong, nonatomic) IBOutlet UIView *viewCancelNote;
@property (strong, nonatomic) IBOutlet UITextView *txtVCancelNote;
- (IBAction)SaveCancelNote:(UIButton *)sender;




//
@property (strong, nonatomic) IBOutlet UIView *viewNotePopup;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segNote;
@property (strong, nonatomic) IBOutlet UITextView *txtNoteDesComplete;
@property (weak, nonatomic) IBOutlet UIButton *newupdate;


@property (strong, nonatomic) IBOutlet UITextField *txtPurchOrder;
@property (nonatomic) NSUInteger totalBytes;
@property (nonatomic) NSUInteger receivedBytes;


@property(assign)BOOL isJobEdited;
@property(retain,nonatomic)NSDictionary *jobDic;

@property(strong,nonatomic)IBOutlet UILabel *lblAddress;
@property(strong,nonatomic)IBOutlet UIButton *btnSlideMenu;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollVw;
@property (strong, nonatomic) IBOutlet UIView *vwMatCostNoteBottomBar;




@property (strong, nonatomic) IBOutlet UITextField *txtSelectCustomer;

@property (strong, nonatomic) IBOutlet UITextField *txtstartdate;
@property (strong, nonatomic) IBOutlet UITextField *txtAdvertiseChannel;
@property (strong, nonatomic) IBOutlet UITextField *txtMainConNumber;

//@property (strong, nonatomic) IBOutlet UITextField *txtCustomerAddress;
@property (strong, nonatomic) IBOutlet UITextView *txtCustomerAddress;

@property (strong, nonatomic) IBOutlet UITextField *txtCustomerTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstname;
@property (strong, nonatomic) IBOutlet UITextField *txtLastname;
@property (strong, nonatomic) IBOutlet UITextField *txtContactNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtEmailAddress;
@property (strong, nonatomic) IBOutlet UITextView *txtvwUserNote;
@property (strong, nonatomic) IBOutlet UITextView *txtVwJobDesc;


@property (strong, nonatomic) IBOutlet UITextField *txtOrganizationType;
@property (strong, nonatomic) IBOutlet UITextField *txtOrganizationName;

@property (strong, nonatomic) IBOutlet UITextField *txtPostcode;
@property (strong, nonatomic) IBOutlet UITextField *txtCountry;
@property (strong, nonatomic) IBOutlet UITextField *txtCityTown;
@property (strong, nonatomic) IBOutlet UITextField *txtTelephoneNo;
@property (strong, nonatomic) IBOutlet UITextView *txtRemarks;
@property (strong, nonatomic) IBOutlet UITextField *txtStartTime;
@property (weak, nonatomic) IBOutlet UITextField *txtEndTime;


@property (strong, nonatomic) IBOutlet UITextField *txtTimeAllowance;
@property (strong, nonatomic) IBOutlet UITextField *txtJobPrice;
@property (strong, nonatomic) IBOutlet UITextField *txtJobStatus;
@property (strong, nonatomic) IBOutlet UITextField *txtJobType;


@property (strong, nonatomic) IBOutlet UIButton *btnsubmit;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
-(IBAction)submitPress:(id)sender;
-(IBAction)cancelPress:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblFinanceJobdescription;




- (IBAction)btnOwnerTapped:(id)sender;
- (IBAction)btnLandlordTapped:(id)sender;
- (IBAction)btnTenantTapped:(id)sender;

- (IBAction)btnJobAdressTapped:(id)sender;
- (IBAction)btnBillingAdressTapped:(id)sender;
- (IBAction)btnLandlordAdressTapped:(id)sender;

- (IBAction)btnJobMatTapped:(id)sender;
- (IBAction)btnJobCostTapped:(id)sender;
- (IBAction)btnJobNoteTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnJobMat;
@property (strong, nonatomic) IBOutlet UIButton *btnJobCost;
@property (strong, nonatomic) IBOutlet UIButton *btnJobNote;



@property (strong, nonatomic) IBOutlet UIView *viewCusType;

@property (strong, nonatomic) IBOutlet UIButton *btnOwner;
@property (strong, nonatomic) IBOutlet UIButton *btnLandlord;
@property (strong, nonatomic) IBOutlet UIButton *btnTenant;

@property (strong, nonatomic) IBOutlet UIImageView *selected,*selected2;

@property (strong, nonatomic) IBOutlet UIButton *btnJobAdress;
@property (strong, nonatomic) IBOutlet UIButton *btnBillingAdress;
@property (strong, nonatomic) IBOutlet UIButton *btnLandlordAdress;

@property (weak, nonatomic) IBOutlet UITextField *txtfdETAtime;

- (IBAction)btnSaveETATime:(UIButton *)sender;


@property (strong, nonatomic) IBOutlet UIView *viewActivenote;

@property (weak, nonatomic) IBOutlet UITextField *txtfdLastEtatime;



@end
