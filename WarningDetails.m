//
//  WarningDetails.m
//  Partner Maintenance
//


#import "WarningDetails.h"

@interface WarningDetails ()

@end

@implementation WarningDetails

#pragma mark - viewDidLoad  Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    _dicWarningDetails=[[NSMutableDictionary alloc]init];
   //_scrollView.contentSize=CGSizeMake(320,CGRectGetMaxY(_btnsubmit.frame)+20);
}

#pragma mark - didReceiveMemoryWarning  Method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Back Press  Method
- (IBAction)btnBackTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Submit Press  Method
- (IBAction)btnSubmitapped:(id)sender
{
    [_dicWarningDetails setValue:[_segGasEscape titleForSegmentAtIndex:_segGasEscape.selectedSegmentIndex] forKey:@"GasEscape"];
    [_dicWarningDetails setValue:_txtLocation.text  forKey:@"Location"];
    [_dicWarningDetails setValue:_txtApplianceType.text  forKey:@"ApplianceType"];
    [_dicWarningDetails setValue:_txtApplianceMake.text  forKey:@"ApplianceMake"];
    [_dicWarningDetails setValue:_txtApplianceModel.text  forKey:@"ApplianceModel"];
    [_dicWarningDetails setValue:_txtApplianceSerialNo.text  forKey:@"ApplianceSerialNo"];
    [_dicWarningDetails setValue:_txtvImmediateDengerousID.text  forKey:@"ImmediateDengerousID"];
    [_dicWarningDetails setValue:[_segImmediateDengerousID titleForSegmentAtIndex:_segImmediateDengerousID.selectedSegmentIndex]  forKey:@"ImmediateDengerousIDVal"];
    [_dicWarningDetails setValue:_txtvAtRiskID.text  forKey:@"AtRiskID"];
    [_dicWarningDetails setValue:[_segAtRiskID titleForSegmentAtIndex:_segAtRiskID.selectedSegmentIndex]  forKey:@"RiskIDVal"];
    [_dicWarningDetails setValue:_txtvNCS.text  forKey:@"NCSText"];
    [_dicWarningDetails setValue:[_segGasUsernotPresent titleForSegmentAtIndex:_segGasUsernotPresent.selectedSegmentIndex]  forKey:@"GasUsernotPresent"];
    
    if([self.delegate respondsToSelector:@selector(warningDetailsRecordData:)])
    {
        [self.delegate warningDetailsRecordData:_dicWarningDetails];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Segment Press  Method
- (IBAction)btnsegGasEscape:(id)sender
{
}
- (IBAction)btnsegImmediateDengerousID:(id)sender
{
}
- (IBAction)btnsegAtRiskID:(id)sender
{
}
- (IBAction)btnsegGasUsernotPresent:(id)sender
{
}

#pragma mark - UItextField Delegate Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_scrollView setContentOffset:PrePoint animated:YES];
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==_txtLocation||textField==_txtApplianceType||textField==_txtApplianceMake)
    {
        Activetxtfld=textField;
       // [self.view endEditing:YES];
       // [self popupList];
    }else{
        PrePoint = _scrollView.contentOffset;
        CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y-150);
        [_scrollView setContentOffset:scrollPoint animated:YES];
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



#pragma mark - DropDown PopUp List method
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
-(NSArray *)GetDataForPoppup:(UITextField *)fld
{
    arrFeedTblPopup=nil;
    
    if (fld==_txtLocation) {
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

#pragma mark - UITableView Delegate and Datasource Method
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tblView){
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




@end
