//
//  PaymentDtlsVC.h
//  PM247
//


#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ViewController.h"
#import "KLCPopup.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ImageViewCat.h"

@interface PaymentDtlsVC : ViewController<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIWebViewDelegate>
{
    NSMutableArray *arrPayments;
    NSMutableArray *arrModeList;
    KLCPopup *popPicker,*popImage;
    
    NSString *strAmtDue;
    NSString *desc;

    NSInteger index;
    
    //Image
     UIScrollView *mainBgNoteDes,*mainBgNoteDesc;
    IBOutlet UIScrollView *imgScroll;
     UIButton *btnCrossNoteDesc;
    IBOutlet UIImageView *imgAttacted;
    
     UIView *bgVwNoteDesc;
    IBOutlet UIWebView *webV;
    MBProgressHUD *hud;
    
    IBOutlet UIView *viewImgPopup;
    
    NSMutableArray *arrImages;
    
    NSInteger jobPaymentId;
    
    BOOL isEdit;
    
    int editedAmount;
   
}

@property (nonatomic) NSUInteger totalBytes;
@property (nonatomic) NSUInteger receivedBytes;
@property (nonatomic) NSMutableData *imageData;

@property(nonatomic,retain)  NSDictionary *dictJob;
@property(nonatomic,retain)  NSString *outStandingAmount;

@property (strong, nonatomic) IBOutlet UITableView *tblPayment;
@property (strong, nonatomic) IBOutlet UIView *viewTakePayment;

@property (strong, nonatomic) IBOutlet UIView *viewPop;
@property (strong, nonatomic) IBOutlet UITextField *txtPayType;
@property (strong, nonatomic) IBOutlet UITextField *txtAmt;
@property (strong, nonatomic) IBOutlet UITextView *txtVDes;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

@property (strong, nonatomic) IBOutlet UIView *viewPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerPayment;


- (IBAction)ClickTakePayment:(UIButton *)sender;
- (IBAction)ClickCancel:(UIButton *)sender;
- (IBAction)ClickSubmit:(UIButton *)sender;


- (IBAction)CancelPicker:(UIButton *)sender;
- (IBAction)PickerDone:(UIButton *)sender;


@end
