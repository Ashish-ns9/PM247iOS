//
//  FinalChecks.m
//  Partner Maintenance
//


#import "FinalChecks.h"

@interface FinalChecks ()

@end

@implementation FinalChecks

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataFinalChecks=[[NSMutableDictionary alloc]init];
    
    _scrollFinalChk.contentSize=CGSizeMake(320,CGRectGetMaxY(_btnSubmit.frame)+20);
    
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"DONE " style:UIBarButtonItemStyleBordered target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    _txtinitialRd.inputAccessoryView = numberToolbar;
     _txtFinalRd.inputAccessoryView = numberToolbar;
       

    
}




-(void)doneWithNumberPad{
    [self.view endEditing:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnBackTapped:(id)sender{
 [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}

- (IBAction)btnGastightnessTapped:(UISegmentedControl *)sender
{

    
}
- (IBAction)btnEmergencyControlValveTapped:(UISegmentedControl *)sender
{
   

}
- (IBAction)btnGasinstallationpipeworkTapped:(UISegmentedControl *)sender
{
   

    
}
- (IBAction)btnMainprotectiveTapped:(UISegmentedControl *)sender
{
 

}
- (IBAction)btnCOalarmfittedTapped:(UISegmentedControl *)sender
{
 

    
}
- (IBAction)btnCOalarmworkingTapped:(UISegmentedControl *)sender
{
    
}
- (IBAction)btnSubmitTapped:(id)sender
{
    
    NSLog(@"asdasdasdasdads");
    
    [_dataFinalChecks setValue:_txtinitialRd.text forKey:@"InitialReadings"];
    [_dataFinalChecks setValue:_txtFinalRd.text forKey:@"FinalReadings"];
    [_dataFinalChecks setValue:[_segGastightness titleForSegmentAtIndex:_segGastightness.selectedSegmentIndex] forKey:@"GasTightnessRead"];
    [_dataFinalChecks setValue:[_segEmergencyControlValve titleForSegmentAtIndex:_segEmergencyControlValve.selectedSegmentIndex] forKey:@"EmrValveAccessible"];
    [_dataFinalChecks setValue:[_segGasinstallationpipework titleForSegmentAtIndex:_segGasinstallationpipework.selectedSegmentIndex] forKey:@"PipeWorkVisual"];
    [_dataFinalChecks setValue:[_segMainprotective titleForSegmentAtIndex:_segMainprotective.selectedSegmentIndex] forKey:@"MainProtectiveEquip"];
    [_dataFinalChecks setValue:[_segCOalarmfitted titleForSegmentAtIndex:_segCOalarmfitted.selectedSegmentIndex] forKey:@"COalarmFitted"];
    [_dataFinalChecks setValue:[_segCOalarmworking titleForSegmentAtIndex:_segCOalarmworking.selectedSegmentIndex] forKey:@"COalarmWorking"];

     [_dataFinalChecks setValue:_txtVwinstalDefect.text forKey:@"InstalationDefects"];
    [_dataFinalChecks setValue:_txtVwRemdAction.text forKey:@"RemedialActionTaken"];


    
        if([self.delegate respondsToSelector:@selector(FinalChecksDidAddedWithData:)]) {
            [self.delegate FinalChecksDidAddedWithData:_dataFinalChecks];
        }
    
      [self dismissViewControllerAnimated:YES completion:nil];
 
}








#pragma mark - TEXTVIEW DELEGATES

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
     PeVscrollPoint=_scrollFinalChk.contentOffset;
    CGPoint scrollPoint = CGPointMake(0, textView.frame.origin.y-150);
    [_scrollFinalChk setContentOffset:scrollPoint animated:YES];
    
    return YES;
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if([text isEqualToString:@"\n"])
    {
         [_scrollFinalChk setContentOffset:PeVscrollPoint animated:YES];
        [textView resignFirstResponder];
    }
    
    return textView.text.length + (text.length - range.length) <= 200;
    
}







@end



