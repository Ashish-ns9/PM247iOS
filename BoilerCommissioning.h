//
//  BoilerCommissioning.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "BoilerChecks.h"
#import "GasFormAdress.h"
#import "Engineersignoff.h"
#import "MBProgressHUD.h"
#import "DefaultSettings.h"

@interface BoilerCommissioning : ViewController<BoilerChecksDelegate,EnggSignOffDelegates,AdressDelegate,UITextFieldDelegate,UIWebViewDelegate>
{
    id actvtextbox;
    
    NSURLConnection *connUniqID,*connEmailGasCert;
    NSMutableData *_responseData;
    NSString *uniqueID,*certLink;
}
@property (strong, nonatomic) IBOutlet UIView *vwEmailCert;
@property (strong, nonatomic) IBOutlet UILabel *lblUniqueNo;

@property(retain,nonatomic)NSDictionary *jobDic;
@property(retain,nonatomic)NSMutableDictionary *dicBoilerComm;

@property (strong, nonatomic) IBOutlet UITextField *txtDate;

- (IBAction)btnBackTapped:(id)sender;

- (IBAction)btnBoilerChecksTapped:(id)sender;
- (IBAction)btnAdressDetailsTapped:(id)sender;
- (IBAction)btnEngineersignoffTapped:(id)sender;
- (IBAction)btnViewCertTapped:(id)sender;

@property(strong,nonatomic)UIImage *imgSignRef;
@property(strong,nonatomic)IBOutlet UIActivityIndicatorView *actvUniqno;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollVw;
@property (nonatomic) NSUInteger totalBytes;


@end
