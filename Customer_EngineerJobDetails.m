//
//  Customer_EngineerJobDetails.m
//  Partner Maintenance
//


#import "Customer_EngineerJobDetails.h"


@interface Customer_EngineerJobDetails ()
{
    AppDelegate *app;
}
@end

@implementation Customer_EngineerJobDetails
@synthesize btnSlideMenu;
@synthesize dicCustomerJobDetails,dicEngineerJobDetails;


#pragma mark- ViewDidLoad Method
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
    
    arrSelectedRecipients=[[NSMutableArray alloc]init];
    
    
    
    [_btnAdditionalNotesShown.layer setBorderColor: [[UIColor clearColor] CGColor]];
    [_btnAdditionalNotesShown.layer setBorderWidth: 0.0];
    [_btnAdditionalNotesShown.layer setCornerRadius:0.0f];
    [_btnAdditionalNotesShown.layer setMasksToBounds:YES];
    _btnAdditionalNotesShown.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:16.0];
    
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
    
    
    
    NSArray *arr=[dicCustomerJobDetails objectForKey:@"JobPeopleListResponse"];
    
    if (arr.count>0) {
        
        //  NSDictionary *dic = [arr objectAtIndex:0];
        for ( NSDictionary *dic  in arr) {
            
            
            if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==1 && [[dic valueForKey:@"CustID"]integerValue]>0) {
                [self performSelector:@selector(UpdateButton:) withObject:_btnOwner afterDelay:0.2];
                // [self btnOwnerTapped:_btnOwner];
                
                [self performSelector:@selector(btnOwnerTapped:) withObject:_btnOwner afterDelay:0.2];
            }else if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==2 && [[dic valueForKey:@"CustID"]integerValue]>0){
                [self performSelector:@selector(UpdateButton:) withObject:_btnTenant afterDelay:0.2];
                // [self btnTenantTapped:_btnTenant];
                [self performSelector:@selector(btnTenantTapped:) withObject:_btnTenant afterDelay:0.2];
                
            }else if (([[dic valueForKey:@"TypeofCustomer"]integerValue]==3 || [[dic valueForKey:@"TypeofCustomer"]integerValue]==4) && [[dic valueForKey:@"CustID"]integerValue]>0){
                [self performSelector:@selector(UpdateButton:) withObject:_btnLandlord afterDelay:0.2];
                // [self btnLandlordTapped:_btnLandlord];
                [self performSelector:@selector(btnLandlordTapped:) withObject:_btnLandlord afterDelay:0.2];
            }
        }
    }

    
    
   
    [self btnJobAdressTapped:_btnJobAdress];
    
}

-(void)UpdateButton:(UIButton*)sender{
    
    [self animateToActiveButton:sender image:_selected];
}

#pragma mark- Gas Form List Redirect Page
- (IBAction)pressGasCertList:(id)sender
{
    NSLog(@"GasCertList");
    
    GasForms *gasfff = [[GasForms alloc]initWithNibName:@"GasForms" bundle:nil];
    gasfff.jobDic=dicCustomerJobDetails;
    gasfff.isJobDetailsPageRedirect=YES;
    [self presentViewController:gasfff animated:YES completion:nil];
    
}



- (IBAction)ClickPaymentDetails:(UIButton *)sender {
    
  
        CustomerFinDtl *fin = [[CustomerFinDtl alloc] initWithNibName:@"CustomerFinDtl" bundle:nil];
        fin.jobDic=dicCustomerJobDetails;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:fin];
        [self presentViewController:nav animated:YES completion:nil];
    
    
}

- (IBAction)AgreementPress:(UIButton *)sender {
    
    SignAgreement *signagree=[[SignAgreement alloc]initWithNibName:@"SignAgreement" bundle:nil];
    signagree.strHeading=@"Agreement Signature";
    signagree.jobID=[dicCustomerJobDetails valueForKey:@"JobID"];
    signagree.JobDic=dicCustomerJobDetails;
    signagree.isAgreementSigned=[[dicCustomerJobDetails valueForKey:@"IsAgreementSign"]boolValue];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDismissSecondViewController)
                                                 name:@"SecondViewControllerDismissedWithAgreement"
                                               object:nil];
    
    
    [self.navigationController pushViewController:signagree animated:true];
}


-(void)didDismissSecondViewController
{
    //DLog(@"Dismissed SecondViewController");
    [self backPress:nil];
}



-(void)addItemViewController:(id)controller didFinishEnteringItem:(NSMutableArray *)Notes
{
    
    arrNotes=Notes;
    
}



