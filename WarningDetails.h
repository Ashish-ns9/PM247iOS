//
//  WarningDetails.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>

@protocol WarningDetailsDelegates <NSObject>

-(void)warningDetailsRecordData:(NSDictionary *)data;


@end


@interface WarningDetails : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITextField *Activetxtfld;
    UITableView *tblView;
    NSArray *arrFeedTblPopup;
    CGPoint PrePoint;
}


@property(retain,nonatomic)NSMutableDictionary *dicWarningDetails;
@property(weak,nonatomic)id <WarningDetailsDelegates>delegate;

- (IBAction)btnBackTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;



@property (strong, nonatomic) IBOutlet UIButton *btnsubmit;
- (IBAction)btnSubmitapped:(id)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segGasEscape;
- (IBAction)btnsegGasEscape:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtLocation;
@property (strong, nonatomic) IBOutlet UITextField *txtApplianceType;
@property (strong, nonatomic) IBOutlet UITextField *txtApplianceMake;
@property (strong, nonatomic) IBOutlet UITextField *txtApplianceModel;
@property (strong, nonatomic) IBOutlet UITextField *txtApplianceSerialNo;

@property (strong, nonatomic) IBOutlet UITextView *txtvImmediateDengerousID;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segImmediateDengerousID;
- (IBAction)btnsegImmediateDengerousID:(id)sender;

@property (strong, nonatomic) IBOutlet UITextView *txtvAtRiskID;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segAtRiskID;
- (IBAction)btnsegAtRiskID:(id)sender;

@property (strong, nonatomic) IBOutlet UITextView *txtvNCS;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segGasUsernotPresent;
- (IBAction)btnsegGasUsernotPresent:(id)sender;


@end
