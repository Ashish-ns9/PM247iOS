//
//  EngineerCalenderAvialabiltyVC.m
//  PM247
//
//  Created by Shubham Kumar on 14/03/22.
//  Copyright © 2022 SANDIPAN. All rights reserved.
//

#import "EngineerCalenderAvialabiltyVC.h"
#import "GlobalDirector.h"
#import "GlobalDirector.h"
#import "ReCreateJob.h"

@interface EngineerCalenderAvialabiltyVC ()
{
    GlobalDirector *globe;
    DSLCalendarView  *classobj;
}


@end

@implementation EngineerCalenderAvialabiltyVC
@synthesize btnSlideMenu;




- (void)viewDidLoad
{
    
    [super viewDidLoad];
  
    [self DatePicker:nil];
    [self Timepicker:nil];
    [self DatePicker2:nil];
    
    [self UpdateCalenderViewWithJobs:(NSArray *)Jobs];
    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [btnSlideMenu addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    Count2=1;
  
    

}



#pragma mark - Pop Up list Fetch / Show Method
-(void)popupList
{
    tableView=[[UITableView alloc]init];
     tableView.frame = CGRectMake(10,162,250,100);
     tableView.dataSource=self;
     tableView.delegate=self;
     tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
     [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
     [tableView reloadData];
    [scrollviewbg addSubview:tableView];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *CellIdentifier = @"Cell";
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier   forIndexPath:indexPath] ;

   if (cell == nil)
   {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
   }
    NSArray *dropdownArray = @[@"Red", @"Green"];
    cell.textLabel.text=[dropdownArray objectAtIndex:indexPath.row];
//    cell.textLabel.text = dropdownArray[0];

   return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

       NSArray *dropdownArray = @[@"Red", @"Green"];
        txtTimeAllowance.text=[dropdownArray objectAtIndex:indexPath.row];
       [tableView removeFromSuperview];
       tableView=nil;

}
-(void)UpdateCalenderViewWithJobs:(NSArray*)Jobs
{
    
    NSString *dateStr ;
    NSMutableDictionary *EventsDic=[[NSMutableDictionary alloc]init];
    
    //Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    
    for (int i=0;i<[Jobs count] ;i++ )
    {
        [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        // NSDictionary *dic=[Jobs objectAtIndex:i];
        
        //-------as per Start Date Time ----------------------------------------------------------------------------------
        NSString *strStartDate = [GlobalDirector ReplaceStringNull:[Jobs objectAtIndex:i]];
        //strStartDate = [strStartDate substringToIndex:10];
        NSArray* foo = [strStartDate componentsSeparatedByString: @" "];
        strStartDate=[foo objectAtIndex:0];
        NSString *strStartDateTime=[NSString stringWithFormat:@"%@ %@",strStartDate,@"00:00:00"];
        // DLog(@"Started DateTime :%@",strStartDateTime);
        
        //-------as per Created Date Time ----------------------------------------------------------------------------------
        //   dateStr=[dic valueForKey:@"DateJobPost"];
        //  DLog(@"Created DateTime :%@",dateStr);
        
        NSDate *date = [dateFormat dateFromString:strStartDateTime];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
        
        [EventsDic setValue:[NSString stringWithFormat:@"%@",@""] forKey:[NSString stringWithFormat:@"%ld/%ld/%ld",(long)components.day,(long)components.month,(long)components.year]];
        
    }
    
    
  
    if (cal==nil) {
        cal=[[DSLCalendarView alloc]initWithDatesWithEvent:EventsDic];
        CGRect calFrame=CGRectMake(0,0,322,300) ;
        cal.delegate=self;
        cal.frame=calFrame;
        cal.center=CGPointMake(CGRectGetWidth(_CalendarView.frame)/2.2f, CGRectGetHeight(calFrame)/1.2f);
        [_CalendarView addSubview:cal];
    }
    else{
        NSDateComponents *visibleMon =  cal.visibleMonth;
        
        [cal removeFromSuperview];
        cal=nil;
        cal=[[DSLCalendarView alloc]initWithDatesWithEvent:EventsDic];
        CGRect calFrame=CGRectMake(0,0,322,300) ;
        cal.delegate=self;
        cal.frame=calFrame;
        cal.center=CGPointMake(CGRectGetWidth(_CalendarView.frame)/2.2f, CGRectGetHeight(calFrame)/1.2f);
        
//          [cal setEventsDic:EventsDic];
        [cal setVisibleMonth:visibleMon];
        [_CalendarView addSubview:cal];
        
    }
    
    
}

-(void)NewVisibleMonthWillCome:(NSDateComponents *)month
{
    
    
    
}



- (NSDate *)getTodayDateAt:(NSInteger)hour minute:(NSInteger)minute {
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    components.hour = hour;
    components.minute = minute;
    return [calendar dateFromComponents:components];
}
 


#pragma mark - Recreate Description PopUP Method
-(void)viewPopUPFormRecreateMethod:(NSString *)strJobID
{
    Count =0;
    Count2 =1;
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
        stringForKey:@"preferenceName"];


    NSString *dateString = savedValue;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    datepicker.date = dateFromString;
    datepicker2.date =dateFromString;
    dateString1 = dateString;
    dateString2 = dateString;

   
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
    

    //--------- Start Time ---------
    txtStartTime = [[UITextField alloc] initWithFrame:CGRectMake(20,45,240,30)];
    txtStartTime.textColor=[UIColor darkGrayColor];
    txtStartTime.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:17.0];
    [txtStartTime setBorderStyle:UITextBorderStyleNone];
    txtStartTime.layer.borderWidth=0.5f;
    txtStartTime.layer.borderColor=[[UIColor grayColor]CGColor];
    txtStartTime.layer.cornerRadius=6.0f;
    txtStartTime.background=[UIImage imageNamed:@"inputBox5"];
    txtStartTime.delegate = self;
    txtStartTime.userInteractionEnabled=YES;
    txtStartTime.inputView=datepicker;

   txtStartTime.placeholder = savedValue;
    txtStartTime.inputAccessoryView=numberToolbar;
    txtStartTime.inputView=datepicker;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    txtStartTime.leftView = paddingView;
    txtStartTime.leftViewMode = UITextFieldViewModeAlways;

    
    btnStartTime=[[UIButton alloc]initWithFrame:CGRectMake(205,0, 35, 30)];
    btnStartTime.backgroundColor=[UIColor clearColor];
    [btnStartTime setBackgroundImage:[UIImage imageNamed:@"dropdownCalender"] forState:UIControlStateNormal];
    [btnStartTime addTarget:self action:@selector(datepicker:) forControlEvents:UIControlEventTouchUpInside];
    btnStartTime.tag=66;
    
    
    //--------- End Time ---------

    txtEndTime = [[UITextField alloc] initWithFrame:CGRectMake(20,85,240,30)];
    txtEndTime.textColor=[UIColor darkGrayColor];
    txtEndTime.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:17.0];
    [txtEndTime setBorderStyle:UITextBorderStyleNone];
    txtEndTime.layer.borderWidth=0.5f;
    txtEndTime.layer.borderColor=[[UIColor grayColor]CGColor];
    txtEndTime.layer.cornerRadius=6.0f;
    txtEndTime.background=[UIImage imageNamed:@"inputBox5"];
    txtEndTime.delegate = self;
    txtEndTime.userInteractionEnabled=YES;
    txtEndTime.inputAccessoryView=numberToolbar;
    txtEndTime.inputView=datepicker2;
    
    txtEndTime.placeholder= savedValue;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    txtEndTime.leftView = paddingView1;
    txtEndTime.leftViewMode = UITextFieldViewModeAlways;
    
    btnEndTime=[[UIButton alloc]initWithFrame:CGRectMake(205,0, 35, 30)];
    btnEndTime.backgroundColor=[UIColor clearColor];
    [btnEndTime setBackgroundImage:[UIImage imageNamed:@"dropdownCalender"] forState:UIControlStateNormal];
    [btnEndTime addTarget:self action:@selector(datepicker2:) forControlEvents:UIControlEventTouchUpInside];
    btnEndTime.tag=67;
   

    
    //--------- Time allowance ---------
    txtTimeAllowance = [[UITextField alloc] initWithFrame:CGRectMake(20,125,240,30)];
    txtTimeAllowance.textColor=[UIColor darkGrayColor];
    txtTimeAllowance.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:18.0];
    [txtTimeAllowance setBorderStyle:UITextBorderStyleNone];
    txtTimeAllowance.layer.borderWidth=0.5f;
    txtTimeAllowance.layer.borderColor=[[UIColor grayColor]CGColor];
    txtTimeAllowance.layer.cornerRadius=6.0f;
    txtTimeAllowance.background=[UIImage imageNamed:@"inputBox5"];
    txtTimeAllowance.delegate = self;
    txtTimeAllowance.userInteractionEnabled=YES;
    txtTimeAllowance.placeholder=@"  Theme Colours";
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    txtTimeAllowance.leftView = paddingView2;
    txtTimeAllowance.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *imgDropdown3=[[UIImageView alloc] initWithFrame:CGRectMake(225,125, 35, 30)];
    [imgDropdown3 setImage:[UIImage imageNamed:@"dropdown"]];

    //-------- Job Decription -------------
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20,175,240,30)];
    lblTitle.text = @"Notes";
    lblTitle.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.backgroundColor =[UIColor colorWithRed:52/255.0 green:54/255.0 blue:67/255.0 alpha:0.72];
    [lblTitle.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [lblTitle.layer setBorderWidth: 1.0];
    [lblTitle.layer setCornerRadius:4.0f];
    [lblTitle.layer setMasksToBounds:YES];
    
    txtvNoteBody = [[UITextView alloc] initWithFrame:CGRectMake(20,205,240,120)];
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
//    [scrollviewbg addSubview:imgDropdown4];
    [scrollviewbg addSubview:txtJobStatus];
    //[scrollviewbg addSubview:imgDropdown5];
    
    [scrollviewbg addSubview:lblTitle];
    [scrollviewbg addSubview:txtvNoteBody];
    
    btnProceed=[UIButton buttonWithType:UIButtonTypeCustom];
    btnProceed.frame=CGRectMake(0,CGRectGetHeight(scrollviewbg.frame),300,40);
    [btnProceed setTitle:@"Save" forState:UIControlStateNormal];
    [btnProceed setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnProceed.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:18.0];
    [btnProceed setBackgroundColor:[UIColor colorWithRed:30/255.0 green:124/255.0 blue:41/255.0 alpha:1.0]];
    btnProceed.tag=[strJobID integerValue];
    [btnProceed addTarget:self action:@selector(pressRecreateOroceed:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnProceed.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [btnProceed.layer setBorderWidth: 1.0];
    [btnProceed.layer setCornerRadius:0.0f];
    [btnProceed.layer setMasksToBounds:YES];
    
    btnCross1=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCross1.frame=CGRectMake(0, 0, 25, 25);
    btnCross1.center=CGPointMake(CGRectGetMaxX(bgVw.frame)-4,CGRectGetMinY(bgVw.frame)+4);
    [btnCross1 setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
    
    
    [btnCross1 addTarget:self action:@selector(cross:) forControlEvents:UIControlEventTouchUpInside];
//    [btnCross clipsToBounds];
    
    [bgVw addSubview:scrollviewbg];
    [bgVw addSubview:btnProceed];
    [mainBg addSubview:bgVw];
    [mainBg addSubview:btnCross1];
    [self.view addSubview:mainBg];
}


-(void)cross:(UIButton *)sender
{
    
    [mainBg removeFromSuperview];
    _CalendarView.hidden=NO;
    
    
}


#pragma mark Calender View Method

-(void)FetchCalanderJobDates:(NSDate*)date
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    
    
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(NSString *)[user valueForKey:@"UserToken"] forKey:@"userToken"];
    [dict setObject:stringFromDate forKey:@"jobDate"];
    // [dict setObject:@"01/01/2018" forKey:@"jobDate"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [globe SyncRequestGet:REQUEST_GetCalendarDate withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            @try {
                
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                
                arrDates = [result valueForKey:@"ItemList"];
                
                
                
                
            } @catch (NSException *exception) {
                
                if (!arrDates) {
                    arrDates = [[NSArray alloc] init];
                }
                
            }@finally{
                
                if ([arrDates isKindOfClass:[NSArray class]]) {
                    [self UpdateCalenderViewWithJobs:arrDates];
                }
                
                
            }
        });
        
        
        
    }];
    
}
-(void)pressRecreateOroceed:(UIButton *)sender
{
   // [mainBg removeFromSuperview];
    UIButton *btn=(UIButton *)sender;
    
    
    NSString *alertmsg;
    DLog(@"note saved");
    
 
  if ([txtStartTime.text isEqualToString:@""]||[self BlankSpaces:txtStartTime])
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
        alertmsg=@"Enter  theme colour ";
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

        NSDate *date = [dateFormatter dateFromString:txtEndTime.text];
        NSDate *date1 = [dateFormatter dateFromString:txtStartTime.text];
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *newDateString = [dateFormatter stringFromDate:date];
        //**********************************************************************************
        
         DLog(@"Converted txtStarDate :%@",newDateString);
//
//        [self postRecreateConfirmation:(NSString *)[user valueForKey:@"UserToken"] existingjobid:strjobidd createdby:(NSString *)[user valueForKey:@"UserID"] description:txtvNoteBody.text startdate:(NSString *)newDateString starttime:(NSString *)txtStartTime.text endtime:(NSString *)txtEndTime.text
//
//                    timeallowance:(long)txtTimeAllowance.tag jobtypeid:(long)txtJobType.tag jobstatusid:1];
    }
    
}
#pragma mark - check Blank Space Method
-(void)Showalert:(NSString *)msg
{
   // [[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
     [self showAlert:msg withTitle:@""];
}

