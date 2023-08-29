//
//  ManagerJobDetails.m

//  Partner Maintenance


#import "ManagerJobDetails.h"
#import "GlobalDirector.h"
AppDelegate *app;
@interface ManagerJobDetails ()
{
    GlobalDirector *globe;

}
@end

@implementation ManagerJobDetails
@synthesize btnSlideMenu,dicManagerJobDetails;
@synthesize managedObjectContext;

#pragma mark- JobactivationbyEngineer Method
-(IBAction)pressJobactivationbyEngineer:(id)sender
{
    
   if (Count==0 )
   {
    [self ShowPopupActive];
  
   }
    
    else if (Count==1)
    {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    //DLog(@"dicManagerJobDetails >>>>>>>>>>>>>>>>>>>>>>>%@",dicManagerJobDetails);

    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString;


    urlString=[NSString stringWithFormat:@"%ssetJobStatusActive?userToken=%@&jobId=%@&userId=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[dicManagerJobDetails valueForKey:@"JobID"],(NSString *)[user valueForKey:@"UserID"]];



    urlString=[urlString stringByRemovingPercentEncoding];
    //DLog(@"PostString=%@",urlString);
    urlString=[urlString stringByReplacingOccurrencesOfString:@"" withString:@"%20"];
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


    connActivateJobbyengineer = [[NSURLConnection alloc]init];
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){

        DLog(@"PostString=%@",urlString);

        dispatch_async(dispatch_get_main_queue(), ^{
            if (error==nil) {
                _responseData=[data mutableCopy];
                [self connectionDidFinishLoading:connActivateJobbyengineer];
            }
            else
            {

            }

        });

    }];
        Count=0;
        
    }
    
}

-(void)ShowPopupActive{
    
    
    etaCount =0;
//    _txtfdManagerEtatime.text=_txtfdsaveETAEnggTime.text;
    _txtfdsaveETAEnggTime.text=@"";
    _txtfdsaveETAEnggTime.layer.borderColor=[[UIColor clearColor]CGColor];
  [_txtfdsaveETAEnggTime becomeFirstResponder];
  
   
    KLCPopup *pop=    [KLCPopup popupWithContentView:_txtvwETa
                                            showType:KLCPopupShowTypeGrowIn dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
   
   
   [pop show];
    
}



#pragma mark- Gas Form List Redirect Page
- (IBAction)pressGasCertList:(id)sender
{
    NSLog(@"GasCertList");
    
    GasForms *gasfff = [[GasForms alloc]initWithNibName:@"GasForms" bundle:nil];
    gasfff.jobDic=dicManagerJobDetails;
    gasfff.isJobDetailsPageRedirect=YES;
//    [self presentViewController:gasfff animated:YES completion:nil];
        [[self navigationController] pushViewController:gasfff animated:YES];
    
}



#pragma mark - ViewWillAppear Method
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    _helpWidgetBtn.layer.cornerRadius = 14;
    _helpWidgetBtn.clipsToBounds = true;
    _helpWidgetBtnJobDetail.layer.cornerRadius = 14;
    _helpWidgetBtnJobDetail.clipsToBounds = true;
   
    DLog(@"dicManagerJobDetails >>>>>>>>>>>>>>>>>>>>>>>%@",dicManagerJobDetails);
    
    [self UpdateviewWillAppear];
    // [self GetJobDetails];
    
    
}



-(void)UpdateviewWillAppear
{
    NSString *strStartDate =[NSString stringWithFormat:@"%@",[dicManagerJobDetails valueForKey:@"JobStartDate"]];
    NSString *strEndTime =[NSString stringWithFormat:@"%@",[dicManagerJobDetails valueForKey:@"JobEndTime"]];
    
    NSString *jobEtaTime =[NSString stringWithFormat:@"%@",[dicManagerJobDetails valueForKey:@"JobEtaTime"]];
    
    
    if (strStartDate.length>0) {
        NSArray* foo = [strStartDate componentsSeparatedByString: @" "];
        
        strStartDate=[foo objectAtIndex:0];
         
        NSArray* foo1 = [strEndTime componentsSeparatedByString: @" "];
        
        strEndTime=[foo1 objectAtIndex:0];
        NSArray* foo2 = [jobEtaTime componentsSeparatedByString: @" "];
        
        jobEtaTime=[foo2 objectAtIndex:0];

    }
    
    
    
    
    //  NSString *status=[NSString stringWithFormat:@"%@",[dicManagerJobDetails objectForKey:@"JobStatus"]];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        
        
        NSString *name= [GlobalDirector ReplaceStringNull:[dicManagerJobDetails valueForKey:@"EngineerName"]];
        
        if (name.length>0)
        {
            _btnjobTypeSms.hidden=NO;
            _btnEngCall.hidden=NO;
            _txtMainContactNumber.text=[NSString stringWithFormat:@"Engineer Allocated: %@",[GlobalDirector ReplaceStringNull:[dicManagerJobDetails valueForKey:@"EngineerName"]]];
        }
        else{
            _btnjobTypeSms.hidden=YES;
            _btnEngCall.hidden=YES;
            _txtMainContactNumber.text=[NSString stringWithFormat:@" %@:\t%@",@"Engineer Allocated",@""];
            _txtfdManagerEtatime.text=[NSString stringWithFormat:@" %@:\t%@ ",_txtfdManagerEtatime.placeholder,[dicManagerJobDetails valueForKey:@"JobEtaTime"]];
            _txtfdEnggEtATime.text=[NSString stringWithFormat:@" %@:\t%@ ",_txtfdEnggEtATime.placeholder,[dicManagerJobDetails valueForKey:@"JobEtaTime"]];
            
        }
    }
    
    
    _txtPurchOrder.text=[GlobalDirector ReplaceStringNull:[dicManagerJobDetails valueForKey:@"PurchaseOrder"]];
    _txtDatejobPost.text=[NSString stringWithFormat:@" %@:\t%@ %@",_txtDatejobPost.placeholder,strStartDate,[dicManagerJobDetails valueForKey:@"JobStartTime"]];
    
    _txtEndtime.text=[NSString stringWithFormat:@" %@:\t%@ ",_txtEndtime.placeholder,[dicManagerJobDetails valueForKey:@"JobEndTime"]];
    _txtfdEnggEtATime.text=[NSString stringWithFormat:@" %@:\t%@ ",_txtfdEnggEtATime.placeholder,[dicManagerJobDetails valueForKey:@"JobEtaTime"]];
    _txtfdManagerEtatime.text=[NSString stringWithFormat:@" %@:\t%@ ",_txtfdManagerEtatime.placeholder,[dicManagerJobDetails valueForKey:@"JobEtaTime"]];
    
    

    
    _txtNatureOfJob.text=[NSString stringWithFormat:@" %@:\t%@",_txtNatureOfJob.placeholder,[dicManagerJobDetails valueForKey:@"NatureofJob"]];
    _txtAdvertisingChannel.text=[NSString stringWithFormat:@" %@:\t%@",_txtAdvertisingChannel.placeholder,[dicManagerJobDetails valueForKey:@"AdvertisingChannel"]];
    _txtPaymentMode.text=[NSString stringWithFormat:@" %@:\t%@",_txtPaymentMode.placeholder,[dicManagerJobDetails valueForKey:@"PaymentMode"]];
    _txtvJobDescription.text=[NSString stringWithFormat:@" %@",[dicManagerJobDetails valueForKey:@"JobDescription"]];
    _txtvJobDescription.userInteractionEnabled=YES;
    _txtvJobDescription.editable=NO;
    _txtvRemarks.userInteractionEnabled=YES;
    _txtvRemarks.editable=NO;
    _txtvwUserNote.userInteractionEnabled=YES;
    _txtvwUserNote.editable=NO;
    _txtTimeAllowance.text=[NSString stringWithFormat:@" %@:\t%@",_txtTimeAllowance.placeholder,[dicManagerJobDetails valueForKey:@"BookingAgentName"]];
    _txtJobPrice.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobPrice.placeholder,[GlobalDirector ReplaceStringNull:[dicManagerJobDetails valueForKey:@"JobPrice"]]];
    
    NSString *jobstatusShown=[NSString stringWithFormat:@"%@",([[dicManagerJobDetails valueForKey:@"JobStatus"]integerValue]>2&&[[dicManagerJobDetails valueForKey:@"JobStatus"]integerValue]!=12)?@"3":[dicManagerJobDetails valueForKey:@"JobStatus"]];
    
    if ([[dicManagerJobDetails valueForKey:@"FixedPrice"]integerValue]>0)
    {
        _txtJobPrice.frame=CGRectMake(CGRectGetMinX(_txtJobPrice.frame), CGRectGetMinY(_txtJobPrice.frame), CGRectGetWidth(_txtFirstName.frame)-CGRectGetWidth(_txtFixedPrice.frame)-2, CGRectGetHeight(_txtJobPrice.frame));
        _txtFixedPrice.hidden=NO;
        _txtFixedPrice.text=[NSString stringWithFormat:@"%@: \u00a3%.2f",_txtFixedPrice.placeholder,[[dicManagerJobDetails valueForKey:@"FixedPrice"] floatValue]];
    }
    else
    {
        _txtJobPrice.frame=CGRectMake(CGRectGetMinX(_txtJobPrice.frame), CGRectGetMinY(_txtJobPrice.frame), CGRectGetWidth(_txtFirstName.frame), CGRectGetHeight(_txtJobPrice.frame));
        _txtFixedPrice.hidden=YES;
    }
    
    if ([jobstatusShown isEqualToString:@"1"])
    {
        
        
        _txtJobStatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobStatus.placeholder,@"Booked"];
        _txtfdEnggEtATime.hidden = true;
        _txtfdManagerEtatime.hidden = true;
        CGRect oldTextfieldframe = _txtJobStatus.frame;
        
          oldTextfieldframe.origin.y = 324;
        CGRect oldTextfieldframe1 = _txtNatureOfJob.frame;
        oldTextfieldframe1.origin.y = 353;
        
        
    }
    else if ([jobstatusShown isEqualToString:@"2"])
    {
        
        
        _txtJobStatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobStatus.placeholder,@"Active"];
           
        _txtfdEnggEtATime.hidden = false;
        _txtfdManagerEtatime.hidden = false;
        
    }
    else if ([jobstatusShown isEqualToString:@"3"])
    {
        //_txtJobStatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobStatus.placeholder,@"Completed"];
        NSString *strComp = [GlobalDirector ReplaceStringNull:[dicManagerJobDetails valueForKey:@"SubStatusText"]];
        
        if (strComp.length>0) {
            strComp = [NSString stringWithFormat:@"Completed-%@",strComp];
            _txtJobStatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobStatus.placeholder,strComp];
        }else{
            
            _txtJobStatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobStatus.placeholder,@"Completed"];
        }
        
        
        
    }
    else if ([jobstatusShown isEqualToString:@"12"])
    {
        
        _txtJobStatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobStatus.placeholder,@"Cancelled"];
    }
    
    
    _btnChkAvl.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
    _btnChkAvl.titleLabel.shadowColor=[UIColor whiteColor];
    _btnChkAvl.layer.cornerRadius=CGRectGetHeight(_btnChkAvl.frame)/2.0f;
    [_btnChkAvl clipsToBounds];
    
    NSString *jobstatus=[NSString stringWithFormat:@"%@",[dicManagerJobDetails objectForKey:@"JobStatus"]];
    NSString *IsEngAccept=[NSString stringWithFormat:@"%@",[dicManagerJobDetails objectForKey:@"IsEngAccept"]];
    NSString *IsEngAssign=[NSString stringWithFormat:@"%@",[dicManagerJobDetails objectForKey:@"IsEngAssign"]];
    
    if ([jobstatus isEqualToString:@"1"])
    {
        btnAddFixedPrice.hidden=YES;
        
        if ([IsEngAccept isEqualToString:@"0"]&&[IsEngAssign isEqualToString:@"0"])
        {
            //Availability
        }
        else if ([IsEngAccept isEqualToString:@"1"]&&[IsEngAssign isEqualToString:@"0"])
        {
            //InvitedF
            
            [_btnChkAvl setBackgroundColor:[UIColor clearColor]];
            [_btnChkAvl setBackgroundImage:[UIImage imageNamed:@"checkavailable"] forState:UIControlStateNormal];
            [_btnChkAvl setTitle:@"Invited" forState:UIControlStateNormal];
            [_btnChkAvl setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _btnchkAvlCopy.hidden=NO;
        }
        else if ([IsEngAccept isEqualToString:@"2"]&&[IsEngAssign isEqualToString:@"0"])
        {
            //Ready to Assign
            
            [_btnChkAvl setBackgroundColor:[UIColor clearColor]];
            [_btnChkAvl setBackgroundImage:nil forState:UIControlStateNormal];
            [_btnChkAvl setTitle:@"Ready to Assign" forState:UIControlStateNormal];
            [_btnChkAvl setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _btnchkAvlCopy.hidden=NO;
            
            [UIView animateWithDuration:0.7 delay:0 options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction) animations:^{
                
                _btnChkAvl.layer.shadowColor = [UIColor grayColor].CGColor;
                _btnChkAvl.layer.shadowOpacity = 0.8;
                _btnChkAvl.layer.shadowRadius = 12;
                _btnChkAvl.layer.shadowOffset = CGSizeMake(12.0f, 12.0f);
                [_btnChkAvl setBackgroundColor:[UIColor colorWithRed:252/255.0f green:75/255.0f blue:9/255.0f alpha:1]];
            }
                             completion:^(BOOL finished){
                [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    [_btnChkAvl setBackgroundColor:[UIColor clearColor]];
                }completion:^(BOOL finished){
                }];
            }];
        }
        else if ([IsEngAssign isEqualToString:@"1"])
        {
            //Assigned
            
            [_btnChkAvl setBackgroundColor:[UIColor clearColor]];
            [_btnChkAvl setBackgroundImage:[UIImage imageNamed:@"allocated"] forState:UIControlStateNormal];
            [_btnChkAvl setTitle:@"Unassign" forState:UIControlStateNormal];
            [_btnChkAvl setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _btnChkAvl.userInteractionEnabled=YES;
            _btnChkAvl.hidden=NO;
        }
    }
    else if ([jobstatus isEqualToString:@"2"])
    {
        
        
        _btnChkAvl.hidden=YES;
    }
    
    
    // Cancel setting
    
    if ([jobstatusShown isEqualToString:@"12"])
    {
        _btnCancel.hidden=YES;
    }else
    {
        _btnCancel.hidden=NO;
        _btnCancel.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
        _btnCancel.titleLabel.shadowColor=[UIColor whiteColor];
        _btnCancel.layer.cornerRadius=CGRectGetHeight(_btnChkAvl.frame)/2.0f;
        [_btnCancel clipsToBounds];
        [_btnCancel setBackgroundColor:[UIColor redColor]];
        [_btnCancel setBackgroundImage:nil forState:UIControlStateNormal];
        [_btnCancel setTitle:@"Cancel Job" forState:UIControlStateNormal];
        [_btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnCancel.userInteractionEnabled=YES;
        
        
    }
    
    
    
    //------------------ Gas Certificate Available -----------------------------------------------------------
    NSLog(@"Gas Certificate Available :%@",[dicManagerJobDetails valueForKey:@"IsGasCertificateAvailable"]);
    NSInteger  isjobstatusNumber =[[dicManagerJobDetails objectForKey:@"JobStatus"] integerValue];
    NSString *strNatureofjob=[NSString stringWithFormat:@"%@",[dicManagerJobDetails objectForKey:@"NatureofJob"]];
    
    if(isjobstatusNumber==1)
    {
        _btnGasCertList.hidden=YES;
    }
    else
    {
        if ([strNatureofjob rangeOfString:[NSString stringWithFormat:@"%@",@"Gas"]].location != NSNotFound)
        {
            _btnGasCertList.hidden=NO;
        }
        else
        {
            _btnGasCertList.hidden=YES;
        }
        
    }
    
}



- (void)viewDidLayoutSubviews {
    [_scrolVw setContentSize:CGSizeMake(320,CGRectGetMaxY(_txtvRemarks.frame)+10)];
}



#pragma mark - ViewDidLoad Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    // _btnMap.hidden=YES;//rky
    self.navigationController.navigationBar.hidden = YES;
    app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    globe = [GlobalDirector SharedDirector];
    arrPQNotes=[[NSMutableArray alloc] init];

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
    Count=0;
    etaCount=0;
    
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
            
            UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,30)];
            leftView.backgroundColor = [UIColor clearColor];
            leftView.textAlignment=NSTextAlignmentLeft;
            txtfld.leftView = leftView;
            txtfld.leftViewMode = UITextFieldViewModeAlways;
            txtfld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            
        }
    }
    
    arrSelectedRecipients=[[NSMutableArray alloc]init];
    
    
    [self UpdateViewDidLoad];
    [self initializeTextFieldInputView];
    

    _txtfdManagerEtatime.hidden = true;
    CGRect oldTextfieldframe = _txtJobStatus.frame;
    
      oldTextfieldframe.origin.y = 324;
    [self Timepicker:nil];
    [self DatePicker:nil];
   
    
    NSDateFormatter *formatter;
    NSString        *timestring;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    timestring = [formatter stringFromDate:[NSDate date]];
    
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:timestring attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
        self->_txtfdsaveETAEnggTime.attributedPlaceholder = str2;
    
    

    
    [self GetSquareUpInvoiceID];
    
}



