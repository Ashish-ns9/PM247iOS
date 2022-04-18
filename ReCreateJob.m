//
//  ReCreateJob.m
//  Partner Maintenance
//


#import "ReCreateJob.h"
#import "GlobalDirector.h"
@interface ReCreateJob ()

@end

@implementation ReCreateJob
@synthesize btnSlideMenu;

#pragma mark - ViewWillAppear Method
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
    {
        
        
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        
    }
    
    _spinner.hidden=YES;
}

#pragma mark - ViewDidLoad Method
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [self DatePicker:nil];
    [self Timepicker:nil];
     _spinner.hidden=YES;
    
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
    
    _tblRecreate.backgroundView=nil;
    _tblRecreate.backgroundColor=[UIColor clearColor];
    _tblRecreate.separatorColor=[UIColor clearColor];
   
    [_search setTintColor:[UIColor colorWithRed:233.0/255.0
                                         green:233.0/255.0
                                          blue:233.0/255.0
                                         alpha:1.0]];
    _search.placeholder=@"Search via name, email, postcode";
    
    
    
   
}


#pragma mark - SWRevealViewController Delegate Methods
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if (position == FrontViewPositionLeftSide)
    {
        
    }
    else if (position == FrontViewPositionLeft)
    {
        
        
    }
}

#pragma mark - Back Button Method
- (IBAction)backTapped:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - UITableView Delegate Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (tableView==tblView) {
        return 44;
    }
    else{
        return 138.0;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView==tblView) {
        return [arrFeedTblPopup count];
            }
    else
    {
        if ([_arrRecreatedFrom count]>0)
        {
            return [_arrRecreatedFrom count];
        }
        else
        {
            return 0;
        }
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tblarr;
    tblarr=_arrRecreatedFrom;
    

    
    if (tableView==tblView)
    {
        static NSString *cellidentifier=@"cellidentifier";
        UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellidentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.backgroundColor=[UIColor clearColor];

        
        NSDictionary *dic=[arrFeedTblPopup objectAtIndex:indexPath.row];
        
        cell.textLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
        
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"DisplayText"]];
        
         return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"RecreateCell";
        RecreateCell  *cell=(RecreateCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // tableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tab_page.png"]];
        if(cell==nil)
        {
            cell =(RecreateCell*)[BaseTableCell cellFromNibNamed:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
     //   cell.viewLine.backgroundColor=[UIColor clearColor];
        
        
        cell.viewLine.layer.borderColor = [UIColor colorWithRed:77.0/255.0 green:130.0/255.0 blue:72.0/255.0 alpha:1].CGColor;
        cell.viewLine.layer.borderWidth = 1.5f;
        cell.viewLine.layer.cornerRadius=8;
        cell.viewLine.layer.masksToBounds=YES;
        
        
       
        
     
        
        NSDictionary *dicTemp=[tblarr objectAtIndex:indexPath.row];
        
        cell.txtDes.text=[GlobalDirector ReplaceStringNull:[dicTemp valueForKey:@"JobDescription"]];
        cell.txtDes.numberOfLines=3;
        
        NSArray *arr=[dicTemp objectForKey:@"JobAddrListResponse"];
        NSDictionary *PresentingJob,*PresentingUser;
        
        for (NSDictionary *dic in arr) {
            if ([[dic valueForKey:@"TypeOfAddress"]integerValue]==1) {
                PresentingJob=dic;
                
            }
        }
        
        
        
        NSArray *arr2=[dicTemp objectForKey:@"JobPeopleListResponse"];
        for (NSDictionary *dic in arr2) {
            
            if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==1) {
                PresentingUser=dic;
                
            }
            
        }
        
       
        
        cell.txtcomName.text=[GlobalDirector ReplaceStringNull:[PresentingJob valueForKey:@"NameofOrganisation"]];
        cell.txtDate.text=[GlobalDirector ReplaceStringNull:[dicTemp valueForKey:@"jobStartDate "]];
        cell.txtTA.text=[GlobalDirector ReplaceStringNull:[dicTemp valueForKey:@"BookingAgentId"]];
        
        NSString *add=[GlobalDirector ReplaceStringNull:[PresentingJob valueForKey:@"Address"]];
        NSString *org= [GlobalDirector ReplaceStringNull:[PresentingJob valueForKey:@"NameofOrganisation"]];
        
        if (org.length>0) {
            cell.txtAddress.text=[NSString stringWithFormat:@"%@ ,%@",org,add];
        }else{
            cell.txtAddress.text=add;
        }
        
        cell.txtCity.text = [NSString stringWithFormat:@"City/Town: %@",[GlobalDirector ReplaceStringNull:[PresentingJob valueForKey:@"City"]]];
        cell.txtCounty.text = [NSString stringWithFormat:@"County: %@",[GlobalDirector ReplaceStringNull:[PresentingJob valueForKey:@"County"]]];
        cell.txtPostCode.text = [NSString stringWithFormat:@"Postcode: %@",[GlobalDirector ReplaceStringNull:[PresentingJob valueForKey:@"PostCode"]]];
 
        
         [cell.btnRecreate addTarget:self action:@selector(pressRecreateDetails:) forControlEvents:UIControlEventTouchUpInside];
         cell.btnRecreate.tag=indexPath.row;
        
        
        
        return cell;
        
    }
    
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    
    if (tableView==tblView)
    {
        NSDictionary *dic=[arrFeedTblPopup objectAtIndex:indexPath.row];
        Activetxtfld.text=[dic valueForKey:@"DisplayText"];
        Activetxtfld.tag=[[dic valueForKey:@"Value"]integerValue];
        
        if (Activetxtfld==txtTimeAllowance)
        {
            txtTimeAllowance.text=(NSString *)[dic valueForKey:@"DisplayText"];
        }
        else if (Activetxtfld==txtJobType)
        {
            txtJobType.text=(NSString *)[dic valueForKey:@"DisplayText"];
        }
        else if (Activetxtfld==txtJobStatus)
        {
            txtJobStatus.text=(NSString *)[dic valueForKey:@"DisplayText"];
        }
        
        [tblView removeFromSuperview];
        tblView=nil;
    }
}