#pragma mark- Add Notes Press Method
-(IBAction)shownAdditionalNotes:(id)sender
{
   
    if (arrNotes.count==0)
    {
        arrNotes=[dicCustomerJobDetails valueForKey:@"JobNoteListResponse"];
    }
    
    
    AddNotes *notes=[[AddNotes alloc]initWithNibName:@"AddNotes" bundle:nil];
            
        
   // notes.Notes=arrNotes;
    notes.jobID=[NSString stringWithFormat:@"%@",[dicCustomerJobDetails valueForKey:@"JobID"]];
    notes.strFromCustomerClass=[NSString stringWithFormat:@"%@",[self class]];
    [self presentViewController:notes animated:YES completion:nil];
}



#pragma mark- Back Press Method
-(IBAction)backPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
  
    
   
    
   NSInteger  isjobstatusNumber =[[dicCustomerJobDetails objectForKey:@"JobStatus"] integerValue];
    if(isjobstatusNumber==2) {
        
        if ([[dicCustomerJobDetails valueForKey:@"IsAgreementSign"]integerValue]==1 && [[dicCustomerJobDetails valueForKey:@"FixedPrice"]integerValue]>0)
        {
            [_btnAgreement setTitle:@"Fixed Price Agreement" forState:UIControlStateNormal];
            _btnAgreement.hidden=NO;
            
        }
        else if([[dicCustomerJobDetails valueForKey:@"IsAgreementSign"]integerValue]==0)
        {
            [_btnAgreement setTitle:@"Small Repair Agreement" forState:UIControlStateNormal];
            _btnAgreement.hidden=NO;
            
        }
        else
        {
            _btnAgreement.hidden=YES;
        }
        
    }else
    {
        _btnAgreement.hidden=YES;
    }
    
   
    
    NSString *strNatureofjob=[NSString stringWithFormat:@"%@",[dicCustomerJobDetails objectForKey:@"NatureofJob"]];
    
    if(isjobstatusNumber==1)
    {
        _btnGasCertList.hidden=YES;
        _btnPayDtl.hidden=YES;
    }
    else
    {
        _btnPayDtl.hidden=NO;
        if ([strNatureofjob rangeOfString:[NSString stringWithFormat:@"%@",@"Gas"]].location != NSNotFound)
        {
            _btnGasCertList.hidden=NO;
        }
        else
        {
            _btnGasCertList.hidden=YES;
        }
        
    }
    
    
   
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
    {
        if (dicCustomerJobDetails==nil)
        {
        }
        else
        {
            
            NSMutableDictionary *dicManagerJobDetails=dicCustomerJobDetails;
            
            NSString *strStartDate =[NSString stringWithFormat:@"%@",[dicManagerJobDetails valueForKey:@"JobStartDate"]];
            strStartDate = [strStartDate substringToIndex:10];
            
             _txtPurOrder.text=[GlobalDirector ReplaceStringNull:[dicManagerJobDetails valueForKey:@"PurchaseOrder"]];
            
            _txtDatejobPost.text=[NSString stringWithFormat:@" %@:\t%@ %@",_txtDatejobPost.placeholder,strStartDate,[dicManagerJobDetails valueForKey:@"JobStartTime"]];
            
            _txtNatureOfJob.text=[NSString stringWithFormat:@" %@:\t%@",_txtNatureOfJob.placeholder,[dicManagerJobDetails valueForKey:@"NatureofJob"]];
             _txtTimeAllowance.text=[NSString stringWithFormat:@" %@:\t%@",_txtTimeAllowance.placeholder,[dicManagerJobDetails valueForKey:@"TimeAllowance"]];
            
            NSString *advert= [GlobalDirector ReplaceStringNull:[dicManagerJobDetails valueForKey:@"AdvertisingChannel"]];
            
            if (advert.length>0) {
                 _txtAddvertisementChannel.text=[NSString stringWithFormat:@" %@:\t%@",_txtAddvertisementChannel.placeholder,[dicManagerJobDetails valueForKey:@"AdvertisingChannel"]];
            }else{
                 _txtAddvertisementChannel.text=[NSString stringWithFormat:@" %@:\t%@",_txtAddvertisementChannel.placeholder,@"Repeat Customer"];
            }
            
            
            
           
            
            _txtPaymentMode.text=[NSString stringWithFormat:@" %@:\t%@",_txtPaymentMode.placeholder,[dicManagerJobDetails valueForKey:@"PaymentMode"]];
            _txtvJobDescription.text=[NSString stringWithFormat:@" %@",[dicManagerJobDetails valueForKey:@"JobDescription"]];
           
            _txtvJobDescription.userInteractionEnabled=YES;
            _txtvJobDescription.editable=NO;
            
            _txtvRemarks.userInteractionEnabled=YES;
            _txtvRemarks.editable=NO;
            
            _txtvwUserNote.userInteractionEnabled=YES;
            _txtvwUserNote.editable=NO;
            
            NSString *jobstatus=[NSString stringWithFormat:@"%@",[dicManagerJobDetails valueForKey:@"JobStatus"]];
            
            if ([jobstatus isEqualToString:@"1"]){
                _txtJobstatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobstatus.placeholder,@"Booked"];
            }
            else if ([jobstatus isEqualToString:@"2"]){
                _txtJobstatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobstatus.placeholder,@"Active"];
            }
            else if ([jobstatus isEqualToString:@"3"]){
                
               // _txtJobstatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobstatus.placeholder,@"Completed"];
                NSString *strComp = [GlobalDirector ReplaceStringNull:[dicManagerJobDetails valueForKey:@"SubStatusText"]];
                
                if (strComp.length>0) {
                    strComp = [NSString stringWithFormat:@"Completed-%@",strComp];
                    _txtJobstatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobstatus.placeholder,strComp];
                }else{
                    _txtJobstatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobstatus.placeholder,@"Completed"];
                }
                
            }
        }
    }
   
    
    for (UITextField *txtfield in [_scrolVw subviews])
    {
        if ([txtfield isKindOfClass:[UITextField class]])
        {
            UITextField *txtfld=(UITextField *)txtfield;
            [txtfld setBorderStyle:UITextBorderStyleNone];
            txtfld.layer.borderWidth=0.5f;
            txtfld.layer.borderColor=[[UIColor lightGrayColor]CGColor];
            txtfld.layer.cornerRadius=0.0f;
            txtfld.backgroundColor=[UIColor whiteColor];
            txtfld.userInteractionEnabled=NO;
            
            if (txtfld==_txtRecreatedFromInvoice)
            {
                txtfld.background=[UIImage imageNamed:@""];
                [txtfld setBorderStyle:UITextBorderStyleNone];
                txtfld.layer.borderWidth=0.5f;
                txtfld.layer.borderColor=[[UIColor lightGrayColor]CGColor];
                txtfld.layer.cornerRadius=0.0f;
                txtfld.backgroundColor=[UIColor whiteColor];
                [txtfld.layer setMasksToBounds:YES];
            }
            
            UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,30)];
            leftView.backgroundColor = [UIColor clearColor];
            leftView.textAlignment=NSTextAlignmentLeft;
            txtfld.leftView = leftView;
            txtfld.leftViewMode = UITextFieldViewModeAlways;
            txtfld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            
            
        }
    }
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SWRevealViewController Delegate Methods
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if (position == FrontViewPositionLeftSide)
    {
        ;
    }
    else if (position == FrontViewPositionLeft)
    {
        ;
        
    }
}