-(void)UpdateViewDidLoad{
    _btnChkAvl.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    _btnChkAvl.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _btnChkAvl.titleLabel.numberOfLines = 2;
    _btnChkAvl.titleLabel.textAlignment=NSTextAlignmentCenter;
    [_btnChkAvl.titleLabel sizeToFit];
    [_btnChkAvl clipsToBounds];
    
    arrMselectedFE=[[NSMutableArray alloc] init];
    
    NSString *jobstatus=[NSString stringWithFormat:@"%@",[dicManagerJobDetails objectForKey:@"JobStatus"]];
    NSString *IsEngAccept=[NSString stringWithFormat:@"%@",[dicManagerJobDetails objectForKey:@"IsEngAccept"]];
    NSString *IsEngAssign=[NSString stringWithFormat:@"%@",[dicManagerJobDetails objectForKey:@"IsEngAssign"]];
    
    
    DLog(@"jobstatus ::::::::::::::::::::::::::::::::::::::%@",jobstatus);
    DLog(@"IsEngAccept ::::::::::::::::::::::::::::::::::::::%@",IsEngAccept);
    DLog(@"IsEngAssign ::::::::::::::::::::::::::::::::::::%@",IsEngAssign);
    
    _btnShowTime.hidden=YES;
    _btnAddNote.hidden=YES;
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        
        
        _btnJobactivationbyEngineer.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:17.0];
        
        if ([jobstatus isEqualToString:@"1"])
        {
            btnAddFixedPrice.hidden=YES;
            _btnJobactivationbyEngineer.hidden=NO;
            [_vwBeforeAllocation setHidden:YES];
            [_vwAfterAllocation setHidden:YES];
            [self activeButton:nil];
        }
        else if([jobstatus isEqualToString:@"2"])
        {
            
            btnFinancial=[[UIButton alloc] init];
            _btnShowTime.hidden=NO;
            _btnAddNote.hidden=NO;
            _btnJobactivationbyEngineer.hidden=YES;
            [_vwBeforeAllocation setHidden:YES];
            [_vwAfterAllocation setHidden:NO];
            
            if ([[dicManagerJobDetails valueForKey:@"IsAgreementSign"]integerValue]>=1)
            {
                btnAddFixedPrice.hidden=NO;
                [self activeButton:nil];
            }
            else
            {
                btnAddFixedPrice.hidden=NO;
                [self activeButton:nil];
            }
            
            if ([[dicManagerJobDetails valueForKey:@"IsAgreementSign"]integerValue]==1)
            {
                if ([[dicManagerJobDetails valueForKey:@"FixedPrice"]integerValue]>0)
                {
                    [_btnAgrrement setTitle:@"Fixed Price Agreement" forState:UIControlStateNormal];
                    _btnAgrrement.hidden=NO;
                    [self activeButton:_btnAgrrement];
                }
                else
                {
                    _btnAgrrement.hidden=NO;
                    [self activeButton:btnFinancial];
                }
                
                
            }
            else if([[dicManagerJobDetails valueForKey:@"IsAgreementSign"]integerValue]==2)
            {
                _btnAgrrement.hidden=NO;
                [self activeButton:btnFinancial];
            }
            else
            {
                
                [_btnAgrrement setTitle:@"Small Repair Agreement" forState:UIControlStateNormal];
                _btnAgrrement.hidden=NO;
                [self activeButton:_btnAgrrement];
            }
            
        }
        else if ([jobstatus integerValue]>2)
        {
            
            _btnChkAvl.hidden=YES;
            btnAddFixedPrice.hidden=YES;
            _btnMap.hidden=YES;
            _btnShowTime.hidden=NO;
            _btnAddNote.hidden=NO;
            _btnJobactivationbyEngineer.hidden=YES;
            [_vwBeforeAllocation setHidden:YES];
            [_vwAfterAllocation setHidden:NO];
            CGRect scrlRect=_scrolVw.frame;
            scrlRect.size.height=scrlRect.size.height+40;
            [_scrolVw setFrame:scrlRect];
            
            [_btnCosts setTitle:@"Costs" forState:UIControlStateNormal];
            [_btnNotes setTitle:@"Notes" forState:UIControlStateNormal];
            [_btnMaterials setTitle:@"Materials" forState:UIControlStateNormal];
            
            btnFinancial=[[UIButton alloc] init];
            _btnAgrrement.hidden=NO;
            [self activeButton:btnFinancial];
            
            
        }
        
        if ([jobstatus integerValue]>1)
        {
//            _helpWidgetBtnJobDetail.hidden = YES;
            _btnMap.hidden=NO;
        }else{
            _btnMap.hidden=YES;
        }
        
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        
        
        if ([jobstatus intValue]>1) {
            _btnjobTypeSms.hidden=NO;
        }else{
            _btnjobTypeSms.hidden=YES;
        }
        
        _btnNotes.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:14.0];
        _btnMaterials.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:14.0];
        _btnCosts.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:14.0];
        _btnMap.hidden=YES;
        _btnJobactivationbyEngineer.hidden=YES;
        _btnAgrrement.hidden=YES;
        
        if ([jobstatus isEqualToString:@"1"]&&[IsEngAssign isEqualToString:@"1"])
        {
            
            _btnJobactivationbyEngineer.hidden=NO;
            [_vwBeforeAllocation setHidden:YES];
            [_vwAfterAllocation setHidden:YES];
            
            if ([[dicManagerJobDetails valueForKey:@"IsAgreementSign"]integerValue]>=1)
            {
                btnAddFixedPrice.hidden=NO;
                [self activeButton:nil];
            }
            else
            {
                btnAddFixedPrice.hidden=YES;
                [self activeButton:nil];
            }
            
        }
        else if ([jobstatus integerValue]==2)
        {
            btnFinancial=[[UIButton alloc]init];
            
            _btnChkAvl.hidden=NO;
            [_vwBeforeAllocation setHidden:YES];
            [_vwAfterAllocation setHidden:NO];
            _btnMap.hidden=NO;
//            _helpWidgetBtnJobDetail. = YES;
            btnAddFixedPrice.hidden=NO;
            
            if ([[dicManagerJobDetails valueForKey:@"IsAgreementSign"]integerValue]==1)
            {
                if ([[dicManagerJobDetails valueForKey:@"FixedPrice"]integerValue]>0)
                {
                    
                    [_btnAgrrement setTitle:@"Fixed Price Agreement" forState:UIControlStateNormal];
                    _btnAgrrement.hidden=NO;
                    [self activeButton:_btnAgrrement];
                }
                else
                {
                    _btnAgrrement.hidden=NO;
                    [self activeButton:btnFinancial];
                }
            }
            else if([[dicManagerJobDetails valueForKey:@"IsAgreementSign"]integerValue]==2)
            {
                _btnAgrrement.hidden=NO;
                [self activeButton:btnFinancial];
            }
            else
            {
                
                _btnAgrrement.hidden=NO;
                [_btnAgrrement setTitle:@"Small Repair Agreement" forState:UIControlStateNormal];
                [self activeButton:_btnAgrrement];
            }
        }
        else if ([jobstatus integerValue]==12)
        {
            _btnChkAvl.hidden=YES;
            btnAddFixedPrice.hidden=YES;
            _btnEditJOb.hidden=NO;
            
            [self activeButton:nil];
            
        }
        else if ([jobstatus integerValue]>2)
        {
            btnFinancial=[[UIButton alloc]init];
            
            _btnChkAvl.hidden=YES;
            btnAddFixedPrice.hidden=NO;
            _btnEditJOb.hidden=NO;
            [_vwBeforeAllocation setHidden:YES];
            [_vwAfterAllocation setHidden:NO];
            
            [self activeButton:btnFinancial];
            
        }else
        {
            [_vwAfterAllocation setHidden:NO];
            [self activeButton:nil];
        }
    }
    
    arrFeedTblPopup=[[NSMutableArray alloc]init];
    
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
    
    [_txtAddress.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_txtAddress.layer setBorderWidth: 0.5];
    [_txtAddress.layer setCornerRadius:0.0f];
    [_txtAddress.layer setMasksToBounds:YES];
    
    
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
    
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.barTintColor=[UIColor whiteColor];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           nil];
    [numberToolbar sizeToFit];
    
    
    
    
    NSArray *arr=[dicManagerJobDetails objectForKey:@"JobPeopleListResponse"];
    
    if (arr.count>0) {
        
        
        for ( NSDictionary *dic  in arr) {
            
            
            //  NSDictionary *dic = [arr objectAtIndex:0];
            
            if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==1 && [[dic valueForKey:@"CustID"]integerValue]>0) {
                [self performSelector:@selector(UpdateButton:) withObject:_btnOwner afterDelay:0.2];
                // [self btnOwnerTapped:_btnOwner];
                [self performSelector:@selector(btnOwnerTapped:) withObject:_btnOwner afterDelay:0.2];
            }else if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==2 && [[dic valueForKey:@"CustID"]integerValue]>0){
                [self performSelector:@selector(UpdateButton:) withObject:_btnTenant afterDelay:0.2];
                //  [self btnTenantTapped:_btnTenant];
                
                [self performSelector:@selector(btnTenantTapped:) withObject:_btnTenant afterDelay:0.2];
                
                
            }else if (([[dic valueForKey:@"TypeofCustomer"]integerValue]==3 || [[dic valueForKey:@"TypeofCustomer"]integerValue]==4 ) && [[dic valueForKey:@"CustID"]integerValue]>0){
                
                [self performSelector:@selector(UpdateButton:) withObject:_btnLandlord afterDelay:0.2];
                //  [self btnLandlordTapped:_btnLandlord];
                [self performSelector:@selector(btnLandlordTapped:) withObject:_btnLandlord afterDelay:0.2];
            }
        }
    }
    
    
    //  1 Owner
    //  2 Tenant
    //  3 Landlord
    //  4 Managing Agent
    
    
    
    [self btnJobAdressTapped:_btnJobAdress];
    
    
    
    
    
    
    
    
}


-(void)UpdateButton:(UIButton*)sender{
    
    [self animateToActiveButton:sender image:_selected];
}


-(void) GetSquareUpInvoiceID
{
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    [dict setObject:[GlobalDirector ReplaceStringNull:[dicManagerJobDetails valueForKey:@"JobID"]] forKey:@"jobId"];
    
    GlobalDirector *globe = [GlobalDirector SharedDirector];
    
    //  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [globe SyncRequestGet:REQUEST_GetSquareUpInvoiceID withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        NSLog(@"%@",result);
        
        // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            @try {
                
                BOOL strValue= [[result valueForKey:@"ResponseStatus"] intValue];
                
                if (strValue==1) {
                    
                    //[self showAlert:[GlobalDirector ReplaceStringNull:[result valueForKey:@"ReturnValue"]] withTitle:@"Success"];
                    
                }else{
                    //[self showAlert:[GlobalDirector ReplaceStringNull:[result valueForKey:@"ReturnValue"]] withTitle:@"Error!"];
                }
            } @catch (NSException *exception) {
                // _txtPost.text=@"";
                [self showAlert:@"There are some problem right now, try again later " withTitle:@"Sorry!"];
            }
        });
        
    }];
}

#pragma mark - People Related Button Press Method
- (IBAction)btnOwnerTapped:(UIButton *)sender
{
    _btnOwner.selected=YES;
    _btnLandlord.selected=NO;
    _btnTenant.selected=NO;
    _btnOwnerEmailSend.hidden=YES;
    _btnCall.hidden=YES;
    _btnMsg.hidden=YES;
    
    [self ResetFieldsFor:@"User"];
    
    NSArray *arr=[dicManagerJobDetails objectForKey:@"JobPeopleListResponse"];
    for (NSDictionary *dic in arr)
    {
        // DLog(@"%@",[dic valueForKey:@"TypeofCustomer"]);
        if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==1)
        {
            NSString *email = [GlobalDirector ReplaceStringNull:[dic valueForKey:@"EmailAddress"]];
            if (email.length>0)
            {
                _btnOwnerEmailSend.hidden=NO;
            }
            else
            {
                _btnOwnerEmailSend.hidden=YES;
            }
            
            NSString *contact = [GlobalDirector ReplaceStringNull:[dic valueForKey:@"ContactNumber"]];
            if (contact.length>0)
            {
                _btnCall.hidden=NO;
                _btnMsg.hidden=NO;
            }
            else
            {
                _btnCall.hidden=YES;
                _btnMsg.hidden=YES;
            }
            [self FetchUserDicValue:dic];
        }
    }
    [self animateToActiveButton:sender image:_selected];
}



- (IBAction)btnLandlordTapped:(UIButton *)sender
{
    _btnOwner.selected=NO;
    _btnLandlord.selected=YES;
    _btnTenant.selected=NO;
    _btnOwnerEmailSend.hidden=YES;
    _btnCall.hidden=YES;
    _btnMsg.hidden=YES;
    
    [self ResetFieldsFor:@"User"];
    NSArray *arr=[dicManagerJobDetails objectForKey:@"JobPeopleListResponse"];
    for (NSDictionary *dic in arr) {
        if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==3 || [[dic valueForKey:@"TypeofCustomer"]integerValue]==4) {
            
            NSString *email = [GlobalDirector ReplaceStringNull:[dic valueForKey:@"EmailAddress"]];
            
            if (email.length>0) {
                _btnOwnerEmailSend.hidden=NO;
            }else{
                _btnOwnerEmailSend.hidden=YES;
            }
            
            NSString *contact = [GlobalDirector ReplaceStringNull:[dic valueForKey:@"ContactNumber"]];
            
            if (contact.length>0) {
                _btnCall.hidden=NO;
                _btnMsg.hidden=NO;
            }else{
                _btnCall.hidden=YES;
                _btnMsg.hidden=YES;
            }
            
            
            
            
            [self FetchUserDicValue:dic];
        }
        
    }
    
    [self animateToActiveButton:sender image:_selected];
}



- (IBAction)btnTenantTapped:(UIButton *)sender
{
    [self animateToActiveButton:sender image:_selected];
    
    _btnOwner.selected=NO;
    _btnLandlord.selected=NO;
    _btnTenant.selected=YES;
    _btnOwnerEmailSend.hidden=YES;
    _btnCall.hidden=YES;
    _btnMsg.hidden=YES;
    
    [self ResetFieldsFor:@"User"];
    NSArray *arr=[dicManagerJobDetails objectForKey:@"JobPeopleListResponse"];
    for (NSDictionary *dic in arr) {
        if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==2) {
            
            
            NSString *email = [GlobalDirector ReplaceStringNull:[dic valueForKey:@"EmailAddress"]];
            
            if (email.length>0) {
                _btnOwnerEmailSend.hidden=NO;
            }else{
                _btnOwnerEmailSend.hidden=YES;
            }
            
            NSString *contact = [GlobalDirector ReplaceStringNull:[dic valueForKey:@"ContactNumber"]];
            
            if (contact.length>0) {
                _btnCall.hidden=NO;
                _btnMsg.hidden=NO;
            }else{
                _btnCall.hidden=YES;
                _btnMsg.hidden=YES;
            }
            
            
            
            [self FetchUserDicValue:dic];
        }
        
    }
    
    
}



-(void)animateToActiveButton:(UIButton *)btn image:(UIImageView*)img
{
    
    img.backgroundColor=[UIColor whiteColor];
    
    img.frame=btn.frame;
    
    [_scrolVw reloadInputViews];
    
}

