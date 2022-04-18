//
//  GBSRappliancedetails.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>

@protocol GBSApplianceDelegates <NSObject>

-(void)GBSApplianceRecordData:(NSDictionary *)data;


@end
@interface GBSRappliancedetails : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField *Activetxtfld;
    UITableView *tblView;
    NSArray *arrFeedTblPopup;
    CGPoint preScrollPoint;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(retain,nonatomic)NSMutableDictionary *dicApplianceData;
@property(weak,nonatomic)id <GBSApplianceDelegates>delegate;


@property (strong, nonatomic) IBOutlet UITextField *txtLocation;
@property (strong, nonatomic) IBOutlet UITextField *txtApplianceType;
@property (strong, nonatomic) IBOutlet UITextField *txtApplianceMake;
@property (strong, nonatomic) IBOutlet UITextField *txtApplianceModel;
@property (strong, nonatomic) IBOutlet UITextField *txtApplianceSerialno;
@property (strong, nonatomic) IBOutlet UITextField *txtBurnerMake;
@property (strong, nonatomic) IBOutlet UITextField *txtBurnerModel;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segGasTightnessTestCarriedout;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segGasTightnessTestResult;
- (IBAction)btnGasTightnessTestCarriedouttapped:(id)sender;
- (IBAction)btnGasTightnessTestResulttapped:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txt1stCO;
@property (strong, nonatomic) IBOutlet UITextField *txt1stCO2;
@property (strong, nonatomic) IBOutlet UITextField *txt1stRatio;
@property (strong, nonatomic) IBOutlet UITextField *txt2ndCO;
@property (strong, nonatomic) IBOutlet UITextField *txt2ndCO2;
@property (strong, nonatomic) IBOutlet UITextField *txt2ndRatio;
@property (strong, nonatomic) IBOutlet UITextField *txt3rdCO;
@property (strong, nonatomic) IBOutlet UITextField *txt3rdCO2;
@property (strong, nonatomic) IBOutlet UITextField *txt3rdRatio;

@property (strong, nonatomic) IBOutlet UITextField *txtOperatingPressure;
@property (strong, nonatomic) IBOutlet UITextField *txtHeatInput;

@property (strong, nonatomic) IBOutlet UIButton *btnsubmit;
- (IBAction)btnSubmitapped:(id)sender;

- (IBAction)btnBackTapped:(id)sender;
@end
