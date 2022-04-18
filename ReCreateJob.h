//
//  ReCreateJob.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "BaseTableCell.h"
#import "RecreateCell.h"
@interface ReCreateJob : ViewController<SWRevealViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,NSURLConnectionDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    NSMutableData *_responseData;
    UIView *mainBg,*bgVw;
    UIScrollView *scrollviewbg;
    
    UITextField *txtStarDate,*txtStartTime,*txtEndTime,*txtTimeAllowance,*txtJobType,*txtJobStatus;
    UIButton *btnStartDate,*btnStartTime,*btnEndTime;
    
    
    UITableView *tblView;
    UITextField *Activetxtfld;
    NSArray *arrFeedTblPopup;
    
    UIButton *btnCross;
    UITextView *txtvNoteBody;
    UIButton *btnProceed;
    
    
    UIDatePicker *datepicker,*timePicker;
    UIToolbar *numberToolbar;
    NSURLConnection *connRecreateConfirmation;
}
@property(nonatomic,retain)IBOutlet UISearchBar *search;
@property (strong, nonatomic) IBOutlet UIButton *btnSlideMenu;
@property(retain,nonatomic)NSMutableArray *arrRecreatedFrom;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


@property (strong, nonatomic) IBOutlet UITableView *tblRecreate;


- (IBAction)backTapped:(id)sender;

@end






