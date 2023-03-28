//
//  GBSRappliancedetails.m
//  Partner Maintenance
//


#import "GBSRappliancedetails.h"

@interface GBSRappliancedetails ()

@end

@implementation GBSRappliancedetails

#pragma mark - viewDidLoad Method
- (void)viewDidLoad
{
    [super viewDidLoad];
 
    _dicApplianceData=[[NSMutableDictionary alloc] init];

    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"DONE " style:UIBarButtonItemStyleBordered target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
  
    _txtHeatInput.inputAccessoryView = numberToolbar;
    _txtOperatingPressure.inputAccessoryView = numberToolbar;
    
    _txt1stCO.inputAccessoryView = numberToolbar;
    _txt1stCO2.inputAccessoryView = numberToolbar;
    _txt1stRatio.inputAccessoryView = numberToolbar;
    
    _txt2ndCO.inputAccessoryView = numberToolbar;
    _txt2ndCO2.inputAccessoryView = numberToolbar;
    _txt2ndRatio.inputAccessoryView = numberToolbar;
    
    _txt3rdCO.inputAccessoryView = numberToolbar;
    _txt3rdCO2.inputAccessoryView = numberToolbar;
    _txt3rdRatio.inputAccessoryView = numberToolbar;
   
    
    
    
    
}





-(void)doneWithNumberPad{
    [_scrollView setContentOffset:preScrollPoint animated:YES];
    [self.view endEditing:YES];
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

#pragma mark - UItextField Delegate Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_scrollView setContentOffset:preScrollPoint animated:YES];
    [textField resignFirstResponder];
    return YES;
    
}




- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    preScrollPoint=_scrollView.contentOffset;
    if (textField==_txtLocation||textField==_txtApplianceType||textField==_txtApplianceMake)
    {
        Activetxtfld=textField;
       // [self.view endEditing:YES];
       // [self popupList];
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
      Activetxtfld=_txtApplianceType;
    }else if (sender.tag==3){
        Activetxtfld=_txtApplianceMake;
    }
    
    
    [self.view endEditing:YES];
    [self popupList];
    
    
}







