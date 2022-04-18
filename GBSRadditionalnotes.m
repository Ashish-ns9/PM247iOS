//
//  GBSRadditionalnotes.m
//  Partner Maintenance


#import "GBSRadditionalnotes.h"

@interface GBSRadditionalnotes ()

@end

@implementation GBSRadditionalnotes

#pragma mark - viewDidLoad Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    _dicNotes=[[NSMutableDictionary alloc]init];
}

#pragma mark - didReceiveMemoryWarning Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Back Press Method
- (IBAction)btnBackTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Submit Press Method
- (IBAction)btnSubmitTapped:(id)sender
{
    [_dicNotes setValue:_txtvadditionalNotes.text forKey:@"AdditionalNote"];
    [_dicNotes setValue:_txtvRequiredspares.text forKey:@"RequiredSpares"];
    
    if([self.delegate respondsToSelector:@selector(GBSAdditionalNoteAdded:)]) {
        [self.delegate GBSAdditionalNoteAdded:_dicNotes];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



#pragma mark - TEXTVIEW DELEGATES

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    prePoint = _scrollview.contentOffset;
    CGPoint scrollPoint = CGPointMake(0, textView.frame.origin.y-150);
    [_scrollview setContentOffset:scrollPoint animated:YES];
    
    return YES;
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if([text isEqualToString:@"\n"])
    {
        [_scrollview setContentOffset:prePoint animated:YES];
        [textView resignFirstResponder];
    }
    
    return textView.text.length + (text.length - range.length) <= 200;
    
}



@end