#pragma mark - Address Related Button Press Method
- (IBAction)btnJobAdressTapped:(id)sender
{
    
    _lblAddress.text=@"  Job Address";
    
    _btnJobAdress.selected=YES;
    _btnLandlordAdress.selected=NO;
    _btnBillingAdress.selected=NO;
    [self ResetFieldsFor:@"Address"];
    
    NSArray *arr=[dicManagerJobDetails objectForKey:@"JobAddrListResponse"];
    
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
    NSArray *arr=[dicManagerJobDetails objectForKey:@"JobAddrListResponse"];
    for (NSDictionary *dic in arr) {
        if ([[dic valueForKey:@"TypeOfAddress"]integerValue]==2) {
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
    NSArray *arr=[dicManagerJobDetails objectForKey:@"JobAddrListResponse"];
    for (NSDictionary *dic in arr) {
        if ([[dic valueForKey:@"TypeOfAddress"]integerValue]==3) {
            [self FetchAddressDicValue:dic];
        }
    }
    
    [self animateToActiveButton:sender image:_selected2];
}

#pragma mark - Note / Material / Cost Press Method
- (IBAction)btnAddNoteOuterAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Gallery",@"Camera",nil];
    [actionSheet showInView:self.view];

}

- (IBAction)btnNotesTapped:(id)sender
{
    // NSMutableArray *arr=[dicManagerJobDetails valueForKey:@"JobNoteListResponse"];
    
    AddNotes *notes=[[AddNotes alloc]initWithNibName:@"AddNotes" bundle:nil];
    
    
    //notes.Notes=arr;
    notes.strHeading=@"Job Notes";
    notes.jobID=(NSString *)[dicManagerJobDetails valueForKey:@"JobID"];
    notes.jobStatus=(NSString *)[dicManagerJobDetails valueForKey:@"JobStatus"];
    notes.strFromCustomerClass=[NSString stringWithFormat:@"%@",[self class]];
    [self presentViewController:notes animated:YES completion:nil];
    
    //}
    
}
- (IBAction)btnMaterialsTapped:(id)sender
{
    // NSMutableArray *arr=[dicManagerJobDetails valueForKey:@"JobMaterialListResponse"];
    AddMaterials *materials=[[AddMaterials alloc]initWithNibName:@"AddMaterials" bundle:nil];
    
    
    // materials.Materials=arr;
    materials.strHeading=@"Job Materials";
    materials.jobID=(NSString *)[dicManagerJobDetails valueForKey:@"JobID"];
    materials.jobStatus=(NSString *)[dicManagerJobDetails valueForKey:@"JobStatus"];
    materials.strFromCustomerClass=[NSString stringWithFormat:@"%@",[self class]];
    [self presentViewController:materials animated:YES completion:nil];
    
    
    
    
}




- (IBAction)btnCostTapped:(id)sender
{
    
    // NSMutableArray *arr=[dicManagerJobDetails valueForKey:@"JobCostListResponse"];
    AddCostViewController *cost=[[AddCostViewController alloc]initWithNibName:@"AddcostViewController" bundle:nil];
    
    
    
    // cost.Costs=arr;
    cost.strHeading=@"Job Cost";
    cost.jobStatus=(NSString *)[dicManagerJobDetails valueForKey:@"JobStatus"];
    cost.jobID=(NSString *)[dicManagerJobDetails valueForKey:@"JobID"];
    cost.strFromCustomerClass=[NSString stringWithFormat:@"%@",[self class]];
    [self presentViewController:cost animated:YES completion:nil];
}

-(void)btnFinancialTapped:(id)sender
{
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        
        FinancialVC *financial = [[FinancialVC alloc]initWithNibName:@"FinancialVCEng" bundle:nil];
        financial.jobDic=dicManagerJobDetails;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:financial];
        if (@available(iOS 13.0, *)) {
            [nav setModalPresentationStyle: UIModalPresentationFullScreen];
         }
        [self presentViewController:nav animated:YES completion:nil];
        
        
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        
        
        FinancialVC *financial = [[FinancialVC alloc]initWithNibName:@"FinancialVC" bundle:nil];
        financial.jobDic=dicManagerJobDetails;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:financial];
        if (@available(iOS 13.0, *)) {
            [nav setModalPresentationStyle: UIModalPresentationFullScreen];
         }
        
        [self presentViewController:nav animated:YES completion:nil];
        
        
    }
    
}



- (IBAction)btnEditJobPressed:(id)sender
{
    
    
    
    
    CreateJobEng *createJob;
    CGSize screenSize=[[UIScreen mainScreen]bounds].size;
    
    DLog(@"%f",screenSize.height);
    
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        
        createJob=  [[CreateJobEng alloc]initWithNibName:@"CreateJobEng" bundle:nil];
        
    }
    
    else
    {
        
     
    }
    [createJob setIsJobEdited:YES];
    createJob.jobDic=dicManagerJobDetails;
    
    [self.navigationController pushViewController:createJob animated:YES];
    
    
    
    
}

-(void)FinancialDetailsAdded:(BOOL)isAdded{

    if (isAdded==YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            [self galleryBtnPressed];
        }
            break;
        case 1:
        {
            [self cameraBtnPressed];
        }
            break;
            
        default:
            break;
    }
}

- (void)galleryBtnPressed
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


- (void)cameraBtnPressed
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIIMagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
   // [imageButton setImage:chosenImage forState:UIControlStateNormal];
    [self saveNoteOuter:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [self dismissViewControllerAnimated:YES completion:nil];

}


-(void)saveNoteOuter:(UIImage *)selectedimage
{
        dicNotes=[[NSMutableDictionary alloc]init];
        newNotes=[[NSMutableArray alloc]init];

        NSString* encodedImageString,*base64String;
        encodedImageString=@"";
        NSMutableArray *arrImageSrtrings=[[NSMutableArray alloc]init];
        
            NSData *imageData = UIImageJPEGRepresentation(selectedimage, 1.0);
            base64String = [imageData base64EncodedStringWithOptions:0];
            encodedImageString = [base64String stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
            [arrImageSrtrings addObject:encodedImageString];
        
      
        NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];

        [dicNotes setObject:[userdetails valueForKey:@"FullName"] forKey:@"CreatedBy"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss a"];
        [dicNotes setObject:[NSString stringWithFormat:@"%@",[dateFormat stringFromDate:[NSDate date]]] forKey:@"CreatedDate"];
        [dicNotes setObject:@"Engineer pic added" forKey:@"NoteBody"];
        [dicNotes setObject:[NSString stringWithFormat:@"false"] forKey:@"IsPreviousJobNote"];
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
        {
            [dicNotes setObject:[NSString stringWithFormat:@"1"] forKey:@"NoteTypeID"];
            [dicNotes setObject:[NSString stringWithFormat:@"Customer"] forKey:@"DisplayTextNoteType"];
            
        }
        else{
            [dicNotes setObject:@"63" forKey:@"NoteTypeID"];
            [dicNotes setObject:@"Engineers Pic" forKey:@"DisplayTextNoteType"];

        }
        
        [dicNotes setObject:arrImageSrtrings forKey:@"imageUpload"];
        [dicNotes setObject:@"jpg" forKey:@"imageextension"];
       // DLog(@"%@",base64String);
        Notes = [Notes mutableCopy];
      //  [Notes addObject:dicNotes];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"CreatedDate" ascending: NO];
        NSArray *arr = [Notes sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        Notes = [arr mutableCopy];
        
        newNotes=[Notes mutableCopy];
        NSString *strFromCustomerClass  = [NSString stringWithFormat:@"%@",[self class]];
        
        if ([strFromCustomerClass isEqualToString:@"ManagerJobDetails"] || [strFromCustomerClass isEqualToString:@"Customer_EngineerJobDetails"])
        {
            
            if ([self InternetConnectionAvailable]==YES) {
                
            NSError *error;
            
            NSArray *arrDic=[NSArray arrayWithObjects:dicNotes, nil];
            
            NSData *jsonAddress = [NSJSONSerialization dataWithJSONObject:arrDic
                                                                  options:0
                                                                    error:&error];
            NSString *note = [[NSString alloc] initWithBytes:[jsonAddress bytes] length:[jsonAddress length] encoding:NSUTF8StringEncoding];
            
            NSString *urlStr=[NSString stringWithFormat:@"%sSetJobNote",conn_url];
    
           
            NSString *json;
            NSError *jsonError;
            
            
            NSMutableData *body = [NSMutableData data];
            NSDictionary *_params=[[NSDictionary alloc]initWithObjects:@[(NSString *)[userdetails valueForKey:@"UserToken"],(NSString *)[userdetails valueForKey:@"UserID"],(NSString *)[dicManagerJobDetails valueForKey:@"JobID"],note] forKeys:@[@"userToken",@"userId",@"jobId",@"note"]];
                
                NSLog(@"_params%@",_params);
                NSLog(@"urlStr%@",urlStr);

                
                ///only testing
                NSData *noteData = [NSJSONSerialization dataWithJSONObject:_params
                                                                      options:0
                                                                        error:&error];
                NSString *noteTest = [[NSString alloc] initWithBytes:[noteData bytes] length:[noteData length] encoding:NSUTF8StringEncoding];

                NSLog(@"%@",noteTest);
                //******
            
           NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
           // DLog(@"request :%@",request);
            NSData *reqData=[NSData dataWithBytes:[json UTF8String] length:[json length]];
            
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%ld",(unsigned long)[reqData length]] forHTTPHeaderField:@"Content-Length"];
            request.timeoutInterval = 300;
            //[request setHTTPBody:reqData];
            NSData *postData = [NSJSONSerialization dataWithJSONObject:_params options:0
                                                                 error:&jsonError];
                
                
                
            if (!jsonError)
            {
                //set POST body
                [request setHTTPBody:postData];
            }
      
                
            // set the content-length
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            
            // set URL
            [request setURL:[NSURL URLWithString:urlStr]];
            
            connPostNote = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [connPostNote start];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            }
            else
            {
                [self showAlert:@"Network connection not available" withTitle:@"Connection Problem!"];
            }
        }
     
        else
        {
//             [Notes addObject:dicNotes];
//            newNotes=[Notes mutableCopy];
//            [mainBg removeFromSuperview];
//            [_tabvNotes reloadData];
//            txtNoteTo.text=@"";
//            txtNoteType.text=@"";
//            txtvNoteBody.text=@"";
//            [self btnNewNotesTapped:nil];
        }
}

#pragma mark- Customer Phone Call Method
- (IBAction)btnShowTimeAction:(id)sender {
    ShowTimeVC *showTime = [[ShowTimeVC alloc] initWithNibName: @"ShowTimeVC" bundle: nil];
    showTime.jobID = (NSString *)[dicManagerJobDetails valueForKey:@"JobID"];
    [self.navigationController pushViewController:showTime animated:YES];
}

- (IBAction)callCustomer:(id)sender {

    UIDevice *device = [UIDevice currentDevice];
    if (![[device model] isEqualToString:@"iPhone Simulator"])
    {
        NSString *strPhoneNo=_txtContactNo.text;
        NSString *cleanedString = [[strPhoneNo componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cleanedString]];
        
        DLog(@"MOBILE++++++++++++++++++%@",strPhoneNo);
        [[UIApplication sharedApplication] openURL:telURL];
    }
    else
    {
        [self showAlert:@"Your device doesn't support this feature." withTitle:@""];
        
    }
}

#pragma mark- Customer Email Send Method
-(IBAction)pressOwnerEmailSend:(id)sender
{
    NSLog(@"Owner Email Method: %@",_txtEmail.text);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString;
    urlString=[NSString stringWithFormat:@"%sSendMailJobDetail?userToken=%@&jobID=%@&userid=%@&mailTo=%@&userType=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[dicManagerJobDetails valueForKey:@"JobID"],(NSString *)[user valueForKey:@"UserID"],_txtEmail.text,@"customer"];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSLog(@"urlString :%@",urlString);
    
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
    
    connSendMessageOwner = [[NSURLConnection alloc]init];
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        DLog(@"PostString=%@",urlString);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error==nil) {
                _responseData=[data mutableCopy];
                [self connectionDidFinishLoading:connSendMessageOwner];
            }
            else
            {
                
            }
            
        });
        
    }];
    
    
}




