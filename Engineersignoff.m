//
//  Engineersignoff.m
//  Partner Maintenance
//


#import "Engineersignoff.h"

@interface Engineersignoff ()
{
    UIControl *bgVw;
    CGFloat XX,YY;
}
@end
@implementation Engineersignoff
@synthesize jobDic;

#pragma mark - Get Engineer Details Method
-(void)getEngineerDetails
{
    dicTempServer=[[NSMutableDictionary alloc] init];
    NSLog(@"JobDic :%@",[jobDic valueForKey:@"JobID"]);
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString=[NSString stringWithFormat:@"%sGetEngineerDetails?usertoken=%@&jobId=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[jobDic valueForKey:@"JobID"]];
    urlString=[urlString stringByRemovingPercentEncoding];
    NSLog(@"PostString=%@",urlString);
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
    connEngineerDetails = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connEngineerDetails start];
}

#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
   
   
    [self showAlert:@"No network connection. Please try again later."  withTitle:@"Error"];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *data_Response = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Responseyyyyyyyyyyyyyyyyyyyyyy=%@",data_Response);
    
    NSMutableDictionary* temp;
    if (_responseData !=nil)
    {
        NSError *error;
        temp = [NSJSONSerialization JSONObjectWithData:_responseData  options:NSJSONReadingMutableContainers error:&error];
        if (!error)
        {
            
            if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
            {
                if (connection==connEngineerDetails)
                {
                    
                    dicTempServer=temp;
                    NSLog(@"dicTempServer :%@",temp);
                    
                    _txtEngineerName.text =[dicTempServer valueForKey:@"EngineerName"];
                    
                    _txtGassafeRegisterNo.text =[dicTempServer valueForKey:@"GasSafeRegisterNumber"];
                    _txtOperativeID.text =[dicTempServer valueForKey:@"OperativeID"];
                    
                    NSDictionary *userDetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
                    _txtDatesigned.text =[userDetails valueForKey:@""];
                    
                    if ([[dicTempServer valueForKey:@"SignaturePath"] isEqualToString:@""])
                    {
                        
                    }
                    else
                    {
                      
                        
                        strSignatureUrl = [GlobalDirector ReplaceStringNull:[[dicTempServer valueForKey:@"SignaturePath"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
                      
                    }
                    
                }
            }
            else
            {
                NSLog(@"JSONObjectWithData error: %@", error);
                if (connection==connEngineerDetails)
                {
                }
            }
        }
    }
    else
    {
        return;
    }
}

#pragma mark - Download Image Asynchronous Method
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                                   NSLog(@"%@",error.description);
                                   
                               }
                           }];
}



#pragma mark - viewWillAppear Method
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
#pragma mark - viewDidAppear Method
-(void)viewDidAppear:(BOOL)animated
{
    
}

#pragma mark - viewDidLoad Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_lbl1.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_lbl1.layer setBorderWidth: 1.0];
    [_lbl1.layer setCornerRadius:4.0f];
    [_lbl1.layer setMasksToBounds:YES];
    
    [_lbl2.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_lbl2.layer setBorderWidth: 1.0];
    [_lbl2.layer setCornerRadius:4.0f];
    [_lbl2.layer setMasksToBounds:YES];
    
    [_lbl3.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_lbl3.layer setBorderWidth: 1.0];
    [_lbl3.layer setCornerRadius:4.0f];
    [_lbl3.layer setMasksToBounds:YES];
    
    [_txtDatesigned.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_txtDatesigned.layer setBorderWidth: 1.0];
    [_txtDatesigned.layer setCornerRadius:4.0f];
    [_txtDatesigned.layer setMasksToBounds:YES];
    
    [_btnsubmit.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_btnsubmit.layer setBorderWidth: 1.0];
    [_btnsubmit.layer setCornerRadius:4.0f];
    [_btnsubmit.layer setMasksToBounds:YES];
    
    _dicSignOffDetails=[[NSMutableDictionary alloc]init];
    
    [self getEngineerDetails];
    
    XX=30,YY=330;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Back Press Method
