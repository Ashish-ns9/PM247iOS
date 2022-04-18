//
//  Messages.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "KLCPopup.h"
@interface Messages : ViewController<SWRevealViewControllerDelegate,UITextViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *mainBg,*bgVw;
    UIButton *btnCross;
    UITextView *txtvMessageBody;
    UIButton *btnMessagePost;
    UITextField *txtUserType,*txtUserName;
    
    UITableView *tblView;
    UITextField *Activetxtfld;
    NSArray *arrFeedTblPopup,*arrRecipientList;
    NSMutableArray *arrSelectedRecipients,*arrSelectedRecipientsIds,*arrMessageList;
    NSMutableData *_responseData;
    NSURLConnection *connSendMessage,*connFetchMessage;
    MBProgressHUD *hud;
    UILabel *lblNoJobs;
    NSString *connIdentifier;
    
    
    
}

@property (strong, nonatomic) IBOutlet UIView *viewPopSub;

@property (strong, nonatomic) IBOutlet UIView *viewMsgPopup;
@property (strong, nonatomic) IBOutlet UITextView *txtVmsgPop;

@property (strong, nonatomic) IBOutlet UITableView *tblMessageList;

@property (strong, nonatomic) IBOutlet UIButton *btnSlideMenu;
@property(strong,nonatomic)NSString *jobID;

@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
//- (IBAction)btnAddTapped:(id)sender;

- (IBAction)backTapped:(id)sender;

@end
