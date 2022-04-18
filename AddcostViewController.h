//
//  AddcostViewController.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "CreateJob.h"
@protocol AddCostDelegates <NSObject>

-(void)addItemViewController:(id)controller didFinishEnteringItem:(NSMutableArray *)Costs;

@end

@interface AddCostViewController : ViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,UIWebViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSString *OnAccount;
    UIScrollView *mainBg;
    UIView *bgVw;
    UIButton *btnCross,*btnSave;
    
    UITextField *txtCostNo,*txtCostType,*txtEngineerTotal,*txtActualTotal;
    UITextView *txtvNoteBody;
    UITableView *tblView;
    UITextField *Activetxtfld;
    
    NSArray *arrFeedTblPopup;
    NSMutableDictionary *dicCosts;
    NSMutableArray *Costs;
    
    NSString *strFromCustomerClass;
   
    UIScrollView *imgScroll,*mainBgNoteDesc;
    NSMutableArray *arrImages;
    UIImageView *imageV;
    UIWebView *webV;
    MBProgressHUD *hud;
    UIView *bgVwNoteDesc;
    UIButton *btnCrossNoteDesc;
    NSURLConnection *connDownloadImage;
    
    NSURLConnection *connPostCost;
    NSMutableData *_responseData;
    CGFloat currX;
    id actvtextbox;
    
    
}

@property (nonatomic) NSUInteger totalBytes;
@property (nonatomic) NSUInteger receivedBytes;
@property (nonatomic) NSMutableData *imageData;
@property(nonatomic,retain)NSString *jobID;

@property(nonatomic,retain)NSString *strFromCustomerClass;
@property(nonatomic,retain)NSString *strHeading,*jobStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblHeading;

@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property (strong, nonatomic) IBOutlet UITableView *tblCost;
@property(nonatomic,retain)NSMutableArray *Costs;
- (IBAction)backTapped:(id)sender;
- (IBAction)btnAddTapped:(id)sender;

@property (nonatomic, weak) id <AddCostDelegates> delegate;

@end
