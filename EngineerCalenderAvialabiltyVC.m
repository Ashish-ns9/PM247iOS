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
    AppDelegate *app;

}

//- (BOOL)isEqualToDate:(NSDate *)date; already part of the NSDate API




@end

@implementation EngineerCalenderAvialabiltyVC

@synthesize btnSlideMenu,managedObjectContext;




- (void)viewDidLoad
{
    
    [super viewDidLoad];
  
    [self DatePicker:nil];
    [self Timepicker:nil];
    [self DatePicker2:nil];
    [self EngineerCalenderAvailbiltProcess];
    
    
    
    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [btnSlideMenu addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
  
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    Count2=1;
    greenCount=0;
    redCount=0;
    noteDataCount=0;
    noteCount=0;
    noteCount1=0;
    noteCount2=0;
    noteCount3=0;
    btnCount=0;
    selectedBtnCount=0;
    emptyDateCount=0;
    deletecount=0;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-0];
    NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    [comps setYear:-10];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];


    datepicker.minimumDate = minDate;
    datepicker.maximumDate = maxDate;


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
    NSArray *dropdownArray = @[@"red", @"Green"];
    cell.textLabel.text=[dropdownArray objectAtIndex:indexPath.row];
//    cell.textLabel.text = dropdownArray[0];

   return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

       NSArray *dropdownArray = @[@"red", @"Green"];
        txtTimeAllowance.text=[dropdownArray objectAtIndex:indexPath.row];
       [tableView removeFromSuperview];
       tableView=nil;

}