#pragma mark - Euro Signed Press Method
-(IBAction)poundSignTapped:(id)sender
{
    
    bgVw =[[UIControl alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [bgVw addTarget:self action:@selector(bgPopupTouched:) forControlEvents:UIControlEventTouchUpInside];
    bgVw.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.5f];
    
    popUpVW=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 280, 140)];
    popUpVW.layer.cornerRadius=6.0f;
    popUpVW.backgroundColor=[UIColor whiteColor];
    popUpVW.center=bgVw.center;
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
       
        
        NSString *jobstatus=[NSString stringWithFormat:@"%@",[dicManagerJobDetails objectForKey:@"JobStatus"]];
        if (![jobstatus isEqualToString:@"3"])
        {
            
            UIButton *btnAddFIxedPrice=[UIButton buttonWithType:UIButtonTypeCustom];
            btnAddFIxedPrice.frame=CGRectMake(20,CGRectGetHeight(popUpVW.frame)/2.0f+10,240,40);
            [btnAddFIxedPrice setTitle:@"Add Fixed Price" forState:UIControlStateNormal];
            if ([[dicManagerJobDetails valueForKey:@"FixedPrice"]integerValue]>0)
            {
                
                [btnAddFIxedPrice setTitle:@"Edit fixed Price" forState:UIControlStateNormal];
            }
            [btnAddFIxedPrice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnAddFIxedPrice.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:16.0];
            [btnAddFIxedPrice setBackgroundColor:[UIColor colorWithRed:82/255.0 green:30/255.0 blue:135/255.0 alpha:1.0]];
            [btnAddFIxedPrice addTarget:self action:@selector(addFixedPrice:) forControlEvents:UIControlEventTouchUpInside];
            
            [btnAddFIxedPrice.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
            [btnAddFIxedPrice.layer setBorderWidth: 0.5];
            [btnAddFIxedPrice.layer setCornerRadius:0.0f];
            [btnAddFIxedPrice.layer setMasksToBounds:YES];
            btnAddFIxedPrice.userInteractionEnabled=YES;
            btnAddFIxedPrice.alpha = 1.0;
            [popUpVW addSubview:btnAddFIxedPrice];
        }
        
        UIButton *btnGenerateInvoice=[UIButton buttonWithType:UIButtonTypeCustom];
        btnGenerateInvoice.frame=CGRectMake(20,CGRectGetHeight(popUpVW.frame)/2.0f-40,240,40);
        if ([jobstatus isEqualToString:@"3"])
        {
            
            [btnGenerateInvoice setTitle:@"Edit/Regenerate Invoice" forState:UIControlStateNormal];
        }
        else
        {
            
            [btnGenerateInvoice setTitle:@"Generate Invoice" forState:UIControlStateNormal];
        }
        [btnGenerateInvoice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnGenerateInvoice.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:16.0];
        [btnGenerateInvoice setBackgroundColor:[UIColor colorWithRed:30/255.0 green:124/255.0 blue:41/255.0 alpha:1.0]];
        [btnGenerateInvoice addTarget:self action:@selector(agreementPress:) forControlEvents:UIControlEventTouchUpInside];
        btnGenerateInvoice.tag=999;
        
        [btnGenerateInvoice.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [btnGenerateInvoice.layer setBorderWidth: 0.5];
        [btnGenerateInvoice.layer setCornerRadius:0.0f];
        [btnGenerateInvoice.layer setMasksToBounds:YES];
        
        UIButton *btncross=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        btncross.center=CGPointMake(CGRectGetMaxX(popUpVW.frame), CGRectGetMinY(popUpVW.frame));
        btncross.backgroundColor=[UIColor clearColor];
        [btncross setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
        [btncross clipsToBounds];
        [btncross addTarget:self action:@selector(bgPopupTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [popUpVW addSubview:btnGenerateInvoice];
        
        [bgVw addSubview:popUpVW];
        [bgVw addSubview:btncross];
        [self.view addSubview:bgVw];
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        
        UIButton *btnGenerateInvoice=[UIButton buttonWithType:UIButtonTypeCustom];
        btnGenerateInvoice.frame=CGRectMake(20,CGRectGetHeight(popUpVW.frame)/2.0f-40,240,40);
        [btnGenerateInvoice setTitle:@"Generate Invoice" forState:UIControlStateNormal];
        [btnGenerateInvoice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnGenerateInvoice.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:16.0];
        [btnGenerateInvoice setBackgroundColor:[UIColor colorWithRed:30/255.0 green:124/255.0 blue:41/255.0 alpha:1.0]];
        [btnGenerateInvoice addTarget:self action:@selector(agreementPress:) forControlEvents:UIControlEventTouchUpInside];
        btnGenerateInvoice.tag=999;
        
        [btnGenerateInvoice.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [btnGenerateInvoice.layer setBorderWidth: 0.5];
        [btnGenerateInvoice.layer setCornerRadius:0.0f];
        [btnGenerateInvoice.layer setMasksToBounds:YES];
        
        UIButton *btncross=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        btncross.center=CGPointMake(CGRectGetMaxX(popUpVW.frame), CGRectGetMinY(popUpVW.frame));
        btncross.backgroundColor=[UIColor clearColor];
        [btncross setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
        [btncross clipsToBounds];
        [btncross addTarget:self action:@selector(bgPopupTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [popUpVW addSubview:btnGenerateInvoice];
        [bgVw addSubview:popUpVW];
        [bgVw addSubview:btncross];
        [self.view addSubview:bgVw];
    }
}




-(IBAction)addFixedPrice:(id)sender
{
    
    [self bgPopupTouched:nil];
    
    bgVw =[[UIControl alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [bgVw addTarget:self action:@selector(bgPopupTouched:) forControlEvents:UIControlEventTouchUpInside];
    bgVw.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.5f];
    
    popUpVW=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 280,290)];
    popUpVW.alpha=0.0f;
    popUpVW.layer.cornerRadius=6.0f;
    popUpVW.backgroundColor=[UIColor whiteColor];
    popUpVW.center=bgVw.center;
    
    
    txtSubtotalValue=[[UITextField alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(txtEnggCommision.frame)+30,240,30)];
    txtSubtotalValue.textColor=[UIColor darkGrayColor];
    txtSubtotalValue.textAlignment=NSTextAlignmentLeft;
    txtSubtotalValue.userInteractionEnabled=YES;
    txtSubtotalValue.delegate=self;
    txtSubtotalValue.placeholder=@"  Enter Subtotal value";
    
    if ([[dicManagerJobDetails valueForKey:@"FixedPrice"]integerValue]>0) {
        txtSubtotalValue.text=[NSString stringWithFormat:@"%.2f",[[dicManagerJobDetails valueForKey:@"FixedPrice"] floatValue]];
        subtotalValueFixed = [[NSString stringWithFormat:@"%@",[dicManagerJobDetails valueForKey:@"FixedPrice"]] floatValue];
    }
    
    txtSubtotalValue.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    [txtSubtotalValue setBorderStyle:UITextBorderStyleNone];
    txtSubtotalValue.layer.borderWidth=0.5f;
    txtSubtotalValue.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    txtSubtotalValue.layer.cornerRadius=0.0f;
    txtSubtotalValue.backgroundColor=[UIColor whiteColor];
    txtSubtotalValue.keyboardType=UIKeyboardTypeDecimalPad;
    txtSubtotalValue.inputAccessoryView=numberToolbar;
    
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(10,0,19,30)];
    leftView.backgroundColor = [UIColor clearColor];
    leftView.textAlignment=NSTextAlignmentLeft;
    leftView.text=@" \u00a3 ";
    txtSubtotalValue.leftView = leftView;
    txtSubtotalValue.leftViewMode = UITextFieldViewModeAlways;
    txtSubtotalValue.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(txtSubtotalValue.frame)+30,240,30)];
    lblTitle.text = @" Fixed Price Note";
    lblTitle.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.backgroundColor =[UIColor colorWithRed:52/255.0 green:54/255.0 blue:67/255.0 alpha:0.72];
    [lblTitle.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [lblTitle.layer setBorderWidth: 0.5];
    [lblTitle.layer setCornerRadius:0.0f];
    [lblTitle.layer setMasksToBounds:YES];
    
    txtvNoteBodyPriceQoute = [[UITextView alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(lblTitle.frame)+20,240,90)];
    txtvNoteBodyPriceQoute.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    txtvNoteBodyPriceQoute.textColor=[UIColor darkGrayColor];
    [txtvNoteBodyPriceQoute setBackgroundColor:[UIColor whiteColor]];
    txtvNoteBodyPriceQoute.delegate = self;
    [txtvNoteBodyPriceQoute.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [txtvNoteBodyPriceQoute.layer setBorderWidth: 0.5];
    [txtvNoteBodyPriceQoute.layer setCornerRadius:0.0f];
    [txtvNoteBodyPriceQoute.layer setMasksToBounds:YES];
    
    
    if ([dicManagerJobDetails valueForKey:@"JobTotalNote"]&&[[dicManagerJobDetails valueForKey:@"FixedPrice"]integerValue]!=0) {
        
        txtvNoteBodyPriceQoute.text=[[dicManagerJobDetails valueForKey:@"JobTotalNote"]isKindOfClass:[NSNull class]]?@"":[NSString stringWithFormat:@"%@",[dicManagerJobDetails valueForKey:@"JobTotalNote"]];
    }
    
    
    UIButton *btncross=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    btncross.center=CGPointMake(CGRectGetMaxX(popUpVW.frame), CGRectGetMinY(popUpVW.frame));
    btncross.backgroundColor=[UIColor clearColor];
    [btncross setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
    [btncross clipsToBounds];
    [btncross addTarget:self action:@selector(bgPopupTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnSave=[UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.frame=CGRectMake(0,CGRectGetHeight(popUpVW.frame)-40,280,40);
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSave.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:18.0];
    [btnSave setBackgroundColor:[UIColor colorWithRed:30/255.0 green:124/255.0 blue:41/255.0 alpha:1.0]];
    [btnSave addTarget:self action:@selector(SaveFixedPrice:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnSave.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [btnSave.layer setBorderWidth: 1.0];
    [btnSave.layer setCornerRadius:0.0f];
    [btnSave.layer setMasksToBounds:YES];
    
    [popUpVW addSubview:lblTitle];
    [popUpVW addSubview:txtvNoteBodyPriceQoute];
    [popUpVW addSubview:txtSubtotalValue];
    [popUpVW addSubview:btnSave];
    [bgVw addSubview:popUpVW];
    [bgVw addSubview:btncross];
    
    [UIView animateWithDuration:0.4 animations:^{
        popUpVW.alpha=1.0f;
        [self.view addSubview:bgVw];
    }];
    
}




-(IBAction)SaveFixedPrice:(id)sender
{
    
    
    if ([txtvNoteBodyPriceQoute.text length]==0)
    {
        [self showAlert:@"Please enter price Quote description." withTitle:@""];
        
    }
    else if (subtotalValueFixed != [[dicManagerJobDetails valueForKey:@"FixedPrice"]floatValue]||![txtvNoteBodyPriceQoute.text isEqualToString:[NSString stringWithFormat:@"%@",[dicManagerJobDetails valueForKey:@"JobTotalNote"]]])
    {
        NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
        
        [MBProgressHUD showHUDAddedTo:popUpVW animated:YES];
        
        NSString *urlString;
        NSString *post =[NSString stringWithFormat:@""];
        NSString *selectedEnggIds=[[arrSelectedRecipients valueForKey:@"Value"] componentsJoinedByString:@","];;
        DLog(@"%@",selectedEnggIds);
        
        urlString=[NSString stringWithFormat:@"%sManagerSetFixedPrice?userToken=%@&jobID=%@&userId=%@&comissionId=%ld&subTotal=%@&note=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],[dicManagerJobDetails valueForKey:@"JobID"],(NSString *)[user valueForKey:@"UserID"],(long)txtEnggCommision.tag,txtSubtotalValue.text,txtvNoteBodyPriceQoute.text];
        
        urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"GET"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        request.timeoutInterval = 300;
        
        connSaveFixedPrice = [[NSURLConnection alloc]init];
        
        [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
            
            DLog(@"PostString=%@",urlString);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error==nil) {
                    self->_responseData=[data mutableCopy];
                    [self connectionDidFinishLoading:self->connSaveFixedPrice];
                    
                    NSString *Count = @"ndata";
                    
                    [[NSUserDefaults standardUserDefaults] setObject:Count forKey:@"StringCount"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    
                }
                
            });
            
        }];
        
        
        
    }
}

#pragma mark - Job People Data Fetch Method
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
    if (![[dic valueForKey:@"EmailAddress"]isEqualToString:@""])
    {
        _txtEmail.text=[dic valueForKey:@"EmailAddress"];
    }
    else
    {
    }
    
    if (![[dic valueForKey:@"ContactNumber"]isEqualToString:@""]) {
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
        {
            
            _txtContactNo.text=[dic valueForKey:@"ContactNumber"];
        }
        else
        {
            
        }
        
        
    }
    if (![[dic valueForKey:@"Notes"]isEqualToString:@""]) {
        _txtvwUserNote.text=[dic valueForKey:@"Notes"];
        
    }
    
    
}


#pragma mark - Reset Job address/people Data  Method
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
        _txtAdressContactNo.text=@"";
        _txtvRemarks.text=@"";
        
    }
    
}



#pragma mark - Job Address Data Fetch Method
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
        
        
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
        {
            
            _txtAdressContactNo.text=[dic valueForKey:@"ContactNo"];
        }
        else
        {
        }
        
        
        
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



#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
    
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *FetchKey;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if (connection==connAvailableEngg)
    {
        FetchKey=@"AvailableEngineerList";
        
    }
    else if (connection==connRequestedFE)
    {
        FetchKey=@"InvitedEngineerList";
        
    }
    else if (connection==connEnggSendMail)
    {
        
    }
    else if (connection==connSendMessage)
    {
        
    }
    else if (connection==connSendMessageOwner)
    {
        
    }
    else if(connection==connActivateJobbyengineer)
    {
        NSArray *arr=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrEditedJobDic"];
        NSMutableArray *mutableCopy=[arr mutableCopy];
        if (mutableCopy==nil) {
            mutableCopy=[[NSMutableArray alloc]init];
        }
        
        [mutableCopy addObject:[dicManagerJobDetails valueForKey:@"JobID"]];
        [[NSUserDefaults standardUserDefaults]setObject:mutableCopy forKey:@"arrEditedJobDic"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [app UpdateEngineerLocation];
    }
    
    NSMutableDictionary* temp;
    if (_responseData !=nil)
    {
        NSString* newStr = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
        DLog(@"Response String :::::%@",newStr);
        NSError *error;
        temp = [NSJSONSerialization JSONObjectWithData:_responseData  options:NSJSONReadingMutableContainers error:&error];
        
        if (!error)
        {
            if ([[temp valueForKey:@"ResponseStatus"]boolValue]==true)
            {
                id jobs=[temp valueForKey:FetchKey];
                
                if ([jobs isKindOfClass:[NSArray class]]&&(connection==connAvailableEngg||connection==connRequestedFE))
                {
                    txtTimeAllowancedropdown.hidden=NO;
                    arrMFE=jobs;
                }
                if (connection==connEnggSelection)
                {
                    //------ allocation .invitation -----
                    if ([strAfterallocated isEqualToString:@"1"])
                    {
                        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @""
                                                                                            message:@"Engineer assigned"
                                                                                     preferredStyle: UIAlertControllerStyleAlert];
                        
                        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                                              style: UIAlertActionStyleDestructive
                                                                            handler: ^(UIAlertAction *action) {
                            DLog(@"Dismiss button tapped!");
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                        
                        [controller addAction: alertAction];
                        
                        [self presentViewController: controller animated: YES completion: nil];
                        
                        [blinkTimer invalidate];
                    }
                    else
                    {
                        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @""
                                                                                            message:@"Request sent successfully"
                                                                                     preferredStyle: UIAlertControllerStyleAlert];
                        
                        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                                              style: UIAlertActionStyleDestructive
                                                                            handler: ^(UIAlertAction *action) {
                            DLog(@"Dismiss button tapped!");
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                        
                        [controller addAction: alertAction];
                        
                        [self presentViewController: controller animated: YES completion: nil];
                        
                    }
                    
                    
                    
                    NSArray *arr=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrEditedJobDic"];
                    NSMutableArray *mutableCopy=[arr mutableCopy];
                    if (mutableCopy==nil) {
                        mutableCopy=[[NSMutableArray alloc]init];
                    }
                    
                    [mutableCopy addObject:[dicManagerJobDetails valueForKey:@"JobID"]];
                    [[NSUserDefaults standardUserDefaults]setObject:mutableCopy forKey:@"arrEditedJobDic"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    
                    
                    
                }
                else if (connection==connEnggSendMail)
                {
                    [self showAlert:[temp valueForKey:@"ResponseMessages"]  withTitle:@""];
                    
                }
                else if (connection==connSendMessageOwner)
                {
                    [self showAlert:[temp valueForKey:@"ResponseMessages"]  withTitle:@""];
                }
                else if (connection==connSendMessage)
                {
                    [self showAlert:@" Message sent " withTitle:nil];
                    [mainBgmssg removeFromSuperview];
                }
                else if (connection==connActivateJobbyengineer)
                {
                    NSArray *arr=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrEditedJobDic"];
                    NSMutableArray *mutableCopy=[arr mutableCopy];
                    if (mutableCopy==nil) {
                        mutableCopy=[[NSMutableArray alloc]init];
                    }
                    
                    [mutableCopy addObject:[dicManagerJobDetails valueForKey:@"JobID"]];
                    [[NSUserDefaults standardUserDefaults]setObject:mutableCopy forKey:@"arrEditedJobDic"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    if(etaCount==0)
                    {
        
                        etaCount=1;
                    }
                    else
                    {

                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }
                }
                else if (connection==connSaveFixedPrice)
                {
                    NSArray *arr=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrEditedJobDic"];
                    NSMutableArray *mutableCopy=[arr mutableCopy];
                    if (mutableCopy==nil) {
                        mutableCopy=[[NSMutableArray alloc]init];
                    }
                    
                    [mutableCopy addObject:[dicManagerJobDetails valueForKey:@"JobID"]];
                    [[NSUserDefaults standardUserDefaults]setObject:mutableCopy forKey:@"arrEditedJobDic"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                 
                        [self.navigationController popViewControllerAnimated:YES];
                     
                    
                }
                [MBProgressHUD hideAllHUDsForView:popUpVW animated:YES];
                
            }
            else
            {
                if (connection==connSendMessage)
                {
                    [self showAlert:[temp valueForKey:@"ResponseMessages"] withTitle:@""];
                    [mainBgmssg removeFromSuperview];
                }
                
                if (connection==connEnggSelection)
                {
                    //------ allocation .invitation -----
                    if ([strAfterallocated isEqualToString:@"1"])
                    {
                        [self showAlert:@"Please try assign later." withTitle:@""];
                        
                        [blinkTimer invalidate];
                    }
                    else
                    {
                        [self showAlert:@"Please try to send request later." withTitle:nil];
                        
                    }
                }
                else if (connection == connPostNote){
                    
                }
                else
                {
                    DLog(@"JSONObjectWithData error: %@", error);
                    [self showAlert:@"No jobs there." withTitle:nil];
                    
                }
            }
        }
        else
        {
            DLog(@"%@",error);
        }
        
    }
    else
    {
        
    }
    if (_btnChkAvl.isSelected==YES)
    {
        [self ShowAvailableEnggFromSender:_btnChkAvl];
    }
    else if (_btnchkAvlCopy.isSelected==YES)
    {
        [self ShowAvailableEnggFromSender:_btnchkAvlCopy];
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    // [[[UIAlertView alloc]initWithTitle:@"Error" message:@"No network connection. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
    
    [self showAlert:@"No network connection. Please try again later."  withTitle:@"Error"];
    
}

-(IBAction)backPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - Available Engineer WebService Method
-(void)fetchAllFE
{
    
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    DLog(@"%@",user);
    
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString=[NSString stringWithFormat:@"%sAvailableEngineer?userToken=%@&jobID=%@&startDate=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[dicManagerJobDetails valueForKey:@"JobID"],(NSString *)[dicManagerJobDetails valueForKey:@"JobStartDate"]];
    
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    request.timeoutInterval = 300;
    DLog(@"PostString=%@",request);
    
    connAvailableEngg = [[NSURLConnection alloc]init];
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        
        DLog(@"PostString=%@",urlString);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error==nil) {
                _responseData=[data mutableCopy];
                [self connectionDidFinishLoading:connAvailableEngg];
            }
            else
            {
                
            }
            
        });
        
    }];
    
    
}


#pragma mark - Invited Engineer WebService Method
-(void)FetchInvitedEngg
{
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    //DLog(@"%@",user);
    
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString=[NSString stringWithFormat:@"%sInvitedEngineer?userToken=%@&jobID=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[dicManagerJobDetails valueForKey:@"JobID"]];
    
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    request.timeoutInterval = 300;
    DLog(@"PostString=%@",request);
    
    connRequestedFE = [[NSURLConnection alloc] init];
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        
        DLog(@"PostString=%@",urlString);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error==nil) {
                _responseData=[data mutableCopy];
                [self connectionDidFinishLoading:connRequestedFE];
            }
            else
            {
                
            }
            
        });
        
    }];
    
    //[connRequestedFE start];
}




#pragma mark - Check Available Button Press Method
- (IBAction)btnchkAvailTapped:(UIButton *)sender
{
    DLog(@"Button clicked:%@",sender.titleLabel.text);
    
    if (sender.tag==101) {
        isCancel=YES;
    }else{
        isCancel=NO;
    }
    
    if ([sender.titleLabel.text isEqualToString:@"Unassign"]||[sender.titleLabel.text isEqualToString:@"Cancel Job"])
    {
        DLog(@"Button clicked:%@",sender.titleLabel.text);
        [self showUnassignedPopUp];
    }
    else
    {
        bgVw =[[UIControl alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        bgVw.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.5f];
        
        
        popUpVW=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 280, 340)];
        popUpVW.alpha=0.0f;
        popUpVW.layer.cornerRadius=0.0f;
        popUpVW.backgroundColor=[UIColor whiteColor];
        popUpVW.layer.borderWidth=0.5f;
        popUpVW.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        popUpVW.center=bgVw.center;
        
        //------------ Time allowance dropdown ------------------------
        UIButton *btnDropdown=[[UIButton alloc]initWithFrame:CGRectMake(145,0, 35, 30)];
        btnDropdown.backgroundColor=[UIColor clearColor];
        [btnDropdown setBackgroundImage:[UIImage imageNamed:@"dropdown"] forState:UIControlStateNormal];
        txtTimeAllowancedropdown=[[UITextField alloc]initWithFrame:CGRectMake(55,13,180,30)];
        txtTimeAllowancedropdown.textColor=[UIColor darkGrayColor];
        txtTimeAllowancedropdown.textAlignment=NSTextAlignmentLeft;
        txtTimeAllowancedropdown.userInteractionEnabled=YES;
        txtTimeAllowancedropdown.delegate=self;
        txtTimeAllowancedropdown.placeholder=@"  Booked agent";
        txtTimeAllowancedropdown.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
        [txtTimeAllowancedropdown setBorderStyle:UITextBorderStyleNone];
        txtTimeAllowancedropdown.layer.borderWidth=0.5f;
        txtTimeAllowancedropdown.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        txtTimeAllowancedropdown.layer.cornerRadius=0.0f;
        txtTimeAllowancedropdown.backgroundColor=[UIColor whiteColor];
        txtTimeAllowancedropdown.hidden=YES;
        
        //------------------------------------------------
        _activity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activity.color=[UIColor blackColor];
        _activity.center=CGPointMake(CGRectGetWidth(popUpVW.frame)/2.0f, CGRectGetHeight(popUpVW.frame)/2.0f);
        [popUpVW addSubview:_activity];
        [_activity startAnimating];
        
        
        NSString *jobstatus=[NSString stringWithFormat:@"%@",[dicManagerJobDetails objectForKey:@"JobStatus"]];
        NSString *IsEngAccept=[NSString stringWithFormat:@"%@",[dicManagerJobDetails objectForKey:@"IsEngAccept"]];
        NSString *IsEngAssign=[NSString stringWithFormat:@"%@",[dicManagerJobDetails objectForKey:@"IsEngAssign"]];
        
        
        if (sender==_btnchkAvlCopy) {
            [txtTimeAllowancedropdown addSubview:btnDropdown];
            [popUpVW addSubview:txtTimeAllowancedropdown];
            
            _btnchkAvlCopy.selected=YES;
            _btnChkAvl.selected=NO;
            
            [self fetchAllFE];
            
        }
        
        else if (sender==_btnChkAvl)
        {
            _btnchkAvlCopy.selected=NO;
            _btnChkAvl.selected=YES;
            
            if ([jobstatus isEqualToString:@"1"])
            {
                //Booked / Avialability
                if ([IsEngAssign isEqualToString:@"0"] &&([IsEngAccept isEqualToString:@"0"]||[IsEngAccept isEqualToString:@"3"]))
                {
                    [txtTimeAllowancedropdown addSubview:btnDropdown];
                    [popUpVW addSubview:txtTimeAllowancedropdown];
                    
                    
                    [self fetchAllFE];
                }
                else if ([IsEngAssign isEqualToString:@"0"] &&([IsEngAccept isEqualToString:@"1"]||[IsEngAccept isEqualToString:@"2"]))
                {
                    //Invited / Accepted OR Decline
                    [self FetchInvitedEngg];
                }
            }
            
            if ([jobstatus isEqualToString:@"2"])
            {
                
                //Active
            }
        }
        
        
        UIButton *btncross=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        btncross.center=CGPointMake(CGRectGetMaxX(popUpVW.frame), CGRectGetMinY(popUpVW.frame));
        btncross.backgroundColor=[UIColor clearColor];
        [btncross setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
        [btncross clipsToBounds];
        [btncross addTarget:self action:@selector(bgPopupTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [bgVw addSubview:popUpVW];
        [bgVw addSubview:btncross];
        
        [UIView animateWithDuration:0.4 animations:^{
            popUpVW.alpha=1.0f;
            [self.view addSubview:bgVw];
        }];
    }
}


#pragma mark - Un Assigned Press Method
-(void)showUnassignedPopUp
{
    NSString *status=[NSString stringWithFormat:@"%@",[dicManagerJobDetails objectForKey:@"JobStatus"]];
    
    mainBgunassign = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    mainBgunassign.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    
    bgVwUnassign = [[UIView alloc] initWithFrame:CGRectMake(0,0,220,120)];
    bgVwUnassign.center=CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, CGRectGetHeight(self.view.frame)/2.0f);
    
    [bgVwUnassign.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [bgVwUnassign.layer setBorderWidth: 0.5];
    [bgVwUnassign.layer setCornerRadius:4.0f];
    [bgVwUnassign.layer setMasksToBounds:YES];
    bgVwUnassign.alpha=0.0f;
    bgVwUnassign.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    
    UILabel *lblMessage=[[UILabel alloc] initWithFrame:CGRectMake(20,bgVwUnassign.frame.size.height-100,180,45)];
    lblMessage.textAlignment=NSTextAlignmentLeft;
    lblMessage.textColor=[UIColor darkGrayColor];
    lblMessage.numberOfLines=2;
    lblMessage.textAlignment=NSTextAlignmentCenter;
    lblMessage.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:13.0];
    lblMessage.backgroundColor=[UIColor clearColor];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        
        lblMessage.text=@"Would you like to un assign yourself from this job?";
    }
    else if([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
       
        
        lblMessage.text=@"Would you like to un assign the engineer from this job?";
    }
    else
    {
        
    }
    
    
    
    [bgVwUnassign addSubview:lblMessage];
    
    UIButton *btnAccept = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAccept.frame = CGRectMake(110,bgVwUnassign.frame.size.height-40,110,40);
    [btnAccept setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnAccept.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    btnAccept.tag=0;
    [btnAccept setTitle:@"YES" forState:UIControlStateNormal];
    [btnAccept setBackgroundColor:[UIColor colorWithRed:120/255.0 green:171/255.0 blue:30/255.0 alpha:1.0]];
    [btnAccept addTarget:self action:@selector(pressAccept:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnReject = [UIButton buttonWithType:UIButtonTypeCustom];
    btnReject.frame = CGRectMake(0,bgVwUnassign.frame.size.height-40,110,40);
    [btnReject setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnReject.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    btnReject.tag=1;
    [btnReject setTitle:@"NO" forState:UIControlStateNormal];
    [btnReject setBackgroundColor:[UIColor colorWithRed:252/255.0 green:52/255.0 blue:31/255.0 alpha:1.0]];
    [btnReject addTarget:self action:@selector(pressDecline:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgVwUnassign addSubview:btnAccept];
    [bgVwUnassign addSubview:btnReject];
    
    
    [btnReject setBackgroundColor:[UIColor colorWithRed:120/255.0 green:171/255.0 blue:30/255.0 alpha:1.0]];
    [btnAccept setBackgroundColor:[UIColor colorWithRed:252/255.0 green:52/255.0 blue:31/255.0 alpha:1.0]];
    
    [mainBgunassign addSubview:bgVwUnassign];
    
    
    
    if (isCancel) {
        
        lblMessage.text=@" Are you sure you want to cancel the job?";
        [btnAccept setTitle:@"Yes" forState:UIControlStateNormal];
        [btnReject setTitle:@"NO" forState:UIControlStateNormal];
        btnReject.titleLabel.font=[UIFont boldSystemFontOfSize:12.0];
        btnReject.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
        btnReject.titleLabel.numberOfLines=2;
        [btnReject setBackgroundColor:[UIColor colorWithRed:120/255.0 green:171/255.0 blue:30/255.0 alpha:1.0]];
        [btnAccept setBackgroundColor:[UIColor colorWithRed:252/255.0 green:52/255.0 blue:31/255.0 alpha:1.0]];
    }
    
    bgVwUnassign.alpha=1.0f;
    mainBgunassign.alpha=0.0f;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        
        mainBgunassign.alpha=1.0f;
        
        [self.view addSubview:mainBgunassign];
        
    }];
    
}





-(void)pressAccept:(id)sender
{
    
    if (isCancel) {
        
        [self CancelJob:nil];
        
    }
    else
    {
        [self unAssignMethodPress];
    }
    
    
    [mainBgunassign removeFromSuperview];
}



-(void)pressDecline:(id)sender
{
    DLog(@"Decline UnAssign");
    [mainBgunassign removeFromSuperview];
}

- (IBAction)CancelJob:(id)sender
{
    
    mainBg = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    mainBg.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0,0,280,350)];
    bgView.center=CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, CGRectGetHeight(self.view.frame)/2.0f);
    
    [bgView.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [bgView.layer setBorderWidth: 0.5];
    [bgView.layer setCornerRadius:4.0f];
    [bgView.layer setMasksToBounds:YES];
    bgView.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    CGFloat currY=40.0f;
    
    //--------- Note Type ----------------
    UITextField * txtNoteType = [[UITextField alloc] initWithFrame:CGRectMake(20,currY,240,30)];
    txtNoteType.textColor=[UIColor darkGrayColor];
    txtNoteType.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    [txtNoteType setBorderStyle:UITextBorderStyleNone];
    txtNoteType.layer.borderWidth=0.5f;
    txtNoteType.text=@" Cancellation Note";
    
    
    txtNoteType.layer.borderColor=[[UIColor grayColor]CGColor];
    txtNoteType.layer.cornerRadius=6.0f;
    txtNoteType.background=[UIImage imageNamed:@"inputBox5"];
    txtNoteType.delegate = self;
    txtNoteType.userInteractionEnabled=NO;
    txtNoteType.placeholder=@" Note Type";
    currY=CGRectGetMaxY(txtNoteType.frame);
    
    UIImageView *imgDropdown1=[[UIImageView alloc] initWithFrame:CGRectMake(225, currY, 35, 30)];
    imgDropdown1.center=CGPointMake(CGRectGetMaxX(txtNoteType.frame)-35, CGRectGetHeight(txtNoteType.frame)/2.0f);
    [imgDropdown1 setImage:[UIImage imageNamed:@"dropdown"]];
    
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20,90,240,29)];
    lblTitle.text = @" Note Description";
    lblTitle.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.backgroundColor =[UIColor colorWithRed:52/255.0 green:54/255.0 blue:67/255.0 alpha:0.72];
    [lblTitle.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [lblTitle.layer setBorderWidth: 1.0];
    [lblTitle.layer setCornerRadius:4.0f];
    [lblTitle.layer setMasksToBounds:YES];
    
    txtvCancelNoteBody = [[UITextView alloc] initWithFrame:CGRectMake(20,130,240,90)];
    txtvCancelNoteBody.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    txtvCancelNoteBody.textColor=[UIColor darkGrayColor];
    [txtvCancelNoteBody setBackgroundColor:[UIColor whiteColor]];
    txtvCancelNoteBody.delegate = self;
    [txtvCancelNoteBody.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [txtvCancelNoteBody.layer setBorderWidth: 1.0];
    [txtvCancelNoteBody.layer setCornerRadius:4.0f];
    [txtvCancelNoteBody.layer setMasksToBounds:YES];
    
    
    UIButton *  btnCross=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCross.frame=CGRectMake(0, 0, 25, 25);
    btnCross.center=CGPointMake(CGRectGetMaxX(bgView.frame),CGRectGetMinY(bgView.frame));
    [btnCross setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
    [btnCross addTarget:self action:@selector(cross:) forControlEvents:UIControlEventTouchUpInside];
    [btnCross clipsToBounds];
    
    UIButton * CancelJob=[UIButton buttonWithType:UIButtonTypeCustom];
    CancelJob.frame=CGRectMake(0,CGRectGetHeight(bgView.frame)-40,280,40);
    [CancelJob setTitle:@"Cancel Job" forState:UIControlStateNormal];
    [CancelJob setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CancelJob.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:18.0];
    [CancelJob setBackgroundColor:[UIColor colorWithRed:30/255.0 green:124/255.0 blue:41/255.0 alpha:1.0]];
    [CancelJob addTarget:self action:@selector(unAssignMethodPress) forControlEvents:UIControlEventTouchUpInside];
    [CancelJob.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [CancelJob.layer setBorderWidth: 1.0];
    [CancelJob.layer setCornerRadius:0.0f];
    [CancelJob.layer setMasksToBounds:YES];
    
    [bgView addSubview:txtNoteType];
    
    [bgView addSubview:lblTitle];
    [bgView addSubview:txtvCancelNoteBody];
    [bgView addSubview:CancelJob];
    
    [mainBg addSubview:bgView];
    [mainBg addSubview:btnCross];
    [self.view addSubview:mainBg];
    
}

-(void)cross:(id)sender
{
    
    [mainBg removeFromSuperview];
    
}

#pragma mark - Un Assign Web service Method


-(void)unAssignMethodPress
{
    
    
    // NSString *post =[NSString stringWithFormat:@""];
    // NSString *urlString;
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict;
    int apiType = 0;
    
    if (isCancel) {
        
        
        if (txtvCancelNoteBody.text.length==0) {
            
            [self showAlert:@"Please give a cancelation note " withTitle:@"wait"];
            
        }
        else
        {
            
            apiType = REQUEST_JobCancellation;
            dict = [[NSMutableDictionary alloc] init];
            [dict setObject:(NSString *)[userdetails valueForKey:@"UserToken"] forKey:@"userToken"];
            [dict setObject:(NSString *)[dicManagerJobDetails valueForKey:@"JobID"] forKey:@"jobID"];
            [dict setObject:txtvCancelNoteBody.text forKey:@"jobCancelNote"];
            [dict setObject:(NSString *)[userdetails valueForKey:@"UserID"] forKey:@"userId"];
            
            
            // urlString=[NSString stringWithFormat:@"%sJobCancellation?userToken=%@&jobID=%@&jobCancelNote=%@&userId=%@",conn_url,(NSString *)[userdetails valueForKey:@"UserToken"],(NSString *)[dicManagerJobDetails valueForKey:@"JobID"],txtvCancelNoteBody.text,(NSString *)[userdetails valueForKey:@"UserID"]];
            
        }
        
    }
    else
    {
        apiType = REQUEST_SetEngineerUnAssigned;
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:(NSString *)[userdetails valueForKey:@"UserToken"] forKey:@"userToken"];
        [dict setObject:(NSString *)[dicManagerJobDetails valueForKey:@"JobID"] forKey:@"jobID"];
        [dict setObject:[GlobalDirector ReplaceStringNull:txtvCancelNoteBody.text] forKey:@"jobCancelNote"];
        [dict setObject:(NSString *)[userdetails valueForKey:@"UserID"] forKey:@"userID"];
        
        
        // urlString=[NSString stringWithFormat:@"%sSetEngineerUnAssigned?userToken=%@&jobID=%@&userID=%@",conn_url,(NSString *)[userdetails valueForKey:@"UserToken"],(NSString *)[dicManagerJobDetails valueForKey:@"JobID"],(NSString *)[userdetails valueForKey:@"UserID"]];
    }
    
    
    if (dict) {
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        /* urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
         NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
         NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
         NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
         [request setURL:[NSURL URLWithString:urlString]];
         [request setHTTPMethod:@"GET"];
         [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
         [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
         [request setHTTPBody:postData];
         DLog(@"PostString=%@",request);
         
         NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
         
         */
        
        
        
        [globe SyncRequestGet:apiType withPrams:dict andCompletionHandler:^(NSDictionary *result) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                
                if ([[result valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
                {
                    NSArray *arr=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrEditedJobDic"];
                    NSMutableArray *mutableCopy=[arr mutableCopy];
                    if (mutableCopy==nil) {
                        mutableCopy=[[NSMutableArray alloc]init];
                    }
                    
                    [mutableCopy addObject:[dicManagerJobDetails valueForKey:@"JobID"]];
                    [[NSUserDefaults standardUserDefaults]setObject:mutableCopy forKey:@"arrEditedJobDic"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    DLog(@"JSONObjectWithData error");
                }
                
            });
            
        }];
        
        
        
    }
    
}


#pragma mark - Textfield Delegate Method
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    Activetxtfld=textField;
    
    if (textField==txtTimeAllowancedropdown||textField==txtEnggCommision)
    {
        [textField resignFirstResponder];
        Activetxtfld=textField;
        
        
    }
    
    if (textField==txtUserTypemssg || textField==txtUserNamemssg)
    {
        [self.view endEditing:YES];
    }
    
}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    Activetxtfld=textField;
    
    if (textField==txtTimeAllowancedropdown||textField==txtEnggCommision)
    {
        [self.view endEditing:YES];
        
        Activetxtfld=textField;
        
        [self popupList];
        
    }
    
    if (textField==txtUserTypemssg || textField==txtUserNamemssg)
    {
        [self.view endEditing:YES];
        if (textField==txtUserNamemssg&&txtUserTypemssg.text.length==0)
        {
            [self showAlert:@"Select User type to get user list " withTitle:nil];
            
        }
        else if (textField==_txtfdsaveETAEnggTime)
        {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            _txtfdsaveETAEnggTime.text=[formatter stringFromDate:[NSDate date]];
            
        }
        else
        {
            [arrSelectedRecipients removeAllObjects];
            Activetxtfld=textField;
            [self popupList];
        }
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
    {
        [textView resignFirstResponder];
        
    }
    
    if (textView==txtvNoteBodyPriceQoute) {
        
        ;
        
        
        
    }
    
    return YES;
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if (self.view.frame.size.height==480) {
        
        
    }
    return YES;
    
}


#pragma mark - PopUp List Engineer Time Allowance
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
        
        if (_btnMessagePress.selected==YES)
        {
            [popUpVW addSubview:tblView];
        }
        else
        {
            [popUpVW addSubview:tblView];
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
            frame.size.height = popUpVW.frame.size.height/2.0f;
            tblView.frame = frame;
        }
                         completion:^(BOOL finished){
            DLog(@"Done!");
        }];
    }
    
}
-(NSArray *)GetDataForPoppup:(UITextField *)fld
{
    
    if (fld==txtTimeAllowancedropdown)
    {
        
        [MBProgressHUD showHUDAddedTo:Activetxtfld animated:YES];
        
        [self fetchDropDownForTextField:@"GetEnggTimeAllowance" didFinishLoading:^(BOOL success,NSArray *arrdata){
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                
                arrFeedTblPopup=arrdata;
                [tblView reloadData];
                [MBProgressHUD hideAllHUDsForView:Activetxtfld animated:YES];
                
                
            });
            
            
            
            
        }];
        
        
        
    }
    else if (fld==txtUserTypemssg)
    {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
        {
            
            
            arrFeedTblPopup=@[@"Customer",@"Manager",@"Engineer",@"Admin"];
        }
        else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
        {
            
            arrFeedTblPopup=@[@"Manager",@"Admin"];
        }
        else
        {
            arrFeedTblPopup=@[@"Customer",@"Manager",@"Engineer",@"Admin"];
        }
        
    }
    else if (fld==txtUserNamemssg)
    {
        arrFeedTblPopup=arrRecipientList;
    }
    
    else if (fld==txtEnggCommision)
    {
        arrFeedTblPopup=[self FetchDropDowns:@"GetCommisionRate"];
        
    }
    return arrFeedTblPopup;
}

