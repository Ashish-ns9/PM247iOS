//
//  ApplianceInspection.m
//  Partner Maintenance
//


#import "ApplianceInspection.h"

@interface ApplianceInspection ()

@end

@implementation ApplianceInspection
@synthesize arrApplianceData;
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    if (!arrApplianceData) {
        arrApplianceData=[[NSMutableArray alloc]init];
    }
    
   // _scrollForm.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width-10,CGRectGetMaxY(_btnsubmit.frame)+20);
    
    _tblApplianceList.backgroundView=nil;
    _tblApplianceList.backgroundColor=[UIColor clearColor];
    _tblApplianceList.separatorColor=[UIColor clearColor];
    
    //Adding scroll view
    _scrollForm.frame = _tblApplianceList.frame;
    [self.view addSubview:_scrollForm];
    _tblApplianceList.hidden=NO;
    _scrollForm.hidden=YES;
    
    
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"DONE " style:UIBarButtonItemStyleBordered target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    _txtOperatingPress.inputAccessoryView = numberToolbar;
     _txtHeatInput.inputAccessoryView = numberToolbar;
    
     _txt1stCO.inputAccessoryView = numberToolbar;
     _txt1stCO2.inputAccessoryView = numberToolbar;
     _txt1stRatio.inputAccessoryView = numberToolbar;
    
    _txt2ndCO.inputAccessoryView = numberToolbar;
    _txt2ndCO2.inputAccessoryView = numberToolbar;
    _txt2ndRatio.inputAccessoryView = numberToolbar;
    
    _txt3rdCO.inputAccessoryView = numberToolbar;
    _txt3rdCO2.inputAccessoryView = numberToolbar;
    _txt3rdRatio.inputAccessoryView = numberToolbar;
    _txtWarningNoticeNo.inputAccessoryView = numberToolbar;


    
    
}





