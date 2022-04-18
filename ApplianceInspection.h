//
//  ApplianceInspection.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>

@protocol ApplianceInspectionDelegate <NSObject>

@optional

-(void)ApplianceDidAddedWithData:(NSArray *)datas;


@end

@interface ApplianceInspection : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UITextField *Activetxtfld;
    UITableView *tblView;
    NSArray *arrFeedTblPopup;
    NSMutableArray *arrApplianceData;
    CGPoint PreScroll;
    
}

@property (strong, nonatomic)  NSMutableArray *arrApplianceData;
@property (strong, nonatomic) IBOutlet UIButton *btnAddAppLian;

@property(retain,nonatomic)NSMutableDictionary *dataApplianceDetails;
@property (strong, nonatomic) IBOutlet UITableView *tblApplianceList;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollForm;

@property (strong, nonatomic) IBOutlet UITextField *txtLocation;
@property (strong, nonatomic) IBOutlet UITextField *txtApplicaceType;
@property (strong, nonatomic) IBOutlet UITextField *txtApplianceMake;
@property (strong, nonatomic) IBOutlet UITextField *txtAplianceModel;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segFuelType;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segLandlordAppliance;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segApplianceInspected;


@property (strong, nonatomic) IBOutlet UITextField *txtOperatingPress;
@property (strong, nonatomic) IBOutlet UITextField *txtHeatInput;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segsafetydevice;


@property (strong, nonatomic) IBOutlet UISegmentedControl *segVentilationProvision;


@property (strong, nonatomic) IBOutlet UISegmentedControl *segvisualcondition;


@property (strong, nonatomic) IBOutlet UISegmentedControl *segFuelperformence;


@property (strong, nonatomic) IBOutlet UISegmentedControl *segApplianceserviced;


@property (strong, nonatomic) IBOutlet UISegmentedControl *segappliancesafetouse;


@property(weak,nonatomic)id<ApplianceInspectionDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *txt1stCO;
@property (strong, nonatomic) IBOutlet UITextField *txt1stCO2;
@property (strong, nonatomic) IBOutlet UITextField *txt1stRatio;
@property (strong, nonatomic) IBOutlet UITextField *txt2ndCO;
@property (strong, nonatomic) IBOutlet UITextField *txt2ndCO2;
@property (strong, nonatomic) IBOutlet UITextField *txt2ndRatio;
@property (strong, nonatomic) IBOutlet UITextField *txt3rdCO;
@property (strong, nonatomic) IBOutlet UITextField *txt3rdCO2;
@property (strong, nonatomic) IBOutlet UITextField *txt3rdRatio;

@property (strong, nonatomic) IBOutlet UITextView *txtVwDetailsOfAnyFault;
@property (strong, nonatomic) IBOutlet UITextView *txtVwRemidialWork;


@property (strong, nonatomic) IBOutlet UISegmentedControl *segWarningNotice;
- (IBAction)btnsegWarningNotice:(id)sender;
- (IBAction)btnAddGasForms:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtWarningNoticeNo;

@property (strong, nonatomic) IBOutlet UIButton *btnsubmit;
- (IBAction)btnSubmitapped:(id)sender;

- (IBAction)btnbacktapped:(id)sender;

- (IBAction)btnLocationtapped:(id)sender;
- (IBAction)btnApplianceTypetapped:(id)sender;
- (IBAction)btnApplianceMaketapped:(id)sender;
@end
