//
//  GasForms.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "ViewController.h"

#import "GasSafetyNatGas.h"
#import "ServicingRecord.h"
#import "MaintainanceCheklist.h"
#import "WarningNotice.h"
#import "BoilerCommissioning.h"
#import "GasFormcell.h"
#import "PJRSignatureView.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "GlobalDirector.h"

@class GasSafetyNatGas;
@protocol GasFormDelegate <NSObject>

@optional

-(void)GasFormCreated:(BOOL )status;


@end

@interface GasForms : ViewController<GasSafetyNatGasDelegate,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,NSURLConnectionDelegate,MaskingDelegate>
{
    BOOL isGasCertCreated;
    
    NSString *strIdentifier;
    NSURLConnection *connGaslist,*connGetInvoiceLink,*conndropboxipload,*connEmailGas;
    NSMutableData *_responseData;
    
    NSMutableArray *arrMGasCertList;
    
    UIView *mainBgNoteDesc;
    UIButton *btnCrossNoteDesc;
    UIScrollView *bgVwNoteDesc;
    UIButton *btnPrint,*btnEmail,*btnDropbox;
    UISegmentedControl *segmentedControl;
    
    BOOL isJobDetailsPageRedirect;
    BOOL isAcceptPageRedirect;
    
    UIControl *bgVw;
    PJRSignatureView *scratchableView;
    
    NSString *strbtnGasSafetyNatGas;
    NSString *strbtnGasBreakdown;
    NSString *strbtnServiceMaintenance;
    NSString *strbtnGasWarningNotice;
    NSString *strbtnGasBoilerComm;
    IBOutlet UIView *viewCustomer1stAgreement;
    NSString *signURL;
    BOOL imgCheckSignature;
    IBOutlet UIImageView *ImgSignCustm;
    NSString *strGasListSignatureUrl;
}
@property(nonatomic,assign)BOOL isJobDetailsPageRedirect;
@property(nonatomic,assign)BOOL isAcceptPageRedirect;

@property (strong, nonatomic) IBOutlet UITableView *tabGasForms;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollGasForm;
@property (strong, nonatomic) IBOutlet UIButton *btnGasSafetyNatGas;
@property (strong, nonatomic) IBOutlet UIButton *btnGasSafetyLPG;
@property (strong, nonatomic) IBOutlet UIButton *btnGasBreakdown;
@property (strong, nonatomic) IBOutlet UIButton *btnServiceMaintenance;
@property (strong, nonatomic) IBOutlet UIButton *btnGasWarningNotice;
@property (strong, nonatomic) IBOutlet UIButton *btnGasBoilerComm;
@property(strong,nonatomic)UIImage *imgSign;
@property(weak,nonatomic)id<GasFormDelegate> delegate;

- (IBAction)btnGasSafetyNatGasTapped:(id)sender;
//- (IBAction)btnGasSafetyLPGTapped:(id)sender;
- (IBAction)btnGasBreakdownTapped:(id)sender;
- (IBAction)btnServiceMaintenanceTapped:(id)sender;
- (IBAction)btnGasWarningNoticeTapped:(id)sender;
- (IBAction)btnGasBoilerCommtapped:(id)sender;
- (IBAction)btnAddGasForms:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnnAddGasForms;
@property (strong, nonatomic) IBOutlet UIButton *btnBackTapped;
- (IBAction)backbtnTapped:(id)sender;
@property(retain,nonatomic)NSDictionary *jobDic;
-(void)preparingAutographPad;
-(void)cleanPress:(id)sender;
- (UIImage*)captureView:(UIView *)view;
@end
