//
//  GSMCappliancechecks.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>

@protocol GSMApplianceChecksDelegate <NSObject>

-(void)GSMApplianceChecksData:(NSDictionary *)data;


@end


@interface GSMCappliancechecks : UIViewController<UITextFieldDelegate>
{
     CGPoint PrePoint;
}
@property(retain,nonatomic)NSMutableDictionary *dicApplianceChecksData;
@property(weak,nonatomic)id <GSMApplianceChecksDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)btnBackTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnsubmit;
- (IBAction)btnSubmitapped:(id)sender;


@property (strong, nonatomic) IBOutlet UITextField *txtRemedial1;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial2;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial3;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial4;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial5;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial6;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial7;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial8;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial9;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial10;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial11;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial12;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial13;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial14;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial15;
@property (strong, nonatomic) IBOutlet UITextField *txtRemedial16;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segRemedial1;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segRemedial2;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segRemedial3;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segRemedial4;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segRemedial5;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segRemedial6;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segRemedial7;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segRemedial8;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segRemedial9;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segRemedial10;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segRemedial11;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segRemedial12;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segRemedial13;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segRemedial14;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segRemedial15;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segRemedial16;


- (IBAction)btnsegRemedial1:(id)sender;
- (IBAction)btnsegRemedial2:(id)sender;
- (IBAction)btnsegRemedial3:(id)sender;
- (IBAction)btnsegRemedial4:(id)sender;
- (IBAction)btnsegRemedial5:(id)sender;
- (IBAction)btnsegRemedial6:(id)sender;
- (IBAction)btnsegRemedial7:(id)sender;
- (IBAction)btnsegRemedial8:(id)sender;
- (IBAction)btnsegRemedial9:(id)sender;
- (IBAction)btnsegRemedial10:(id)sender;
- (IBAction)btnsegRemedial11:(id)sender;
- (IBAction)btnsegRemedial12:(id)sender;
- (IBAction)btnsegRemedial13:(id)sender;
- (IBAction)btnsegRemedial14:(id)sender;
- (IBAction)btnsegRemedial15:(id)sender;
- (IBAction)btnsegRemedial16:(id)sender;




@end