-(NSArray *)FetchDropDownsMessageUsername:(NSString *)key
{
    NSArray *arr;
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *urlString=[NSString stringWithFormat:@"%sGetUserByRole?userToken=%@&userType=%@&jobId=%@",conn_url,(NSString *)[userdetails valueForKey:@"UserToken"],key,[NSString stringWithFormat:@"%@",[dicManagerJobDetails valueForKey:@"JobID"]]];
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    MBProgressHUD *hud=  [MBProgressHUD showHUDAddedTo:popUpVW  animated:YES];
    hud.labelText=[NSString stringWithFormat:@"Getting %@ list",key];
    
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        
        DLog(@"PostString=%@",urlString);
        [MBProgressHUD hideAllHUDsForView:popUpVW animated:YES];
        
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

-(NSArray *)FetchDropDowns:(NSString *)key
{
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *urlString=[NSString stringWithFormat:@"%s%@?userToken=%@",conn_url,key,(NSString *)[userdetails valueForKey:@"UserToken"]];
    urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    MBProgressHUD *hud=  [MBProgressHUD showHUDAddedTo:popUpVW  animated:YES];
    hud.labelText=[NSString stringWithFormat:@"Getting %@ list",key];
    
    __block NSArray *arrData;
    
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *returnData, NSURLResponse *response, NSError *error){
        
        DLog(@"PostString=%@",urlString);
        [MBProgressHUD hideAllHUDsForView:popUpVW animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error==nil) {
                NSMutableDictionary* temp;
                if (returnData !=nil)
                {
                    NSError *error;
                    temp = [NSJSONSerialization JSONObjectWithData:returnData  options:NSJSONReadingMutableContainers error:&error];
                    if (!error)
                    {
                        if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
                        {
                            arrData=(NSArray *)[temp objectForKey:@"DataResponses"];
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
    
    return arrData;
}



#pragma mark TableView delegate datasource
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tblView) {
        return [arrFeedTblPopup count];
        
    }
    else
    {
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
        NSDictionary *dic=(NSDictionary *)[arrFeedTblPopup objectAtIndex:indexPath.row];
        DLog(@"%@",dic);
        
        
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
        else if (Activetxtfld==txtUserTypemssg)
        {
            cell.textLabel.text=[NSString stringWithFormat:@"%@",[arrFeedTblPopup objectAtIndex:indexPath.row]];
        }
        else
        {
            cell.textLabel.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"DisplayText"]];
        }
    }
    else
    {
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblView) {
        return 45;
        
    }
    return 0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (tableView==tblView)
    {
        if (Activetxtfld==txtTimeAllowancedropdown)
        {
            NSDictionary *dic=[arrFeedTblPopup objectAtIndex:indexPath.row];
            Activetxtfld.text=[NSString stringWithFormat:@"  %@",[dic valueForKey:@"DisplayText"]];
            Activetxtfld.tag=[[dic valueForKey:@"Value"]integerValue];
            
            DLog(@"txt :%@",txtTimeAllowancedropdown.text);
            [tblView removeFromSuperview];
            tblView=nil;
        }
        else if (Activetxtfld==txtUserTypemssg)
        {
            txtUserTypemssg.text=[arrFeedTblPopup objectAtIndex:indexPath.row];
            [tblView removeFromSuperview];
            tblView=nil;
            
            
            arrRecipientList=[self FetchDropDownsMessageUsername:[arrFeedTblPopup objectAtIndex:indexPath.row]];
            
        }
        else if (Activetxtfld==txtUserNamemssg)
        {
            DLog(@"%ld",(unsigned long)[[txtUserNamemssg subviews]count]);
            NSDictionary *dic=(NSDictionary *)[arrFeedTblPopup objectAtIndex:indexPath.row];
            [tblView removeFromSuperview];
            
            
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
        
        else if (Activetxtfld==txtEnggCommision)
        {
            NSDictionary *dic=[arrFeedTblPopup objectAtIndex:indexPath.row];
            Activetxtfld.text=[NSString stringWithFormat:@"  %@",[dic valueForKey:@"DisplayText"]];
            Activetxtfld.tag=[[dic valueForKey:@"Value"]integerValue];
            
            DLog(@"txt :%@",txtEnggCommision.text);
            [tblView removeFromSuperview];
            tblView=nil;
        }
    }
    
    
    
    
}

#pragma mark - Engineer Invite / Assign Related Pop-Up Design Method
-(void)ShowAvailableEnggFromSender:(UIButton *)sender
{
    NSMutableArray *engee;
    DLog(@"Button Title Name:%@",sender.titleLabel.text);
    engee=arrMFE;
    
    DLog(@"engee count :%ld",(unsigned long)[engee count]);
    
    
    if (engee.count==0)
    {
        UILabel *NoEnggAval=[[UILabel alloc]init];
        NoEnggAval.text=@"No engineers available right now.";
        NoEnggAval.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        NoEnggAval.numberOfLines=2;
        [NoEnggAval sizeToFit];
        NoEnggAval.center=CGPointMake(popUpVW.frame.size.width/2.0f, popUpVW.frame.size.height/2.0f);
        [popUpVW addSubview:NoEnggAval];
        
        txtTimeAllowancedropdown.hidden=YES;
    }
    if ([sender.titleLabel.text isEqualToString:@"Ready to Assign"])
    {
        //DLog(@"engee:%@",engee);
        _arrEnggAccepted=engee;
    }
    else if ([sender.titleLabel.text isEqualToString:@"Allocated"])
    {
        
    }
    
    UIButton *btnRequest=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(popUpVW.frame), 50.0f)];
    [btnRequest setTitle:@"Send Request" forState:UIControlStateNormal];
    [btnRequest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnRequest.backgroundColor=[UIColor blackColor];
    btnRequest.layer.borderWidth=0.5f;
    btnRequest.layer.borderColor=[[UIColor whiteColor]CGColor];
    btnRequest.layer.cornerRadius=0.0f;
    
    if (engee.count==0){
        btnRequest.userInteractionEnabled=NO;
    }
    NSString *jobstatus=[NSString stringWithFormat:@"%@",[dicManagerJobDetails objectForKey:@"JobStatus"]];
    NSString *IsEngAccept=[NSString stringWithFormat:@"%@",[dicManagerJobDetails objectForKey:@"IsEngAccept"]];
    NSString *IsEngAssign=[NSString stringWithFormat:@"%@",[dicManagerJobDetails objectForKey:@"IsEngAssign"]];
    
    CGFloat currY=50.0f;
    IsAccepted=NO;
    
    for (int i=0;i<[engee count];i++)
    {
        NSMutableDictionary *dictem=[engee objectAtIndex:i];
        DLog(@"Engineer List Details :%@",dictem);
        UIControl *engg;
        
        if ([sender.titleLabel.text isEqualToString:@"Ready to Assign"])
        {
            
            engg=[self enggDetails:dictem];
            
            if ([[dictem valueForKey:@"IsActive"]integerValue]==1 &&[[dictem valueForKey:@"IsAccepted"]integerValue]==0)
            {
                //yellow
                engg.userInteractionEnabled=NO;
                [imgvstatusCrcl setBackgroundColor:[UIColor yellowColor]];
            }
            else if ([[dictem valueForKey:@"IsActive"]integerValue]==1 &&[[dictem valueForKey:@"IsAccepted"]integerValue]==1)
            {
                //green
                [imgvstatusCrcl setBackgroundColor:[UIColor greenColor]];
            }
            else if ([[dictem valueForKey:@"IsActive"]integerValue]==0 &&([[dictem valueForKey:@"IsAccepted"]integerValue]==1||[[dictem valueForKey:@"IsAccepted"]integerValue]==0))
            {
                //red
                engg.userInteractionEnabled=NO;
                [imgvstatusCrcl setBackgroundColor:[UIColor redColor]];
                
            }
            
            
            engg.tag=i+100;
            [engg addTarget:self action:@selector(handleEnggSelection:) forControlEvents:UIControlEventTouchUpInside];
            engg.center=CGPointMake(CGRectGetWidth(popUpVW.frame)/2.0f, currY+CGRectGetHeight(engg.frame)/2.0f+10);
            currY=CGRectGetMaxY(engg.frame);
            [popUpVW addSubview:engg];
            
        }
        else if ([sender.titleLabel.text isEqualToString:@"Allocated"])
        {
            
            DLog(@"arrengineer allocated :%@",arrMAllocatedFE1);
            DLog(@"arrengineer accepted :%@",_arrEnggAccepted);
            
            NSMutableDictionary *dictemp=[engee objectAtIndex:i];
            NSMutableDictionary *dictemp2;
            
            for (int j=0; j<[_arrEnggAccepted count]; j++)
            {
                dictemp2=[_arrEnggAccepted objectAtIndex:j];
                
                if ([[dictemp valueForKey:@"eng_id"] isEqualToString:[dictemp2 valueForKey:@"eng_id"]])
                {
                    engg=[self enggDetails:dictemp2];
                    [imgvstatusCrcl setBackgroundColor:[UIColor greenColor]];
                    
                    DLog(@"eng_name :%@",[dictemp2 valueForKey:@"eng_name"]);
                    
                    engg.tag=i+100;
                    [engg addTarget:self action:@selector(handleEnggSelection:) forControlEvents:UIControlEventTouchUpInside];
                    engg.center=CGPointMake(CGRectGetWidth(popUpVW.frame)/2.0f, currY+CGRectGetHeight(engg.frame)/2.0f+10);
                    currY=CGRectGetMaxY(engg.frame);
                    [popUpVW addSubview:engg];
                    engg.userInteractionEnabled=NO;
                    
                }
                
            }
        }
        else
        {
            engg=[self enggDetails:dictem];
            
            DLog(@"isActive :%@",[dictem valueForKey:@"IsActive"]);
            if ([dictem valueForKey:@"IsActive"])
            {
                if ([[dictem valueForKey:@"IsActive"]integerValue]==0 &&[[dictem valueForKey:@"IsAccepted"]integerValue]==0)
                {
                    [imgvstatusCrcl setBackgroundColor:[UIColor redColor]];
                    engg.userInteractionEnabled=NO;
                }
            }
            
            engg.tag=i+100;
            [engg addTarget:self action:@selector(handleEnggSelection:) forControlEvents:UIControlEventTouchUpInside];
            engg.center=CGPointMake(CGRectGetWidth(popUpVW.frame)/2.0f, currY+CGRectGetHeight(engg.frame)/2.0f+10);
            currY=CGRectGetMaxY(engg.frame);
            //engg.userInteractionEnabled=YES;
            [popUpVW addSubview:engg];
        }
        
    }
    
    if (_btnChkAvl.isSelected==YES)
    {
        if ([jobstatus isEqualToString:@"1"])
        {
            
            if ([IsEngAssign isEqualToString:@"0"]&&[IsEngAccept isEqualToString:@"0"])
            {
                //Booked
                [btnRequest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnRequest setTitle:@"Send Request" forState:UIControlStateNormal];
                
            }
            else if ([IsEngAssign isEqualToString:@"0"]&&([IsEngAccept isEqualToString:@"1"]||[IsEngAccept isEqualToString:@"2"]))
            {
                //Invite
                if ([sender.titleLabel.text isEqualToString:@"Ready to Assign"])
                {
                    engee=_arrEnggAccepted;
                    
                    DLog(@"engee count :%ld",(unsigned long)[engee count]);
                    DLog(@"_arrEnggAccepted count :%ld",(unsigned long)[_arrEnggAccepted count]);
                    
                    [btnRequest setBackgroundColor:[UIColor colorWithRed:252/255.0 green:79/255.0 blue:5/255.0 alpha:1.0]];
                    [btnRequest setTitle:@"Allocate" forState:UIControlStateNormal];
                    [btnRequest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    btnRequest.userInteractionEnabled=YES;
                    
                }
                else
                {
                    [btnRequest setBackgroundColor:[UIColor colorWithRed:252/255.0 green:79/255.0 blue:5/255.0 alpha:1.0]];
                    [btnRequest setTitle:@"Request Sent" forState:UIControlStateNormal];
                    [btnRequest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    btnRequest.userInteractionEnabled=NO;
                }
                
            }
            else if ([IsEngAssign isEqualToString:@"1"])
            {
                //Allocated
                [btnRequest setBackgroundColor:[UIColor colorWithRed:78/255.0 green:179/255.0 blue:129/255.0 alpha:1.0]];
                [btnRequest setTitle:@"Allocated" forState:UIControlStateNormal];
                [btnRequest setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                btnRequest.userInteractionEnabled=NO;
            }
        }
        else if ([jobstatus isEqualToString:@"2"])
        {
            //Active
        }
        
        if (IsAccepted==YES)
        {
            
            [btnRequest setBackgroundColor:[UIColor colorWithRed:78/255.0 green:179/255.0 blue:129/255.0 alpha:1.0]];
            [btnRequest setTitle:@"Allocate Engineer" forState:UIControlStateNormal];
            [btnRequest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnRequest.userInteractionEnabled=YES;
            
        }
        else
        {
        }
    }
    
    popUpVW.contentSize=CGSizeMake(popUpVW.frame.size.width, currY+10);
    
    
    btnRequest.layer.cornerRadius=4.0f;
    btnRequest.center=CGPointMake(CGRectGetWidth(bgVw.frame)/2.0f, CGRectGetMaxY(popUpVW.frame)+CGRectGetHeight(btnRequest.frame)/2.0f+2);
    [btnRequest addTarget:self action:@selector(sendRequest:) forControlEvents:UIControlEventTouchUpInside];
    [bgVw addSubview:btnRequest];
    
    [_activity stopAnimating];
    [_activity removeFromSuperview];
    _activity=nil;
    
}

-(UIControl *)enggDetails:(NSDictionary *)EnggDic
{
    
    UIControl *vw=[[UIControl alloc]initWithFrame:CGRectMake(0, 0,250,80)];
    vw.backgroundColor=[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1.0];
    vw.layer.cornerRadius=0.0f;
    [vw.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [vw.layer setBorderWidth: 0.5];
    [vw.layer setMasksToBounds:YES];
    
    UIImageView *chk=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    chk.center=CGPointMake(CGRectGetWidth(chk.frame)/2.0f+10, vw.center.y-9);
    chk.layer.borderColor=[[UIColor grayColor]CGColor];
    chk.image=[UIImage imageNamed:@"uncheck"];
    chk.backgroundColor=[UIColor clearColor];
    
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 130, 28)];
    lblName.text=[NSString stringWithFormat:@"%@ %@",[EnggDic valueForKey:@"FirstName"],[EnggDic valueForKey:@"LastName"]];
    lblName.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    lblName.center=CGPointMake(CGRectGetMaxX(chk.frame)+CGRectGetWidth(lblName.frame)/2.0f+5, vw.center.y-9);
    lblName.textColor=[UIColor darkGrayColor];
    lblName.backgroundColor=[UIColor clearColor];
    
    [vw addSubview:chk];
    [vw addSubview:lblName];
    
    //---------------------------------------Staus Circle Color-------------------------------------------------
    imgvstatusCrcl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    imgvstatusCrcl.center=CGPointMake(CGRectGetWidth(vw.frame)-CGRectGetWidth(imgvstatusCrcl.frame)/2.0f-14, vw.center.y-7);
    imgvstatusCrcl.layer.borderColor=[[UIColor whiteColor]CGColor];
    imgvstatusCrcl.layer.borderWidth=2.0f;
    imgvstatusCrcl.layer.cornerRadius=9.0f;
    imgvstatusCrcl.layer.masksToBounds=YES;
    [vw addSubview:imgvstatusCrcl];
    
    
    //----------- Engineer Phone Call Button ----------
    btnPhoneCall=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnPhoneCall setFrame:CGRectMake(0,51,83,28)];
    [btnPhoneCall setBackgroundImage:[UIImage imageNamed:@"eng-phone-call"] forState:UIControlStateNormal];
    btnPhoneCall.titleLabel.text=[NSString stringWithFormat:@"%@",[EnggDic valueForKey:@"EmergencyContactNo"]];
    btnPhoneCall.titleLabel.hidden=YES;
    btnPhoneCall.backgroundColor=[UIColor clearColor];
    [btnPhoneCall addTarget:self action:@selector(pressEnggPhoneCall:) forControlEvents:UIControlEventTouchUpInside];
    [vw addSubview:btnPhoneCall];
    
    //----------- Engineer Phone sms Button ----------
    btnPhoneSms=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnPhoneSms setFrame:CGRectMake(85,51,82,28)];
    [btnPhoneSms setBackgroundImage:[UIImage imageNamed:@"eng-sms"] forState:UIControlStateNormal];
    btnPhoneSms.titleLabel.text=[NSString stringWithFormat:@"%@",[EnggDic valueForKey:@"EmergencyContactNo"]];
    btnPhoneSms.titleLabel.hidden=YES;
    [btnPhoneSms setBackgroundColor:[UIColor clearColor]];
    [btnPhoneSms addTarget:self action:@selector(pressEnggPhoneSms:) forControlEvents:UIControlEventTouchUpInside];
    [vw addSubview:btnPhoneSms];
    
    //----------- Engineer Email Send Button -----------
    btnEmail=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnEmail setFrame:CGRectMake(168,51,83,28)];
    [btnEmail setBackgroundImage:[UIImage imageNamed:@"eng-email"] forState:UIControlStateNormal];
    btnEmail.titleLabel.text=[NSString stringWithFormat:@"%@",[EnggDic valueForKey:@"Email"]];
    btnEmail.titleLabel.hidden=YES;
    [btnEmail setBackgroundColor:[UIColor clearColor]];
    [btnEmail addTarget:self action:@selector(pressEnggEmail:) forControlEvents:UIControlEventTouchUpInside];
    [vw addSubview:btnEmail];
    
    if ([[EnggDic valueForKey:@"IsInvited"]integerValue]==1)
    {
        chk.image=[UIImage imageNamed:@"check"];
        
        
        if ([[EnggDic valueForKey:@"IsActive"]integerValue]==1 &&[[EnggDic valueForKey:@"IsAccepted"]integerValue]==0)
        {
            [imgvstatusCrcl setBackgroundColor:[UIColor yellowColor]];
            chk.hidden=YES;
        }
        else if ([[EnggDic valueForKey:@"IsActive"]integerValue]==1 &&[[EnggDic valueForKey:@"IsAccepted"]integerValue]==1)
        {
            
            [imgvstatusCrcl setBackgroundColor:[UIColor greenColor]];
            IsAccepted=YES;
            chk.image=[UIImage imageNamed:@"uncheck"];
            vw.userInteractionEnabled=YES;
        }
        else if ([[EnggDic valueForKey:@"IsActive"]integerValue]==0 &&([[EnggDic valueForKey:@"IsAccepted"]integerValue]==0||[[EnggDic valueForKey:@"IsAccepted"]integerValue]==1))
        {
            [imgvstatusCrcl setBackgroundColor:[UIColor redColor]];
            chk.hidden=YES;
        }
    }
    else
    {
        imgvstatusCrcl.hidden=YES;
        
    }
    return vw;
}

#pragma mark- Email send Method
-(void)pressEnggEmail:(UIButton *)sender
{
    //SendMailJobDetail(string userToken, int jobId, string userid,string mailTo);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UIView *parentVw=[sender superview];
    DLog(@"%ld",(long)parentVw.tag);
    
    DLog(@"sender :%@",sender.titleLabel.text);
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *post =[NSString stringWithFormat:@""];
    
    NSString *urlString;
    urlString=[NSString stringWithFormat:@"%sSendMailJobDetail?userToken=%@&jobID=%@&userid=%@&mailTo=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[dicManagerJobDetails valueForKey:@"JobID"],(NSString *)[user valueForKey:@"UserID"],sender.titleLabel.text];
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSLog(@"urlString :%@",urlString);
    
    
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
    
    connEnggSendMail = [[NSURLConnection alloc]init];
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        
        DLog(@"PostString=%@",urlString);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error==nil) {
                _responseData=[data mutableCopy];
                [self connectionDidFinishLoading:connEnggSendMail];
            }
            else
            {
                
            }
            
        });
        
    }];
    
    //[connEnggSendMail start];
    
    
}




