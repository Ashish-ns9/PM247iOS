//
//  GasForms.m
//  Partner Maintenance
//


#import "GasForms.h"
#import "AppDelegate.h"
@class AppDelegate;
@interface GasForms ()
{
    AppDelegate *app;
}
@end
@implementation GasForms
@synthesize isJobDetailsPageRedirect,isAcceptPageRedirect;
#pragma mark- viewDidLoad Mtehod
- (void)viewDidLoad
{
    [super viewDidLoad];
    app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    app.arrApplianceInspection = [[NSArray alloc] init];
    imgCheckSignature=NO;
    if (isJobDetailsPageRedirect==YES)
    {
        //_btnnAddGasForms.hidden=YES;
    }
    arrMGasCertList=[[NSMutableArray alloc] init];
    _tabGasForms.backgroundView=nil;
    _tabGasForms.backgroundColor=[UIColor clearColor];
    _tabGasForms.separatorColor=[UIColor clearColor];
    //-----------  Gas Certificate Button -----------------------
    [_btnGasSafetyNatGas.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_btnGasSafetyNatGas.layer setBorderWidth: 0.5];
    [_btnGasSafetyNatGas.layer setCornerRadius:0.0f];
    [_btnGasSafetyNatGas.layer setMasksToBounds:YES];
    
    [_btnGasBreakdown.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_btnGasBreakdown.layer setBorderWidth: 0.5];
    [_btnGasBreakdown.layer setCornerRadius:0.0f];
    [_btnGasBreakdown.layer setMasksToBounds:YES];
    
    [_btnServiceMaintenance.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_btnServiceMaintenance.layer setBorderWidth: 0.5];
    [_btnServiceMaintenance.layer setCornerRadius:0.0f];
    [_btnServiceMaintenance.layer setMasksToBounds:YES];
    
    [_btnGasWarningNotice.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_btnGasWarningNotice.layer setBorderWidth: 0.5];
    [_btnGasWarningNotice.layer setCornerRadius:0.0f];
    [_btnGasWarningNotice.layer setMasksToBounds:YES];
    
    [_btnGasBoilerComm.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_btnGasBoilerComm.layer setBorderWidth: 0.5];
    [_btnGasBoilerComm.layer setCornerRadius:0.0f];
    [_btnGasBoilerComm.layer setMasksToBounds:YES];
    //-------------------------------------------------------------
    
    
    //Adding scroll view
    _scrollGasForm.frame = _tabGasForms.frame;
    [self.view addSubview:_scrollGasForm];
    _tabGasForms.hidden=NO;
    _scrollGasForm.hidden=YES;
     [self getGasList];
}

#pragma mark- viewDidAppear Mtehod
-(void)viewDidAppear:(BOOL)animated
{
    if (isGasCertCreated==YES)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
    {
        _btnnAddGasForms.hidden=YES;
    }else{
        _btnnAddGasForms.hidden=NO;
    }
}

