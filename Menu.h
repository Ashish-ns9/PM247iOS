//
//  Menu.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "Login.h"
#import "DashBoard.h"
#import "Messages.h"
#import "EngineerSetAvialability.h"
#import "EngineerCalenderAvialabiltyVC.h"
#import "ProfileEdit.h"
#import "EngineerBehalfInvitation.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MessageUI/MessageUI.h>




@interface Menu : ViewController
{
 
    
}

@property (strong, nonatomic) IBOutlet UILabel *lblMenu;

@property (weak, nonatomic) IBOutlet UITableView *tab_Menu;
@end
