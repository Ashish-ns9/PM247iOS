//
//  PostCodePopupController.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "PostCodeCell.h"
#import "MBProgressHUD.h"
#import "GlobalDirector.h"
#import "ViewController.h"
@protocol PostCodePopupControllerDelegate <NSObject>

@required
-(void)PostCodeAddressSelection:(NSMutableDictionary*)dict;

@end

@interface PostCodePopupController : ViewController<UITextFieldDelegate>
{
    NSMutableArray *arraddresses;
   
}

@property (strong, nonatomic) IBOutlet UITextField *txtPost;
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) UITextField *txtDelegate;


@property (nonatomic,weak) id <PostCodePopupControllerDelegate> delegate;

- (IBAction)ClickSearch:(UIButton *)sender;
- (IBAction)ClickBack:(UIButton *)sender;


@end



