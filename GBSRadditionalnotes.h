//
//  GBSRadditionalnotes.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>

@protocol GBSAdditionalNoteDelegate <NSObject>

-(void)GBSAdditionalNoteAdded:(NSDictionary *)data;


@end


@interface GBSRadditionalnotes : UIViewController<UITextViewDelegate>
{
    CGPoint prePoint;
}
@property(retain,nonatomic)NSMutableDictionary *dicNotes;
@property(weak,nonatomic)id <GBSAdditionalNoteDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@property (strong, nonatomic) IBOutlet UITextView *txtvadditionalNotes;
@property (strong, nonatomic) IBOutlet UITextView *txtvRequiredspares;

@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
- (IBAction)btnSubmitTapped:(id)sender;


- (IBAction)btnBackTapped:(id)sender;
@end
