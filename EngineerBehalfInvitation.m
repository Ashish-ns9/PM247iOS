//
//  EngineerBehalfInvitation.m
//  Partner Maintenance
//


#import "EngineerBehalfInvitation.h"
#import "DefaultSettings.h"


@interface EngineerBehalfInvitation ()

@end

@implementation EngineerBehalfInvitation
@synthesize btnSlideMenu;

#pragma mark ViewDidLoad Method
- (void)viewDidLoad
{
    [super viewDidLoad];
  
    
    self.navigationController.navigationBarHidden=YES;
  
    
    InvitedJobs =[[NSMutableArray alloc]init];
    arrMselectedFE=[[NSMutableArray alloc]init];
    arrInvitedEngg=[[NSMutableArray alloc]init];
    
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
    
    [self fetchInvitedJobdetails];
    
    
     page=0;
    
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


#pragma mark TableView Delegate && Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 145;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
   return  [InvitedJobs count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tblarr;
    //NSString *orgType;
    static NSString *cellidentifier=@"cellidentifier";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellidentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.backgroundColor=[UIColor clearColor];
    
    tblarr=InvitedJobs;
    UIImageView *imgvCellbg;
    imgvCellbg=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(_tabvInvitationList.frame),145)];
    [imgvCellbg setImage:[UIImage imageNamed:@"jobBox_clearbg"]];
    [cell.contentView addSubview:imgvCellbg];
    
    
    NSDictionary *dicTemp=[tblarr objectAtIndex:indexPath.row];
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
    

    UIButton *btnMapLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMapLocation.frame = CGRectMake(0,0,110,110);
    btnMapLocation.center=CGPointMake(CGRectGetMinX(imgvCellbg.frame)+CGRectGetWidth(btnMapLocation.frame)/2.0f+10,CGRectGetHeight(imgvCellbg.frame)/2.0f);
    btnMapLocation.tag=indexPath.row;
    [btnMapLocation setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [btnMapLocation addTarget:self action:@selector(pressMapLocation:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btnMapLocation];
    
    
    UIButton *btnagree=[UIButton buttonWithType:UIButtonTypeCustom];
    btnagree.frame=CGRectMake(CGRectGetMaxX(imgvCellbg.frame)-50,CGRectGetMaxY(btnMapLocation.frame)-35,40,40);
    btnagree.tag=indexPath.row;
    [btnagree setBackgroundImage:[UIImage imageNamed:@"e-Sigagree"] forState:UIControlStateNormal];
    [btnagree setBackgroundColor:[UIColor clearColor]];
    [btnagree addTarget:self action:@selector(agree:) forControlEvents:UIControlEventTouchUpInside];
    btnagree.titleLabel.textColor=[UIColor colorWithRed:26/255.0 green:137/255.0 blue:44/255.0 alpha:1.0];
    btnagree.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:16.0];
    [cell.contentView addSubview:btnagree];
    
    //----------------- Refuse ------------
    UIButton *btnRefuse=[UIButton buttonWithType:UIButtonTypeCustom];
    btnRefuse.frame=CGRectMake(CGRectGetMaxX(imgvCellbg.frame)-50,CGRectGetMinY(btnagree.frame),40,40);
    //btnRefuse.tag=[[dicTemp objectForKey:@"JobID"] integerValue];
    [btnRefuse setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
    [btnRefuse setBackgroundColor:[UIColor clearColor]];
    [btnRefuse addTarget:self action:@selector(refuse:) forControlEvents:UIControlEventTouchUpInside];
    btnRefuse.titleLabel.textColor=[UIColor colorWithRed:26/255.0 green:137/255.0 blue:44/255.0 alpha:1.0];
    btnRefuse.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:16.0];
   // [cell.contentView addSubview:btnRefuse];
    
    
    NSLog(@"dicTemp :%@",dicTemp);
    
    //------------------------------------------------ BOX -----------------------------------------------------------
    UILabel *lblAddressBorder=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btnMapLocation.frame),CGRectGetMinY(btnMapLocation.frame),btnMapLocation.frame.size.width,btnMapLocation.frame.size.height)];
    [lblAddressBorder.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [lblAddressBorder.layer setBorderWidth: 1.0];
    [lblAddressBorder.layer setCornerRadius:2.0f];
    [lblAddressBorder.layer setMasksToBounds:YES];
    [cell.contentView addSubview:lblAddressBorder];
    
    //---- Start Date ----
    UILabel *lblDateStart=[[UILabel alloc] initWithFrame:CGRectMake(13,CGRectGetMinY(lblAddressBorder.frame)+15,100,15)];
    lblDateStart.textAlignment=NSTextAlignmentLeft;
    lblDateStart.textColor=[UIColor darkGrayColor];
    lblDateStart.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:10.8];
    lblDateStart.backgroundColor=[UIColor clearColor];
    lblDateStart.text=[NSString stringWithFormat:@"%@",@""];
    
    if ([dicTemp valueForKey:@"JobStartDate"])
    {
        NSString *dateString =[dicTemp valueForKey:@"JobStartDate"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:dateString];
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"dd/MM/yyyy"];
        NSString *stringDate = [dateFormatter1 stringFromDate:dateFromString];
        NSLog(@"%@", stringDate);
        
        lblDateStart.text=[NSString stringWithFormat:@"Start Date: %@",stringDate];
    }
    else
    {
        lblDateStart.text=@"";
    }
    
    lblDateStart.numberOfLines=1;
    [lblDateStart setAdjustsFontSizeToFitWidth:YES];
    [cell.contentView addSubview:lblDateStart];
    
    //---- Start Time ----
    UILabel *lblTimeStart=[[UILabel alloc] initWithFrame:CGRectMake(13,CGRectGetMaxY(lblDateStart.frame)+6,100,15)];
    lblTimeStart.textAlignment=NSTextAlignmentLeft;
    lblTimeStart.textColor=[UIColor darkGrayColor];
    lblTimeStart.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:10.8];
    lblTimeStart.backgroundColor=[UIColor clearColor];
    lblTimeStart.text=[NSString stringWithFormat:@"%@",@""];
    if ([dicTemp valueForKey:@"JobStartTime"])
    {
        lblTimeStart.text=[NSString stringWithFormat:@"Start Time: %@",[dicTemp valueForKey:@"JobStartTime"]];
    }
    else
    {
        lblTimeStart.text=@"";
    }
    lblTimeStart.numberOfLines=1;
    [lblTimeStart sizeToFit];
    [cell.contentView addSubview:lblTimeStart];
    
    //---- End Time ----

    
    
    
    //---- Time Allowance ----
    UILabel *lblTimeAllowance=[[UILabel alloc] initWithFrame:CGRectMake(13,CGRectGetMaxY(lblTimeStart.frame)+7,100,15)];
    lblTimeAllowance.textAlignment=NSTextAlignmentLeft;
    lblTimeAllowance.textColor=[UIColor darkGrayColor];
    lblTimeAllowance.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:10.8];
    lblTimeAllowance.backgroundColor=[UIColor clearColor];
    lblTimeAllowance.text=[NSString stringWithFormat:@"%@",@""];
    if ([dicTemp valueForKey:@"TimeAllowance"])
    {
        lblTimeAllowance.text=[NSString stringWithFormat:@"Time Allowance: %@",[dicTemp valueForKey:@"TimeAllowance"]];
    }
    else
    {
        lblTimeAllowance.text=@"";
    }
    lblTimeAllowance.numberOfLines=2;
    [lblTimeAllowance sizeToFit];
    [cell.contentView addSubview:lblTimeAllowance];
    //------------------------------------------------------------------------
    
    //-----------  JobDescription --------------------------------------------
    UILabel *lblJobTitle;
    lblJobTitle=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnMapLocation.frame)+5,CGRectGetMinY(btnMapLocation.frame),220,40)];
    lblJobTitle.textAlignment=NSTextAlignmentLeft;
    lblJobTitle.textColor=[UIColor darkGrayColor];
    lblJobTitle.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:13.0];
    lblJobTitle.backgroundColor=[UIColor clearColor];
    if (![[dicTemp valueForKey:@"JobDescription"] isKindOfClass:[NSNull class]]){
        lblJobTitle.text=[dicTemp valueForKey:@"JobDescription"];
    }else{
        lblJobTitle.text=@"";
    }
    lblJobTitle.numberOfLines=2;
    [cell.contentView addSubview:lblJobTitle];
    
    //----------- Customer Name ----------------------------------------
    UILabel *lblName;
    lblName=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lblJobTitle.frame),CGRectGetMaxY(lblJobTitle.frame)+2,150,15)];
    lblName.textAlignment=NSTextAlignmentLeft;
    lblName.textColor=[UIColor lightGrayColor];
    lblName.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
    lblName.backgroundColor=[UIColor clearColor];
    lblName.text=[NSString stringWithFormat:@"%@",@"Customer name"];
    if (![[PresentingUser valueForKey:@"FullName"] isKindOfClass:[NSNull class]]) {
        lblName.text=[PresentingUser valueForKey:@"FullName"];
    }
    [cell.contentView addSubview:lblName];
    
    //----------- Start date time ----------------------------------------
    UIImageView *imgvTimeP=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(lblJobTitle.frame),CGRectGetMaxY(lblName.frame)+5, 13, 12)];
    [imgvTimeP setImage:[UIImage imageNamed:@"clock_icon"]];
    [cell.contentView addSubview:imgvTimeP];
    
    UILabel *lblTimePeriod;
    lblTimePeriod=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgvTimeP.frame)+2,CGRectGetMinY(imgvTimeP.frame),220,15)];
    lblTimePeriod.center=CGPointMake(CGRectGetMaxX(imgvTimeP.frame)+CGRectGetWidth(lblTimePeriod.frame)/2.0f+5, imgvTimeP.center.y);
    lblTimePeriod.textAlignment=NSTextAlignmentLeft;
    lblTimePeriod.textColor=[UIColor lightGrayColor];
    lblTimePeriod.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
    lblTimePeriod.backgroundColor=[UIColor clearColor];
    lblTimePeriod.text=[NSString stringWithFormat:@"%@",@""];
    //JobStartDate   DateJobPost JobStartTime
    if (![[dicTemp valueForKey:@"JobStartDate"] isKindOfClass:[NSNull class]])
    {
        NSString *strStartDate =[NSString stringWithFormat:@"%@",[dicTemp valueForKey:@"JobStartDate"]];
        //strStartDate = [strStartDate substringToIndex:10];
        lblTimePeriod.text=[NSString stringWithFormat:@"%@ %@",strStartDate,[dicTemp valueForKey:@"JobStartTime"]];
    }
    [cell.contentView addSubview:lblTimePeriod];
    
    //----------- Job Address ----------------------------------------
    UIImageView *imgvAddr=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(lblJobTitle.frame),CGRectGetMaxY(lblTimePeriod.frame)+5, 14, 12)];
    imgvAddr.center=CGPointMake(imgvTimeP.center.x,CGRectGetMaxY(imgvTimeP.frame)+CGRectGetHeight(imgvAddr.frame)/2.0f+5);
    [imgvAddr setImage:[UIImage imageNamed:@"address_icon"]];
    [cell.contentView addSubview:imgvAddr];
    
    UILabel *lblAddress;
    lblAddress=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lblJobTitle.frame),CGRectGetMaxY(lblTimePeriod.frame)+5,170,15)];
    lblAddress.center=CGPointMake(CGRectGetMaxX(imgvAddr.frame)+CGRectGetWidth(lblAddress.frame)/2.0f+3, imgvAddr.center.y);
    lblAddress.textAlignment=NSTextAlignmentLeft;
    lblAddress.textColor=[UIColor lightGrayColor];
    lblAddress.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:10.8];
    lblAddress.backgroundColor=[UIColor clearColor];
    lblAddress.text=[NSString stringWithFormat:@"%@",@""];
    
    NSString *city = [GlobalDirector ReplaceStringNull:[PresentingJob valueForKey:@"City"]];
    NSString *address = [GlobalDirector ReplaceStringNull:[PresentingJob valueForKey:@"Address"]];
    
    
    if (city.length>0 || address.length>0 ) {
        lblAddress.text=[NSString stringWithFormat:@"%@,%@",city,address];
    }else {
         lblAddress.text=@"";
    }
   
    
    
    lblAddress.numberOfLines=2;
    lblAddress.lineBreakMode=NSLineBreakByWordWrapping;
    [lblAddress sizeToFit];
    [cell.contentView addSubview:lblAddress];
    
     return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}


