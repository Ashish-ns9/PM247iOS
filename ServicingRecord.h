//
//  ServicingRecord.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "GBSRappliancedetails.h"
#import "GBSRappliancechecks.h"
#import "GBSRfaults.h"
#import "GBSRadditionalnotes.h"
#import "GasFormAdress.h"
#import "Engineersignoff.h"
#import "MBProgressHUD.h"
#import "DefaultSettings.h"
#import "GlobalDirector.h"


@interface ServicingRecord : ViewController<GBSAdditionalNoteDelegate,GBSAppliaceCheckDelegate,GBSApplianceDelegates,GBSFaultsDelegates,AdressDelegate,EnggSignOffDelegates,UIWebViewDelegate>
{
    id actvtextbox;
    
    NSURLConnection *connUniqID,*connEmailGasCert;
    NSMutableData *_responseData;
    NSString *uniqueID,*certLink;
    
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *segJobType;
- (IBAction)segJobTypePress:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnEmailCert;
@property (strong, nonatomic) IBOutlet UILabel *lblUniqueNo;
@property (strong, nonatomic) IBOutlet UITextField *txtReferenceNo;
@property (strong, nonatomic) IBOutlet UIView *vwCertGas;
@property (strong, nonatomic) IBOutlet UITextField *txtDate;
@property (strong, nonatomic) IBOutlet UIWebView *webVW;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlVW;

@property(retain,nonatomic)NSDictionary *jobDic;
@property(retain,nonatomic)NSMutableDictionary *ServiceRecord;

@property(strong,nonatomic)UIImage *imgSignRef;
@property(strong,nonatomic)IBOutlet UIActivityIndicatorView *actvUniqno;
@property (nonatomic) NSUInteger totalBytes;
@property (strong, nonatomic) IBOutlet UIView *vwEmailCert;


- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnApplianceDetailsTapped:(id)sender;
- (IBAction)btnApplianceChecksTapped:(id)sender;
- (IBAction)btnFaultsTapped:(id)sender;
- (IBAction)btnAdditionalNotesTapped:(id)sender;
- (IBAction)btnAdressDetailsTapped:(id)sender;
- (IBAction)btnEngineersignoffTapped:(id)sender;
- (IBAction)btnViewCertTapped:(id)sender;
//- (IBAction)hideWeb:(id)sender;





@end
