//
//  MaintainanceCheklist.h
//  Partner Maintenance


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "GSMCappliancedetails.h"
#import "GSMCappliancechecks.h"
#import "GSMCsafetychecks.h"
#import "GSMCfindings.h"
#import "GasFormAdress.h"
#import "Engineersignoff.h"
#import "MBProgressHUD.h"
#import "DefaultSettings.h"

@interface MaintainanceCheklist : ViewController<GSMFindingsDelegate,GSMSafetyDelegates,GSMApplianceDelegate,GSMApplianceChecksDelegate,AdressDelegate,EnggSignOffDelegates,UIWebViewDelegate>
{
    id actvtextbox;
    
    NSURLConnection *connUniqID,*connEmailGasCert;
    NSMutableData *_responseData;
    NSString *uniqueID,*certLink;
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *segJobType;
- (IBAction)segJobTypePress:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblUniqueNo;
@property (strong, nonatomic) IBOutlet UITextField *txtReferenceNo;
@property (strong, nonatomic) IBOutlet UIView *vwEmailCert;
@property (strong, nonatomic) IBOutlet UITextField *txtDate;
@property(retain,nonatomic)NSDictionary *jobDic;
@property(retain,nonatomic)NSMutableDictionary *MaintainanceCheckList;

@property (strong, nonatomic) IBOutlet UIScrollView *scrlVW;

- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnApplianceDetailsTapped:(id)sender;
- (IBAction)btnApplianceChecksTapped:(id)sender;
- (IBAction)btnSfaetyChecksTapped:(id)sender;
- (IBAction)btnFindingsTapped:(id)sender;
- (IBAction)btnAdressDetailsTapped:(id)sender;
- (IBAction)btnEngineersignoffTapped:(id)sender;
- (IBAction)btnViewCertTapped:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *btnEmailCert;
@property (strong, nonatomic) IBOutlet UIView *vwCertGas;
@property (strong, nonatomic) IBOutlet UIWebView *webVW;
@property(strong,nonatomic)UIImage *imgSignRef;
@property(strong,nonatomic)IBOutlet UIActivityIndicatorView *actvUniqno;
@property (nonatomic) NSUInteger totalBytes;

- (IBAction)hideWeb:(id)sender;

@end
