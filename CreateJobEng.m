//
//  CreateJobEng.m
//  Partner Maintenance
//


#import "CreateJobEng.h"
@class AddSelPopupController;
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface CreateJobEng ()
{
    GlobalDirector *globe;
    
}

@end

@implementation CreateJobEng
@synthesize btnSlideMenu;



#pragma mark - ViewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
   // [self registerForKeyboardNotifications];
    globe = [GlobalDirector SharedDirector];
    //add tool bar to completed process note
    searchText = @"";
    UIToolbar* numberTool = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberTool.barStyle = UIBarStyleBlackTranslucent;
    numberTool.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(Cancel:)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(Complete:)],
                           nil];
    [numberTool sizeToFit];
    _txtNoteDesComplete.inputAccessoryView = numberTool;
    
    
    
    [_scrollVw setAutoresizesSubviews:YES];
    [self initializeTextFieldInputView];

    self.navigationController.navigationBar.hidden = YES;
    activityOnTextFields=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [btnSlideMenu addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:revealController action:@selector(rightRevealToggle:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    UISwipeGestureRecognizer *recognizer1;
    recognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:revealController action:@selector(revealToggle:)];
    [recognizer1 setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [[self view] addGestureRecognizer:recognizer1];
    [[self view] addGestureRecognizer:recognizer];

    [_txtSelectCustomer setBorderStyle:UITextBorderStyleNone];
    _txtSelectCustomer.layer.borderWidth=0.5f;
    _txtSelectCustomer.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtSelectCustomer.layer.cornerRadius=0.0f;
    _txtSelectCustomer.backgroundColor=[UIColor whiteColor];
    
    _txtSelectCustomer.textColor=[UIColor darkGrayColor];
    _btnJobMat.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    _btnJobCost.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    _btnJobNote.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    
    [_txtRemarks.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_txtRemarks.layer setBorderWidth: 0.5];
    [_txtRemarks.layer setCornerRadius:0.0f];
    [_txtRemarks.layer setMasksToBounds:YES];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [_scrollVw addGestureRecognizer:singleTap];
    singleTap.delegate=self;
    
    [_lblFinanceJobdescription.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_lblFinanceJobdescription.layer setBorderWidth: 1.0];
    [_lblFinanceJobdescription.layer setCornerRadius:0.0f];
    [_lblFinanceJobdescription.layer setMasksToBounds:YES];
    
  
    [_lblFinanceJobdescription setFont:[UIFont fontWithName:@"TheSansArabic-Bold" size:14.0]];
  
    
    
    for (UITextField *txtfield in [_scrollVw subviews])
    {
        if ([txtfield isKindOfClass:[UITextField class]])
        {
            UITextField *txtfld=(UITextField *)txtfield;
            [txtfld setBorderStyle:UITextBorderStyleNone];
            txtfld.layer.borderWidth=0.5f;
            txtfld.layer.borderColor=[[UIColor lightGrayColor]CGColor];
            txtfld.layer.cornerRadius=0.0f;
            txtfld.backgroundColor=[UIColor whiteColor];
            txtfld.textColor=[UIColor darkGrayColor];
            
            UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(10,0,10,26)];
            leftView.backgroundColor = [UIColor clearColor];
            txtfld.leftView = leftView;
            txtfld.leftViewMode = UITextFieldViewModeAlways;
            txtfld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [txtfld addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
            
            
        }
    }
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        _vwMatCostNoteBottomBar.hidden=YES;
        [_btnsubmit setFrame:CGRectMake(CGRectGetMinX(_btnsubmit.frame), CGRectGetMinY(_btnsubmit.frame)-CGRectGetHeight(_vwMatCostNoteBottomBar.frame), CGRectGetWidth(_btnsubmit.frame), CGRectGetHeight(_btnsubmit.frame))];
           [_btnCancel setFrame:CGRectMake(CGRectGetMinX(_btnCancel.frame), CGRectGetMinY(_btnCancel.frame)-CGRectGetHeight(_vwMatCostNoteBottomBar.frame), CGRectGetWidth(_btnCancel.frame), CGRectGetHeight(_btnCancel.frame))];
        
        
    }

    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.barTintColor=[UIColor whiteColor];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(Next)],
                           nil];
    [numberToolbar sizeToFit];
    
    _txtstartdate.inputAccessoryView = numberToolbar;
    _txtStartTime.inputAccessoryView=numberToolbar;
    _txtEndTime.inputAccessoryView=numberToolbar;

    _txtMainConNumber.inputAccessoryView=numberToolbar;
    _txtContactNumber.inputAccessoryView=numberToolbar;
    
    _txtTelephoneNo.inputAccessoryView=numberToolbar;
    
    arrMSavedContactNumber=[[NSMutableArray alloc] init];
    
    dicOwnerDetails=[[NSMutableDictionary alloc]init];
    dicTenantDetails=[[NSMutableDictionary alloc]init];
    dicLandLordDetails=[[NSMutableDictionary alloc]init];
    dicBillingAddress=[[NSMutableDictionary alloc]init];
    dicJobAddress=[[NSMutableDictionary alloc]init];
    dicLandLordAdress=[[NSMutableDictionary alloc]init];
    
    
    
    [dicJobAddress setValue:@"3" forKey:@"TypeofOrganisation"];
    [dicJobAddress setValue:@"Residential" forKey:@"TypeofOrganisationText"];
    
    [dicBillingAddress setValue:@"3" forKey:@"TypeofOrganisation"];
    [dicBillingAddress setValue:@"Residential" forKey:@"TypeofOrganisationText"];

    [dicLandLordAdress setValue:@"3" forKey:@"TypeofOrganisation"];
    [dicLandLordAdress setValue:@"Residential" forKey:@"TypeofOrganisationText"];

    
   
    addMat=[[AddMaterials alloc]initWithNibName:@"AddMaterials" bundle:nil];
    addMat.delegate=self;
    
    
    addcost=[[AddCostViewController alloc]initWithNibName:@"AddcostViewController" bundle:nil];
    addcost.delegate=self;

   
     addNote=[[AddNotes alloc]initWithNibName:@"AddNotes" bundle:nil];
     addNote.delegate=self;
            
    
    
    
    if (_isJobEdited==YES) {
        [self EditJobDic:_jobDic];
        
    }
    else
    {
        [self btnOwnerTapped:_btnOwner];
        
        [self btnBillingAdressTapped:_btnBillingAdress];
        
    }
 
    
}



