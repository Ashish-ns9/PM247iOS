//
//  BoilerChecks.m
//  Partner Maintenance
//


#import "BoilerChecks.h"
#import "GlobalDirector.h"
@interface BoilerChecks ()

@end

@implementation BoilerChecks

- (void)viewDidLoad {
    [super viewDidLoad];
    _dicBoilerChkData=[[NSMutableDictionary alloc]init];
    
    // Do any additional setup after loading the view from its nib.
   
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"DONE " style:UIBarButtonItemStyleBordered target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    _txtAllSystem3.inputAccessoryView = numberToolbar;
    _txtGasRate.inputAccessoryView = numberToolbar;
     _txtBurnerOperatingPressure.inputAccessoryView = numberToolbar;
     _txtGasIntentPressure.inputAccessoryView = numberToolbar;
    _txtCentralHeatingFlow.inputAccessoryView = numberToolbar;
    _txtCentralHeatingReturn.inputAccessoryView = numberToolbar;
    
    _txtDHWgasrate.inputAccessoryView = numberToolbar;
    _txtDHWburneroperatingpressure.inputAccessoryView = numberToolbar;
    _txtDHWgasintentpressure.inputAccessoryView = numberToolbar;
    _txtDHWcoldwaterintent.inputAccessoryView = numberToolbar;
    _txtDHWhotwateroutlet.inputAccessoryView = numberToolbar;
    _txtDHWwaterflowrate.inputAccessoryView = numberToolbar;
    
     _txtallInstallationCO1.inputAccessoryView = numberToolbar;
     _txtallInstallationRatio1.inputAccessoryView = numberToolbar;
     _txtallInstallationCO2.inputAccessoryView = numberToolbar;
     _txtallInstallationRatio2.inputAccessoryView = numberToolbar;
    
    
    
   
    
}





-(void)doneWithNumberPad{
  
    [self.view endEditing:YES];
}






-(void)viewDidAppear:(BOOL)animated{
  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnBackTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)btnsegControls1:(id)sender{
    
}
- (IBAction)btnsegControls2:(id)sender{
    
}
- (IBAction)btnsegControls3:(id)sender{
    
}
- (IBAction)btnsegControls4:(id)sender{
    
}
- (IBAction)btnsegControls5:(id)sender{
    
}
- (IBAction)btnsegControls6:(id)sender{
    
}
- (IBAction)btnsegControls7:(id)sender{
    
}
- (IBAction)btnsegControls8:(id)sender{
    
}
- (IBAction)btnsegControls9:(id)sender{
    
}
- (IBAction)btnsegControls10:(id)sender{
    
}
- (IBAction)btnsegControls11:(id)sender{
    
}

- (IBAction)btnsegAllSystem1:(id)sender{
    
}
- (IBAction)btnsegAllSystem2:(id)sender{
    
}

- (IBAction)btnsegCombinationBoiler1:(id)sender{
    
}
- (IBAction)btnsegCombinationBoiler2:(id)sender{
    
}

- (IBAction)btnsegtxtDHWcheckedHotWater:(id)sender{
    
}
- (IBAction)btnsegCondensingBoilersOnly:(id)sender{
    
}

- (IBAction)btnsegAllInstallation1:(id)sender{
    
}
- (IBAction)btnsegAllInstallation2:(id)sender{
    
}
- (IBAction)btnsegAllInstallation3:(id)sender{
    
}
- (IBAction)btnsegAllInstallation4:(id)sender{
    
}

