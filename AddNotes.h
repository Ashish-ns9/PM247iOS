
//
//  AddNotes.h
//  Partner Maintenance

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "DefaultSettings.h"
#import "MBProgressHUD.h"

@protocol AddNotesDelegates <NSObject>

-(void)addItemViewController:(id)controller didFinishEnteringItem:(NSMutableArray *)Notes;

@end

@interface AddNotes : ViewController<UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate,UIWebViewDelegate>
{
    UIView *bgVw,*mainBg;
    UIButton *btnCross,*btnAddNotes;
    UITextField *txtNoteType,*txtNoteTo;
    UITextView *txtvNoteBody;
    UIScrollView *imgScroll,*mainBgNoteDesc;
    NSMutableArray *arrImages;
    
    NSString *Heading;
    
    NSMutableArray *arrMAllNotes;
    
    NSDictionary *previouslyTypedNotes;
    NSMutableArray *Notes;
    UITableView *tblView;
    NSArray *arrFeedTblPopup,*arrFeed;
    UITextField *Activetxtfld;
   
    
    NSMutableDictionary *dicNotes;
    
    
    NSString *strFromCustomerClass;
    
    NSURLConnection *connPostNote;
    
    UIView *bgVwNoteDesc;
    UIButton *btnCrossNoteDesc;
    UITextView *txtvNoteBodyNoteDesc;
    NSMutableData *_responseData;
    UIImageView *imageV;
    UIWebView *webV;
    
    NSURLConnection *connDownloadImage;
    
    MBProgressHUD *hud;
    
    NSMutableArray *prevNotes,*newNotes;
    
    
    
}

@property (nonatomic) NSUInteger totalBytes;
@property (nonatomic) NSUInteger receivedBytes;
@property (nonatomic) NSMutableData *imageData;

@property (strong, nonatomic) IBOutlet UIImageView *selected;

@property(nonatomic,retain)NSString *strFromCustomerClass,*jobID;

@property(nonatomic,retain)NSMutableArray *Notes;
@property(nonatomic,retain)NSMutableArray *arrMAllNotes;

@property(nonatomic,retain)NSString *strHeading,*jobStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblHeading;
@property (strong, nonatomic) IBOutlet UITableView *tabvNotes;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
- (IBAction)btnPrevNotes:(id)sender;
- (IBAction)btnNewNotesTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnPrevNotes;
@property (strong, nonatomic) IBOutlet UIButton *btnNewNotes;

@property (nonatomic, weak) id <AddNotesDelegates> delegate;


- (IBAction)btnAddTapped:(id)sender;
- (IBAction)backTapped:(id)sender;

@end