-(void)PopulateUserDetailsDic:(NSDictionary *)Dic{
    
    NSMutableDictionary *userdetails=[Dic mutableCopy];
    
    
    if ([[userdetails valueForKey:@"TypeofCustomer"]integerValue]==1) {
        [dicOwnerDetails setValue:[userdetails valueForKey:@"FirstName"] forKey:@"FirstName"];
        [dicOwnerDetails setValue:[userdetails valueForKey:@"LastName"] forKey:@"LastName"];
       
        
       // if (_isJobEdited) {
           // [SelectedUserDic setValue:[NSString stringWithFormat:@"%ld",(long)Activetxtfld.tag] forKey:@"TitleID"];
          //  [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",Activetxtfld.text] forKey:@"Title"];
            
           // [dicOwnerDetails setValue:[NSString stringWithFormat:@"%ld",(long)Activetxtfld.tag] forKey:@"TitleID"];
          //  [dicOwnerDetails setValue:[NSString stringWithFormat:@"%@",Activetxtfld.text] forKey:@"Title"];
            
       // }
       // else
       // {
            [dicOwnerDetails setValue:[userdetails valueForKey:@"Title"] forKey:@"Title"];
            [dicOwnerDetails setValue:[userdetails valueForKey:@"TitleID"] forKey:@"TitleID"];
            
       // }
        
        [dicOwnerDetails setValue:[userdetails valueForKey:@"TypeofCustomer"] forKey:@"TypeofCustomer"];
        [dicOwnerDetails setValue:[userdetails valueForKey:@"EmailAddress"] forKey:@"EmailAddress"];
       
      
        
        if ([userdetails valueForKey:@"Mobile"]) {
            [dicOwnerDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"ContactNumber"];
            [dicOwnerDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"Mobile"];
        }else if ([userdetails valueForKey:@"ContactNumber"]){
            [dicOwnerDetails setValue:[userdetails valueForKey:@"ContactNumber"] forKey:@"ContactNumber"];
            [dicOwnerDetails setValue:[userdetails valueForKey:@"ContactNumber"] forKey:@"Mobile"];
        }
        
        
        if([userdetails valueForKey:@"CustID"]) {
           [dicOwnerDetails setValue:[userdetails valueForKey:@"CustID"] forKey:@"CustID"];
        }else{
            [dicOwnerDetails setValue:@"0" forKey:@"CustID"];
        }
        
        
        
        
        
        
        
        [dicOwnerDetails setValue:[userdetails valueForKey:@"Notes"] forKey:@"Notes"];
        
        
    }
    else if ([[userdetails valueForKey:@"TypeofCustomer"]integerValue]==2){
        [dicTenantDetails setValue:[userdetails valueForKey:@"FirstName"] forKey:@"FirstName"];
        [dicTenantDetails setValue:[userdetails valueForKey:@"LastName"] forKey:@"LastName"];
        
        
        if (_isJobEdited) {
            [SelectedUserDic setValue:[NSString stringWithFormat:@"%ld",(long)Activetxtfld.tag] forKey:@"TitleID"];
            [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",Activetxtfld.text] forKey:@"Title"];
            
        }
        else
        {
            [dicTenantDetails setValue:[userdetails valueForKey:@"TitleID"] forKey:@"TitleID"];
            [dicTenantDetails setValue:[userdetails valueForKey:@"Title"] forKey:@"Title"];
            
        }
        
        [dicTenantDetails setValue:[userdetails valueForKey:@"TypeofCustomer"] forKey:@"TypeofCustomer"];
        [dicTenantDetails setValue:[userdetails valueForKey:@"EmailAddress"] forKey:@"EmailAddress"];
       
        if ([userdetails valueForKey:@"Mobile"]) {
            [dicOwnerDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"ContactNumber"];
            [dicOwnerDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"Mobile"];
        }else if ([userdetails valueForKey:@"ContactNumber"]){
            [dicOwnerDetails setValue:[userdetails valueForKey:@"ContactNumber"] forKey:@"ContactNumber"];
            [dicOwnerDetails setValue:[userdetails valueForKey:@"ContactNumber"] forKey:@"Mobile"];
        }
        
        [dicTenantDetails setValue:[userdetails valueForKey:@"Notes"] forKey:@"Notes"];
        
        
        if([userdetails valueForKey:@"CustID"]) {
            [dicTenantDetails setValue:[userdetails valueForKey:@"CustID"] forKey:@"CustID"];
        }else{
            [dicTenantDetails setValue:@"0" forKey:@"CustID"];
        }
        
        
        
    }
    else if ([[userdetails valueForKey:@"TypeofCustomer"]integerValue]==3 || [[userdetails valueForKey:@"TypeofCustomer"]integerValue]==4){
        [dicLandLordDetails setValue:[userdetails valueForKey:@"FirstName"] forKey:@"FirstName"];
        [dicLandLordDetails setValue:[userdetails valueForKey:@"LastName"] forKey:@"LastName"];
        
        
        //if (_isJobEdited) {
           // [SelectedUserDic setValue:[NSString stringWithFormat:@"%ld",(long)Activetxtfld.tag] forKey:@"TitleID"];
         //   [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",Activetxtfld.text] forKey:@"Title"];
            
       // }
       // else
       // {
            [dicLandLordDetails setValue:[userdetails valueForKey:@"TitleID"] forKey:@"TitleID"];
            [dicLandLordDetails setValue:[userdetails valueForKey:@"Title"] forKey:@"Title"];
            
       // }
        
        if([userdetails valueForKey:@"CustID"]) {
            [dicLandLordDetails setValue:[userdetails valueForKey:@"CustID"] forKey:@"CustID"];
        }else{
            [dicLandLordDetails setValue:@"0" forKey:@"CustID"];
        }
        
        
        
        [dicLandLordDetails setValue:[userdetails valueForKey:@"TypeofCustomer"] forKey:@"TypeofCustomer"];
        [dicLandLordDetails setValue:[userdetails valueForKey:@"EmailAddress"] forKey:@"EmailAddress"];
        
        if ([userdetails valueForKey:@"Mobile"]) {
            [dicOwnerDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"ContactNumber"];
            [dicOwnerDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"Mobile"];
        }else if ([userdetails valueForKey:@"ContactNumber"]){
            [dicOwnerDetails setValue:[userdetails valueForKey:@"ContactNumber"] forKey:@"ContactNumber"];
            [dicOwnerDetails setValue:[userdetails valueForKey:@"ContactNumber"] forKey:@"Mobile"];
        }
       
        [dicLandLordDetails setValue:[userdetails valueForKey:@"Notes"] forKey:@"Notes"];
        
        
    }
}


-(void)prePopulateUserDetailsDic:(NSDictionary *)Dic{
    
    NSMutableDictionary *userdetails=[Dic mutableCopy];
    
    
    
    
    
    if ([[userdetails valueForKey:@"TypeofCustomer"]integerValue]==1) {
        [dicOwnerDetails setValue:[userdetails valueForKey:@"FirstName"] forKey:@"FirstName"];
        [dicOwnerDetails setValue:[userdetails valueForKey:@"LastName"] forKey:@"LastName"];
        
        
        
        [dicOwnerDetails setValue:[userdetails valueForKey:@"TypeofCustomer"] forKey:@"TypeofCustomer"];
       
        [dicOwnerDetails setValue:[userdetails valueForKey:@"EmailAddress"] forKey:@"EmailAddress"];
        [dicOwnerDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"ContactNumber"];
        [dicOwnerDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"Mobile"];
        
        [dicOwnerDetails setValue:[userdetails valueForKey:@"Notes"] forKey:@"Notes"];
        
       
        
        [dicOwnerDetails setValue:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"CustID"]] forKey:@"CustID"];
        

    }
    else if ([[userdetails valueForKey:@"TypeofCustomer"]integerValue]==2){
        [dicTenantDetails setValue:[userdetails valueForKey:@"FirstName"] forKey:@"FirstName"];
        [dicTenantDetails setValue:[userdetails valueForKey:@"LastName"] forKey:@"LastName"];
        
        
        [dicTenantDetails setValue:[userdetails valueForKey:@"Title"] forKey:@"Title"];
        [dicTenantDetails setValue:[userdetails valueForKey:@"TitleID"] forKey:@"TitleID"];
        
        [dicTenantDetails setValue:[userdetails valueForKey:@"TypeofCustomer"] forKey:@"TypeofCustomer"];
        [dicTenantDetails setValue:[userdetails valueForKey:@"EmailAddress"] forKey:@"EmailAddress"];
        [dicTenantDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"ContactNumber"];
         [dicTenantDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"Mobile"];
        
        [dicTenantDetails setValue:[userdetails valueForKey:@"Notes"] forKey:@"Notes"];
        
         [dicTenantDetails setValue:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"CustID"]] forKey:@"CustID"];
        
       
        

    }
    else if ([[userdetails valueForKey:@"TypeofCustomer"]integerValue]==3 || [[userdetails valueForKey:@"TypeofCustomer"]integerValue]==4){
        [dicLandLordDetails setValue:[userdetails valueForKey:@"FirstName"] forKey:@"FirstName"];
        [dicLandLordDetails setValue:[userdetails valueForKey:@"LastName"] forKey:@"LastName"];
        
        
      
        
        [dicLandLordDetails setValue:[userdetails valueForKey:@"Title"] forKey:@"Title"];
        [dicLandLordDetails setValue:[userdetails valueForKey:@"TitleID"] forKey:@"TitleID"];
        
        [dicLandLordDetails setValue:[userdetails valueForKey:@"TypeofCustomer"] forKey:@"TypeofCustomer"];
        [dicLandLordDetails setValue:[userdetails valueForKey:@"EmailAddress"] forKey:@"EmailAddress"];
        [dicLandLordDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"ContactNumber"];
         [dicLandLordDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"Mobile"];
        [dicLandLordDetails setValue:[userdetails valueForKey:@"Notes"] forKey:@"Notes"];
         [dicLandLordDetails setValue:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"CustID"]] forKey:@"CustID"];

    }
    
    
    //  1 Owner
    //  2 Tenant
    //  3 Landlord
    //  4 Managing Agent
    
    NSString *add = [GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"AddressLine1"]];
    NSString *add1 = [GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"AddressLine2"]];
    NSString *add2 = [GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"AddressLine3"]];
    
    
    
   
    NSMutableArray *arrAdd = [[NSMutableArray alloc] init];
    
    if (add.length>0) {
       // address= [address stringByAppendingFormat:@"%@",add];
        [arrAdd addObject:add];
    }
    
    if (add1.length>0) {
        [arrAdd addObject:add1];
    }
    
    if (add2.length>0) {
         [arrAdd addObject:add2];
    }
    
    [dicBillingAddress setValue:[GlobalDirector ReplaceStringNull:[arrAdd componentsJoinedByString:@","]] forKey:@"Address"];
    
    [dicBillingAddress setValue:[userdetails valueForKey:@"County"] forKey:@"County"];
    [dicBillingAddress setValue:[userdetails valueForKey:@"Town"] forKey:@"City"];
    [dicBillingAddress setValue:[userdetails valueForKey:@"Postcode"] forKey:@"PostCode"];
    [dicBillingAddress setValue:[userdetails valueForKey:@"PhoneNumber"] forKey:@"ContactNo"];
    [dicBillingAddress setValue:[userdetails valueForKey:@"Notes"] forKey:@"Remarks"];
    [dicBillingAddress setValue:@"2" forKey:@"TypeOfAddress"];
   
    
    int type = [[userdetails valueForKey:@"TypeofOrganisation"]intValue];
    NSString *typeOfOrganisation = @"";
     NSString *value = @"";
    
    if (type == 2)
    {
        typeOfOrganisation=@"Large Organisation";
        value= @"2";
    }
    
    else if (type == 3)
    {
        typeOfOrganisation=@"Residential";
         value= @"3";
        
    }
    
    else if (type == 1)
    {
        typeOfOrganisation=@"Small Organisation";
        value= @"1";
        
    }
    
    else
    {
        typeOfOrganisation=@"";
        value=@"";
    }
    
    if (typeOfOrganisation.length>0) {
        
        _txtOrganizationName.text = [GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"NameofOrganisation"]];
        _txtOrganizationType.text= typeOfOrganisation;
        
        
        [dicBillingAddress setValue:typeOfOrganisation forKey:@"TypeofOrganisationText"];
        [dicBillingAddress setValue:value forKey:@"TypeofOrganisation"];
        [dicBillingAddress setValue:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"NameofOrganisation"]] forKey:@"NameofOrganisation"];

    }
    
    selectedAddressDic = [dicBillingAddress mutableCopy];

}





-(void)EditJobDic:(NSDictionary *)dicJobDetails
{
    
    
    if ([[dicJobDetails valueForKey:@"JobStartDate"]length]>9)
    {
        NSString *strStartDate =[NSString stringWithFormat:@"%@",[dicJobDetails valueForKey:@"JobStartDate"]];
        NSArray* foo = [strStartDate componentsSeparatedByString: @" "];
        strStartDate=[foo objectAtIndex:0];
        // strStartDate = [strStartDate substringToIndex:10];
         _txtstartdate.text=strStartDate;
    }
   
     _txtPurchOrder.text=[GlobalDirector ReplaceStringNull:[dicJobDetails valueForKey:@"PurchaseOrder"]];
    _txtStartTime.text=[dicJobDetails valueForKey:@"JobStartTime"];
    _txtEndTime.text=[dicJobDetails valueForKey:@"JobEndTime"];
    _txtTimeAllowance.text=[dicJobDetails valueForKey:@"BookingAgentName"];
    _txtTimeAllowance.tag=[[dicJobDetails valueForKey:@"BookingAgentId"]integerValue];
    
    _txtMainConNumber.text=[dicJobDetails valueForKey:@"MainContactNumber"];
    
    if (_txtMainConNumber.text.length>0) {
        [arrMSavedContactNumber addObject:[NSString stringWithFormat:@"%@",_txtMainConNumber.text]];
    }
    
    
    _txtJobPrice.text=[dicJobDetails valueForKey:@"JobPrice"];
    _txtJobPrice.tag=[[dicJobDetails valueForKey:@"JobPriceID"]integerValue];
    
    _txtJobType.text=[dicJobDetails valueForKey:@"NatureofJob"];
     _txtJobType.tag=[[dicJobDetails valueForKey:@"JobTypeID"]integerValue];
    
    _txtAdvertiseChannel.text=[dicJobDetails valueForKey:@"AdvertisingChannel"];
    _txtAdvertiseChannel.tag=[[dicJobDetails valueForKey:@"AdvertisingChannelID"]integerValue];
    
     _txtJobStatus.userInteractionEnabled=YES;
    
    NSString *jobstatusShown=[NSString stringWithFormat:@"%@",([[dicJobDetails valueForKey:@"JobStatus"]integerValue]>2&&[[dicJobDetails valueForKey:@"JobStatus"]integerValue]!=12)?@"3":[dicJobDetails valueForKey:@"JobStatus"]];
    
    
    if ([jobstatusShown isEqualToString:@"1"])
    {
        _txtJobStatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobStatus.placeholder,@"Booked"];
        
    }
    else if ([jobstatusShown isEqualToString:@"2"])
    {
        _txtJobStatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobStatus.placeholder,@"Active"];
    }
    else if ([jobstatusShown isEqualToString:@"3"])
    {
       // _txtJobStatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobStatus.placeholder,@"Completed"];
        NSString *strComp = [GlobalDirector ReplaceStringNull:[dicJobDetails valueForKey:@"SubStatusText"]];
        
        if (strComp.length>0) {
            strComp = [NSString stringWithFormat:@"Completed-%@",strComp];
            _txtJobStatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobStatus.placeholder,strComp];
        }else{
           _txtJobStatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobStatus.placeholder,@"Completed"];
        }
        
       
       _txtJobStatus.userInteractionEnabled=YES;
    }
    else if([jobstatusShown isEqualToString:@"12"])
    {
        _txtJobStatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobStatus.placeholder,@"Cancelled"];
      _txtJobStatus.userInteractionEnabled=YES;
        
    }
    
    _txtJobStatus.tag=[jobstatusShown integerValue];
    
    
    
    _txtVwJobDesc.text=[dicJobDetails valueForKey:@"JobDescription"];
    
    NSArray *array=[dicJobDetails objectForKey:@"JobPeopleListResponse"];
    
    int mainCustomer = 0;
    
    for (NSMutableDictionary *dic in array) {
        DLog(@"%@",[dic valueForKey:@"TypeofCustomer"]);
        
        if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==1) {
            
            NSInteger cust = [[GlobalDirector ReplaceStringNull:[dic valueForKey:@"CustID"] ]integerValue];
            
            if (cust>0) {
                customerID=cust;
                _txtSelectCustomer.text=[NSString stringWithFormat:@"%@(%@)",[dic valueForKey:@"FullName"],[dic valueForKey:@"EmailAddress"]];
                mainCustomer=1;
            }
            
            dicOwnerDetails=[dic mutableCopy];
            SelectedUserDic = [dic mutableCopy];
            
            
             [self btnOwnerTapped:_btnOwner];
        }
        else if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==2)
        {
            
             dicTenantDetails=[dic mutableCopy];
             SelectedUserDic = [dic mutableCopy];
            
            NSInteger cust = [[GlobalDirector ReplaceStringNull:[dic valueForKey:@"CustID"] ]integerValue];
            
            if (cust>0) {
                customerID=cust;
                _txtSelectCustomer.text=[NSString stringWithFormat:@"%@(%@)",[dic valueForKey:@"FullName"],[dic valueForKey:@"EmailAddress"]];
                 mainCustomer=2;
            }
            
           
            
        }
        else if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==3 || [[dic valueForKey:@"TypeofCustomer"]integerValue]==4)
        {
            NSInteger cust = [[GlobalDirector ReplaceStringNull:[dic valueForKey:@"CustID"] ]integerValue];
            
            if (cust>0) {
                customerID=cust;
                 _txtSelectCustomer.text=[NSString stringWithFormat:@"%@(%@)",[dic valueForKey:@"FullName"],[dic valueForKey:@"EmailAddress"]];
                 mainCustomer=3;
            }

           
            dicLandLordDetails=[dic mutableCopy];
             SelectedUserDic = [dic mutableCopy];
           
             [self btnLandlordTapped:_btnLandlord];
            
        }
        
        
    }
    
    if (mainCustomer==1) {
       
        [self performSelector:@selector( btnOwnerTapped:) withObject:_btnOwner afterDelay:0.1];
        
    }else if (mainCustomer==2){
        [self performSelector:@selector( btnTenantTapped:) withObject:_btnTenant afterDelay:0.1];
        
       
    }else if (mainCustomer==3){
        [self performSelector:@selector( btnLandlordTapped:) withObject:_btnLandlord afterDelay:0.1];
        
     
    }
    
    
    NSArray *arrAddr=[dicJobDetails objectForKey:@"JobAddrListResponse"];
    for (NSMutableDictionary *dic in arrAddr) {
       
        
        if ([[dic valueForKey:@"TypeOfAddress"]integerValue]==1) {
            
            dicJobAddress=[dic mutableCopy];
            
        }
        else if ([[dic valueForKey:@"TypeOfAddress"]integerValue]==2)
        {
            dicBillingAddress=[dic mutableCopy];
            
        }
        else if ([[dic valueForKey:@"TypeOfAddress"]integerValue]==3)
        {
            dicLandLordAdress=[dic mutableCopy];
            
        }
        
       
        
    }
    
    
    
   
    arradditionalNotes = [[NSMutableArray alloc] init];
    
    arradditionalMaterials = [[NSMutableArray alloc] init];
    arradditionalCost = [[NSMutableArray alloc] init];
    
   
    [self btnBillingAdressTapped:_btnBillingAdress];
  
}