-(void)UpdateCalenderViewWithJobs:(NSArray*)Jobs
{
    

//    NSDate *today = [NSDate date];
    
    NSMutableDictionary *EventsDic=[[NSMutableDictionary alloc]init];
//    NSMutableDictionary *EventsgreenDic=[[NSMutableDictionary alloc]init];
//    NSMutableDictionary *EventsredDic=[[NSMutableDictionary alloc]init];

    //Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    
        for (int i=0;i<[Jobs count] ;i++ )
        {
            [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
            // NSDictionary *dic=[Jobs objectAtIndex:i];
            
            //-------as per Start Date Time ----------------------------------------------------------------------------------
            NSString *strStartDate = [GlobalDirector ReplaceStringNull:[Jobs objectAtIndex:i]];
            NSString *strStartTime=[Jobs objectAtIndex:i];
          
            //strStartDate = [strStartDate substringToIndex:10];
            NSArray* foo = [strStartDate componentsSeparatedByString: @" "];
            
            strStartDate=[foo objectAtIndex:0];
            strStartTime=[foo objectAtIndex:1];
          
            NSString *strStartDateTime=[NSString stringWithFormat:@"%@ %@",strStartDate,strStartTime];

//            // DLog(@"Started DateTime :%@",strStartDateTime);
            
            //-------as per Created Date Time ----------------------------------------------------------------------------------
            //   dateStr=[dic valueForKey:@"DateJobPost"];
            //  DLog(@"Created DateTime :%@",dateStr);
            
            NSDate *date = [dateFormat dateFromString:strStartDateTime];
            
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear |  NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
            
            [EventsDic setValue:[NSString stringWithFormat:@"%@",@""] forKey:[NSString stringWithFormat:@"%ld/%ld/%ld ",components.day,components.month,components.year]];
            

            
}
        
    
    NSMutableArray* colorArray = [[NSMutableArray alloc] init];
    NSMutableArray* previousdata = [[NSMutableArray alloc] init];
    NSMutableArray *greenKeyArray = [[NSMutableArray alloc] init];
    NSMutableArray *redKeyArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *previouskey ;
  

    for ( id key in arrDates)
    {
        
            for (id object in themeColorArray)
            {
                if (Count ==0)
                {


                [colorArray addObject:object];
                }


            }

            for(id data in colorArray)
             {


                 if (key!=previouskey)
                {


                    if ( [data  isEqual: @"Green"] || [data  isEqual: @"green"] )
                    {


                        previouskey=key;
                        previousdata= data;

//                        NSMutableDictionary *employee = [[NSMutableDictionary alloc]init];
                        NSMutableDictionary *emplyeeA = previouskey;

                        [greenKeyArray addObject: emplyeeA];



                    }

                        if ( [data  isEqual: @"red"] || [data  isEqual: @"Red"])
                        {


                            previouskey=key;
                            previousdata= data;
//                            NSMutableDictionary *employee = [[NSMutableDictionary alloc]init];
                            NSMutableDictionary *emplyeeA = previouskey;

                            [redKeyArray addObject: emplyeeA];




//                            NSLog(@"%",redKeyArray);



                        }
                    [colorArray removeObjectAtIndex: 0];
                  NSMutableArray *colorArray2 =colorArray;
                      themeColorArray = colorArray2;

                      Count=1;
                    break;


                    }




        }

    }

    
    newRedArray=redKeyArray;
    newGreenArray=greenKeyArray;
    
    [[NSUserDefaults standardUserDefaults] setObject:themeColorArray forKey:@"jobDataString"];
    [[NSUserDefaults standardUserDefaults] synchronize];
        
     
    
      
//    DLog(@"%@",EventsDic);
    if (cal==nil) {
        cal=[[DSLCalendarView alloc]initWithDatesWithEvent:EventsDic];
        CGRect calFrame=CGRectMake(0,0,322,300) ;
        cal.delegate=self;
        cal.frame=calFrame;
        cal.center=CGPointMake(CGRectGetWidth(_CalendarView.frame)/2.0f, CGRectGetHeight(calFrame)/1.50f);
     
        
        [_CalendarView addSubview:cal];
    }else{
        
        NSDateComponents *visibleMon =  cal.visibleMonth;
        
        [cal removeFromSuperview];
        cal=nil;
        cal=[[DSLCalendarView alloc]initWithDatesWithEvent:EventsDic];
        CGRect calFrame=CGRectMake(0,0,322,300) ;
        cal.delegate=self;
        cal.frame=calFrame;
        cal.center=CGPointMake(CGRectGetWidth(_CalendarView.frame)/2.0f, CGRectGetHeight(calFrame)/1.50f);
        
   
        [cal setVisibleMonth:visibleMon];
        [_CalendarView addSubview:cal];
        
    }
    
}

-(void)NewVisibleMonthWillCome:(NSDateComponents *)month
{
    
    
    [self FetchCalanderJobDates:month.date];
}
- (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2
{
    
    return ([day1.date compare:day2.date] == NSOrderedAscending);
}
- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents *)month
{
    

//    DLog(@"Now showing %@", month);
//
}

- (void)calendarView:(DSLCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents *)month duration:(NSTimeInterval)duration
{
    
    // [self FetchCalanderJobDates:month.date];
//    DLog(@"Will show %@ in %.3f seconds", month, duration);
    
}







#pragma mark - Recreate Description PopUP Method
-(void)viewPopUPFormRecreateMethod:(NSString *)strJobID
{
    

    NSString *dateString = savedValue;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"];
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
    

    if(selectedBtnCount==1)
    {
        
        
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:availbfromOnBtn1 attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];

        datandtimeOnStarttimetxtfld=availbfromOnBtn1;
       
        NSString *Eventsdic1  = [availbfromOnBtn1 substringWithRange:NSMakeRange(0,2)];
        NSString *Eventsdic2  = [availbfromOnBtn1 substringWithRange:NSMakeRange(3,2)];
        NSString *Eventsdic3  = [availbfromOnBtn1 substringWithRange:NSMakeRange(6,4)];
        NSString *Eventsdic4  = [availbfromOnBtn1 substringWithRange:NSMakeRange(11,8)];
       
        
        
        NSString *str = [NSString stringWithFormat: @"%@-%@-%@ %@ ",Eventsdic3, Eventsdic2, Eventsdic1,Eventsdic4];
        
        txtStartTime.text = str;
        availblityId =availabilityIDonBtn1;

    
    }
    else if(selectedBtnCount==2)
    {
        
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:availbfromOnBtn2 attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
        self->txtStartTime.attributedPlaceholder = str2;
        datandtimeOnStarttimetxtfld=availbfromOnBtn2;
        NSString *Eventsdic1  = [availbfromOnBtn2 substringWithRange:NSMakeRange(0,2)];
        NSString *Eventsdic2  = [availbfromOnBtn2 substringWithRange:NSMakeRange(3,2)];
        NSString *Eventsdic3  = [availbfromOnBtn2 substringWithRange:NSMakeRange(6,4)];
        NSString *Eventsdic4  = [availbfromOnBtn2 substringWithRange:NSMakeRange(11,8)];
       
        NSString *str = [NSString stringWithFormat: @"%@-%@-%@ %@ ",Eventsdic3, Eventsdic2, Eventsdic1,Eventsdic4];
        
        txtStartTime.text = str;
        availblityId =availabilityIDonBtn2;
    }
  else if (selectedBtnCount==3)
    {
        
        
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:availbfromOnBtn3 attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
    self->txtStartTime.attributedPlaceholder = str2;
        datandtimeOnStarttimetxtfld=availbfromOnBtn3;
        NSString *Eventsdic1  = [availbfromOnBtn3 substringWithRange:NSMakeRange(0,2)];
        NSString *Eventsdic2  = [availbfromOnBtn3 substringWithRange:NSMakeRange(3,2)];
        NSString *Eventsdic3  = [availbfromOnBtn3 substringWithRange:NSMakeRange(6,4)];
        NSString *Eventsdic4  = [availbfromOnBtn3 substringWithRange:NSMakeRange(11,8)];
       
        NSString *str = [NSString stringWithFormat: @"%@-%@-%@ %@ ",Eventsdic3, Eventsdic2, Eventsdic1,Eventsdic4];
        
        txtStartTime.text = str;
        availblityId =availabilityIDonBtn3;
       
        
    }
    else if(selectedBtnCount==4)
    {
        
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:availbfromOnBtn4 attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
    self->txtStartTime.attributedPlaceholder = str2;
        datandtimeOnStarttimetxtfld=availbfromOnBtn4;
        NSString *Eventsdic1  = [availbfromOnBtn4 substringWithRange:NSMakeRange(0,2)];
        NSString *Eventsdic2  = [availbfromOnBtn4 substringWithRange:NSMakeRange(3,2)];
        NSString *Eventsdic3  = [availbfromOnBtn4 substringWithRange:NSMakeRange(6,4)];
        NSString *Eventsdic4  = [availbfromOnBtn4 substringWithRange:NSMakeRange(11,8)];
       
        NSString *str = [NSString stringWithFormat: @"%@-%@-%@ %@ ",Eventsdic3, Eventsdic2, Eventsdic1,Eventsdic4];
        
        txtStartTime.text = str;
        availblityId =availabilityIDonBtn3;
    }
    else if(EventsdicCount==0)
    {
        
        NSString *Eventsdic1  = [savedValue substringWithRange:NSMakeRange(0,2)];
        NSString *Eventsdic2  = [savedValue substringWithRange:NSMakeRange(3,2)];
        NSString *Eventsdic3  = [savedValue substringWithRange:NSMakeRange(6,4)];
       
        NSDate *currentTime = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@" hh:mm:ss"];
        NSString *resultString = [dateFormatter stringFromDate: currentTime];
        NSString *Eventsdic4  = resultString;
        NSString *str = [NSString stringWithFormat: @"%@-%@-%@ %@ ",Eventsdic3, Eventsdic2, Eventsdic1,Eventsdic4];
        txtStartTime.text = str;
        
      
        
        
    }
    

    txtStartTime.inputAccessoryView=numberToolbar;
    txtStartTime.inputView=datepicker;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    txtStartTime.leftView = paddingView;
    txtStartTime.leftViewMode = UITextFieldViewModeAlways;
    
    btnStartTime=[[UIButton alloc]initWithFrame:CGRectMake(205,0, 35, 30)];
    btnStartTime.backgroundColor=[UIColor clearColor];
    [btnStartTime setBackgroundImage:[UIImage imageNamed:@"dropdownCalender"] forState:UIControlStateNormal];
