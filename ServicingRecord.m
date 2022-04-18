//
//  ServicingRecord.m
//  Partner Maintenance
//


#import "ServicingRecord.h"

@interface ServicingRecord ()
{
    NSArray *arrApplianceCheck,*arrApplianceRecord,*arrFaults,*arrAddress,*arrEnggSignOff,*arrAdditionalNoteAdded;

}
@end

@implementation ServicingRecord

#pragma mark - Segment Press Method
- (IBAction)segJobTypePress:(id)sender
{
}

#pragma mark - viewDidLoad Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    _ServiceRecord=[[NSMutableDictionary alloc]init];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.barTintColor=[UIColor whiteColor];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(Next)],
                           nil];
    [numberToolbar sizeToFit];
    _txtDate.inputAccessoryView = numberToolbar;
    
    [self initializeTextFieldInputView];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    _txtDate.text = [formatter stringFromDate:[NSDate date]];
    
    [self getUniqueID];
}

#pragma mark - viewDidAppear Method
-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%@",_ServiceRecord);
    _scrlVW.contentSize=CGSizeMake(_scrlVW.frame.size.width, CGRectGetMaxY(_vwEmailCert.frame));
}

#pragma mark - didReceiveMemoryWarning Method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Back Press Method
- (IBAction)btnBackTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Date Picker View Method
- (void) initializeTextFieldInputView
{
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.minuteInterval = 5;
    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker addTarget:self action:@selector(dateUpdated:) forControlEvents:UIControlEventValueChanged];
    
    _txtDate.inputView = datePicker;
}

#pragma mark - Next Cancel Method
-(void)cancel
{
    UITextField *txtfld=(UITextField *)actvtextbox;
    [txtfld resignFirstResponder];
    //numberTextField.text = @"";
}
-(void)Next
{
    UITextField *txtfld=(UITextField *)actvtextbox;
    [txtfld resignFirstResponder];
    //[txtfld becomeFirstResponder];
}

#pragma mark - Date Updated Method
- (void) dateUpdated:(UIDatePicker *)datePicker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    UITextField *actvfld=(UITextField *)_txtDate;
    actvfld.text = [formatter stringFromDate:datePicker.date];
}

#pragma mark - UITextField Delegate Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    actvtextbox=textField;
}

#pragma mark - All Button Click Method
- (IBAction)btnApplianceDetailsTapped:(id)sender
{
    GBSRappliancedetails  *obj=[[GBSRappliancedetails alloc] initWithNibName:@"GBSRappliancedetails" bundle:Nil];
        
        obj.delegate=self;
        [self presentViewController:obj animated:YES completion:nil];
    
 
}

- (IBAction)btnApplianceChecksTapped:(id)sender
{
    GBSRappliancechecks  *obj=[[GBSRappliancechecks alloc] initWithNibName:@"GBSRappliancechecks" bundle:Nil];
       
        obj.delegate=self;
        [self presentViewController:obj animated:YES completion:nil];
   
}
        
- (IBAction)btnFaultsTapped:(id)sender
{
    GBSRfaults  *obj=[[GBSRfaults alloc] initWithNibName:@"GBSRfaults" bundle:Nil];
    obj.delegate=self;
    [self presentViewController:obj animated:YES completion:nil];
   
}

- (IBAction)btnAdditionalNotesTapped:(id)sender
{
    GBSRadditionalnotes  *obj=[[GBSRadditionalnotes alloc] initWithNibName:@"GBSRadditionalnotes" bundle:Nil];
    obj.delegate=self;
    [self presentViewController:obj animated:YES completion:nil];
    
    
}

- (IBAction)btnAdressDetailsTapped:(id)sender
{
    GasFormAdress *obj=[[GasFormAdress alloc] initWithNibName:@"GasFormAdress" bundle:Nil];
    obj.delegate=self;
    obj.jobDic=_jobDic;
    [self presentViewController:obj animated:YES completion:nil];
   
}
- (IBAction)btnEngineersignoffTapped:(id)sender
{
    Engineersignoff *obj=[[Engineersignoff alloc] initWithNibName:@"Engineersignoff" bundle:Nil];
        
        obj.delegate=self;
        obj.jobDic=_jobDic;
        [self presentViewController:obj animated:YES completion:nil];

}

#pragma mark - Generate Certificate Method
- (IBAction)btnViewCertTapped:(id)sender
{
    NSLog(@"ServoceREcord Data :: -- %@",_ServiceRecord);
    [self createCertificate];
}

