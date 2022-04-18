//
//  GBSRappliancechecks.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>

@protocol GBSAppliaceCheckDelegate <NSObject>

-(void)GBSApplianceCheckData:(NSDictionary *)data;


@end


@interface GBSRappliancechecks : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(retain,nonatomic)NSMutableDictionary *dicAppliaceChk;
@property(weak,nonatomic)id <GBSAppliaceCheckDelegate>delegate;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segPC1;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segPC2;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segPC3;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segPC4;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segPC5;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segPC6;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segPC7;

- (IBAction)btnsegPC1Tapped:(id)sender;
- (IBAction)btnsegPC2Tapped:(id)sender;
- (IBAction)btnsegPC3Tapped:(id)sender;
- (IBAction)btnsegPC4Tapped:(id)sender;
- (IBAction)btnsegPC5Tapped:(id)sender;
- (IBAction)btnsegPC6Tapped:(id)sender;
- (IBAction)btnsegPC7Tapped:(id)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segSC1;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segSC2;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segSC3;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segSC4;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segSC5;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segSC6;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segSC7;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segSC8;

- (IBAction)btnsegSC1Tapped:(id)sender;
- (IBAction)btnsegSC2Tapped:(id)sender;
- (IBAction)btnsegSC3Tapped:(id)sender;
- (IBAction)btnsegSC4Tapped:(id)sender;
- (IBAction)btnsegSC5Tapped:(id)sender;
- (IBAction)btnsegSC6Tapped:(id)sender;
- (IBAction)btnsegSC7Tapped:(id)sender;
- (IBAction)btnsegSC8Tapped:(id)sender;


@property (strong, nonatomic) IBOutlet UISegmentedControl *segSO1;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segSO2;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segSO3;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segSO4;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segSO5;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segSO6;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segSO7;

- (IBAction)btnsegSO1Tapped:(id)sender;
- (IBAction)btnsegSO2Tapped:(id)sender;
- (IBAction)btnsegSO3Tapped:(id)sender;
- (IBAction)btnsegSO4Tapped:(id)sender;
- (IBAction)btnsegSO5Tapped:(id)sender;
- (IBAction)btnsegSO6Tapped:(id)sender;
- (IBAction)btnsegSO7Tapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
- (IBAction)btnSubmitTapped:(id)sender;









- (IBAction)btnBackTapped:(id)sender;
@end
