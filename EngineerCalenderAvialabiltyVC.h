//
//  EngineerCalenderAvialabiltyVC.h
//  PM247
//
//  Created by Shubham Kumar on 14/03/22.
//  Copyright © 2022 SANDIPAN. All rights reserved.
//

#import <UIKit/UIKit.h>
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
#import "ViewController.h"
#import "AppDelegate.h"
#import "BaseTableCell.h"
#import "RecreateCell.h"
#import "ViewController.h"
#import "Login.h"


NS_ASSUME_NONNULL_BEGIN

@interface EngineerCalenderAvialabiltyVC : UIViewController<SWRevealViewControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,NSURLConnectionDelegate,UITextViewDelegate,UITextFieldDelegate,DSLCalendarViewDelegate,DSLCalendarViewDataSource>
{
    
    UITextField *txtStarDate,*txtStartTime,*txtEndTime,*txtTimeAllowance,*txtJobType,*txtJobStatus;
    UIButton *btnStartDate,*btnStartTime,*btnEndTime;
    
    DSLCalendarView *cal;
    NSString *savedValue;
 
    NSMutableArray *colorArray,*themeColorArray,*newGreenArray,*newRedArray,*noteBodyArray, *avaliablityArrayid,*availblityToArray,*orderDic,*jobdetailarray, *jobdetailarray1,*jobdetailarray2,*jobdetailarray3,*jobdetailarray4,*JobsOnDate;
  
    NSArray*arrDates,*arrDates1,*Jobs,*jobEnggAvailabilityListResponse,*job;

   
    NSString *dateString1,*availbleFromdate,*availbleFromdate1,*availbleFromdate2,*availbleFromdate3,*availbleTo,*availbletodate,*availbledatfortextfiled, *notebodydata,*previousTime,*newTime,*strJobID,*dateString2,*availblityId,*strttimetxtfldDate,*strttimetxtfldDate1,*timeOnDate,*timeOnDate1,*previousGreenTime,*previousGreenTime1,*previousGreenTime2,*previousRedTime;
   
   

    NSMutableDictionary *dicUsercalenderDetails;
    UIControl *bgView;
    UIView *mainBg,*bgVw;
    UIScrollView *scrollviewbg;
    UIDatePicker *datepicker,*timePicker,*datepicker2,*timePicker2;
    UIToolbar* toolbar;
    UIDatePicker* picker;
    UIToolbar *numberToolbar;
    UIButton *btnCross;
    UIButton *btnProceed,*btnCreatejob,*btnCreatejob1,*btnCreatejob2,*btnCreatejob3,*btnCreatejob4,*btnDelete;
    UIButton *btnDropdown;
    
    NSInteger Count2,greenCount,redCount,Count,EventsdicCount,Test,noteCount,noteCount1,noteCount2,noteCount3,noteDataCount,btnCount,selectedBtnCount, emptyDateCount, deletecount;
    NSString *availabilityIDonBtn1,*availabilityIDonBtn2, *availabilityIDonBtn3,*availabilityIDonBtn4;
    NSString *availbfromOnBtn1,*availbfromOnBtn2,*availbfromOnBtn3,*availbfromOnBtn4;
    NSString *AvailbTOnBtn1,*AvailbToOnBtn2,*AvailbToOnBtn3,*AvailbToOnBtn4;
    NSString *themeColorOnBtn1,*themeColorOnBtn2,*themeColorOnBtn3, *themeColorOnBtn4;
    NSString *notesOnBtn1,*notesOnBtn2,*notesOnBtn3,*notesonBtn4;
    NSString *datandtimeOnStarttimetxtfld,*datandtimeOnEndtimetxtfld;
    
   
    UITableView *tableView;
    UITextView *txtvNoteBody;
    UITextView *txtvSelectingColorView;
    UITextField *Activetxtfld;
    NSMutableData *_responseData;
    
    NSURLConnection *connRecreateConfirmation,*connLogin;

}

@property (strong, nonatomic) IBOutlet UIButton *btnSlideMenu;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UIView *CalendarView;
@property (strong, nonatomic) IBOutlet UIView *NewCalendrView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


@end

NS_ASSUME_NONNULL_END
