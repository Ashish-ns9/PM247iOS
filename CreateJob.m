//
//  CreateJob.m
//  Partner Maintenance
//


#import "CreateJob.h"

@interface CreateJob ()

{
    AddNotes *addNote;
    
}

@end


@implementation CreateJob
@synthesize btnSlideMenu;
@synthesize managedObjectContext;

#pragma mark - Additional Notes Add Method
- (IBAction)addJobNoteTapped:(id)sender
{
    
        addNote=[[AddNotes alloc]initWithNibName:@"AddNotes" bundle:nil];
        addNote.delegate=self;
    if (arrCustomeradditionalNotes!=nil)
    {
       // addNote.Notes=arrCustomeradditionalNotes;
    }
    addNote.strHeading=@"Add Notes";
    addNote.Notes=arrCustomeradditionalNotes;
    addNote.strFromCustomerClass=[NSString stringWithFormat:@"%@",[self class]];
    [self presentViewController:addNote animated:YES completion:nil];
    
}



-(void)addItemViewController:(id)controller didFinishEnteringItem:(NSMutableArray *)Notes{
    
    arrCustomeradditionalNotes=Notes;
    [_btnAddJobNote setTitle:[NSString stringWithFormat:@"Add Job Notes %lu",(unsigned long)[Notes count]] forState:UIControlStateNormal];
}



