//
//  GasSafetyNatGas.m
//  Partner Maintenance
//


#import "GasSafetyNatGas.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
@class AppDelegate;

@interface GasSafetyNatGas ()
{
    NSArray *arrAdress,*arrFinalChecks,*arrEnggSignOffDetails;
    NSString *AdditionalNote;
    AppDelegate *app;
   
}

@end

@implementation GasSafetyNatGas

#pragma  mark - Create Certificate Data
-(void)createCertificate
{
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:_webVW animated:YES];
    hud.labelText=@"Generating Certificate";
    [self.view addSubview:hud];
    
    //NSString *post =[NSString stringWithFormat:@""];
   // NSLog(@"post :%@",post);
    NSError *error;
    NSData *GasSafetyNatRecordData = [NSJSONSerialization dataWithJSONObject:_GasSafetyNatRecord
                                                              options:0
                                                            error:&error];
    NSString *JSONString,*JSONStringAppliance,*JSONStringAdress,*JSONStringEnggSignOF,*JSONStringFinalchk;
    NSData *jsonAppliance,*jsonAddress,*jsonEnggSignOf ,*jsonFinalChk;
    
    if (!GasSafetyNatRecordData) {
    } else {
        JSONString = [[NSString alloc] initWithBytes:[GasSafetyNatRecordData bytes] length:[GasSafetyNatRecordData length] encoding:NSUTF8StringEncoding];
    }
    
    
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSLog(@"JSONString :%@",JSONString);
    
    if (arrAdress!=nil) {
        jsonAddress = [NSJSONSerialization dataWithJSONObject:arrAdress
                                                      options:0
                                                        error:&error];
        JSONStringAdress = [[NSString alloc] initWithBytes:[jsonAddress bytes] length:[jsonAddress length] encoding:NSASCIIStringEncoding];
        
    }
    
    if (app.arrApplianceInspection!=nil) {
        jsonAppliance = [NSJSONSerialization dataWithJSONObject:app.arrApplianceInspection
                                                        options:0
                                                          error:&error];
        JSONStringAppliance = [[NSString alloc] initWithBytes:[jsonAppliance bytes] length:[jsonAppliance length] encoding:NSASCIIStringEncoding];

    }
  
    if (arrEnggSignOffDetails!=nil) {
        jsonEnggSignOf  = [NSJSONSerialization dataWithJSONObject:arrEnggSignOffDetails
                                                          options:0
                                                            error:&error];
         JSONStringEnggSignOF = [[NSString alloc] initWithBytes:[jsonEnggSignOf bytes] length:[jsonEnggSignOf length] encoding:NSASCIIStringEncoding];
        
    }
    if (arrFinalChecks!=nil) {
        jsonFinalChk  = [NSJSONSerialization dataWithJSONObject:arrFinalChecks
                                                        options:0
                                                          error:&error];
        JSONStringFinalchk = [[NSString alloc] initWithBytes:[jsonFinalChk bytes] length:[jsonFinalChk length] encoding:NSASCIIStringEncoding];
    }
    
    
    
    
  
    NSData *imageData = UIImageJPEGRepresentation(_imgSignRef, 1.0);
    NSString * base64String = [imageData base64EncodedStringWithOptions:0];
    //NSString * encodedImageString = [base64String stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
 
    NSString *json;
    NSMutableDictionary *postDictionary = [NSMutableDictionary dictionary];
    [postDictionary setValue:JSONString forKey:@"GasSafetyRecordData"];
    [postDictionary setValue:_txtDate.text forKey:@"creationDate"];
    [postDictionary setValue:_lblUniqueNo.text forKey:@"uniqueNo"];
    //[postDictionary setValue:_txtReferenceNo.text forKey:@"reference"];
    [postDictionary setValue:(NSString *)[userdetails valueForKey:@"UserToken"] forKey:@"userToken"];
    [postDictionary setValue:(NSString *)[userdetails valueForKey:@"UserID"] forKey:@"userID"];
    
    [postDictionary setValue:JSONStringAdress forKey:@"address"];
    [postDictionary setValue:JSONStringAppliance forKey:@"applianceInspection"];
    [postDictionary setValue:JSONStringEnggSignOF forKey:@"enggSignOffDetails"];
    [postDictionary setValue:JSONStringFinalchk forKey:@"finalChecks"];
    
    if (AdditionalNote.length>0) {
        [postDictionary setValue:AdditionalNote forKey:@"additionalNote"];
    }
    
    
    
    
    
    [postDictionary setValue:[NSString stringWithFormat:@"%@",[_jobDic valueForKey:@"JobID"]] forKey:@"jobId"];
    
    
    [postDictionary setObject:base64String forKey:@"imageData"];
    [postDictionary setObject:@"jpg" forKey:@"imageextension"];
    
    
    
    NSURL *url;
    url=[NSURL URLWithString:[NSString stringWithFormat:@"%sSetGasSafetyNatGas",conn_url]];
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
    //NSLog(@"request Body:%@",[request HTTPBody]);
    NSString *strReq = [[NSString alloc] initWithData:postData encoding:NSASCIIStringEncoding];
    NSLog(@"%@",strReq);
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
}

