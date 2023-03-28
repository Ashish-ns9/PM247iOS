//
//  ManagerJobDetails.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "SignAgreement.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "SignAgreement.h"
#import "AddNotes.h"
#import "AddJobPayment.h"
#import "AddMaterials.h"
#import "AddcostViewController.h"
#import "AddNotes.h"
#import "Map_show.h"
#import "CreateJobEng.h"
#import "Messages.h"
#import "FinancialVC.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "GasForms.h"
#import "GlobalDirector.h"
#import "HelpWidgetVC.h"

@interface ManagerJobDetails : ViewController<SWRevealViewControllerDelegate,NSURLConnectionDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MFMessageComposeViewControllerDelegate,UITextViewDelegate>

{
    
    float  subtotalValueFixed;
    NSMutableDictionary *dicPhoneSMS;
    
    NSMutableArray *arrPQNotes;
    UITextView *txtvNoteBodyPriceQoute;
    
    UIView *mainBgunassign,*bgVwUnassign,*mainBg;
    
    
    NSMutableDictionary *dicManagerJobDetails;
    UIControl *bgVw;
    UIScrollView *popUpVW;
    
    
    NSMutableDictionary *dicFE;
    NSMutableArray *arrMFE;
    UITextView *  txtvCancelNoteBody;
    NSString *enggName;
    
    NSMutableArray *arrMselectedFE,*arrMallocatedFE;
    UILabel *imgvstatusCrcl;
    
    UIActivityIndicatorView *_activity;
    NSMutableData *_responseData;
    NSURLConnection *connEnggSelection ;
    NSInteger Count , etaCount;
    
    
   
    
    UITextField *txtTimeAllowancedropdown,*txtEnggCommision,*txtSubtotalValue;
    
    UIDatePicker *datepicker,*timePicker;
    id actvtextbox;
    UIToolbar* numberToolbar;
    
    NSMutableDictionary *dicAllocatedFE1;
    NSMutableArray *arrMAllocatedFE1;
    NSURLConnection *connRequestedFE;
    NSURLConnection *connAvailableEngg,*connEnggSendMail,*connSaveFixedPrice;
    
    NSURLConnection *connActivateJobbyengineer,*connlogin;
    
    BOOL IsAccepted;
    
    NSTimer *blinkTimer;
    NSString *strAfterallocated;
    
    
    UITableView *tblView;
    UITextField *Activetxtfld;
    NSArray *arrFeedTblPopup;
    
    UIButton *btnPhoneCall,*btnPhoneSms,*btnEmail;
    UIButton *btnFinancial;
    
   
    //--------- Add Message Section --------------
    UIView *mainBgmssg,*bgVwmssg;
    UIButton *btnCrossmssg;
    UITextView *txtvMessageBodymssg;
    UIButton *btnMessagePostmssg;
    UITextField *txtUserTypemssg,*txtUserNamemssg;
    NSURLConnection *connSendMessage;
    
    NSURLConnection *connSendMessageOwner;
    
    IBOutlet UIButton *btnAddFixedPrice;
    NSArray *arrRecipientList;
    NSMutableArray *arrSelectedRecipients,*arrSelectedRecipientsIds;
    NSString *engNumber;
    
    
    BOOL isCancel;
    
    
}



@property (strong, nonatomic) IBOutlet UITextField *txtPurchOrder;
@property (strong, nonatomic) IBOutlet UIButton *btnCall;
@property (strong, nonatomic) IBOutlet UIButton *btnjobTypeSms;

@property (strong, nonatomic) IBOutlet UIButton *btnMsg;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
- (IBAction)helpWidgetBtnJobDetail:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *helpWidgetBtnJobDetail;

@property (strong, nonatomic) IBOutlet UIButton *btnJobactivationbyEngineer;
-(IBAction)pressJobactivationbyEngineer:(id)sender;

//HelpWidgetBtn
@property (strong, nonatomic) IBOutlet UIButton *helpWidgetBtn;
- (IBAction)helpWidgetBtn:(id)sender;



@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,retain)NSMutableDictionary *dicManagerJobDetails;
@property (strong, nonatomic) IBOutlet UIButton *btnSlideMenu;

@property (strong, nonatomic) IBOutlet UIButton *btnEditJOb;

@property (strong, nonatomic) IBOutlet UITextField *txtDatejobPost;
@property (strong, nonatomic) IBOutlet UITextField *txtEndtime;

@property (strong, nonatomic) IBOutlet UITextField *txtTypeofOrganization;
@property (strong, nonatomic) IBOutlet UITextField *txtAdressContactNo;
@property (strong, nonatomic) IBOutlet UITextField *txtCountry;
@property (strong, nonatomic) IBOutlet UITextField *txtCityTown;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtContactNo;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtFixedPrice;

@property (strong, nonatomic) IBOutlet UITextField *txtTypeOfAddress;

@property (strong, nonatomic) IBOutlet UITextView *txtAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtzipCode;
@property (strong, nonatomic) IBOutlet NSDictionary *dictData1;
@property (strong, nonatomic) IBOutlet UITextField *txtNatureOfJob;
@property (strong, nonatomic) IBOutlet UITextField *txtNameOfOrganisation;

