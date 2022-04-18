//
//  DashBoard.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SWRevealViewController.h"
#import "DSLCalendarView.h"
#import "CreateJob.h"
#import <QuartzCore/QuartzCore.h>
#import "Customer_EngineerJobDetails.h"
#import "ManagerJobDetails.h"
#import "CreateJobEng.h"
#import "Messages.h"
#import "ReCreateJob.h"
#import "Map_show.h"
#import "SignAgreement.h"
#import "HelpWidgetVC.h"


@interface DashBoard : ViewController<SWRevealViewControllerDelegate,DSLCalendarViewDelegate,DSLCalendarViewDataSource,UIGestureRecognizerDelegate,NSURLConnectionDelegate,UITableViewDataSource,UITableViewDelegate>

{
    NSTimer *blinkTimer;
    
    //------Accept Agreement1---------
    UIView *mainBg11,*bgVw11;
    //--------------------------------
    //------Accept Agreement2---------
    UIControl *mainBg22,*bgVw22,*mainBg33;
    //--------------------------------
    
    //----- Agreement1 ------
    UIView *mainBg1,*bgVw1;
    UIButton *btnAcceptYesPress,*btnDeclineNoPress;
    
    //----- Agreement2 ------
    UIView *mainBg2,*bgVw2;
    UIButton *btnAcceptYesPress2,*btnDeclineNoPress2;
    
    UIView *mainBg,*bgVw;
    UIButton *btnCross;

    
  
    
    UIControl *bgView;
    
    UIRefreshControl *refreshControl;
    
    NSMutableDictionary *dicJobDetails;
    
    NSMutableArray *arrMJobDetails,*arrMFilterJobsList,*arrCFilterJoblist,*arrMInvitations,*arrMAssignedJobs,*arrMActiveJobDetails,*arrMBookedJobDetails,*arrMCompleteJobDetails,*arrMAlljob ,*arrMActiveFilterJobsList,*arrMBookedFilterJobsList,*arrMCompleteFilterJobsList;
    //job edit array
    NSMutableArray *arrEditedJobDic;
   
    
    NSMutableArray *arrMallocatedFEjobid;
    
    NSURLConnection *conn;
    
    BOOL isbtnAssignedClicked,isbtnInvitationClicked,isLoadMore;
    
    UIView *myBackView;
    UISwipeGestureRecognizer *gestureL,*gestureR;
    NSInteger selectedIndex;
    UIView *myView;
    NSMutableData *_responseData;
    
    IBOutlet UILabel *lblNotifications;
    
    IBOutlet UILabel *lblMesseges;
    NSMutableArray *arrMStatusJobid;
    NSMutableDictionary *dicStatusJobid;
    NSMutableArray *JobsOnDate;
    
    NSURLConnection *connAccept,*connReject;
    
    UIButton *btnActiveSubCategory,*btnActiveCategory;
    CGFloat yOffset;
    NSInteger page;
    NSInteger Count;
    NSInteger loadBookedPageCount;
    NSInteger loadActivePageCount;
    NSInteger loadCompletePageCount;
    NSInteger BookedPage;
    NSInteger ActivePage;
    NSInteger CompletePage;
    NSInteger refreshPagecount;
    NSInteger refreshBookedPagecount;
    NSInteger refreshBookedPagecount2;
    NSInteger refreshActivePagecount;
    NSInteger refreshCompletePagecount;
    NSInteger loadActivePageCount2;
    NSInteger refreshActiveloadmorePagecount;
    NSInteger refreshCompleteloadmorePagecount;
    NSInteger  ViewWillAppearBookedloadmorePagecount;
    NSInteger ViewWillAppearActiveloadmorePagecount;
    NSInteger ViewWillAppearcompleteloadmorePagecount;
 
    NSInteger allpageValue;
    BOOL isNxtJobAvailable,isPrevJobAvailable;
    
    
    UIPageControl *pageControl;
    UILabel *lblNoJobs;
    
    
    
    IBOutlet UIView *Vwtbl;
    DSLCalendarView *cal;
    
    
    
}

@property (strong, nonatomic) IBOutlet UIButton *btnLoadMore;
- (IBAction)btnLoadMore:(id)sender;




- (IBAction)btnRefreshTapped:(id)sender;


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UIButton *btnSlideMenu;


@property (strong, nonatomic) IBOutlet DSLCalendarView *Calendar;
@property (strong, nonatomic) IBOutlet UIView *ViewCalendar;

@property (strong, nonatomic) IBOutlet UIView *viewToDoList;
@property (strong, nonatomic) IBOutlet UITableView *tabvToDoList;

- (IBAction)AddJob:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnaddjob;

- (IBAction)HelpWidget:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *HelpWidgetBtn;



@property (strong, nonatomic) IBOutlet UIView *vwtab;
@property(retain,nonatomic)NSString *LoggedUser;



@property (strong, nonatomic) IBOutlet UIButton *btnNotification;
@property (strong, nonatomic) IBOutlet UIButton *btnMessage;

@property (strong, nonatomic) IBOutlet UIButton *btnListandCalender;
@property (strong, nonatomic) IBOutlet UIImageView *imgVtoggleCalTodo;


-(void)fetchJobdetails;


-(IBAction)listandCalenderPress:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *viewUpperSelectionTab;
@property (strong, nonatomic) IBOutlet UIButton *btnActive,*btnActiveAssigns;
@property (strong, nonatomic) IBOutlet UIButton *btnBooked,*btnAssigned;
@property (strong, nonatomic) IBOutlet UIButton *btnComplete,*btnCompleteAssign;
@property (strong, nonatomic) IBOutlet UIImageView *selected;

-(IBAction)activePress:(id)sender;
-(IBAction)bookedPress:(id)sender;
-(IBAction)completePress:(id)sender;






@property (strong, nonatomic) IBOutlet UIView *viewEngineerTab;
@property (strong, nonatomic) IBOutlet UIButton *btnJobsInvitation;
@property (strong, nonatomic) IBOutlet UIButton *btnAssignedJobs;
@property (strong, nonatomic) IBOutlet UIImageView *selectedEngineer;
-(IBAction)jobsInvitationPress:(id)sender;
-(IBAction)assignedJobsPress:(id)sender;



@property (strong, nonatomic) IBOutlet UIView *viewSubTabAssignment;
@property (strong, nonatomic) IBOutlet UIView *viewSubTabAllCurrPrevNext;
@property (strong, nonatomic) IBOutlet UIView *viewsubTabAgreement;
@property (strong, nonatomic) IBOutlet UIView *vwSubInvitations;

@property (strong, nonatomic) IBOutlet UIButton *btnNewInvitation;
@property (strong, nonatomic) IBOutlet UIButton *btnAcceptedInvitation;
- (IBAction)btnAcceptedInvitationTapped:(id)sender;
- (IBAction)btnNewInvitationTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnAll;
@property (strong, nonatomic) IBOutlet UIButton *btnCurrent;
@property (strong, nonatomic) IBOutlet UIButton *btnPrevious;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;

-(IBAction)allPress:(id)sender;
-(IBAction)currentPress:(id)sender;
-(IBAction)previousPress:(id)sender;
-(IBAction)nextPress:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnNoAgreement;
@property (strong, nonatomic) IBOutlet UIButton *btnSmallRepairAgreement;
@property (strong, nonatomic) IBOutlet UIButton *btnBothAgreement;

- (IBAction)btnNoAgreementPress:(id)sender;
- (IBAction)btnSmallRepairAgreementPress:(id)sender;
- (IBAction)btnBothAgreementPress:(id)sender;







@end
