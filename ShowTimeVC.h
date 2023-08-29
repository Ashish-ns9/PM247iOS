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
//@property (strong, nonatomic) NSString *engineerID;

-(IBAction)backPress:(id)sender;
-(IBAction)playPausePress:(UIButton*)sender;
-(IBAction)stopPress:(id)sender;

@end

