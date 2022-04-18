//
//  WarningNotice.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "WarningDetails.h"
#import "GasFormAdress.h"
#import "Engineersignoff.h"
#import "MBProgressHUD.h"
#import "DefaultSettings.h"
#import "GlobalDirector.h"
@interface WarningNotice : ViewController<WarningDetailsDelegates,AdressDelegate,EnggSignOffDelegates,UIWebViewDelegate>
{
    id actvtextbox;
    
    NSURLConnection *connUniqID,*connEmailGasCert;
    NSMutableData *_responseData;
    NSString *uniqueID,*certLink;
}

@property (strong, nonatomic) IBOutlet UILabel *lblUniqueNo;

@property(retain,nonatomic)NSDictionary *jobDic;
@property(retain,nonatomic)NSMutableDictionary *WarningDetails;

@property (strong, nonatomic) IBOutlet UITextField *txtDate;
- (IBAction)btnBackTapped:(id)sender;

- (IBAction)btnWarningDetailsTapped:(id)sender;
- (IBAction)btnAdressDetailsTapped:(id)sender;
- (IBAction)btnEngineersignoffTapped:(id)sender;
- (IBAction)btnViewCertTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *viewEmailCert;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlVw;
@property (strong, nonatomic) IBOutlet UIView *vwCertGas;
@property (strong, nonatomic) IBOutlet UIWebView *webVW;
@property(strong,nonatomic)UIImage *imgSignRef;
@property(strong,nonatomic)IBOutlet UIActivityIndicatorView *actvUniqno;
@property (nonatomic) NSUInteger totalBytes;

@end
