//
//  Customer_EngineerJobDetails.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "AddNotes.h"
#import "Messages.h"
#import "GasForms.h"
#import "CustomerFinDtl.h"
#import "SignAgreement.h"
#import "HelpWidgetVC.h"

@interface Customer_EngineerJobDetails : ViewController<SWRevealViewControllerDelegate,AddNotesDelegates,UITextViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary *dicCustomerJobDetails,*dicEngineerJobDetails;
    NSMutableArray *arrNotes;
    
    //--------- Add Message Section --------------
    UIView *bgVwmssg;
    UIScrollView *mainBgmssg;
    UIButton *btnCrossmssg;
    UITextView *txtvMessageBodymssg;
    UIButton *btnMessagePostmssg;
    UITextField *txtUserTypemssg,*txtUserNamemssg;
    UITextField *Activetxtfld;
    UITableView *tblView;
    NSArray *arrFeedTblPopup,*arrRecipientList;
    NSMutableArray *arrSelectedRecipients,*arrSelectedRecipientsIds;
    NSMutableData *_responseData;
    NSURLConnection *connSendMessage;
    
    
}


@property (strong, nonatomic) IBOutlet UIButton *btnAgreement;
- (IBAction)helpWidgetBtnCoustomer:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtPurOrder;
@property (strong, nonatomic) IBOutlet UIButton *btnPayDtl;

@property (strong, nonatomic) IBOutlet UILabel *lblAddress;

@property(nonatomic,retain)NSMutableDictionary *dicCustomerJobDetails,*dicEngineerJobDetails;
@property (strong, nonatomic) IBOutlet UITextField *txtAddvertisementChannel;

@property (strong, nonatomic) IBOutlet UIButton *btnSlideMenu;
@property (strong, nonatomic) IBOutlet UIScrollView *scrolVw;
@property (strong, nonatomic) IBOutlet UITextField *txtDatejobPost;
@property (strong, nonatomic) IBOutlet UITextField *txtTypeofOrganization;
@property (strong, nonatomic) IBOutlet UITextField *txtAdressContactNo;
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
@property (strong, nonatomic) IBOutlet UITextField *txtContactPerson;
//@property (strong, nonatomic) IBOutlet UITextField *txtAdvertisingChannel;
@property (strong, nonatomic) IBOutlet UITextField *txtRecreatedFromInvoice;
@property (strong, nonatomic) IBOutlet UITextField *txtPaymentMode;
@property (strong, nonatomic) IBOutlet UITextField *txtTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtTypeOfCustomer;
@property (strong, nonatomic) IBOutlet UITextView *txtvJobDescription;
@property (strong, nonatomic) IBOutlet UITextView *txtvRemarks;
@property (strong, nonatomic) IBOutlet UITextView *txtvwUserNote;


-(IBAction)backPress:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtTimeAllowance;
@property (strong, nonatomic) IBOutlet UITextField *txtJobstatus;

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


@property (strong, nonatomic) IBOutlet UIView *viewCusType;
@property (strong, nonatomic) IBOutlet UIButton *btnOwner,*btnGasCertList;
@property (strong, nonatomic) IBOutlet UIButton *btnLandlord;
@property (strong, nonatomic) IBOutlet UIButton *btnTenant;
@property (strong, nonatomic) IBOutlet UIImageView *selected,*selected2;

@property (strong, nonatomic) IBOutlet UIButton *btnJobAdress;
@property (strong, nonatomic) IBOutlet UIButton *btnBillingAdress;

@property (strong, nonatomic) IBOutlet UIButton *btnLandlordAdress;

@property (strong, nonatomic) IBOutlet UIButton *btnAdditionalNotesShown;
-(IBAction)shownAdditionalNotes:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnMessagePress;
-(IBAction)pressMessage:(id)sender;
@end