#pragma mark- BackbtnTapped Mtehod
- (IBAction)backbtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- CertificateGenerated Mtehod
-(void)CertificateGenerated:(BOOL)status
{
    if (status==YES)
    {
        if([self.delegate respondsToSelector:@selector(GasFormCreated:)])
        {
            [self.delegate GasFormCreated:YES];
        }
        isGasCertCreated=YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Prepare Digital Signature Method
-(void)preparingAutographPad
{
    bgVw =[[UIControl alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    bgVw.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.8f];
    
    scratchableView = [[PJRSignatureView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth(bgVw.frame),300)];
    scratchableView.tag=1001;
    scratchableView.delegate=self;
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
   /* CGRect rect = scratchableView.frame;
    rect.size.width=rect.size.width-2;
    rect.origin.x=rect.origin.x+2;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([[self captureView:bgVw] CGImage], rect);
    UIImage *img ;
    img = [UIImage imageWithCGImage:imageRef];*/
   // NSLog(@"img :%@",img);
    ImgSignCustm.image= [scratchableView getSignatureImage];
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


#pragma mark- Customer SIGNATURE View Method
-(void)viewPopUpCustomerSignature
{
    ImgSignCustm.image=nil;
    viewCustomer1stAgreement.frame = CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height-64);
    
    [viewCustomer1stAgreement.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [viewCustomer1stAgreement.layer setBorderWidth: 0.0];
    [viewCustomer1stAgreement.layer setCornerRadius:4.0f];
    [viewCustomer1stAgreement.layer setMasksToBounds:YES];
    viewCustomer1stAgreement.backgroundColor =[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1.0];
    
 
    
    
    
    ImgSignCustm.backgroundColor=[UIColor whiteColor];
    ImgSignCustm.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signTapped:)];
    [singleTap setNumberOfTapsRequired:1];
    [ImgSignCustm addGestureRecognizer:singleTap];
    

    
    [self.view addSubview:viewCustomer1stAgreement];
    
    
}



-(void)signTapped:(UIGestureRecognizer *)recognizer
{
    DLog(@"image click");

    if ([strGasListSignatureUrl isEqualToString:@""])
    {
        imgCheckSignature=NO;
        ImgSignCustm.image=nil;
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
                                                            imgCheckSignature=NO;
                                                            ImgSignCustm.image=nil;
                                                            [self preparingAutographPad];
                                                            
                                                        }];
        UIAlertAction *ExistSign = [UIAlertAction actionWithTitle: @"OK , Use It"
                                                            style: UIAlertActionStyleDefault
                                                          handler: ^(UIAlertAction *action) {
                                                              NSLog(@"Dismiss button tapped!");
                                                              MBProgressHUD *hudtoShow= [MBProgressHUD showHUDAddedTo:ImgSignCustm animated:YES];
                                                              hudtoShow.labelText=@"Getting Signature ...";
                                                              hudtoShow.labelFont=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
                                                              
                                                             // [self GetCustomerPreviousSignatureLink];
                                                              
                                                              signURL= strGasListSignatureUrl;
                                                              
                                                              signURL=[signURL stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
                                                              DLog(@"%@",signURL);
                                                              [self downloadImageWithURL:[NSURL URLWithString:signURL]completionBlock:^(BOOL succeeded, UIImage *image) {
                                                                  [MBProgressHUD hideAllHUDsForView:ImgSignCustm animated:YES];
                                                                  if (succeeded) {
                                                                      ImgSignCustm.image=image;
                                                                      imgCheckSignature=YES;
                                                                      
                                                                  }
                                                              }];
                                                              
                                                              
                                                          }];
        
        
        [controller addAction: NewSign];
        [controller addAction: ExistSign];
        [self presentViewController: controller animated: YES completion: nil];
    }
    
}



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
                                   DLog(@"%@",error.description);
                                   
                               }
                           }];
}

#pragma mark- AcceptPress && DeclinePress && AcceptPressPaperwork Method
-(IBAction)acceptPress:(UIButton *)sender
{
    if(ImgSignCustm.image==nil)
    {
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @""
                                                                            message:@"Please do your signature first."
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                NSLog(@"Dismiss button tapped!");
                                                            }];
        
        [controller addAction: alertAction];
        [self presentViewController: controller animated: YES completion: nil];
    }
    else
    {
        NSData *imageData=[[NSMutableData alloc]init];
        imageData=(NSMutableData*)UIImagePNGRepresentation(ImgSignCustm.image);
        DLog(@"imageData :%@",imageData);
        _imgSign=ImgSignCustm.image;
        
        imgCheckSignature=NO;
        [viewCustomer1stAgreement removeFromSuperview];
        
    }
}