-(void)cancel
{
    isContactsave=NO;
    UITextField *txtfld=(UITextField *)actvtextbox;
    [txtfld resignFirstResponder];
    
}

-(void)Next
{
     UITextField *txtfld=(UITextField *)actvtextbox;
    if (txtfld==_txtstartdate) {
        txtfld=_txtStartTime;
        
    }
    else if (txtfld==_txtStartTime){
        txtfld=_txtEndTime;
        
    }
    else if (txtfld==_txtEndTime){
        txtfld=_txtTimeAllowance;
        
    }
    else if (txtfld==_txtMainConNumber){
        txtfld=_txtJobPrice;
        
    }
    else if (txtfld==_txtContactNumber){
        txtfld=_txtEmailAddress;
        
    }
    else if (txtfld==_txtTelephoneNo){
        txtfld=_txtCountry;
        
    }
    
    [txtfld becomeFirstResponder];
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}



// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    UIScrollView *scrollView=_scrollVw;
    UITextField * activeField;
    activeField=(UITextField *)actvtextbox;
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
 
    
}


///EmailValidator
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}






// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIScrollView *scrollView=_scrollVw;
    
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void) initializeTextFieldInputView {
    datepicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datepicker.datePickerMode = UIDatePickerModeDate;
    
    datepicker.backgroundColor = [UIColor whiteColor];
    [datepicker addTarget:self action:@selector(dateUpdated:) forControlEvents:UIControlEventValueChanged];
    _txtstartdate.inputView = datepicker;
    
  timePicker= [[UIDatePicker alloc] initWithFrame:CGRectZero];
  timePicker.datePickerMode = UIDatePickerModeTime;
  timePicker.backgroundColor = [UIColor whiteColor];
  [timePicker addTarget:self action:@selector(timeUpdated:) forControlEvents:UIControlEventValueChanged];
  timePicker.minuteInterval = 5;
    _txtStartTime.inputView=timePicker;
    timePicker= [[UIDatePicker alloc] initWithFrame:CGRectZero];
    timePicker.datePickerMode = UIDatePickerModeTime;
    timePicker.backgroundColor = [UIColor whiteColor];
    [timePicker addTarget:self action:@selector(timeUpdated:) forControlEvents:UIControlEventValueChanged];
    timePicker.minuteInterval = 5;
      _txtEndTime.inputView=timePicker;

    
    
}

- (void) dateUpdated:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    UITextField *actvfld=(UITextField *)actvtextbox;
    
    actvfld.text = [formatter stringFromDate:datePicker.date];
}

- (void) timeUpdated:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    UITextField *actvfld=(UITextField *)actvtextbox;
    
    actvfld.text = [formatter stringFromDate:datePicker.date];
}

#pragma mark - SWRevealViewController Delegate Methods
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if (position == FrontViewPositionLeftSide)
    {
        // Menu will get revealed
        // self.tapGestureRecognizer.enabled = YES;                 // Enable the tap gesture Recognizer
        //self.interactivePopGestureRecognizer.enabled = NO;        // Prevents the iOS7's pan gesture
        // self.topViewController.view.userInteractionEnabled = NO;       // Disable the topViewController's interaction
        
        //tab_browse.userInteractionEnabled=NO; //Table View Intercation NO
    }
    else if (position == FrontViewPositionLeft)
    {
        // Menu will close
        //self.tapGestureRecognizer.enabled = NO;
        //self.interactivePopGestureRecognizer.enabled = YES;
        // self.topViewController.view.userInteractionEnabled = YES;
        
        //tab_browse.userInteractionEnabled=YES;  //Table View Intercation YES
        
    }
}


#pragma mark - TEXTFIELD DELEGATES
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range
replacementString: (NSString*) string
{
    if (textField == _txtContactNumber||textField==_txtTelephoneNo||textField==_txtMainConNumber)
    {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString: string];
        if (text.length<=13)
        {
            if (text.length == 5&&![string isEqualToString:@""])
            {
                textField.text = [NSString stringWithFormat: @"%@  ", text];
                return NO;
            }
        }
        else
        {
            if(textField==_txtMainConNumber)
            {
                isContactsave=NO;
                if (![_txtMainConNumber.text isEqualToString:@""] && [_txtMainConNumber.text length]==13)
                {
                    NSLog(@"_txtMainConNumber.text :%@",_txtMainConNumber.text);
                    [arrMSavedContactNumber addObject:[NSString stringWithFormat:@"%@",_txtMainConNumber.text]];
                }
                
            }
            
            return NO;
        }
    }
    else if (textField== _txtSelectCustomer) //**********
    {
        if ([_txtSelectCustomer.text isEqualToString:@""])
        {
            arrFeedTblPopup=arrCustomerList;
        }
        else
        {
            //NSPredicate *searchSearch = [NSPredicate predicateWithFormat:@"self CONTAINS[cd] %@", _txtSelectCustomer.text];
            
             NSPredicate *searchSearch = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"DisplayText CONTAINS[cd] '%@'", _txtSelectCustomer.text]];
            
            NSArray *searchResults = [arrCustomerList filteredArrayUsingPredicate:searchSearch];
            DLog(@"%@", searchResults);
            arrFeedTblPopup=searchResults;
        }
        [tblView reloadData];
    }
    
    
    if (textField == _txtPurchOrder)
    {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= 20 || returnKey;
        
    }
    return YES;
}




- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
     actvtextbox=textField;
    if (textField ==_txtOrganizationName) {
        int valueJob = [[dicJobAddress valueForKey:@"TypeofOrganisation"] intValue];
        int valueBill = [[dicBillingAddress valueForKey:@"TypeofOrganisation"] intValue];
        int valueLand = [[dicLandLordAdress valueForKey:@"TypeofOrganisation"] intValue];
        
        if (_btnJobAdress.selected==YES && valueJob == 3) {
            return NO;
        }else if (_btnBillingAdress.selected==YES && valueBill == 3){
            return NO;
        }else if (_btnLandlordAdress.selected==YES && valueLand == 3){
            return NO;
        }

    }
    
   
    if (textField !=_txtSelectCustomer) {
        CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y-100);
        [_scrollVw setContentOffset:scrollPoint animated:YES];

    }

    
    
    if (textField == _txtstartdate&&[textField.text isEqualToString:@""])
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        _txtstartdate.text=[formatter stringFromDate:[NSDate date]];
    }
    
    if (textField == _txtStartTime)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        _txtStartTime.text=[formatter stringFromDate:[NSDate date]];
    }
    if (textField ==_txtEndTime)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        _txtEndTime.text=[formatter stringFromDate:[NSDate date]];
    }
    else if (textField == _txtPostcode){
        
       
            PostCodePopupController *post = [[PostCodePopupController alloc] initWithNibName:@"PostCodePopupController" bundle:nil];
            post.delegate=self;
            post.txtDelegate=_txtPostcode;
            [self presentViewController:post animated:YES completion:nil];
        
            return NO;
        
        
    }
     if (textField==_txtJobPrice||textField==_txtCustomerTitle||textField==_txtOrganizationType||textField==_txtTimeAllowance||textField==_txtJobType||textField==_txtAdvertiseChannel|| textField==_txtJobStatus )
    {
        [MBProgressHUD hideAllHUDsForView:Activetxtfld animated:YES];
         Activetxtfld=textField;
        [self.view endEditing:YES];
        for (UILabel *lbl in [textField subviews]) {
            if (lbl.tag==999) {
                [lbl removeFromSuperview];
            }
        }
        [self popupList];
        return NO;
    }else if (textField==_txtSelectCustomer){
        
        [MBProgressHUD hideAllHUDsForView:Activetxtfld animated:YES];
        Activetxtfld=textField;
        [self.view endEditing:YES];
        for (UILabel *lbl in [textField subviews]) {
            if (lbl.tag==999) {
                [lbl removeFromSuperview];
            }
        }
        [self popupList];
        return YES;
        
    }
     else if (textField== _txtMainConNumber ||textField== _txtContactNumber ||textField== _txtTelephoneNo)
     {
         if (isContactsave==YES)
         {
             
         }
         else
         {
             if ([arrMSavedContactNumber count]>0)
             {
                 
                 
                 
                 UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Re-Use Main Contact Number ?"
                                                                                     message:@""
                                                                              preferredStyle: UIAlertControllerStyleAlert];
                 
                 UIAlertAction *NewContactNumber = [UIAlertAction actionWithTitle: @"No, Take New One"
                                                                            style: UIAlertActionStyleDefault
                                                                          handler: ^(UIAlertAction *action) {
                                                                              NSLog(@"Dismiss button tapped!");
                                                                              isContactsave=YES;
                                                                              [textField becomeFirstResponder];
                                                                              
                                                                              
                                                                          }];
                 
                 UIAlertAction *ExistContactNumber = [UIAlertAction actionWithTitle: @"OK , Use It"
                                                                              style: UIAlertActionStyleDefault
                                                                            handler: ^(UIAlertAction *action) {
                                                                                NSLog(@"Dismiss button tapped!");
                                                                                
                                                                                
                                                                                
                                                                                dispatch_async(dispatch_get_main_queue(), ^(){
                                                                                    
                                                                                    if (textField==_txtMainConNumber)
                                                                                    {
                                                                                        [_txtMainConNumber reloadInputViews];
                                                                                        _txtMainConNumber.text=[GlobalDirector ReplaceStringNull:[arrMSavedContactNumber objectAtIndex:0]];
                                                                                        
                                                                                    }
                                                                                    else if (textField==_txtContactNumber)
                                                                                    {
                                                                                        _txtContactNumber.text=[NSString stringWithFormat:@"%@",[arrMSavedContactNumber objectAtIndex:0]];
                                                                                        
                                                                                        [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",_txtContactNumber.text] forKey:@"ContactNumber"];
                                                                                         [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",_txtContactNumber.text] forKey:@"Mobile"];
                                                                                        
                                                                                    }
                                                                                    else if (textField==_txtTelephoneNo)
                                                                                    {
                                                                                        _txtTelephoneNo.text=[NSString stringWithFormat:@"%@",[arrMSavedContactNumber objectAtIndex:0]];
                                                                                        
                                                                                        [selectedAddressDic setValue:[NSString stringWithFormat:@"%@",_txtTelephoneNo.text] forKey:@"ContactNo"];
                                                                                        
                                                                                    }
                                                                                    
                                                                                });
                                                                                
                                                                                
                                                                            }];
                 
                 
                 
                 
                 
                 [controller addAction: NewContactNumber];
                 [controller addAction: ExistContactNumber];
                 [self presentViewController: controller animated: YES completion: nil];
                 
                 
                 
             }
             else
             {
                 isContactsave=YES;
                 [textField becomeFirstResponder];
             }
         }
     }
    else
    {
        ActvTextfldOthr=textField;
        for (UILabel *lbl in [textField subviews]) {
            if (lbl.tag==999) {
                [lbl removeFromSuperview];
            }
        }
        [self handleTap];
    }
    
   
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
     if (textField == _txtSelectCustomer){
        
         [MBProgressHUD hideAllHUDsForView:Activetxtfld animated:YES];
        
         Activetxtfld=textField;
         [self.view endEditing:YES];
         for (UILabel *lbl in [textField subviews]) {
             if (lbl.tag==999) {
                 [lbl removeFromSuperview];
             }
         }
         searchText= _txtSelectCustomer.text;
         [self GetDataForPoppup:Activetxtfld];
         return NO;
         
     }else{
         isContactsave=NO;
         [textField resignFirstResponder];
     }
   

    if (textField==_txtstartdate) {
        [datepicker removeFromSuperview];
        datepicker=nil;
        
    }
    
    else if(textField==_txtFirstname)
    {
        [_txtLastname becomeFirstResponder];
        
    }
    else if(textField==_txtLastname)
    {
        [_txtContactNumber becomeFirstResponder];
        
    }
    else if(textField==_txtContactNumber)
    {
        [_txtEmailAddress becomeFirstResponder];
        
    }
    else if(textField==_txtEmailAddress)
    {
        
        if ([self validateEmailWithString:_txtEmailAddress.text]==NO) {
            
            [self ShowErrorAtTextField:_txtEmailAddress alert:@"Email is not a valid"];
            
           
           
            
        }
        
    }
    
    return YES;
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    isContactsave=NO;
    
    
    //-------Job People-----------
    if (textField==_txtEmailAddress)
    {
        if (![_txtEmailAddress.text isEqualToString:@""])
        {
           [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",_txtEmailAddress.text] forKey:@"EmailAddress"];
        }
    }
    else if(textField==_txtCustomerTitle)
    {
        [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",_txtCustomerTitle.text] forKey:@"Title"];
    }
    else if(textField==_txtFirstname)
    {
        [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",_txtFirstname.text] forKey:@"FirstName"];
    }
    else if(textField==_txtLastname)
    {
        [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",_txtLastname.text] forKey:@"LastName"];
    }
    else if(textField==_txtContactNumber)
    {
        [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",_txtContactNumber.text] forKey:@"ContactNumber"];
        [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",_txtContactNumber.text] forKey:@"Mobile"];
        
        if (_txtContactNumber.text.length>0) {
            [arrMSavedContactNumber addObject:[GlobalDirector ReplaceStringNull:_txtContactNumber.text]];
        }
        
    }
    
    
    //----------------------------------
    
    else if(textField==_txtOrganizationName)
    {
        [selectedAddressDic setValue:[NSString stringWithFormat:@"%@",_txtOrganizationName.text] forKey:@"NameofOrganisation"];
    }
    else if(textField==_txtCountry)
    {
        [selectedAddressDic setValue:[NSString stringWithFormat:@"%@",_txtCountry.text] forKey:@"County"];
        
    }
    else if(textField==_txtCityTown)
    {
        [selectedAddressDic setValue:[NSString stringWithFormat:@"%@",_txtCityTown.text] forKey:@"City"];
        
    }
    else if(textField==_txtPostcode)
    {
        [selectedAddressDic setValue:[NSString stringWithFormat:@"%@",_txtPostcode.text] forKey:@"PostCode"];
        
    }
    else if(textField==_txtTelephoneNo)
    {
        [selectedAddressDic setValue:[NSString stringWithFormat:@"%@",_txtTelephoneNo.text] forKey:@"ContactNo"];
       
       // [arrMSavedContactNumber addObject:[NSString stringWithFormat:@"%@",_txtTelephoneNo.text]];
        
        if (_txtTelephoneNo.text.length>0) {
            [arrMSavedContactNumber addObject:[GlobalDirector ReplaceStringNull:_txtTelephoneNo.text]];
        }

        
    }
    else
    {
        
    }

   
   
    
}






-(void)ShowErrorAtTextField:(UITextField *)txtfld alert:(NSString *)alrt{
   
    for (UILabel *lbl in [txtfld subviews]) {
        if (lbl.tag==999)
        {
            [lbl removeFromSuperview];
            
        }
    }
   
    
            UILabel *err=[[UILabel alloc]init];
            err.text=[NSString stringWithFormat:@"%@",alrt];
            
            err.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:10];
            err.textColor=[UIColor redColor];
            [err sizeToFit];
            err.userInteractionEnabled=NO;
            err.tag=999;
            
            UITextField *textField=txtfld;
            
            
            if (textField==_txtJobPrice||textField==_txtCustomerTitle||textField==_txtOrganizationType||textField==_txtstartdate||textField==_txtStartTime ||textField==_txtEndTime||textField==_txtTimeAllowance||textField==_txtJobType||textField==_txtAdvertiseChannel)
            {
                err.center=CGPointMake(CGRectGetWidth(txtfld.frame)-CGRectGetWidth(err.frame)/2.0f-40, CGRectGetHeight(txtfld.frame)/2.0f);
            }
            
            else
            {
                err.center=CGPointMake(CGRectGetWidth(txtfld.frame)-CGRectGetWidth(err.frame)/2.0f-5, CGRectGetHeight(txtfld.frame)/2.0f);
            }
            
            
            [txtfld addSubview:err];
    

}


#pragma mark - TEXTVIEW DELEGATES
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   
    
   // if (!_txtNoteDesComplete) {
        if([text isEqualToString:@"\n"])
            [textView resignFirstResponder];
    //}
    
    
    actvtextbox=textView;
    
    return textView.text.length + (text.length - range.length) <= 199;
    
    
    
}



- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView==_txtvwUserNote) {
        [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",textView.text] forKey:@"Notes"];
        
    }
    
    if (textView==_txtRemarks) {
        [selectedAddressDic setValue:[NSString stringWithFormat:@"%@",textView.text] forKey:@"Remarks"];
        
    }
    
    
}



- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if (textView==_txtCustomerAddress) {
        [GlobalDirector cleanTextView:_txtCustomerAddress];
    }
    
    CGPoint scrollPoint = CGPointMake(0, textView.frame.origin.y-100);
    [_scrollVw setContentOffset:scrollPoint animated:YES];
    
    textView.textColor=[UIColor blackColor];
    actvtextbox=textView;
    return YES;
    
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    textView.textColor=[UIColor blackColor];
    actvtextbox=textView;
    
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
     if(textView ==_txtCustomerAddress)
    {
        [selectedAddressDic setValue:[NSString stringWithFormat:@"%@",_txtCustomerAddress.text] forKey:@"Address"];
        
    }
    
}



#pragma mark gesture recognizer delegates and action methods


-(void)handleTap
{
    
     [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = tblView.frame;
                         frame.size.height = 0;
                         tblView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         DLog(@"Done!");
                         [tblView removeFromSuperview];
                         tblView=nil;
                         
                     }];
    
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    DLog(@"%@",touch.view);
    if ([touch.view isDescendantOfView:tblView]) {
        
       
        return NO;
    }
    
    return YES;
}



-(void)popupList
{

   if (tblView!=nil)
    {
        [self handleTap];
        [self.dataTask cancel];
        
    }
    
    else
    {
      
         arrFeedTblPopup= [self GetDataForPoppup:Activetxtfld];
        
        tblView=[[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMinX(Activetxtfld.frame),CGRectGetMaxY(Activetxtfld.frame)+2, CGRectGetWidth(Activetxtfld.frame), 0) style:UITableViewStylePlain];
        tblView.delegate=self;
        tblView.dataSource=self;
        if (Activetxtfld==_txtSelectCustomer) {
             [self.view addSubview:tblView];
        }
        else
        {
        [self.scrollVw addSubview:tblView];
        }
        
        
        [tblView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [tblView.layer setBorderWidth: 2.0];
        [tblView.layer setCornerRadius:3.0f];
        [tblView.layer setMasksToBounds:YES];
        
        [UIView animateWithDuration:0.35
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect frame = tblView.frame;
                             frame.size.height = self.view.frame.size.height/2.5f;
                             tblView.frame = frame;
                         }
                         completion:^(BOOL finished){
                             DLog(@"Done!");
                         }];
    }
 
    
    
    
}





-(NSArray *)GetDataForPoppup:(UITextField *)fld
{
    arrFeedTblPopup=nil;
    
    if(fld==_txtJobType){
        
        [self FetchDataForField:@"GetJobNatureList"];
        
        
   
        
    }
    else if(fld==_txtJobPrice){
        
         [self FetchDataForField:@"GetJobPrice"];
    }
    else if(fld==_txtCustomerTitle){
        
         [self FetchDataForField:@"GetCustomerTitleList"];
        
    }
    else if(fld==_txtTimeAllowance){
        
        [self FetchDataForField:@"GetBookedAgent"];
      
    }
    
    
    else if(fld==_txtOrganizationType){
        arrFeedTblPopup=@[@"Small Organisation",@"Large Organisation",@"Residential"];
    }
    else if(fld==_txtAdvertiseChannel){
        
        [self FetchDataForField:@"GetAdvertisingChannelList"];
    }
    
    else if(fld==_txtSelectCustomer){
       
        [MBProgressHUD showHUDAddedTo:_txtSelectCustomer animated:YES];
        
      
        NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
        [dict setObject:[GlobalDirector ReplaceStringNull:searchText] forKey:@"searchText"];
        
        
      searchText=@"";
        
        [globe SyncRequestGet:REQUEST_GetCustomerDetails withPrams:dict andCompletionHandler:^(NSDictionary *result) {
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                
                [MBProgressHUD hideAllHUDsForView:_txtSelectCustomer animated:YES];
                NSArray *arrData = [NSArray array];
                if ([[result valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
                {
                    arrData = (NSArray *)[result objectForKey:@"DataResponses"];
                }
                
                Activetxtfld.text=@"";
                Activetxtfld.userInteractionEnabled=YES;
                arrFeedTblPopup=arrData;
                arrCustomerList=arrFeedTblPopup;
                [tblView reloadData];
                
                
            });
            
        }];
        
       
    }
    else if(fld==_txtJobStatus)
    {
       
        [self FetchDataForField:@"GetJobStatus"];
        
    }
    else
    {
        
    }
    
    return arrFeedTblPopup;
}

#pragma mark -  TableView Delegate Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![arrFeedTblPopup isKindOfClass:[NSNull class]]) {
          return [arrFeedTblPopup count];
    }else{
        return 0;
    }
  
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"CELL";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    
    cell.textLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    cell.textLabel.textColor=[UIColor darkGrayColor];
    
    
    NSDictionary *tempDic=[arrFeedTblPopup objectAtIndex:indexPath.row];
   
    
    
    if (![tempDic isKindOfClass:[NSDictionary class]]) {
        cell.textLabel.text=[arrFeedTblPopup objectAtIndex:indexPath.row];
        
    }
    else
    {
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[tempDic valueForKey:@"DisplayText"]];
        
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
       [self handleTap];
    
    NSDictionary *tempDic=[arrFeedTblPopup objectAtIndex:indexPath.row];
    
    if (![tempDic isKindOfClass:[NSDictionary class]])
    {
        Activetxtfld.text=[arrFeedTblPopup objectAtIndex:indexPath.row];
        Activetxtfld.tag=indexPath.row+1;
        
    }
    else
    {
        
        Activetxtfld.text=[NSString stringWithFormat:@"%@",[tempDic valueForKey:@"DisplayText"]];
        Activetxtfld.tag=[[NSString stringWithFormat:@"%@",[tempDic valueForKey:@"Value"]]integerValue];
    }
    
    if (Activetxtfld==_txtCustomerTitle)
    {
  
       if (_isJobEdited) {
            [SelectedUserDic setValue:[NSString stringWithFormat:@"%ld",(long)Activetxtfld.tag] forKey:@"TitleID"];
            [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",Activetxtfld.text] forKey:@"Title"];
            
        }
        else
        {
            
            [SelectedUserDic setValue:[NSString stringWithFormat:@"%ld",(long)Activetxtfld.tag] forKey:@"TitleID"];
            [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",Activetxtfld.text] forKey:@"Title"];
         
        }
    }
    
    
    
    if (Activetxtfld==_txtOrganizationType)
    {
        
        [selectedAddressDic setValue:[NSString stringWithFormat:@"%ld",(long)(indexPath.row+1)] forKey:@"TypeofOrganisation"];
        
        [selectedAddressDic setValue:[NSString stringWithFormat:@"%@",Activetxtfld.text] forKey:@"TypeofOrganisationText"];
        
    }
    
    if (Activetxtfld==_txtSelectCustomer)
    {
        
        customerID = Activetxtfld.tag;
        [searchActivity startAnimating];
        [self FetchCustomerDetails:Activetxtfld.tag];
  
    }
    
    if (Activetxtfld==_txtJobStatus)
    {
        [selectedAddressDic setValue:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"JobStatus"];
        _txtJobStatus.tag=[[tempDic valueForKey:@"Value"]integerValue];
        [selectedAddressDic setValue:[NSString stringWithFormat:@"%@",Activetxtfld.text] forKey:@"JobStatusText"];
        
        if ([Activetxtfld.text isEqualToString:@"Complete"]) {
            
            [self ShowPopupComplete];
        }else if ([Activetxtfld.text isEqualToString:@"Job Cancelled"]) {
            [self ShowPopupCancelNote];
        }
        
    }
    
 
    
}



-(void)FetchCustomerDetails:(NSInteger)CustomerId
{
    
   
    NSString *post =[NSString stringWithFormat:@""];
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    
    NSString *urlString=[NSString stringWithFormat:@"%sCustomerDetails?userToken=%@&custId=%ld",conn_url,(NSString *)[userdetails valueForKey:@"UserToken"],(long)CustomerId];
    
    
    
    DLog(@"PostString=%@",urlString);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    request.timeoutInterval = 300;
    DLog(@"PostString=%@",request);
    
   
    
    
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *returnData, NSURLResponse *response, NSError *error){
        
        DLog(@"PostString=%@",urlString);
        [searchActivity stopAnimating];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error==nil) {
                NSMutableDictionary* temp;
                if (returnData !=nil)
                {
                    NSError *error1;
                    
                    
                    temp = [NSJSONSerialization JSONObjectWithData:returnData  options:NSJSONReadingMutableContainers error:&error1];
                    if (!error1)
                    {
                        
                        
                        if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"]) {
                            
                            
                           
                            SelectedUserDic = [temp mutableCopy];
                            
                          
                          
                            
                             [self prePopulateUserDetailsDic:SelectedUserDic];
                            
                            
                           
                            NSDictionary *dic = temp;
                            
                            if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==1) {
                               [self btnOwnerTapped:_btnOwner];
                            }else if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==2){
                                [self btnTenantTapped:_btnTenant];
                            }else if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==3 || [[dic valueForKey:@"TypeofCustomer"]integerValue]==4){
                                [self btnLandlordTapped:_btnLandlord];
                            }
                            
                            //  1 Owner
                            //  2 Tenant
                            //  3 Landlord
                            //  4 Managing Agent

                            
                            
                            
                           
                            
                          
                            [self btnBillingAdressTapped:_btnBillingAdress];
                            
                            NSLog(@"temp :%@",temp);
                            NSString *str=[GlobalDirector ReplaceStringNull:[temp valueForKey:@"Mobile"]];
                            NSLog(@"str :%@",str);
                            
                            if (str.length>0) {
                                 [arrMSavedContactNumber addObject:str];
                            }
                           
                            
                           
                            
                        }
                        
                        else {
                            DLog(@"JSONObjectWithData error: %@", error1);
                            
                            
                        }
                        
                        
                        
                        
                    }
                    
                }
                else
                {
                    
                    
                    
                }
                
                
            }
            else
            {
                [self showAlert:@"There are some problem right now, try again later " withTitle:@"Sorry!"];
                
                
            }
            
        });
        
    }];
    
   
    
    //DLog(@"temp all static page:%@",temp);
  
}



