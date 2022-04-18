//
//  AdditionalNotes.m
//  Partner Maintenance
//


#import "AdditionalNotes.h"

@interface AdditionalNotes ()

@end

@implementation AdditionalNotes

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnbacktapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnSubmitTapped:(id)sender
{
    if([self.delegate respondsToSelector:@selector(AdditionalNotesAdded:)]) {
        [self.delegate AdditionalNotesAdded:_txtvAdditionalNotes.text];
    }
      [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - TEXTVIEW DELEGATES
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    
    return YES;
}
@end