#pragma mark - Map/details button Press Method
-(void)pressMapLocation:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    DLog(@"Selected IndexPath :%ld",(long)btn.tag);
}
-(void)pressRecreateDetails:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    //DLog(@"Selected IndexPath :%ld",(long)btn.tag);
   
    NSMutableDictionary *dicTemp=[_arrRecreatedFrom objectAtIndex:(long)btn.tag];
    DLog(@"JobID :%@",(NSString *)[dicTemp valueForKey:@"JobID"]);
    
    [self viewPopUPFormRecreateMethod:(NSString *)[dicTemp valueForKey:@"JobID"]];
}



#pragma mark - Recreate Description PopUP Method
-(void)viewPopUPFormRecreateMethod:(NSString *)strJobID
{
    
    mainBg = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    mainBg.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    
    bgVw = [[UIView alloc] initWithFrame:CGRectMake(0,0,300,self.view.frame.size.height-100)];
    bgVw.center=CGPointMake(CGRectGetWidth(mainBg.frame)/2.0f, CGRectGetHeight(mainBg.frame)/2.0f);
    [bgVw.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [bgVw.layer setBorderWidth: 0.5];
    [bgVw.layer setCornerRadius:4.0f];
    [bgVw.layer setMasksToBounds:YES];
    bgVw.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    
        
    scrollviewbg = [[UIScrollView alloc] initWithFrame:CGRectMake(5,10,300,self.view.frame.size.height-140)];
    scrollviewbg.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    
    [scrollviewbg setContentSize:CGSizeMake(300, 600)];
    
    //--------- Start Date ---------
    txtStarDate = [[UITextField alloc] initWithFrame:CGRectMake(20,5,240,30)];
    txtStarDate.textColor=[UIColor darkGrayColor];
    txtStarDate.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    [txtStarDate setBorderStyle:UITextBorderStyleNone];
    txtStarDate.layer.borderWidth=0.5f;
    txtStarDate.layer.borderColor=[[UIColor grayColor]CGColor];
    txtStarDate.layer.cornerRadius=6.0f;
    txtStarDate.background=[UIImage imageNamed:@"inputBox5"];
    txtStarDate.delegate = self;
    txtStarDate.userInteractionEnabled=YES;
    txtStarDate.placeholder=@" Start date";
    txtStarDate.inputAccessoryView=numberToolbar;
    txtStarDate.inputView=datepicker;
    
    btnStartDate=[[UIButton alloc]initWithFrame:CGRectMake(205,0, 35, 30)];
    btnStartDate.backgroundColor=[UIColor clearColor];
    [btnStartDate setBackgroundImage:[UIImage imageNamed:@"dropdownCalender"] forState:UIControlStateNormal];
    [btnStartDate addTarget:self action:@selector(DatePicker:) forControlEvents:UIControlEventTouchUpInside];
    btnStartDate.tag=55;
    
    
    
    //--------- Start Time ---------
    txtStartTime = [[UITextField alloc] initWithFrame:CGRectMake(20,45,240,30)];
    txtStartTime.textColor=[UIColor darkGrayColor];
    txtStartTime.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    [txtStartTime setBorderStyle:UITextBorderStyleNone];
    txtStartTime.layer.borderWidth=0.5f;
    txtStartTime.layer.borderColor=[[UIColor grayColor]CGColor];
    txtStartTime.layer.cornerRadius=6.0f;
    txtStartTime.background=[UIImage imageNamed:@"inputBox5"];
    txtStartTime.delegate = self;
    txtStartTime.userInteractionEnabled=YES;
    txtStartTime.placeholder=@" Start time";
    txtStartTime.inputAccessoryView=numberToolbar;
    txtStartTime.inputView=timePicker;

    
    btnStartTime=[[UIButton alloc]initWithFrame:CGRectMake(205,0, 35, 30)];
    btnStartTime.backgroundColor=[UIColor clearColor];
    [btnStartTime setBackgroundImage:[UIImage imageNamed:@"dropdownCalender"] forState:UIControlStateNormal];
    [btnStartTime addTarget:self action:@selector(Timepicker:) forControlEvents:UIControlEventTouchUpInside];
    btnStartTime.tag=66;
    
    
    //--------- End Time ---------

    txtEndTime = [[UITextField alloc] initWithFrame:CGRectMake(20,85,240,30)];
    txtEndTime.textColor=[UIColor darkGrayColor];
    txtEndTime.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    [txtEndTime setBorderStyle:UITextBorderStyleNone];
    txtEndTime.layer.borderWidth=0.5f;
    txtEndTime.layer.borderColor=[[UIColor grayColor]CGColor];
    txtEndTime.layer.cornerRadius=6.0f;
    txtEndTime.background=[UIImage imageNamed:@"inputBox5"];
    txtEndTime.delegate = self;
    txtEndTime.userInteractionEnabled=YES;
    txtEndTime.placeholder=@" End Time";
    txtEndTime.inputAccessoryView=numberToolbar;
    txtEndTime.inputView=timePicker;
    
    btnEndTime=[[UIButton alloc]initWithFrame:CGRectMake(205,0, 35, 30)];
    btnEndTime.backgroundColor=[UIColor clearColor];
    [btnEndTime setBackgroundImage:[UIImage imageNamed:@"dropdownCalender"] forState:UIControlStateNormal];
    [btnEndTime addTarget:self action:@selector(Timepicker:) forControlEvents:UIControlEventTouchUpInside];
    btnEndTime.tag=67;
    

    
    //--------- Time allowance ---------
    txtTimeAllowance = [[UITextField alloc] initWithFrame:CGRectMake(20,125,240,30)];
    txtTimeAllowance.textColor=[UIColor darkGrayColor];
    txtTimeAllowance.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    [txtTimeAllowance setBorderStyle:UITextBorderStyleNone];
    txtTimeAllowance.layer.borderWidth=0.5f;
    txtTimeAllowance.layer.borderColor=[[UIColor grayColor]CGColor];
    txtTimeAllowance.layer.cornerRadius=6.0f;
    txtTimeAllowance.background=[UIImage imageNamed:@"inputBox5"];
    txtTimeAllowance.delegate = self;
    txtTimeAllowance.userInteractionEnabled=YES;
    txtTimeAllowance.placeholder=@"Booking Agent";
    
    UIImageView *imgDropdown3=[[UIImageView alloc] initWithFrame:CGRectMake(225,125, 35, 30)];
    [imgDropdown3 setImage:[UIImage imageNamed:@"dropdown"]];
    
    //-----------Dropdownbutton---------
    
    //--------- Job type ---------
    txtJobType = [[UITextField alloc] initWithFrame:CGRectMake(20,165,240,30)];
    txtJobType.textColor=[UIColor darkGrayColor];
    txtJobType.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    [txtJobType setBorderStyle:UITextBorderStyleNone];
    txtJobType.layer.borderWidth=0.5f;
    txtJobType.layer.borderColor=[[UIColor grayColor]CGColor];
    txtJobType.layer.cornerRadius=6.0f;
    txtJobType.background=[UIImage imageNamed:@"inputBox5"];
    txtJobType.delegate = self;
    txtJobType.userInteractionEnabled=YES;
    txtJobType.placeholder=@" Job Type";
    
    UIImageView *imgDropdown4=[[UIImageView alloc] initWithFrame:CGRectMake(225,165, 35, 30)];
    [imgDropdown4 setImage:[UIImage imageNamed:@"dropdown"]];
    
    //--------- Job status ---------
    txtJobStatus = [[UITextField alloc] initWithFrame:CGRectMake(20,205,240,30)];
    txtJobStatus.textColor=[UIColor darkGrayColor];
    txtJobStatus.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    [txtJobStatus setBorderStyle:UITextBorderStyleNone];
    txtJobStatus.layer.borderWidth=0.5f;
    txtJobStatus.layer.borderColor=[[UIColor grayColor]CGColor];
    txtJobStatus.layer.cornerRadius=6.0f;
    txtJobStatus.background=[UIImage imageNamed:@"inputBox5"];
    //txtJobStatus.delegate = self;
    txtJobStatus.text=@"Booked";
    txtJobStatus.userInteractionEnabled=NO;
    txtJobStatus.placeholder=@" Job Status";
    
    UIImageView *imgDropdown5=[[UIImageView alloc] initWithFrame:CGRectMake(225,160, 35, 30)];
    [imgDropdown5 setImage:[UIImage imageNamed:@"dropdown"]];
    
    //-------- Job Decription -------------
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20,245,240,30)];
    lblTitle.text = @" Job Description";
    lblTitle.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.backgroundColor =[UIColor colorWithRed:52/255.0 green:54/255.0 blue:67/255.0 alpha:0.72];
    [lblTitle.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [lblTitle.layer setBorderWidth: 1.0];
    [lblTitle.layer setCornerRadius:4.0f];
    [lblTitle.layer setMasksToBounds:YES];
    
    txtvNoteBody = [[UITextView alloc] initWithFrame:CGRectMake(20,285,240,120)];
    txtvNoteBody.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    txtvNoteBody.textColor=[UIColor darkGrayColor];
    [txtvNoteBody setBackgroundColor:[UIColor whiteColor]];
    txtvNoteBody.delegate = self;
    [txtvNoteBody.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [txtvNoteBody.layer setBorderWidth: 1.0f];
    [txtvNoteBody.layer setCornerRadius:4.0f];
    [txtvNoteBody.layer setMasksToBounds:YES];
    //-------------------------------------
    
    
    [scrollviewbg addSubview:txtStarDate];
    [txtStarDate addSubview:btnStartDate];
    [scrollviewbg addSubview:txtStartTime];
    [txtStartTime addSubview:btnStartTime];
    [scrollviewbg addSubview:txtEndTime];
    [txtEndTime addSubview:btnEndTime];
    [scrollviewbg addSubview:txtTimeAllowance];
    [scrollviewbg addSubview:imgDropdown3];
    [scrollviewbg addSubview:txtJobType];
    [scrollviewbg addSubview:imgDropdown4];
    [scrollviewbg addSubview:txtJobStatus];
    //[scrollviewbg addSubview:imgDropdown5];
    
    [scrollviewbg addSubview:lblTitle];
    [scrollviewbg addSubview:txtvNoteBody];
    
    btnProceed=[UIButton buttonWithType:UIButtonTypeCustom];
    btnProceed.frame=CGRectMake(0,CGRectGetHeight(scrollviewbg.frame),300,40);
    [btnProceed setTitle:@"Re-Create" forState:UIControlStateNormal];
    [btnProceed setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnProceed.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:18.0];
    [btnProceed setBackgroundColor:[UIColor colorWithRed:30/255.0 green:124/255.0 blue:41/255.0 alpha:1.0]];
    btnProceed.tag=[strJobID integerValue];
    [btnProceed addTarget:self action:@selector(pressRecreateOroceed:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnProceed.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [btnProceed.layer setBorderWidth: 1.0];
    [btnProceed.layer setCornerRadius:0.0f];
    [btnProceed.layer setMasksToBounds:YES];
    
    btnCross=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCross.frame=CGRectMake(0, 0, 25, 25);
    
    btnCross.center=CGPointMake(CGRectGetMaxX(bgVw.frame)-4,CGRectGetMinY(bgVw.frame)+4);
    [btnCross setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
    [btnCross addTarget:self action:@selector(cross:) forControlEvents:UIControlEventTouchUpInside];
    [btnCross clipsToBounds];
    
    [bgVw addSubview:scrollviewbg];
    [bgVw addSubview:btnProceed];
    [mainBg addSubview:bgVw];
    [mainBg addSubview:btnCross];
    [self.view addSubview:mainBg];
}


-(void)cross:(UIButton *)sender
{
    
    [mainBg removeFromSuperview];
    
}


-(void)pressRecreateOroceed:(UIButton *)sender
{
   // [mainBg removeFromSuperview];
    UIButton *btn=(UIButton *)sender;
    
    
    NSString *alertmsg;
    DLog(@"note saved");
    
    if ([txtStarDate.text isEqualToString:@""]||[self BlankSpaces:txtStarDate])
    {
        
        alertmsg=@"Enter Start Date";
        [self Showalert:alertmsg];
        
    }
    else if ([txtStartTime.text isEqualToString:@""]||[self BlankSpaces:txtStartTime])
    {
        alertmsg=@"Enter Start Time";
        [self Showalert:alertmsg];
    }
    else if ([txtEndTime.text isEqualToString:@""]||[self BlankSpaces:txtEndTime])
    {
        alertmsg=@"Enter End Time";
        [self Showalert:alertmsg];
    }
    else if ([txtTimeAllowance.text isEqualToString:@""]||[self BlankSpaces:txtTimeAllowance])
    {
        alertmsg=@"Enter Booking Agent";
        [self Showalert:alertmsg];
        
    }
    else if ([txtJobType.text isEqualToString:@""]||[self BlankSpaces:txtJobType])
    {
        alertmsg=@"Enter Job Type";
        [self Showalert:alertmsg];
    }
    else if ([txtJobStatus.text isEqualToString:@""]||[self BlankSpaces:txtJobStatus])
    {
        alertmsg=@"Enter Job Status";
        [self Showalert:alertmsg];
    }
    else if ([txtvNoteBody.text isEqualToString:@""]||[self BlankSpaces:txtvNoteBody])
    {
        alertmsg=@"Enter Job Note";
        [self Showalert:alertmsg];
    }
    else
    {
        
        NSDictionary *user = [[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
        
       
        
        NSString *strjobidd=[NSString stringWithFormat:@"%ld",(long)btn.tag];
        
       
        
        //**********************************************************************************
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSDate *date = [dateFormatter dateFromString:txtStarDate.text];
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *newDateString = [dateFormatter stringFromDate:date];
        //**********************************************************************************
        
         DLog(@"Converted txtStarDate :%@",newDateString);
        
        [self postRecreateConfirmation:(NSString *)[user valueForKey:@"UserToken"] existingjobid:strjobidd createdby:(NSString *)[user valueForKey:@"UserID"] description:txtvNoteBody.text startdate:(NSString *)newDateString starttime:(NSString *)txtStartTime.text endtime:(NSString *)txtEndTime.text
                         
                    timeallowance:(long)txtTimeAllowance.tag jobtypeid:(long)txtJobType.tag jobstatusid:1];
    }
    
}



-(void)postRecreateConfirmation:(NSString *)strUserToken existingjobid:(NSString *)strJobID createdby:(NSString *)strUserID description:(NSString *)strDescription startdate:(NSString *)strStartDate starttime:(NSString *)strStartTime endtime:(NSString *)strEndTime timeallowance:(long)BookingAgentId jobtypeid:(long)isJobTypeID jobstatusid:(long) isJobStatusID
{
    
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString;
    
    urlString=[NSString stringWithFormat:@"%sRecreateExistingJob?userToken=%@&existingJobID=%@&createdBy=%@&jobStartDate=%@&StartTime=%@&EndTime=%@&BookingAgentId=%ld&JobTypeID=%ld&CurrentActivityId=%ld&jobDescription=%@",conn_url,strUserToken,strJobID,strUserID,strStartDate,strStartTime,strEndTime,BookingAgentId,isJobTypeID,isJobStatusID,strDescription];

    
    urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
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
    
    connRecreateConfirmation = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connRecreateConfirmation start];
    
    
}




#pragma mark - Ok / cancel
-(void)cancel
{
    
   [self.view endEditing:YES];
    
}
-(void)OK
{
   [self.view endEditing:YES];
    
     }

#pragma mark - Date Picker Method
-(void)DatePicker:(id)sender
{
    if (numberToolbar==nil) {
        numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,310, 320, 50)];
    }
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.barTintColor=[UIColor lightGrayColor];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(OK)],
                           nil];
    [numberToolbar sizeToFit];
    //[mainBg addSubview:numberToolbar];
    txtStarDate.inputAccessoryView=numberToolbar;
    txtStartTime.inputAccessoryView=numberToolbar;
    txtEndTime.inputAccessoryView=numberToolbar;
    
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
    txtStarDate.inputAccessoryView=numberToolbar;
    txtStartTime.inputAccessoryView=numberToolbar;
    txtEndTime.inputAccessoryView=numberToolbar;
    //[mainBg addSubview:numberToolbar];
    
    timePicker= [[UIDatePicker alloc] initWithFrame:CGRectZero];
    timePicker.datePickerMode = UIDatePickerModeTime;
    timePicker.backgroundColor = [UIColor whiteColor];
    [timePicker addTarget:self action:@selector(timeUpdated:) forControlEvents:UIControlEventValueChanged];
    timePicker.minuteInterval = 5;
    txtStartTime.inputView=timePicker;
    txtEndTime.inputView=timePicker;
}

#pragma mark - Date Updated Method
- (void) dateUpdated:(UIDatePicker *)datePicker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    UITextField *actvfld=(UITextField *)txtStarDate;
    actvfld.text = [formatter stringFromDate:datePicker.date];
}