-(void)fetchInvitedJobdetails
{
    
    self.activity.hidden=NO;
    [self.activity startAnimating];
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString;
    
    
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
  
    urlString=[NSString stringWithFormat:@"%sGetJobListInvitedToEngineer?userToken=%@&staffID=%@&page=%ld",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[user valueForKey:@"StaffID"],(long)page];
    
    [post stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    // DLog(@"PostString=%@",urlString);
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
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    
}

-(void)pressMapLocation:(UIButton *)sender
{
    
}
-(void)refuse:(UIButton *)sender
{
    
}

-(void)agree:(UIButton *)sender
{
    DLog(@"%ld",(long)sender.tag);
    
    bgVw =[[UIControl alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [bgVw addTarget:self action:@selector(bgPopupTouched:) forControlEvents:UIControlEventTouchUpInside];
    bgVw.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.3f];
    
    popUpVW=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 280, 340)];
    popUpVW.layer.cornerRadius=6.0f;
    popUpVW.backgroundColor=[UIColor whiteColor];
    popUpVW.center=bgVw.center;
    
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0,0,280,35)];
    lbl.text=@"Accept On Behalf Of ";
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.textColor=[UIColor whiteColor];
    lbl.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:16.0];
    lbl.backgroundColor=[UIColor colorWithRed:220/255.0 green:164/255.0 blue:102/255.0 alpha:1.0];
    [popUpVW addSubview:lbl];
    
    self.activity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activity.color=[UIColor blackColor];
    self.activity.center=CGPointMake(CGRectGetWidth(popUpVW.frame)/2.0f, CGRectGetHeight(popUpVW.frame)/2.0f);
    [popUpVW addSubview:self.activity];
    [self.activity startAnimating];
    
    UIButton *btncross=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    btncross.center=CGPointMake(CGRectGetMaxX(popUpVW.frame), CGRectGetMinY(popUpVW.frame));
    btncross.backgroundColor=[UIColor clearColor];
    [btncross setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
    [btncross clipsToBounds];
    [btncross addTarget:self action:@selector(bgPopupTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        
    UIButton *accept=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, popUpVW.frame.size.width, 50)];
    accept.titleLabel.textColor=[UIColor greenColor];
    accept.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:17.0];
    [accept setTitle:@"Accept" forState:UIControlStateNormal];
    accept.tag=sender.tag;
    [accept addTarget:self action:@selector(accept:) forControlEvents:UIControlEventTouchUpInside];
    accept.center=CGPointMake(popUpVW.center.x, CGRectGetMaxY(popUpVW.frame)+CGRectGetHeight(accept.frame)/2.0f+3);
    accept.backgroundColor=[UIColor colorWithRed:26/255.0 green:137/255.0 blue:44/255.0 alpha:1.0];
    
    
    [bgVw addSubview:popUpVW];
    [bgVw addSubview:btncross];
    [bgVw addSubview:accept];
    [self.view addSubview:bgVw];
    [self FetchInvitedEngg:sender.tag];
}

