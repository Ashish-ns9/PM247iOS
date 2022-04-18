//
//  EngineerSetAvialability.m
//  Partner Maintenance
//


#import "EngineerSetAvialability.h"

@interface EngineerSetAvialability ()

@end

@implementation EngineerSetAvialability
@synthesize btnSlideMenu;

#pragma mark - ViewWillAppear Method
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self fetchDetails];
}

#pragma mark - ViewDidLoad Mthod
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    [self Timepicker];
    _btnSave.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:18.0];
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
    
    // [_scroll setContentSize:CGSizeMake(320,700)];
    
    
    //--------------------------------Date from / to Time-----------------------------------
    [_txtMondayFromtime setBorderStyle:UITextBorderStyleNone];
    _txtMondayFromtime.layer.borderWidth=0.5f;
    _txtMondayFromtime.layer.borderColor=[[UIColor grayColor]CGColor];
    _txtMondayFromtime.layer.cornerRadius=0.0f;
    
    [_txtMondaytoTime setBorderStyle:UITextBorderStyleNone];
    _txtMondaytoTime.layer.borderWidth=0.5f;
    _txtMondaytoTime.layer.borderColor=[[UIColor grayColor]CGColor];
    _txtMondaytoTime.layer.cornerRadius=0.0f;
    //-----------
    [_txtTuesdayFromtime setBorderStyle:UITextBorderStyleNone];
    _txtTuesdayFromtime.layer.borderWidth=0.5f;
    _txtTuesdayFromtime.layer.borderColor=[[UIColor grayColor]CGColor];
    _txtTuesdayFromtime.layer.cornerRadius=0.0f;
    
    [_txtTuesdaytoTime setBorderStyle:UITextBorderStyleNone];
    _txtTuesdaytoTime.layer.borderWidth=0.5f;
    _txtTuesdaytoTime.layer.borderColor=[[UIColor grayColor]CGColor];
    _txtTuesdaytoTime.layer.cornerRadius=0.0f;
    //-----------
    [_txtWednesdayFromtime setBorderStyle:UITextBorderStyleNone];
    _txtWednesdayFromtime.layer.borderWidth=0.5f;
    _txtWednesdayFromtime.layer.borderColor=[[UIColor grayColor]CGColor];
    _txtWednesdayFromtime.layer.cornerRadius=0.0f;
    
    [_txtWednesdaytoTime setBorderStyle:UITextBorderStyleNone];
    _txtWednesdaytoTime.layer.borderWidth=0.5f;
    _txtWednesdaytoTime.layer.borderColor=[[UIColor grayColor]CGColor];
    _txtWednesdaytoTime.layer.cornerRadius=0.0f;
    //-----------
    [_txtThursdayFromtime setBorderStyle:UITextBorderStyleNone];
    _txtThursdayFromtime.layer.borderWidth=0.5f;
    _txtThursdayFromtime.layer.borderColor=[[UIColor grayColor]CGColor];
    _txtThursdayFromtime.layer.cornerRadius=0.0f;
    
    [_txtThursdaytoTime setBorderStyle:UITextBorderStyleNone];
    _txtThursdaytoTime.layer.borderWidth=0.5f;
    _txtThursdaytoTime.layer.borderColor=[[UIColor grayColor]CGColor];
    _txtThursdaytoTime.layer.cornerRadius=0.0f;
    //-----------
    [_txtFridayFromtime setBorderStyle:UITextBorderStyleNone];
    _txtFridayFromtime.layer.borderWidth=0.5f;
    _txtFridayFromtime.layer.borderColor=[[UIColor grayColor]CGColor];
    _txtFridayFromtime.layer.cornerRadius=0.0f;
    
    [_txtFridaytoTime setBorderStyle:UITextBorderStyleNone];
    _txtFridaytoTime.layer.borderWidth=0.5f;
    _txtFridaytoTime.layer.borderColor=[[UIColor grayColor]CGColor];
    _txtFridaytoTime.layer.cornerRadius=0.0f;
    //-----------
    [_txtSaturdayFromtime setBorderStyle:UITextBorderStyleNone];
    _txtSaturdayFromtime.layer.borderWidth=0.5f;
    _txtSaturdayFromtime.layer.borderColor=[[UIColor grayColor]CGColor];
    _txtSaturdayFromtime.layer.cornerRadius=0.0f;
    
    [_txtSaturdaytoTime setBorderStyle:UITextBorderStyleNone];
    _txtSaturdaytoTime.layer.borderWidth=0.5f;
    _txtSaturdaytoTime.layer.borderColor=[[UIColor grayColor]CGColor];
    _txtSaturdaytoTime.layer.cornerRadius=0.0f;
    //-----------
    [_txtSundayFromtime setBorderStyle:UITextBorderStyleNone];
    _txtSundayFromtime.layer.borderWidth=0.5f;
    _txtSundayFromtime.layer.borderColor=[[UIColor grayColor]CGColor];
    _txtSundayFromtime.layer.cornerRadius=0.0f;
    
    [_txtSundaytoTime setBorderStyle:UITextBorderStyleNone];
    _txtSundaytoTime.layer.borderWidth=0.5f;
    _txtSundaytoTime.layer.borderColor=[[UIColor grayColor]CGColor];
    _txtSundaytoTime.layer.cornerRadius=0.0f;
    //--------------------------------------------------------------------------------------------
    timePicker= [[UIDatePicker alloc] initWithFrame:CGRectZero];
    timePicker.datePickerMode = UIDatePickerModeTime;
    timePicker.backgroundColor = [UIColor whiteColor];
    [timePicker addTarget:self action:@selector(timeUpdated:) forControlEvents:UIControlEventValueChanged];
    timePicker.minuteInterval = 5;
    
    _txtMondayFromtime.inputView=timePicker;
    _txtMondaytoTime.inputView=timePicker;
    
    _txtTuesdayFromtime.inputView=timePicker;
    _txtTuesdaytoTime.inputView=timePicker;
    
    _txtWednesdayFromtime.inputView=timePicker;
    _txtWednesdaytoTime.inputView=timePicker;
    
    _txtThursdayFromtime.inputView=timePicker;
    _txtThursdaytoTime.inputView=timePicker;
    
    _txtFridayFromtime.inputView=timePicker;
    _txtFridaytoTime.inputView=timePicker;
    
    _txtSaturdayFromtime.inputView=timePicker;
    _txtSaturdaytoTime.inputView=timePicker;
    
    _txtSundayFromtime.inputView=timePicker;
    _txtSundaytoTime.inputView=timePicker;
    
    
    strMondaychck=@"false";
    strTuesdaychck=@"false";
    strWednesdaychck=@"false";
    strThursdaychck=@"false";
    strFridaychck=@"false";
    strSaturdaychck=@"false";
    strSundaychck=@"false";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SWRevealViewController Delegate Methods
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if (position == FrontViewPositionLeftSide)
    {}
    else if (position == FrontViewPositionLeft)
    {}
}