- (IBAction)btnbacktapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Submit Press Method
- (IBAction)btnSubmitapped:(id)sender
{
    
    NSLog(@"OperativeId :%@",_txtOperativeID.text);
    NSLog(@"GasSafeRegNo :%@",_txtGassafeRegisterNo.text);
    
    
    if (_imgVEnggSign.image==nil) {
        
        [self showAlert:@"Signature is empty" withTitle:@"Error"];
        return;
    }
    
    
    [_dicSignOffDetails setValue:_txtEngineerName.text forKey:@"EnggName"];
    [_dicSignOffDetails setValue:_txtDatesigned.text forKey:@"Date Signed"];
    [_dicSignOffDetails setValue:_txtGassafeRegisterNo.text forKey:@"GasSafeRegNo"];
    [_dicSignOffDetails setValue:_txtOperativeID.text forKey:@"OperativeId"];
    
    [_dicSignOffDetails setValue:@"" forKey:@"GCRLicenceNo"];
    [_dicSignOffDetails setValue:[dicTempServer valueForKey:@"Title"] forKey:@"TradingTitle"];
    
    
     [_dicSignOffDetails setValue:[dicTempServer valueForKey:@"Postcode"] forKey:@"PostCode"];
     [_dicSignOffDetails setValue:@"" forKey:@"TelePhoneNo"];
     [_dicSignOffDetails setValue:[dicTempServer valueForKey:@"MobileNumber"] forKey:@"MobileNo"];
    
    [_dicSignOffDetails setValue:[dicTempServer valueForKey:@"AddressLine1"] forKey:@"AddressLine1"];
    [_dicSignOffDetails setValue:[dicTempServer valueForKey:@"AddressLine2"] forKey:@"AddressLine2"];
    [_dicSignOffDetails setValue:[dicTempServer valueForKey:@"AddressLine3"] forKey:@"AddressLine3"];
    
    
     NSData *imageData = UIImageJPEGRepresentation(_imgVEnggSign.image, 1.0);
     NSString *  base64String = [imageData base64EncodedStringWithOptions:0];
    NSString * encodedImageString = [base64String stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [_dicSignOffDetails setValue:encodedImageString forKey:@"EnggSign"];
    [_dicSignOffDetails setObject:@"jpg" forKey:@"imageextension"];
    
    
    if([self.delegate respondsToSelector:@selector(EnggSignOffDetailsValue:)]) {
        [self.delegate EnggSignOffDetailsValue:_dicSignOffDetails];
    }
    
      [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}



#pragma mark - Engineer Signature Tapped Method


- (IBAction)btnenggSignTapped:(id)sender
{
  
    
    if ([strSignatureUrl isEqualToString:@""])
    {
       // imgCheckSignature=NO;
        _imgVEnggSign.image=nil;
        [self preparingAutographPad];
    }
    else
    {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Re-Use previous signature ?"
                                                                            message:@""
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *NewSign = [UIAlertAction actionWithTitle: @"No, Take New One"
                                                          style: UIAlertActionStyleDefault
                                                        handler: ^(UIAlertAction *action) {
                                                            NSLog(@"Dismiss button tapped!");
                                                          //  imgCheckSignature=NO;
                                                            _imgVEnggSign.image=nil;
                                                            [self preparingAutographPad];
                                                            
                                                        }];
        UIAlertAction *ExistSign = [UIAlertAction actionWithTitle: @"OK , Use It"
                                                            style: UIAlertActionStyleDefault
                                                          handler: ^(UIAlertAction *action) {
                                                              NSLog(@"Dismiss button tapped!");
                                                              MBProgressHUD *hudtoShow= [MBProgressHUD showHUDAddedTo:_imgVEnggSign animated:YES];
                                                              hudtoShow.labelText=@"Getting Signature ...";
                                                              hudtoShow.labelFont=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
                                                              
                                                              [self downloadImageWithURL:[NSURL URLWithString:strSignatureUrl]completionBlock:^(BOOL succeeded, UIImage *image) {
                                                                  [MBProgressHUD hideAllHUDsForView:_imgVEnggSign animated:YES];
                                                                  if (succeeded) {
                                                                      _imgVEnggSign.image=image;
                                                                      
                                                                      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                                      [formatter setDateFormat:@"dd/MM/yyyy"];
                                                                      [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
                                                                      [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                                                                      _txtDatesigned.text = [formatter stringFromDate:[NSDate date]];
                                                                     
                                                                      
                                                                  }
                                                              }];
                                                              
                                                              
                                                          }];
        
        
        [controller addAction: NewSign];
        [controller addAction: ExistSign];
        [self presentViewController: controller animated: YES completion: nil];
    }
    
}



#pragma mark- Prepare Digital Signature Method
-(void)preparingAutographPad
{
    bgVw =[[UIControl alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    bgVw.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.8f];
    
    scratchableView = [[PJRSignatureView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth(bgVw.frame),300)];
    scratchableView.tag=1001;
   // scratchableView.delegate=self;
   // [scratchableView setMaskingFrame:CGRectMake(0, 0, CGRectGetWidth(bgVw.frame), 300) :@"whitey.png"];
    scratchableView.center=CGPointMake(CGRectGetWidth(bgVw.frame)/2.0f, CGRectGetHeight(bgVw.frame)/2.0f);
    [bgVw addSubview:scratchableView];
    
    UIImageView *bkIMG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blacky.png"]];
    bkIMG.tag=1002;
    [bkIMG setFrame:CGRectMake(30, 330, CGRectGetWidth(bgVw.frame), 300)];
    bkIMG.tag=5;
    bkIMG.center=CGPointMake(CGRectGetWidth(bgVw.frame)/2.0f, CGRectGetHeight(bgVw.frame)/2.0f);
    [bgVw addSubview:bkIMG];
    [bgVw bringSubviewToFront:scratchableView];
    
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.frame = CGRectMake(0,0,100,40);
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone setBackgroundColor:[UIColor colorWithRed:120/255.0 green:171/255.0 blue:30/255.0 alpha:1.0]];
    [btnDone addTarget:self action:@selector(DoneSignature:) forControlEvents:UIControlEventTouchUpInside];
    btnDone.center=CGPointMake(CGRectGetMaxX(scratchableView.frame)-CGRectGetWidth(btnDone.frame)/2.0f-10, CGRectGetMaxY(scratchableView.frame)+CGRectGetHeight(btnDone.frame)/2.0f+5);
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(0,0,100,40);
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCancel.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCancel setBackgroundColor:[UIColor colorWithRed:214/255.0 green:100/255.0 blue:4/255.0 alpha:1.0]];
    [btnCancel addTarget:self action:@selector(cleanPress:) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.center=CGPointMake(CGRectGetMinX(scratchableView.frame)+CGRectGetWidth(btnDone.frame)/2.0f+10, CGRectGetMaxY(scratchableView.frame)+CGRectGetHeight(btnCancel.frame)/2.0f+5);
    
    
    [bgVw addSubview:btnDone];
    [bgVw addSubview:btnCancel];
    [self.view addSubview:bgVw];
}


-(void)DoneSignature:(id)sender
{
   
   
    _imgVEnggSign.image = [scratchableView getSignatureImage];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    _txtDatesigned.text = [formatter stringFromDate:[NSDate date]];

    
    [bgVw removeFromSuperview];
    
}


-(void)cleanPress:(id)sender
{
    [bgVw removeFromSuperview];
}


- (UIImage*)captureView:(UIView *)view
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}


#pragma mark - PopUp Touch Press Method
-(IBAction)bgPopupTouched:(id)sender
{
    for (UIView *vw in [bgVw subviews])
    {
        [vw removeFromSuperview];
    }
    [bgVw removeFromSuperview];
}


#pragma mark - TextField Delegate Method


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    PeVscrollPoint=_scrollView.contentOffset;
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y-150);
    [_scrollView setContentOffset:scrollPoint animated:YES];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
   [_scrollView setContentOffset:PeVscrollPoint animated:YES];
    
    [textField resignFirstResponder];
    
   
    return YES;
}


@end
