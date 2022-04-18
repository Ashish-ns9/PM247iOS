//
//  GSMCappliancechecks.m
//  Partner Maintenance
//


#import "GSMCappliancechecks.h"

@interface GSMCappliancechecks ()

@end

@implementation GSMCappliancechecks

#pragma mark - viewDidLoad Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    _dicApplianceChecksData=[[NSMutableDictionary alloc]init];
   // _scrollView.contentSize=CGSizeMake(320,CGRectGetMaxY(_btnsubmit.frame)+20);
}

#pragma mark - UItextField Delegate Method
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    PrePoint = _scrollView.contentOffset;
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y-150);
    [_scrollView setContentOffset:scrollPoint animated:YES];
    return YES;
}




-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [_scrollView setContentOffset:PrePoint animated:YES];

    return YES;
}


#pragma mark - didReceiveMemoryWarning Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Back Press Method
- (IBAction)btnBackTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Submit Press Method
- (IBAction)btnSubmitapped:(id)sender
{
    [_dicApplianceChecksData setValue:[_segRemedial1 titleForSegmentAtIndex:_segRemedial1.selectedSegmentIndex] forKey:@"burnerInjectors"];
    [_dicApplianceChecksData setValue:_txtRemedial1.text forKey:@"burnerInjectorsText"];
    [_dicApplianceChecksData setValue:[_segRemedial2 titleForSegmentAtIndex:_segRemedial2.selectedSegmentIndex] forKey:@"heatEnchanger"];
    [_dicApplianceChecksData setValue:_txtRemedial2.text forKey:@"heatEnchangerText"];
    [_dicApplianceChecksData setValue:[_segRemedial3 titleForSegmentAtIndex:_segRemedial3.selectedSegmentIndex] forKey:@"ignition"];
    [_dicApplianceChecksData setValue:_txtRemedial3.text forKey:@"ignitionText"];
    [_dicApplianceChecksData setValue:[_segRemedial4 titleForSegmentAtIndex:_segRemedial4.selectedSegmentIndex] forKey:@"electrics"];
    [_dicApplianceChecksData setValue:_txtRemedial4.text forKey:@"electricsText"];
    [_dicApplianceChecksData setValue:[_segRemedial5 titleForSegmentAtIndex:_segRemedial5.selectedSegmentIndex] forKey:@"controls"];
    [_dicApplianceChecksData setValue:_txtRemedial1.text forKey:@"controlsText"];
    [_dicApplianceChecksData setValue:[_segRemedial6 titleForSegmentAtIndex:_segRemedial6.selectedSegmentIndex] forKey:@"gasWaterLeaks"];
    [_dicApplianceChecksData setValue:_txtRemedial6.text forKey:@"gasWaterLeaksText"];
    [_dicApplianceChecksData setValue:[_segRemedial7 titleForSegmentAtIndex:_segRemedial7.selectedSegmentIndex] forKey:@"gasConnection"];
    [_dicApplianceChecksData setValue:_txtRemedial1.text forKey:@"gasConnectionText"];
    [_dicApplianceChecksData setValue:[_segRemedial8 titleForSegmentAtIndex:_segRemedial8.selectedSegmentIndex] forKey:@"seals"];
    [_dicApplianceChecksData setValue:_txtRemedial1.text forKey:@"sealsText"];
    [_dicApplianceChecksData setValue:[_segRemedial9 titleForSegmentAtIndex:_segRemedial9.selectedSegmentIndex] forKey:@"gasPipework"];
    [_dicApplianceChecksData setValue:_txtRemedial9.text forKey:@"gasPipeworkText"];
    [_dicApplianceChecksData setValue:[_segRemedial10 titleForSegmentAtIndex:_segRemedial10.selectedSegmentIndex] forKey:@"fans"];
    [_dicApplianceChecksData setValue:_txtRemedial10.text forKey:@"fansText"];
    [_dicApplianceChecksData setValue:[_segRemedial11 titleForSegmentAtIndex:_segRemedial11.selectedSegmentIndex] forKey:@"firePlaceOpening"];
    [_dicApplianceChecksData setValue:_txtRemedial11.text forKey:@"firePlaceOpeningText"];
    [_dicApplianceChecksData setValue:[_segRemedial12 titleForSegmentAtIndex:_segRemedial12.selectedSegmentIndex] forKey:@"closurePlate"];
    [_dicApplianceChecksData setValue:_txtRemedial12.text forKey:@"closurePlateText"];
    [_dicApplianceChecksData setValue:[_segRemedial13 titleForSegmentAtIndex:_segRemedial13.selectedSegmentIndex] forKey:@"flamePicture"];
    [_dicApplianceChecksData setValue:_txtRemedial13.text forKey:@"flamePictureText"];
    [_dicApplianceChecksData setValue:[_segRemedial14 titleForSegmentAtIndex:_segRemedial14.selectedSegmentIndex] forKey:@"location"];
    [_dicApplianceChecksData setValue:_txtRemedial14.text forKey:@"locationText"];
    [_dicApplianceChecksData setValue:[_segRemedial15 titleForSegmentAtIndex:_segRemedial15.selectedSegmentIndex] forKey:@"stability"];
    [_dicApplianceChecksData setValue:_txtRemedial1.text forKey:@"stabilityText"];
    [_dicApplianceChecksData setValue:[_segRemedial16 titleForSegmentAtIndex:_segRemedial16.selectedSegmentIndex] forKey:@"returnAirPlenum"];
    [_dicApplianceChecksData setValue:_txtRemedial16.text forKey:@"returnAirPlenumText"];
    
    if([self.delegate respondsToSelector:@selector(GSMApplianceChecksData:)]) {
        [self.delegate GSMApplianceChecksData:_dicApplianceChecksData];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Segment Press Method
- (IBAction)btnsegRemedial1:(id)sender;
{
}
- (IBAction)btnsegRemedial2:(id)sender
{
}
- (IBAction)btnsegRemedial3:(id)sender
{
}
- (IBAction)btnsegRemedial4:(id)sender
{
}
- (IBAction)btnsegRemedial5:(id)sender
{
}
- (IBAction)btnsegRemedial6:(id)sender
{
}
- (IBAction)btnsegRemedial7:(id)sender
{
}
- (IBAction)btnsegRemedial8:(id)sender
{
}
- (IBAction)btnsegRemedial9:(id)sender
{
}
- (IBAction)btnsegRemedial10:(id)sender
{
}
- (IBAction)btnsegRemedial11:(id)sender
{
}
- (IBAction)btnsegRemedial12:(id)sender
{
}
- (IBAction)btnsegRemedial13:(id)sender
{
}
- (IBAction)btnsegRemedial14:(id)sender
{
}
- (IBAction)btnsegRemedial15:(id)sender
{
}
- (IBAction)btnsegRemedial16:(id)sender
{
}

@end