-(void)doneWithNumberPad{
    [_scrollForm setContentOffset:PreScroll animated:YES];
    [self.view endEditing:YES];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnbacktapped:(id)sender
{
    if([self.delegate respondsToSelector:@selector(ApplianceDidAddedWithData:)]) {
        [self.delegate ApplianceDidAddedWithData:arrApplianceData];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- Submit Press Method
- (IBAction)btnSubmitapped:(id)sender
{
    
    NSLog(@"arrApplianceData :%@",arrApplianceData);
    
    _dataApplianceDetails=[[NSMutableDictionary alloc]init];
    
    [_dataApplianceDetails setValue:_txtLocation.text forKey:@"Location"];
    [_dataApplianceDetails setValue:_txtApplicaceType.text forKey:@"ApplianceType"];
    [_dataApplianceDetails setValue:_txtApplianceMake.text forKey:@"ApplianceMake"];
    [_dataApplianceDetails setValue:_txtAplianceModel.text forKey:@"ApplianceModel"];
    [_dataApplianceDetails setValue:_txtOperatingPress.text forKey:@"OperatingPressure"];
    [_dataApplianceDetails setValue:_txtHeatInput.text forKey:@"HeatInput"];
    
    [_dataApplianceDetails setValue:[_segFuelType titleForSegmentAtIndex:_segFuelType.selectedSegmentIndex] forKey:@"FlueType"];
    [_dataApplianceDetails setValue:[_segLandlordAppliance titleForSegmentAtIndex:_segLandlordAppliance.selectedSegmentIndex] forKey:@"LandLordsAppliances"];
    [_dataApplianceDetails setValue:[_segApplianceInspected titleForSegmentAtIndex:_segApplianceInspected.selectedSegmentIndex] forKey:@"ApplianceInspected"];
    [_dataApplianceDetails setValue:[_segsafetydevice titleForSegmentAtIndex:_segsafetydevice.selectedSegmentIndex] forKey:@"SafetyDeviceCorrect"];
    
    [_dataApplianceDetails setValue:[_segVentilationProvision titleForSegmentAtIndex:_segVentilationProvision.selectedSegmentIndex] forKey:@"VentilationProvision"];
    [_dataApplianceDetails setValue:[_segvisualcondition titleForSegmentAtIndex:_segvisualcondition.selectedSegmentIndex] forKey:@"VisualSatisfatory"];
    [_dataApplianceDetails setValue:[_segFuelperformence titleForSegmentAtIndex:_segFuelperformence.selectedSegmentIndex] forKey:@"FluePerFormanceTest"];
    [_dataApplianceDetails setValue:[_segApplianceserviced titleForSegmentAtIndex:_segApplianceserviced.selectedSegmentIndex] forKey:@"ApplianceServiced"];
    [_dataApplianceDetails setValue:[_segappliancesafetouse titleForSegmentAtIndex:_segappliancesafetouse.selectedSegmentIndex] forKey:@"ApplianceSafeToUse"];
    [_dataApplianceDetails setValue:[_segWarningNotice titleForSegmentAtIndex:_segWarningNotice.selectedSegmentIndex] forKey:@"WarningNoticeIssued"];
    
    
    [_dataApplianceDetails setValue:_txt1stCO.text forKey:@"FirstCO"];
    [_dataApplianceDetails setValue:_txt1stCO2.text forKey:@"FirstCOTwo"];
    [_dataApplianceDetails setValue:_txt1stRatio.text forKey:@"FirstRatio"];
    
    [_dataApplianceDetails setValue:_txt2ndCO.text forKey:@"SecondCO"];
    [_dataApplianceDetails setValue:_txt2ndCO2.text forKey:@"SecondCOTwo"];
    [_dataApplianceDetails setValue:_txt2ndRatio.text forKey:@"SecondRatio"];
    
    [_dataApplianceDetails setValue:_txt3rdCO.text forKey:@"ThirdCO"];
    [_dataApplianceDetails setValue:_txt3rdCO2.text forKey:@"ThirdCOTwo"];
    [_dataApplianceDetails setValue:_txt3rdRatio.text forKey:@"ThirdRatio"];
    
    [_dataApplianceDetails setValue:_txtVwDetailsOfAnyFault.text forKey:@"FaultDetails"];
    [_dataApplianceDetails setValue:_txtVwRemidialWork.text forKey:@"RemedialAction"];
    
    [_dataApplianceDetails setValue:_txtWarningNoticeNo.text forKey:@"WarningNotice"];
    
    [arrApplianceData addObject:_dataApplianceDetails];

    NSLog(@"arrApplianceData :%@",arrApplianceData);
    
    [self btnAddGasForms:_btnAddAppLian];
    
    [_tblApplianceList reloadData];
}



#pragma mark - Textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_scrollForm setContentOffset:PreScroll animated:YES];
    [textField resignFirstResponder];
    return YES;
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    PreScroll = _scrollForm.contentOffset;
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y-150);
    [_scrollForm setContentOffset:scrollPoint animated:YES];
    
}



#pragma mark - TEXTVIEW DELEGATES

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
     PreScroll = _scrollForm.contentOffset;
    CGPoint scrollPoint = CGPointMake(0, textView.frame.origin.y-150);
    [_scrollForm setContentOffset:scrollPoint animated:YES];
    
    return YES;
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if([text isEqualToString:@"\n"])
    {
         [_scrollForm setContentOffset:PreScroll animated:YES];
        [textView resignFirstResponder];
    }
    
    return textView.text.length + (text.length - range.length) <= 200;
    
}