-(void)showAlert:(NSString *)alertmessage withTitle:(NSString *)title
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: title
                                                                            message:alertmessage
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                NSLog(@"Dismiss button tapped!");
                                                            }];
        
        [controller addAction: alertAction];
        
        [self presentViewController: controller animated: YES completion: nil];
        
    });
    
    
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


#pragma mark - Textfield Delegate Method
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
     if (textField==txtTimeAllowance)
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
   

    else if (textField==txtStartTime)
    {

//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"  dd/MM/yyyy :  HH:mm"];
       
        if(Count==0)
        {
            
            txtStartTime.text= dateString1;
            Count=1;
        }
       
     
    }
    else if (textField==txtEndTime)
    {
        
//        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
//        [formatter1 setDateFormat:@" dd/MM/yyyy : HH:mm"];
        if(Count2==1)
        {
            
            txtEndTime.text= dateString2;
            Count2=2;
        }
        
    }
    
    return YES;
    
}
#pragma mark - Date Picker Method
-(void)DatePicker:(id)sender
{
    
    
    if (numberToolbar==nil)
    {
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
    txtStartTime.inputView=timePicker;
    
    datepicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datepicker.datePickerMode = UIDatePickerModeDateAndTime;
    datepicker.backgroundColor = [UIColor whiteColor];
    [datepicker addTarget:self action:@selector(dateUpdated:) forControlEvents:UIControlEventValueChanged];
  
    
}
#pragma mark - Date Picker Method2
-(void)DatePicker2:(id)sender
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
   
    txtEndTime.inputAccessoryView=numberToolbar;
    txtEndTime.inputView=timePicker;
    
    datepicker2 = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datepicker2.datePickerMode = UIDatePickerModeDateAndTime;
    datepicker2.backgroundColor = [UIColor whiteColor];
    [datepicker2 addTarget:self action:@selector(dateUpdated2:) forControlEvents:UIControlEventValueChanged];
  
    
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
    [formatter setDateFormat:@"dd/MM/yyyy : HH:mm"];
//    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
   
    
    UITextField *actvfld=(UITextField *)txtStartTime;
    actvfld.text = [formatter stringFromDate:datepicker.date];
           

}
#pragma mark - Date Updated Method
- (void) dateUpdated2:(UIDatePicker *)datePicker2
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy : HH:mm"];
//    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
   
    UITextField *actvfld1=(UITextField *)txtEndTime;
    actvfld1.text = [formatter stringFromDate:datePicker2.date];
    



}



#pragma mark - Time Updated Method
- (void) timeUpdated:(UIDatePicker *)datePicker
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@" dd/MM/yyyy : HH:mm"];
    
    UITextField *actvfld=(UITextField *)txtStartTime;
    actvfld.text = [formatter stringFromDate:datePicker.date];
  
}
#pragma mark - Time Updated Method
- (void) timeUpdated2:(UIDatePicker *)datePicker2
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@" dd/MM/yyyy : HH:mm"];
    
    UITextField *actvfld1=(UITextField *)txtEndTime;
    actvfld1.text = [formatter stringFromDate:datePicker2.date];
}
-(void)OK
{
   [self.view endEditing:YES];
    
     }


#pragma mark - DSLCalendarView Delegate and Datasource Method
- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range
{
    
    self.NewCalendrView.hidden=NO;
    _CalendarView.hidden=YES;
    [self viewPopUPFormRecreateMethod:(NSString *)strJobID];

    

}



- (UIView *)createPicker {
    

    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 216)];
//    pickerView.backgroundColor = [UIColor colorWithRed:109.0/255.0 g0 alpha:1];

    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 145, 300, 120)];
    picker.delegate = self;
   [pickerView addSubview:picker];

   return pickerView;
}




@end