- (IBAction)btnOwnerTapped:(UIButton *)sender {
    _btnOwner.selected=YES;
    _btnLandlord.selected=NO;
    _btnTenant.selected=NO;
    [self ResetFieldsFor:@"User"];
  
    NSArray *arr=[dicCustomerJobDetails objectForKey:@"JobPeopleListResponse"];
    for (NSDictionary *dic in arr) {
        DLog(@"%@",[dic valueForKey:@"TypeofCustomer"]);
        
        if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==1) {
            [self FetchUserDicValue:dic];
        }
        
    }
    
   [self animateToActiveButton:sender image:_selected];
    
}



- (IBAction)btnLandlordTapped:(id)sender {
    _btnOwner.selected=NO;
    _btnLandlord.selected=YES;
    _btnTenant.selected=NO;
    [self ResetFieldsFor:@"User"];
    NSArray *arr=[dicCustomerJobDetails objectForKey:@"JobPeopleListResponse"];
    for (NSDictionary *dic in arr) {
        if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==3 || [[dic valueForKey:@"TypeofCustomer"]integerValue]==4) {
            [self FetchUserDicValue:dic];
        }
       
    }
   
    [self animateToActiveButton:sender image:_selected];
}


- (IBAction)btnTenantTapped:(UIButton *)sender {
    _btnOwner.selected=NO;
    _btnLandlord.selected=NO;
    _btnTenant.selected=YES;
    [self ResetFieldsFor:@"User"];
    NSArray *arr=[dicCustomerJobDetails objectForKey:@"JobPeopleListResponse"];
    for (NSDictionary *dic in arr) {
        if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==2) {
            [self FetchUserDicValue:dic];
        }
       
    }

    [self animateToActiveButton:sender image:_selected];
}