#pragma mark- Phone Call Method
-(void)pressEnggPhoneCall:(UIButton *)sender
{
    DLog(@"sender :%@",sender.titleLabel.text);
    
    UIDevice *device = [UIDevice currentDevice];
    if (![[device model] isEqualToString:@"iPhone Simulator"])
    {
        
        
        NSString *strPhoneNo=btnPhoneCall.titleLabel.text;
        NSString *cleanedString = [[strPhoneNo componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cleanedString]];
        
        DLog(@"MOBILE++++++++++++++++++%@",strPhoneNo);
        [[UIApplication sharedApplication] openURL:telURL];
    }
    else
    {
        [self showAlert:@"Your device doesn't support this feature." withTitle:@"Sorry!!"];
        
    }
}

#pragma mark- SMS Send Method
-(void)pressEnggPhoneSms:(UIButton *)sender
{
    
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    [dict setObject:[GlobalDirector ReplaceStringNull:[dicManagerJobDetails valueForKey:@"JobID"]] forKey:@"jobId"];
    [dict setObject:[GlobalDirector ReplaceStringNull:@"engineer"] forKey:@"smsReceiverType"];
    
    [dict setObject:[GlobalDirector ReplaceStringNull:sender.titleLabel.text] forKey:@"phoneNumber"];
    
    
    
    GlobalDirector *globe = [GlobalDirector SharedDirector];
    
    // [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [globe SyncRequestGet:REQUEST_SendJobDetailsSms withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        
        NSLog(@"%@",result);
        
        
        //  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            @try {
                
                
                BOOL strValue= [result valueForKey:@"ResponseStatus"];
                
                if (strValue==1) {
                    
                    [self showAlert:[GlobalDirector ReplaceStringNull:[result valueForKey:@"ReturnValue"]] withTitle:@"Success"];
                    
                }else{
                    [self showAlert:[GlobalDirector ReplaceStringNull:[result valueForKey:@"ReturnValue"]] withTitle:@"Error!"];
                }
                
                
                
                
                
            } @catch (NSException *exception) {
                // _txtPost.text=@"";
                [self showAlert:@"There are some problem right now, try again later " withTitle:@"Sorry!"];
            }
        });
        
    }];
    
    
}