- (IBAction)btnSubmitapped:(id)sender
{
    
    NSLog(@"txtLocation :%@",_txtLocation.text);
    NSLog(@"txtapplianceMake :%@",_txtapplianceMake.text);
    NSLog(@"txtApplianceModel :%@",_txtApplianceModel.text);
    NSLog(@"txtapplianceSerialno %@",_txtapplianceSerialno.text);
 
    [_dicBoilerChkData setValue:_txtLocation.text forKey:@"Location"];
    
    [_dicBoilerChkData setValue:_txtapplianceMake.text forKey:@"ApplianceMake"];
    [_dicBoilerChkData setValue:_txtApplianceModel.text forKey:@"ApplianceModel"];
    [_dicBoilerChkData setValue:_txtapplianceSerialno.text forKey:@"SerialNumber"];
    
    [_dicBoilerChkData setValue:[_segControls1 titleForSegmentAtIndex:_segControls1.selectedSegmentIndex] forKey:@"roomThermostatFitted"];
    [_dicBoilerChkData setValue:[_segControls2 titleForSegmentAtIndex:_segControls2.selectedSegmentIndex] forKey:@"progRoomThermostatFitted"];
    [_dicBoilerChkData setValue:[_segControls3 titleForSegmentAtIndex:_segControls3.selectedSegmentIndex] forKey:@"loadWeatherComFitted"];
    [_dicBoilerChkData setValue:[_segControls4 titleForSegmentAtIndex:_segControls4.selectedSegmentIndex] forKey:@"OptimumStartControlFitted"];
    [_dicBoilerChkData setValue:[_segControls5 titleForSegmentAtIndex:_segControls5.selectedSegmentIndex] forKey:@"cylinderThermostatAndProgTimer"];
    [_dicBoilerChkData setValue:[_segControls6 titleForSegmentAtIndex:_segControls6.selectedSegmentIndex] forKey:@"combinationBoiler"];
    [_dicBoilerChkData setValue:[_segControls7 titleForSegmentAtIndex:_segControls7.selectedSegmentIndex] forKey:@"heatingZoneValvFitted"];
    [_dicBoilerChkData setValue:[_segControls8 titleForSegmentAtIndex:_segControls8.selectedSegmentIndex] forKey:@"hotWaterZoneValveFitted"];
    [_dicBoilerChkData setValue:[_segControls9 titleForSegmentAtIndex:_segControls9.selectedSegmentIndex] forKey:@"thermostaticValveFitted"];
    [_dicBoilerChkData setValue:[_segControls10 titleForSegmentAtIndex:_segControls10.selectedSegmentIndex] forKey:@"automaticBypassToSys"];
    [_dicBoilerChkData setValue:[_segControls11 titleForSegmentAtIndex:_segControls11.selectedSegmentIndex] forKey:@"boilerInterlock"];
    
     [_dicBoilerChkData setValue:[_segAllSystem1 titleForSegmentAtIndex:_segAllSystem1.selectedSegmentIndex] forKey:@"allSystemFlushedAndCleaned"];
    
    [_dicBoilerChkData setValue:_txtAllSystem1.text forKey:@"systemCleaner"];
    [_dicBoilerChkData setValue:_txtAllSystem2.text forKey:@"inhibitor"];
    [_dicBoilerChkData setValue:_txtAllSystem3.text forKey:@"quantityOfInhibitor"];
    
     [_dicBoilerChkData setValue:[_segAllSystem2 titleForSegmentAtIndex:_segAllSystem2.selectedSegmentIndex] forKey:@"hasPrimaryWaterFitted"];
    [_dicBoilerChkData setValue:_txtGasRate.text forKey:@"gasRate"];
    [_dicBoilerChkData setValue:_txtBurnerOperatingPressure.text forKey:@"burnerOperatingPressure"];
    [_dicBoilerChkData setValue:_txtGasIntentPressure.text forKey:@"gasInletPressure"];
    [_dicBoilerChkData setValue:_txtCentralHeatingFlow.text forKey:@"centralHeatFlowTemp"];
    [_dicBoilerChkData setValue:_txtCentralHeatingReturn.text forKey:@"centralHeatReturnTemp"];
    
    [_dicBoilerChkData setValue:[_segCombinationBoiler1 titleForSegmentAtIndex:_segCombinationBoiler1.selectedSegmentIndex]
                         forKey:@"installInHardWater"];
    [_dicBoilerChkData setValue:[_segCombinationBoiler2 titleForSegmentAtIndex:_segCombinationBoiler2.selectedSegmentIndex]
                         forKey:@"waterScaleReducerFit"];

     [_dicBoilerChkData setValue:_txtCombinationBoiler.text forKey:@"scaleReducerType"];
    
     [_dicBoilerChkData setValue:_txtDHWgasrate.text forKey:@"DHgasRate"];
     [_dicBoilerChkData setValue:_txtDHWburneroperatingpressure.text forKey:@"DHburnerOperatingPressure"];
     [_dicBoilerChkData setValue:_txtDHWgasintentpressure.text forKey:@"DHgasInletPressure"];
     [_dicBoilerChkData setValue:_txtDHWcoldwaterintent.text forKey:@"DHcoldWaterInletTemp"];
    
    [_dicBoilerChkData setValue:[_segtxtDHWcheckedHotWater titleForSegmentAtIndex:_segtxtDHWcheckedHotWater.selectedSegmentIndex]
                         forKey:@"DHhotWaterChecked"];
    
    [_dicBoilerChkData setValue:_txtDHWhotwateroutlet.text forKey:@"DHcentralHotWaterOutletTemp"];
    [_dicBoilerChkData setValue:_txtDHWwaterflowrate.text forKey:@"DHWaterFlowRate"];
    
    [_dicBoilerChkData setValue:[_segCondensingBoilersOnly titleForSegmentAtIndex:_segCondensingBoilersOnly.selectedSegmentIndex]
                         forKey:@"condensedDrainInstalled"];
    
    [_dicBoilerChkData setValue:[_segAllInstallation1 titleForSegmentAtIndex:_segAllInstallation1.selectedSegmentIndex]
                         forKey:@"hotwaterSystemComplies"];
    
    [_dicBoilerChkData setValue:[_segAllInstallation2 titleForSegmentAtIndex:_segAllInstallation2.selectedSegmentIndex]
                         forKey:@"boilerAndAssociateProInstalled"];
    
    [_dicBoilerChkData setValue:[_segAllInstallation3 titleForSegmentAtIndex:_segAllInstallation3.selectedSegmentIndex]
                         forKey:@"operatingBoilerDemonstrated"];
    
    [_dicBoilerChkData setValue:[_segAllInstallation4 titleForSegmentAtIndex:_segAllInstallation4.selectedSegmentIndex]
                         forKey:@"literatureExplained"];
    
    
    [_dicBoilerChkData setValue:_txtallInstallationCO1.text forKey:@"maxRateCO"];
    [_dicBoilerChkData setValue:_txtallInstallationCO2.text forKey:@"minRateCO"];
    [_dicBoilerChkData setValue:_txtallInstallationRatio1.text forKey:@"maxRateRatio"];
    [_dicBoilerChkData setValue:_txtallInstallationRatio2.text forKey:@"minRateRatio"];
    
    if([self.delegate respondsToSelector:@selector(BoilerChecksRecordData:)]) {
        [self.delegate BoilerChecksRecordData:_dicBoilerChkData];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UItextField Delegate Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (textField==_txtLocation||textField==_txtapplianceMake)
    {
        Activetxtfld=textField;
       // [self.view endEditing:YES];
       // [self performSelector:@selector(popupList) withObject:nil afterDelay:0.1];
        return YES;
    }else{
        CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y-150);
        [_scrollView setContentOffset:scrollPoint animated:YES];
        return YES;
    }
}


