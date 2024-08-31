//
//  FinancialVC.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "GlobalDirector.h"
#import "MBProgressHUD.h"
#import "FinancialNoteList.h"

@interface FinancialVC : ViewController<UITextViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tblView;
    UITextField *Activetxtfld;
    UIView *popUpVW;
    NSArray *arrFeedTblPopup;
    NSMutableArray *arrSquareUpPayments;
    NSMutableArray *arrVoltPayments;

    NSURLConnection *connFinancialDetails;
    NSString *strIdentifier;
    NSMutableData *_responseData;
    NSMutableDictionary *dicFinanceDetails;
    
    MBProgressHUD *hud;
    NSArray *arrFinNoteList;
    
}



@property(retain,nonatomic)NSDictionary *jobDic;

- (IBAction)btnBack:(id)sender;

@property (strong, nonatomic) IBOutlet UITextView *txtFixedPriceNote;
@property (strong, nonatomic) IBOutlet UITextView *txtVNote;
@property (strong, nonatomic) IBOutlet UITextView *txtAddFixedPriceNote;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollDetails;

@property (strong, nonatomic) IBOutlet UITextField *txtCommissionRate;
@property (strong, nonatomic) IBOutlet UITextField *txtJobPrice;
@property (strong, nonatomic) IBOutlet UITextField *txtsubTotalValue;

@property (strong, nonatomic) IBOutlet UILabel *lblDecription;
@property (strong, nonatomic) IBOutlet UILabel *lblCreatDate;
@property (strong, nonatomic) IBOutlet UILabel *lblcreatedBy;


@property (strong, nonatomic) IBOutlet UITextField *txtJobVATPercentageValue;
@property (strong, nonatomic) IBOutlet UITextField *txtJobVATValue;
@property (strong, nonatomic) IBOutlet UITextField *txtJobVATTotalValue;

@property (strong, nonatomic) IBOutlet UITextField *txtActualMaterialSubTotalValue;
@property (strong, nonatomic) IBOutlet UITextField *txtActualMaterialVATValue;
@property (strong, nonatomic) IBOutlet UITextField *txtActualCostSubTotalValue;
@property (strong, nonatomic) IBOutlet UITextField *txtActualCostVATValue;
@property (strong, nonatomic) IBOutlet UITextField *txtOutstanding;

@property (strong, nonatomic) IBOutlet UITextField *txtEngineerMaterialSubTotalValue;
@property (strong, nonatomic) IBOutlet UITextField *txtEngineerMaterialVATValue;
@property (strong, nonatomic) IBOutlet UITextField *txtEngineerCostSubTotalValue;
@property (strong, nonatomic) IBOutlet UITextField *txtEngineerCostVATValue;

@property (strong, nonatomic) IBOutlet UILabel *lblProfitCommissionMessage;

@property (strong, nonatomic) IBOutlet UITextField *txtCompanyJobProfitValue;
@property (strong, nonatomic) IBOutlet UITextField *txtEngineersCommissionValue;
@property (strong, nonatomic) IBOutlet UITextField *txtCompanyProfiValue;

@property (strong, nonatomic) IBOutlet UIButton *btnCalculate;

//- (IBAction)pressCalculate:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutlet UIButton *btnPaymentDetail;

//- (IBAction)pressSubmit:(id)sender;
- (IBAction)MoreNoteClick:(UIButton *)sender;



@end