-(void)animateToActiveButton:(UIButton *)btn image:(UIImageView*)img {
    
    img.backgroundColor=[UIColor whiteColor];
    
    img.frame=btn.frame;
    
    
}

- (IBAction)btnJobAdressTapped:(id)sender {
    _lblAddress.text=@"  Job Address";
  
    _btnJobAdress.selected=YES;
    _btnLandlordAdress.selected=NO;
    _btnBillingAdress.selected=NO;
     [self ResetFieldsFor:@"Address"];
   
    NSArray *arr=[dicCustomerJobDetails objectForKey:@"JobAddrListResponse"];
    
    for (NSDictionary *dic in arr) {
        if ([[dic valueForKey:@"TypeOfAddress"]integerValue]==1) {
            [self FetchAddressDicValue:dic];
        }
    }
    [self animateToActiveButton:sender image:_selected2];
}

- (IBAction)btnBillingAdressTapped:(id)sender
{
    _lblAddress.text=@"  Billing Address";
   
    _btnJobAdress.selected=NO;
    _btnLandlordAdress.selected=NO;
    _btnBillingAdress.selected=YES;
    [self ResetFieldsFor:@"Address"];
    NSArray *arr=[dicCustomerJobDetails objectForKey:@"JobAddrListResponse"];
    for (NSDictionary *dic in arr)
    {
        if ([[dic valueForKey:@"TypeOfAddress"]integerValue]==2)
        {
           [self FetchAddressDicValue:dic];
        }
    }
    [self animateToActiveButton:sender image:_selected2];
}

- (IBAction)btnLandlordAdressTapped:(id)sender
{
    
    _lblAddress.text=@"  LL Address";
    _btnJobAdress.selected=NO;
    _btnLandlordAdress.selected=YES;
    _btnBillingAdress.selected=NO;
    [self ResetFieldsFor:@"Address"];
    NSArray *arr=[dicCustomerJobDetails objectForKey:@"JobAddrListResponse"];
    for (NSDictionary *dic in arr)
    {
        if ([[dic valueForKey:@"TypeOfAddress"]integerValue]==3)
        {
            [self FetchAddressDicValue:dic];
        }
    }
    [self animateToActiveButton:sender image:_selected2];
}


-(void)FetchUserDicValue:(NSDictionary *)dic
{
    if (![[dic valueForKey:@"FirstName"]isEqualToString:@""]) {
        _txtFirstName.text=[dic valueForKey:@"FirstName"];
        
    }
    if (![[dic valueForKey:@"LastName"]isEqualToString:@""]) {
        _txtLastName.text=[dic valueForKey:@"LastName"];
        
    }
    if (![[dic valueForKey:@"Title"]isEqualToString:@""]) {
        _txtTitle.text=[dic valueForKey:@"Title"];
   
    }
    if (![[dic valueForKey:@"EmailAddress"]isEqualToString:@""]) {
        _txtEmail.text=[dic valueForKey:@"EmailAddress"];
        
    }
    if (![[dic valueForKey:@"ContactNumber"]isEqualToString:@""]) {
        _txtContactNo.text=[dic valueForKey:@"ContactNumber"];
        
    }
    if (![[dic valueForKey:@"Notes"]isEqualToString:@""]) {
        _txtvwUserNote.text=[dic valueForKey:@"Notes"];
        
    }
}

-(void)ResetFieldsFor:(NSString *)key
{
    if ([key isEqualToString:@"User"])
    {
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
         _txtAdressContactNo.text=@"";

        
    }
}

