//
//  Engineersignoff.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "PJRSignatureView.h"
#import <QuartzCore/QuartzCore.h>
#import "DefaultSettings.h"
#import "MBProgressHUD.h"
#import "GlobalDirector.h"
#import "ViewController.h"

@protocol EnggSignOffDelegates <NSObject>

-(void)EnggSignOffDetailsValue:(NSDictionary *)datas;


@end


@interface Engineersignoff : ViewController
{
     PJRSignatureView *scratchableView;
    

    NSURLConnection *connEngineerDetails;
    NSMutableData *_responseData;
    NSMutableDictionary *dicTempServer;
    CGPoint PeVscrollPoint;
    NSString *strSignatureUrl;
}
@property(retain,nonatomic)NSDictionary *jobDic;

@property(retain,nonatomic)NSMutableDictionary *dicSignOffDetails;
@property(weak,nonatomic)id <EnggSignOffDelegates>delegate;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UITextField *txtEngineerName;
@property (strong, nonatomic) IBOutlet UITextField *txtDatesigned;

@property (strong, nonatomic) IBOutlet UITextField *txtGassafeRegisterNo;
@property (strong, nonatomic) IBOutlet UITextField *txtOperativeID;

@property (strong, nonatomic) IBOutlet UIButton *btnsubmit;
- (IBAction)btnSubmitapped:(id)sender;
- (IBAction)btnbacktapped:(id)sender;
- (IBAction)btnenggSignTapped:(id)sender;
- (UIImage*)captureView:(UIView *)view;
@property (strong, nonatomic) IBOutlet UIImageView *imgVEnggSign;


@property (strong, nonatomic) IBOutlet UILabel *lbl1;
@property (strong, nonatomic) IBOutlet UILabel *lbl2;
@property (strong, nonatomic) IBOutlet UILabel *lbl3;




@end