#pragma mark- NSURLConnection Delegate Methods
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
                    if ([[[temp valueForKey:@"SetGasSafetyNatGasResult"]valueForKey:@"ResponseMessages"] isEqualToString:@"SUCCESS"])
                    {
                        app.arrApplianceInspection = [[NSArray alloc] init];
                        if (connection==connEmailGasCert)
                        {
                           
                            
                            [self showAlert:@"Email sent"  withTitle:@"Success"];
                        }
                        else
                        {
                            NSString *link=[[temp valueForKey:@"SetGasSafetyNatGasResult"]valueForKey:@"ReturnValue"];
                            certLink=link;
                            NSURL *url = [NSURL URLWithString:[certLink stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
                            NSLog(@"url>>>>> %@",url);
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                    }else{
                        [self showAlert:[GlobalDirector ReplaceStringNull:[[temp valueForKey:@"SetGasSafetyNatGasResult"]valueForKey:@"ResponseMessages"] ] withTitle:@"Error"];
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



#pragma mark- WebView Delegate Method
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideAllHUDsForView:webView animated:YES];
}

#pragma mark- ViewDidLoad Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    _GasSafetyNatRecord=[[NSMutableDictionary alloc]init];
    
    app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (!app.arrApplianceInspection) {
        app.arrApplianceInspection = [[NSArray alloc] init];
    }
    
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
    
    NSDateFormatter *formt = [[NSDateFormatter alloc] init];
    [formt setDateFormat:@"ddMMyyyy"];
    NSString *firstHalfUnique = [formt stringFromDate:[NSDate date]];
    NSString *jobID= [NSString stringWithFormat:@"%@",[_jobDic valueForKey:@"JobID"]];
    NSString *uniqueNo=[NSString stringWithFormat:@"%@%@%d",firstHalfUnique,jobID,rand() %50 ];
    _lblUniqueNo.text=uniqueNo;
    
    [self getUniqueID];
    
}



#pragma mark- viewDidAppear Method
-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%@",_GasSafetyNatRecord);
    _scrlVW.contentSize=CGSizeMake(_scrlVW.frame.size.width, CGRectGetMaxY(_vwPrintCertEmail.frame));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- BackTapped Method
- (IBAction)btnBackTapped:(id)sender {
   
    if (certLink.length!=0) {
        if([self.delegate respondsToSelector:@selector(CertificateGenerated:)]) {
            [self.delegate CertificateGenerated:YES];
        }
    }
     [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Date Picker View
- (void) initializeTextFieldInputView
{
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.minuteInterval = 5;
    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker addTarget:self action:@selector(dateUpdated:) forControlEvents:UIControlEventValueChanged];
    
    _txtDate.inputView = datePicker;
}

#pragma mark- Next Cancel Method
-(void)cancel{
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
    
    _txtDate.text = [formatter stringFromDate:datePicker.date];
}



#pragma mark - UITextField Delegate Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    actvtextbox=textField;
}


#pragma mark- ApplianceInspection - FinalChecks - AdressDetails - AdditionalNotes - Engineersignoff - ViewCertificate Method
- (IBAction)btnApplianceInspectionTappe:(id)sender
{
    ApplianceInspection *obj =[[ApplianceInspection alloc] initWithNibName:@"ApplianceInspection" bundle:Nil];
    obj.delegate=self;
    
    if (app.arrApplianceInspection) {
        obj.arrApplianceData = [app.arrApplianceInspection mutableCopy];
    }
    
    [self presentViewController:obj animated:YES completion:nil];
  
}

- (IBAction)btnFinalChecksTapped:(id)sender
{
    FinalChecks *obj = [[FinalChecks alloc] initWithNibName:@"FinalChecks" bundle:Nil];
    obj.delegate=self;
    [self presentViewController:obj animated:YES completion:nil];
        
}

- (IBAction)btnAdressDetailsTapped:(id)sender
{
    GasFormAdress *obj =[[GasFormAdress alloc] initWithNibName:@"GasFormAdress" bundle:Nil];
       
        obj.jobDic=_jobDic;
        obj.delegate=self;
        [self presentViewController:obj animated:YES completion:nil];
   
}

- (IBAction)btnAdditionalNotesTapped:(id)sender
{
    AdditionalNotes *obj = [[AdditionalNotes alloc] initWithNibName:@"AdditionalNotes" bundle:Nil];
    obj.delegate=self;
    [self presentViewController:obj animated:YES completion:nil];
        
    
}
- (IBAction)btnEngineersignoffTapped:(id)sender
{
    Engineersignoff *obj=[[Engineersignoff alloc] initWithNibName:@"Engineersignoff" bundle:Nil];
        
        obj.delegate=self;
        obj.jobDic=_jobDic;
        [self presentViewController:obj animated:YES completion:nil];
    
    
}
- (IBAction)btnViewCertificateTapped:(id)sender
{
    _webVW.hidden=NO;
    [self createCertificate];
}



#pragma mark All Class Delegates
-(void)ApplianceDidAddedWithData:(NSArray *)datas
{
    NSLog(@"%@",datas);
    app.arrApplianceInspection=datas;//@[datas];
   
}
-(void)GasFormAddress:(NSArray *)address
{
    NSLog(@"%@",address);
    arrAdress=address;
    
}
-(void)FinalChecksDidAddedWithData:(NSDictionary *)datas
{
    NSLog(@"%@",datas);
    arrFinalChecks=@[datas];
   
}
-(void)AdditionalNotesAdded:(NSString *)note
{
    NSLog(@"%@",note);
    AdditionalNote=note;
   
}
-(void)EnggSignOffDetailsValue:(NSDictionary *)datas
{
    NSLog(@"%@",datas);
    arrEnggSignOffDetails=@[datas];
    
}


#pragma mark- Hide WebView Method
- (IBAction)hideWeb:(id)sender
{
    _vwCertGas.hidden=YES;
}


#pragma mark- UniqueID  Generate Method
-(void)getUniqueID
{
 
    _actvUniqno.hidden=NO;
    [_actvUniqno startAnimating];
    
    
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *urlString;
    NSString *post =[NSString stringWithFormat:@""];
    
    urlString=[NSString stringWithFormat:@"%sGetGasSafetySerialNumber?userToken=%@&jobId=%@&certificateFor=LGSR",conn_url, (NSString *)[userdetails valueForKey:@"UserToken"],[_jobDic valueForKey:@"JobID"]];
     urlString= [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    
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
@end
