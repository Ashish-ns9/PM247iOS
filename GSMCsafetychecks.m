//
//  GSMCsafetychecks.m
//  Partner Maintenance
//


#import "GSMCsafetychecks.h"

@interface GSMCsafetychecks ()

@end

@implementation GSMCsafetychecks

#pragma mark - viewDidLoad Method
- (void)viewDidLoad {
    [super viewDidLoad];
      _dicSafetyData=[[NSMutableDictionary alloc]init];
  //  _scrollView.contentSize=CGSizeMake(320,CGRectGetMaxY(_btnsubmit.frame)+20);
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
- (IBAction)btnSubmitapped:(id)sender
{
    
    [_dicSafetyData setValue:[_segVentilation titleForSegmentAtIndex:_segVentilation.selectedSegmentIndex] forKey:@"Ventilation"];
    [_dicSafetyData setValue:_txtRemedial1.text forKey:@"VentilationText"];
    [_dicSafetyData setValue:[_segFuelTermination titleForSegmentAtIndex:_segFuelTermination.selectedSegmentIndex] forKey:@"FlueTermination"];
    [_dicSafetyData setValue:_txtRemedial2.text forKey:@"FlueTerminationText"];
    [_dicSafetyData setValue:[_segFlueflowtest titleForSegmentAtIndex:_segFlueflowtest.selectedSegmentIndex] forKey:@"FlueFlowTest"];
    [_dicSafetyData setValue:_txtRemedial3.text forKey:@"FlueFlowTestText"];
    [_dicSafetyData setValue:[_segSpillagetest titleForSegmentAtIndex:_segSpillagetest.selectedSegmentIndex] forKey:@"SpillageTest"];
    [_dicSafetyData setValue:_txtRemedial4.text forKey:@"SpillageTestText"];
    [_dicSafetyData setValue:[_segOperatingPressure titleForSegmentAtIndex:_segOperatingPressure.selectedSegmentIndex] forKey:@"OperatingPressure"];
    [_dicSafetyData setValue:_txtRemedial4.text forKey:@"OperatingPressureText"];
    [_dicSafetyData setValue:[_segSafetydevice titleForSegmentAtIndex:_segSafetydevice.selectedSegmentIndex] forKey:@"SafetyDevice"];
    [_dicSafetyData setValue:_txtRemedial4.text forKey:@"SafetyDeviceText"];
    [_dicSafetyData setValue:[_segOthers titleForSegmentAtIndex:_segOthers.selectedSegmentIndex] forKey:@"Others"];
    [_dicSafetyData setValue:_txtRemedial4.text forKey:@"OthersText"];
    
    if([self.delegate respondsToSelector:@selector(GSMSafetyDataRecord:)]) {
        [self.delegate GSMSafetyDataRecord:_dicSafetyData];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UItextfield Delegate Method
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    PrePoint = _scrollView.contentOffset;
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y-150);
    [_scrollView setContentOffset:scrollPoint animated:YES];

    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [_scrollView setContentOffset:PrePoint animated:YES];
    return YES;
    
}

#pragma mark - Segment Press Method
- (IBAction)btnsegVentilationTapped:(id)sender
{
}
- (IBAction)btnsegFuelTerminationTapped:(id)sender
{
}
- (IBAction)btnsegFlueflowtestTapped:(id)sender
{
}
- (IBAction)btnsegSpillagetestTapped:(id)sender
{
}
- (IBAction)btnsegOperatingPressureTapped:(id)sender
{
}
- (IBAction)btnsegSafetydeviceTapped:(id)sender
{
}
- (IBAction)btnsegOthersTapped:(id)sender
{
}


@end
