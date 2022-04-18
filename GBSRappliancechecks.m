//
//  GBSRappliancechecks.m
//  Partner Maintenance


#import "GBSRappliancechecks.h"

@interface GBSRappliancechecks ()

@end

@implementation GBSRappliancechecks

#pragma mark - viewDidLoad Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    _dicAppliaceChk =[[NSMutableDictionary alloc]init];
  //  _scrollView.contentSize=CGSizeMake(320,CGRectGetMaxY(_btnSubmit.frame)+20);
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

#pragma mark - Segment press Method
- (IBAction)btnsegPC1Tapped:(id)sender
{
}
- (IBAction)btnsegPC2Tapped:(id)sender
{
}
- (IBAction)btnsegPC3Tapped:(id)sender
{
}
- (IBAction)btnsegPC4Tapped:(id)sender
{
}
- (IBAction)btnsegPC5Tapped:(id)sender
{
}
- (IBAction)btnsegPC6Tapped:(id)sender
{
}
- (IBAction)btnsegPC7Tapped:(id)sender
{
}
- (IBAction)btnsegSC1Tapped:(id)sender
{
}
- (IBAction)btnsegSC2Tapped:(id)sender
{
}
- (IBAction)btnsegSC3Tapped:(id)sender
{
}
- (IBAction)btnsegSC4Tapped:(id)sender
{
}
- (IBAction)btnsegSC5Tapped:(id)sender
{
}
- (IBAction)btnsegSC6Tapped:(id)sender
{
}
- (IBAction)btnsegSC7Tapped:(id)sender
{
}
- (IBAction)btnsegSC8Tapped:(id)sender
{
}
- (IBAction)btnsegSO1Tapped:(id)sender
{
}
- (IBAction)btnsegSO2Tapped:(id)sender
{
}
- (IBAction)btnsegSO3Tapped:(id)sender
{
}
- (IBAction)btnsegSO4Tapped:(id)sender
{
}
- (IBAction)btnsegSO5Tapped:(id)sender
{
}
- (IBAction)btnsegSO6Tapped:(id)sender
{
}
- (IBAction)btnsegSO7Tapped:(id)sender
{
}

#pragma mark - Submit Press Method
- (IBAction)btnSubmitTapped:(id)sender
{
    [_dicAppliaceChk setValue:[_segPC1 titleForSegmentAtIndex:_segPC1.selectedSegmentIndex] forKey:@"flueAtmospheric"];
    [_dicAppliaceChk setValue:[_segPC2 titleForSegmentAtIndex:_segPC2.selectedSegmentIndex] forKey:@"ventilationSize"];
    [_dicAppliaceChk setValue:[_segPC3 titleForSegmentAtIndex:_segPC3.selectedSegmentIndex] forKey:@"waterFuelSound"];
    [_dicAppliaceChk setValue:[_segPC4 titleForSegmentAtIndex:_segPC4.selectedSegmentIndex] forKey:@"electricallyFused"];
    [_dicAppliaceChk setValue:[_segPC5 titleForSegmentAtIndex:_segPC5.selectedSegmentIndex] forKey:@"correctValvingArrangement"];
    [_dicAppliaceChk setValue:[_segPC6 titleForSegmentAtIndex:_segPC6.selectedSegmentIndex] forKey:@"isolationAviailable"];
    [_dicAppliaceChk setValue:[_segPC7 titleForSegmentAtIndex:_segPC7.selectedSegmentIndex] forKey:@"boilerPlantrrolClean"];
    [_dicAppliaceChk setValue:[_segSC1 titleForSegmentAtIndex:_segSC1.selectedSegmentIndex] forKey:@"heatExchanger"];
    [_dicAppliaceChk setValue:[_segSC2 titleForSegmentAtIndex:_segSC2.selectedSegmentIndex] forKey:@"ignition"];
    [_dicAppliaceChk setValue:[_segSC3 titleForSegmentAtIndex:_segSC3.selectedSegmentIndex] forKey:@"gasValve"];
    [_dicAppliaceChk setValue:[_segSC4 titleForSegmentAtIndex:_segSC4.selectedSegmentIndex] forKey:@"fan"];
    [_dicAppliaceChk setValue:[_segSC5 titleForSegmentAtIndex:_segSC5.selectedSegmentIndex] forKey:@"safetyDevice"];
    [_dicAppliaceChk setValue:[_segSC6 titleForSegmentAtIndex:_segSC6.selectedSegmentIndex] forKey:@"controlBox"];
    [_dicAppliaceChk setValue:[_segSC7 titleForSegmentAtIndex:_segSC7.selectedSegmentIndex] forKey:@"burnersAndPilot"];
    [_dicAppliaceChk setValue:[_segSC7 titleForSegmentAtIndex:_segSC8.selectedSegmentIndex] forKey:@"FuelPressureAndType"];
    [_dicAppliaceChk setValue:[_segSO1 titleForSegmentAtIndex:_segSO1.selectedSegmentIndex] forKey:@"burnerWashedAndCleaned"];
    [_dicAppliaceChk setValue:[_segSO2 titleForSegmentAtIndex:_segSO2.selectedSegmentIndex] forKey:@"pilotAssembly"];
    [_dicAppliaceChk setValue:[_segSO3 titleForSegmentAtIndex:_segSO3.selectedSegmentIndex] forKey:@"ignitionSystemCleaned"];
    [_dicAppliaceChk setValue:[_segSO4 titleForSegmentAtIndex:_segSO4.selectedSegmentIndex] forKey:@"burnerfanAndAirwaysCleaned"];
    [_dicAppliaceChk setValue:[_segSO5 titleForSegmentAtIndex:_segSO5.selectedSegmentIndex] forKey:@"heatExchangerClean"];
    [_dicAppliaceChk setValue:[_segSO6 titleForSegmentAtIndex:_segSO6.selectedSegmentIndex] forKey:@"fuelElectricalSupplyConnected"];
    [_dicAppliaceChk setValue:[_segSO7 titleForSegmentAtIndex:_segSO7.selectedSegmentIndex] forKey:@"interLocksInPlace"];

    if([self.delegate respondsToSelector:@selector(GBSApplianceCheckData:)]) {
        [self.delegate GBSApplianceCheckData:_dicAppliaceChk];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