#pragma mark - DropDown PopUp List Method
-(void)popupList
{
    if (tblView!=nil){
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
-(NSArray *)GetDataForPoppup:(UITextField *)fld
{
    arrFeedTblPopup=nil;
    
    if (fld==_txtLocation){
        arrFeedTblPopup=@[@"1st Floor office",@"2nd floor office",@"Bathroom",@"Bedroom",@"Boardroom",@"Canteen",@"Cloakroom",@"Compartment",@"Cupboard",@"Dining Room",@"En-Suite",@"Garage",@"Ground Floor Office",@"Kitchen",@"Lounge / Living Room",@"Meeting Room",@"Outside",@"Passage",@"Reception",@"Roof Space",@"Study",@"Toilets",@"Under stairs",@"Utility",@"Warehouse",@"n/a"];
    }
    else if(fld==_txtApplianceType){
        arrFeedTblPopup=@[@"Back Boiler",@"Back Boiler Fire",@"Combi Boiler",@"Cooker",@"Fire",@"Fridge",@"Hob",@"Oven",@"Space Heater",@"Stove",@"System Boiler",@"WAll Heater",@"Warm Air",@"Water Heater"];
    }
    else if(fld==_txtApplianceMake){
        arrFeedTblPopup=@[@"ACV",@"Albion",@"Alde",@"Alpha",@"Andrews",@"Ariston",@"Atag",@"Barlo",@"Baxi",@"Beeston",@"Benson",@"Biasi",@"British Gas",@"Bunderus",@"Carver",@"Chaffoteaux",@"Combat",@"Eco Hometec",@"Elco",@"Eurocal",@"Evo",@"FER",@"Fagor",@"Ferroli",@"Firebird",@"Firecfly",@"Fontecal",@"Fusion",@"GAH",@"Gem",@"Gemini",@"Geminox",@"Gerkros",@"Gledhill",@"Glowworm",@"Grant",@"HRM",@"Halstead",@"Hamworthy",@"Harcel",@"Heating Services",@"Heatline",@"Hermann",@"Hoval",@"Icon",@"Ideal",@"Ikon",@"Intergas",@"Intesa",@"Italkero",@"Jaguar",@"Johnson & Starley",@"Keston",@"Lamborghini",@"Lennox",@"Lochinvar",@"Main",@"Malvern",@"Maxol",@"Merlin",@"Morco",@"Myson",@"Nu-Way",@"Optia",@"Potterton",@"Premier",@"ProCombi",@"Protherm",@"Quantum",@"Radiant",@"Range",@"Ravenheat",@"Remeha",@"Reznor",@"Riello",@"Rinnal",@"SARIgas",@"Sabre",@"Santon",@"Saunier Duval",@"Savio",@"Servowarm",@"Sime",@"Sirrus",@"Stokvis",@"Strebel",@"Termet",@"Thermaflow",@"Thermsaver",@"Thorn",@"Trianco",@"Trisave",@"Vaillant",@"Viessmann",@"Vokera",@"Warm World",@"wickes",@"Wilson",@"Worcester Bosch"];
    }
    else{
    }
    return arrFeedTblPopup;
}

#pragma mark - UITableview Delegate and datasource Method
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
    if (tableView==tblView)
    {
        Activetxtfld.text=[arrFeedTblPopup objectAtIndex:indexPath.row];
        [tblView removeFromSuperview];
        tblView=nil;
    }
}

#pragma mark - Segment Press Method
- (IBAction)btnGasTightnessTestCarriedouttapped:(id)sender
{
    
}
- (IBAction)btnGasTightnessTestResulttapped:(id)sender
{
    
}

#pragma mark - Submit Press Method
- (IBAction)btnSubmitapped:(id)sender
{
    
    [_dicApplianceData setValue:_txtLocation.text forKey:@"Location"];
    [_dicApplianceData setValue:_txtApplianceType.text forKey:@"ApplianceType"];
    [_dicApplianceData setValue:_txtApplianceMake.text forKey:@"ApplianceMake"];
    [_dicApplianceData setValue:_txtApplianceModel.text forKey:@"ApplianceModel"];
    [_dicApplianceData setValue:_txtApplianceSerialno.text forKey:@"ApplianceSerialno"];
    [_dicApplianceData setValue:_txtBurnerMake.text forKey:@"BurnerMake"];
    [_dicApplianceData setValue:_txtBurnerModel.text forKey:@"BurnerModel"];
    [_dicApplianceData setValue:[_segGasTightnessTestCarriedout titleForSegmentAtIndex:_segGasTightnessTestCarriedout.selectedSegmentIndex] forKey:@"GasTightTestCarriedOut"];
    [_dicApplianceData setValue:[_segGasTightnessTestResult titleForSegmentAtIndex:_segGasTightnessTestResult.selectedSegmentIndex] forKey:@"GasTightTestResult"];
    [_dicApplianceData setValue:_txt1stCO.text forKey:@"FirstCO"];
    [_dicApplianceData setValue:_txt1stCO2.text forKey:@"FirstCOTwo"];
    [_dicApplianceData setValue:_txt1stRatio.text forKey:@"FirstRatio"];
    [_dicApplianceData setValue:_txt2ndCO.text forKey:@"SecondCO"];
    [_dicApplianceData setValue:_txt2ndCO2.text forKey:@"SecondCOTwo"];
    [_dicApplianceData setValue:_txt2ndRatio.text forKey:@"SecondRatio"];
    [_dicApplianceData setValue:_txt3rdCO.text forKey:@"ThirdCO"];
    [_dicApplianceData setValue:_txt3rdCO2.text forKey:@"ThirdCOTwo"];
    [_dicApplianceData setValue:_txt3rdRatio.text forKey:@"ThirdRatio"];
    [_dicApplianceData setValue:_txtOperatingPressure.text forKey:@"OperatingPressure"];
    [_dicApplianceData setValue:_txtHeatInput.text forKey:@"HeatInput"];
    
    if([self.delegate respondsToSelector:@selector(GBSApplianceRecordData:)]) {
        [self.delegate GBSApplianceRecordData:_dicApplianceData];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
