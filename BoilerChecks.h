//
//  BoilerChecks.h
//  Partner Maintenance
//

#import <UIKit/UIKit.h>

@protocol BoilerChecksDelegate <NSObject>

-(void)BoilerChecksRecordData:(NSDictionary *)data;


@end



@interface BoilerChecks : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField *Activetxtfld;
    UITableView *tblView;
    NSArray *arrFeedTblPopup;
}


- (IBAction)btnBackTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong,nonatomic)NSMutableDictionary *dicBoilerChkData;
@property(weak,nonatomic)id <BoilerChecksDelegate>delegate;

@property (strong, nonatomic) IBOutlet UITextField *txtLocation;
@property (strong, nonatomic) IBOutlet UITextField *txtapplianceMake;
@property (strong, nonatomic) IBOutlet UITextField *txtApplianceModel;
@property (strong, nonatomic) IBOutlet UITextField *txtapplianceSerialno;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segControls1;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControls2;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControls3;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControls4;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControls5;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControls6;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControls7;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControls8;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControls9;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControls10;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControls11;


- (IBAction)btnsegControls1:(id)sender;
- (IBAction)btnsegControls2:(id)sender;
- (IBAction)btnsegControls3:(id)sender;
- (IBAction)btnsegControls4:(id)sender;
- (IBAction)btnsegControls5:(id)sender;
- (IBAction)btnsegControls6:(id)sender;
- (IBAction)btnsegControls7:(id)sender;
- (IBAction)btnsegControls8:(id)sender;
- (IBAction)btnsegControls9:(id)sender;
- (IBAction)btnsegControls10:(id)sender;
- (IBAction)btnsegControls11:(id)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segAllSystem1;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segAllSystem2;

- (IBAction)btnsegAllSystem1:(id)sender;
- (IBAction)btnsegAllSystem2:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtAllSystem1;
@property (strong, nonatomic) IBOutlet UITextField *txtAllSystem2;
@property (strong, nonatomic) IBOutlet UITextField *txtAllSystem3;

@property (strong, nonatomic) IBOutlet UITextField *txtGasRate;
@property (strong, nonatomic) IBOutlet UITextField *txtBurnerOperatingPressure;
@property (strong, nonatomic) IBOutlet UITextField *txtGasIntentPressure;
@property (strong, nonatomic) IBOutlet UITextField *txtCentralHeatingFlow;
@property (strong, nonatomic) IBOutlet UITextField *txtCentralHeatingReturn;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segCombinationBoiler1;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segCombinationBoiler2;

- (IBAction)btnsegCombinationBoiler1:(id)sender;
- (IBAction)btnsegCombinationBoiler2:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtCombinationBoiler;

@property (strong, nonatomic) IBOutlet UITextField *txtDHWgasrate;
@property (strong, nonatomic) IBOutlet UITextField *txtDHWburneroperatingpressure;
@property (strong, nonatomic) IBOutlet UITextField *txtDHWgasintentpressure;
@property (strong, nonatomic) IBOutlet UITextField *txtDHWcoldwaterintent;
@property (strong, nonatomic) IBOutlet UITextField *txtDHWhotwateroutlet;
@property (strong, nonatomic) IBOutlet UITextField *txtDHWwaterflowrate;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segtxtDHWcheckedHotWater;
- (IBAction)btnsegtxtDHWcheckedHotWater:(id)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segCondensingBoilersOnly;
- (IBAction)btnsegCondensingBoilersOnly:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtallInstallationCO1;
@property (strong, nonatomic) IBOutlet UITextField *txtallInstallationRatio1;
@property (strong, nonatomic) IBOutlet UITextField *txtallInstallationCO2;
@property (strong, nonatomic) IBOutlet UITextField *txtallInstallationRatio2;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segAllInstallation1;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segAllInstallation2;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segAllInstallation3;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segAllInstallation4;

- (IBAction)btnsegAllInstallation1:(id)sender;
- (IBAction)btnsegAllInstallation2:(id)sender;
- (IBAction)btnsegAllInstallation3:(id)sender;
- (IBAction)btnsegAllInstallation4:(id)sender;



@property (strong, nonatomic) IBOutlet UIButton *btnsubmit;
- (IBAction)btnSubmitapped:(id)sender;






















@end
