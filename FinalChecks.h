//
//  FinalChecks.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>


@protocol finalChecksDelegate <NSObject>

@optional

-(void)FinalChecksDidAddedWithData:(NSDictionary *)datas;


@end

@interface FinalChecks : UIViewController<UITextFieldDelegate>
{
    CGPoint PeVscrollPoint;
}
@property (retain,nonatomic)NSMutableDictionary *dataFinalChecks;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollFinalChk;

@property (strong, nonatomic) IBOutlet UITextField *txtinitialRd;
@property (strong, nonatomic) IBOutlet UITextField *txtFinalRd;

@property (strong, nonatomic) IBOutlet UITextView *txtVwinstalDefect;
@property (strong, nonatomic) IBOutlet UITextView *txtVwRemdAction;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segGastightness;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segEmergencyControlValve;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segGasinstallationpipework;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segMainprotective;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segCOalarmfitted;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segCOalarmworking;
@property(weak,nonatomic)id <finalChecksDelegate> delegate;

- (IBAction)btnGastightnessTapped:(id)sender;
- (IBAction)btnEmergencyControlValveTapped:(id)sender;
- (IBAction)btnGasinstallationpipeworkTapped:(id)sender;
- (IBAction)btnMainprotectiveTapped:(id)sender;
- (IBAction)btnCOalarmfittedTapped:(id)sender;
- (IBAction)btnCOalarmworkingTapped:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
- (IBAction)btnSubmitTapped:(id)sender;


- (IBAction)btnBackTapped:(id)sender;

@end