-(IBAction)declinePress:(UIButton *)sender
{
    [viewCustomer1stAgreement removeFromSuperview];
    
    _btnnAddGasForms.selected=NO;
    _scrollGasForm.alpha=1.0f;
    [UIView animateWithDuration:0.2 animations:^{
        _scrollGasForm.alpha=0.0f;
        _scrollGasForm.hidden=YES;
        _tabGasForms.hidden=NO;
        [_btnnAddGasForms setTransform:CGAffineTransformRotate(_btnnAddGasForms.transform, M_PI_2/2)];
    }];
    
}

-(IBAction)acceptPressPaperwork:(UIButton *)sender
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @""
                                                                        message:@"Do you accept this agreement via paperwork ?"
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *Yes = [UIAlertAction actionWithTitle: @"YES"
                                                  style: UIAlertActionStyleDefault
                                                handler: ^(UIAlertAction *action) {
                                                    
                                                    ImgSignCustm.image=[UIImage imageNamed:@"SignViaPaperwork"];
                                                    imgCheckSignature=YES;
                                                }];
    
    UIAlertAction *No = [UIAlertAction actionWithTitle: @"NO"
                                                 style: UIAlertActionStyleDefault
                                               handler: ^(UIAlertAction *action) {
                                                   NSLog(@"Dismiss button tapped!");
                                               }];
    
    
    [controller addAction: Yes];
    [controller addAction: No];
    
    [self presentViewController: controller animated: YES completion: nil];
}



-(void)MaskinViewController:(PJRSignatureView *)viewController IsSignatureDone:(BOOL)value{
    imgCheckSignature=value;
}
//----------------------------

#pragma mark- GasSafetyNatGasTapped Mtehod
- (IBAction)btnGasSafetyNatGasTapped:(id)sender
{
    strbtnGasSafetyNatGas=@"0001";
    
    NSLog(@"_jobDic :%@",_jobDic);
    NSLog(@"v :%@",_imgSign);
    
    GasSafetyNatGas *obj = [[GasSafetyNatGas alloc] initWithNibName:@"GasSafetyNatGas" bundle:Nil];
    obj.jobDic=_jobDic;
    obj.imgSignRef=_imgSign;
    obj.delegate=self;
    [self presentViewController:obj animated:YES completion:nil];
  
    
}


#pragma mark- GasBreakdownTapped Mtehod
- (IBAction)btnGasBreakdownTapped:(id)sender {
    
    
    strbtnGasBreakdown=@"0002";
    
    NSLog(@"_jobDic :%@",_jobDic);
    NSLog(@"v :%@",_imgSign);
    
    ServicingRecord *obj =[[ServicingRecord alloc] initWithNibName:@"ServicingRecord" bundle:Nil];
    obj.jobDic=_jobDic;
    obj.imgSignRef=_imgSign;
    [self presentViewController:obj animated:YES completion:nil];
   
}

#pragma mark- ServiceMaintenanceTapped Mtehod
- (IBAction)btnServiceMaintenanceTapped:(id)sender
{
    
    strbtnServiceMaintenance=@"0003";
    
    
    NSLog(@"_jobDic :%@",_jobDic);
    NSLog(@"v :%@",_imgSign);
    
    MaintainanceCheklist *obj = [[MaintainanceCheklist alloc] initWithNibName:@"MaintainanceCheklist" bundle:Nil];
    obj.jobDic=_jobDic;
    obj.imgSignRef=_imgSign;
    [self presentViewController:obj animated:YES completion:nil];
    
}

#pragma mark- GasWarningNoticeTapped Mtehod
- (IBAction)btnGasWarningNoticeTapped:(id)sender
{
    strbtnGasWarningNotice=@"0004";
    
 
    NSLog(@"_jobDic :%@",_jobDic);
    NSLog(@"v :%@",_imgSign);
    
    WarningNotice *obj=[[WarningNotice alloc] initWithNibName:@"WarningNotice" bundle:Nil];
      
        
        obj.jobDic=_jobDic;
        obj.imgSignRef=_imgSign;
        [self presentViewController:obj animated:YES completion:nil];
  
}