#pragma mark- SMS Send Delegate Method
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
    {
        DLog(@"Message cancelled");
    }
    else if (result == MessageComposeResultSent)
    {
        DLog(@"Message sent");
    }
    else
    {
        DLog(@"Message failed");
    }
}





#pragma mark - Remove background popup
-(IBAction)bgPopupTouched:(id)sender
{
    for (UIView *vw in [bgVw subviews]) {
        [vw removeFromSuperview];
        
        
    }
    [bgVw removeFromSuperview];
    
    [arrMselectedFE removeAllObjects];
    
}

#pragma mark -  Handle Engineer Selection From Popup
-(IBAction)handleEnggSelection:(UIControl *)sender
{
    
    NSMutableDictionary *temp;
    NSString *IsEngAccept=[NSString stringWithFormat:@"%@",[dicManagerJobDetails objectForKey:@"IsEngAccept"]];
    NSString *IsEngAssign=[NSString stringWithFormat:@"%@",[dicManagerJobDetails objectForKey:@"IsEngAssign"]];
    
    if (_btnChkAvl.selected==YES&&[_btnChkAvl.titleLabel.text isEqualToString:@"Ready to Assign"])
    {
        temp=[_arrEnggAccepted objectAtIndex:sender.tag-100];
    }
    else
    {
        temp=[arrMFE objectAtIndex:sender.tag-100];
        
    }
    
    
    
    
    
    for (UIImageView *chkimg in [sender subviews])
    {
        
        if ([chkimg isKindOfClass:[UIImageView class]]) {
            UIImageView *chk=(UIImageView *)chkimg;
            
            if (chk.backgroundColor==[UIColor lightGrayColor]) {
                
                chk.image=[UIImage imageNamed:@"uncheck"];
                chk.backgroundColor=[UIColor clearColor];
                NSInteger indextodelete = 0;
                
                for ( int i=0;i<[arrMselectedFE count];i++) {
                    
                    NSMutableDictionary *dic;
                    
                    if ([[dic valueForKey:@"user_id"]isEqualToString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"user_id"]]]) {
                        indextodelete=(NSInteger)i;
                        
                        
                    }
                }
                
                [arrMselectedFE removeObjectAtIndex:indextodelete];
                
            }
            
            
            
            else
            {
                if ([IsEngAccept isEqualToString:@"2"]&&[IsEngAssign isEqualToString:@"0"]&&_btnChkAvl.selected==YES&&[arrMselectedFE count]==1)
                {
                    [self showAlert:@"More than one Engineer cannot be assigned " withTitle:@""];
                    
                }
                else
                {
                    
                    [arrMselectedFE addObject:temp];
                    chk.image=[UIImage imageNamed:@"check"];
                    chk.backgroundColor=[UIColor lightGrayColor];
                }
                
                
                
            }
            
        }
    }
    
    
    
    
    
}

#pragma mark -  Send Invitation / Assigned Pop-Up Button Press Method
-(IBAction)sendRequest:(UIButton *)sender
{
    
    NSString *altmsg;
    // alert=[[UIAlertView alloc]init];
    
    if ([arrMselectedFE count]>0)
    {
        
        DLog(@"IsAccepted :%d",IsAccepted);
        NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
        NSString *urlString;
        NSString *post =[NSString stringWithFormat:@""];
        NSString *selectedEnggIds=@"";
        
        for (int i=0; i<[arrMselectedFE count]; i++)
        {
            NSDictionary *dic=[arrMselectedFE objectAtIndex:i];
            selectedEnggIds=[selectedEnggIds stringByAppendingString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"StaffID"]]];
            if (i<[arrMselectedFE count]-1)
            {
                selectedEnggIds=[selectedEnggIds stringByAppendingString:@","];
            }
            
        }
        
        if (_btnChkAvl.selected==YES&&[_btnChkAvl.titleLabel.text isEqualToString:@"Ready to Assign"])
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            urlString=[NSString stringWithFormat:@"%sSetEngineerAssigned?userToken=%@&jobID=%@&assignedEngineerID=%@&scheduledDate=%@&scheduledTime=%@&userID=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[dicManagerJobDetails valueForKey:@"JobID"],selectedEnggIds,@"",@"",(NSString *)[user valueForKey:@"UserID"]];
            
            strAfterallocated=@"1";
            
            urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
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
            
            connEnggSelection = [[NSURLConnection alloc]init];
            [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
                
                DLog(@"PostString=%@",urlString);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error==nil) {
                        _responseData=[data mutableCopy];
                        [self connectionDidFinishLoading:connEnggSelection];
                    }
                    else
                    {
                        
                    }
                    
                });
                
            }];
            
            // [connEnggSelection start];
            [self bgPopupTouched:nil];
            
        }
        else
        {
            DLog(@"selectedEnggIds ::::::----%@",selectedEnggIds);
            
            if ([txtTimeAllowancedropdown.text isEqualToString:@""])
            {
                [self showAlert:@"Please select time allowance" withTitle:@"Wait"];
                
            }
            else
            {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                urlString=[NSString stringWithFormat:@"%sSetJobEngineerAllotment?userToken=%@&jobID=%@&invitedEngineerID=%@&userID=%@&enggTimeAllowance=%ld",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[dicManagerJobDetails valueForKey:@"JobID"],selectedEnggIds,(NSString *)[user valueForKey:@"UserID"],(long)txtTimeAllowancedropdown.tag];
                
                urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                
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
                
                connEnggSelection = [[NSURLConnection alloc]init];
                [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
                    
                    DLog(@"PostString=%@",urlString);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error==nil) {
                            _responseData=[data mutableCopy];
                            [self connectionDidFinishLoading:connEnggSelection];
                        }
                        else
                        {
                            
                        }
                        
                    });
                    
                }];
                
                
                //[connEnggSelection start];
                [self bgPopupTouched:nil];
                
            }
        }
    }
    else
    {
        altmsg=@"To Send Request you have to select atleast one Field Engineer";
        
        
        [self showAlert:altmsg withTitle:@"Wait!!"];
        
        
    }
    
}



-(void)GetJobDetails
{
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    [dict setObject:[GlobalDirector ReplaceStringNull:[dicManagerJobDetails valueForKey:@"JobID"]] forKey:@"jobId"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    GlobalDirector *globe = [GlobalDirector SharedDirector];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    MBProgressHUD   *hudd=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudd.labelText=@"Loading...";
    [hudd show:YES];
    
    [globe SyncRequestGet:REQUEST_GetJobDetails withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        NSLog(@"%@",result);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hudd hide:YES];
            @try {
                BOOL strValue= [result valueForKey:@"ResponseStatus"];
                if (strValue==1)
                {
                    
                    engNumber = [GlobalDirector ReplaceStringNull:[[result valueForKey:@"JobResponseList"] valueForKey:@"EngineerPhoneNumber"]];
                    dicManagerJobDetails = [result valueForKey:@"JobResponseList"];
                    
                    // [self UpdateViewDidLoad];
                    // [self UpdateviewWillAppear];
                    
                    //Replace controller
                    
                    
                    
                }
                else
                {
                    ;
                }
            } @catch (NSException *exception) {
                ;
            }
        });
        
    }];
}



#pragma mark More Option Expand
- (IBAction)agreementPress:(UIButton *)sender
{
    
    SignAgreement *signagree=[[SignAgreement alloc]initWithNibName:@"SignAgreement" bundle:nil];
    
    if (sender.tag==999)
    {
        signagree.strHeading=@"Invoice";
    }
    else
    {
        signagree.strHeading=@"Agreement Signature";
    }
    
    signagree.jobID=[dicManagerJobDetails valueForKey:@"JobID"];
    signagree.JobDic=dicManagerJobDetails;
    signagree.isAgreementSigned=[[dicManagerJobDetails valueForKey:@"IsAgreementSign"]boolValue];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDismissSecondViewController)
                                                 name:@"SecondViewControllerDismissedWithAgreement"
                                               object:nil];
    
    [self.navigationController pushViewController:signagree animated:true];

    
}



- (IBAction)SendSms:(UIButton *)sender {
    
    
    
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    [dict setObject:[GlobalDirector ReplaceStringNull:[dicManagerJobDetails valueForKey:@"JobID"]] forKey:@"jobId"];
    [dict setObject:[GlobalDirector ReplaceStringNull:@"customer"] forKey:@"smsReceiverType"];
    
    [dict setObject:[GlobalDirector ReplaceStringNull:_txtContactNo.text] forKey:@"phoneNumber"];
    
    
    
    GlobalDirector *globe = [GlobalDirector SharedDirector];
    
    //  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [globe SyncRequestGet:REQUEST_SendJobDetailsSms withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        
        NSLog(@"%@",result);
        
        
        // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            @try {
                
                
                BOOL strValue= [[result valueForKey:@"ResponseStatus"] intValue];
                
                if (strValue==1) {
                    
                    [self showAlert:[GlobalDirector ReplaceStringNull:[result valueForKey:@"ReturnValue"]] withTitle:@"Success"];
                    
                }else{
                    [self showAlert:[GlobalDirector ReplaceStringNull:[result valueForKey:@"ReturnValue"]] withTitle:@"Error!"];
                }
                
                
                
                
                
            } @catch (NSException *exception) {
                // _txtPost.text=@"";
                [self showAlert:@"There are some problem right now, try again later " withTitle:@"Sorry!"];
            }
        });
        
    }];
    
    
    
}





-(void)didDismissSecondViewController
{
    //DLog(@"Dismissed SecondViewController");
    [self backPress:nil];
}




- (IBAction)mapPress:(id)sender
{
    NSArray *arr=[dicManagerJobDetails objectForKey:@"JobAddrListResponse"];
    
    bool isJobAddress = NO;
    
    for (NSDictionary *dic in arr) {
        if ([[dic valueForKey:@"TypeOfAddress"]integerValue]==1) {
            isJobAddress=YES;
        }
        
    }
    
    if (isJobAddress) {
        
        
        
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        // If the status is denied or only granted for when in use, display an alert
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
            NSString *title;
            title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
            NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
            
            
            
            UIAlertController *controller = [UIAlertController alertControllerWithTitle: title
                                                                                message:message
                                                                         preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle: @"Cancel"
                                                                        style: UIAlertActionStyleDestructive
                                                                      handler: ^(UIAlertAction *action) {
                
            }];
            
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Settings"
                                                                  style: UIAlertActionStyleDestructive
                                                                handler: ^(UIAlertAction *action) {
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:settingsURL];
            }];
            
            
            
            [controller addAction: alertActionCancel];
            [controller addAction: alertAction];
            
            [self presentViewController: controller animated: YES completion: nil];
            
        }else if (status == kCLAuthorizationStatusNotDetermined) {
            [app.locationManager requestAlwaysAuthorization];
        }else
        {
            
            
            Map_show *mapShow = [[Map_show alloc]initWithNibName:@"Map_show" bundle:nil];
            
            mapShow.strHeading=@"Map Navigation";
            mapShow.dicJobTemp=dicManagerJobDetails;
            [self presentViewController:mapShow animated:YES completion:nil];
            
        }
    }else{
        [self showAlert:@"Job address not available." withTitle:@"info"];
    }
    
}