#pragma mark - Location / Appliance Type / Appliance Make Press DropDown Method
- (IBAction)btnLocationtapped:(id)sender
{
    Activetxtfld=_txtLocation;
    [self popupList];
}
- (IBAction)btnApplianceTypetapped:(id)sender
{
    Activetxtfld=_txtApplicaceType;
    [self popupList];
}
- (IBAction)btnApplianceMaketapped:(id)sender
{
    Activetxtfld=_txtApplianceMake;
    [self popupList];
}







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
        [self.scrollForm addSubview:tblView];
        
        tblView.backgroundView=nil;
        tblView.backgroundColor=[UIColor clearColor];
        tblView.separatorColor=[UIColor clearColor];
        
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
    
    if (fld==_txtLocation)
    {
        arrFeedTblPopup=@[@"1st Floor office",@"2nd floor office",@"Bathroom",@"Bedroom",@"Boardroom",@"Canteen",@"Cloakroom",@"Compartment",@"Cupboard",@"Dining Room",@"En-Suite",@"Garage",@"Ground Floor Office",@"Kitchen",@"Lounge / Living Room",@"Meeting Room",@"Outside",@"Passage",@"Reception",@"Roof Space",@"Study",@"Toilets",@"Under stairs",@"Utility",@"Warehouse",@"n/a"];
    }
    else if(fld==_txtApplicaceType)
    {
        arrFeedTblPopup=@[@"Back Boiler",@"Back Boiler Fire",@"Combi Boiler",@"Cooker",@"Fire",@"Fridge",@"Hob",@"Oven",@"Space Heater",@"Stove",@"System Boiler",@"WAll Heater",@"Warm Air",@"Water Heater"];
    }
    else if(fld==_txtApplianceMake)
    {
        arrFeedTblPopup=@[@"ACV",@"Albion",@"Alde",@"Alpha",@"Andrews",@"Ariston",@"Atag",@"Barlo",@"Baxi",@"Beeston",@"Benson",@"Biasi",@"British Gas",@"Bunderus",@"Carver",@"Chaffoteaux",@"Combat",@"Eco Hometec",@"Elco",@"Eurocal",@"Evo",@"FER",@"Fagor",@"Ferroli",@"Firebird",@"Firecfly",@"Fontecal",@"Fusion",@"GAH",@"Gem",@"Gemini",@"Geminox",@"Gerkros",@"Gledhill",@"Glowworm",@"Grant",@"HRM",@"Halstead",@"Hamworthy",@"Harcel",@"Heating Services",@"Heatline",@"Hermann",@"Hoval",@"Icon",@"Ideal",@"Ikon",@"Intergas",@"Intesa",@"Italkero",@"Jaguar",@"Johnson & Starley",@"Keston",@"Lamborghini",@"Lennox",@"Lochinvar",@"Main",@"Malvern",@"Maxol",@"Merlin",@"Morco",@"Myson",@"Nu-Way",@"Optia",@"Potterton",@"Premier",@"ProCombi",@"Protherm",@"Quantum",@"Radiant",@"Range",@"Ravenheat",@"Remeha",@"Reznor",@"Riello",@"Rinnal",@"SARIgas",@"Sabre",@"Santon",@"Saunier Duval",@"Savio",@"Servowarm",@"Sime",@"Sirrus",@"Stokvis",@"Strebel",@"Termet",@"Thermaflow",@"Thermsaver",@"Thorn",@"Trianco",@"Trisave",@"Vaillant",@"Viessmann",@"Vokera",@"Warm World",@"wickes",@"Wilson",@"Worcester Bosch"];
    }
    else{
        
    }
    return arrFeedTblPopup;
    
}


