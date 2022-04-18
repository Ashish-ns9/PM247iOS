//
//  GSMCappliancedetails.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>

@protocol GSMApplianceDelegate <NSObject>

-(void)GSMapplianceDelegateData:(NSDictionary *)data;


@end

@interface GSMCappliancedetails : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField *Activetxtfld;
    UITableView *tblView;
    NSArray *arrFeedTblPopup;
    CGPoint PrePoint;
}

@property(retain,nonatomic)NSMutableDictionary *dicApplianceDetails;
@property(weak,nonatomic)id <GSMApplianceDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)btnBackTapped:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *btnsubmit;
- (IBAction)btnSubmitapped:(id)sender;


@property (strong, nonatomic) IBOutlet UITextField *txtLocation;
@property (strong, nonatomic) IBOutlet UITextField *txtAppliancetype;
@property (strong, nonatomic) IBOutlet UITextField *txtApplianceMake;
@property (strong, nonatomic) IBOutlet UITextField *txtApplianceModel;
@property (strong, nonatomic) IBOutlet UITextField *txtApplianceSerialno;

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
@property (strong, nonatomic) IBOutlet UITextField *txtHeatinput;


@property (strong, nonatomic) IBOutlet UISegmentedControl *segGastightnesstestcarriedout;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segGastightnessResult;
- (IBAction)btnsegGastightnesstestcarriedout:(id)sender;
- (IBAction)btnsegGastightnessResult:(id)sender;


@end