-(void)FetchAddressDicValue:(NSDictionary *)dic
{
    
    if (![[dic valueForKey:@"NameofOrganisation"]isKindOfClass:[NSNull class]]) {
    
    
        _txtNameOfOrganisation.text=[dic valueForKey:@"NameofOrganisation"];
        
   
    }
    if (![[dic valueForKey:@"Address"]isKindOfClass:[NSNull class]]) {
   
   
        _txtAddress.text=[dic valueForKey:@"Address"];
   
    }
    
    if (![[dic valueForKey:@"County"]isKindOfClass:[NSNull class]]) {
    
    
        _txtCountry.text=[dic valueForKey:@"County"];

        
    }
    if (![[dic valueForKey:@"City"]isKindOfClass:[NSNull class]]) {
    
           _txtCityTown.text=[dic valueForKey:@"City"];

    }
    
    if (![[dic valueForKey:@"PostCode"]isKindOfClass:[NSNull class]]) {
    
   
        _txtzipCode.text=[dic valueForKey:@"PostCode"];

        
    }
    if (![[dic valueForKey:@"ContactNo"]isKindOfClass:[NSNull class]]) {
  
        _txtAdressContactNo.text=[dic valueForKey:@"ContactNo"];
   
    }
    
   
    
    if ([dic valueForKey:@"TypeofOrganisation"]) {
    
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
       
        _txtTypeofOrganization.text=typeOfOrganisation;
        
    }
    
    
    
    if (![[dic valueForKey:@"Remarks"]isKindOfClass:[NSNull class]]) {
   
   
        _txtvRemarks.text=[dic valueForKey:@"Remarks"];
   
    }
}




