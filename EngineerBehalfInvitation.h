//
//  EngineerBehalfInvitation.h
//  Partner Maintenance
//


#import "EngineerBehalfInvitation.h"
#import "SWRevealViewController.h"
#import "ViewController.h"
#import "GlobalDirector.h"

@interface EngineerBehalfInvitation : ViewController<UITabBarDelegate,UITableViewDataSource>
{
    NSMutableArray *InvitedJobs,*arrInvitedEngg,*arrMselectedFE;
    int page;
    NSMutableData *_responseData;
    
    NSURLConnection *connRequestedFE,*connAccept;
    UIControl *bgVw;
    UIScrollView *popUpVW;
    UIView *mainBg11, *bgVw11,*mainBg22,*bgVw22,*mainBg33;
    
    UILabel *imgvstatusCrcl;
    
   
    
}


@property (strong, nonatomic) IBOutlet UIButton *btnSlideMenu;
@property (strong, nonatomic) IBOutlet UITableView *tabvInvitationList;



@end