- (IBAction)ClickDropDown:(UIButton *)sender {
    
    if (sender.tag==1) {
        Activetxtfld=_txtLocation;
    }else if (sender.tag==2){
        Activetxtfld=_txtapplianceMake;
    }
    
    [self.view endEditing:YES];
    [self popupList];
    
    
}








#pragma mark - DropDown PopUp List Method
-(void)popupList
{
    if (tblView!=nil)
    {
        [tblView removeFromSuperview];
        tblView=nil;
    }
    else
    {
        arrFeedTblPopup= [self GetDataForPoppup:Activetxtfld];
        tblView=[[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMinX(Activetxtfld.frame),CGRectGetMaxY(Activetxtfld.frame)+2, CGRectGetWidth(Activetxtfld.frame), 0) style:UITableViewStylePlain];
        tblView.delegate=self;
        tblView.dataSource=self;
        [self.scrollView addSubview:tblView];
        [tblView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [tblView.layer setBorderWidth: 2.0];
        [tblView.layer setCornerRadius:3.0f];
        [tblView.layer setMasksToBounds:YES];
        
        [UIView animateWithDuration:0.35
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect frame = tblView.frame;
                             frame.size.height = self.view.frame.size.height/2.0f;
                             tblView.frame = frame;
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                            
                         }];
    }
}