#pragma mark - Save All Shedule Method
-(IBAction)svaePress:(id)sender
{
    
    NSString *post =[NSString stringWithFormat:@""];
    DLog(@"post %@",post);
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSError *error;
    NSData *jsonShedule = [NSJSONSerialization dataWithJSONObject:arrMSheduleDayTime
                                                          options:0
                                                            error:&error];
    NSString *JSONstringShedule;
    if (!jsonShedule)
    {
        JSONstringShedule=@"";
    }
    else
    {
        JSONstringShedule = [[NSString alloc] initWithBytes:[jsonShedule bytes] length:[jsonShedule length] encoding:NSUTF8StringEncoding];
    }
    DLog(@"JSONstringShedule :%@",JSONstringShedule);
    NSString *urlString=[NSString stringWithFormat:@"%sSetEngineerAvailability?userToken=%@&enggAvailability=%@",conn_url,(NSString *)[userdetails valueForKey:@"UserToken"],JSONstringShedule];
    
    NSString *mainString = [urlString stringByReplacingOccurrencesOfString:@"" withString:@"%20"];
    //    urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    urlString  = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    request.timeoutInterval = 300;
    [MBProgressHUD showHUDAddedTo:_scroll animated:YES];
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *returnData, NSURLResponse *response, NSError *error){
        NSMutableDictionary* temp;
        if (returnData !=nil)
        {
            NSError *error;
            temp = [NSJSONSerialization JSONObjectWithData:returnData  options:NSJSONReadingMutableContainers error:&error];
            if (!error)
            {
                if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
                {
                    DLog(@"%@",temp);
                    
                    [self showAlert:@"Shedule updated successfully." withTitle:@"Update Successful"];
                    
                    [MBProgressHUD hideAllHUDsForView:_scroll animated:YES];
                }
            }
            else
            {
                DLog(@"JSONObjectWithData error: %@", error);
            }
        }
    }];
}