#pragma mark - All data Delegate  Method
-(void)GBSAdditionalNoteAdded:(NSDictionary *)data
{
    [_ServiceRecord setValue:data forKey:@"AdditionalNote"];
    arrAdditionalNoteAdded=@[data];
}
-(void)GBSApplianceCheckData:(NSDictionary *)data
{
   [_ServiceRecord setValue:data forKey:@"ApplianceChecks"];
    arrApplianceCheck=@[data];
}
-(void)GBSApplianceRecordData:(NSDictionary *)data
{
    [_ServiceRecord setValue:data forKey:@"ApplianceRecord"];
    arrApplianceRecord=@[data];
}
-(void)GBSFaultsData:(NSDictionary *)data
{
   [_ServiceRecord setValue:data forKey:@"GBSFaults"];
    arrFaults=@[data];
}
-(void)GasFormAddress:(NSArray *)address
{
   [_ServiceRecord setValue:address forKey:@"Address"];
    arrAddress=address;
}
-(void)EnggSignOffDetailsValue:(NSDictionary *)datas
{
    [_ServiceRecord setValue:datas forKey:@"EnggSignOff"];
    arrEnggSignOff=@[datas];
}


#pragma mark - Craete Certificate Method
-(void)createCertificate
{
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:_webVW animated:YES];
    hud.labelText=@"Generating Certificate";
    [self.view addSubview:hud];

    NSString *post =[NSString stringWithFormat:@""];
    NSLog(@"post :%@",post);
    NSError *error;
    NSString *JSONStringAppliancecheck,*JSONStringAdress,*JSONStringEnggSignOF,*JSONStringAppliancerecord,*JSONStringFualts,*JSONStringAdditionalNotes;
    
    NSData *jsonAppliancecheck,*jsonAddress,*jsonEnggSignOf ,*jsonAppliancerecord,*jsonFualts,*jsonAdditionalNotes;
    
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    if (arrApplianceCheck!=nil) {
        jsonAppliancecheck = [NSJSONSerialization dataWithJSONObject:arrApplianceCheck
                                                             options:0
                                                               error:&error];
        JSONStringAppliancecheck = [[NSString alloc] initWithBytes:[jsonAppliancecheck bytes] length:[jsonAppliancecheck length] encoding:NSUTF8StringEncoding];
        
    }
    if (arrAddress!=nil) {
        jsonAddress = [NSJSONSerialization dataWithJSONObject:arrAddress
                                                      options:0
                                                        error:&error];
        JSONStringAdress = [[NSString alloc] initWithBytes:[jsonAddress bytes] length:[jsonAddress length] encoding:NSUTF8StringEncoding];
        
    }
    if (arrEnggSignOff!=nil) {
        jsonEnggSignOf  = [NSJSONSerialization dataWithJSONObject:arrEnggSignOff
                                                          options:0
                                                            error:&error];
        JSONStringEnggSignOF = [[NSString alloc] initWithBytes:[jsonEnggSignOf bytes] length:[jsonEnggSignOf length] encoding:NSUTF8StringEncoding];
        
    }
    if (arrApplianceRecord!=nil) {
        jsonAppliancerecord = [NSJSONSerialization dataWithJSONObject:arrApplianceRecord
                                                             options:0
                                                               error:&error];
        JSONStringAppliancerecord = [[NSString alloc] initWithBytes:[jsonAppliancerecord bytes] length:[jsonAppliancerecord length] encoding:NSUTF8StringEncoding];
        
    }
    if (arrFaults!=nil) {
        jsonFualts = [NSJSONSerialization dataWithJSONObject:arrFaults
                                                             options:0
                                                               error:&error];
        JSONStringFualts = [[NSString alloc] initWithBytes:[jsonFualts bytes] length:[jsonFualts length] encoding:NSUTF8StringEncoding];
        
    }
    if (arrAdditionalNoteAdded!=nil) {
        jsonAdditionalNotes = [NSJSONSerialization dataWithJSONObject:arrAdditionalNoteAdded
                                                     options:0
                                                       error:&error];
        JSONStringAdditionalNotes = [[NSString alloc] initWithBytes:[jsonAdditionalNotes bytes] length:[jsonAdditionalNotes length] encoding:NSUTF8StringEncoding];
        
    }
    
    NSData *imageData = UIImageJPEGRepresentation(_imgSignRef, 1.0);
    NSString * base64String = [imageData base64EncodedStringWithOptions:0];
    NSString *json;
    NSMutableDictionary *postDictionary = [NSMutableDictionary dictionary];
    [postDictionary setValue:_txtDate.text forKey:@"creationDate"];
    [postDictionary setValue:_lblUniqueNo.text forKey:@"uniqueNo"];
    [postDictionary setValue:[_segJobType titleForSegmentAtIndex:_segJobType.selectedSegmentIndex] forKey:@"certificategastype"];
    [postDictionary setValue:(NSString *)[userdetails valueForKey:@"UserToken"] forKey:@"userToken"];
    [postDictionary setValue:(NSString *)[userdetails valueForKey:@"UserID"] forKey:@"userID"];
    [postDictionary setValue:JSONStringAdress forKey:@"address"];
    [postDictionary setValue:JSONStringAppliancecheck forKey:@"applianceChecks"];
    [postDictionary setValue:JSONStringAppliancerecord forKey:@"applianceRecord"];
    [postDictionary setValue:JSONStringEnggSignOF forKey:@"enggSignOffDetails"];
    [postDictionary setValue:JSONStringFualts forKey:@"GBSFaults"];
    [postDictionary setValue:JSONStringAdditionalNotes forKey:@"additionalNote"];
    [postDictionary setValue:[NSString stringWithFormat:@"%@",[_jobDic valueForKey:@"JobID"]] forKey:@"jobId"];
    [postDictionary setObject:base64String forKey:@"imageData"];
    [postDictionary setObject:@"jpg" forKey:@"imageextension"];
    
    NSURL *url;
    url=[NSURL URLWithString:[NSString stringWithFormat:@"%sSetGasBreakDown",conn_url]];
    NSError *jsonError;
    NSData *reqData=[NSData dataWithBytes:[json UTF8String] length:[json length]];
    self.totalBytes=(unsigned long)[reqData length];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    NSLog(@"request :%@",request);
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = 300;
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDictionary options:0
                                                         error:&jsonError];
    if (!jsonError)
    {
        [request setHTTPBody:postData];
    }
    _totalBytes=_totalBytes+(unsigned long)[postData length];
    [request setValue:[NSString stringWithFormat:@"%ld",(unsigned long)_totalBytes] forHTTPHeaderField:@"Content-Length"];
    NSString *strReq = [[NSString alloc] initWithData:postData encoding:NSASCIIStringEncoding];
    NSLog(@"%@",strReq);
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
}

