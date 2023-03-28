//
//  GSMCfindings.m
//  Partner Maintenance
//


#import "GSMCfindings.h"

@interface GSMCfindings ()

@end

@implementation GSMCfindings

#pragma mark - viewDidLoad Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    _dicFindings=[[NSMutableDictionary alloc]init];
  //  _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width, CGRectGetMaxY(_btnsubmit.frame));
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

#pragma mark - Segement Press Method
- (IBAction)btnInstallationSafetousetapped:(id)sender
{
}
- (IBAction)btnInstallationNotapped:(id)sender
{
}
- (IBAction)btnInstallationCnfirmtapped:(id)sender
{
}

#pragma mark - Submit Press Method
- (IBAction)btnSubmitapped:(id)sender
{
    
    [_dicFindings setValue:[_segInstallationSafetouse titleForSegmentAtIndex:_segInstallationSafetouse.selectedSegmentIndex] forKey:@"InstallationSafetouse"];
    [_dicFindings setValue:[_segInstallationNo titleForSegmentAtIndex:_segInstallationNo.selectedSegmentIndex]  forKey:@"InstallationNo"];
    [_dicFindings setValue:[_segInstallationCnfirm titleForSegmentAtIndex:_segInstallationCnfirm.selectedSegmentIndex] forKey:@"InstallationCnfirm"];
    [_dicFindings setValue:_txtvRemedialWork.text forKey:@"RemidialWork"];
    
    if([self.delegate respondsToSelector:@selector(GSMFindingDataRecord:)]) {
        [self.delegate GSMFindingDataRecord:_dicFindings];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - TEXTVIEW DELEGATES

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    PrePoint = _scrollView.contentOffset;
    CGPoint scrollPoint = CGPointMake(0, textView.frame.origin.y-150);
    [_scrollView setContentOffset:scrollPoint animated:YES];
    
    return YES;
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if([text isEqualToString:@"\n"])
    {
        [_scrollView setContentOffset:PrePoint animated:YES];
        [textView resignFirstResponder];
    }
    
    return textView.text.length + (text.length - range.length) <= 200;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