/////////////////////////////////////////////////////////Address User SElection//////////////////////////////////////////////////////////


- (IBAction)btnOwnerTapped:(UIButton *)sender
{

    if (SelectedUserDic) {
        [self PopulateUserDetailsDic:SelectedUserDic];
    }
    
    
    [self ResetFieldsFor:@"User"];
    _btnOwner.selected=YES;
    _btnLandlord.selected=NO;
    _btnTenant.selected=NO;
    SelectedUserDic=[dicOwnerDetails mutableCopy];
    [SelectedUserDic setValue:[NSNumber numberWithInt:1] forKey:@"TypeofCustomer"];
    [self FetchUserDicValue:dicOwnerDetails];
    [self animateToActiveButton:sender image:_selected];
    [self TextFieldsInterationEnable:YES];
    
   
    
}



- (IBAction)btnLandlordTapped:(UIButton *)sender
{
    if (SelectedUserDic) {
         [self PopulateUserDetailsDic:SelectedUserDic];
    }
   
    
    [self ResetFieldsFor:@"User"];
    _btnOwner.selected=NO;
    _btnLandlord.selected=YES;
    _btnTenant.selected=NO;
    SelectedUserDic=[dicLandLordDetails mutableCopy];
    [SelectedUserDic setValue:[NSNumber numberWithInt:3] forKey:@"TypeofCustomer"];
   
    
    [self FetchUserDicValue:dicLandLordDetails];
    
    [self animateToActiveButton:sender image:_selected];
    [self TextFieldsInterationEnable:YES];
}

- (IBAction)btnTenantTapped:(UIButton *)sender
{
    if (SelectedUserDic) {
       [self PopulateUserDetailsDic:SelectedUserDic];
    }
   
    
    [self ResetFieldsFor:@"User"];
    _btnOwner.selected=NO;
    _btnLandlord.selected=NO;
    _btnTenant.selected=YES;
    SelectedUserDic=[dicTenantDetails mutableCopy];
    [SelectedUserDic setValue:[NSNumber numberWithInt:2] forKey:@"TypeofCustomer"];
    [self FetchUserDicValue:dicTenantDetails];
    [self animateToActiveButton:sender image:_selected];
    [self TextFieldsInterationEnable:YES];
}



- (IBAction)btnJobAdressTapped:(id)sender
{
    
    [self SetupAddressDict];
    
    _lblAddress.text=@"  Job Address";

    
    
    [self ResetFieldsFor:@"Address"];
    _btnJobAdress.selected=YES;
    _btnLandlordAdress.selected=NO;
    _btnBillingAdress.selected=NO;
    selectedAddressDic=[dicJobAddress mutableCopy];
    [self FetchAddressDicValue:dicJobAddress];
    [selectedAddressDic setValue:@"1" forKey:@"TypeOfAddress"];
    
    [self animateToActiveButton:sender image:_selected2];
    [self TextFieldsInterationEnable:YES];
    
    
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Address"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionBill = [UIAlertAction actionWithTitle:@"Same as billing address"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                          isNewAddress=NO;
                                                         
                                                         dicJobAddress = [[NSMutableDictionary alloc] initWithDictionary:[dicBillingAddress mutableCopy]];
                                                         [dicJobAddress setValue:@"1" forKey:@"TypeOfAddress"];
                                                         
                                                          if (_isJobEdited==YES) {
                                                          [dicJobAddress setValue:@"0" forKey:@"JobAddressID"];
                                                          }
                                                         
                                                          selectedAddressDic=[dicJobAddress mutableCopy];
                                                         
                                                          [self FetchAddressDicValue:dicJobAddress];
                                                         
                                                         
                                                         
                                                         
                                                     }];
    
    
    
    UIAlertAction *actionPre = [UIAlertAction actionWithTitle:@"Select from list of previous addresses"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                           
                                                           if (_txtSelectCustomer.text.length>0) {
                                                              isNewAddress=NO;
                                                                [self performSelector:@selector(ShowAddressPopUp) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
                                                               
                                                           }else{
                                                               [self showAlert:@"Please select customer first." withTitle:@"Error"];
                                                           }
                                                          
                                                           
                                                           
                                                       }];
    
    UIAlertAction *actionNew = [UIAlertAction actionWithTitle:@"add new address"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                          isNewAddress=YES;
                                                          [self performSelector:@selector(ShowPostCodePopUp) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
                                                          
                                                      }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                        
                                                          
                                                      }];
    
    
    
    [alertController addAction:actionBill];
    [alertController addAction:actionPre];
    [alertController addAction:actionNew];
    [alertController addAction:cancel];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
   
    
    
}


-(void)ShowPostCodePopUp{
   
    PostCodePopupController *post = [[PostCodePopupController alloc] initWithNibName:@"PostCodePopupController" bundle:nil];
    post.delegate=self;
    post.txtDelegate=_txtPostcode;
    [self presentViewController:post animated:YES completion:nil];
}


-(void)ShowAddressPopUp{

    AddSelPopupController *post = [[AddSelPopupController alloc] initWithNibName:@"AddSelPopupController" bundle:nil];
    post.customerId = [NSString stringWithFormat:@"%ld",(long)customerID];
    post.delegate=self;
    [self presentViewController:post animated:YES completion:nil];
    
}





- (IBAction)btnBillingAdressTapped:(id)sender
{
    [self SetupAddressDict];
   
    _lblAddress.text=@"  Billing Address";
    
    
    [self ResetFieldsFor:@"Address"];
    _btnJobAdress.selected=NO;
    _btnLandlordAdress.selected=NO;
    _btnBillingAdress.selected=YES;
    selectedAddressDic=[dicBillingAddress mutableCopy];
    [self FetchAddressDicValue:dicBillingAddress];
    [selectedAddressDic setValue:@"2" forKey:@"TypeOfAddress"];
    
    [self animateToActiveButton:sender image:_selected2];
    [self TextFieldsInterationEnable:YES];
}


- (IBAction)btnLandlordAdressTapped:(id)sender
{
    [self SetupAddressDict];
    _lblAddress.text=@"  LL Address";
    
    
    [self ResetFieldsFor:@"Address"];
    _btnJobAdress.selected=NO;
    _btnLandlordAdress.selected=YES;
    _btnBillingAdress.selected=NO;
    selectedAddressDic=[dicLandLordAdress mutableCopy];
    [selectedAddressDic setValue:@"3" forKey:@"TypeOfAddress"];
    
    [self FetchAddressDicValue:dicLandLordAdress];
    [self animateToActiveButton:sender image:_selected2];
    [self TextFieldsInterationEnable:YES];
}

-(void)SetupAddressDict
{
    if (selectedAddressDic) {
        
        if ([[selectedAddressDic valueForKey:@"TypeOfAddress"] isEqualToString:@"1"]) {
            dicJobAddress =[selectedAddressDic mutableCopy];
            
        }else if ([[selectedAddressDic valueForKey:@"TypeOfAddress"] isEqualToString:@"2"]){
            dicBillingAddress =[selectedAddressDic mutableCopy];
            
        }else if ([[selectedAddressDic valueForKey:@"TypeOfAddress"] isEqualToString:@"3"]){
            dicLandLordAdress =[selectedAddressDic mutableCopy];
            
        }
        
    }
    
}



#pragma mark Add Job Material
- (IBAction)btnJobMatTapped:(id)sender
{
    addMat.strHeading=@"Add Materials";
   // addMat.Materials=arradditionalMaterials;
     addMat.jobID=(NSString *)[_jobDic valueForKey:@"JobID"];
    addMat.strFromCustomerClass=[NSString stringWithFormat:@"%@",[self class]];
    [self presentViewController:addMat animated:YES completion:nil];
    
    
    
}
#pragma mark Add Job Cost
- (IBAction)btnJobCostTapped:(id)sender
{
     addcost.strHeading=@"Add Cost";
   // addcost.Costs=arradditionalCost;
     addcost.strFromCustomerClass=[NSString stringWithFormat:@"%@",[self class]];
      addcost.jobID=(NSString *)[_jobDic valueForKey:@"JobID"];
     [self presentViewController:addcost animated:YES completion:nil];
    
}
#pragma mark Add Notes
- (IBAction)btnJobNoteTapped:(id)sender
{
    addNote.strHeading=@"Add Notes";
   // addNote.Notes=arradditionalNotes;
    addNote.jobID=(NSString *)[_jobDic valueForKey:@"JobID"];
  //  addNote.jobStatus=(NSString *)[_jobDic valueForKey:@"JobStatus"];
    

    addNote.strFromCustomerClass=[NSString stringWithFormat:@"%@",[self class]];
    [self presentViewController:addNote animated:YES completion:nil];
    
    
    
    
   
    

}


-(void)FetchUserDicValue:(NSMutableDictionary *)dic
{
    
    
    if (![[dic valueForKey:@"FirstName"]isEqualToString:@""]) {
        _txtFirstname.text=[dic valueForKey:@"FirstName"];
        [self cleanTextField:_txtFirstname];
        
    }
    if (![[dic valueForKey:@"LastName"]isEqualToString:@""]) {
        _txtLastname.text=[dic valueForKey:@"LastName"];
         [self cleanTextField:_txtLastname];
        
    }
    
    
    if (![[dic valueForKey:@"Title"]isEqualToString:@""]) {
        _txtCustomerTitle.text=[dic valueForKey:@"Title"];
        _txtCustomerTitle.tag=[[dic valueForKey:@"TitleID"]integerValue];
        
         [self cleanTextField:_txtCustomerTitle];
        
    }
    if (![[dic valueForKey:@"EmailAddress"]isKindOfClass:[NSNull class]]) {
        _txtEmailAddress.text=[dic valueForKey:@"EmailAddress"];
        [self cleanTextField:_txtEmailAddress];
        
    }
    if (![[dic valueForKey:@"ContactNumber"]isEqualToString:@""]) {
        _txtContactNumber.text=[dic valueForKey:@"ContactNumber"];
        [self cleanTextField:_txtContactNumber];
        
    }
    if (![[dic valueForKey:@"Notes"]isEqualToString:@""]) {
        _txtvwUserNote.text=[dic valueForKey:@"Notes"];
       
        
    }
    
    if (_isJobEdited==YES) {
        if ([dic valueForKey:@"Title"]) {
            _txtCustomerTitle.text=[dic valueForKey:@"Title"];
        }
        else
        {
            _txtCustomerTitle.text=[dic valueForKey:@"Title"];
        }
        [self cleanTextField:_txtCustomerTitle];
        
        _txtCustomerTitle.tag=[[dic valueForKey:@"TitleID"]integerValue];
    }
    
}