#pragma mark- Message Class Method
-(IBAction)pressMessage:(id)sender
{
    mainBgmssg = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    mainBgmssg.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    
    bgVwmssg = [[UIView alloc] initWithFrame:CGRectMake(0,0,300,self.view.frame.size.height-270)];
   
   
    
    if ([UIScreen mainScreen].bounds.size.height==480) {
        [bgVwmssg setFrame:CGRectMake(0, 0, 300.0, self.view.frame.size.height-170)];
        bgVwmssg.center=CGPointMake(CGRectGetWidth(mainBgmssg.frame)/2.0f, (CGRectGetHeight(mainBgmssg.frame)/2.0f)-40);
    }else{
      bgVwmssg.center=CGPointMake(CGRectGetWidth(mainBgmssg.frame)/2.0f, CGRectGetHeight(mainBgmssg.frame)/2.0f);
    }
    
    
    
    [bgVwmssg.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [bgVwmssg.layer setBorderWidth: 0.5];
    [bgVwmssg.layer setCornerRadius:4.0f];
    [bgVwmssg.layer setMasksToBounds:YES];
    bgVwmssg.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    
    
    UILabel *lbheader = [[UILabel alloc] initWithFrame:CGRectMake(20,3,240,29)];
    lbheader.center=CGPointMake(CGRectGetWidth(bgVwmssg.frame)/2.0f, lbheader.center.y);
    
    lbheader.text = @"Send a message";
    lbheader.font = [UIFont fontWithName:@"TheSansArabic-Bold" size:16.0];
    lbheader.textAlignment = NSTextAlignmentCenter;
    lbheader.textColor=[UIColor grayColor];
    [bgVwmssg addSubview:lbheader];
    
    
    //--------Select UserType------------
    txtUserTypemssg = [[UITextField alloc] initWithFrame:CGRectMake(20,50,240,30)];
    txtUserTypemssg.center=CGPointMake(CGRectGetWidth(bgVwmssg.frame)/2.0f, txtUserTypemssg.center.y);
    txtUserTypemssg.backgroundColor=[UIColor whiteColor];
    txtUserTypemssg.textColor=[UIColor darkGrayColor];
    txtUserTypemssg.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    [txtUserTypemssg setBorderStyle:UITextBorderStyleNone];
    txtUserTypemssg.delegate = self;
    txtUserTypemssg.userInteractionEnabled=YES;
    txtUserTypemssg.placeholder=@" Send to";
    txtUserTypemssg.layer.borderWidth=0.5f;
    txtUserTypemssg.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    txtUserTypemssg.layer.cornerRadius=0.0f;
    
    UIImageView *imgDropdown4=[[UIImageView alloc] initWithFrame:CGRectMake(225,50, 35, 30)];
    imgDropdown4.center=CGPointMake(CGRectGetMaxX(txtUserTypemssg.frame)-CGRectGetWidth(imgDropdown4.frame)/2.0f, imgDropdown4.center.y);
    [imgDropdown4 setImage:[UIImage imageNamed:@"dropdown"]];
    [bgVwmssg addSubview:txtUserTypemssg];
    [bgVwmssg addSubview:imgDropdown4];
    
    
    //--------Select Mutiple UserName------------
    txtUserNamemssg = [[UITextField alloc] initWithFrame:CGRectMake(20,110,240,30)];
    txtUserNamemssg.center=CGPointMake(CGRectGetWidth(bgVwmssg.frame)/2.0f, txtUserNamemssg.center.y);
    txtUserNamemssg.textColor=[UIColor darkGrayColor];
    txtUserNamemssg.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    [txtUserNamemssg setBorderStyle:UITextBorderStyleNone];
    txtUserNamemssg.layer.borderWidth=0.5f;
    txtUserNamemssg.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    txtUserNamemssg.layer.cornerRadius=0.0f;
    txtUserNamemssg.backgroundColor=[UIColor whiteColor];
    txtUserNamemssg.delegate = self;
    txtUserNamemssg.userInteractionEnabled=YES;
    txtUserNamemssg.placeholder=@" Select name";
    
    UIImageView *imgDropdown5=[[UIImageView alloc] initWithFrame:CGRectMake(225,110, 35, 30)];
    imgDropdown5.center=CGPointMake(CGRectGetMaxX(txtUserNamemssg.frame)-CGRectGetWidth(imgDropdown5.frame)/2.0f, imgDropdown5.center.y);
    [imgDropdown5 setImage:[UIImage imageNamed:@"dropdown"]];
    [bgVwmssg addSubview:txtUserNamemssg];
    [bgVwmssg addSubview:imgDropdown5];
    
    
    //-------- Job Decription -------------
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20,170,240,30)];
    lblTitle.center=CGPointMake(CGRectGetWidth(bgVwmssg.frame)/2.0f, lblTitle.center.y);
    lblTitle.text = @" Message Body";
    lblTitle.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.backgroundColor =[UIColor colorWithRed:52/255.0 green:54/255.0 blue:67/255.0 alpha:0.72];
    [lblTitle.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [lblTitle.layer setBorderWidth: 1.0];
    [lblTitle.layer setCornerRadius:0.0f];
    [lblTitle.layer setMasksToBounds:YES];
    
    txtvMessageBodymssg = [[UITextView alloc] initWithFrame:CGRectMake(20,210,240,120)];
    txtvMessageBodymssg.center=CGPointMake(CGRectGetWidth(bgVwmssg.frame)/2.0f, txtvMessageBodymssg.center.y);
    txtvMessageBodymssg.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    txtvMessageBodymssg.textColor=[UIColor darkGrayColor];
    [txtvMessageBodymssg setBackgroundColor:[UIColor whiteColor]];
    txtvMessageBodymssg.delegate = self;
    [txtvMessageBodymssg.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [txtvMessageBodymssg.layer setBorderWidth: 1.0];
    [txtvMessageBodymssg.layer setCornerRadius:0.0f];
    [txtvMessageBodymssg.layer setMasksToBounds:YES];
    [bgVwmssg addSubview:lblTitle];
    [bgVwmssg addSubview:txtvMessageBodymssg];
    
    btnMessagePostmssg=[UIButton buttonWithType:UIButtonTypeCustom];
    btnMessagePostmssg.frame=CGRectMake(0,CGRectGetHeight(bgVwmssg.frame)-40,300,40);
    [btnMessagePostmssg setTitle:@"Send" forState:UIControlStateNormal];
    [btnMessagePostmssg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnMessagePostmssg.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:18.0];
    [btnMessagePostmssg setBackgroundColor:[UIColor colorWithRed:30/255.0 green:124/255.0 blue:41/255.0 alpha:1.0]];
    btnMessagePostmssg.tag=1;
    [btnMessagePostmssg addTarget:self action:@selector(pressMessagePostmssg:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnMessagePostmssg.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [btnMessagePostmssg.layer setBorderWidth: 1.0];
    [btnMessagePostmssg.layer setCornerRadius:0.0f];
    [btnMessagePostmssg.layer setMasksToBounds:YES];
    
    btnCrossmssg=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCrossmssg.frame=CGRectMake(0, 0, 25, 25);
    btnCrossmssg.center=CGPointMake(CGRectGetMaxX(bgVwmssg.frame)-4,CGRectGetMinY(bgVwmssg.frame)+4);
    [btnCrossmssg setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
    [btnCrossmssg addTarget:self action:@selector(crossmssg:) forControlEvents:UIControlEventTouchUpInside];
    [btnCrossmssg clipsToBounds];
    
    
    
    [bgVwmssg addSubview:btnMessagePostmssg];
    [mainBgmssg addSubview:bgVwmssg];
    [mainBgmssg addSubview:btnCrossmssg];
    
    [mainBgmssg setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+100)];
    
    [self.view addSubview:mainBgmssg];
}





#pragma mark- Cross Press Method
-(void)crossmssg:(UIButton *)sender
{
    _btnMessagePress.selected=NO;
    [mainBgmssg removeFromSuperview];
    [arrSelectedRecipients removeAllObjects];
}
#pragma mark- pressMessagePost Method
-(void)pressMessagePostmssg:(id)sender
{
    
    if ([txtUserNamemssg.text isEqualToString:@""]||[txtUserTypemssg.text isEqualToString:@""]||[txtvMessageBodymssg.text isEqualToString:@""]) {
        
        [self showAlert:@"To send message you have to enter usertype/username and message respectively" withTitle:@"Wait"];
        
    }
    else
    {
    
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *urlString;
    NSString *post =[NSString stringWithFormat:@""];
    
    
    
    NSString *selectedEnggIds=[[arrSelectedRecipients valueForKey:@"Value"] componentsJoinedByString:@","];;
    DLog(@"%@",selectedEnggIds);
    
    
    urlString=[NSString stringWithFormat:@"%sSetJobWiseMessage?userToken=%@&jobID=%@&userToIds=%@&userFromId=%@&messageBody=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],[NSString stringWithFormat:@"%@",[dicCustomerJobDetails valueForKey:@"JobID"]],selectedEnggIds,(NSString *)[user valueForKey:@"UserID"],txtvMessageBodymssg.text];
   // [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
        request.timeoutInterval = 300;
    DLog(@"PostString=%@",request);
    
     connSendMessage = [[NSURLConnection alloc]init];
    
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
            
            DLog(@"PostString=%@",urlString);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (error==nil) {
                    _responseData=[data mutableCopy];
                    [self connectionDidFinishLoading:connSendMessage];
                }
                else
                {
                    
                }
                
            });
            
        }];
        
   
    }

    
}

