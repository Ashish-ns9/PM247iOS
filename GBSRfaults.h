//
//  GBSRfaults.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>

@protocol GBSFaultsDelegates <NSObject>

-(void)GBSFaultsData:(NSDictionary *)data;


@end



@interface GBSRfaults : UIViewController<UITextFieldDelegate,UITextViewDelegate>
{
    CGPoint prePoint;
}
@property(retain,nonatomic)NSMutableDictionary *dicFaultsAction;
@property(weak,nonatomic)id<GBSFaultsDelegates>delegate;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@property (strong, nonatomic) IBOutlet UITextView *txtvFaults;
@property (strong, nonatomic) IBOutlet UITextView *txtvRemedialworkactiontaken;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segWarningNotice;
- (IBAction)btnsegWarningNoticeTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtWarningNoticeNo;

@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
- (IBAction)btnSubmitTapped:(id)sender;

- (IBAction)btnBackTapped:(id)sender;
@end
