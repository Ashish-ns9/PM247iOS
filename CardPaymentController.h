//
//  CardPaymentController.h
//  PM247
//


#import <UIKit/UIKit.h>
#import "PaymentTransactionDtls.h"
#import "Luhn.h"
#import "KLCPopup.h"
#import "ViewController.h"
#import "MBProgressHUD.h"
#import "SaveCardCell.h"
#import "NewCardCell.h"
#import "ViewController.h"
#import "KLCPopup.h"
#import "PM247-Swift.h"


@interface CardPaymentController : ViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
{
   // IBOutlet UIButton *btnPay;
    NSString *operationType;
    IBOutlet UIButton *btnIsSave;
  
    NSString *autKey;
   
    BOOL isCardFrontView;
    
   
    BOOL isCardOpen;
    
    IBOutlet UIView *viewCard;
    
    IBOutlet AMCreditCardView *card;
    NSInteger timeCounter;
    NSInteger Count;
    
    
    NSString *previousTextFieldContent;
    UITextRange *previousSelection;
    
}

@property(nonatomic,retain)  NSDictionary *dictJob,*dictCardIdentifire;
@property(nonatomic,retain)  NSMutableDictionary *dictPaymentDtls;
@property(nonatomic)PaymentTransactionDtls *selfPaymentDtlsPage;
@property(nonatomic,retain)NSString *strMerchantSessionKey;
@property(nonatomic,retain)NSArray *arrMonth;
@property(nonatomic,retain)NSMutableArray *arrYears,*arrSaveCardBool,*arrCards;


@property(nonatomic)int mm;
@property(nonatomic)int year;


@property (strong, nonatomic) IBOutlet UITextField *txtCardName;
@property (strong, nonatomic) IBOutlet UITextField *txtCardNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtccv;
@property (strong, nonatomic) IBOutlet UIImageView *imgCard;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UIView *pickerView;

@property (strong, nonatomic) IBOutlet UITextField *txtExpiry;

@property (strong, nonatomic) IBOutlet UITableView *tblList;


@property (strong, nonatomic) IBOutlet UIView *ViewCVCPopUp;
@property (weak, nonatomic) IBOutlet UILabel *lblCVC;
@property (strong, nonatomic) IBOutlet UIButton *btnPay;



- (IBAction)ClickSave:(UIButton *)sender;







@end