#pragma mark TableView delegate datasource
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tblView)
    {
        return [arrFeedTblPopup count];
    }
    if (tableView == _tblApplianceList) {
        
        return [arrApplianceData count];
        
    }
    else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier=@"cellidentifier";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellidentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    
    if (tableView==tblView)
    {
        cell.backgroundColor=[UIColor whiteColor];
        cell.textLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
        cell.textLabel.text=[arrFeedTblPopup objectAtIndex:indexPath.row];
        
        UILabel *lblSeparator;
        lblSeparator=[[UILabel alloc] initWithFrame:CGRectMake(0,44.6,tableView.frame.size.width,0.4)];
        lblSeparator.backgroundColor=[UIColor lightGrayColor];
        [cell.contentView addSubview:lblSeparator];
    }
    
    else if (tableView ==_tblApplianceList)
    {
        
        cell.backgroundColor=[UIColor colorWithRed:249/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
        NSDictionary *dic=[arrApplianceData objectAtIndex:indexPath.row];
        
        UILabel *lbl111;
        lbl111=[[UILabel alloc] initWithFrame:CGRectMake(15,10,100,30)];
        lbl111.textAlignment=NSTextAlignmentLeft;
        lbl111.textColor=[UIColor darkGrayColor];
        lbl111.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
        lbl111.backgroundColor=[UIColor clearColor];
        lbl111.text=@"Appliance Type :";
        [cell.contentView addSubview:lbl111];
        
        UILabel *ApplianceType;
        ApplianceType=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbl111.frame)+5,10,240,30)];
        ApplianceType.textAlignment=NSTextAlignmentLeft;
        ApplianceType.textColor=[UIColor blueColor];
        ApplianceType.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
        ApplianceType.backgroundColor=[UIColor clearColor];
        ApplianceType.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"ApplianceType"]];
        [cell.contentView addSubview:ApplianceType];
        
        
        
        UILabel *lbl222;
        lbl222=[[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(lbl111.frame)+2,100,30)];
        lbl222.textAlignment=NSTextAlignmentLeft;
        lbl222.textColor=[UIColor darkGrayColor];
        lbl222.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
        lbl222.backgroundColor=[UIColor clearColor];
        lbl222.text=@"Appliance Model :";
        [cell.contentView addSubview:lbl222];
        
        UILabel *ApplianceModel;
        ApplianceModel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbl222.frame)+5,CGRectGetMinY(lbl222.frame),240,30)];
        ApplianceModel.textAlignment=NSTextAlignmentLeft;
        ApplianceModel.textColor=[UIColor blueColor];
        ApplianceModel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
        ApplianceModel.backgroundColor=[UIColor clearColor];
        ApplianceModel.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"ApplianceModel"]];
        [cell.contentView addSubview:ApplianceModel];
        
        UILabel *lblSeparator;
        lblSeparator=[[UILabel alloc] initWithFrame:CGRectMake(0,89.6,tableView.frame.size.width,0.4)];
        lblSeparator.backgroundColor=[UIColor lightGrayColor];
        [cell.contentView addSubview:lblSeparator];
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
    else if (tableView ==_tblApplianceList)
    {
        return 90;
        
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


- (IBAction)btnsegWarningNotice:(UISegmentedControl *)sender
{
}


- (IBAction)btnAddGasForms:(UIButton *)sender
{
    if (sender.selected==YES)
    {
        sender.selected=NO;
        _scrollForm.alpha=1.0f;
        [UIView animateWithDuration:0.2 animations:^{
            _scrollForm.alpha=0.0f;
            
            _scrollForm.hidden=YES;
            _tblApplianceList.hidden=NO;
            
            [sender setTransform:CGAffineTransformRotate(sender.transform, M_PI_2/2)];
            
        }];
    }
    else
    {
        sender.selected=YES;
        _scrollForm.hidden=NO;
        _tblApplianceList.hidden=YES;
        _scrollForm.alpha=0.0f;
        [UIView animateWithDuration:0.2 animations:^{
            [sender setTransform:CGAffineTransformRotate(sender.transform, -M_PI_2/2)];
            _scrollForm.alpha=1.0f;
        }];
        
        [_scrollForm setContentOffset:CGPointZero];
        
        for (UIView *fld in _scrollForm.subviews) {
            if ([fld isKindOfClass:[UITextField class]]) {
                UITextField *txtfld=(UITextField *)fld;
                txtfld.text=@"";
                
            }
            else if ([fld isKindOfClass:[UITextView class]])
            {
                UITextView *txtVw = (UITextView *)fld;
                txtVw.text=@"";
                
            }
            else if ([fld isKindOfClass:[UISegmentedControl class]])
            {
                UISegmentedControl *seg=(UISegmentedControl *)fld;
                seg.selectedSegmentIndex=0;
                
            }
        }
    }
}

@end