-(void)cleanTextField:(UITextField *)textField{
    for (UILabel *lbl in [textField subviews]) {
        if (lbl.tag==999) {
            
            [lbl removeFromSuperview];
            
            
        }
    }
    
}



-(void)TextFieldsInterationEnable:(BOOL)change{
   
     _txtCustomerAddress.userInteractionEnabled=change;
     _txtCountry.userInteractionEnabled=change;
     _txtCityTown.userInteractionEnabled=change;
     _txtPostcode.userInteractionEnabled=change;
     _txtTelephoneNo.userInteractionEnabled=change;
   
    _txtRemarks.userInteractionEnabled=change;
    
    
    
    
    _txtFirstname.userInteractionEnabled=change;
     _txtLastname.userInteractionEnabled=change;
     _txtCustomerTitle.userInteractionEnabled=change;
     _txtEmailAddress.userInteractionEnabled=change;
     _txtContactNumber.userInteractionEnabled=change;
     _txtvwUserNote.userInteractionEnabled=change;
    
    
    
}


-(void)FetchAddressDicValue:(NSMutableDictionary *)dic
{
    
    if (![[dic valueForKey:@"NameofOrganisation"]isEqualToString:@""]) {
        _txtOrganizationName.text=[dic valueForKey:@"NameofOrganisation"];
         [self cleanTextField:_txtOrganizationName];
        
    }
    if (![[dic valueForKey:@"Address"]isEqualToString:@""]) {
        _txtCustomerAddress.text=[dic valueForKey:@"Address"];
       
        [GlobalDirector cleanTextView:_txtCustomerAddress];
        
        
    }
    if (![[dic valueForKey:@"County"]isEqualToString:@""]) {
        _txtCountry.text=[dic valueForKey:@"County"];
         [self cleanTextField:_txtCountry];
        
    }
    if (![[dic valueForKey:@"City"]isEqualToString:@""]) {
        _txtCityTown.text=[dic valueForKey:@"City"];
         [self cleanTextField:_txtCityTown];
        
    }
    if (![[dic valueForKey:@"PostCode"]isEqualToString:@""]) {
        _txtPostcode.text=[dic valueForKey:@"PostCode"];
         [self cleanTextField:_txtPostcode];
        
    }
    if (![[dic valueForKey:@"ContactNo"]isEqualToString:@""]) {
        _txtTelephoneNo.text=[dic valueForKey:@"ContactNo"];
         [self cleanTextField:_txtTelephoneNo];
        
    }
    
    if ([dic valueForKey:@"TypeofOrganisationText"]) {
        _txtOrganizationType.text=[dic valueForKey:@"TypeofOrganisationText"];
         [self cleanTextField:_txtOrganizationName];
       
        
    }
    if (![[dic valueForKey:@"Remarks"]isEqualToString:@""]) {
        _txtRemarks.text=[dic valueForKey:@"Remarks"];
         [self cleanTextField:_txtOrganizationName];
        
        
    }
   
    
    if (_isJobEdited==YES) {
        if (![dic valueForKey:@"TypeofOrganisationText"]) {
            
            NSString *typeOfOrganisation;
            if ([[dic valueForKey:@"IsLargeOrganisation"]boolValue]==1)
            {
                typeOfOrganisation=@"LargeOrganisation";
                
            }
            
            else if ([[dic valueForKey:@"IsResidential"]boolValue]==1)
            {
                typeOfOrganisation=@"Residential";
                
            }
            
            else if ([[dic valueForKey:@"IsSmallOrganisation"]boolValue]==1)
            {
                typeOfOrganisation=@"Small Organisation";
                
            }
            
            else
            {
                typeOfOrganisation=@"";
            }
            
            _txtOrganizationType.text=typeOfOrganisation;
            _txtOrganizationType.tag=[[dic valueForKey:@"TypeofOrganisation"]integerValue];
            
        }
        else
        {
            _txtOrganizationType.text=[dic valueForKey:@"TypeofOrganisationText"];
            
        }
         [self cleanTextField:_txtOrganizationName];
    }
 
}


-(void)animateToActiveButton:(UIButton *)btn image:(UIImageView*)img
{
    
    img.backgroundColor=[UIColor whiteColor];
    
    
    
    img.frame=btn.frame;
}


-(void)ResetFieldsFor:(NSString *)key
{
    if ([key isEqualToString:@"User"]) {
        _txtFirstname.text=@"";
        _txtLastname.text=@"";
        _txtCustomerTitle.text=@"";
        _txtEmailAddress.text=@"";
        _txtContactNumber.text=@"";
        _txtvwUserNote.text=@"";
    }
    else if ([key isEqualToString:@"Address"])
    {
        _txtOrganizationName.text=@"";
        _txtCustomerAddress.text=@"";
        _txtCountry.text=@"";
        _txtCityTown.text=@"";
        _txtPostcode.text=@"";
        _txtOrganizationType.text=@"";
        _txtRemarks.text=@"";
        _txtTelephoneNo.text=@"";
        
        
    }
}


-(BOOL)ChectUserDetails:(NSMutableDictionary*)dict
{
    
    NSString *strFirstLL = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"FirstName"]];
    NSString *strLastLL = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"LastName"]];
    NSString *strTitleLL = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"TitleID"]];
    
  
    
    
  
    
    if (strFirstLL.length>0 && strLastLL.length>0  && strTitleLL.length>0) {
       return YES;
    }else{
        return NO;
    }
    
    
    
    
}

#pragma mark - Submit / Cancel Press
-(IBAction)submitPress:(id)sender
{
    
    
    
    
    
    if (SelectedUserDic) {
        [self PopulateUserDetailsDic:SelectedUserDic];
    }

 
    if ([self ChkAllTextFlds]==YES)
    {
         [self SetupAddressDict];
        
        if ([self ChectUserDetails:dicOwnerDetails]==NO && [self ChectUserDetails:dicLandLordDetails]==NO) {
            
            [self showAlert:@"Please fill customer details under owner or Agent/LL" withTitle:@"Wait"];
            
            
        }
        else if ([dicJobAddress isKindOfClass:[NSNull class]]||[dicJobAddress count]<4)
        {
            [self showAlert:@"Please fill job address details" withTitle:@"Wait"];
            
        }else{
             
             Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
             NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
             if (networkStatus == NotReachable) {
                 DLog(@"There IS NO internet connection");
                 
                 [self showAlert:@"Check your Internet connection" withTitle:@"Connection Error!"];
                 
             }
             
             else {
                 DLog(@"There IS internet connection");
                 hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                 hud.labelText = @"Posting...";
                 
                 [self PostJob];
             }
             
         }
        
        
    }else
    {
        [self showAlert:@"Please check all fields" withTitle:@"Wait"];
        
    }
}


-(IBAction)cancelPress:(id)sender
{
   [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)backPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Validation Check all Fields
-(BOOL)ChkAllTextFlds
{
    int flag=1;
    for (UITextField *txtfield in [_scrollVw subviews])
    {
        if ([txtfield isKindOfClass:[UITextField class]])
        {
            UITextField *txtfld=(UITextField *)txtfield;
            
            
            if ([txtfld.text isEqualToString:@""]&&(txtfld!=_txtOrganizationName)&&(txtfld!=_txtOrganizationType)&&(txtfld!=_txtTelephoneNo)&&(txtfld!=_txtEmailAddress)&&(txtfld!=_txtContactNumber)&&(txtfld!=_txtCustomerTitle)&&(txtfld!=_txtFirstname)&&(txtfld!=_txtLastname)&&(txtfld!=_txtPurchOrder)&&(txtfld!=_txtMainConNumber)) {
                
               
                        [self ShowErrorAtTextField:txtfld alert:@" *Field Should not be blanked"];
                        flag=0;
              
          
            }
            
          
          
            
        }
        
    }
    
    if (_btnJobAdress.selected==YES || _btnBillingAdress.selected==YES ) {
        if (_txtCustomerAddress.text.length==0) {
            [GlobalDirector ShowErrorAtTextView:_txtCustomerAddress alert:@" *Field Should not be blanked"];
             flag=0;
        }
    }
    
    if (flag==0) {
        return NO;
        
    }
    
    return YES;
    
    
}


#pragma mark ADD Job Material Notes Delegates
-(void)addItemViewController:(id)controller didFinishEnteringItem:(NSMutableArray *)Item{
    
    DLog(@"calling functions ::::%@",Item);
   
    if ([controller isKindOfClass:[AddNotes class]]) {
        arradditionalNotes=Item;
      [_btnJobNote setTitle:[NSString stringWithFormat:@"Add Job Notes %ld",(unsigned long)[Item count]] forState:UIControlStateNormal];
    }
    else if ([controller isKindOfClass:[AddMaterials class]])
    {
        arradditionalMaterials=Item;
        [_btnJobMat setTitle:[NSString stringWithFormat:@"Add Mat %ld",(unsigned long)[Item count]] forState:UIControlStateNormal];
        
    }
    else if([controller isKindOfClass:[AddCostViewController class]])
    {
        
        arradditionalCost=Item;
     [_btnJobCost setTitle:[NSString stringWithFormat:@"Add Cost %ld",(unsigned long)[Item count]] forState:UIControlStateNormal];
        
    }
    DLog(@"calling functions ::::%@",Item);
}

#pragma mark FETCHDROPDOWNS


-(void)FetchDataForField:(NSString *)key{
    
    DLog(@"%@",self.dataTask.originalRequest.URL);
    
   
    [MBProgressHUD showHUDAddedTo:Activetxtfld animated:YES];
    
    [self fetchDropDownForTextField:key didFinishLoading:^(BOOL success , NSArray *arrData){
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            [MBProgressHUD hideAllHUDsForView:Activetxtfld animated:YES];
            
          
            
            if(![arrData isKindOfClass:[NSNull class]])  {
                
                arrFeedTblPopup=arrData;
                [tblView reloadData];
                [self.dataTask cancel];
                
            }else{
                arrFeedTblPopup = [[NSArray alloc] init];
            }
            
        });
        
    }];
}


#pragma mark- Customer Registration

- (IBAction)CustomeRegistration:(UIButton *)sender {
   
    CustomerRegistration *reg = [[CustomerRegistration alloc] initWithNibName:@"CustomerRegistration" bundle:nil];
    [self.navigationController pushViewController:reg animated:YES];

}



#pragma mark Method Job Create