#pragma mark - Time Updated Method
- (void) timeUpdated:(UIDatePicker *)datePicker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    UITextField *actvfld=(UITextField *)txtStartTime;
    actvfld.text = [formatter stringFromDate:datePicker.date];
    UITextField *actvfld1=(UITextField *)txtEndTime;
    actvfld1.text = [formatter stringFromDate:datePicker.date];
}

#pragma mark - Textfield Delegate Method
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
   
    if (textField==txtTimeAllowance||textField==txtJobType)
    {
        Activetxtfld=textField;
       
        [txtStarDate resignFirstResponder];
        [txtStartTime resignFirstResponder];
        [txtEndTime resignFirstResponder];
        
        [Activetxtfld resignFirstResponder];
       
        Activetxtfld=textField;
        [self popupList];
        
        return NO;
    }
    else if (textField==txtStarDate)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        txtStarDate.text=[formatter stringFromDate:[NSDate date]];
        if (tblView!=nil)
        {
            [tblView removeFromSuperview];
            tblView=nil;
        }
        
    }
    else if (textField==txtStartTime)
    {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        txtStartTime.text=[formatter stringFromDate:[NSDate date]];
        if (tblView!=nil)
        {
            [tblView removeFromSuperview];
            tblView=nil;
        }
    }
    else if (textField==txtEndTime)
    {
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"HH:mm"];
        txtEndTime.text=[formatter1 stringFromDate:[NSDate date]];
        if (tblView!=nil)
        {
            [tblView removeFromSuperview];
            tblView=nil;
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
        [textView resignFirstResponder];
    return YES;
}