@property (strong, nonatomic) IBOutlet UITextField *txtContactPerson;
@property (strong, nonatomic) IBOutlet UITextField *txtAdvertisingChannel;
@property (strong, nonatomic) IBOutlet UITextField *txtRecreatedFromInvoice;

@property (strong, nonatomic) IBOutlet UITextField *txtPaymentMode;
@property (strong, nonatomic) IBOutlet UITextField *txtTitle;

@property (strong, nonatomic) IBOutlet UITextField *txtTypeOfCustomer;

@property (strong, nonatomic) IBOutlet UITextView *txtvJobDescription;


@property (strong, nonatomic) IBOutlet UITextView *txtvRemarks;
@property (strong, nonatomic) IBOutlet UITextView *txtvwUserNote;


- (IBAction)btnchkAvailTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnChkAvl;
@property (strong, nonatomic) IBOutlet UIButton *btnchkAvlCopy;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;


@property (strong, nonatomic) IBOutlet UIScrollView *scrolVw;

@property(strong,nonatomic)NSMutableArray *arrEnggAccepted;
@property(strong,nonatomic)NSString *stausCell;

@property (strong, nonatomic) IBOutlet UIView *vwAfterAllocation;
@property (strong, nonatomic) IBOutlet UIButton *btnAgrrement;
@property (strong, nonatomic) IBOutlet UIButton *btnAdNotes;
@property (strong, nonatomic) IBOutlet UIButton *btnPayment;
@property (strong, nonatomic) IBOutlet UIButton *btnMap;
@property (strong, nonatomic) IBOutlet UIView *vwBeforeAllocation;

- (IBAction)agreementPress:(id)sender;

//- (IBAction)notePress:(id)sender;
//- (IBAction)paymentPress:(id)sender;

- (IBAction)mapPress:(id)sender;
-(IBAction)backPress:(id)sender;
-(IBAction)poundSignTapped:(id)sender;



@property (strong, nonatomic) IBOutlet UILabel *lblJobDetails;
@property (strong, nonatomic) IBOutlet UILabel *lblCustomerdetails;
@property (strong, nonatomic) IBOutlet UILabel *lblAddressDetails;
@property (strong, nonatomic) IBOutlet UILabel *lblRemarks;
@property (strong, nonatomic) IBOutlet UILabel *lblRemarks1;
@property (strong, nonatomic) IBOutlet UILabel *lblJobDescription;


- (IBAction)btnOwnerTapped:(id)sender;
- (IBAction)btnLandlordTapped:(id)sender;
- (IBAction)btnTenantTapped:(id)sender;

- (IBAction)btnJobAdressTapped:(id)sender;
- (IBAction)btnBillingAdressTapped:(id)sender;
- (IBAction)btnLandlordAdressTapped:(id)sender;

- (IBAction)btnNotesTapped:(id)sender;
- (IBAction)btnMaterialsTapped:(id)sender;
- (IBAction)btnCostTapped:(id)sender;
- (IBAction)btnEditJobPressed:(id)sender;
- (IBAction)callCustomer:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtEngineer;

@property (strong, nonatomic) IBOutlet UIView *viewCusType;
@property (strong, nonatomic) IBOutlet UIButton *btnOwner;
@property (strong, nonatomic) IBOutlet UIButton *btnLandlord;
@property (strong, nonatomic) IBOutlet UIButton *btnTenant;
@property (strong, nonatomic) IBOutlet UIImageView *selected,*selected2;

@property (strong, nonatomic) IBOutlet UIButton *btnJobAdress;
@property (strong, nonatomic) IBOutlet UIButton *btnBillingAdress;

@property (strong, nonatomic) IBOutlet UIButton *btnLandlordAdress;

@property (strong, nonatomic) IBOutlet UIButton *btnNotes;
@property (strong, nonatomic) IBOutlet UIButton *btnMaterials;
@property (strong, nonatomic) IBOutlet UIButton *btnCosts;

@property (strong, nonatomic) IBOutlet UITextField *txtTimeAllowance;
@property (strong, nonatomic) IBOutlet UITextField *txtMainContactNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtJobPrice;
@property (strong, nonatomic) IBOutlet UITextField *txtJobStatus;
@property (strong, nonatomic) IBOutlet UIButton *btnEngCall;

@property (strong, nonatomic) IBOutlet UIButton *btnOwnerEmailSend;
-(IBAction)pressOwnerEmailSend:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnMessagePress;
-(IBAction)pressMessage:(id)sender;

- (IBAction)pressGasCertList:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnGasCertList;
@property (weak, nonatomic) IBOutlet UITextField *txtfdEnggEtATime;
@property (strong, nonatomic) IBOutlet UITextField *txtfdManagerEtatime;


@property (strong, nonatomic) IBOutlet UIView *txtvwETa;
@property (weak, nonatomic) IBOutlet UITextField *txtfdsaveETAEnggTime;
- (IBAction)SaveETabtn:(id)sender;

//@property (weak, nonatomic) IBOutlet UITextField *txtfdMAnagerETAtime;
//
//
//- (IBAction)managerETASavebtn:(id)sender;
//
//@property (strong, nonatomic) IBOutlet UIView *txtVWManagerETA;


@end
