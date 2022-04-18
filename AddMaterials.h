//
//  AddMaterials.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "CreateJob.h"

@protocol AddMaterialsDelegates <NSObject>

-(void)addItemViewController:(id)controller didFinishEnteringItem:(NSMutableArray *)Materials;

@end

@interface AddMaterials : ViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIWebViewDelegate>
{
    
    UIScrollView *imgScroll,*mainBgNoteDesc;
    NSMutableArray *arrImages;
    UIImageView *imageV;
    UIWebView *webV;
    MBProgressHUD *hud;
    
    UIView *bgVwNoteDesc;
    UIButton *btnCrossNoteDesc;
    NSURLConnection *connDownloadImage;
    
    NSString *OnAccount;
    
    UIScrollView *mainBg;
    UIView *bgVw;
    UIButton *btnCross,*btnSave;
    UITextField *txtMaterialNo,*txtMaterialType,*txtEngineerTotal,*txtActualTotal;
    UITextView *txtvNoteBody;
    
    UITableView *tblView;
    UITextField *Activetxtfld;
    NSArray *arrFeedTblPopup;
    
    NSMutableDictionary *dicMaterials;
    NSMutableArray *Materials;
   
    NSString *strFromCustomerClass;
    
    NSURLConnection *connPostMaterials;
    NSMutableData *_responseData;
    CGFloat currX;
}

@property (nonatomic) NSUInteger totalBytes;
@property (nonatomic) NSUInteger receivedBytes;
@property (nonatomic) NSMutableData *imageData;



@property(nonatomic,retain)NSString *jobID;

@property(nonatomic,retain)NSString *strFromCustomerClass;
@property(nonatomic,retain)NSString *strHeading,*jobStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblHeading;
@property (strong, nonatomic) IBOutlet UITableView *tblMaterials;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property(nonatomic,retain)NSMutableArray *Materials;

- (IBAction)btnAddTapped:(id)sender;
- (IBAction)backTapped:(id)sender;
@property (nonatomic, weak) id <AddMaterialsDelegates> delegate;
@end