#pragma mark- Message Class Method
-(IBAction)pressMessage:(id)sender
{
    
    _btnMessagePress.selected=YES;
    
    mainBgmssg = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    mainBgmssg.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    
    popUpVW = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,300,self.view.frame.size.height-270)];
    popUpVW.center=CGPointMake(CGRectGetWidth(mainBgmssg.frame)/2.0f, CGRectGetHeight(mainBgmssg.frame)/2.0f);
    [popUpVW.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [popUpVW.layer setBorderWidth: 0.5];
    [popUpVW.layer setCornerRadius:4.0f];
    [popUpVW.layer setMasksToBounds:YES];
    popUpVW.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    popUpVW.alpha=0.0f;
    
    
    UILabel *lbheader = [[UILabel alloc] initWithFrame:CGRectMake(20,3,240,29)];
    lbheader.center=CGPointMake(CGRectGetWidth(popUpVW.frame)/2.0f, lbheader.center.y);
    
    lbheader.text = @"Send a message";
    lbheader.font = [UIFont fontWithName:@"TheSansArabic-Bold" size:16.0];
    lbheader.textAlignment = NSTextAlignmentCenter;
    lbheader.textColor=[UIColor grayColor];
    [popUpVW addSubview:lbheader];
    
    
    
    //--------Select UserType------------
    txtUserTypemssg = [[UITextField alloc] initWithFrame:CGRectMake(0,0,240,30)];
    txtUserTypemssg.center=CGPointMake(CGRectGetWidth(popUpVW.frame)/2.0f, 50);
    
    txtUserTypemssg.textColor=[UIColor darkGrayColor];
    txtUserTypemssg.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    [txtUserTypemssg setBorderStyle:UITextBorderStyleNone];
    txtUserTypemssg.layer.borderWidth=0.5f;
    txtUserTypemssg.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    txtUserTypemssg.layer.cornerRadius=0.0f;
    txtUserTypemssg.backgroundColor=[UIColor whiteColor];
    txtUserTypemssg.delegate = self;
    txtUserTypemssg.userInteractionEnabled=YES;
    txtUserTypemssg.placeholder=@" Send to";
    
    UIImageView *imgDropdown4=[[UIImageView alloc] initWithFrame:CGRectMake(225,50, 35, 30)];
    imgDropdown4.center=CGPointMake(CGRectGetMaxX(txtUserTypemssg.frame)-15, txtUserTypemssg.center.y);
    [imgDropdown4 setImage:[UIImage imageNamed:@"dropdown"]];
    [popUpVW addSubview:txtUserTypemssg];
    [popUpVW addSubview:imgDropdown4];
    
    
    //--------Select Mutiple UserName------------
    txtUserNamemssg = [[UITextField alloc] initWithFrame:CGRectMake(0,0,240,30)];
    txtUserNamemssg.center=CGPointMake(CGRectGetWidth(popUpVW.frame)/2.0f, CGRectGetMaxY(txtUserTypemssg.frame)+25);
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
    imgDropdown5.center=CGPointMake(CGRectGetMaxX(txtUserNamemssg.frame)-15, txtUserNamemssg.center.y);
    [imgDropdown5 setImage:[UIImage imageNamed:@"dropdown"]];
    [popUpVW addSubview:txtUserNamemssg];
    [popUpVW addSubview:imgDropdown5];
    
    
    //-------- Job Decription -------------
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0,240,30)];
    lblTitle.center=CGPointMake(CGRectGetWidth(popUpVW.frame)/2.0f, CGRectGetMaxY(txtUserNamemssg.frame)+25);
    lblTitle.text = @" Message Body";
    lblTitle.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.backgroundColor =[UIColor colorWithRed:52/255.0 green:54/255.0 blue:67/255.0 alpha:0.72];
    [lblTitle.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [lblTitle.layer setBorderWidth: 0.5];
    [lblTitle.layer setCornerRadius:0.0f];
    [lblTitle.layer setMasksToBounds:YES];
    [popUpVW addSubview:lblTitle];
    
    txtvMessageBodymssg = [[UITextView alloc] initWithFrame:CGRectMake(0,0,240,120)];
    txtvMessageBodymssg.center=CGPointMake(CGRectGetWidth(popUpVW.frame)/2.0f, CGRectGetMaxY(lblTitle.frame)+65);
    txtvMessageBodymssg.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    txtvMessageBodymssg.textColor=[UIColor darkGrayColor];
    [txtvMessageBodymssg setBackgroundColor:[UIColor whiteColor]];
    txtvMessageBodymssg.delegate = self;
    [txtvMessageBodymssg.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [txtvMessageBodymssg.layer setBorderWidth: 0.5];
    [txtvMessageBodymssg.layer setCornerRadius:0.0f];
    [txtvMessageBodymssg.layer setMasksToBounds:YES];
    
    [popUpVW addSubview:txtvMessageBodymssg];
    
    popUpVW.frame=CGRectMake(popUpVW.frame.origin.x,popUpVW.frame.origin.y,CGRectGetWidth(popUpVW.frame),CGRectGetMaxY(txtvMessageBodymssg.frame)+95);
    
    btnMessagePostmssg=[UIButton buttonWithType:UIButtonTypeCustom];
    btnMessagePostmssg.frame=CGRectMake(0,CGRectGetHeight(popUpVW.frame)-40,300,40);
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
    btnCrossmssg.center=CGPointMake(CGRectGetMaxX(popUpVW.frame)-4,CGRectGetMinY(popUpVW.frame)+4);
    [btnCrossmssg setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
    [btnCrossmssg addTarget:self action:@selector(crossmssg:) forControlEvents:UIControlEventTouchUpInside];
    [btnCrossmssg clipsToBounds];
    
    
    
    [popUpVW addSubview:btnMessagePostmssg];
    [mainBgmssg addSubview:popUpVW];
    [mainBgmssg addSubview:btnCrossmssg];
    popUpVW.alpha=1.0f;
    mainBgmssg.alpha=0.0f;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        mainBgmssg.alpha=1.0f;
        
        
        [self.view addSubview:mainBgmssg];
        
    }];
    
}

#pragma mark- Cross Press Method
-(void)crossmssg:(UIButton *)sender
{
    _btnMessagePress.selected=NO;
    [arrSelectedRecipients removeAllObjects];
    [mainBgmssg removeFromSuperview];
}


- (IBAction)EngCall:(UIButton *)sender {
    DLog(@"sender :%@",sender.titleLabel.text);
    
    UIDevice *device = [UIDevice currentDevice];
    if (![[device model] isEqualToString:@"iPhone Simulator"])
    {
        
        
        NSString *strPhoneNo=[GlobalDirector ReplaceStringNull:engNumber];
        NSString *cleanedString = [[strPhoneNo componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cleanedString]];
        
        DLog(@"MOBILE++++++++++++++++++%@",strPhoneNo);
        [[UIApplication sharedApplication] openURL:telURL];
    }
    else
    {
        [self showAlert:@"Your device doesn't support this feature." withTitle:@"Sorry!!"];
        
    }
}


- (IBAction)JobTypeSmsSending:(UIButton *)sender {
    
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    [dict setObject:[GlobalDirector ReplaceStringNull:[dicManagerJobDetails valueForKey:@"JobID"]] forKey:@"jobId"];
    [dict setObject:[GlobalDirector ReplaceStringNull:@"engineer"] forKey:@"smsReceiverType"];
    
    // [dict setObject:[GlobalDirector ReplaceStringNull:sender.titleLabel.text] forKey:@"phoneNumber"];
    
    
    
    GlobalDirector *globe = [GlobalDirector SharedDirector];
    
    // [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [globe SyncRequestGet:REQUEST_SendJobDetailsSms withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        
        NSLog(@"%@",result);
        
        
        // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            @try {
                
                
                BOOL strValue= [[result valueForKey:@"ResponseStatus"] intValue];
                
                if (strValue==1) {
                    
                    [self showAlert:[GlobalDirector ReplaceStringNull:[result valueForKey:@"ReturnValue"]] withTitle:@"Success"];
                    
                }else{
                    [self showAlert:[GlobalDirector ReplaceStringNull:[result valueForKey:@"ReturnValue"]] withTitle:@"Error!"];
                }
                
                
                
                
                
            } @catch (NSException *exception) {
                // _txtPost.text=@"";
                [self showAlert:@"There are some problem right now, try again later " withTitle:@"Sorry!"];
            }
        });
        
    }];
    
    
}



-(void)pressMessagePostmssg:(id)sender
{
    
    
    
    if ([txtUserNamemssg.text isEqualToString:@""]||[txtUserTypemssg.text isEqualToString:@""]||[txtvMessageBodymssg.text isEqualToString:@""])
    {
        
        [self showAlert:@"To send message you have to enter recipient name and message respectively" withTitle:@"Wait"];
        
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
        NSString *urlString;
        NSString *post =[NSString stringWithFormat:@""];
        
        
        
        NSString *selectedEnggIds=[[arrSelectedRecipients valueForKey:@"Value"] componentsJoinedByString:@","];;
        DLog(@"%@",selectedEnggIds);
        
        
        urlString=[NSString stringWithFormat:@"%sSetJobWiseMessage?userToken=%@&jobID=%@&userToIds=%@&userFromId=%@&messageBody=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],[NSString stringWithFormat:@"%@",[dicManagerJobDetails valueForKey:@"JobID"]],selectedEnggIds,(NSString *)[user valueForKey:@"UserID"],txtvMessageBodymssg.text];
        
        urlString= [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
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
        [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
            
            DLog(@"PostString=%@",urlString);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error==nil) {
                    _responseData=[data mutableCopy];
                    [self connectionDidFinishLoading:connSendMessage];
                }
                else
                {
                    
                }
                
            });
            
        }];
        
        // [connSendMessage start];
        
    }
    
}



-(IBAction)activeButton:(UIButton *)sender
{
    
    _vwAfterAllocation.frame=CGRectMake(0, CGRectGetMinY(_vwAfterAllocation.frame), [[UIScreen mainScreen]bounds].size.width, _vwAfterAllocation.frame.size.height);
    
    if (sender==nil)
    {
        _btnNotes.frame=CGRectMake(0, 0, CGRectGetWidth(_vwAfterAllocation.frame)/3.0f, CGRectGetHeight(_vwAfterAllocation.frame));
        _btnMaterials.frame=CGRectMake(CGRectGetMaxX(_btnNotes.frame)+2, 0, CGRectGetWidth(_btnNotes.frame), CGRectGetHeight(_btnNotes.frame));
        _btnCosts.frame=CGRectMake(CGRectGetMaxX(_btnMaterials.frame)+2, 0, CGRectGetWidth(_btnNotes.frame), CGRectGetHeight(_btnNotes.frame));
        
        _btnMaterials.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:15];
        _btnCosts.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:15];
        _btnNotes.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:15];
        
        [_btnMaterials setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnCosts setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    else if (sender==btnFinancial)
    {
        
        
        CGSize screenSize=[[UIScreen mainScreen]bounds].size;
        if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        {
            if (screenSize.height==568.0f)
            {
            }
            else if(screenSize.height == 667.0f)
            {
                ;
            }
            else if(screenSize.height == 736.0f)
            {
            }
            else
            {
            }
        }
        else{
        }
        
        _btnNotes.translatesAutoresizingMaskIntoConstraints = YES;
        _btnMaterials.translatesAutoresizingMaskIntoConstraints = YES;
        _btnCosts.translatesAutoresizingMaskIntoConstraints = YES;
        btnFinancial.translatesAutoresizingMaskIntoConstraints = YES;
        
        _btnAgrrement.hidden=YES;
        [_vwAfterAllocation addSubview:btnFinancial];
        _btnNotes.frame=CGRectMake(0, 0, CGRectGetWidth(_vwAfterAllocation.frame)/4.0f, CGRectGetHeight(_vwAfterAllocation.frame));
        
        _btnMaterials.frame=CGRectMake(CGRectGetMaxX(_btnNotes.frame)+1, 0, CGRectGetWidth(_btnNotes.frame), CGRectGetHeight(_btnNotes.frame));
        _btnCosts.frame=CGRectMake(CGRectGetMaxX(_btnMaterials.frame)+1, 0, CGRectGetWidth(_btnNotes.frame), CGRectGetHeight(_btnNotes.frame));
        btnFinancial.frame= CGRectMake(CGRectGetMaxX(_btnCosts.frame)+1, 0, CGRectGetWidth(_btnNotes.frame), CGRectGetHeight(_btnNotes.frame));
        
        btnFinancial.backgroundColor=_btnNotes.backgroundColor;
        [btnFinancial setTitle:@"Financial" forState:UIControlStateNormal];
        btnFinancial.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:13];
        [btnFinancial addTarget:self action:@selector(btnFinancialTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _btnMaterials.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:13];
        _btnCosts.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:13];
        _btnNotes.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:13];
        
        [_btnMaterials setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnNotes setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnCosts setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btnFinancial setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        
    }
    else
    {
        for (UIButton *btn in _vwAfterAllocation.subviews){
            if (btn!=sender){
                btn.hidden=YES;
            }
        }
        sender.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:21];
        sender.frame=CGRectMake(0, 0, CGRectGetWidth(_vwAfterAllocation.frame), CGRectGetHeight(_vwAfterAllocation.frame));
    }
    
    //DLog(@"%@",sender.titleLabel.text);
    
}


-(void) addGradient:(UIButton *) _button {
    
    // Add Border
    CALayer *layer = _button.layer;
    
    layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;
    layer.cornerRadius=5.0f;
    
    
    
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    [layer addSublayer:shineLayer];
}

// navigate to helpwidgetVC
- (IBAction)helpWidgetBtn:(id)sender {
    HelpWidgetVC *createJob = [[HelpWidgetVC alloc] initWithNibName: @"HelpWidgetVC" bundle: nil];
//    @property (strong, nonatomic) IBOutlet NSDictionary *dictData;
    NSMutableDictionary *dict1= [[NSMutableDictionary alloc] init];
    [dict1 setValue:self.txtzipCode.text forKey:@"var2"];
    [dict1 setValue:self.txtFirstName.text forKey:@"var1"];
    createJob.dictData = dict1;
    NSLog(@"%@",dict1);

    
    [self.navigationController pushViewController:createJob animated:YES];
}
// navigate to helpwidgetVC
- (IBAction)helpWidgetBtnJobDetail:(id)sender
{
    HelpWidgetVC *createJob = [[HelpWidgetVC alloc] initWithNibName: @"HelpWidgetVC" bundle: nil];
//    @property (strong, nonatomic) IBOutlet NSDictionary *dictData;
    NSMutableDictionary *dict1= [[NSMutableDictionary alloc] init];
    [dict1 setValue:self.txtzipCode.text forKey:@"var2"];
    [dict1 setValue:self.txtFirstName.text forKey:@"var1"];
    createJob.dictData = dict1;
    NSLog(@"%@",dict1);
   
    [self.navigationController pushViewController:createJob animated:YES];
}


- (void) initializeTextFieldInputView {

    
 
   
    

   

    
    
}
- (void) timeUpdated:(UIDatePicker *)datePicker {
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    UITextField *actvfld= _txtfdsaveETAEnggTime;
    
    actvfld.text = [formatter stringFromDate:datePicker.date];
}
- (IBAction)SaveETabtn:(id)sender
{
    
    Count=1;
    _txtfdManagerEtatime.text = _txtfdsaveETAEnggTime.text;
        if (_txtfdsaveETAEnggTime.text.length>0 ) {
            [_txtfdsaveETAEnggTime resignFirstResponder];
            
            _txtJobStatus.text=[NSString stringWithFormat:@" %@:\t%@",_txtJobStatus.placeholder,@"Active"];
            [KLCPopup dismissAllPopups];
            
            NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
          
            NSString *JobID = [dicManagerJobDetails valueForKey:@"JobID"];
            NSString *post =[NSString stringWithFormat:@""];
            NSString*EtaTime = _txtfdsaveETAEnggTime.text;
            NSString *urlString=[NSString stringWithFormat:@"%sEtaTimeJobUpdate?UserToken=%@&EtaTime=%@&JobID=%@",conn_url,[userdetails valueForKey:@"UserToken"],EtaTime,JobID];

            
 
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

            connActivateJobbyengineer = [[NSURLConnection alloc]init];
            [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){

                DLog(@"PostString=%@",urlString);

                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error==nil) {
                        self->_responseData=[data mutableCopy];
                        [self connectionDidFinishLoading:connActivateJobbyengineer];
                    }
                    else
                    {

                    }

                });

            }];

            


            
            
            
        }else{
            
            _txtfdsaveETAEnggTime.layer.cornerRadius=8.0f;
            _txtfdsaveETAEnggTime.layer.masksToBounds=YES;
            _txtfdsaveETAEnggTime.layer.borderColor=[[UIColor redColor]CGColor];
            _txtfdsaveETAEnggTime.layer.borderWidth= 1.0f;
            
        }
   
    


}
#pragma mark - Date Picker Method
-(void)DatePicker:(id)sender
{
    if (numberToolbar==nil) {
        numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,310, 320, 50)];
    }
//    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
//    numberToolbar.barTintColor=[UIColor lightGrayColor];
//    numberToolbar.items = [NSArray arrayWithObjects:
//                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)],
//                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//                           [[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(OK)],
//                           nil];
    [numberToolbar sizeToFit];
    //[mainBg addSubview:numberToolbar];
    _txtfdsaveETAEnggTime.inputAccessoryView=numberToolbar;
  
;
    
    datepicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datepicker.datePickerMode = UIDatePickerModeDate;
    datepicker.backgroundColor = [UIColor whiteColor];
    [datepicker addTarget:self action:@selector(dateUpdated:) forControlEvents:UIControlEventValueChanged];
    //txtStarDate.inputView = datepicker;
}

#pragma mark - Time Picker Method
-(void)Timepicker:(id)sender
{
    
    if (numberToolbar==nil) {
        numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,320, 310, 50)];
    }
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.barTintColor=[UIColor lightGrayColor];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(OK)],
                           nil];
    [numberToolbar sizeToFit];
  
    _txtfdsaveETAEnggTime.inputAccessoryView=numberToolbar;
    //[mainBg addSubview:numberToolbar];
    
    timePicker= [[UIDatePicker alloc] initWithFrame:CGRectZero];
    timePicker.datePickerMode = UIDatePickerModeTime;
    timePicker.backgroundColor = [UIColor whiteColor];
    [timePicker addTarget:self action:@selector(timeUpdated:) forControlEvents:UIControlEventValueChanged];
    timePicker.minuteInterval = 5;
    _txtfdsaveETAEnggTime.inputView=timePicker;
}
#pragma mark - Ok / cancel
-(void)cancel
{
    
    [_txtfdsaveETAEnggTime resignFirstResponder];
    
    
}
-(void)OK
{
    
    
    [_txtfdsaveETAEnggTime resignFirstResponder];
    
    
     }


@end