//    [btnStartTime addTarget:self action:@selector(datepicker:) forControlEvents:UIControlEventTouchUpInside];
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
    if(selectedBtnCount==1)
    {
        
    txtEndTime.placeholder= AvailbTOnBtn1;
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString: AvailbTOnBtn1 attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
        self->txtEndTime.attributedPlaceholder = str1;
        datandtimeOnEndtimetxtfld=AvailbTOnBtn1;
        NSString *Eventsdic1  = [AvailbTOnBtn1 substringWithRange:NSMakeRange(0,2)];
        NSString *Eventsdic2  = [AvailbTOnBtn1 substringWithRange:NSMakeRange(3,2)];
        NSString *Eventsdic3  = [AvailbTOnBtn1 substringWithRange:NSMakeRange(6,4)];
        NSString *Eventsdic4  = [AvailbTOnBtn1 substringWithRange:NSMakeRange(11,8)];
       
        NSString *str = [NSString stringWithFormat: @"%@-%@-%@ %@ ",Eventsdic3, Eventsdic2, Eventsdic1,Eventsdic4];
        
        txtEndTime.text = str;

    }
   else if(selectedBtnCount==2)
    {
        
    txtEndTime.placeholder= AvailbToOnBtn2;
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:AvailbToOnBtn2 attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
        self->txtEndTime.attributedPlaceholder = str1;
        datandtimeOnEndtimetxtfld=AvailbToOnBtn2;
        NSString *Eventsdic1  = [AvailbToOnBtn2 substringWithRange:NSMakeRange(0,2)];
        NSString *Eventsdic2  = [AvailbToOnBtn2 substringWithRange:NSMakeRange(3,2)];
        NSString *Eventsdic3  = [AvailbToOnBtn2 substringWithRange:NSMakeRange(6,4)];
        NSString *Eventsdic4  = [AvailbToOnBtn2 substringWithRange:NSMakeRange(11,8)];
       
        NSString *str = [NSString stringWithFormat: @"%@-%@-%@ %@ ",Eventsdic3, Eventsdic2, Eventsdic1,Eventsdic4];
        
        txtEndTime.text = str;
       
 
    }
   else if(selectedBtnCount==3)
    {
        
    txtEndTime.placeholder= AvailbToOnBtn3;
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:AvailbToOnBtn3 attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
        self->txtEndTime.attributedPlaceholder = str1;
        datandtimeOnEndtimetxtfld=AvailbToOnBtn3;
        NSString *Eventsdic1  = [AvailbToOnBtn3 substringWithRange:NSMakeRange(0,2)];
        NSString *Eventsdic2  = [AvailbToOnBtn3 substringWithRange:NSMakeRange(3,2)];
        NSString *Eventsdic3  = [AvailbToOnBtn3 substringWithRange:NSMakeRange(6,4)];
        NSString *Eventsdic4  = [AvailbToOnBtn3 substringWithRange:NSMakeRange(11,8)];
       
        NSString *str = [NSString stringWithFormat: @"%@-%@-%@ %@ ",Eventsdic3, Eventsdic2, Eventsdic1,Eventsdic4];
        
        txtEndTime.text = str;
       

    }
   else if(selectedBtnCount==4)
    {
        
    txtEndTime.placeholder= AvailbToOnBtn4;
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:AvailbToOnBtn4 attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
        self->txtEndTime.attributedPlaceholder = str1;
        datandtimeOnEndtimetxtfld=AvailbToOnBtn4;
        NSString *Eventsdic1  = [AvailbToOnBtn3 substringWithRange:NSMakeRange(0,2)];
        NSString *Eventsdic2  = [AvailbToOnBtn3 substringWithRange:NSMakeRange(3,2)];
        NSString *Eventsdic3  = [AvailbToOnBtn3 substringWithRange:NSMakeRange(6,4)];
        NSString *Eventsdic4  = [AvailbToOnBtn3 substringWithRange:NSMakeRange(11,8)];
        NSString *str = [NSString stringWithFormat: @"%@-%@-%@ %@ ",Eventsdic3, Eventsdic2, Eventsdic1,Eventsdic4];
        txtEndTime.text = str;

    }
   else if(EventsdicCount==0)
   {
       NSString *Eventsdic1  = [savedValue substringWithRange:NSMakeRange(0,2)];
       NSString *Eventsdic2  = [savedValue substringWithRange:NSMakeRange(3,2)];
       NSString *Eventsdic3  = [savedValue substringWithRange:NSMakeRange(6,4)];
      
       NSDate *currentTime = [NSDate date];
       NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
       [dateFormatter setDateFormat:@" hh:mm:ss"];
       NSString *resultString = [dateFormatter stringFromDate: currentTime];
       NSString *Eventsdic4  = resultString;
       NSString *str = [NSString stringWithFormat: @"%@-%@-%@ %@ ",Eventsdic3, Eventsdic2, Eventsdic1,Eventsdic4];
       txtEndTime.text = str;
      
//       txtEndTime.placeholder= @"Enter End time";
//
       
   }
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    txtEndTime.leftView = paddingView1;
    txtEndTime.leftViewMode = UITextFieldViewModeAlways;
    
    btnEndTime=[[UIButton alloc]initWithFrame:CGRectMake(205,0, 35, 30)];
    btnEndTime.backgroundColor=[UIColor clearColor];
    [btnEndTime setBackgroundImage:[UIImage imageNamed:@"dropdownCalender"] forState:UIControlStateNormal];
