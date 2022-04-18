//
//  GSMCfindings.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "GlobalDirector.h"
@protocol GSMFindingsDelegate <NSObject>

-(void)GSMFindingDataRecord:(NSDictionary *)data;


@end


@interface GSMCfindings : UIViewController<UITextViewDelegate>
{
    CGPoint PrePoint;
}
@property(retain,nonatomic)NSMutableDictionary *dicFindings;
@property(weak,nonatomic)id <GSMFindingsDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)btnBackTapped:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *btnsubmit;
- (IBAction)btnSubmitapped:(id)sender;


@property (strong, nonatomic) IBOutlet UISegmentedControl *segInstallationSafetouse;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segInstallationNo;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segInstallationCnfirm;

- (IBAction)btnInstallationSafetousetapped:(id)sender;
- (IBAction)btnInstallationNotapped:(id)sender;
- (IBAction)btnInstallationCnfirmtapped:(id)sender;

@property (strong, nonatomic) IBOutlet UITextView *txtvRemedialWork;


@end
