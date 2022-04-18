//
//  AddJobPayment.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AddJobPayment : UIViewController<UITextFieldDelegate,UITextViewDelegate>
{
    UIView *bgVw,*mainBg;
    UIButton *btnCross,*btnSave;
    UITextField *txtPaymentMethod,*txtAmount;
    UITextView *txtvDescription;
}

@property(nonatomic,retain)NSString *strHeading;
@property (strong, nonatomic) IBOutlet UILabel *lblHeading;
@property (strong, nonatomic) IBOutlet UITableView *tabvNotes;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
- (IBAction)btnAddTapped:(id)sender;
- (IBAction)backTapped:(id)sender;

@end
