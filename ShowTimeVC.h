//
//  ManagerJobDetails.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "AppDelegate.h"

@interface ShowTimeVC : ViewController<NSURLConnectionDelegate,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>
{
    
   
}

@property (strong, nonatomic) IBOutlet UILabel *lblTimer;
@property (strong, nonatomic) IBOutlet UIButton *btnPlayPause;
@property (strong, nonatomic) IBOutlet UITableView *tblView;

@property (strong, nonatomic) NSString *jobID;
@property (strong, nonatomic) NSMutableArray *arrNotes;
@property (weak, nonatomic) IBOutlet UIView *viewMainActionType;
@property (weak, nonatomic) IBOutlet UIView *viewInnerActionType;
@property (weak, nonatomic) IBOutlet UITableView *tblViewActionType;
@property (weak, nonatomic) IBOutlet UIButton *actionTypeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ActionTypeViewHeight;

//@property (strong, nonatomic) NSString *engineerID;

-(IBAction)backPress:(id)sender;
-(IBAction)playPausePress:(UIButton*)sender;
-(IBAction)stopPress:(id)sender;
- (IBAction)actionTypePress:(id)sender;
- (IBAction)actionCancelPress:(id)sender;

@end