#pragma mark- GasBoilerCommtapped Mtehod
- (IBAction)btnGasBoilerCommtapped:(id)sender
{
    
    strbtnGasBoilerComm=@"0005";
    
    BoilerCommissioning *obj=[[BoilerCommissioning alloc] initWithNibName:@"BoilerCommissioning" bundle:Nil];
    obj.jobDic=_jobDic;
    obj.imgSignRef=_imgSign;
    [self presentViewController:obj animated:YES completion:nil];
    
}





#pragma mark- GasForms Mtehod
- (IBAction)btnAddGasForms:(UIButton *)sender {
    
    if (sender.selected==YES)
    {
        sender.selected=NO;
        if (viewCustomer1stAgreement!=nil)
        {
            [viewCustomer1stAgreement removeFromSuperview];
             [self getGasList];
        }
        
        _scrollGasForm.alpha=1.0f;
        [UIView animateWithDuration:0.2 animations:^{
            _scrollGasForm.alpha=0.0f;
            _scrollGasForm.hidden=YES;
            _tabGasForms.hidden=NO;
            [sender setTransform:CGAffineTransformRotate(sender.transform, M_PI_2/2)];
        }];
    }
    else
    {
        sender.selected=YES;
        _scrollGasForm.hidden=NO;
        _tabGasForms.hidden=YES;
        _scrollGasForm.alpha=0.0f;
        [UIView animateWithDuration:0.2 animations:^{
        [sender setTransform:CGAffineTransformRotate(sender.transform, -M_PI_2/2)];
        _scrollGasForm.alpha=1.0f;
        }];
        
        if (isJobDetailsPageRedirect==YES)
        {
            [self viewPopUpCustomerSignature];
        }
    }
}



#pragma mark- Gas List Fetch Method
-(void)getGasList
{
    NSLog(@"_JobDic :%@",[_jobDic valueForKey:@"JobID"]);
    strIdentifier=@"1";
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString=[NSString stringWithFormat:@"%sGetGasCertificateList?usertoken=%@&jobId=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[_jobDic valueForKey:@"JobID"]];
    urlString=[urlString stringByRemovingPercentEncoding];
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
    connGaslist = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connGaslist start];
    
    
}



