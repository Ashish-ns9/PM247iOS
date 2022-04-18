//
//  AdditionalNotes.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>

@protocol AdditionalNoteDelegates <NSObject>

-(void)AdditionalNotesAdded:(NSString *)note;


@end


@interface AdditionalNotes : UIViewController<UITextViewDelegate>


@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
- (IBAction)btnSubmitTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *txtvAdditionalNotes;
@property(weak,nonatomic)id <AdditionalNoteDelegates>delegate;

- (IBAction)btnbacktapped:(id)sender;
@end