#pragma mark - Submit Press Method
- (IBAction)jobSubmitPress:(id)sender
{

    
    
    
    if ([self ChkAllTextFlds]==YES) {
        
         [self SetupAddressDict];
        if (SelectedUserDic) {
            [self PopulateUserDetailsDic:SelectedUserDic];
        }
        
        
        if (([dicOwnerDetails isKindOfClass:[NSNull class]]||[dicOwnerDetails count]<4) && ([dicLandLordDetails isKindOfClass:[NSNull class]]||[dicLandLordDetails count]<4)) {
            
     
             [self showAlert:@"Please fill customer details under owner or Agent/LL" withTitle:@"Wait"];
            
            
        }
        else if ([dicJobAddress isKindOfClass:[NSNull class]]||[dicJobAddress count]<4)
        {
            [self showAlert:@"Please fill job address details" withTitle:@"Wait"];
            
        }
        else
        {
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
            if (networkStatus == NotReachable) {
                DLog(@"There IS NO internet connection");
                [self showAlert:@"Check your Internet connection"  withTitle:@"Connection Problem!"];
                
            } else {
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



#pragma mark - Cancel Press Method
- (IBAction)jobCancelPress:(id)sender
{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Back Press Method
-(IBAction)backPress:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Validation Check All Fields
-(BOOL)ChkAllTextFlds
{
    int flag=1;
    
    for (id txtfield in [_scrolVw subviews])
    {
        if ([txtfield isKindOfClass:[UITextField class]])
        {
            UITextField *txtfld=(UITextField *)txtfield;
            
            if ([txtfld.text isEqualToString:@""]&&(txtfld!=_txtTypeofOrganization)&&(txtfld!=_txtNameOfOrganisation)&&(txtfld!=_txtEmail)&&(txtfld!=_txtAddrContactNo)&&(txtfld!=_txtPurchOrder)&&(txtfld!=_txtContactNo))
            {
               
                [self ShowErrorAtTextField:txtfld alert:@" *Field Should not be blanked"];
                flag=0;
                
            }
            
        }
        
        if ([txtfield isKindOfClass:[UITextView class]])
        {
            UITextView *txtv=(UITextView *)txtfield;
            
            if ([txtv.text isEqualToString:@""] && txtv !=_txtvwUserNote && txtv !=_txtvRemarks )
            {
                
                [self ShowErrorAtTextField:txtfield alert:@" *Field Should not be blanked"];
                flag=0;
                
            }
        }
    }
    
    if (_btnJobAdress.selected==YES || _btnBillingAdress.selected==YES ) {
        
        if (_txtAddress.text.length==0) {
            [GlobalDirector ShowErrorAtTextView:_txtAddress alert:@" *Field Should not be blanked"];
            flag=0;
        }
    }
    
    
    if (flag==0)
    {
        return NO;
        
    }
    
    return YES;
    
}




-(void)ShowErrorAtTextField:(UITextField *)txtfld alert:(NSString *)alrt
{
    
    for (UILabel *lbl in [txtfld subviews])
    {
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
            
            
             if (textField==_txtTimeAllowance||textField==_txtPaymentMode||textField==_txtNatureOfJob||textField==_txtTitle||textField==_txtTypeOfCustomer||textField==_txtTypeofOrganization|| textField==_txtCountry||textField==_txtCityTown||textField==_txtTypeOfAddress)
            {
                err.center=CGPointMake(CGRectGetWidth(txtfld.frame)-CGRectGetWidth(err.frame)/2.0f-35, CGRectGetHeight(txtfld.frame)/2.0f);
            }
            
            else
            {
                err.center=CGPointMake(CGRectGetWidth(txtfld.frame)-CGRectGetWidth(err.frame)/2.0f-5, CGRectGetHeight(txtfld.frame)/2.0f);
            }
            [txtfld addSubview:err];
            
    
    
}




#pragma mark - ViewDidLoad Method
- (void)viewDidLoad
{
    [super viewDidLoad];
  
    
    
    [self initializeTextFieldInputView];
    self.navigationController.navigationBar.hidden = YES;
    
    SWRevealViewController *revealController = [self revealViewController];
   
    [btnSlideMenu addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:revealController action:@selector(rightRevealToggle:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    UISwipeGestureRecognizer *recognizer1;
    recognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:revealController action:@selector(revealToggle:)];
    [recognizer1 setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [_btnAddJobNote.layer setBorderColor: [[UIColor clearColor] CGColor]];
    [_btnAddJobNote.layer setBorderWidth: 0.5];
    [_btnAddJobNote.layer setCornerRadius:0.0f];
    [_btnAddJobNote.layer setMasksToBounds:YES];
     _btnAddJobNote.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:16.0];
    
    [_txtvJobDescription.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_txtvJobDescription.layer setBorderWidth: 0.5];
    [_txtvJobDescription.layer setCornerRadius:0.0f];
    [_txtvJobDescription.layer setMasksToBounds:YES];
    
    [_txtvwUserNote.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_txtvwUserNote.layer setBorderWidth: 0.5];
    [_txtvwUserNote.layer setCornerRadius:0.0f];
    [_txtvwUserNote.layer setMasksToBounds:YES];
    
    [_txtvRemarks.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_txtvRemarks.layer setBorderWidth: 0.5];
    [_txtvRemarks.layer setCornerRadius:0.0f];
    [_txtvRemarks.layer setMasksToBounds:YES];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [_scrolVw addGestureRecognizer:singleTap];
    singleTap.delegate=self;
    
    
    
    for (UITextField *txtfield in [_scrolVw subviews])
    {
        if ([txtfield isKindOfClass:[UITextField class]])
        {
            UITextField *txtfld=(UITextField *)txtfield;
            [txtfld setBorderStyle:UITextBorderStyleNone];
            txtfld.layer.borderWidth=0.5f;
            txtfld.layer.borderColor=[[UIColor lightGrayColor]CGColor];
            txtfld.layer.cornerRadius=0.0f;
            
            if (txtfld==_txtRecreatedFromInvoice)
            {
                txtfld.backgroundColor=[UIColor lightGrayColor];
            }
            else
            {
                txtfld.backgroundColor=[UIColor whiteColor];
            }
            UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(10,0,10,26)];
            leftView.backgroundColor = [UIColor clearColor];
            txtfld.textColor=[UIColor darkGrayColor];
            txtfld.leftView = leftView;
            txtfld.leftViewMode = UITextFieldViewModeAlways;
            txtfld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [txtfld addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
        }
   
    }
    for (UITextField *txtfield in [_vwAddress subviews])
    {
        if ([txtfield isKindOfClass:[UITextField class]])
        {
            UITextField *txtfld=(UITextField *)txtfield;
            [txtfld setBorderStyle:UITextBorderStyleNone];
            txtfld.layer.borderWidth=0.5f;
            txtfld.layer.borderColor=[[UIColor lightGrayColor]CGColor];
            txtfld.layer.cornerRadius=0.0f;
            txtfld.backgroundColor=[UIColor whiteColor];
        }
        
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
    _txtStartDate.inputAccessoryView = numberToolbar;
    _txtContactNo.inputAccessoryView=numberToolbar;
    
    _txtAddrContactNo.inputAccessoryView=numberToolbar;
    
    
    _btnCancelCreateJob.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:13.0];
    _btnCreateJOb.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:13.0];
    
    [_lblJobDetails.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_lblJobDetails.layer setBorderWidth: 0.5];
    [_lblJobDetails.layer setCornerRadius:0.0f];
    [_lblJobDetails.layer setMasksToBounds:YES];
    
    [_lblCustomerdetails.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_lblCustomerdetails.layer setBorderWidth: 0.5];
    [_lblCustomerdetails.layer setCornerRadius:0.0f];
    [_lblCustomerdetails.layer setMasksToBounds:YES];
    
    [_lblAddressDetails.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_lblAddressDetails.layer setBorderWidth: 0.5];
    [_lblAddressDetails.layer setCornerRadius:0.0f];
    [_lblAddressDetails.layer setMasksToBounds:YES];
    
    [_lblRemarks.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_lblRemarks.layer setBorderWidth: 0.5];
    [_lblRemarks.layer setCornerRadius:0.0f];
    [_lblRemarks.layer setMasksToBounds:YES];
    
    [_lblRemarks1.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_lblRemarks1.layer setBorderWidth: 0.5];
    [_lblRemarks1.layer setCornerRadius:0.0f];
    [_lblRemarks1.layer setMasksToBounds:YES];
    
    
    [_lblJobDescription.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_lblJobDescription.layer setBorderWidth: 0.5];
    [_lblJobDescription.layer setCornerRadius:0.0f];
    [_lblJobDescription.layer setMasksToBounds:YES];
        
    
    [_lblJobDetails setFont:[UIFont fontWithName:@"TheSansArabic-Bold" size:14.0]];
    [_lblCustomerdetails setFont:[UIFont fontWithName:@"TheSansArabic-Bold" size:14.0]];
    [_lblAddressDetails setFont:[UIFont fontWithName:@"TheSansArabic-Bold" size:14.0]];
    [_lblRemarks setFont:[UIFont fontWithName:@"TheSansArabic-Bold" size:14.0]];
    [_lblRemarks1 setFont:[UIFont fontWithName:@"TheSansArabic-Bold" size:14.0]];
    [_lblJobDescription setFont:[UIFont fontWithName:@"TheSansArabic-Bold" size:14.0]];
    
    //--- contact saved------
    arrMSavedContactNumber=[[NSMutableArray alloc] init];
    
    dicOwnerDetails=[[NSMutableDictionary alloc]init];
    dicTenantDetails=[[NSMutableDictionary alloc]init];
    dicLandLordDetails=[[NSMutableDictionary alloc]init];
    dicBillingAddress=[[NSMutableDictionary alloc]init];
    dicJobAddress=[[NSMutableDictionary alloc]init];
    dicLandLordAdress=[[NSMutableDictionary alloc]init];
    
    //Set default org type
    [dicJobAddress setValue:@"3" forKey:@"TypeofOrganisation"];
    [dicJobAddress setValue:@"Residential" forKey:@"TypeofOrganisationText"];
    
    [dicBillingAddress setValue:@"3" forKey:@"TypeofOrganisation"];
    [dicBillingAddress setValue:@"Residential" forKey:@"TypeofOrganisationText"];
    
    [dicLandLordAdress setValue:@"3" forKey:@"TypeofOrganisation"];
    [dicLandLordAdress setValue:@"Residential" forKey:@"TypeofOrganisationText"];

   
    
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];//UserID
    NSInteger ID = [[userdetails valueForKey:@"StaffID"] intValue];
    
    [self FetchCustomerDetails:ID];
    
    
    
    
//    
//    NSString *Count = @"data";
//    
//    [[NSUserDefaults standardUserDefaults] setObject:Count forKey:@"StringCount"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
}



-(void)FetchCustomerDetails:(NSInteger)CustomerId
{
    
    
    NSString *post =[NSString stringWithFormat:@""];
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];//UserID
    
    
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
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *returnData, NSURLResponse *response, NSError *error){
        
        DLog(@"PostString=%@",urlString);
      
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (error==nil) {
                NSMutableDictionary* temp;
                if (returnData !=nil)
                {
                    NSError *error1;
                    
                    
                    temp = [NSJSONSerialization JSONObjectWithData:returnData  options:NSJSONReadingMutableContainers error:&error1];
                    if (!error1)
                    {
                        
                        
                        if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"]) {
                            
                           
                            ///from here to find customer details.
                            
                            [self prePopulateUserDetailsDic:temp];
                            
                            
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
                            // [self btnJobAdressTapped:_btnJobAdress];
                            
                            //****
                            _txtAdvertiseChannel.tag=[[GlobalDirector ReplaceStringNull:[temp valueForKey:@"DefaultAdvertisingChannelID"]] integerValue];
                             _txtAdvertiseChannel.text=[GlobalDirector ReplaceStringNull:[temp valueForKey:@"DefaultAdvertisingChannel"]];
                            
                            
                            [self btnBillingAdressTapped:_btnBillingAdress];
                            
                            NSLog(@"temp :%@",temp);
                            NSString *str=[NSString stringWithFormat:@"%@",[temp valueForKey:@"Mobile"]];
                            NSLog(@"str :%@",str);
                            
                            if ([GlobalDirector ReplaceStringNull:str].length>0) {
                                [arrMSavedContactNumber addObject:str];
                            }
                            
                           
                            
                            
                            
                        }
                        
                        else {
                            DLog(@"JSONObjectWithData error: %@", error1);
                            
                            
                        }
                        
                        
                        
                        
                    }
                    
                }
                
                
                
            }
            else
            {
                [self showAlert:@"There are some problem right now, try again later " withTitle:@"Sorry!"];
                
                
            }
            
        });
        
    }];
    
    
    
   
    
}


