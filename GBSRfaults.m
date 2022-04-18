//
//  GBSRfaults.m
//  Partner Maintenance


#import "GBSRfaults.h"

@interface GBSRfaults ()

@end

@implementation GBSRfaults

#pragma mark - viewDidLoad Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    _dicFaultsAction=[[NSMutableDictionary alloc]init];
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

#pragma mark - Segment Press Method
- (IBAction)btnsegWarningNoticeTapped:(id)sender
{
}

#pragma mark - Submit Press Method
- (IBAction)btnSubmitTapped:(id)sender
{
    [_dicFaultsAction setValue:_txtvFaults.text forKey:@"Faults"];
    [_dicFaultsAction setValue:_txtvRemedialworkactiontaken.text forKey:@"RemedialAction"];
    [_dicFaultsAction setValue:[_segWarningNotice titleForSegmentAtIndex:_segWarningNotice.selectedSegmentIndex] forKey:@"WarningNoticeIssued"];
    [_dicFaultsAction setValue:_txtWarningNoticeNo.text forKey:@"WarningNoticeNo"];
    
    if([self.delegate respondsToSelector:@selector(GBSFaultsData:)]) {
        [self.delegate GBSFaultsData:_dicFaultsAction];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}




-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_scrollview setContentOffset:prePoint animated:YES];
    [textField resignFirstResponder];
    return YES;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    prePoint = _scrollview.contentOffset;
    
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y-200);
    [_scrollview setContentOffset:scrollPoint animated:YES];
    return YES;
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
