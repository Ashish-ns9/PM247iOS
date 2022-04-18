//
//  SignAgreement.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "ViewController.h"

#import "AppDelegate.h"
#import "PJRSignatureView.h"
#import <QuartzCore/QuartzCore.h>
#import "GasForms.h"
#import "GlobalDirector.h"


@interface SignAgreement : ViewController<NSURLConnectionDataDelegate,NSURLConnectionDataDelegate,UIWebViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,GasFormDelegate,UIPrintInteractionControllerDelegate,MaskingDelegate>
{
    
    
    UITextField *selectInvoiceNo;
    UITextField *Activetxtfld;
    NSMutableArray *arrFeedTblPopup;
    UITableView *tblView;
    UIScrollView *popUpVW;
    UIImageView *ImgSign;
    
    
    BOOL imgCheckSignature;
   
    UITextView *txtvNoteInvoice;
    
    NSString *strHeading;
    CGFloat frameWidth;
    CGFloat frameHeight;
    CGFloat XX ,YY;
    NSMutableData *imageData;
    PJRSignatureView *scratchableView;
    NSURLConnection *connPostAgreement,*connGetInvoiceLink,*connSetInvoiceLink;
    NSMutableData *_responseData;
    UIView *mainBgNoteDesc;
    UIButton *btnCrossNoteDesc;
    UIView *viewCustomer1stAgreement;
    UIActivityIndicatorView *hud;
    UIScrollView *bgVwNoteDesc;
    
    NSString *agreementLink;
    UIWebView *webVw;
    
    UIScrollView *scrlAgreements;
    
    UIButton *btnPrint,*btnEmail,*btnDropBox;
    
    
    //------Accept Agreement1---------
    UIView *mainBg11,*bgVw11;
    //--------------------------------
    //------Accept Agreement2---------
    UIControl *mainBg22,*bgVw22,*mainBg33;
    //--------------------------------
    
    //----- Agreement1 ------
    UIView *mainBg1,*bgVw1;
    UIButton *btnAcceptYesPress,*btnDeclineNoPress;
    
    //----- Agreement2 ------
    UIView *mainBg2,*bgVw2;
    UIButton *btnAcceptYesPress2,*btnDeclineNoPress2;
    
    UIControl *mainBg,*bgVw;
    UIButton *btnCross;
    NSMutableDictionary *arrAgrLinks;
    
    UISegmentedControl *segmentedControl ;
    
    NSURLConnection *connEmailPost,*connDropboxPost;
    BOOL IsGasFormSigned;
    NSString *signURL;
    MBProgressHUD *hudRefEmail;
    
}

// Complete process popup
@property (strong, nonatomic) IBOutlet UIView *viewNotePopup;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segNote;
@property (strong, nonatomic) IBOutlet UITextView *txtNoteDesComplete;


@property(nonatomic,assign)CGFloat frameWidth,frameHeight,XX,YY;
@property (strong, nonatomic) IBOutlet UILabel *lblHeading;
@property(nonatomic,retain)NSString *strHeading,*jobID,*txtRecomandation;
@property(assign)BOOL isAgreementSigned,isSecondAgreement,isInvoice;
-(void)preparingAutographPad;
-(void)cleanPress:(id)sender;
- (UIImage*)captureView:(UIView *)view;
- (IBAction)backTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imgvHeader;
@property(strong,nonatomic)NSDictionary *JobDic;
@property(strong,nonatomic)UITextView *txtVRecomandation;


@end