-(void)PopulateUserDetailsDic:(NSDictionary *)Dic{
    
    NSMutableDictionary *userdetails=[Dic mutableCopy];
    
   
    
    
    
    if ([[userdetails valueForKey:@"TypeofCustomer"]integerValue]==1) {
        [dicOwnerDetails setValue:[userdetails valueForKey:@"FirstName"] forKey:@"FirstName"];
        [dicOwnerDetails setValue:[userdetails valueForKey:@"LastName"] forKey:@"LastName"];
        
        
        [dicOwnerDetails setValue:[userdetails valueForKey:@"TitleText"] forKey:@"TitleText"];
        [dicOwnerDetails setValue:[userdetails valueForKey:@"Title"] forKey:@"Title"];
        
        [dicOwnerDetails setValue:[userdetails valueForKey:@"TypeofCustomer"] forKey:@"TypeofCustomer"];
        [dicOwnerDetails setValue:[userdetails valueForKey:@"EmailAddress"] forKey:@"EmailAddress"];
        
        
        
        if ([userdetails valueForKey:@"Mobile"]) {
            [dicOwnerDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"ContactNumber"];
            [dicOwnerDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"Mobile"];
        }else if ([userdetails valueForKey:@"ContactNumber"]){
            [dicOwnerDetails setValue:[userdetails valueForKey:@"ContactNumber"] forKey:@"ContactNumber"];
            [dicOwnerDetails setValue:[userdetails valueForKey:@"ContactNumber"] forKey:@"Mobile"];
        }
        
        [dicOwnerDetails setValue:[userdetails valueForKey:@"Notes"] forKey:@"Notes"];
        
        if([userdetails valueForKey:@"CustID"]) {
            [dicOwnerDetails setValue:[userdetails valueForKey:@"CustID"] forKey:@"CustID"];
        }else{
            [dicOwnerDetails setValue:@"0" forKey:@"CustID"];
        }
        
    }
    else if ([[userdetails valueForKey:@"TypeofCustomer"]integerValue]==2){
        [dicTenantDetails setValue:[userdetails valueForKey:@"FirstName"] forKey:@"FirstName"];
        [dicTenantDetails setValue:[userdetails valueForKey:@"LastName"] forKey:@"LastName"];
        
        
        [dicTenantDetails setValue:[userdetails valueForKey:@"TitleText"] forKey:@"TitleText"];
        [dicTenantDetails setValue:[userdetails valueForKey:@"Title"] forKey:@"Title"];

        
        [dicTenantDetails setValue:[userdetails valueForKey:@"TypeofCustomer"] forKey:@"TypeofCustomer"];
        [dicTenantDetails setValue:[userdetails valueForKey:@"EmailAddress"] forKey:@"EmailAddress"];
        
        if ([userdetails valueForKey:@"Mobile"]) {
            [dicTenantDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"ContactNumber"];
            [dicTenantDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"Mobile"];
        }else if ([userdetails valueForKey:@"ContactNumber"]){
            [dicTenantDetails setValue:[userdetails valueForKey:@"ContactNumber"] forKey:@"ContactNumber"];
            [dicTenantDetails setValue:[userdetails valueForKey:@"ContactNumber"] forKey:@"Mobile"];
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
        
        
        [dicLandLordDetails setValue:[userdetails valueForKey:@"TitleText"] forKey:@"TitleText"];
        [dicLandLordDetails setValue:[userdetails valueForKey:@"Title"] forKey:@"Title"];

        
        [dicLandLordDetails setValue:[userdetails valueForKey:@"TypeofCustomer"] forKey:@"TypeofCustomer"];
        [dicLandLordDetails setValue:[userdetails valueForKey:@"EmailAddress"] forKey:@"EmailAddress"];
        
        if ([userdetails valueForKey:@"Mobile"]) {
            [dicLandLordDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"ContactNumber"];
            [dicLandLordDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"Mobile"];
        }else if ([userdetails valueForKey:@"ContactNumber"]){
            [dicLandLordDetails setValue:[userdetails valueForKey:@"ContactNumber"] forKey:@"ContactNumber"];
            [dicLandLordDetails setValue:[userdetails valueForKey:@"ContactNumber"] forKey:@"Mobile"];
        }
        
        [dicLandLordDetails setValue:[userdetails valueForKey:@"Notes"] forKey:@"Notes"];
        
        if([userdetails valueForKey:@"CustID"]) {
            [dicLandLordDetails setValue:[userdetails valueForKey:@"CustID"] forKey:@"CustID"];
        }else{
            [dicLandLordDetails setValue:@"0" forKey:@"CustID"];
        }
        
    }
}


-(void)prePopulateUserDetailsDic:(NSDictionary *)DictCust{
    
  
  
    NSDictionary *userdetails= DictCust;
    
    
    if ([[userdetails valueForKey:@"TypeofCustomer"]integerValue]==1) {
        
        [dicOwnerDetails setValue:[userdetails valueForKey:@"FirstName"] forKey:@"FirstName"];
        [dicOwnerDetails setValue:[userdetails valueForKey:@"LastName"] forKey:@"LastName"];
        
        
        [dicOwnerDetails setValue:[userdetails valueForKey:@"Title"] forKey:@"TitleText"];
        [dicOwnerDetails setValue:[userdetails valueForKey:@"TitleID"] forKey:@"Title"];
        
        [dicOwnerDetails setValue:[userdetails valueForKey:@"EmailAddress"] forKey:@"EmailAddress"];
        [dicOwnerDetails setValue:[userdetails valueForKey:@"PhoneNumber"] forKey:@"ContactNumber"];
        [dicOwnerDetails setValue:[userdetails valueForKey:@"Notes"] forKey:@"Notes"];
        [dicOwnerDetails setValue:[userdetails valueForKey:@"TypeofCustomer"] forKey:@"TypeofCustomer"];
        
        if ([userdetails valueForKey:@"Mobile"]) {
            [dicOwnerDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"ContactNumber"];
            [dicOwnerDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"Mobile"];
        }else if ([userdetails valueForKey:@"ContactNumber"]){
            [dicOwnerDetails setValue:[userdetails valueForKey:@"ContactNumber"] forKey:@"ContactNumber"];
            [dicOwnerDetails setValue:[userdetails valueForKey:@"ContactNumber"] forKey:@"Mobile"];
        }
// [dicOwnerDetails setValue:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"CustID"]] forKey:@"CustID"];
        
        if([userdetails valueForKey:@"CustID"]) {
            [dicOwnerDetails setValue:[userdetails valueForKey:@"CustID"] forKey:@"CustID"];
        }else{
            [dicOwnerDetails setValue:@"0" forKey:@"CustID"];
        }
        
    }else if ([[userdetails valueForKey:@"TypeofCustomer"]integerValue]==2){
        
        [dicTenantDetails setValue:[userdetails valueForKey:@"FirstName"] forKey:@"FirstName"];
        [dicTenantDetails setValue:[userdetails valueForKey:@"LastName"] forKey:@"LastName"];
        
        [dicTenantDetails setValue:[userdetails valueForKey:@"Title"] forKey:@"TitleText"];
        [dicTenantDetails setValue:[userdetails valueForKey:@"TitleID"] forKey:@"Title"];
        [dicTenantDetails setValue:[userdetails valueForKey:@"EmailAddress"] forKey:@"EmailAddress"];
        [dicTenantDetails setValue:[userdetails valueForKey:@"PhoneNumber"] forKey:@"ContactNumber"];
        [dicTenantDetails setValue:[userdetails valueForKey:@"Notes"] forKey:@"Notes"];
        [dicTenantDetails setValue:[userdetails valueForKey:@"TypeofCustomer"] forKey:@"TypeofCustomer"];
        
        if ([userdetails valueForKey:@"Mobile"]) {
            [dicTenantDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"ContactNumber"];
            [dicTenantDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"Mobile"];
        }else if ([userdetails valueForKey:@"ContactNumber"]){
            [dicTenantDetails setValue:[userdetails valueForKey:@"ContactNumber"] forKey:@"ContactNumber"];
            [dicTenantDetails setValue:[userdetails valueForKey:@"ContactNumber"] forKey:@"Mobile"];
        }
// [dicTenantDetails setValue:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"CustID"]] forKey:@"CustID"];
        if([userdetails valueForKey:@"CustID"]) {
            [dicTenantDetails setValue:[userdetails valueForKey:@"CustID"] forKey:@"CustID"];
        }else{
            [dicTenantDetails setValue:@"0" forKey:@"CustID"];
        }
    }else if ([[userdetails valueForKey:@"TypeofCustomer"]integerValue]==3 || [[userdetails valueForKey:@"TypeofCustomer"]integerValue]==4){
        
        [dicLandLordDetails setValue:[userdetails valueForKey:@"FirstName"] forKey:@"FirstName"];
        [dicLandLordDetails setValue:[userdetails valueForKey:@"LastName"] forKey:@"LastName"];
        
        [dicLandLordDetails setValue:[userdetails valueForKey:@"Title"] forKey:@"TitleText"];
        [dicLandLordDetails setValue:[userdetails valueForKey:@"TitleID"] forKey:@"Title"];
        [dicLandLordDetails setValue:[userdetails valueForKey:@"EmailAddress"] forKey:@"EmailAddress"];
        [dicLandLordDetails setValue:[userdetails valueForKey:@"PhoneNumber"] forKey:@"ContactNumber"];
        [dicLandLordDetails setValue:[userdetails valueForKey:@"Notes"] forKey:@"Notes"];
        [dicLandLordDetails setValue:[userdetails valueForKey:@"TypeofCustomer"] forKey:@"TypeofCustomer"];
        
        if ([userdetails valueForKey:@"Mobile"]) {
            [dicLandLordDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"ContactNumber"];
            [dicLandLordDetails setValue:[userdetails valueForKey:@"Mobile"] forKey:@"Mobile"];
        }else if ([userdetails valueForKey:@"ContactNumber"]){
            [dicLandLordDetails setValue:[userdetails valueForKey:@"ContactNumber"] forKey:@"ContactNumber"];
            [dicLandLordDetails setValue:[userdetails valueForKey:@"ContactNumber"] forKey:@"Mobile"];
        }
// [dicLandLordDetails setValue:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"CustID"]] forKey:@"CustID"];
        
        if([userdetails valueForKey:@"CustID"]) {
            [dicLandLordDetails setValue:[userdetails valueForKey:@"CustID"] forKey:@"CustID"];
        }else{
            [dicLandLordDetails setValue:@"0" forKey:@"CustID"];
        }
        
    }
    
    //  1 Owner
    //  2 Tenant
    //  3 Landlord
    //  4 Managing Agent
    

    
    NSString *add = [GlobalDirector ReplaceStringNull:[DictCust valueForKey:@"AddressLine1"]];
    NSString *add1 = [GlobalDirector ReplaceStringNull:[DictCust valueForKey:@"AddressLine2"]];
    NSString *add2 = [GlobalDirector ReplaceStringNull:[DictCust valueForKey:@"AddressLine3"]];
    
    
    
    
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
    
    [dicBillingAddress setValue:[DictCust valueForKey:@"County"] forKey:@"County"];
    [dicBillingAddress setValue:[DictCust valueForKey:@"Town"] forKey:@"City"];
    [dicBillingAddress setValue:[DictCust valueForKey:@"Postcode"] forKey:@"PostCode"];
    [dicBillingAddress setValue:[DictCust valueForKey:@"PhoneNumber"] forKey:@"ContactNo"];
    [dicBillingAddress setValue:[DictCust valueForKey:@"Notes"] forKey:@"Remarks"];
    [dicBillingAddress setValue:@"2" forKey:@"TypeOfAddress"];
    
    
    
    int type = [[DictCust valueForKey:@"TypeofOrganisation"]intValue];
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
        
        
        [dicBillingAddress setValue:typeOfOrganisation forKey:@"TypeofOrganisationText"];
        [dicBillingAddress setValue:value forKey:@"TypeofOrganisation"];
        [dicBillingAddress setValue:[GlobalDirector ReplaceStringNull:[DictCust valueForKey:@"NameofOrganisation"]] forKey:@"NameofOrganisation"];
        
    }
   selectedAddressDic = [dicBillingAddress mutableCopy];
         
}