#pragma mark - Textfield Delegate Method
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   
    [self.view endEditing:YES];
    
    Activetxtfld=textField;
    
   
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.view endEditing:YES];
    
    Activetxtfld=textField;
    if (textField==txtUserNamemssg&&txtUserTypemssg.text.length==0)
    {
        [self showAlert:@"Select User type to get user list " withTitle:@"Wait"];
        
    }
    else
    {
        
        [self popupList];
    }
    return YES;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - TEXTVIEW DELEGATES
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}
#pragma mark - Pop Up list Fetch / Show Method
-(void)popupList
{
    arrFeedTblPopup= [self GetDataForPoppup:Activetxtfld];
    
    
    if (tblView!=nil)
    {
        [tblView removeFromSuperview];
        tblView=nil;
    }
    
    else
    {
       tblView=[[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMinX(Activetxtfld.frame)+3,CGRectGetMaxY(Activetxtfld.frame)+1, CGRectGetWidth(Activetxtfld.frame), 0) style:UITableViewStylePlain];
        tblView.delegate=self;
        tblView.dataSource=self;
        [bgVwmssg addSubview:tblView];
        
        
        
        [tblView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [tblView.layer setBorderWidth: 2.0];
        [tblView.layer setCornerRadius:3.0f];
        [tblView.layer setMasksToBounds:YES];
        
        [UIView animateWithDuration:0.35
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect frame = tblView.frame;
                             frame.size.height = self.view.frame.size.height/4.0f;
                             tblView.frame = frame;
                         }
                         completion:^(BOOL finished){
                             DLog(@"Done!");
                         }];
    }
    
}
-(NSArray *)GetDataForPoppup:(UITextField *)fld
{
    
    
    
    if (fld==txtUserTypemssg)
    {
        arrFeedTblPopup=@[@"Manager",@"Admin"];
        return arrFeedTblPopup;
    }
    else if (fld==txtUserNamemssg)
    {
        arrFeedTblPopup=arrRecipientList;
        return arrFeedTblPopup;
    }
    return nil;
    
}