#pragma mark - Fetch Unique serialNo Method
-(void)getUniqueID
{
    _actvUniqno.hidden=NO;
    [_actvUniqno startAnimating];
    
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *urlString;
    NSString *post =[NSString stringWithFormat:@""];
    urlString=[NSString stringWithFormat:@"%sGetGasSafetySerialNumber?userToken=%@&jobId=%@&certificateFor=GBSR",conn_url, (NSString *)[userdetails valueForKey:@"UserToken"],[_jobDic valueForKey:@"JobID"]];
    urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //NSLog(@"PostString=%@",urlString);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    request.timeoutInterval = 300;
    
    NSLog(@"PostString=%@",request);
    
    connUniqID = [[NSURLConnection alloc] init];
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        DLog(@"PostString=%@",urlString);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error==nil) {
                _responseData=[data mutableCopy];
                [self connectionDidFinishLoading:connUniqID];
            }
            else
            {
            }
        });
    }];
}

#pragma mark - NSURLConnection Delegate Methods
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
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    NSMutableDictionary* temp=[[NSMutableDictionary alloc]init];
    if (_responseData !=nil)
    {
        NSString *string = [[NSString alloc] initWithData: _responseData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",string);
        if (_responseData !=nil)
        {
            NSError *error;
            temp = [NSJSONSerialization JSONObjectWithData:_responseData  options:NSJSONReadingMutableContainers error:&error];
            
            if (!error)
            {
                if (connection==connUniqID)
                {
                    uniqueID=(NSString *)[temp valueForKey:@"ReturnValue"];
                    _lblUniqueNo.text=uniqueID;
                    _actvUniqno.hidden=YES;
                    [_actvUniqno stopAnimating];
                }
                else
                {
                    if ([[[temp valueForKey:@"SetGasBreakDownResult"]valueForKey:@"ResponseMessages"] isEqualToString:@"SUCCESS"])
                    {
                        NSString *link=[[temp valueForKey:@"SetGasBreakDownResult"]valueForKey:@"ReturnValue"];
                        certLink=link;
                        NSURL *url = [NSURL URLWithString:[certLink stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
                        NSLog(@"url>>>>> %@",url);
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        [self showAlert:[GlobalDirector ReplaceStringNull:[[temp valueForKey:@"SetGasBreakDownResult"]valueForKey:@"ResponseMessages"] ] withTitle:@"Error"];
                    }
                    
                    
                    
                }
            }
        }
    }
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
     [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
   // [[[UIAlertView alloc]initWithTitle:@"Error" message:@"No network connection. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
    
    
    [self showAlert:@"No network connection. Please try again later."  withTitle:@"Error"];
}


@end