-(void)PostJob
{
   
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    if (SelectedUserDic) {
        [self PopulateUserDetailsDic:SelectedUserDic];
    }
   
    
    if (!_isJobEdited)
    {
        if ([dicOwnerDetails valueForKey:@"TitleID"]) {
            NSString *idTitle = [dicOwnerDetails valueForKey:@"TitleID"];
            [dicOwnerDetails setValue:idTitle forKey:@"Title"];
        }
        
        if ([dicLandLordDetails valueForKey:@"TitleID"]) {
            NSString *idTitle = [dicLandLordDetails valueForKey:@"TitleID"];
            [dicLandLordDetails setValue:idTitle forKey:@"Title"];
        }
        
        if ([dicTenantDetails valueForKey:@"TitleID"]) {
            NSString *idTitle = [dicTenantDetails valueForKey:@"TitleID"];
            [dicTenantDetails setValue:idTitle forKey:@"Title"];
        }
    }
    
   

  
    
    
    NSError *error;
    NSArray *UserDetailsArr=[NSArray arrayWithObjects:dicOwnerDetails,dicLandLordDetails, dicTenantDetails,nil];
    
    NSArray *AddressArr=[NSArray arrayWithObjects:dicBillingAddress,dicJobAddress,dicLandLordAdress, nil];
    
    
    NSData *jsonUserDetails = [NSJSONSerialization dataWithJSONObject:UserDetailsArr
                                                              options:0
                                                                error:&error];
    NSData *jsonAddress = [NSJSONSerialization dataWithJSONObject:AddressArr
                                                          options:0
                                                            error:&error];
    
    
    NSData *jsonadditionalNotes;
    NSData *jsonMaterials;
    NSData *jsonCost;
    
 
    
    
     if ([arradditionalNotes count]!=0)
     {
         NSMutableArray *arrNote = [[NSMutableArray alloc] init];
         
         
         
         for (NSDictionary *dict in arradditionalNotes) {
             NSMutableDictionary *dictM = [dict mutableCopy];
             [dictM removeObjectForKey:@"CreatedOn"];
             [arrNote addObject:dictM];
         }
         
         jsonadditionalNotes = [NSJSONSerialization dataWithJSONObject:arrNote
                                                                       options:0
                                                                         error:&error];
     }
    
    
    if ([arradditionalMaterials count]!=0)
    {
        jsonMaterials = [NSJSONSerialization dataWithJSONObject:arradditionalMaterials
                                                                options:0
                                                                  error:&error];
    }
    if ([arradditionalCost count]!=0)
    {
        jsonCost = [NSJSONSerialization dataWithJSONObject:arradditionalCost
                                                           options:0
                                                             error:&error];

    }
   
    NSString *JSONStringAdrr,*JSONStringUsers;
    NSString *JSONStringAdditionalNotes,*JSONStringMaterials,*JSONNStringCost;
    
    //---------------------------------------------------------------------------------------------------------------------------------------
    if (!jsonUserDetails) {
    } else {
        JSONStringUsers = [[NSString alloc] initWithBytes:[jsonUserDetails bytes] length:[jsonUserDetails length] encoding:NSUTF8StringEncoding];
    }
    //---------------------------------------------------------------------------------------------------------------------------------------
    if (!jsonAddress) {
    } else {
        JSONStringAdrr = [[NSString alloc] initWithBytes:[jsonAddress bytes] length:[jsonAddress length] encoding:NSUTF8StringEncoding];
    }
    //===========================================================================================
    
    
    if (!jsonadditionalNotes) {
       JSONStringAdditionalNotes=@"";
        
    } else {
        
        JSONStringAdditionalNotes = [[NSString alloc] initWithBytes:[jsonadditionalNotes bytes] length:[jsonadditionalNotes length] encoding:NSUTF8StringEncoding];
      
    }
    //----------
    if (!jsonMaterials) {
        JSONStringMaterials=@"";
        
    } else {
        
        JSONStringMaterials = [[NSString alloc] initWithBytes:[jsonMaterials bytes] length:[jsonMaterials length] encoding:NSUTF8StringEncoding];
        
    }
    //-------------
    if (!jsonCost) {
       JSONNStringCost=@"";
        
    } else {
        
        JSONNStringCost = [[NSString alloc] initWithBytes:[jsonCost bytes] length:[jsonCost length] encoding:NSUTF8StringEncoding];
    
    }
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *startDate=[formatter dateFromString:_txtstartdate.text];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString *startDateStr=[formatter stringFromDate:startDate];
  
    
    NSLog(@"_txtSelectCustomer tag:%ld",(long)_txtSelectCustomer.tag);
    
    if (_txtSelectCustomer.tag==0) {
        _txtSelectCustomer.tag=customerID;
    }
    
    NSString *json;
    NSMutableDictionary *postDictionary = [NSMutableDictionary dictionary];
    [postDictionary setValue:(NSString *)[userdetails valueForKey:@"UserToken"] forKey:@"userToken"];
    [postDictionary setValue:(NSString *)[userdetails valueForKey:@"UserID"] forKey:@"userID"];
    [postDictionary setValue:(NSString *)[userdetails valueForKey:@"UserType"] forKey:@"userType"];
    [postDictionary setValue:startDateStr forKey:@"jobStartDate"];
    [postDictionary setValue:_txtStartTime.text forKey:@"startTime"];
    [postDictionary setValue:[NSString stringWithFormat:@"%ld",(long)_txtTimeAllowance.tag] forKey:@"BookedAgent"];
    [postDictionary setValue:_txtEndTime.text forKey:@"EndTime"];
    
   
    [postDictionary setValue:[NSString stringWithFormat:@"%ld",(long)_txtAdvertiseChannel.tag] forKey:@"advertisingChannel"];
    [postDictionary setValue:_txtMainConNumber.text forKey:@"mainContactNumber"];
    [postDictionary setValue:[NSString stringWithFormat:@"%ld",(long)_txtJobPrice.tag] forKey:@"jobPriceID"];
    [postDictionary setValue:@"" forKey:@"jobStatus"];
    [postDictionary setValue:[NSString stringWithFormat:@"%ld",(long)_txtJobType.tag] forKey:@"natureofJob"];
    [postDictionary setValue:(NSString *)[userdetails valueForKey:@"StaffID"] forKey:@"staffID"];
    [postDictionary setValue:_txtVwJobDesc.text forKey:@"jobDescription"];
    [postDictionary setValue:JSONStringUsers forKey:@"jobPeople"];
    [postDictionary setValue:JSONStringAdrr forKey:@"jobAddress"];
    [postDictionary setValue:JSONStringAdditionalNotes forKey:@"jobNote"];
    [postDictionary setValue:JSONStringMaterials forKey:@"jobMaterial"];
    [postDictionary setValue:JSONNStringCost forKey:@"jobCost"];
    [postDictionary setValue:[NSString stringWithFormat:@"%ld",(long)_txtSelectCustomer.tag] forKey:@"custId"];
    
    if (_txtPurchOrder.text.length>0) {
        [postDictionary setValue:_txtPurchOrder.text forKey:@"purchaseOrder"];
        
    }
    
    
    NSString  *url;
    if (_isJobEdited==YES)
    {
       
        
        NSLog(@"TAG: %ld",(long)_txtJobStatus.tag);
        
        if (_txtJobStatus.tag==3) {
            [postDictionary setObject:_txtNoteDesComplete.text forKey:@"noteText"];
            if (_segNote.selectedSegmentIndex==0) {
                [postDictionary setObject:[NSString stringWithFormat:@"22"] forKey:@"noteType"];
            }else if (_segNote.selectedSegmentIndex==1){
                [postDictionary setObject:[NSString stringWithFormat:@"23"] forKey:@"noteType"];
            }else if (_segNote.selectedSegmentIndex==2){
                [postDictionary setObject:[NSString stringWithFormat:@"10"] forKey:@"noteType"];
            }
        }else if (_txtJobStatus.tag == 12) {
            [postDictionary setObject:_txtVCancelNote.text forKey:@"noteText"];
            [postDictionary setObject:[NSString stringWithFormat:@"15"] forKey:@"noteType"];  
        }
    
      
        
        NSString *jobid =[NSString stringWithFormat:@"%ld",(long)[[_jobDic valueForKey:@"JobID"] integerValue]];
        NSString *custID=@"0";
        
        NSArray *arrpplList=[_jobDic valueForKey:@"JobPeopleListResponse"];
        for (NSDictionary *dic in arrpplList) {
            
                if ([[dic valueForKey:@"CustID"] intValue]>0) {
                     custID=[dic valueForKey:@"CustID"];
                }
            
        }
        
        
            [postDictionary setValue:[NSString stringWithFormat:@"%ld",(long)_txtJobStatus.tag] forKey:@"jobStatus"];

  
        [postDictionary setValue:jobid forKey:@"jobID"];
        [postDictionary setValue:custID forKey:@"custId"];
        //url=[NSString stringWithFormat:@"%sEngineerManagerJobEdit",conn_url];
        url=[NSString stringWithFormat:@"%sEngineerManagerJobEditComplete",conn_url];
        
        
    }
    else
    {
        NSString *jobid =@"0";
        [postDictionary setValue:jobid forKey:@"jobID"];
        url=[NSString stringWithFormat:@"%sEngineerManagerJobCreate",conn_url];
    }
    
    NSError *jsonError;
   
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString :url]];
    DLog(@"request :%@",request);
    NSData *reqData=[NSData dataWithBytes:[json UTF8String] length:[json length]];
    self.totalBytes=(unsigned long)[reqData length];
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld",(unsigned long)_totalBytes] forHTTPHeaderField:@"Content-Length"];
    request.timeoutInterval = 300;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDictionary options:0
                                                         error:&jsonError];
    if (!jsonError)
    {
        //set POST body
        [request setHTTPBody:postData];
    }
    _totalBytes=_totalBytes+(unsigned long)[postData length];
    DLog(@"%ld",(unsigned long)_totalBytes);
    
    connIdentifier=@"connPostNote";
    [self PostDataToServerWithUrl:url dataDictionary:postDictionary finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
        if (error==nil) {
            _responseData=[data mutableCopy];
            [self connectionDidFinishLoading:connPostNote];
        
        }
            
            else
            {
                [self showAlert:[NSString stringWithFormat:@"%@",error.localizedDescription] withTitle:@"Try Again !!"];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
            }
        });
        
    }];
        
        
}


#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse *res=(NSHTTPURLResponse*)response;
    //DLog(@"%@",res);
    
    if ([res statusCode] == 404)
    {
        /// do some stuff
        DLog(@"404 error");
        
    }
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSDictionary *dict = httpResponse.allHeaderFields;
    NSString *lengthString = [dict valueForKey:@"Content-Length"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *length = [formatter numberFromString:lengthString];
    DLog(@"lll :%@",length);
    
    
    
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
   
    hud.progress=(float)_receivedBytes/(float)_totalBytes;
    
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    
   hud.progress=(float)totalBytesWritten/(float)_totalBytes;
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
 
    NSMutableData *returnData=_responseData;
    
    NSMutableDictionary *temp,*dicTemp;
    if (returnData !=nil)
    {
        NSError *error;
        
        
        temp = [NSJSONSerialization JSONObjectWithData:returnData  options:NSJSONReadingMutableContainers error:&error];
        DLog(@"%@",temp);
        
        if (_isJobEdited==YES) {
             DLog(@"EngineerManagerJobEditCompleteResult ");
            dicTemp=[temp objectForKey:@"EngineerManagerJobEditCompleteResult"];
            
        }
        else
        {
              DLog(@"EngineerManagerJobEditCompleteResult ");
            dicTemp=[temp objectForKey:@"EngineerManagerJobCreateResult"];
            
        }
        
        if (!error)
        {
              DLog(@"Inside No error if ");
            if ([[dicTemp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
            {
                 DLog(@"Success ");
               
                if (_isJobEdited==YES) {
                      DLog(@"job edited ");
                   /* alert=[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"job Updated successfully(Job ID: %@).",[dicTemp valueForKey:@"JobID"]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];*/
                    
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @""
                                                                                        message:[NSString stringWithFormat:@"job Updated successfully(Job ID: %@).",[dicTemp valueForKey:@"JobID"]]
                                                                                 preferredStyle: UIAlertControllerStyleAlert];
                    
                    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                                          style: UIAlertActionStyleDestructive
                                                                        handler: ^(UIAlertAction *action) {
                                                                            [self alertcall112];
                                                                            
                                                                        }];
                    
                    [controller addAction: alertAction];
                    
                    [self presentViewController: controller animated: YES completion: nil];
                    
                }
                else
                {
                   /* alert=[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"New job saved successfully(Job ID: %@).",[dicTemp valueForKey:@"JobID"]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];*/
                      DLog(@"job Saved ");
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @""
                                                                                        message:[NSString stringWithFormat:@"New job saved successfully(Job ID: %@).",[dicTemp valueForKey:@"JobID"]]
                                                                                 preferredStyle: UIAlertControllerStyleAlert];
                    
                    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                                          style: UIAlertActionStyleDestructive
                                                                        handler: ^(UIAlertAction *action) {
                                                                            [self alertcall112];
                                                                        }];
                    
                    [controller addAction: alertAction];
                    
                    [self presentViewController: controller animated: YES completion: nil];
                    
                }
               
                
            }else    {
                 DLog(@"NO SUCCESS ");
                //[dicTemp valueForKey:@"ResponseMessages"]
                
                 DLog(@"This is  value for res msg %@",[dicTemp valueForKey:@"ResponseMessages"]);
                UIAlertController *controller = [UIAlertController alertControllerWithTitle: @""
                                                                                    message:[NSString stringWithFormat:@"%@",[dicTemp valueForKey:@"ResponseMessages"]]
                                                                             preferredStyle: UIAlertControllerStyleAlert];
                
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                                      style: UIAlertActionStyleDestructive
                                                                    handler: ^(UIAlertAction *action) {
                                                                        NSLog(@"Dismiss button tapped!");
                                                                    }];
                
                [controller addAction: alertAction];
                
                [self presentViewController: controller animated: YES completion: nil];
                
               
            }
        }
        else
        {
            DLog(@"JSONObjectWithData error: %@", error);
        }
        
        [hud hide:YES];
        
        
    }
    
    
    NSString *str=[[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
    
    DLog(@"result is %@",str);
    
    
}




- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
   // [[[UIAlertView alloc]initWithTitle:@"Error" message:@"No network connection. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
     [self showAlert:@"No network connection. Please try again later."  withTitle:@"Error"];
}