#pragma mark - Monday - Tuesday - Wednesday - Thursday - Friday - Staurday - Sunday Method
-(IBAction)btnCheck:(UIButton *)sender{
    
    NSInteger index=sender.superview.tag-1;
    
    NSMutableDictionary *dic;
    if ([arrMSheduleDayTime count]>0)
    {
        dic=[arrMSheduleDayTime objectAtIndex:index];
        
    }
    if ([[dic valueForKey:@"IsSelect"]boolValue]==1) {
        
        [sender setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        [dic setObject:@"false" forKey:@"IsSelect"];
        [dic setObject:@"" forKey:@"AvailableForm"];
        [dic setObject:@"" forKey:@"AvailableTo"];
        DLog(@"%ld",(unsigned long)[[sender.superview subviews]count]);
        for (UITextField *txt in [sender.superview subviews])
        {
            if ([txt isKindOfClass:[UITextField class]]) {
                UITextField *txtfld=(UITextField *)txt;
                txtfld.text=@"";
            }
        }
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [dic setObject:@"true" forKey:@"IsSelect"];
        
    }
    
    [arrMSheduleDayTime replaceObjectAtIndex:index withObject:dic];
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
#pragma mark - Time Picker Method
-(void)Timepicker
{
    if (numberToolbar==nil) {
        numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,310, 310, 50)];
    }
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.barTintColor=[UIColor lightGrayColor];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(OK)],
                           nil];
    [numberToolbar sizeToFit];
    
    _txtMondayFromtime.inputAccessoryView=numberToolbar;
    _txtMondaytoTime.inputAccessoryView=numberToolbar;
    
    _txtTuesdayFromtime.inputAccessoryView=numberToolbar;
    _txtTuesdaytoTime.inputAccessoryView=numberToolbar;
    
    _txtWednesdayFromtime.inputAccessoryView=numberToolbar;
    _txtWednesdaytoTime.inputAccessoryView=numberToolbar;
    
    _txtThursdayFromtime.inputAccessoryView=numberToolbar;
    _txtThursdaytoTime.inputAccessoryView=numberToolbar;
    
    _txtFridayFromtime.inputAccessoryView=numberToolbar;
    _txtFridaytoTime.inputAccessoryView=numberToolbar;
    
    _txtSaturdayFromtime.inputAccessoryView=numberToolbar;
    _txtSaturdaytoTime.inputAccessoryView=numberToolbar;
    
    _txtSundayFromtime.inputAccessoryView=numberToolbar;
    _txtSundaytoTime.inputAccessoryView=numberToolbar;
    
    
}

#pragma mark - Time Updated Method
- (void) timeUpdated:(UIDatePicker *)datePicker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    actvfld.text = [formatter stringFromDate:datePicker.date];
    
    DLog(@"%ld",(long)actvfld.superview.tag);
    NSInteger SelectedIndex=(NSInteger)actvfld.superview.tag-1;
    
    
    NSMutableDictionary *dic=[arrMSheduleDayTime objectAtIndex:SelectedIndex];
    if (actvfld.tag==11) {
        [dic setObject:actvfld.text forKey:@"AvailableForm"];
    }
    else if (actvfld.tag==22)
    {
        [dic setObject:actvfld.text forKey:@"AvailableTo"];
        
    }
    
    [arrMSheduleDayTime replaceObjectAtIndex:SelectedIndex withObject:dic];
    
    
}

#pragma mark - Textfield Delegate Method
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    actvfld=textField;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}


#pragma mark - Avalaibality Data Fetch
-(void)fetchDetails
{
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString;
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    urlString=[NSString stringWithFormat:@"%sGetEngineerAvailabilityList?userToken=%@&staffId=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[user valueForKey:@"StaffID"]];
    
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
    
    connGetshedule = [[NSURLConnection alloc] init];
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        
        DLog(@"PostString=%@",urlString);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error==nil) {
                _responseData=[data mutableCopy];
                [self connectionDidFinishLoading:connGetshedule];
            }
            else
            {
                
                
            }
            
        });
        
    }];
    //[connGetshedule start];
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading Available time...";
    [hud show:YES];
}
#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
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
            
            if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
            {
                if (connection==connGetshedule)
                {
                    id shedule=[temp objectForKey:@"EnggAvailabilityListResponse"];
                    
                    if ([shedule isKindOfClass:[NSArray class]])
                    {
                        arrMSheduleDayTime=shedule;
                    }
                    DLog(@"arrMSheduleDayTime :%ld",(unsigned long)[arrMSheduleDayTime count]);
                    
                    [self populateView:arrMSheduleDayTime];
                    [hud hide:YES];
                }
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
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    //  [[[UIAlertView alloc]initWithTitle:@"Error" message:@"No network connection. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
    [self showAlert:@"No network connection. Please try again later."  withTitle:@"Error"];
}
-(void)populateView:(NSMutableArray *)arrMPopulate
{
    int i=0;
    
    for (UIView  *Views in [_scroll subviews]) {
        
        DLog(@"%d",i);
        if (i<[arrMPopulate count])
        {
            NSDictionary *DataDic=[arrMPopulate objectAtIndex:i];
            
            for (id vw in [Views subviews])
            {
                if ([vw isKindOfClass:[UITextField class]])
                {
                    UITextField *txtfld=(UITextField *)vw;
                    DLog(@"%ld",(long)txtfld.tag);
                    
                    if (txtfld.tag==11)
                    {
                        txtfld.text=[NSString stringWithFormat:@"%@",[DataDic valueForKey:@"AvailableForm"]];
                    }
                    
                    else if (txtfld.tag==22)
                    {
                        txtfld.text=[NSString stringWithFormat:@"%@",[DataDic valueForKey:@"AvailableTo"]];
                    }
                }
                
                if ([vw isKindOfClass:[UIButton class]])
                {
                    UIButton *chkBtn=(UIButton *)vw;
                    DLog(@"isselect :%@",[DataDic valueForKey:@"IsSelect"]);
                    
                    if ([[DataDic valueForKey:@"IsSelect"]boolValue]==1)
                    {
                        [chkBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [chkBtn setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
                    }
                }
            }
        }
        i++;
    }
}
@end