-(void)GetCustomerPreviousSignatureLink
{
    NSLog(@"_JobDic :%@",[_jobDic valueForKey:@"JobID"]);
    
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString=[NSString stringWithFormat:@"%sGetInvoice?userToken=%@&jobId=%@",conn_url, (NSString *)[userdetails valueForKey:@"UserToken"],(NSString *)[_jobDic valueForKey:@"JobID"]];
    urlString=[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
    connGetInvoiceLink = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connGetInvoiceLink start];
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
   
   // [[[UIAlertView alloc]initWithTitle:@"Error" message:@"No network connection. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
    
     [self showAlert:@"No network connection. Please try again later."  withTitle:@"Error"];// sabnam
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
     [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    NSString *data_Response = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Responseyyyyyyyyyyyyyyyyyyyyyy=%@",data_Response);
    
    NSMutableDictionary* temp;
    if (_responseData !=nil)
    {
        NSError *error;
        temp = [NSJSONSerialization JSONObjectWithData:_responseData  options:NSJSONReadingMutableContainers error:&error];
        if (!error)
        {
            NSLog(@"temp :%@",temp);
            if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
            {
                if (connection==connGaslist)
                {
                    NSLog(@"GasCertificateList link  :%@",[temp valueForKey:@"GasCertificateList"]);
                    strGasListSignatureUrl=[NSString stringWithFormat:@"%@",[temp valueForKey:@"SignatureUrl"]];
                    
                    if ([[temp valueForKey:@"GasCertificateList"] isEqual:[NSNull null]])
                    {
                        // [[[UIAlertView alloc]initWithTitle:@"" message:@"There have no gas certificate." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
                        
                        [self showAlert:@"There have no gas certificate."  withTitle:@""];//sabnam
                    }
                    else
                    {
                        arrMGasCertList=[temp valueForKey:@"GasCertificateList"];
                        NSLog(@"Array :%@",arrMGasCertList);
                        [_tabGasForms reloadData];
                    }
                }
                else if (connection==connGetInvoiceLink)
                {
                    signURL= [temp valueForKey:@"SignatureUrl"]!=[NSNull null]?[temp valueForKey:@"SignatureUrl"]:@"";
                    
                    signURL=[signURL stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
                    DLog(@"%@",signURL);
                    [self downloadImageWithURL:[NSURL URLWithString:signURL]completionBlock:^(BOOL succeeded, UIImage *image) {
                        [MBProgressHUD hideAllHUDsForView:ImgSignCustm animated:YES];
                        if (succeeded) {
                            ImgSignCustm.image=image;
                            imgCheckSignature=YES;
                            
                        }
                    }];
                }
                else if (connection==conndropboxipload)
                {
                  //  [[[UIAlertView alloc]initWithTitle:@"" message:@"Dropbox upload successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
                     [self showAlert:@"Dropbox upload successfully."  withTitle:@""];//sabnam
                }
                else if (connection==connEmailGas)
                {
                   // [[[UIAlertView alloc]initWithTitle:@"" message:@"Email sent successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
                     [self showAlert:@"Email sent successfully."  withTitle:@""];
                }
            }
            else
            {
                if (connection==conndropboxipload || connection==connEmailGas)
                {
                   [self showAlert:[GlobalDirector ReplaceStringNull:[temp valueForKey:@"ResponseMessages"]] withTitle:@"Error" ];
                }
                
                
                DLog(@"JSONObjectWithData error: %@", error);
                if (connection==connGaslist)
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




#pragma mark- Tableview Delegates/DataSource Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrMGasCertList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 106.0;
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"GasFormcell";
    GasFormcell  *cell=(GasFormcell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // tableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tab_page.png"]];
    if(cell==nil)
    {
        cell =(GasFormcell*)[BaseTableCell cellFromNibNamed:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    
    
    NSDictionary *dic=[arrMGasCertList objectAtIndex:indexPath.row];
    
    
    
    cell.type.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"CertificateType"]];
    cell.date.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"Date"]];
    cell.serial.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"UniqueSerialNumber"]];
    
    [cell.btnInvoice addTarget:self action:@selector(openGasForm:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnInvoice.tag=indexPath.row;
    
    return cell;
}






- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



-(void)openGasForm:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    NSLog(@"tag: %ld",(long)btn.tag);
    
    NSDictionary *dic=[arrMGasCertList objectAtIndex:btn.tag];
    
    NSString *cert = [GlobalDirector ReplaceStringNull:[dic valueForKey:@"CertificateFilePath"]];
    
    if (cert.length>0) {
        [self zoomPdfView:[NSString stringWithFormat:@"%@",[dic valueForKey:@"CertificateFilePath"]] strgascerttype:[NSString stringWithFormat:@"%@",[dic valueForKey:@"CertificateType"]]indexint:btn.tag];
    }
    
   
}


#pragma mark  - Zoom Pdf View Agreement Method
-(void)zoomPdfView:(NSString *)strLink strgascerttype:(NSString *)strType indexint:(NSInteger)indexInt
{
    CGFloat currX=0.0f;
    
    mainBgNoteDesc = [[UIView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen]bounds].size.width,self.view.frame.size.height)];
    mainBgNoteDesc.backgroundColor =[UIColor clearColor];
    
    bgVwNoteDesc = [[UIScrollView alloc] initWithFrame:CGRectMake(2,67,[[UIScreen mainScreen]bounds].size.width-5,CGRectGetHeight(self.view.frame)-50)];
    bgVwNoteDesc.pagingEnabled=YES;
    bgVwNoteDesc.bounces=NO;
    bgVwNoteDesc.delegate=self;
    bgVwNoteDesc.showsHorizontalScrollIndicator=NO;
    [bgVwNoteDesc.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [bgVwNoteDesc.layer setBorderWidth: 0.5];
    [bgVwNoteDesc.layer setCornerRadius:0.0f];
    [bgVwNoteDesc.layer setMasksToBounds:YES];
    bgVwNoteDesc.backgroundColor =[UIColor darkGrayColor];
    
    NSURL *url = [NSURL URLWithString:[strLink stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    DLog(@"url>>>>> %@",url);
    
    UIWebView*  webV=[[UIWebView alloc]initWithFrame:CGRectMake(currX, 30, CGRectGetWidth(bgVwNoteDesc.frame), CGRectGetHeight(bgVwNoteDesc.frame)-25)];
    webV.backgroundColor=[UIColor lightGrayColor];
    webV.delegate=self;
    [webV loadRequest:[NSURLRequest requestWithURL:url]];
    [webV setScalesPageToFit:YES];
    webV.backgroundColor=[UIColor lightGrayColor];
    webV.tag=0;
    [bgVwNoteDesc addSubview:webV];
    
    btnEmail=[UIButton buttonWithType:UIButtonTypeCustom];
    btnEmail.frame=CGRectMake(0, 0, 30, 30);
    btnEmail.tag=indexInt;
    btnEmail.center=CGPointMake(CGRectGetMinX(mainBgNoteDesc.frame)+currX+20,CGRectGetMinY(mainBgNoteDesc.frame)+15);
    [btnEmail setBackgroundImage:[UIImage imageNamed:@"emailagreecert"] forState:UIControlStateNormal];
    [btnEmail addTarget:self action:@selector(pressEmail:) forControlEvents:UIControlEventTouchUpInside];
    
 
    
    btnDropbox=[UIButton buttonWithType:UIButtonTypeCustom];
    btnDropbox.frame=CGRectMake(0, 0, 30, 30);
    btnDropbox.tag=indexInt;
    btnDropbox.center=CGPointMake(CGRectGetMaxX(btnEmail.frame)+30,CGRectGetMinY(mainBgNoteDesc.frame)+15);
    [btnDropbox setBackgroundImage:[UIImage imageNamed:@"dropbox"] forState:UIControlStateNormal];
    [btnDropbox addTarget:self action:@selector(pressdropbox:) forControlEvents:UIControlEventTouchUpInside];
   
    
    
    
   // [bgVwNoteDesc addSubview:btnPrint];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
         [bgVwNoteDesc addSubview:btnEmail];
        [bgVwNoteDesc addSubview:btnDropbox];
    }else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
       [bgVwNoteDesc addSubview:btnDropbox];
    }else{
       [bgVwNoteDesc addSubview:btnEmail];
    }
    
    
    
    NSMutableArray *arrItems=[[NSMutableArray alloc] initWithObjects:strType, nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:arrItems];
    segmentedControl.frame = CGRectMake(0,20, CGRectGetWidth(mainBgNoteDesc.frame), 45);
    segmentedControl.selectedSegmentIndex = 0;
    UIFont *font = [UIFont fontWithName:@"TheSansArabic-Bold" size:16.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    segmentedControl.tintColor=[UIColor colorWithRed:76/255.0 green:170/255.0 blue:39/255.0 alpha:1];
    segmentedControl.backgroundColor=[UIColor whiteColor];
    [mainBgNoteDesc addSubview:segmentedControl];

    
    btnCrossNoteDesc=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCrossNoteDesc.frame=CGRectMake(0, 0, 25, 25);
    btnCrossNoteDesc.center=CGPointMake(CGRectGetMaxX(bgVwNoteDesc.frame)-14,CGRectGetMinY(bgVwNoteDesc.frame)+15);
    [btnCrossNoteDesc setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
    [btnCrossNoteDesc addTarget:self action:@selector(cross:) forControlEvents:UIControlEventTouchUpInside];
    [btnCrossNoteDesc clipsToBounds];
    
    [mainBgNoteDesc addSubview:bgVwNoteDesc];
    [mainBgNoteDesc addSubview:btnCrossNoteDesc];
    
    [self.view addSubview:mainBgNoteDesc];

}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:webView animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:webView animated:YES];
}

-(void)cross:(UIButton *)sender
{
    [mainBgNoteDesc removeFromSuperview];
    mainBgNoteDesc=nil;
    //[sender.superview removeFromSuperview];
    //[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -  Print Email Method
-(void)pressPrint:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    DLog(@"tag:%ld",(long)btn.tag);
    
    NSDictionary *dic=[arrMGasCertList objectAtIndex:btn.tag];
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[dic valueForKey:@"CertificateFilePath"]]] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    DLog(@"url>>>>> %@",url);
    
    NSURL *requestURL = url;
    NSError *error;
    NSString *htmlStr = [NSString stringWithContentsOfURL:requestURL
                                                 encoding:NSASCIIStringEncoding
                                                    error:&error];
    NSLog(@"htmlStr :%@",htmlStr);
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.orientation=UIPrintInfoOrientationLandscape;
    printInfo.jobName = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[dic valueForKey:@"CertificateJobType"]]];
    pic.printInfo = printInfo;
    
    UIMarkupTextPrintFormatter* textFormatter = [[UIMarkupTextPrintFormatter alloc]initWithMarkupText:htmlStr];
    textFormatter.startPage = 0;
    textFormatter.contentInsets = UIEdgeInsetsMake(20.0, 0.0,72.0, 72.0);
    textFormatter.maximumContentWidth = 20 * 72.0;
    pic.printFormatter = textFormatter;
    pic.showsPageRange = YES;
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            NSLog(@"Printing error: %@", error);
        }
    };
    [pic presentFromBarButtonItem:self.navigationItem.leftBarButtonItem
                         animated:YES
                completionHandler:completionHandler];
}