-(void)alertcall112{
    if (_isJobEdited==YES) {
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[DashBoard class]])
            {
                NSArray *arrM=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrEditedJobDic"];
                NSMutableArray *mutableCopy=[arrM mutableCopy];
                if (mutableCopy==nil) {
                    mutableCopy=[[NSMutableArray alloc]init];
                }
                
                [mutableCopy addObject:[_jobDic valueForKey:@"JobID"]];
                [[NSUserDefaults standardUserDefaults]setObject:mutableCopy forKey:@"arrEditedJobDic"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self.navigationController popToViewController:controller animated:YES];
                
                break;
            }
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


#pragma mark- PostcodeDelegate
-(void)PostCodeAddressSelection:(NSMutableDictionary*)dict{
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (dict) {
        
    
    
    @try {
        
        if (_btnJobAdress.selected) {
           
            [dicJobAddress setValue:[GlobalDirector ReplaceStringNull:[dict valueForKey:@"county"]] forKey:@"County"];
            [dicJobAddress setValue:[GlobalDirector ReplaceStringNull:[dict valueForKey:@"town"]] forKey:@"City"];
            [dicJobAddress setValue:[GlobalDirector ReplaceStringNull:[dict valueForKey:@"postcode"]] forKey:@"PostCode"];
            [dicJobAddress setValue:[GlobalDirector ReplaceStringNull:[dict valueForKey:@"address"]] forKey:@"Address"];
            [dicJobAddress setObject:@"0" forKey:@"CustomerAddressID"]; //new address
            
            NSString *com = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"company"]];
            
            if (com.length>0) {
                
                [dicJobAddress setValue:@"1" forKey:@"TypeofOrganisation"];
                [dicJobAddress setValue:@"Small Organisation" forKey:@"TypeofOrganisationText"];
                [dicJobAddress setValue:com forKey:@"NameofOrganisation"];
                
            }else{
                [dicJobAddress setValue:@"3" forKey:@"TypeofOrganisation"];
                [dicJobAddress setValue:@"Residential" forKey:@"TypeofOrganisationText"];
                [dicJobAddress setValue:@"" forKey:@"NameofOrganisation"];
                
               
            }
            
            //[self btnJobAdressTapped:_btnJobAdress];
            [dicJobAddress setValue:@"1" forKey:@"TypeOfAddress"];
            selectedAddressDic=[dicJobAddress mutableCopy];
           
           // [selectedAddressDic setValue:@"1" forKey:@"TypeOfAddress"];
            
            
             [self FetchAddressDicValue:selectedAddressDic];

        }
        else if (_btnBillingAdress.selected){
            
            [dicBillingAddress setValue:[GlobalDirector ReplaceStringNull:[dict valueForKey:@"county"]] forKey:@"County"];
            [dicBillingAddress setValue:[GlobalDirector ReplaceStringNull:[dict valueForKey:@"town"]] forKey:@"City"];
            [dicBillingAddress setValue:[GlobalDirector ReplaceStringNull:[dict valueForKey:@"postcode"]] forKey:@"PostCode"];
            [dicBillingAddress setValue:[GlobalDirector ReplaceStringNull:[dict valueForKey:@"address"]] forKey:@"Address"];
            [dicBillingAddress setObject:@"0" forKey:@"CustomerAddressID"]; //new address
            
            NSString *com = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"company"]];
            
            if (com.length>0) {
                
                [dicBillingAddress setValue:@"1" forKey:@"TypeofOrganisation"];
                [dicBillingAddress setValue:@"Small Organisation" forKey:@"TypeofOrganisationText"];
                [dicBillingAddress setValue:com forKey:@"NameofOrganisation"];
                
            }else{
               
                
                [dicBillingAddress setValue:@"3" forKey:@"TypeofOrganisation"];
                [dicBillingAddress setValue:@"Residential" forKey:@"TypeofOrganisationText"];
                [dicBillingAddress setValue:@"" forKey:@"NameofOrganisation"];
                
                
            }
            
           [dicBillingAddress setValue:@"2" forKey:@"TypeOfAddress"];
            selectedAddressDic=[dicBillingAddress mutableCopy];
            
            [self btnBillingAdressTapped:_btnBillingAdress];

        }
        else if (_btnLandlordAdress.selected){
            
            
            
            [dicLandLordAdress setValue:[GlobalDirector ReplaceStringNull:[dict valueForKey:@"county"]] forKey:@"County"];
            [dicLandLordAdress setValue:[GlobalDirector ReplaceStringNull:[dict valueForKey:@"town"]] forKey:@"City"];
            [dicLandLordAdress setValue:[GlobalDirector ReplaceStringNull:[dict valueForKey:@"postcode"]] forKey:@"PostCode"];
            [dicLandLordAdress setValue:[GlobalDirector ReplaceStringNull:[dict valueForKey:@"address"]] forKey:@"Address"];
            [dicLandLordAdress setObject:@"0" forKey:@"CustomerAddressID"]; //new address
            
            NSString *com = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"company"]];
            
            if (com.length>0) {
                
                [dicLandLordAdress setValue:@"1" forKey:@"TypeofOrganisation"];
                [dicLandLordAdress setValue:@"Small Organisation" forKey:@"TypeofOrganisationText"];
                [dicLandLordAdress setValue:com forKey:@"NameofOrganisation"];
                
            }else{
                
                [dicLandLordAdress setValue:@"3" forKey:@"TypeofOrganisation"];
                [dicLandLordAdress setValue:@"Residential" forKey:@"TypeofOrganisationText"];
                [dicLandLordAdress setValue:@"" forKey:@"NameofOrganisation"];

            }
             [dicLandLordAdress setValue:@"3" forKey:@"TypeOfAddress"];
             selectedAddressDic=[dicLandLordAdress mutableCopy];
            [self btnLandlordAdressTapped:_btnLandlordAdress];
            
        }
        
       
        
        
        
    } @catch (NSException *exception) {
        ;
    }
    }else{
       
    }
    
}


#pragma mark- Address selection
-(void)AddressSelection:(NSMutableDictionary*)dict{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if (dict) {
        @try {
            
            
            [dicJobAddress setValue:[GlobalDirector ReplaceStringNull:[dict valueForKey:@"County"]] forKey:@"County"];
            [dicJobAddress setValue:[GlobalDirector ReplaceStringNull:[dict valueForKey:@"Town"]] forKey:@"City"];
            [dicJobAddress setValue:[GlobalDirector ReplaceStringNull:[dict valueForKey:@"Postcode"]] forKey:@"PostCode"];
            [dicJobAddress setValue:[GlobalDirector ReplaceStringNull:[dict valueForKey:@"AddressLine1"]] forKey:@"Address"];
            [dicJobAddress setObject:[GlobalDirector ReplaceStringNull:[dict valueForKey:@"CustomerAddressID"]] forKey:@"CustomerAddressID"]; //new address
            
            NSString *com = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"OrganisationName"]];
            int  orgID = [[GlobalDirector ReplaceStringNull:[dict valueForKey:@"OrganisationTypeId"]] intValue];
            
            if (orgID == 2)
            {
                [dicJobAddress setValue:@"2" forKey:@"TypeofOrganisation"];
                [dicJobAddress setValue:@"Large Organisation" forKey:@"TypeofOrganisationText"];
                
            }else if (orgID == 3)
            {
                [dicJobAddress setValue:@"3" forKey:@"TypeofOrganisation"];
                [dicJobAddress setValue:@"Residential" forKey:@"TypeofOrganisationText"];
                
                
            }else{
                
                [dicJobAddress setValue:@"1" forKey:@"TypeofOrganisation"];
                [dicJobAddress setValue:@"Small Organisation" forKey:@"TypeofOrganisationText"];
                
            }
            
            if (com.length>0) {
                
                [dicJobAddress setValue:com forKey:@"NameofOrganisation"];
            }
            
            
            selectedAddressDic=[dicJobAddress mutableCopy];
           
            [selectedAddressDic setValue:@"1" forKey:@"TypeOfAddress"];
             [dicJobAddress setValue:@"1" forKey:@"TypeOfAddress"];
            
             [self FetchAddressDicValue:selectedAddressDic];
            
            
            
        } @catch (NSException *exception) {
            ;
        }
        
    }else{
        
        [self showAlert:@"No previous address to show." withTitle:@"Error"];
    }              
    
    
    
}





#pragma mark- note selection after complete

- (IBAction)Complete:(UIButton *)sender {
    
    if (_txtNoteDesComplete.text.length>0 || _segNote.selectedSegmentIndex==2 ) {
        [_txtNoteDesComplete resignFirstResponder];
        
        NSString *strComp = @"";
        
       
        if (_segNote.selectedSegmentIndex==0) {
           strComp=@"Further work";
        }else if (_segNote.selectedSegmentIndex==1){
           strComp=@"Attention needed";
        }
        
        
        if (strComp.length>0) {
            strComp = [NSString stringWithFormat:@"Completed-%@",strComp];
            _txtJobStatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobStatus.placeholder,strComp];
        }else{
            _txtJobStatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobStatus.placeholder,@"Completed"];
        }

        
         [KLCPopup dismissAllPopups];
        
        
    }else{
        
        _txtNoteDesComplete.layer.cornerRadius=8.0f;
        _txtNoteDesComplete.layer.masksToBounds=YES;
        _txtNoteDesComplete.layer.borderColor=[[UIColor redColor]CGColor];
        _txtNoteDesComplete.layer.borderWidth= 1.0f;
    
    }
    
}



- (IBAction)Cancel:(UIButton *)sender {
    
   //  [KLCPopup dismissAllPopups];
    _txtNoteDesComplete.text=@"";
    _segNote.enabled=YES;
}



-(void)ShowPopupComplete{
    
    _txtNoteDesComplete.layer.borderColor=[[UIColor clearColor]CGColor];
    _segNote.selectedSegmentIndex=2;
    _txtNoteDesComplete.tag=0;
    _txtNoteDesComplete.text=@"";
   // _txtNoteDesComplete.editable=YES;
      _txtNoteDesComplete.editable=NO;
    [_txtNoteDesComplete becomeFirstResponder];
    _segNote.enabled=NO;
    
    KLCPopup *pop=    [KLCPopup popupWithContentView:_viewNotePopup showType:KLCPopupShowTypeGrowIn dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    
    
    [pop show];
    
}



-(void)ShowPopupCancelNote{
     _txtVCancelNote.text=@"";
    _txtVCancelNote.layer.borderColor=[[UIColor clearColor]CGColor];
   [_txtVCancelNote becomeFirstResponder];
   
    
    KLCPopup *pop=    [KLCPopup popupWithContentView:_viewCancelNote showType:KLCPopupShowTypeGrowIn dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    
    
    [pop show];
    
}





- (IBAction)SegmentClick:(UISegmentedControl *)sender {
    
    sender.enabled=NO;
    
    if (sender.selectedSegmentIndex != _txtNoteDesComplete.tag) {
        _txtNoteDesComplete.text=@"";
        _txtNoteDesComplete.tag = sender.selectedSegmentIndex;
        
        if (sender.selectedSegmentIndex==2) {
            [_txtNoteDesComplete resignFirstResponder];
            _txtNoteDesComplete.editable=NO;
        }else{
          _txtNoteDesComplete.editable=YES;
             [_txtNoteDesComplete becomeFirstResponder];
        }
    }
    
}



- (IBAction)SaveCancelNote:(UIButton *)sender {
    
    if (_txtVCancelNote.text.length>0 ) {
        [_txtNoteDesComplete resignFirstResponder];
        
        _txtJobStatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobStatus.placeholder,@"Job Cancelled"];
        [KLCPopup dismissAllPopups];
        
        
    }else{
        
        _txtVCancelNote.layer.cornerRadius=8.0f;
        _txtVCancelNote.layer.masksToBounds=YES;
        _txtVCancelNote.layer.borderColor=[[UIColor redColor]CGColor];
        _txtVCancelNote.layer.borderWidth= 1.0f;
        
    }
    
}


@end


