#pragma mark - Get DropDown Value Fetch Method
-(NSArray *)GetDataForPoppup:(UITextField *)fld{
    
    arrFeedTblPopup=nil;
    
    if (fld==_txtLocation) {
        arrFeedTblPopup=@[@"1st Floor office",@"2nd floor office",@"Bathroom",@"Bedroom",@"Boardroom",@"Canteen",@"Cloakroom",@"Compartment",@"Cupboard",@"Dining Room",@"En-Suite",@"Garage",@"Ground Floor Office",@"Kitchen",@"Lounge / Living Room",@"Meeting Room",@"Outside",@"Passage",@"Reception",@"Roof Space",@"Study",@"Toilets",@"Under stairs",@"Utility",@"Warehouse",@"n/a"];
    }
    else if(fld==_txtapplianceMake){
        arrFeedTblPopup=@[@"ACV",@"Albion",@"Alde",@"Alpha",@"Andrews",@"Ariston",@"Atag",@"Barlo",@"Baxi",@"Beeston",@"Benson",@"Biasi",@"British Gas",@"Bunderus",@"Carver",@"Chaffoteaux",@"Combat",@"Eco Hometec",@"Elco",@"Eurocal",@"Evo",@"FER",@"Fagor",@"Ferroli",@"Firebird",@"Firecfly",@"Fontecal",@"Fusion",@"GAH",@"Gem",@"Gemini",@"Geminox",@"Gerkros",@"Gledhill",@"Glowworm",@"Grant",@"HRM",@"Halstead",@"Hamworthy",@"Harcel",@"Heating Services",@"Heatline",@"Hermann",@"Hoval",@"Icon",@"Ideal",@"Ikon",@"Intergas",@"Intesa",@"Italkero",@"Jaguar",@"Johnson & Starley",@"Keston",@"Lamborghini",@"Lennox",@"Lochinvar",@"Main",@"Malvern",@"Maxol",@"Merlin",@"Morco",@"Myson",@"Nu-Way",@"Optia",@"Potterton",@"Premier",@"ProCombi",@"Protherm",@"Quantum",@"Radiant",@"Range",@"Ravenheat",@"Remeha",@"Reznor",@"Riello",@"Rinnal",@"SARIgas",@"Sabre",@"Santon",@"Saunier Duval",@"Savio",@"Servowarm",@"Sime",@"Sirrus",@"Stokvis",@"Strebel",@"Termet",@"Thermaflow",@"Thermsaver",@"Thorn",@"Trianco",@"Trisave",@"Vaillant",@"Viessmann",@"Vokera",@"Warm World",@"wickes",@"Wilson",@"Worcester Bosch"];
    }
    else{
        
    }
    return arrFeedTblPopup;
}

#pragma mark - UITableview Delegate and Datasource Method
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tblView)
    {
        return [arrFeedTblPopup count];
    }
    else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier=@"cellidentifier";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.backgroundColor=[UIColor clearColor];
    
    if (tableView==tblView)
    {
        cell.textLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
        cell.textLabel.text=[arrFeedTblPopup objectAtIndex:indexPath.row];
    }
    else
    {
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblView)
    {
        return 45;
    }
    else
    {
        return 0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (tableView==tblView)
    {
        Activetxtfld.text=[arrFeedTblPopup objectAtIndex:indexPath.row];
        [tblView removeFromSuperview];
        tblView=nil;
    }
}


@end
