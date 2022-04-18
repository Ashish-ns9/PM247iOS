//
//  GasSafetyNatGas.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ApplianceInspection.h"
#import "FinalChecks.h"
#import "GasFormAdress.h"
#import "AdditionalNotes.h"
#import "Engineersignoff.h"
#import "DefaultSettings.h"
#import "GlobalDirector.h"


@protocol GasSafetyNatGasDelegate <NSObject>

@optional

-(void)CertificateGenerated:(BOOL )status;


@end

@interface GasSafetyNatGas : ViewController<ApplianceInspectionDelegate,finalChecksDelegate,AdressDelegate,AdditionalNoteDelegates,EnggSignOffDelegates,NSURLConnectionDelegate,UIWebViewDelegate,UITextFieldDelegate>
{
    id actvtextbox;
    NSMutableData *_responseData;
    NSString *certLink,*uniqueID;
    NSURLConnection *connEmailGasCert,*connUniqID;

    
    
}

@property (strong, nonatomic) IBOutlet UIButton *btnEmailCert;
@property (strong, nonatomic) IBOutlet UILabel *lblUniqueNo;
@property (strong, nonatomic) IBOutlet UITextField *txtReferenceNo;

@property(strong,nonatomic)UIImage *imgSignRef;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actvUniqno;


@property (strong, nonatomic) IBOutlet UIView *vwCertGas;
@property (strong, nonatomic) IBOutlet UITextField *txtDate;
@property (nonatomic) NSUInteger totalBytes;
@property(retain,nonatomic)NSDictionary *jobDic,*dicFinalChecks;
@property(retain,nonatomic)NSMutableDictionary *GasSafetyNatRecord;
@property(retain,nonatomic) id <GasSafetyNatGasDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *vwPrintCertEmail;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlVW;


- (IBAction)btnBackTapped:(id)sender;

- (IBAction)btnApplianceInspectionTappe:(id)sender;
- (IBAction)btnFinalChecksTapped:(id)sender;
- (IBAction)btnAdressDetailsTapped:(id)sender;
- (IBAction)btnAdditionalNotesTapped:(id)sender;
- (IBAction)btnEngineersignoffTapped:(id)sender;
- (IBAction)btnViewCertificateTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIWebView *webVW;
- (IBAction)hideWeb:(id)sender;


@end