-(NSArray *)FetchDropDowns:(NSString *)key
{
    NSArray *arr;
    NSString *post =[NSString stringWithFormat:@""];
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *urlString=[NSString stringWithFormat:@"%sGetUserByRole?userToken=%@&userType=%@&jobId=%@",conn_url,(NSString *)[userdetails valueForKey:@"UserToken"],key,[NSString stringWithFormat:@"%@",[dicCustomerJobDetails valueForKey:@"JobID"]]];
    
    //[post stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
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
    MBProgressHUD *hud=  [MBProgressHUD showHUDAddedTo:bgVwmssg  animated:YES];
    hud.labelText=[NSString stringWithFormat:@"Getting %@ list",key];
    //
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        
        DLog(@"PostString=%@",urlString);
        [MBProgressHUD hideAllHUDsForView:bgVwmssg animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error==nil) {
                _responseData=[data mutableCopy];
                
                NSMutableDictionary* temp;
                if (_responseData !=nil)
                {
                    NSError *error;
                    temp = [NSJSONSerialization JSONObjectWithData:_responseData  options:NSJSONReadingMutableContainers error:&error];
                    if (!error)
                    {
                        if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
                        {
                            arrRecipientList=(NSArray *)[temp objectForKey:@"DataResponses"];
                        }
                        else
                        {
                            DLog(@"JSONObjectWithData error: %@", error);
                        }
                    }
                }
                else
                {
                }
                DLog(@"temp all static page:%@",temp);
            }
            else
            {
                
            }
            
        });
        
    }];

    return arr;
}
#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
    DLog(@"Connection Start::%@",_responseData);
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSMutableDictionary* temp;
    if (_responseData !=nil)
    {
        NSError *error;
        temp = [NSJSONSerialization JSONObjectWithData:_responseData  options:NSJSONReadingMutableContainers error:&error];
        
        if (!error)
        {
            if ([[temp valueForKey:@"ResponseStatus"]boolValue]==true)
            {
                if (connection==connSendMessage)
                {
                    
                    [self showAlert:@"Message sent" withTitle:@""];
                    
                    [mainBgmssg removeFromSuperview];
                }
            }
            else
            {
                [self showAlert:[temp valueForKey:@"ResponseMessages"] withTitle:@""];
                
                [mainBgmssg removeFromSuperview];
            }
            
        }
    }
}

#pragma mark - UITableView Delegate Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (tableView==tblView)
    {
        return 44;
    }
    else
    {
        return 135.0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tblView)
    {
        return [arrFeedTblPopup count];
    }
    else
    {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier=@"cellidentifier";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellidentifier];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.backgroundColor=[UIColor clearColor];
    
    DLog(@"arrFeedTblPopup :%@",arrFeedTblPopup);
    
    if (tableView==tblView)
    {
        NSDictionary *dic=(NSDictionary *)[arrFeedTblPopup objectAtIndex:indexPath.row];
        DLog(@"%@",dic);
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[arrFeedTblPopup objectAtIndex:indexPath.row]];
        cell.textLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
        
        if (Activetxtfld==txtUserNamemssg)
        {
            cell.textLabel.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"DisplayText"]];
            DLog(@"%@",arrSelectedRecipients);
            
            for (NSDictionary *obj in arrSelectedRecipients)
            {
                NSString *str=[obj valueForKey:@"DisplayText"];
                
                if ([str isEqualToString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"DisplayText"]]])
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            }
        }
    }
    else
    {
    }
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    if (tableView==tblView)
    {
        if (Activetxtfld==txtUserTypemssg)
        {
            txtUserTypemssg.text=[arrFeedTblPopup objectAtIndex:indexPath.row];
            [tblView removeFromSuperview];
            tblView=nil;
            
            arrRecipientList=[self FetchDropDowns:[arrFeedTblPopup objectAtIndex:indexPath.row]];
            
        }
        else if (Activetxtfld==txtUserNamemssg)
        {
            DLog(@"%ld",(unsigned long)[[txtUserNamemssg subviews]count]);
            NSDictionary *dic=(NSDictionary *)[arrFeedTblPopup objectAtIndex:indexPath.row];
            
            
            
            if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                if ([arrSelectedRecipients containsObject:dic])
                {
                    [arrSelectedRecipients removeObject:dic];
                }
            }
            else if ( cell.accessoryType == UITableViewCellAccessoryNone)
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [arrSelectedRecipients addObject:dic];
            }
            
            
            txtUserNamemssg.text=[[arrSelectedRecipients valueForKey:@"DisplayText"] componentsJoinedByString:@","];
            
            
        }
    }
}

- (IBAction)helpWidgetBtnCoustomer:(id)sender {
    HelpWidgetVC *createJob = [[HelpWidgetVC alloc] initWithNibName: @"HelpWidgetVC" bundle: nil];
//    @property (strong, nonatomic) IBOutlet NSDictionary *dictData;
    NSMutableDictionary *dict1= [[NSMutableDictionary alloc] init];
    [dict1 setValue:self.txtzipCode.text forKey:@"var2"];
    [dict1 setValue:self.txtFirstName.text forKey:@"var1"];
    createJob.dictData = dict1;
    NSLog(@"%@",dict1);
    [self.navigationController pushViewController:createJob animated:YES];
}
@end