//    [btnEndTime addTarget:self action:@selector(datepicker2:) forControlEvents:UIControlEventTouchUpInside];
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
    txtTimeAllowance.placeholder=@" Theme Colours";

    if(selectedBtnCount==1)
    {
        
        
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:themeColorOnBtn1 attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
        self->txtTimeAllowance.attributedPlaceholder = str1;
        txtTimeAllowance.text = themeColorOnBtn1;


    }
   else if(selectedBtnCount==2)
    {
        
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:themeColorOnBtn2 attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
        self->txtTimeAllowance.attributedPlaceholder = str1;
        txtTimeAllowance.text = themeColorOnBtn2;
    }
   else if(selectedBtnCount==3)
    {
        
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:themeColorOnBtn3 attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
        self->txtTimeAllowance.attributedPlaceholder = str1;
        txtTimeAllowance.text = themeColorOnBtn3;

    }
  else  if(selectedBtnCount==4)
    {
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:themeColorOnBtn4 attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
        self->txtTimeAllowance.attributedPlaceholder = str1;
     txtTimeAllowance.text = themeColorOnBtn4;

    }
        
       
    
    
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
    
    if(selectedBtnCount==1)
    {
        
        txtvNoteBody.text=notesOnBtn1;
        [self->txtvNoteBody endEditing:YES];

    }
    if(selectedBtnCount==2)
    {
        
        txtvNoteBody.text=notesOnBtn2;

    }
    if(selectedBtnCount==3)
    {
        
        txtvNoteBody.text=notesOnBtn3;
       

    }
    if(selectedBtnCount==4)
    {
        
        txtvNoteBody.text= notesonBtn4;

    }
        
       
    if(EventsdicCount=0)
    {
       
        
        txtvNoteBody.text= @"Please enter the note";
    
        
    }
    
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
    [scrollviewbg addSubview:txtJobStatus];
    [scrollviewbg addSubview:lblTitle];
    [scrollviewbg addSubview:txtvNoteBody];
    
    btnProceed=[UIButton buttonWithType:UIButtonTypeCustom];
    if(btnCount==0)
    {
       
        btnProceed.frame=CGRectMake(0,CGRectGetHeight(scrollviewbg.frame),300,40);
        [btnProceed setTitle:@"SaveEvent" forState:UIControlStateNormal];
    }
  else
    {
        
        btnProceed.frame=CGRectMake(0,CGRectGetHeight(scrollviewbg.frame),125,40);
        [btnProceed setTitle:@"Update" forState:UIControlStateNormal];
        
    
    }
   
    [btnProceed setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnProceed.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:18.0];
    [btnProceed setBackgroundColor:[UIColor colorWithRed:30/255.0 green:124/255.0 blue:41/255.0 alpha:1.0]];
    
    btnProceed.tag=[strJobID integerValue];
    [btnProceed addTarget:self action:@selector(pressRecreateOroceed:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnProceed.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [btnProceed.layer setBorderWidth: 1.0];
    [btnProceed.layer setCornerRadius:0.0f];
    [btnProceed.layer setMasksToBounds:YES];
    
    btnDelete=[UIButton buttonWithType:UIButtonTypeCustom];
    if(btnCount!=0)
    {
        btnDelete.frame=CGRectMake(160,CGRectGetHeight(scrollviewbg.frame),150,40);
   
    }
 
    [btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
    [btnDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDelete.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:18.0];
    [btnDelete setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
    
    btnDelete.tag=[strJobID integerValue];
    [btnDelete addTarget:self action:@selector(pressdeletejob:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnDelete.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [btnDelete.layer setBorderWidth: 1.0];
    [btnDelete.layer setCornerRadius:0.0f];
    [btnDelete.layer setMasksToBounds:YES];
    
    btnCross=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCross.frame=CGRectMake(0, 0, 25, 25);
    btnCross.center=CGPointMake(CGRectGetMaxX(bgVw.frame)-4,CGRectGetMinY(bgVw.frame)+4);
    [btnCross setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
    
    
    [btnCross addTarget:self action:@selector(cross:) forControlEvents:UIControlEventTouchUpInside];
    [btnCross clipsToBounds];
    
    [bgVw addSubview:scrollviewbg];
    [bgVw addSubview:btnProceed];
    [bgVw addSubview:btnDelete];
    [mainBg addSubview:bgVw];
    [mainBg addSubview:btnCross];
    [self.view addSubview:mainBg];
}

-(void)jobdetailpopup:(NSString *)strJobID
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
    
    scrollviewbg = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,300,self.view.frame.size.height-180)];
    scrollviewbg.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    
    [scrollviewbg setContentSize:CGSizeMake(300, 400)];
    
    //--------- Time allowance ---------
   
    
    btnCreatejob=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCreatejob.frame=CGRectMake(0,CGRectGetHeight(scrollviewbg.frame),300,40);
    [btnCreatejob setTitle:@"NewEvent" forState:UIControlStateNormal];
    [btnCreatejob setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCreatejob.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:18.0];
    [btnCreatejob setBackgroundColor:[UIColor colorWithRed:30/255.0 green:124/255.0 blue:41/255.0 alpha:1.0]];
    btnCreatejob.tag=[strJobID integerValue];
    [btnCreatejob addTarget:self action:@selector(createJOb:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnCreatejob.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [btnCreatejob.layer setBorderWidth: 1.0];
    [btnCreatejob.layer setCornerRadius:0.0f];
    [btnCreatejob.layer setMasksToBounds:YES];
    
    
    
    btnCreatejob1=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCreatejob1.frame=CGRectMake(0,CGRectGetHeight(scrollviewbg.frame)-80,300,70);
    [btnCreatejob1 setTitle:availbfromOnBtn1 forState:UIControlStateNormal];
    
    if([themeColorOnBtn1  isEqual: @"Red"] ||[themeColorOnBtn1 isEqual: @"red"])
    {
        
        [btnCreatejob1 setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
    }
    if([themeColorOnBtn1  isEqual: @"Green"] ||[themeColorOnBtn1 isEqual: @"greeen"])
    {
        [btnCreatejob1 setBackgroundColor:[UIColor colorWithRed:30/255.0 green:124/255.0 blue:41/255.0 alpha:1.0]];
    }
    
   
    
    [btnCreatejob1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCreatejob1.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:18.0];
    btnCreatejob1.tag=[strJobID integerValue];
    [btnCreatejob1 addTarget:self action:@selector(createJOb1:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnCreatejob1.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [btnCreatejob1.layer setBorderWidth: 1.0];
    [btnCreatejob1.layer setCornerRadius:0.0f];
    [btnCreatejob1.layer setMasksToBounds:YES];
    
    btnCreatejob2=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCreatejob2.frame=CGRectMake(0,CGRectGetHeight(scrollviewbg.frame)-180,300,70);
    [btnCreatejob2 setTitle:availbfromOnBtn2 forState:UIControlStateNormal];
    
    if([themeColorOnBtn2  isEqual: @"Red"] ||[themeColorOnBtn2 isEqual: @"red"])
    {
        
        [btnCreatejob2 setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
    }
    if([themeColorOnBtn2  isEqual: @"Green"] ||[themeColorOnBtn2 isEqual: @"greeen"])
    {
        [btnCreatejob2 setBackgroundColor:[UIColor colorWithRed:30/255.0 green:124/255.0 blue:41/255.0 alpha:1.0]];
    }
    
   
    
    [btnCreatejob2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCreatejob2.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:18.0];
    btnCreatejob2.tag=[strJobID integerValue];
    [btnCreatejob2 addTarget:self action:@selector(createJOb2:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnCreatejob2.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [btnCreatejob2.layer setBorderWidth: 1.0];
    [btnCreatejob2.layer setCornerRadius:0.0f];
    [btnCreatejob2.layer setMasksToBounds:YES];
    
    
    btnCreatejob3=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCreatejob3.frame=CGRectMake(0,CGRectGetHeight(scrollviewbg.frame)-280,300,70);
    [btnCreatejob3 setTitle:availbfromOnBtn3 forState:UIControlStateNormal];
    
    if([themeColorOnBtn3 isEqual: @"Red"] ||[themeColorOnBtn3 isEqual: @"red"])
    {
        
        [btnCreatejob3 setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
    }
    if([themeColorOnBtn3  isEqual: @"Green"] ||[themeColorOnBtn3 isEqual: @"greeen"])
    {
        [btnCreatejob3 setBackgroundColor:[UIColor colorWithRed:30/255.0 green:124/255.0 blue:41/255.0 alpha:1.0]];
    }
    
   
    
    [btnCreatejob3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCreatejob3.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:18.0];
    btnCreatejob3.tag=[strJobID integerValue];
    [btnCreatejob3 addTarget:self action:@selector(createJOb3:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnCreatejob3.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [btnCreatejob3.layer setBorderWidth: 1.0];
    [btnCreatejob3.layer setCornerRadius:0.0f];
    [btnCreatejob3.layer setMasksToBounds:YES];
    
    
 
    btnCreatejob4=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCreatejob4.frame=CGRectMake(0,CGRectGetHeight(scrollviewbg.frame)-380,300,70);
    [btnCreatejob4 setTitle:availbfromOnBtn3 forState:UIControlStateNormal];
    
    if([themeColorOnBtn4 isEqual: @"Red"] ||[themeColorOnBtn4 isEqual: @"red"])
    {
        
        [btnCreatejob4 setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
    }
    if([themeColorOnBtn4  isEqual: @"Green"] ||[themeColorOnBtn4 isEqual: @"greeen"])
    {
        [btnCreatejob4 setBackgroundColor:[UIColor colorWithRed:30/255.0 green:124/255.0 blue:41/255.0 alpha:1.0]];
    }
    
   
    
    [btnCreatejob4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCreatejob4.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:18.0];
    btnCreatejob4.tag=[strJobID integerValue];
    [btnCreatejob4 addTarget:self action:@selector(createJOb4:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnCreatejob4.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [btnCreatejob4.layer setBorderWidth: 1.0];
    [btnCreatejob4.layer setCornerRadius:0.0f];
    [btnCreatejob4.layer setMasksToBounds:YES];
    
    
    btnCross=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCross.frame=CGRectMake(0, 0, 25, 25);
    btnCross.center=CGPointMake(CGRectGetMaxX(bgVw.frame)-4,CGRectGetMinY(bgVw.frame)+4);
    [btnCross setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
    
    
    [btnCross addTarget:self action:@selector(cross:) forControlEvents:UIControlEventTouchUpInside];
    [btnCross clipsToBounds];
    
    if(btnCount==1)
    {
        
        btnCreatejob4.hidden=true;
        btnCreatejob2.hidden=true;
        btnCreatejob3.hidden=true;
        
    }
   else if(btnCount==2)
    {
        btnCreatejob2.hidden=false;
        btnCreatejob4.hidden=true;
        btnCreatejob3.hidden=true;
        
    }
    else if (btnCount==3)
    {
        btnCreatejob4.hidden=true;
        btnCreatejob2.hidden=false;
        btnCreatejob3.hidden=false;
    }
    else if (btnCount==4)
    {
        
        
        btnCreatejob4.hidden=false;
        btnCreatejob2.hidden=false;
        btnCreatejob3.hidden=false;
    }

    [bgVw addSubview:scrollviewbg];
    [bgVw addSubview:btnCreatejob];
    [bgVw addSubview:btnCreatejob1];
    [bgVw addSubview:btnCreatejob2];
    [bgVw addSubview:btnCreatejob3];
    [bgVw addSubview:btnCreatejob4];
    
    [mainBg addSubview:bgVw];
    [mainBg addSubview:btnCross];
    [self.view addSubview:mainBg];
    
}

-(void)cross:(UIButton *)sender
{
    
    [mainBg removeFromSuperview];
    _CalendarView.hidden=NO;
    greenCount =0;
    redCount=0;
    timeOnDate =@"";
    timeOnDate1 =@"";
    noteCount=0;
    noteDataCount=0;
    emptyDateCount=0;
    previousTime = @"";
    previousGreenTime = @"";
    previousRedTime = @"";
    btnCount=0;
    noteCount1=0;
    noteCount2=0;
    noteCount3=0;
    selectedBtnCount =0;
    availblityId = nil;
    
    
 
}


-(void)createJOb:(UIButton *)sender
{
       [mainBg removeFromSuperview];
    [self viewPopUPFormRecreateMethod:(NSString *)strJobID];
    
    btnProceed.frame=CGRectMake(0,CGRectGetHeight(scrollviewbg.frame),300,40);
    [btnProceed setTitle:@"SaveEvent" forState:UIControlStateNormal];
    btnDelete.hidden=YES;
//    [mainBg removeFromSuperview];
   
    
    
 

}
-(void)createJOb1:(UIButton *)sender
{
    
    availblityId=availabilityIDonBtn1;
    [mainBg removeFromSuperview];
    selectedBtnCount=1;
    [self viewPopUPFormRecreateMethod:(NSString *)strJobID];
    
    
}
-(void)createJOb2:(UIButton *)sender
{
    
    availblityId=availabilityIDonBtn2;
    [mainBg removeFromSuperview];
    selectedBtnCount=2;
    [self viewPopUPFormRecreateMethod:(NSString *)strJobID];
    
}
-(void)createJOb3:(UIButton *)sender
{
    
    availblityId=availabilityIDonBtn3;
    [mainBg removeFromSuperview];
    selectedBtnCount=3;
    [self viewPopUPFormRecreateMethod:(NSString *)strJobID];
    
}
-(void)createJOb4:(UIButton *)sender
{
    
    availblityId=availabilityIDonBtn4;
    [mainBg removeFromSuperview];
    selectedBtnCount=4;
    [self viewPopUPFormRecreateMethod:(NSString *)strJobID];
    
}
#pragma mark - TEXTVIEW DELEGATES
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
//    [self.view endEditing:YES];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
 
    [textField resignFirstResponder];
    return YES;
    
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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            @try {
                
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                
                self->arrDates1=[self->dicUsercalenderDetails valueForKey:@"EnggAvailabilityListResponse"];
           
        
                self->arrDates=[self->arrDates1 valueForKey:@"AvailableForm"];
           self->themeColorArray=[self->arrDates1 valueForKey:@"ThemeColor"];
                
                self->noteBodyArray=[self->arrDates1 valueForKey:@"Note"];

                
                

            } @catch (NSException *exception)
            {
                
                if (!self->arrDates) {
                    self->arrDates = [[NSArray alloc] init];
                    
                }
                
            }
            @finally{
                
                if ([self->arrDates isKindOfClass:[NSArray class]])
                {
                    
                    
                    [self UpdateCalenderViewWithJobs:self->arrDates];
                }
            
                
            }
        });
        
        
        
   
    
}
-(void)pressdeletejob:(UIButton *)sender
{
    deletecount=1;
    

    NSDictionary *user = [[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *AvailabilityID = availblityId;
    
//    DLog(@"%@",user);
   
   NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString=[NSString stringWithFormat:@"%sEngineerCalenderAvailbilityDelete?UserToken=%@&AvailabilityID=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],AvailabilityID];

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
    [mainBg removeFromSuperview];
    _CalendarView.hidden =NO;
    [self EngineerCalenderAvailbiltProcess];
    greenCount =0;
    redCount=0;
    timeOnDate =@"";
    timeOnDate1 =@"";
    noteCount=0;
    noteDataCount=0;
    emptyDateCount=0;
    previousTime = @"";
    previousGreenTime = @"";
    previousRedTime = @"";
    btnCount=0;
    noteCount1=0;
    noteCount2=0;
    noteCount3=0;
    selectedBtnCount =0;
    availblityId = nil;
    

}

-(void)pressRecreateOroceed:(UIButton *)sender
{
    
    
    UIButton *btn=(UIButton *)sender;
    
    NSString *alertmsg;
//    DLog(@"note saved");



    
 if ([txtStartTime.text isEqualToString:@""]||[self BlankSpaces:txtStartTime])
    {
        
        
        alertmsg=@"Enter Start Time";
        [self Showalert:alertmsg];
    }
    
   
    else if ([txtEndTime.text isEqualToString:@""]||[self BlankSpaces:txtEndTime] ||txtEndTime.text.length<12 ||[strttimetxtfldDate1 hasSuffix:@"00:00"])
    {
        alertmsg=@"Enter End Time";
        [self Showalert:alertmsg];
    }
    else if  ([strttimetxtfldDate hasPrefix:@" dd/MM/yyyy "]>[strttimetxtfldDate1 hasPrefix:@"dd/MM/yyyy"])
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
            
            
            NSString*usertoken=[user valueForKey:@"UserToken"];
            NSString *stafid = [user valueForKey:@"StaffID"];

            

            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
               [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
               NSDate *date  = [dateFormatter dateFromString:txtStartTime.text];
              NSDate *date1  = [dateFormatter dateFromString:txtEndTime.text];

               // Convert to new Date Format
               [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
               NSString *newDate = [dateFormatter stringFromDate:date];
              NSString *newDate1 = [dateFormatter stringFromDate:date1];
            
//              DLog(@"ThemeColor :%@",newDate1);
    
            
            NSString *strColor= txtTimeAllowance.text;
            NSString*NotesStr = txtvNoteBody.text;
            
            DLog(@"ThemeColor :%@",strColor);
            DLog(@"Notesbody :%@",NotesStr);
            DLog(@"stafid :%@",stafid);
            DLog(@"Availbiltyid :%@",availblityId);
            DLog(@"usertoken :%@",usertoken);
            
//            string userToken, int EngineerID, DateTime AvailableForm, DateTime AvailableTo, string Note, string ThemeColor
            [self postRecreateConfirmation:(NSString *)[user valueForKey:@"UserToken"] EngineerID:stafid AvailabilityID:availblityId description:txtvNoteBody.text timeallowance:(NSString *)txtTimeAllowance.text starttime:(NSString *)newDate
                                   endtime:(NSString *)newDate1];
            [self.view endEditing:YES];
        }
    
}
#pragma mark - check Blank Space Method
-(void)Showalert:(NSString *)msg
{
   
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
    [formatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
//    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
   
    UITextField *actvfld=(UITextField *)txtStartTime;
    actvfld.text = [formatter stringFromDate:datepicker.date];
    
//    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    

}
#pragma mark - Date Updated Method
- (void) dateUpdated2:(UIDatePicker *)datePicker2
{
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    
   
    UITextField *actvfld1=(UITextField *)txtEndTime;
    actvfld1.text = [formatter stringFromDate:datePicker2.date];
    

}




#pragma mark - Time Updated Method
- (void) timeUpdated:(UIDatePicker *)datePicker
{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateFormat:@"EE MM dd HH:mm:ss ZZZ yyyy"];

    UITextField *actvfld=(UITextField *)txtStartTime;
    actvfld.text = [formatter stringFromDate:datePicker.date];

}
#pragma mark - Time Updated Method
- (void) timeUpdated2:(UIDatePicker *)datePicker2
{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EE MM dd HH:mm:ss ZZZ yyyy"];

    UITextField *actvfld1=(UITextField *)txtEndTime;
    actvfld1.text = [formatter stringFromDate:datePicker2.date];
}
-(void)OK
{
    
   [self.view endEditing:YES];
   
     }
-(void)cancel
{
   [self.view endEditing:YES];
    
}


#pragma mark - DSLCalendarView Delegate and Datasource Method
- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range
{
    
    
    
    emptyDateCount=0;
    noteDataCount=0;
    
//   NSString *prviousAvailbiltyid;
    savedValue = [[NSUserDefaults standardUserDefaults]
          stringForKey:@"preferenceName"];
   
    for(id clickdate in arrDates)
    {
    
        
        NSString *Eventsdic1  = [clickdate substringWithRange:NSMakeRange(0,10)];
        NSString* time = [clickdate substringWithRange:NSMakeRange(10,9)];
        
       
        if(noteDataCount<=arrDates.count)
        {
            
        noteDataCount++;
        if( [Eventsdic1 isEqualToString:savedValue])
        {
          

            emptyDateCount++;
            if(time !=previousTime )
            {
                
                
                previousTime =time;
                NSInteger counted = 0;
                counted++;
                
                if(noteCount==0)
                {
                    
                   
                    noteCount = counted;
                    jobdetailarray = arrDates1[noteDataCount-1];
//                    DLog(@"noteCount = %@", jobdetailarray);
                    btnCount=1;
                    availabilityIDonBtn1 = [self ->jobdetailarray valueForKey:@"AvailabilityID"];
                    availbfromOnBtn1 = [self ->jobdetailarray valueForKey:@"AvailableForm"];
                 AvailbTOnBtn1 = [self ->jobdetailarray valueForKey:@"AvailableTo"];
                    themeColorOnBtn1 = [self ->jobdetailarray valueForKey:@"ThemeColor"];
                  notesOnBtn1 = [self ->jobdetailarray valueForKey:@"Note"];
                    
                }
               else if(noteCount1==0 && noteCount != 0)
                {
                    
                    noteCount1 =counted;
                    jobdetailarray1 = arrDates1[noteDataCount-1];
                    
                    
//                    DLog(@"noteCount = %@", jobdetailarray1);
                    btnCount=2;
                    availabilityIDonBtn2 = [self ->jobdetailarray1 valueForKey:@"AvailabilityID"];
                    availbfromOnBtn2 = [self ->jobdetailarray1 valueForKey:@"AvailableForm"];
                 AvailbToOnBtn2 = [self ->jobdetailarray1 valueForKey:@"AvailableTo"];
                    themeColorOnBtn2 = [self ->jobdetailarray1 valueForKey:@"ThemeColor"];
                  notesOnBtn2 = [self ->jobdetailarray1 valueForKey:@"Note"];
                    
                }
               else if(noteCount1 !=0 && noteCount2==0)
                {
                    
                    noteCount2 =counted;
                    jobdetailarray2 = arrDates1[noteDataCount-1];
//                    DLog(@"noteCount2=%@",jobdetailarray2);
                    btnCount=3;
                    availabilityIDonBtn3 = [self ->jobdetailarray2 valueForKey:@"AvailabilityID"];
                    availbfromOnBtn3 = [self ->jobdetailarray2 valueForKey:@"AvailableForm"];
                 AvailbToOnBtn3 = [self ->jobdetailarray2 valueForKey:@"AvailableTo"];
                    themeColorOnBtn3 = [self ->jobdetailarray2 valueForKey:@"ThemeColor"];
                  notesOnBtn3 = [self ->jobdetailarray2 valueForKey:@"Note"];
                    
                }
               else if(noteCount2 !=0 && noteCount3 ==0)
                {
                    
                    noteCount3 =counted;
                    jobdetailarray3 = arrDates1[noteDataCount-1];
//                    DLog(@"noteCount2=%@",jobdetailarray3);
                    btnCount=4;
                    availabilityIDonBtn4 = [self ->jobdetailarray3 valueForKey:@"AvailabilityID"];
                    availbfromOnBtn4 = [self ->jobdetailarray3 valueForKey:@"AvailableForm"];
                 AvailbToOnBtn4 = [self ->jobdetailarray3 valueForKey:@"AvailableTo"];
                    themeColorOnBtn4 = [self ->jobdetailarray3 valueForKey:@"ThemeColor"];
                    notesonBtn4 = [self ->jobdetailarray3 valueForKey:@"Note"];
                    
                    
                }
                

                   
            }

            
       
        }
        
    }
        
       
    }
    if(emptyDateCount ==0)
    {
        
        
        
        
        
        [ self viewPopUPFormRecreateMethod:(NSString *)strJobID];
    }
    

    self->themeColorArray=[self->arrDates1 valueForKey:@"ThemeColor"];
    NSMutableArray*values;
    values = [self->jobdetailarray valueForKey:@"AvailabilityID"];


     for (id object in arrDates)
     {
         
         
        NSString *Eventsdic1  =  [object substringWithRange:NSMakeRange(0,10)];

         timeOnDate  =  [object substringWithRange:NSMakeRange(10,9)];
      
         if ([Eventsdic1 isEqualToString:savedValue])
         {
  
             if(timeOnDate != previousGreenTime)
             {
                 
                 
                 availbleFromdate=object;
                 
                 
                 if (greenCount==0)
                 {
                     

                 [self jobdetailpopup:(NSString *)strJobID];
                     greenCount++;
                 }
                 
                 
        }
    }
             
         }
     
         
             
    for (id object in newRedArray)
       
    {
        
        
       NSString *Eventsdic1  =  [object substringWithRange:NSMakeRange(0,10)];

        timeOnDate1  =  [object substringWithRange:NSMakeRange(10,9)];

        
        if ([Eventsdic1 isEqualToString:savedValue])
        {
            
            if(timeOnDate1 != previousRedTime )
            {
                
                availbleFromdate=object;
                if (greenCount==0)
                {
                    

                [self jobdetailpopup:(NSString *)strJobID];
                    greenCount++;
                }
                   
        
            }
            
        }
    }
         
     
        }
      
        
    

    
     
    


- (DSLCalendarRange*)calendarView:(DSLCalendarView *)calendarView didDragToDay:(NSDateComponents *)day selectingRange:(DSLCalendarRange *)range
{
    
    
    
    if (NO)
    { // Only select a single day
        return [[DSLCalendarRange alloc] initWithStartDay:day endDay:day];
    }
    else if (/* DISABLES CODE */ (NO))
    { // Don't allow selections before today
        NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:calendarView.visibleMonth.calendar];
        
        NSDateComponents *startDate = range.startDay;
        NSDateComponents *endDate = range.endDay;
        
        if ([self day:startDate isBeforeDay:today] && [self day:endDate isBeforeDay:today]) {
            return nil;
        }
        else {
            if ([self day:startDate isBeforeDay:today]) {
                startDate = [today copy];
            }
            if ([self day:endDate isBeforeDay:today]) {
                endDate = [today copy];
            }
            
            return [[DSLCalendarRange alloc] initWithStartDay:startDate endDay:endDate];
        }
    }
    
    return range;
}
//-(void)fetchDayWiseJobs:(NSString*)date
//{
//
//
//    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:(NSString *)[user valueForKey:@"UserToken"] forKey:@"userToken"];
//    [dict setObject:date forKey:@"jobDate"];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [globe SyncRequestGet:REQUEST_GetCalendarJob withPrams:dict andCompletionHandler:^(NSDictionary *result) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            @try {
//
//                JobsOnDate=[[NSMutableArray alloc]init];
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                [JobsOnDate addObjectsFromArray:[result valueForKey:@"JobListResponse"]];
//
//            } @catch (NSException *exception) {
//
//                if (!JobsOnDate) {
//                    JobsOnDate = [[NSMutableArray alloc] init];
//                }
//
//            }@finally{
//
//                if ([JobsOnDate isKindOfClass:[NSMutableArray class]]) {
////                    [self PopUptableViewListingJobs];
//                }
//            }
//        });
//    }];
//
//}
-(void)postRecreateConfirmation:(NSString *)strUserToken EngineerID:(NSString *)staffid  AvailabilityID:(NSString *)availblityId  description:(NSString *)strDescription timeallowance:(NSString *)ThemeColor starttime:(NSString *)strStartTime endtime:(NSString *)strEndTime
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    

   
   NSString *post =[NSString stringWithFormat:@""];
   NSString *urlString;
    
    urlString=[NSString stringWithFormat:@"%sEngineerCalenderCreateAvailbility?userToken=%@&EngineerID=%@&AvailabilityID=%@&Themecolor=%@&Note=%@&AvailableFrom=%@&AvailableTo=%@",conn_url,strUserToken,staffid,availblityId,ThemeColor,strDescription,strStartTime,strEndTime];
    if(availblityId==nil)
    {
        
        urlString=[NSString stringWithFormat:@"%sEngineerCalenderCreateAvailbility?userToken=%@&EngineerID=%@&Themecolor=%@&Note=%@&AvailableFrom=%@&AvailableTo=%@",conn_url,strUserToken,staffid,ThemeColor,strDescription,strStartTime,strEndTime];
    }
  
    DLog(@"PostString=%@",urlString);
    
    NSString *originalString = urlString;

    NSString *newString = [originalString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DLog(@"PostString=%@",newString);
    
   
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:newString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    request.timeoutInterval = 300;
    DLog(@"PostString=%@",request);
    
    connRecreateConfirmation = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connRecreateConfirmation start];
    [mainBg removeFromSuperview];
    _CalendarView.hidden =NO;
    [self EngineerCalenderAvailbiltProcess];
    greenCount =0;
    redCount=0;
    timeOnDate =@"";
    timeOnDate1 =@"";
    noteCount=0;
    noteDataCount=0;
    emptyDateCount=0;
    previousTime = @"";
    previousGreenTime = @"";
    previousRedTime = @"";
    btnCount=0;
    noteCount1=0;
    noteCount2=0;
    noteCount3=0;
    selectedBtnCount =0;
    availblityId = nil;


    
    
}

-(void)EngineerCalenderAvailbiltProcess
{
    
    noteDataCount=0;
    Count=0;

    NSDictionary *user = [[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *staffid = [user valueForKey:@"StaffID"];

   NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString=[NSString stringWithFormat:@"%sGetEngineerCalenderAvailabilityList?UserToken=%@&staffid=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],staffid];

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
    
connLogin = [[NSURLConnection alloc] initWithRequest:request delegate:self];
[connLogin start];


}
#pragma mark - NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    _responseData = [[NSMutableData alloc] init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_responseData appendData:data];
}
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
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
                dicUsercalenderDetails=temp;
                                   DLog(@"%@", temp);
                                
                                   self->arrDates1=[self->dicUsercalenderDetails valueForKey:@"EnggAvailabilityListResponse"];
                              

                                   self->themeColorArray=[self->arrDates1 valueForKey:@"ThemeColor"];
                                   availblityToArray=[self->arrDates1 valueForKey:@"AvailableTo"];
                                   avaliablityArrayid=[self->arrDates1 valueForKey:@"AvailabilityID"];
                              
//                                   [[NSUserDefaults standardUserDefaults] setObject:themeColorArray forKey:@"calenderthemecolordetail"];
//                                   [[NSUserDefaults standardUserDefaults] synchronize];
                                   [self FetchCalanderJobDates:[NSDate date]];
            
                if (connection==connRecreateConfirmation)
                {
                    if(deletecount==0)
                    {
            
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @""
                                                    message:@"New event updated successfully"
                                                                                 preferredStyle: UIAlertControllerStyleAlert];
                    
                   
                    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                                          style: UIAlertActionStyleDestructive
                                                                        handler: ^(UIAlertAction *action) {
                        
                        [self EngineerCalenderAvailbiltProcess];
                        [self->mainBg removeFromSuperview];
                        self->_CalendarView.hidden=NO;
                        self->greenCount =0;
                        self->redCount=0;
                        self->timeOnDate =@"";
                        self->timeOnDate1 =@"";
                        self->noteCount=0;
                        self->noteDataCount=0;
                        self->emptyDateCount=0;
                        self->previousTime = @"";
                        self->previousGreenTime = @"";
                        self->previousRedTime = @"";
                        self->btnCount=0;
                        self->noteCount1=0;
                        self->noteCount2=0;
                        self->noteCount3=0;
//                       self->selectedBtnCount =0;
                [self.navigationController popViewControllerAnimated:YES];
                                                                        }];
                    
                    
                    
                    
                    [controller addAction: alertAction];
                    
                    [self presentViewController: controller animated: YES completion: nil];
                    [mainBg removeFromSuperview];
                }
                    else{
            
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @""
                                                    message:@ "Event delte successfully"
                                                                                 preferredStyle: UIAlertControllerStyleAlert];
                    
                   
                    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                                          style: UIAlertActionStyleDestructive
                                                                        handler: ^(UIAlertAction *action) {
                        
                        [self EngineerCalenderAvailbiltProcess];
                        [self->mainBg removeFromSuperview];
                        self->_CalendarView.hidden=NO;
                        self->greenCount =0;
                        self->redCount=0;
                        self->timeOnDate =@"";
                        self->timeOnDate1 =@"";
                        self->noteCount=0;
                        self->noteDataCount=0;
                        self->emptyDateCount=0;
                        self->previousTime = @"";
                        self->previousGreenTime = @"";
                        self->previousRedTime = @"";
                        self->btnCount=0;
                        self->noteCount1=0;
                        self->noteCount2=0;
                        self->noteCount3=0;
                        self->deletecount=0;
                [self.navigationController popViewControllerAnimated:YES];
                                                                        }];
                    
                    
                    
                    
                    [controller addAction: alertAction];
                    
                    [self presentViewController: controller animated: YES completion: nil];
                    [mainBg removeFromSuperview];
                }
                }
            }
            else
            {
                [_spinner stopAnimating];
                [_spinner setHidesWhenStopped:YES];
                DLog(@"JSONObjectWithData error: %@", error);
                
                
                    [self showAlert:[NSString stringWithFormat:@"%@",[temp valueForKey:@"ResponseMessages"]]  withTitle:@""];
                
                
              
            }
        }
    }
    else
    {
        [_spinner stopAnimating];
        [_spinner setHidesWhenStopped:YES];
    }
    
    
    
  
    
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