#pragma mark Agreement
-(void)showPopUpAgreementPage11:(long)isSelectedRow
{
    mainBg11 = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    mainBg11.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    
    bgVw11 = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width-30,self.view.frame.size.height-80)];
    bgVw11.center=CGPointMake(CGRectGetWidth(mainBg11.frame)/2.0f, CGRectGetHeight(mainBg11.frame)/2.0f);
    [bgVw11.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [bgVw11.layer setBorderWidth: 0.5];
    [bgVw11.layer setCornerRadius:4.0f];
    [bgVw11.layer setMasksToBounds:YES];
    bgVw11.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    
    
    
    UITextView *txtvAgreement = [[UITextView alloc] initWithFrame:CGRectMake(5,20,CGRectGetWidth(bgVw11.frame)-10,CGRectGetHeight(bgVw11.frame)-50)];
    txtvAgreement.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
    txtvAgreement.textColor=[UIColor darkGrayColor];
    [txtvAgreement setBackgroundColor:[UIColor whiteColor]];
    txtvAgreement.editable=NO;
    
    MBProgressHUD *hudshow=[MBProgressHUD showHUDAddedTo:txtvAgreement animated:YES];
    hudshow.labelText=@"loading T&C ...";
    
    [self getAgreement:@"AcceptDecline_Agree1" loadingCompleted:^(BOOL completed,NSString *htmlString){
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        txtvAgreement.attributedText = attributedString;
        
        [MBProgressHUD hideAllHUDsForView:txtvAgreement animated:YES];
        
        
        
    }];
    
    [txtvAgreement.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [txtvAgreement.layer setBorderWidth: 0.5];
    [txtvAgreement.layer setCornerRadius:0.0f];
    [txtvAgreement.layer setMasksToBounds:YES];
    
    UIButton *btnacceptYes11 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnacceptYes11.frame = CGRectMake(CGRectGetWidth(bgVw11.frame)/2.0f,bgVw11.frame.size.height-40,CGRectGetWidth(bgVw11.frame)/2.0f,40);
    [btnacceptYes11 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnacceptYes11.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    btnacceptYes11.tag=isSelectedRow;
    [btnacceptYes11 setTitle:@"Accept" forState:UIControlStateNormal];
    [btnacceptYes11 setBackgroundColor:[UIColor colorWithRed:120/255.0 green:171/255.0 blue:30/255.0 alpha:1.0]];
    [btnacceptYes11 addTarget:self action:@selector(pressAcceptYes11:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btndeclineNo11 = [UIButton buttonWithType:UIButtonTypeCustom];
    btndeclineNo11.frame = CGRectMake(0,bgVw11.frame.size.height-40,CGRectGetWidth(bgVw11.frame)/2.0f,40);
    [btndeclineNo11 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btndeclineNo11.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    btndeclineNo11.tag=11;
    [btndeclineNo11 setTitle:@"Decline" forState:UIControlStateNormal];
    [btndeclineNo11 setBackgroundColor:[UIColor colorWithRed:214/255.0 green:100/255.0 blue:4/255.0 alpha:1.0]];
    [btndeclineNo11 addTarget:self action:@selector(pressDeclineNo11:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [bgVw11 addSubview:txtvAgreement];
    [bgVw11 addSubview:btnacceptYes11];
    [bgVw11 addSubview:btndeclineNo11];
    
    [mainBg11 addSubview:bgVw11];
    [self.view addSubview:mainBg11];
}
-(void)pressAcceptYes11:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    DLog(@"selected Row  :%ld",(long)btn.tag);
    [mainBg11 removeFromSuperview];
    [self showPopUpAgreementPage22:btn.tag];
}
-(void)pressDeclineNo11:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    DLog(@"tag :%ld",(long)btn.tag);
    [self.dataTaskAgr cancel];
    [mainBg11 removeFromSuperview];
}

#pragma mark - Accept Agreement2 PopUp
-(void)showPopUpAgreementPage22:(long)isSelectedRow22
{
    mainBg22 = [[UIControl alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    mainBg22.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    
    bgVw22 = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width-30,self.view.frame.size.height-80)];
    bgVw22.center=CGPointMake(CGRectGetWidth(mainBg22.frame)/2.0f, CGRectGetHeight(mainBg22.frame)/2.0f);
    [bgVw22.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [bgVw22.layer setBorderWidth: 0.5];
    [bgVw22.layer setCornerRadius:4.0f];
    [bgVw22.layer setMasksToBounds:YES];
    bgVw22.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    
    UITextView *txtvAgreement = [[UITextView alloc] initWithFrame:CGRectMake(5,20,CGRectGetWidth(bgVw22.frame)-10,CGRectGetHeight(bgVw22.frame)-50)];
    txtvAgreement.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
    txtvAgreement.textColor=[UIColor darkGrayColor];
    [txtvAgreement setBackgroundColor:[UIColor whiteColor]];
    txtvAgreement.editable=NO;
    MBProgressHUD *hudshow=[MBProgressHUD showHUDAddedTo:txtvAgreement animated:YES];
    hudshow.labelText=@"loading T&C ...";
    
    [self getAgreement:@"AcceptDecline_Agree2" loadingCompleted:^(BOOL completed,NSString *htmlString){
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        txtvAgreement.attributedText = attributedString;
        
        [MBProgressHUD hideAllHUDsForView:txtvAgreement animated:YES];
        
        
        
    }];
    
    [txtvAgreement.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [txtvAgreement.layer setBorderWidth: 1.0];
    [txtvAgreement.layer setCornerRadius:4.0f];
    [txtvAgreement.layer setMasksToBounds:YES];
    
    UIButton *btnacceptYes22 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnacceptYes22.frame = CGRectMake(CGRectGetWidth(bgVw22.frame)/2.0f,bgVw22.frame.size.height-40,CGRectGetWidth(bgVw22.frame)/2.0f,40);
    [btnacceptYes22 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnacceptYes22.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    btnacceptYes22.tag=isSelectedRow22;
    [btnacceptYes22 setTitle:@"Accept" forState:UIControlStateNormal];
    [btnacceptYes22 setBackgroundColor:[UIColor colorWithRed:120/255.0 green:171/255.0 blue:30/255.0 alpha:1.0]];
    [btnacceptYes22 addTarget:self action:@selector(pressAcceptYes22:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btndeclineNo22 = [UIButton buttonWithType:UIButtonTypeCustom];
    btndeclineNo22.frame = CGRectMake(0,bgVw22.frame.size.height-40,CGRectGetWidth(bgVw22.frame)/2.0f,40);
    [btndeclineNo22 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btndeclineNo22.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    btndeclineNo22.tag=22;
    [btndeclineNo22 setTitle:@"Decline" forState:UIControlStateNormal];
    [btndeclineNo22 setBackgroundColor:[UIColor colorWithRed:214/255.0 green:100/255.0 blue:4/255.0 alpha:1.0]];
    [btndeclineNo22 addTarget:self action:@selector(pressDeclineNo22:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [bgVw22 addSubview:txtvAgreement];
    [bgVw22 addSubview:btnacceptYes22];
    [bgVw22 addSubview:btndeclineNo22];
    
    [mainBg22 addSubview:bgVw22];
    [self.view addSubview:mainBg22];
}
-(void)pressAcceptYes22:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    DLog(@"selected Row  :%ld",(long)btn.tag);
    [mainBg22 removeFromSuperview];
    
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSDictionary* jobDic=[InvitedJobs objectAtIndex:btn.tag];
    NSDictionary* enggDic=[arrMselectedFE objectAtIndex:0];
    
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString=[NSString stringWithFormat:@"%sAcceptJobByEngineer?userToken=%@&staffID=%@&jobID=%ld&companyID=0",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[enggDic valueForKey:@"StaffID"],(long)[[jobDic valueForKey:@"JobID"]integerValue]];
   // DLog(@"PostString=%@",urlString);
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
    
    //NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    //DLog(@"%@",data);
    
    [MBProgressHUD showHUDAddedTo:popUpVW animated:YES];
    
    connAccept = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connAccept start];
    
}
-(void)pressDeclineNo22:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    DLog(@"tag :%ld",(long)btn.tag);
    [self.dataTaskAgr cancel];
    [mainBg22 removeFromSuperview];
    [mainBg33 removeFromSuperview];
    
}






-(IBAction)accept:(UIButton*)sender{
    
    
    if (arrMselectedFE.count==0) {
        [self showAlert:@"Select One Engineer to active" withTitle:@"Wait"];
    
    }
    else
    {
        DLog(@"%ld",(long)sender.tag);
       /* UIAlertView *showalrt= [[UIAlertView alloc]initWithTitle:@"Alert" message:@"you are able to accept the following agreements on behalf of the engineer. Do you want to continue?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        showalrt.tag=sender.tag;
        
        [showalrt show];*/
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Alert"
                                                                            message:@"you are able to accept the following agreements on behalf of the engineer. Do you want to continue?"
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle: @"Cancel"
                                                                    style: UIAlertActionStyleDestructive
                                                                  handler: ^(UIAlertAction *action) {
                                                                      
                                                                  }];
        
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                [self showPopUpAgreementPage11:sender.tag];
                                                                
                                                            }];
        
        
        
        [controller addAction: alertActionCancel];
        [controller addAction: alertAction];
        
        [self presentViewController: controller animated: YES completion: nil];

        
    
    }
    
}




-(UIControl *)enggDetails:(NSDictionary *)EnggDic
{
    UIControl *vw=[[UIControl alloc]initWithFrame:CGRectMake(0, 0,250,50)];
    vw.backgroundColor=[UIColor lightGrayColor];
    vw.layer.borderWidth=0.5f;
    vw.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    vw.layer.cornerRadius=0.0f;
    
    UIImageView *chk=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    chk.center=CGPointMake(CGRectGetWidth(chk.frame)/2.0f+10, vw.center.y);
    chk.layer.borderColor=[[UIColor grayColor]CGColor];
    chk.image=[UIImage imageNamed:@"uncheck"];
    
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 28)];
    lblName.text=[NSString stringWithFormat:@"%@ %@",[EnggDic valueForKey:@"FirstName"],[EnggDic valueForKey:@"LastName"]];
    lblName.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    lblName.center=CGPointMake(CGRectGetMaxX(chk.frame)+CGRectGetWidth(lblName.frame)/2.0f+5, vw.center.y);
    lblName.backgroundColor=[UIColor clearColor];
    
    
    [vw addSubview:chk];
    [vw addSubview:lblName];
    
    imgvstatusCrcl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    imgvstatusCrcl.center=CGPointMake(CGRectGetWidth(vw.frame)-CGRectGetWidth(imgvstatusCrcl.frame)/2.0f-10, vw.center.y);
    imgvstatusCrcl.layer.borderColor=[[UIColor whiteColor]CGColor];
    imgvstatusCrcl.layer.borderWidth=2.0f;
    imgvstatusCrcl.layer.cornerRadius=9.0f;
    imgvstatusCrcl.layer.masksToBounds=YES;
    [vw addSubview:imgvstatusCrcl];
    
    
    if ([[EnggDic valueForKey:@"IsInvited"]integerValue]==1)
    {
        chk.image=[UIImage imageNamed:@"check"];
        vw.userInteractionEnabled=NO;
        
        if ([[EnggDic valueForKey:@"IsActive"]integerValue]==1 &&[[EnggDic valueForKey:@"IsAccepted"]integerValue]==0)
        {
            [imgvstatusCrcl setBackgroundColor:[UIColor yellowColor]];
            chk.hidden=NO;
            vw.userInteractionEnabled=YES;
            chk.image=[UIImage imageNamed:@"uncheck"];
            
        }
        else if ([[EnggDic valueForKey:@"IsActive"]integerValue]==1 &&[[EnggDic valueForKey:@"IsAccepted"]integerValue]==1)
        {
            
            [imgvstatusCrcl setBackgroundColor:[UIColor greenColor]];
            vw.userInteractionEnabled=NO;
             chk.hidden=YES;
        }
        else if ([[EnggDic valueForKey:@"IsActive"]integerValue]==0 &&[[EnggDic valueForKey:@"IsAccepted"]integerValue]==0)
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




-(void)PopulateInvitedEnggList{
    
    float currY=75.0f;
    int i=0;
    
    
    for (NSDictionary *dic in arrInvitedEngg ) {
        
        UIControl *VwEngg=[self enggDetails:dic];
        [VwEngg setFrame:CGRectMake(0, currY, VwEngg.frame.size.width, VwEngg.frame.size.height)];
        currY=CGRectGetMaxY(VwEngg.frame)+5;
        VwEngg.tag=i;
        VwEngg.center=CGPointMake(CGRectGetWidth(popUpVW.frame)/2.0f, VwEngg.center.y);
        [VwEngg addTarget:self action:@selector(handleEnggSelection:) forControlEvents:UIControlEventTouchUpInside];
        i++;
       
        [popUpVW addSubview:VwEngg];
    
    }
    [popUpVW setContentSize:CGSizeMake(popUpVW.frame.size.width, currY)];
                                       
    
    
}



-(IBAction)handleEnggSelection:(UIControl *)sender
{
 NSMutableDictionary *temp;
    
    temp=[arrInvitedEngg objectAtIndex:sender.tag];
    
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
                if ([arrMselectedFE count]==1)
                {
                    [self showAlert:@"Only one Engineer can be selected at a time " withTitle:@"Sorry"];
                    
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



-(IBAction)bgPopupTouched:(id)sender
{
    for (UIView *vw in [bgVw subviews]) {
        [vw removeFromSuperview];
        
        
    }
    [bgVw removeFromSuperview];
    
    [arrMselectedFE removeAllObjects];
    
}



-(void)FetchInvitedEngg:(NSInteger)index
{
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    //DLog(@"%@",user);
    NSDictionary *dicManagerJobDetails=[InvitedJobs objectAtIndex:index];
    
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString=[NSString stringWithFormat:@"%sInvitedEngineer?userToken=%@&jobID=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[dicManagerJobDetails valueForKey:@"JobID"]];
    
    //DLog(@"PostString=%@",urlString);
    
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
    
    connRequestedFE = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connRequestedFE start];
}




#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MBProgressHUD hideAllHUDsForView:popUpVW animated:YES];
    
    NSMutableDictionary* temp;
    if (_responseData !=nil)
    {
        NSError *error;
        
        temp = [NSJSONSerialization JSONObjectWithData:_responseData  options:NSJSONReadingMutableContainers error:&error];
        if (!error)
        {
            if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
            {
                if (connection==connRequestedFE) {
                    arrInvitedEngg=(NSMutableArray *)[temp objectForKey:@"InvitedEngineerList"];
                    [self PopulateInvitedEnggList];
                    
                }
                else if (connection==connAccept)
                {
                    [self bgPopupTouched:nil];
                    [self FetchInvitedEngg:0];
                    
                }
                else
                {
             
                InvitedJobs=(NSMutableArray *)[temp objectForKey:@"JobListResponse"];
                    if ([InvitedJobs count]==0) {
                        
                        UILabel *lbl=[[UILabel alloc]init];
                        lbl.text=@"No job invitation to accept";
                        lbl.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:20.0];
                        [lbl sizeToFit];
                        lbl.center=CGPointMake(_tabvInvitationList.center.x, _tabvInvitationList.center.y);
                        [_tabvInvitationList addSubview:lbl];
                        
                        
                    }
                    
                }
                
                
            }
            else
            {
                DLog(@"JSONObjectWithData error: %@", error);
                if ([InvitedJobs count]==0) {
                    
                    UILabel *lbl=[[UILabel alloc]init];
                    lbl.text=[NSString stringWithFormat:@"%@",@"No job invitations"];
                    
                    lbl.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:20.0];
                    [lbl sizeToFit];
                    lbl.tag=404;
                    lbl.center=CGPointMake(_tabvInvitationList.center.x, _tabvInvitationList.center.y);
                    [self.view addSubview:lbl];
                    
                    
                }
                
            }
            
        }
        
    }
    else
    {
        
    }
    self.activity.hidden=YES;
    [self.activity stopAnimating];
    [_tabvInvitationList reloadData];
    
    
}






- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
   // [[[UIAlertView alloc]initWithTitle:@"Error" message:@"No network connection. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
   
    [self showAlert:@"No network connection. Please try again later."  withTitle:@"Error"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
