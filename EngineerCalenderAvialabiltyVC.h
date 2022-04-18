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


NS_ASSUME_NONNULL_BEGIN

@interface EngineerCalenderAvialabiltyVC : UIViewController<SWRevealViewControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,NSURLConnectionDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    
    UITextField *txtStarDate,*txtStartTime,*txtEndTime,*txtTimeAllowance,*txtJobType,*txtJobStatus;
    UIButton *btnStartDate,*btnStartTime,*btnEndTime;
    
    DSLCalendarView *cal;
    NSArray*Jobs;
    NSArray*arrDates;
    NSString*strJobID;
    NSString*dateString1;
    NSString*dateString2;


    UIControl *bgView;
    UIView *mainBg,*bgVw;
    UIScrollView *scrollviewbg;
    UIDatePicker *datepicker,*timePicker,*datepicker2,*timePicker2;
    UIToolbar* toolbar;
    UIDatePicker* picker;
    UIToolbar *numberToolbar;
    UIButton *btnCross1;
    UIButton *btnProceed;
    UIButton *btnDropdown;
    NSInteger *Count;
    NSInteger *Count2;
    NSInteger *Test;
    UITableView *tableView;
    UITextView *txtvNoteBody;
    UITextView *txtvSelectingColorView;
    UITextField *Activetxtfld;
//    NSArray *dropdownData;
    
    NSURLConnection *connRecreateConfirmation;

}
@property (strong, nonatomic) IBOutlet UIButton *btnSlideMenu;

@property (strong, nonatomic) IBOutlet UIView *CalendarView;
@property (strong, nonatomic) IBOutlet UIView *NewCalendrView;


@end

NS_ASSUME_NONNULL_END