#pragma mark - SearchBar Delegate/Datasource
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    DLog(@"search button clicked");
    _arrRecreatedFrom=nil;
    [tblView reloadData];
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *urlString;
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        urlString=[NSString stringWithFormat:@"%sRecreateEngMngrJobSearch?userToken=%@&searchParam=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],searchBar.text];
        
    }
    else  if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        
        urlString=[NSString stringWithFormat:@"%sRecreateEngineerJobSearch?userToken=%@&postCode=%@&userID=%@&staffID=%@&IsEngineer=true",conn_url,(NSString *)[user valueForKey:@"UserToken"],searchBar.text,(NSString *)[user valueForKey:@"UserID"],(NSString *)[user valueForKey:@"StaffID"]];
        
    }
    else
    {
        urlString=[NSString stringWithFormat:@"%sRecreateEngineerJobSearch?userToken=%@&postCode=%@&userID=%@&staffID=%@&IsEngineer=false",conn_url,(NSString *)[user valueForKey:@"UserToken"],searchBar.text,(NSString *)[user valueForKey:@"UserID"],(NSString *)[user valueForKey:@"StaffID"]];
        
    }
    
    //DLog(@"urlString :%@",urlString);
    
    [self fetchRecraeteJobListdetailsWithURL:urlString];
    
    
    [searchBar resignFirstResponder];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    DLog(@"search cancel clicked");
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSPredicate *searchSearch = [NSPredicate predicateWithFormat:@"self CONTAINS[cd] %@", searchText];
    NSArray *searchResults = [_arrRecreatedFrom filteredArrayUsingPredicate:searchSearch];
    DLog(@"%@", searchResults);
}

