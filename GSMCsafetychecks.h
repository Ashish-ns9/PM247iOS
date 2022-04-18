//
//  GSMCsafetychecks.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>

@protocol GSMSafetyDelegates <NSObject>

-(void)GSMSafetyDataRecord:(NSDictionary *)data;


@end


@interface GSMCsafetychecks : UIViewController<UITextFieldDelegate>
{
     CGPoint PrePoint;
}
@property(retain,nonatomic)NSMutableDictionary *dicSafetyData;
@property(weak,nonatomic)id <GSMSafetyDelegates>delegate;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)btnBackTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnsubmit;
- (IBAction)btnSubmitapped:(id)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segVentilation;
- (IBAction)btnsegVentilationTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial1;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segFuelTermination;
- (IBAction)btnsegFuelTerminationTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial2;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segFlueflowtest;
- (IBAction)btnsegFlueflowtestTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial3;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segSpillagetest;
- (IBAction)btnsegSpillagetestTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial4;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segOperatingPressure;
- (IBAction)btnsegOperatingPressureTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial5;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segSafetydevice;
- (IBAction)btnsegSafetydeviceTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial6;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segOthers;
- (IBAction)btnsegOthersTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial7;


@end
