//
//  PostCodePopupController.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "AddressCell.h"
#import "MBProgressHUD.h"
#import "GlobalDirector.h"
#import "ViewController.h"
@protocol AddSelPopupControllerDelegate <NSObject>

@required
-(void)AddressSelection:(NSMutableDictionary*)dict;

@end

@interface AddSelPopupController : ViewController
{
    NSMutableArray *arraddresses;
   
}

@property(nonatomic,strong)NSString *customerId;
@property (strong, nonatomic) IBOutlet UITableView *tblView;


@property (nonatomic,weak) id <AddSelPopupControllerDelegate> delegate;


- (IBAction)ClickBack:(UIButton *)sender;


@end



