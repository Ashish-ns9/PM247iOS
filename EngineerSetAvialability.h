//
//  EngineerSetAvialability.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "SWRevealViewController.h"
#import "DefaultSettings.h"
#import "MBProgressHUD.h"

@interface EngineerSetAvialability : ViewController<SWRevealViewControllerDelegate,NSURLConnectionDelegate>
{
    UIDatePicker *timePicker;
    UIToolbar *numberToolbar;
    
    UITextField *actvfld;
    NSString *strMondaychck,*strTuesdaychck,*strWednesdaychck,*strThursdaychck,*strFridaychck,*strSaturdaychck,*strSundaychck;
    
    
    NSMutableData *_responseData;
    
    
    NSMutableArray *arrMSheduleDayTime;
    NSURLConnection *connGetshedule;
    MBProgressHUD *hud;
    

    
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@property (strong, nonatomic) IBOutlet UIButton *btnSlideMenu;

@property (strong, nonatomic) IBOutlet UIButton *btnSave;
-(IBAction)svaePress:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *vwMonday;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckMonday;
@property (strong, nonatomic) IBOutlet UILabel *lblMonday;
@property (strong, nonatomic) IBOutlet UITextField *txtMondayFromtime;
@property (strong, nonatomic) IBOutlet UITextField *txtMondaytoTime;

@property (strong, nonatomic) IBOutlet UIView *vwTuesday;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckTuesday;
@property (strong, nonatomic) IBOutlet UILabel *lblTuesday;
@property (strong, nonatomic) IBOutlet UITextField *txtTuesdayFromtime;
@property (strong, nonatomic) IBOutlet UITextField *txtTuesdaytoTime;

@property (strong, nonatomic) IBOutlet UIView *vwWednesday;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckWednesday;
@property (strong, nonatomic) IBOutlet UILabel *lblWednesday;
@property (strong, nonatomic) IBOutlet UITextField *txtWednesdayFromtime;
@property (strong, nonatomic) IBOutlet UITextField *txtWednesdaytoTime;

@property (strong, nonatomic) IBOutlet UIView *vwThursday;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckThursday;
@property (strong, nonatomic) IBOutlet UILabel *lblThursday;
@property (strong, nonatomic) IBOutlet UITextField *txtThursdayFromtime;
@property (strong, nonatomic) IBOutlet UITextField *txtThursdaytoTime;

@property (strong, nonatomic) IBOutlet UIView *vwFriday;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckFriday;
@property (strong, nonatomic) IBOutlet UILabel *lblFriday;
@property (strong, nonatomic) IBOutlet UITextField *txtFridayFromtime;
@property (strong, nonatomic) IBOutlet UITextField *txtFridaytoTime;

@property (strong, nonatomic) IBOutlet UIView *vwSaturday;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckSaturday;
@property (strong, nonatomic) IBOutlet UILabel *lblSaturday;
@property (strong, nonatomic) IBOutlet UITextField *txtSaturdayFromtime;
@property (strong, nonatomic) IBOutlet UITextField *txtSaturdaytoTime;

@property (strong, nonatomic) IBOutlet UIView *vwSunday;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckSunday;
@property (strong, nonatomic) IBOutlet UILabel *lblSunday;
@property (strong, nonatomic) IBOutlet UITextField *txtSundayFromtime;
@property (strong, nonatomic) IBOutlet UITextField *txtSundaytoTime;

-(IBAction)btnCheck:(UIButton *)sender;





@end