-(void)cancel{
    UITextField *txtfld=(UITextField *)actvtextbox;
    
    
    [txtfld resignFirstResponder];
    //numberTextField.text = @"";
}

-(void)Next{
    UITextField *txtfld=(UITextField *)actvtextbox;
    if (txtfld==_txtStartDate) {
        txtfld=_txtTimeAllowance;
        
    }
    else if (txtfld==_txtContactNo)
    {
        txtfld=_txtEmail;
       
        
    }
    else if (txtfld==_txtzipCode)
    {
        [_txtvRemarks becomeFirstResponder];
        
        
        
    }
 [txtfld becomeFirstResponder];
 
}





#pragma mark Date Picker View
- (void) initializeTextFieldInputView
{
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.minuteInterval = 5;
    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker addTarget:self action:@selector(dateUpdated:) forControlEvents:UIControlEventValueChanged];
   
    _txtStartDate.inputView = datePicker;
}

- (void) dateUpdated:(UIDatePicker *)datePicker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     [formatter setDateFormat:@"dd/MM/yyyy"];
    
    _txtStartDate.text =[formatter stringFromDate:datePicker.date];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TEXTFIELD DELEGATES
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range
replacementString: (NSString*) string
{
    
    if (textField == _txtPurchOrder)
    {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= 20 || returnKey;
        
    }
    
    if (textField == _txtContactNo||textField==_txtAddrContactNo)
    {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range
                                                                 withString: string];
        if (text.length<=13) {
            
            if (text.length == 5&&![string isEqualToString:@""]) { //or probably better, check if int
                textField.text = [NSString stringWithFormat: @"%@  ", text];
                return NO;
            }
            
        }
        else
        {
            return NO;
            
        }
        
        
    }
    
    return YES;
}






- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    actvtextbox=textField;
    if (textField ==_txtNameOfOrganisation) {
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

    
    
    int pos=10;
    if (textField.frame.origin.y>100) {
        pos=100;
    }
    
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y-pos);
    [_scrolVw setContentOffset:scrollPoint animated:YES];
    
    if (textField == _txtStartDate)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        
        _txtStartDate.text=[formatter stringFromDate:[NSDate date]];
    }
   
    if (textField==_txtTimeAllowance||textField==_txtPaymentMode||textField==_txtNatureOfJob||textField==_txtTitle||textField==_txtTypeOfCustomer||textField==_txtTypeofOrganization||textField==_txtTypeOfAddress || textField == _txtAdvertiseChannel)
    {
    
        Activetxtfld=textField;
        for (UILabel *lbl in [textField subviews]) {
            if (lbl.tag==999) {
                
                [lbl removeFromSuperview];
         
            }
        }
        
        [self.view endEditing:YES];
        [self popupList];
        
        return NO;
    
    }
    else if (textField==_txtContactNo||textField==_txtAddrContactNo)
    {
        if (isContactsave==YES)
        {
            
        //
            
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
                                                                               
                                                                               if (textField==_txtContactNo)
                                                                               {
                                                                                   _txtContactNo.text=[GlobalDirector ReplaceStringNull:[arrMSavedContactNumber objectAtIndex:0]];
                                                                                   
                                                                                   [SelectedUserDic setValue:[GlobalDirector ReplaceStringNull:_txtContactNo.text] forKey:@"ContactNumber"];
                                                                               }
                                                                               else if (textField==_txtAddrContactNo)
                                                                               {
                                                                                   _txtAddrContactNo.text=[GlobalDirector ReplaceStringNull:[arrMSavedContactNumber objectAtIndex:0]];
                                                                                   
                                                                                   [selectedAddressDic setValue:[GlobalDirector ReplaceStringNull:_txtAddrContactNo.text] forKey:@"ContactNo"];
                                                                               }
                                                                               
                                                                               
                                                                           }];
                
                
                [controller addAction: NewContactNumber];
                [controller addAction: ExistContactNumber];
                [self presentViewController: controller animated: YES completion: nil];
            }
            
        }
        
    }else if (textField==_txtzipCode){
        
        
        PostCodePopupController *post = [[PostCodePopupController alloc] initWithNibName:@"PostCodePopupController" bundle:nil];
        post.delegate=self;
        post.txtDelegate=_txtzipCode;
        [self presentViewController:post animated:YES completion:nil];
        
        
        
        return NO;

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
    actvtextbox=textField;
    
    return YES;
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    isContactsave=NO;
    [textField resignFirstResponder];
   
    if (textField==_txtStartDate) {
        [datepicker removeFromSuperview];
        datepicker=nil;
    }
    
    else if (textField==_txtFirstName)
    {
        [_txtLastName becomeFirstResponder];
        [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",_txtFirstName.text] forKey:@"FirstName"];
        
        
    }
    else if (textField==_txtLastName)
    {
        [_txtContactNo becomeFirstResponder];
         [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",_txtLastName.text] forKey:@"LastName"];
        
    }
    else if (textField==_txtTypeOfAddress)
    {
        [_txtNatureOfJob becomeFirstResponder];
        
    }
    
    else if (textField==_txtNameOfOrganisation)
    {
        [_txtAddress becomeFirstResponder];
        
    }else if (textField==_txtContactPerson)
    {
        [_txtCountry becomeFirstResponder];
        
    }
    else if (textField==_txtEmail)
    {
        if ([self validateEmailWithString:_txtEmail.text]==NO) {
            
            [self ShowErrorAtTextField:_txtEmail alert:@"*not a valid Email"];

        }
        else
        {
            [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",_txtEmail.text] forKey:@"EmailAddress"];
        }
        
    }

    
    else if(textField==_txtTitle)
    {
        
        [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",_txtTitle.text] forKey:@"TitleText"];
        
    }

    else if(textField==_txtContactNo)
    {
        [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",_txtContactNo.text] forKey:@"ContactNumber"];
        
    }
   
    else
    {
        
    }
    return YES;
    
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
   isContactsave=NO;
    
     if (textField==_txtEmail)
     {
        if (![_txtEmail.text isEqualToString:@""])
        {
            if ([self validateEmailWithString:_txtEmail.text]==NO) {
                [self ShowErrorAtTextField:_txtEmail alert:@"*not a valid Email"];
                //[_txtEmailAddress becomeFirstResponder];
            }
            else
            {
                [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",_txtEmail.text] forKey:@"EmailAddress"];
            }
        }
        
        
         
    }
    else if(textField==_txtTitle)
    {
        [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",_txtTitle.text] forKey:@"TitleText"];
    }
    else if(textField==_txtFirstName)
    {
         [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",_txtFirstName.text] forKey:@"FirstName"];
    }
    else if(textField==_txtLastName)
    {
         [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",_txtLastName.text] forKey:@"LastName"];
    }
    else if(textField==_txtContactNo)
    {
        [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",_txtContactNo.text] forKey:@"ContactNumber"];
        if (_txtContactNo.text.length>0) {
             [arrMSavedContactNumber addObject:[GlobalDirector ReplaceStringNull:_txtContactNo.text]];
        }
       
        
    }
    else if(textField==_txtNameOfOrganisation)
    {
        [selectedAddressDic setValue:[NSString stringWithFormat:@"%@",_txtNameOfOrganisation.text] forKey:@"NameofOrganisation"];
    }
    else if(textField==_txtCountry)
    {
        [selectedAddressDic setValue:[NSString stringWithFormat:@"%@",_txtCountry.text] forKey:@"County"];
    }
    else if(textField==_txtCityTown)
    {
        [selectedAddressDic setValue:[NSString stringWithFormat:@"%@",_txtCityTown.text] forKey:@"City"];
    }
    else if(textField==_txtzipCode)
    {
        [selectedAddressDic setValue:[NSString stringWithFormat:@"%@",_txtzipCode.text] forKey:@"PostCode"];
    }
    else if(textField==_txtAddrContactNo)
    {
        [selectedAddressDic setValue:[NSString stringWithFormat:@"%@",_txtAddrContactNo.text] forKey:@"ContactNo"];
        if (_txtAddrContactNo.text.length>0) {
            [arrMSavedContactNumber addObject:[NSString stringWithFormat:@"%@",_txtAddrContactNo.text]];
        }
        
    }
    else
    {
    }
}


- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}



#pragma mark - TEXTVIEW DELEGATES
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    actvtextbox=textView;
    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    
     return textView.text.length + (text.length - range.length) <= 200;
    
}


- (void)textViewDidChange:(UITextView *)textView
{
   
    if (textView==_txtvwUserNote) {
        [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",textView.text] forKey:@"Notes"];
   
    }
    
    if (textView==_txtvRemarks) {
         [selectedAddressDic setValue:[NSString stringWithFormat:@"%@",textView.text] forKey:@"Remarks"];
        
    }
    
    
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    int pos=10;
    if (textView.frame.origin.y>100) {
        pos=100;
    }
    
    CGPoint scrollPoint = CGPointMake(0, textView.frame.origin.y-pos);
    [_scrolVw setContentOffset:scrollPoint animated:YES];

    
    textView.textColor=[UIColor blackColor];
     actvtextbox=textView;
    return YES;
    
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    textView.textColor=[UIColor blackColor];
    actvtextbox=textView;
    
    for (UILabel *lbl in [textView subviews]) {
        if (lbl.tag==999) {
            
            [lbl removeFromSuperview];
            
            
        }
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if(textView ==_txtAddress)
    {
        [selectedAddressDic setValue:[NSString stringWithFormat:@"%@",_txtAddress.text] forKey:@"Address"];
        
    }
   
    
}




#pragma mark gesture recognizer delegates and action methods


-(void)handleTap
{
  
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
    if ([touch.view isDescendantOfView:tblView]||[touch.view isDescendantOfView:_vwCopyJobAddr]||[touch.view isDescendantOfView:_vwAddress]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
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
        [self.scrolVw addSubview:tblView];
        
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
                             DLog(@"Done!");
                         }];
    }
}




#pragma mark - Get DropDown Value Fetch Method
-(NSArray *)GetDataForPoppup:(UITextField *)fld
{
    arrFeedTblPopup=nil;
    if (fld==_txtTimeAllowance){
        [self FetchDataForField:@"GetBookedAgent"];
    }
    else if(fld==_txtRecreatedFromInvoice){
         arrFeedTblPopup=@[@"invoice1"];
    }
    else if(fld==_txtPaymentMode){
         [self FetchDataForField:@"GetPaymentModeList"];
    }
    else if(fld==_txtNatureOfJob){
         [self FetchDataForField:@"GetJobNatureList"];
    }
    else if(fld==_txtTypeOfAddress){
         [self FetchDataForField:@"GetAddressTypeList"];
    }
    else if(fld==_txtTitle){
         [self FetchDataForField:@"GetCustomerTitleList"];
    }
    else if(fld==_txtTypeOfCustomer){
         [self FetchDataForField:@"GetCustomerTypeList"];
    }
    else if(fld==_txtTypeofOrganization){
         arrFeedTblPopup=@[@"Small Organisation",@"Large Organisation",@"Residential"];
    }
    else if(fld==_txtAdvertiseChannel){
         [self FetchDataForField:@"GetAdvertisingChannelList"];
    }
    else{
        
    }
    return arrFeedTblPopup;
}

-(void)FetchDataForField:(NSString *)key{
    [MBProgressHUD showHUDAddedTo:Activetxtfld animated:YES];
    
    [self fetchDropDownForTextField:key didFinishLoading:^(BOOL success , NSArray *arrData){
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            [MBProgressHUD hideAllHUDsForView:Activetxtfld animated:YES];
            arrFeedTblPopup=arrData;
            [tblView reloadData];
            
        });
        
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrFeedTblPopup count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"CELL";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    
    cell.textLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    cell.textLabel.textColor=[UIColor darkGrayColor];
    
    NSDictionary *tempDic=[arrFeedTblPopup objectAtIndex:indexPath.row];
    //DLog(@"%@",arrFeedTblPopup);
    
    
    if (![tempDic isKindOfClass:[NSDictionary class]]) {
        cell.textLabel.text=[arrFeedTblPopup objectAtIndex:indexPath.row];
        
    }
    else
    {
    cell.textLabel.text=[NSString stringWithFormat:@"%@",[tempDic valueForKey:@"DisplayText"]];
    
    }
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
   
    
    NSDictionary *tempDic=[arrFeedTblPopup objectAtIndex:indexPath.row];
    if (![tempDic isKindOfClass:[NSDictionary class]]) {
        Activetxtfld.text=[arrFeedTblPopup objectAtIndex:indexPath.row];
        Activetxtfld.tag=indexPath.row+1;
        
        
    }
    else{
    
      Activetxtfld.text=[NSString stringWithFormat:@"%@",[tempDic valueForKey:@"DisplayText"]];
        Activetxtfld.tag=[[NSString stringWithFormat:@"%@",[tempDic valueForKey:@"Value"]]integerValue];
    }
    
    
    //Activetxtfld.text=[NSString stringWithFormat:@"%@",[arrFeedTblPopup objectAtIndex:indexPath.row]];
    
    if (Activetxtfld==_txtTitle) {
    
     [SelectedUserDic setValue:[NSString stringWithFormat:@"%ld",(long)Activetxtfld.tag] forKey:@"Title"];
        [SelectedUserDic setValue:[NSString stringWithFormat:@"%@",Activetxtfld.text] forKey:@"TitleText"];
        
       
    }
   
    if (Activetxtfld==_txtTypeofOrganization) {
        
        [selectedAddressDic setValue:[NSString stringWithFormat:@"%ld",(long)(indexPath.row+1)] forKey:@"TypeofOrganisation"];
        [selectedAddressDic setValue:[NSString stringWithFormat:@"%@",Activetxtfld.text] forKey:@"TypeofOrganisationText"];
        
    }
    
    [self handleTap];
   
}






#pragma mark - Owner / Landlord /Tanent Button Press
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
}


#pragma mark - Job Address / Billing Address / Landlord Address
- (IBAction)btnJobAdressTapped:(id)sender
{
     [self SetupAddressDict];
    
    _lblAddress.text=@"  Job Address";
   
    
    [self.view endEditing:YES];
    [self ResetFieldsFor:@"Address"];
    _btnJobAdress.selected=YES;
    _btnLandlordAdress.selected=NO;
    _btnBillingAdress.selected=NO;
    selectedAddressDic=[dicJobAddress mutableCopy];
    [self FetchAddressDicValue:dicJobAddress];
    [selectedAddressDic setValue:@"1" forKey:@"TypeOfAddress"];
    //[selectedAddressDic setValue:@"This is a static Note" forKey:@"Remarks"];
    [self animateToActiveButton:sender image:_selected2];
    
    DLog(@"Copy job Address::--%@",dicJobAddress);
    
    if (CGRectGetMinY(_vwAddress.frame)>=CGRectGetMaxY(_vwCopyJobAddr.frame)) {
        [self animateCollapseVwAddress];
    }
    
 _vwCopyJobAddr.hidden=YES;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Address"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionBill = [UIAlertAction actionWithTitle:@"Same as billing address"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                           
                                                          // dicJobAddress = dicBillingAddress;
                                                               dicJobAddress = [[NSMutableDictionary alloc] initWithDictionary:[dicBillingAddress copy]];
                                                          [dicJobAddress setValue:@"1" forKey:@"TypeOfAddress"];
                                                          selectedAddressDic = [dicJobAddress mutableCopy];
                                                           [self FetchAddressDicValue:dicJobAddress];
                                                           
                                                           
                                                       }];
    
    
    
    UIAlertAction *actionPre = [UIAlertAction actionWithTitle:@"Select from list of previous addresses"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                        
                                                    [self performSelector:@selector(ShowAddressPopUp) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
                                                              
                                                          
                                                          
                                                      }];
    
    UIAlertAction *actionNew = [UIAlertAction actionWithTitle:@"add new address"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                         
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
     post.txtDelegate=_txtzipCode;
    [self presentViewController:post animated:YES completion:nil];
}


-(void)ShowAddressPopUp{
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];//UserID
    AddSelPopupController *post = [[AddSelPopupController alloc] initWithNibName:@"AddSelPopupController" bundle:nil];
    post.customerId = [GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"StaffID"]];
    post.delegate=self;
    [self presentViewController:post animated:YES completion:nil];
    
}



- (IBAction)btnBillingAdressTapped:(id)sender
{
   [self SetupAddressDict];
    _lblAddress.text=@"  Billing Address";
   
    
     [self.view endEditing:YES];
    [self ResetFieldsFor:@"Address"];
    
    _btnJobAdress.selected=NO;
    _btnLandlordAdress.selected=NO;
    _btnBillingAdress.selected=YES;
    selectedAddressDic=[dicBillingAddress mutableCopy];
    [self FetchAddressDicValue:dicBillingAddress];
    
    [selectedAddressDic setValue:@"2" forKey:@"TypeOfAddress"];
      //[selectedAddressDic setValue:@"This is a static Note" forKey:@"Remarks"];
    [self animateToActiveButton:sender image:_selected2];
    _vwCopyJobAddr.tag=11;
   
    DLog(@"Copy job Address::--%@",dicBillingAddress);
    
   
    if ([[dicBillingAddress valueForKey:@"copyJobAdrr"]integerValue]==1) {
        
        [_imgvwTickCopyJobAdrr setImage:[UIImage imageNamed:@"check"]];
        [self FetchAddressDicValue:dicJobAddress];
       copyJobAddr=YES;
        
    }
    else if([[dicBillingAddress valueForKey:@"copyJobAdrr"]integerValue]==0)
    {
        [_imgvwTickCopyJobAdrr setImage:[UIImage imageNamed:@"uncheck"]];
        [self FetchAddressDicValue:dicBillingAddress];
       
        copyJobAddr=NO;
    
    }
    else
    {
          [self FetchAddressDicValue:dicBillingAddress];
      
        copyJobAddr=NO;
    }
 
    
    if (CGRectGetMinY(_vwAddress.frame)<=CGRectGetMinY(_vwCopyJobAddr.frame)) {
        [self animateExpandVwAddress];
    }

}

- (IBAction)btnLandlordAdressTapped:(id)sender
{
    [self SetupAddressDict];
    _lblAddress.text=@"  LL Address";
    
    
     [self.view endEditing:YES];
    [self ResetFieldsFor:@"Address"];
    _btnJobAdress.selected=NO;
    _btnLandlordAdress.selected=YES;
    _btnBillingAdress.selected=NO;
    selectedAddressDic=[dicLandLordAdress mutableCopy];
    [selectedAddressDic setValue:@"3" forKey:@"TypeOfAddress"];
    //[selectedAddressDic setValue:@"This is a static Note" forKey:@"Remarks"];
    //[self FetchAddressDicValue:dicLandLordAdress];
    _vwCopyJobAddr.tag=22;
    
    [self animateToActiveButton:sender image:_selected2];
    
    if (CGRectGetMinY(_vwAddress.frame)<=CGRectGetMinY(_vwCopyJobAddr.frame)) {
        [self animateExpandVwAddress];
    }
    
    
    DLog(@"Copy job Address::--%@",dicLandLordAdress);
    
    
    if ([[dicLandLordAdress valueForKey:@"copyJobAdrr"]integerValue]==1) {
        
        [_imgvwTickCopyJobAdrr setImage:[UIImage imageNamed:@"check"]];
         [self FetchAddressDicValue:dicJobAddress];
         copyJobAddr=YES;
        
    }
    else if ([[dicLandLordAdress valueForKey:@"copyJobAdrr"]integerValue]==0)
    {
        [_imgvwTickCopyJobAdrr setImage:[UIImage imageNamed:@"uncheck"]];
          [self FetchAddressDicValue:dicLandLordAdress];
        copyJobAddr=NO;
        
    }
    else
    {
        [self FetchAddressDicValue:dicLandLordAdress];
        copyJobAddr=NO;
    }
  
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



#pragma mark - Copy Smae As Job Address Method
- (IBAction)CopyJobAdress:(UIControl *)sender {
    
     DLog(@"%ld",(long)sender.tag);
     DLog(@"%i",copyJobAddr);
    
    if (copyJobAddr==NO)
    {
        copyJobAddr=YES;
        [_imgvwTickCopyJobAdrr setImage:[UIImage imageNamed:@"check"]];
        
        if (sender.tag==11) {
            
            dicBillingAddress=[NSMutableDictionary dictionaryWithDictionary:dicJobAddress];
            
            [dicBillingAddress setValue:@"1" forKey:@"copyJobAdrr"];
            selectedAddressDic=[dicBillingAddress mutableCopy];
            
            [self FetchAddressDicValue:selectedAddressDic];
            
        }
        else if (sender.tag==22)
        {
            
            dicLandLordAdress=[NSMutableDictionary dictionaryWithDictionary:dicJobAddress];
            [dicLandLordAdress setValue:@"1" forKey:@"copyJobAdrr"];
            selectedAddressDic=[dicLandLordAdress mutableCopy];
            
            [self FetchAddressDicValue:selectedAddressDic];
            
        }
    }
    else
    {
        copyJobAddr=NO;
        if (sender.tag==11) {
          
           [dicBillingAddress setValue:@"0" forKey:@"copyJobAdrr"];
            [dicBillingAddress removeAllObjects];
        }
        else if (sender.tag==22)
        {
         
         [dicLandLordAdress setValue:@"0" forKey:@"copyJobAdrr"];
         [dicLandLordAdress removeAllObjects];
        }
        [self ResetFieldsFor:@"Address"];
        [_imgvwTickCopyJobAdrr setImage:[UIImage imageNamed:@"uncheck"]];
        
    }

}



-(void)FetchUserDicValue:(NSMutableDictionary *)dic
{
    if (![[dic valueForKey:@"FirstName"]isEqualToString:@""]) {
        _txtFirstName.text=[dic valueForKey:@"FirstName"];
         [self cleanTextField:_txtFirstName];
    }
    if (![[dic valueForKey:@"LastName"]isEqualToString:@""]) {
        _txtLastName.text=[dic valueForKey:@"LastName"];
         [self cleanTextField:_txtLastName];
    }
    if (![[dic valueForKey:@"TitleText"]isEqualToString:@""]) {
        _txtTitle.text=[dic valueForKey:@"TitleText"];
       
         [self cleanTextField:_txtTitle];
        
    }
     if (![[dic valueForKey:@"EmailAddress"]isEqualToString:@""]) {
        _txtEmail.text=[dic valueForKey:@"EmailAddress"];
         [self cleanTextField:_txtEmail];
    }
    
    
    
     if (![[dic valueForKey:@"ContactNumber"]isEqualToString:@""]) {
        _txtContactNo.text=[dic valueForKey:@"ContactNumber"];
         
         if ([GlobalDirector ReplaceStringNull:[dic valueForKey:@"ContactNumber"]].length>0) {
              [arrMSavedContactNumber addObject:[GlobalDirector ReplaceStringNull:[dic valueForKey:@"ContactNumber"]]];
         }
        
         [self cleanTextField:_txtContactNo];
    }
    if (![[dic valueForKey:@"Notes"]isEqualToString:@""]) {
        _txtvwUserNote.text=[dic valueForKey:@"Notes"];
         [GlobalDirector cleanTextView:_txtvwUserNote];
    }

}


-(void)FetchAddressDicValue:(NSMutableDictionary *)dic
{
  
    if (![[dic valueForKey:@"NameofOrganisation"]isEqualToString:@""]) {
        _txtNameOfOrganisation.text=[dic valueForKey:@"NameofOrganisation"];
    }
    
    
    if (![[dic valueForKey:@"Address"]isEqualToString:@""]) {
        _txtAddress.text=[dic valueForKey:@"Address"];
        [GlobalDirector cleanTextView:_txtAddress];
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
        _txtzipCode.text=[dic valueForKey:@"PostCode"];
        [self cleanTextField:_txtzipCode];
        
    }
    
    
    
    
    if (![[dic valueForKey:@"ContactNo"]isEqualToString:@""]) {
        _txtAddrContactNo.text=[dic valueForKey:@"ContactNo"];
    }
    
    if (![[dic valueForKey:@"TypeofOrganisation"]isEqualToString:@""]) {
        _txtTypeofOrganization.text=[dic valueForKey:@"TypeofOrganisationText"];
    }
    if (![[dic valueForKey:@"Remarks"]isEqualToString:@""]) {
        _txtvRemarks.text=[dic valueForKey:@"Remarks"];
        [GlobalDirector cleanTextView:_txtvRemarks];
    }
    
}
-(void)animateToActiveButton:(UIButton *)btn image:(UIImageView*)img
{
    img.backgroundColor=[UIColor whiteColor];
    img.frame=btn.frame;
}

-(void)animateExpandVwAddress
{
    _vwCopyJobAddr.hidden=NO;
}
-(void)animateCollapseVwAddress
{
     _vwCopyJobAddr.hidden=YES;
}
-(void)ResetFieldsFor:(NSString *)key
{
   
    
    if ([key isEqualToString:@"User"]) {
        _txtFirstName.text=@"";
        _txtLastName.text=@"";
        _txtTitle.text=@"";
        _txtEmail.text=@"";
        _txtContactNo.text=@"";
        _txtvwUserNote.text=@"";
    }
    else if ([key isEqualToString:@"Address"])
    {
        _txtNameOfOrganisation.text=@"";
        _txtAddress.text=@"";
        _txtCountry.text=@"";
        _txtCityTown.text=@"";
        _txtzipCode.text=@"";
        _txtTypeofOrganization.text=@"";
        _txtvRemarks.text=@"";
        _txtAddrContactNo.text=@"";
        
        
    }
}

-(void)cleanTextField:(UITextField *)textField{
    for (UILabel *lbl in [textField subviews]) {
        if (lbl.tag==999) {
            
            [lbl removeFromSuperview];
            
            
        }
    }
    
}


#pragma mark Post Jod Service
-(void)PostJob
{
    
   

    NSString *post =[NSString stringWithFormat:@""];
    DLog(@"post :%@",post);
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
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
    if ([arrCustomeradditionalNotes count]!=0)
    {
        jsonadditionalNotes = [NSJSONSerialization dataWithJSONObject:arrCustomeradditionalNotes
                                                              options:0
                                                                error:&error];
    }
   
    
    
    NSString *JSONStringAdrr,*JSONStringUsers,*JSONStringAdditionalNotes;
    
    
    if (!jsonUserDetails) {
       // DLog(@"%@ ,%@",jsonUserDetails,error);
        
    } else {
        
        JSONStringUsers = [[NSString alloc] initWithBytes:[jsonUserDetails bytes] length:[jsonUserDetails length] encoding:NSUTF8StringEncoding];
        DLog(@"%@ ,%@",jsonUserDetails,JSONStringUsers);
    }
    
    
    if (!jsonAddress) {
        //DLog(@"%@ ,%@",jsonAddress,error);
        
    } else {
        
        JSONStringAdrr = [[NSString alloc] initWithBytes:[jsonAddress bytes] length:[jsonAddress length] encoding:NSUTF8StringEncoding];
       // DLog(@"%@ ,%@",jsonAddress,JSONStringAdrr);
    }
    
    if (!jsonadditionalNotes)
    {
       JSONStringAdditionalNotes=@"";
        
    } else {
        
        JSONStringAdditionalNotes = [[NSString alloc] initWithBytes:[jsonadditionalNotes bytes] length:[jsonadditionalNotes length] encoding:NSUTF8StringEncoding];
        // DLog(@"%@ ,%@",jsonAddress,JSONStringAdrr);
    }
    
    //------------ all field s fetch DLog -----------
    
//    DLog(@"userToken %@",(NSString *)[userdetails valueForKey:@"UserToken"]);
//    DLog(@"UserID :%@",(NSString *)[userdetails valueForKey:@"UserID"]);
//    DLog(@"userType :%@",(NSString *)[userdetails valueForKey:@"UserType"]);
//    DLog(@"staffID :%@",(NSString *)[userdetails valueForKey:@"StaffID"]);
//    DLog(@"DateStartDate :%@",_txtStartDate.text);
//    DLog(@"TimeAllowance :%ld",(long)_txtTimeAllowance.tag);
//    DLog(@"JobType :%ld",(long)_txtNatureOfJob.tag);
//    DLog(@"JobStatus :%@",_txtJobStatus.text);
//    DLog(@"JobDescription :%@",_txtvJobDescription.text);
//    DLog(@"PaymentMode :%ld",(long)_txtPaymentMode.tag);
//    DLog(@"PaymentMode :%ld",(long)_txtAdvertiseChannel.tag);
//    
//    DLog(@"PeopleDetails :%@",JSONStringUsers);
//    DLog(@"JobAddress :%@",JSONStringAdrr);
    //DLog(@"Job Note :%@",JSONStringAdditionalNotes);
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *startDate=[formatter dateFromString:_txtStartDate.text];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString *startDateStr=[formatter stringFromDate:startDate];
    DLog(@"%@",startDateStr);
    
    
    NSString *json;
    NSMutableDictionary *postDictionary = [NSMutableDictionary dictionary];
    [postDictionary setValue:(NSString *)[userdetails valueForKey:@"UserToken"] forKey:@"userToken"];
    [postDictionary setValue:(NSString *)[userdetails valueForKey:@"UserID"] forKey:@"userID"];
    [postDictionary setValue:(NSString *)[userdetails valueForKey:@"UserType"] forKey:@"userType"];
    [postDictionary setValue:startDateStr forKey:@"jobStartDate"];
    //[postDictionary setValue:_txt.text forKey:@"startTime"];
    [postDictionary setValue:[NSString stringWithFormat:@"%@", _txtTimeAllowance.text] forKey:@"BookingAgentName"];
    [postDictionary setValue:[NSString stringWithFormat:@"%ld",(long)_txtAdvertiseChannel.tag] forKey:@"advertisingChannel"];
    [postDictionary setValue:@"" forKey:@"jobStatus"];
    [postDictionary setValue:[NSString stringWithFormat:@"%ld",(long)_txtNatureOfJob.tag] forKey:@"natureofJob"];
    [postDictionary setValue:(NSString *)[userdetails valueForKey:@"StaffID"] forKey:@"staffID"];
    [postDictionary setValue:_txtvJobDescription.text forKey:@"jobDescription"];
    
    if (_txtPurchOrder.text.length>0) {
        [postDictionary setValue:_txtPurchOrder.text forKey:@"purchaseOrder"];
    }
    
    
    [postDictionary setValue:JSONStringUsers forKey:@"jobPeople"];
    [postDictionary setValue:JSONStringAdrr forKey:@"jobAddress"];
    [postDictionary setValue:JSONStringAdditionalNotes forKey:@"jobNote"];

    //------------------------------------------------
   
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%sCustomerJobCreate",conn_url]]];
    [request setHTTPMethod:@"POST"];
    DLog(@"request :%@",request);
    NSError *jsonError;

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
    
    DLog(@"request Body:%@",[request HTTPBody]);
    NSString *strReq = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSASCIIStringEncoding];
    DLog(@"%@",strReq);
    
    connIdentifier=@"connPostNote";
    
    [self PostDataToServerWithUrl:[NSString stringWithFormat:@"%sCustomerJobCreate",conn_url] dataDictionary:postDictionary finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _responseData=[data mutableCopy];
            [self connectionDidFinishLoading:connPostNote];
        });
        
    }];
    /*
    connPostNote = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connPostNote start];
  */
    
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    NSHTTPURLResponse *res=(NSHTTPURLResponse*)response;
    DLog(@"%@",res);
    
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
    //DLog(@"%f",(float)totalBytesWritten/totalBytesExpectedToWrite);
    DLog(@"totalBytesWritten:-%f\totalBytesExpectedToWrite:%f\n\t\t\tDiv=%f",(float)totalBytesWritten,(float)_totalBytes,(float)totalBytesWritten/(float)_totalBytes);
    
}




- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
     
    
   NSMutableData * returnData=_responseData;
    
    NSMutableDictionary *temp,*dicTemp;
    if (returnData !=nil)
    {
        NSError *error;
        temp = [NSJSONSerialization JSONObjectWithData:returnData  options:NSJSONReadingMutableContainers error:&error];
        
        DLog(@"temp %@",temp);
     
        dicTemp=[temp objectForKey:@"CustomerJobCreateResult"];
        
        if (!error)
        {
            if ([[dicTemp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
            {
                DLog(@"%@",temp);
              
                
                UIAlertController *controller = [UIAlertController alertControllerWithTitle: @""
                                                                                    message:[NSString stringWithFormat:@"New job saved successfully(Job ID: %@).",[dicTemp valueForKey:@"JobID"]]
                                                                             preferredStyle: UIAlertControllerStyleAlert];
                
                
                
                
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK"
                                                                      style: UIAlertActionStyleDestructive
                                                                    handler: ^(UIAlertAction *action) {
                                                                        [self.navigationController popViewControllerAnimated:YES];
                                                                        
                                                                    }];
                
                
                
                
                [controller addAction: alertAction];
                
                [self presentViewController: controller animated: YES completion: nil];
                
                
            }
        }
        else
        {
            DLog(@"JSONObjectWithData error: %@", error);
        }
        
        NSString *str=[[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
        
        DLog(@"%@",str);
        
        
        [hud hide:YES];
        
    }
        
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
   // [[[UIAlertView alloc]initWithTitle:@"Error" message:@"No network connection. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
     [self showAlert:@"No network connection. Please try again later."  withTitle:@"Error"];
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
                    
                }
                
                //[self btnJobAdressTapped:_btnJobAdress];
                 [dicJobAddress setValue:@"1" forKey:@"TypeOfAddress"];
                selectedAddressDic=[dicJobAddress mutableCopy];
                [self FetchAddressDicValue:dicJobAddress];
               
                
                
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
                    
                }
                [dicBillingAddress setValue:@"2" forKey:@"TypeOfAddress"];
                selectedAddressDic=[dicJobAddress mutableCopy];
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
                    
                }
                
                [dicLandLordAdress setValue:@"3" forKey:@"TypeOfAddress"];
                selectedAddressDic=[dicJobAddress mutableCopy];
                
                [self btnLandlordAdressTapped:_btnLandlordAdress];
                
            }
            
            
        } @catch (NSException *exception) {
            ;
        }
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
            
            
            [dicJobAddress setValue:@"1" forKey:@"TypeOfAddress"];

            selectedAddressDic=[dicJobAddress mutableCopy];
            [self FetchAddressDicValue:dicJobAddress];
           
            
            
            
            
        } @catch (NSException *exception) {
            ;
        }
        
    }else{
        
        [self showAlert:@"No previous address to show." withTitle:@"Error"];
    }
    
    
    
}




@end