#pragma mark - Email Post Method
-(void)pressEmail:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    DLog(@"tag:%ld",(long)btn.tag);
    
    NSDictionary *dic=[arrMGasCertList objectAtIndex:btn.tag];
    NSLog(@"dic :%@",dic);
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[dic valueForKey:@"CertificateFilePath"]] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    DLog(@"url>>>>> %@",url);
    
   
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *urlString;
    NSString *post =[NSString stringWithFormat:@""];
    urlString=[NSString stringWithFormat:@"%sSendGasSafetyMail?userToken=%@&jobId=%@&formType=%@&uniqueSerialNo=%@",conn_url, (NSString *)[userdetails valueForKey:@"UserToken"],[_jobDic valueForKey:@"JobID"],[dic valueForKey:@"CertificateType"],[dic valueForKey:@"UniqueSerialNumber"]];
    
    
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
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    connEmailGas = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connEmailGas start];
    
}



#pragma mark - Dropbox Post Method
-(void)pressdropbox:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    DLog(@"tag:%ld",(long)btn.tag);
    
    NSDictionary *dic=[arrMGasCertList objectAtIndex:btn.tag];
    NSLog(@"dic :%@",dic);
    NSLog(@"_JobDic :%@",[_jobDic valueForKey:@"JobID"]);
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[dic valueForKey:@"CertificateFilePath"]] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    DLog(@"url>>>>> %@",url);
    
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString;
    urlString=[NSString stringWithFormat:@"%sUploadFileToDropbox?userToken=%@&jobId=%@&fileUrl=%@&certificateTypeId=%@&uniqueNo=%@",conn_url, (NSString *)[userdetails valueForKey:@"UserToken"],[_jobDic valueForKey:@"JobID"],url,[dic valueForKey:@"CertificateTypeId"],[dic valueForKey:@"UniqueSerialNumber"]];
    NSLog(@"urlString :%@",urlString);
    urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setHTTPBody:postData];
    request.timeoutInterval = 300;
    DLog(@"PostString=%@",request);
     [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    conndropboxipload = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conndropboxipload start];
    
}




@end