#pragma mark - Fetch Job List for Re-Create
-(void)fetchRecraeteJobListdetailsWithURL:(NSString *)urlString
{
    NSString *post =[NSString stringWithFormat:@""];
   
    urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
     DLog(@"PostString=%@",urlString);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:300.0];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    _spinner.hidden=NO;
    [self.view bringSubviewToFront:_spinner];
    [_spinner startAnimating];
    [conn start];
}



#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}



- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    return nil;
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [_spinner stopAnimating];
    [_spinner setHidesWhenStopped:YES];
    
    NSMutableDictionary* temp;
    if (_responseData !=nil)
    {
        NSError *error;
        temp = [NSJSONSerialization JSONObjectWithData:_responseData  options:NSJSONReadingMutableContainers error:&error];
        if (!error)
        {
            if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
            {
                [_spinner stopAnimating];
                [_spinner setHidesWhenStopped:YES];
                
                id jobs=[temp objectForKey:@"JobListResponse"];
                if ([jobs isKindOfClass:[NSArray class]]){
                    _arrRecreatedFrom=jobs;
                }
                
                if (connection==connRecreateConfirmation)
                {
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @""
                                                        message:@"New Job Re-Created successfully"
                                                                                 preferredStyle: UIAlertControllerStyleAlert];
                    
                    
                    
                    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
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
                [_spinner stopAnimating];
                [_spinner setHidesWhenStopped:YES];
                DLog(@"JSONObjectWithData error: %@", error);
                
                
                    [self showAlert:[NSString stringWithFormat:@"%@",[temp valueForKey:@"ResponseMessages"]]  withTitle:@""];
                
                
              /*  if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
                {
                    [self showAlert:@"No job found" withTitle:@""];
                    
                    
                }
                else
                {
                    [self showAlert:@"No job found" withTitle:@""];
                    
                }*/
            }
        }
    }
    else
    {
        [_spinner stopAnimating];
        [_spinner setHidesWhenStopped:YES];
    }
    
    [_tblRecreate reloadData];
    
   // DLog(@"_arrRecreatedFrom :::::%@",_arrRecreatedFrom);
    
}




- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_spinner stopAnimating];
    [_spinner setHidesWhenStopped:YES];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
   // [[[UIAlertView alloc]initWithTitle:@"Error" message:@"No network connection. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
     [self showAlert:@"No network connection. Please try again later."  withTitle:@"Error"];
}



#pragma mark - Pop Up list Fetch / Show Method
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
        tblView=[[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMinX(Activetxtfld.frame),CGRectGetMaxY(Activetxtfld.frame)+1, CGRectGetWidth(Activetxtfld.frame), 0) style:UITableViewStylePlain];
        tblView.delegate=self;
        tblView.dataSource=self;
        [scrollviewbg addSubview:tblView];
        
        
        
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
    
    if (fld==txtTimeAllowance)
    {
        
       
        [self FetchDataForField:@"GetBookedAgent"];
        
        
        
    }
    else if (fld==txtJobType) {
        
       
        [self FetchDataForField:@"GetJobNatureList"];
        
    }
    else if (fld==txtJobStatus) {
      
         [self FetchDataForField:@"GetJobStatus"];
        
    }
    
    return nil;
    
}

#pragma mark - check Blank Space Method
-(void)Showalert:(NSString *)msg
{
   // [[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
     [self showAlert:msg withTitle:@""];
}






-(BOOL)BlankSpaces:(id )txtfld
{
    NSString *rawString;
    if([txtfld isKindOfClass:[UITextField class]])
    {
        rawString=[(UITextField*)txtfld text];
        
    }
    if([txtfld isKindOfClass:[UITextView class]])
    {
        rawString=[(UITextView*)txtfld text];
        
    }
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    if ([trimmed length] == 0) {
        // Text was empty or only whitespace.
        return YES;
        
    }
    return NO;
    
}

#pragma mark - Master Fetch Web Service Method

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


@end
