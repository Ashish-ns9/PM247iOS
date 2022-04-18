//
//  SignAgreement.m
//  Partner Maintenance
//


#import "SignAgreement.h"
AppDelegate *app;

@interface SignAgreement ()
{
    NSString *jobCompletetionNoteType;
    BOOL isBack;
    
}
@end

@implementation SignAgreement
@synthesize strHeading;
@synthesize frameWidth,frameHeight,XX,YY;

#pragma mark- Back Press Method
- (IBAction)backTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark- ViewLDidLoad Method
- (void)viewDidLoad
{
    
      DLog(@"viewDidLoad started ");
    [super viewDidLoad];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    UIToolbar* numberTool = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberTool.barStyle = UIBarStyleBlackTranslucent;
    numberTool.items = [NSArray arrayWithObjects:
                        [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(Cancel:)],
                        [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                        [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(Complete:)],
                        nil];
    [numberTool sizeToFit];
    _txtNoteDesComplete.inputAccessoryView = numberTool;
    isBack=NO;
    self.navigationController.navigationBar.hidden = YES;
    _lblHeading.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:18.0];
    app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    _lblHeading.text=strHeading;
    imgCheckSignature=NO;
    frameWidth=300.00;
    frameHeight=250.00;
    XX=30;
    YY=330;
    arrAgrLinks=[[NSMutableDictionary alloc]init];
    if ([strHeading isEqualToString:@"Agreement"])
    {
         DLog(@"inside agreement if ");
       
        
        if ([_JobDic valueForKey:@"CustomerAgreementLink"]&&[[_JobDic valueForKey:@"IsAgreementSign"]integerValue]>=1)
        {
            
              DLog(@"inside CustomerAgreementLink if ");
            [arrAgrLinks setObject:[_JobDic valueForKey:@"CustomerAgreementLink"] forKey:@"Small Repair Agreement"];
            
        }
        if ([_JobDic valueForKey:@"DetailsAgreementLink"]&&[[_JobDic valueForKey:@"IsAgreementSign"]integerValue]>1)
        {
             DLog(@"inside DetailsAgreementLink if ");
            [arrAgrLinks setObject:[_JobDic valueForKey:@"DetailsAgreementLink"] forKey:@"Fixed Price Agreement"];
        }
        
        [self zoomPdfView:arrAgrLinks];
         DLog(@" agreement if ended ");
    }
    else if ([strHeading isEqualToString:@"Invoice"])
    {
        
        
        if ([[GlobalDirector ReplaceStringNull:[_JobDic valueForKey:@"IsGasCertificateAvailable"]] intValue]==1) {
            IsGasFormSigned=YES;
        }
        if (self.isInvoice==YES)
        {
            arrAgrLinks=[[NSMutableDictionary alloc]init];
            if ([_JobDic valueForKey:@"InvoiceDetailsLink"]!=NULL)
            {
                [arrAgrLinks setObject:[_JobDic valueForKey:@"InvoiceDetailsLink"] forKey:@"Invoice"];
                
            }
            [self zoomPdfView:arrAgrLinks];
        }
        else
        {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self GetInvoiceLink];
        }
    }
    else
    {
        [self showPopUpAgreementPage:@"1"];
    }
    
     DLog(@"viewDidLoad Ended ");
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event //here enable the touch
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    if (CGRectContainsPoint(scratchableView.frame, touchLocation))
    {
        DLog(@" touched");
    }
}

-(void)GasFormCreated:(BOOL)status
{
    IsGasFormSigned=status;
}

#pragma mark- ViewWillAppear Method
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (isBack) {
        if (IsGasFormSigned==1)
        {
            [self CreateInvoiceDropDown];
        }
    }
    isBack=YES;
}


#pragma mark - view PopUp Customer 1st Agreement Method
-(void)viewPopUpCustomer1stAgreement
{
    scrlAgreements=[[UIScrollView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_imgvHeader.frame)+5,CGRectGetWidth([[UIScreen mainScreen]bounds]),[[UIScreen mainScreen]bounds].size.height-CGRectGetMaxY(_imgvHeader.frame))];
    CGFloat currX=5.0f;
    
    viewCustomer1stAgreement= [[UIView alloc] initWithFrame:CGRectMake(currX,0,CGRectGetWidth(_imgvHeader.frame)-10,scrlAgreements.frame.size.height)];
    [viewCustomer1stAgreement.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [viewCustomer1stAgreement.layer setBorderWidth: 0.0];
    [viewCustomer1stAgreement.layer setCornerRadius:4.0f];
    [viewCustomer1stAgreement.layer setMasksToBounds:YES];
    viewCustomer1stAgreement.backgroundColor =[UIColor clearColor];
    
    //--------------- Agreement WebView Frame Set Method ------------------------
    if ([strHeading isEqualToString:@"Invoice"])
    {
        UIWebView*  webV=[[UIWebView alloc]initWithFrame:CGRectMake(30,26,300,250)];
        
        webV.backgroundColor=[UIColor lightGrayColor];
        webV.delegate=self;
        //[webV stringByEvaluatingJavaScriptFromString:@"document.open();document.close()"];
        
        NSString *link=[arrAgrLinks valueForKey:@"Invoice"];
        NSURL *url= [NSURL URLWithString:[link stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];;
        [webV loadRequest:[NSURLRequest requestWithURL:url]];
        [webV setScalesPageToFit:YES];
        webV.backgroundColor=[UIColor lightGrayColor];
        webV.center=CGPointMake(CGRectGetWidth(viewCustomer1stAgreement.frame)/2.0f, webV.center.y);
        [viewCustomer1stAgreement addSubview:webV];
        
        
        UIButton *btnZoom = [UIButton buttonWithType:UIButtonTypeCustom];
        btnZoom.frame = CGRectMake(0,0,35,25);
        btnZoom.center=CGPointMake(CGRectGetMinX(webV.frame)+CGRectGetWidth(btnZoom.frame)/2.0f+4, CGRectGetMaxY(webV.frame)-CGRectGetWidth(btnZoom.frame)/2.0f-4);
        
        [btnZoom setTitle:@"Zoom" forState:UIControlStateNormal];
        btnZoom.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
        [btnZoom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnZoom.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.4];
        [btnZoom addTarget:self action:@selector(zoomPdfView:) forControlEvents:UIControlEventTouchUpInside];
        [viewCustomer1stAgreement addSubview:btnZoom];
        
    }
    else
    {
        UITextView *lbltitle1=[[UITextView alloc] initWithFrame:CGRectMake(10,30,CGRectGetWidth([[UIScreen mainScreen]bounds])-20,250)];
        lbltitle1.textAlignment=NSTextAlignmentCenter;
        lbltitle1.editable=NO;
        lbltitle1.backgroundColor=[UIColor lightGrayColor];
        
        if ([[_JobDic valueForKey:@"FixedPrice"]integerValue]>0)
        {
            
            
            //-------- String 1 ---------
            UIColor *color1 = [UIColor blackColor];
            UIFont *font1 = [UIFont fontWithName:@"TheSansArabic-Bold" size:14];
            NSString *string1 = @"\t\tFurther Work Fixed/Quoted Price Repair ";
            NSDictionary *attrs1 = @{ NSForegroundColorAttributeName : color1 };
            attrs1= [NSDictionary dictionaryWithObject:font1 forKey:NSFontAttributeName];
            NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString:string1 attributes:attrs1];
            
            //-------- String 2---------
            UIColor *color2 = [UIColor blackColor];
            UIFont *font2 = [UIFont fontWithName:@"TheSansArabic" size:13];
            NSString *string2 = [NSString stringWithFormat:@"\nFixed price repair. We will carry out the work as explained to you. This price is a fixed price %@ included VAT of  %@%% ",[_JobDic valueForKey:@"FixedPrice"],[_JobDic valueForKey:@"CurrentVat"]];
            NSDictionary *attrs2 = @{ NSForegroundColorAttributeName : color2 };
            attrs2= [NSDictionary dictionaryWithObject:font2 forKey:NSFontAttributeName];
            NSAttributedString *attrStr2 = [[NSAttributedString alloc] initWithString:string2 attributes:attrs2];
            //-------- String 3 ---------
            
            
            
            UIColor *color3 = [UIColor colorWithRed:196/255.0f green:46/255.0f blue:0/255.0f alpha:1];
            NSString *string3 = [NSString stringWithFormat:@"\nTotal= £%.2f",[[_JobDic valueForKey:@"FixedPrice"]floatValue]*(100+[[_JobDic valueForKey:@"CurrentVat"]floatValue])/100];
            NSDictionary *attrs3 = @{ NSForegroundColorAttributeName : color3 ,NSFontAttributeName:[UIFont fontWithName:@"TheSansArabic-Bold" size:14]};
            NSAttributedString *attrStr3 = [[NSAttributedString alloc] initWithString:string3 attributes:attrs3];
            //-------- String 4 ---------
            UIColor *color4 = [UIColor blackColor];
            NSString *string4 = @"\n\nThe price includes a 1 year  guarantee unless stated.";
            NSDictionary *attrs4 = @{ NSForegroundColorAttributeName : color4 };
            NSAttributedString *attrStr4 = [[NSAttributedString alloc] initWithString:string4 attributes:attrs4];
            
            //-------- String 5 ---------
            NSAttributedString *attrStr5=[[NSAttributedString alloc] initWithString:@"\n\n\tI confirm that I read the notice of the right to cancel contract and the terms and conditions which shall form part of the contract." attributes:attrs2];
            
            NSMutableAttributedString *hintText = [[NSMutableAttributedString alloc] init];
            [hintText appendAttributedString:attrStr1];
            [hintText appendAttributedString:attrStr2];
            [hintText appendAttributedString:attrStr3];
            [hintText appendAttributedString:attrStr4];
            [hintText appendAttributedString:attrStr5];
            
            lbltitle1.attributedText=hintText;
        }
        else
        {
            NSString *str= [GlobalDirector ReplaceStringNull:[_JobDic valueForKey:@"JobPrice"]];
            const char *cString = [str UTF8String];
            NSData *data = [NSData dataWithBytes:cString length:strlen(cString)];
            NSString *rate = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            //-------- String 1 ---------
            UIColor *color1 = [UIColor blackColor];
            UIFont *font1 = [UIFont fontWithName:@"TheSansArabic-Bold" size:15];
            NSString *string1 = @"\t\tDiagnostic Work & Small repair ";
            NSDictionary *attrs1 = @{ NSForegroundColorAttributeName : color1 };
            attrs1= [NSDictionary dictionaryWithObject:font1 forKey:NSFontAttributeName];
            NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString:string1 attributes:attrs1];
            
            //-------- String 2 ---------
            UIColor *color2 = [UIColor blackColor];
            UIFont *font2 = [UIFont fontWithName:@"TheSansArabic" size:14];
            NSString *string2 = @"\n\n  Diagnostic work or small repairs, we will explore the problem you tell us about and see if it can be quickly fixed. If not, we will then give you a detailed quote for any further repairs if extensive work is 	 needed. This work is charged at a rate Of ";
            NSDictionary *attrs2 = @{ NSForegroundColorAttributeName : color2 };
            attrs2= [NSDictionary dictionaryWithObject:font2 forKey:NSFontAttributeName];
            NSAttributedString *attrStr2 = [[NSAttributedString alloc] initWithString:string2 attributes:attrs2];
            
 
            //-------- String 3 ---------
            UIColor *color3 = [UIColor colorWithRed:196/255.0f green:46/255.0f blue:0/255.0f alpha:1];
            NSString *string3 = [NSString stringWithFormat:@" %@Plus VAT",rate];
            NSDictionary *attrs3 = @{ NSForegroundColorAttributeName : color3 };
            
            NSAttributedString *attrStr3 = [[NSAttributedString alloc] initWithString:string3 attributes:attrs3];
            
            //-------- String 4 ---------
            NSAttributedString *attrStr4=[[NSAttributedString alloc] initWithString:@"\n\n\t I confirm that I read the notice of the right to cancel contract and the terms and conditions which shall form part of the contract." attributes:attrs2];
            
            NSMutableAttributedString *hintText = [[NSMutableAttributedString alloc] init];
            [hintText appendAttributedString:attrStr1];
            [hintText appendAttributedString:attrStr2];
            [hintText appendAttributedString:attrStr3];
            [hintText appendAttributedString:attrStr4];
            lbltitle1.attributedText=hintText;
        }
        
        [lbltitle1.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
        [lbltitle1.layer setBorderWidth: 2.0];
        [lbltitle1.layer setCornerRadius:4.0f];
        [lbltitle1.layer setMasksToBounds:YES];
        lbltitle1.center=CGPointMake(CGRectGetWidth(viewCustomer1stAgreement.frame)/2.0f, lbltitle1.center.y);
        
        [viewCustomer1stAgreement addSubview:lbltitle1];
    }
    //---------------------------------------------------------------------------
    
    //------------- Customer signature show ------------------------
    UILabel *lbltitle2=[[UILabel alloc] initWithFrame:CGRectMake(10,290,CGRectGetWidth([[UIScreen mainScreen]bounds])-20,30)];
    lbltitle2.textAlignment=NSTextAlignmentCenter;
    lbltitle2.textColor=[UIColor blackColor];
    lbltitle2.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:14.0];
    lbltitle2.backgroundColor=[UIColor lightGrayColor];
    lbltitle2.text=[NSString stringWithFormat:@"%@",@"Customer Signature"];
    [lbltitle2.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [lbltitle2.layer setBorderWidth: 1.0];
    [lbltitle2.layer setCornerRadius:4.0f];
    [lbltitle2.layer setMasksToBounds:YES];
    lbltitle2.center=CGPointMake(CGRectGetWidth(viewCustomer1stAgreement.frame)/2.0f, lbltitle2.center.y);
    [viewCustomer1stAgreement addSubview:lbltitle2];
    
    
    
    ImgSign=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(lbltitle2.frame), 150)];
    ImgSign.center=CGPointMake(lbltitle2.center.x, CGRectGetMaxY(lbltitle2.frame)+CGRectGetHeight(ImgSign.frame)/2.0f+10);
    ImgSign.backgroundColor=[UIColor whiteColor];
    ImgSign.userInteractionEnabled=YES;
    
    
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signTapped:)];
        [singleTap setNumberOfTapsRequired:1];
        [ImgSign addGestureRecognizer:singleTap];
        
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"]&&[_lblHeading.text isEqualToString:@"Invoice"])
    {
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signTapped:)];
        [singleTap setNumberOfTapsRequired:1];
        [ImgSign addGestureRecognizer:singleTap];
    }
    else
    {
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ProceedWithPaperWork)];
        [singleTap setNumberOfTapsRequired:1];
        [ImgSign addGestureRecognizer:singleTap];
        
    }
    
    [viewCustomer1stAgreement addSubview:ImgSign];
    
    
    
    //---------- Clean -----------------------
    UIButton *btnClean = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClean.frame = CGRectMake(CGRectGetMaxX(ImgSign.frame)-30,484,28,28);
    [btnClean setBackgroundImage:[UIImage imageNamed:@"ClearSignature"] forState:UIControlStateNormal];
    [btnClean addTarget:self action:@selector(cleanPress:) forControlEvents:UIControlEventTouchUpInside];
    btnClean.tag=90;
    [viewCustomer1stAgreement addSubview:btnClean];
    
    //--------------  Accept ---------------
    UIButton *btnAccept = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAccept.frame = CGRectMake(10,520,80,27);
    [btnAccept setTitle:@"Accept" forState:UIControlStateNormal];
    [btnAccept setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnAccept.titleLabel.font=[UIFont boldSystemFontOfSize:13.0];
    
    if ([strHeading isEqualToString:@"Invoice"])
    {
        [btnAccept addTarget:self action:@selector(SelectInvoiceNumberPopUp:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [btnAccept addTarget:self action:@selector(acceptPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    btnAccept.tag=191;
    
    [btnAccept.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [btnAccept.layer setBorderWidth: 0.0];
    [btnAccept.layer setCornerRadius:0.5f];
    btnAccept.backgroundColor=[UIColor colorWithRed:137/255.0 green:182/255.0 blue:40/255.0 alpha:1.0];
    
    [viewCustomer1stAgreement addSubview:btnAccept];
    
    //----------   Decline  -------------------
    UIButton *btnDecline = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDecline.frame = CGRectMake(CGRectGetWidth(viewCustomer1stAgreement.frame)-90,520,80,27);
    [btnDecline setTitle:@"Decline" forState:UIControlStateNormal];
    [btnDecline setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDecline.titleLabel.font=[UIFont boldSystemFontOfSize:13.0];
    [btnDecline addTarget:self action:@selector(declinePress:) forControlEvents:UIControlEventTouchUpInside];
    btnDecline.tag=190;
    
    [btnDecline.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [btnDecline.layer setBorderWidth: 0.0];
    [btnDecline.layer setCornerRadius:0.5f];
    btnDecline.backgroundColor=[UIColor colorWithRed:214/255.0 green:100/255.0 blue:4/255.0 alpha:1.0];
    
    [viewCustomer1stAgreement addSubview:btnDecline];
    
    //----------   Sign via Paper  -------------------
    UIButton *btnSignViaPaper = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSignViaPaper.frame = CGRectMake(10,CGRectGetMaxY(btnAccept.frame)+5,CGRectGetWidth(viewCustomer1stAgreement.frame)-20,50);
    [btnSignViaPaper setTitle:@"Customer Signature Via Paperwork" forState:UIControlStateNormal];
    [btnSignViaPaper setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSignViaPaper.titleLabel.font=[UIFont boldSystemFontOfSize:13.0];
    
    if ([strHeading isEqualToString:@"Invoice"])
    {
        [btnSignViaPaper addTarget:self action:@selector(SelectInvoiceNumberPopUp:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [btnSignViaPaper addTarget:self action:@selector(acceptPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    btnSignViaPaper.tag=212;
    
    [btnSignViaPaper.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [btnSignViaPaper.layer setBorderWidth: 0.0];
    [btnSignViaPaper.layer setCornerRadius:0.5f];
    btnSignViaPaper.backgroundColor=[UIColor colorWithRed:137/255.0 green:182/255.0 blue:40/255.0 alpha:1.0];
    
    [viewCustomer1stAgreement addSubview:btnSignViaPaper];
    
    [scrlAgreements addSubview:viewCustomer1stAgreement];
    currX=CGRectGetWidth(viewCustomer1stAgreement.frame)+currX;
    
    scrlAgreements.contentSize=CGSizeMake(currX, CGRectGetMaxY(btnSignViaPaper.frame));
    viewCustomer1stAgreement.frame=CGRectMake(CGRectGetMinX(viewCustomer1stAgreement.frame),CGRectGetMinY(viewCustomer1stAgreement.frame),CGRectGetWidth(viewCustomer1stAgreement.frame),scrlAgreements.contentSize.height);
    scrlAgreements.scrollEnabled=YES;
    scrlAgreements.bounces=NO;
    scrlAgreements.pagingEnabled=YES;
    [self.view addSubview:scrlAgreements];
    
}

-(void)signTapped:(UIGestureRecognizer *)recognizer
{
    NSLog([NSString stringWithFormat:@"%@", signURL]);
    
    if (signURL.length>0)
    {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Re-Use previous signature ?"
                                                                            message:@""
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *NewSign = [UIAlertAction actionWithTitle: @"No, Take New One"
                                                          style: UIAlertActionStyleDefault
                                                        handler: ^(UIAlertAction *action) {
            imgCheckSignature=NO;
            ImgSign.image=nil;
            [self preparingAutographPad];
            
        }];
        UIAlertAction *ExistSign = [UIAlertAction actionWithTitle: @"OK , Use It"
                                                            style: UIAlertActionStyleDefault
                                                          handler: ^(UIAlertAction *action) {
            MBProgressHUD *hudtoShow= [MBProgressHUD showHUDAddedTo:ImgSign animated:YES];
            hudtoShow.labelText=@"Getting Signature ...";
            hudtoShow.labelFont=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
            
            signURL=[signURL stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            
            [self downloadImageWithURL:[NSURL URLWithString:signURL]completionBlock:^(BOOL succeeded, UIImage *image) {
                [MBProgressHUD hideAllHUDsForView:ImgSign animated:YES];
                if (succeeded) {
                    ImgSign.image=image;
                    imgCheckSignature=YES;
                }
            }];
        }];
        [controller addAction: NewSign];
        [controller addAction: ExistSign];
        
        [self presentViewController: controller animated: YES completion: nil];
    }
    else
    {
        [self preparingAutographPad];
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
        }
    }];
}



#pragma  mark  - Invoice Nethod Link
-(void)GetInvoiceLink
{
    //GetInvoice(string userToken, long jobId);
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString=[NSString stringWithFormat:@"%sGetInvoice?userToken=%@&jobId=%@",conn_url, (NSString *)[userdetails valueForKey:@"UserToken"],_jobID];
    urlString=[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // [post stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
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


-(void)ProceedWithPaperWork
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @""
                                                                        message:@"Do you accept this agreement via paperwork ?"
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *Yes = [UIAlertAction actionWithTitle: @"YES"
                                                  style: UIAlertActionStyleDefault
                                                handler: ^(UIAlertAction *action) {
        
        ImgSign.image=[UIImage imageNamed:@"SignViaPaperwork"];
        imgCheckSignature=YES;
        [self acceptPress:nil];
        
    }];
    
    UIAlertAction *No = [UIAlertAction actionWithTitle: @"NO"
                                                 style: UIAlertActionStyleDefault
                                               handler: ^(UIAlertAction *action) {
    }];
    [controller addAction: Yes];
    [controller addAction: No];
    [self presentViewController: controller animated: YES completion: nil];
}



#pragma mark- AcceptPress Method
-(void)acceptPress:(UIButton *)sender
{
    
    UIImage *img ;
    
    if (sender.tag==212)
    {
        ImgSign.image=[UIImage imageNamed:@"SignViaPaperwork"];
        imgCheckSignature=YES;
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"]&&imgCheckSignature==NO)
    {
        [self ProceedWithPaperWork];
    }
    else if(imgCheckSignature==NO && sender.tag!=212)
    {
        [self showAlert:@"Please do your signature first." withTitle:@"Wait"];
    }
    else
    {
        img=ImgSign.image;
        imageData=[[NSMutableData alloc]init];
        imageData=(NSMutableData*)UIImagePNGRepresentation(img);
        NSString *printType=@"1stAgreement";
        if ([_lblHeading.text isEqualToString:@"Invoice"])
        {
            printType=@"InvoicePrint";
        }
        else
        {
            if ([[_JobDic valueForKey:@"FixedPrice"]integerValue]>0)
            {
                printType=@"DetailQuote";
            }
        }
        NSString *strNoteID;
        if (_segNote.selectedSegmentIndex==0) {
            strNoteID = @"22";
        }else if (_segNote.selectedSegmentIndex==1){
            strNoteID = @"23";
        }else if (_segNote.selectedSegmentIndex==2){
            strNoteID = @"10";
        }
        if (_txtNoteDesComplete.text.length==0) {
            _txtNoteDesComplete.text=@"";
        }
        
        NSString* encodedImageString,*base64String;
        encodedImageString=@"";
        base64String = [imageData base64EncodedStringWithOptions:0];
        NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
        NSString *urlStr=[NSString stringWithFormat:@"%sSaveSignature",conn_url];
        NSString *json;
        NSError *jsonError;
        NSMutableData *body = [NSMutableData data];
        NSDictionary *_params=[[NSDictionary alloc]initWithObjects:@[(NSString *)[userdetails valueForKey:@"UserToken"],base64String,_jobID,printType,[userdetails valueForKey:@"UserType"],[userdetails valueForKey:@"UserID"],_txtNoteDesComplete.text,strNoteID] forKeys:@[@"userToken",@"imageData",@"jobId",@"printType",@"userType",@"userId",@"note",@"noteTypeId"]];
        NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
        NSData *reqData=[NSData dataWithBytes:[json UTF8String] length:[json length]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%ld",(unsigned long)[reqData length]] forHTTPHeaderField:@"Content-Length"];
        request.timeoutInterval = 300;
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:_params options:0
                                                             error:&jsonError];
        if (!jsonError)
        {
            [request setHTTPBody:postData];
        }
        
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setURL:[NSURL URLWithString:urlStr]];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        connPostAgreement = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connPostAgreement start];
    }
}

#pragma mark- DeclinePress Method
-(void)declinePress:(id)sender
{
    [self backTapped:nil];
}
-(void)MaskinViewController:(PJRSignatureView *)viewController IsSignatureDone:(BOOL)value{
    
    imgCheckSignature=value;
}
-(IBAction)agreementSigned:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SecondViewControllerDismissedWithAgreement"
                                                        object:nil
                                                      userInfo:nil];
    NSArray *arr=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrEditedJobDic"];
    NSMutableArray *mutableCopy=[arr mutableCopy];
    if (mutableCopy==nil)
    {
        mutableCopy=[[NSMutableArray alloc]init];
    }
    [mutableCopy addObject:_jobID];
    [[NSUserDefaults standardUserDefaults]setObject:mutableCopy forKey:@"arrEditedJobDic"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    // Creates a mutable data object for updating with binary data, like a byte array
    UIWebView *webView = (UIWebView*)aView;
    NSString *heightStr = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    
    int height = [heightStr intValue];
    CGFloat screenHeight = webView.bounds.size.height;
    int pages = ceil(height / screenHeight);
    
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, webView.bounds, nil);
    CGRect frame = [webView frame];
    for (int i = 0; i < pages; i++) {
        // Check to screenHeight if page draws more than the height of the UIWebView
        if ((i+1) * screenHeight  > height) {
            CGRect f = [webView frame];
            f.size.height -= (((i+1) * screenHeight) - height);
            [webView setFrame: f];
        }
        
        UIGraphicsBeginPDFPage();
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        [[[webView subviews] lastObject] setContentOffset:CGPointMake(0, screenHeight * i) animated:NO];
        [webView.layer renderInContext:currentContext];
    }
    
    UIGraphicsEndPDFContext();
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    [webView setFrame:frame];
}

#pragma mark- Signature Cancel Press Method
-(void)cleanPress:(id)sender
{
    imgCheckSignature=0;
    ImgSign.image=nil;
}

#pragma mark- Prepare Digital Signature Method
-(void)preparingAutographPad
{
    bgVw =[[UIControl alloc]initWithFrame:CGRectMake(0,0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    bgVw.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.8f];
    
    scratchableView = [[PJRSignatureView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth(bgVw.frame),300)];
    scratchableView.tag=1001;
    scratchableView.delegate=self;
    // [scratchableView setMaskingFrame:CGRectMake(0, 0, CGRectGetWidth(bgVw.frame), 300) :@"whitey.png"];
    scratchableView.center=CGPointMake(CGRectGetWidth(bgVw.frame)/2.0f, CGRectGetHeight(bgVw.frame)/2.0f);
    [bgVw addSubview:scratchableView];
    
    UIImageView *bkIMG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blacky.png"]];
    bkIMG.tag=1002;
    [bkIMG setFrame:CGRectMake(XX, YY, CGRectGetWidth(bgVw.frame), 300)];
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
    btnDone.center=CGPointMake(CGRectGetMaxX(scratchableView.frame)-CGRectGetWidth(btnDone.frame)-5/2.0f, CGRectGetMaxY(scratchableView.frame)+CGRectGetHeight(btnDone.frame)/2.0f+5);
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(0,0,100,40);
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCancel.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCancel setBackgroundColor:[UIColor colorWithRed:254/255.0 green:171/255.0 blue:30/255.0 alpha:1.0]];
    [btnCancel addTarget:self action:@selector(bgPopupTouched:) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.center=CGPointMake(CGRectGetMinX(scratchableView.frame)+CGRectGetWidth(btnDone.frame)+5/2.0f, CGRectGetMaxY(scratchableView.frame)+CGRectGetHeight(btnCancel.frame)/2.0f+5);
    
    
    [bgVw addSubview:btnDone];
    [bgVw addSubview:btnCancel];
    [self.view addSubview:bgVw];
}


-(IBAction)DoneSignature:(id)sender{
    ImgSign.image=[scratchableView getSignatureImage];
    [self bgPopupTouched:nil];
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

#pragma mark - DidRecieve Memory Warning Method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Agreement 1 Page job create
-(void)showPopUpAgreementPage :(NSString *)strNewOrRecReate
{
    mainBg1 = [[UIView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
    mainBg1.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    
    bgVw1 = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth([UIScreen mainScreen].bounds)-10,[UIScreen mainScreen].bounds.size.height-60)];
    bgVw1.center=CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2.0f, CGRectGetHeight([UIScreen mainScreen].bounds)/2.0f);
    
    [bgVw1.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [bgVw1.layer setBorderWidth: 0.5];
    [bgVw1.layer setCornerRadius:4.0f];
    [bgVw1.layer setMasksToBounds:YES];
    bgVw1.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.text = @"Terms & Conditions";
    lblTitle.font = [UIFont fontWithName:@"TheSansArabic-Bold" size:17];
    [lblTitle sizeToFit];
    lblTitle.center=CGPointMake(CGRectGetWidth(bgVw1.frame)/2.0f, CGRectGetHeight(lblTitle.frame)/2.0f+10);
    
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.textColor=[UIColor darkGrayColor];
    lblTitle.backgroundColor =[UIColor clearColor];
    [bgVw1 addSubview:lblTitle];
    
    
    UITextView *txtvAgreement = [[UITextView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(bgVw1.frame)-10,bgVw1.frame.size.height-100)];
    txtvAgreement.center=CGPointMake(CGRectGetWidth(bgVw1.frame)/2.0f, CGRectGetHeight(bgVw1.frame)/2.0f);
    
    txtvAgreement.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
    txtvAgreement.textColor=[UIColor darkGrayColor];
    [txtvAgreement setBackgroundColor:[UIColor whiteColor]];
    txtvAgreement.editable=NO;
    MBProgressHUD *hudshow=[MBProgressHUD showHUDAddedTo:txtvAgreement animated:YES];
    hudshow.labelText=@"loading T&C ...";
    
    [self getAgreement:@"Print" loadingCompleted:^(BOOL completed,NSString *htmlString){
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        txtvAgreement.attributedText = attributedString;
        
        [MBProgressHUD hideAllHUDsForView:txtvAgreement animated:YES];
        
    }];
    
    [txtvAgreement.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [txtvAgreement.layer setBorderWidth: 1.0];
    [txtvAgreement.layer setCornerRadius:4.0f];
    [txtvAgreement.layer setMasksToBounds:YES];
    
    
    UIButton *btnacceptYes = [UIButton buttonWithType:UIButtonTypeCustom];
    btnacceptYes.frame = CGRectMake(CGRectGetWidth(bgVw1.frame)/2.0f,bgVw1.frame.size.height-40,CGRectGetWidth(bgVw1.frame)/2.0f,40);
    [btnacceptYes setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnacceptYes.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    btnacceptYes.tag=[strNewOrRecReate integerValue];
    [btnacceptYes setTitle:@"Accept" forState:UIControlStateNormal];
    [btnacceptYes setBackgroundColor:[UIColor colorWithRed:120/255.0 green:171/255.0 blue:30/255.0 alpha:1.0]];
    [btnacceptYes addTarget:self action:@selector(pressAcceptYes:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btndeclineNo = [UIButton buttonWithType:UIButtonTypeCustom];
    btndeclineNo.frame = CGRectMake(0,bgVw1.frame.size.height-40,CGRectGetWidth(btnacceptYes.frame),40);
    [btndeclineNo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btndeclineNo.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    btndeclineNo.tag=[strNewOrRecReate integerValue];
    [btndeclineNo setTitle:@"Decline" forState:UIControlStateNormal];
    [btndeclineNo setBackgroundColor:[UIColor colorWithRed:214/255.0 green:100/255.0 blue:4/255.0 alpha:1.0]];
    [btndeclineNo addTarget:self action:@selector(pressDeclineNo:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [bgVw1 addSubview:txtvAgreement];
    [bgVw1 addSubview:btnacceptYes];
    [bgVw1 addSubview:btndeclineNo];
    
    [mainBg1 addSubview:bgVw1];
    // [self.view addSubview:mainBg1];
    mainBg1.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{
        mainBg1.alpha=1.0f;
        [self.view addSubview:mainBg1];
        
    }];
}

-(void)pressAcceptYes:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    DLog(@"tag :%ld",(long)btn.tag);
    [mainBg1 removeFromSuperview];
    NSString *strTag=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    [self showPopUpAgreement2Page:strTag];
}

-(void)pressDeclineNo:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    DLog(@"tag :%ld",(long)btn.tag);
    [self.dataTaskAgr cancel];
    [mainBg1 removeFromSuperview];
    [self backTapped:nil];
}

#pragma mark - Agreement 2 Page job create
-(void)showPopUpAgreement2Page :(NSString *)strNewOrRecReate
{
    mainBg2 = [[UIView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen]bounds].size.width,[[UIScreen mainScreen]bounds].size.height)];
    mainBg2.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    
    bgVw2 = [[UIView alloc] initWithFrame:CGRectMake(5,44,CGRectGetWidth([[UIScreen mainScreen]bounds])-10,[[UIScreen mainScreen]bounds].size.height-60)];
    bgVw2.center=CGPointMake(CGRectGetWidth([[UIScreen mainScreen]bounds])/2.0f, CGRectGetHeight([[UIScreen mainScreen]bounds])/2.0f);
    
    [bgVw2.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [bgVw2.layer setBorderWidth: 0.5];
    [bgVw2.layer setCornerRadius:4.0f];
    [bgVw2.layer setMasksToBounds:YES];
    bgVw2.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.text = @"Cancellation Rights";
    lblTitle.font = [UIFont fontWithName:@"TheSansArabic-Bold" size:17];
    [lblTitle sizeToFit];
    lblTitle.center=CGPointMake(CGRectGetWidth(bgVw2.frame)/2.0f, CGRectGetHeight(lblTitle.frame)/2.0f+10);
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.textColor=[UIColor darkGrayColor];
    lblTitle.backgroundColor =[UIColor clearColor];
    [bgVw2 addSubview:lblTitle];
    
    
    UITextView *txtvAgreement = [[UITextView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(bgVw2.frame)-10,bgVw1.frame.size.height-100)];
    txtvAgreement.center=CGPointMake(CGRectGetWidth(bgVw2.frame)/2.0f, CGRectGetHeight(bgVw2.frame)/2.0f);
    
    txtvAgreement.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
    txtvAgreement.textColor=[UIColor darkGrayColor];
    [txtvAgreement setBackgroundColor:[UIColor whiteColor]];
    txtvAgreement.editable=NO;
    
    MBProgressHUD *hudshow=[MBProgressHUD showHUDAddedTo:txtvAgreement animated:YES];
    hudshow.labelText=@"loading T&C ...";
    
    [self getAgreement:@"Secondlevel" loadingCompleted:^(BOOL completed,NSString *htmlString){
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        txtvAgreement.attributedText = attributedString;
        
        [MBProgressHUD hideAllHUDsForView:txtvAgreement animated:YES];
         
        
        
    }];
    
    
    [txtvAgreement.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [txtvAgreement.layer setBorderWidth: 1.0];
    [txtvAgreement.layer setCornerRadius:4.0f];
    [txtvAgreement.layer setMasksToBounds:YES];
    
    UIButton *btnacceptYes = [UIButton buttonWithType:UIButtonTypeCustom];
    btnacceptYes.frame = CGRectMake(CGRectGetWidth(bgVw2.frame)/2.0f,bgVw2.frame.size.height-40,CGRectGetWidth(bgVw2.frame)/2.0f,40);
    [btnacceptYes setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnacceptYes.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    btnacceptYes.tag=[strNewOrRecReate integerValue];
    [btnacceptYes setTitle:@"Accept" forState:UIControlStateNormal];
    [btnacceptYes setBackgroundColor:[UIColor colorWithRed:120/255.0 green:171/255.0 blue:30/255.0 alpha:1.0]];
    [btnacceptYes addTarget:self action:@selector(pressAcceptYes2:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btndeclineNo = [UIButton buttonWithType:UIButtonTypeCustom];
    btndeclineNo.frame = CGRectMake(0,bgVw2.frame.size.height-40,CGRectGetWidth(bgVw2.frame)/2.0f,40);
    [btndeclineNo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btndeclineNo.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    btndeclineNo.tag=[strNewOrRecReate integerValue];
    [btndeclineNo setTitle:@"Decline" forState:UIControlStateNormal];
    [btndeclineNo setBackgroundColor:[UIColor colorWithRed:214/255.0 green:100/255.0 blue:4/255.0 alpha:1.0]];
    [btndeclineNo addTarget:self action:@selector(pressDeclineNo2:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [bgVw2 addSubview:txtvAgreement];
    [bgVw2 addSubview:btnacceptYes];
    [bgVw2 addSubview:btndeclineNo];
    [mainBg2 addSubview:bgVw2];
    //[self.view addSubview:mainBg2];
    
    mainBg2.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{
        
        
        mainBg2.alpha=1.0f;
        
        [self.view addSubview:mainBg2];
        
    }];
}
-(void)pressAcceptYes2:(id)sender
{
    [mainBg2 removeFromSuperview];
    [self viewPopUpCustomer1stAgreement];
    
    if ([_JobDic valueForKey:@"JobTotalNote"]&&[[_JobDic valueForKey:@"FixedPrice"]integerValue]!=0&&[[_JobDic valueForKey:@"IsAgreementSign"]integerValue]>0) {
        
        [self showAlert:[NSString stringWithFormat:@"%@",[_JobDic valueForKey:@"JobTotalNote"]] withTitle:@"Fixed price note "];
        
    }
    
}

-(void)pressDeclineNo2:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    DLog(@"tag :%ld",(long)btn.tag);
    [self.dataTaskAgr cancel];
    [mainBg2 removeFromSuperview];
    [self backTapped:nil];
    
}

#pragma mark  - Zoom Pdf View Agreement Method
-(void)zoomPdfView:(NSMutableDictionary*)arrLink
{
    if ([strHeading isEqualToString:@"Invoice"])
    {
        arrLink=arrAgrLinks;
    }
    
    mainBgNoteDesc = [[UIView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen]bounds].size.width,[[UIScreen mainScreen]bounds].size.height)];
    mainBgNoteDesc.backgroundColor =[UIColor clearColor];
    
    bgVwNoteDesc = [[UIScrollView alloc] initWithFrame:CGRectMake(2,67,[[UIScreen mainScreen]bounds].size.width-5,CGRectGetHeight([[UIScreen mainScreen]bounds])-50)];
    bgVwNoteDesc.pagingEnabled=YES;
    bgVwNoteDesc.bounces=NO;
    bgVwNoteDesc.delegate=self;
    bgVwNoteDesc.showsHorizontalScrollIndicator=NO;
    [bgVwNoteDesc.layer setBorderColor: [[UIColor colorWithRed:108/255.0 green:110/255.0 blue:119/255.0 alpha:1.0] CGColor]];
    [bgVwNoteDesc.layer setBorderWidth: 0.5];
    [bgVwNoteDesc.layer setCornerRadius:0.0f];
    [bgVwNoteDesc.layer setMasksToBounds:YES];
    bgVwNoteDesc.backgroundColor =[UIColor darkGrayColor];
    
    NSMutableArray *arrItems=[[NSMutableArray alloc]init];
    CGFloat currX=0.0f;
    int i=0;
    
    DLog(@"arrLink :%@",arrLink);
    
    for (NSString *Str in [arrLink allKeys])
    {
        i++;
        
        DLog(@"Str :%@",Str);
        
        if (![[arrLink valueForKey:Str]isEqualToString:@""])
        {
            [arrItems addObject:Str];
            
            NSURL *url = [NSURL URLWithString:[[arrLink valueForKey:Str] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
            DLog(@"url>>>>> %@",url);
            
            UIWebView*  webV=[[UIWebView alloc]initWithFrame:CGRectMake(currX, 30, CGRectGetWidth(bgVwNoteDesc.frame), CGRectGetHeight(bgVwNoteDesc.frame)-47)];
            //[webV stringByEvaluatingJavaScriptFromString:@"document.open();document.close()"];
            webV.backgroundColor=[UIColor lightGrayColor];
            webV.delegate=self;
            [webV loadRequest:[NSURLRequest requestWithURL:url]];
            [webV setScalesPageToFit:YES];
            webV.backgroundColor=[UIColor lightGrayColor];
            webV.tag=i;
            [bgVwNoteDesc addSubview:webV];
            
            btnEmail=[UIButton buttonWithType:UIButtonTypeCustom];
            btnEmail.frame=CGRectMake(0, 0, 30, 30);
            if ([Str isEqualToString:@"Invoice"])
            {
                btnEmail.tag=0;
            }
            
            if ([Str isEqualToString:@"Small Repair Agreement"])
            {
                btnEmail.tag=2;
            }
            else if ([Str isEqualToString:@"Fixed Price Agreement"])
            {
                btnEmail.tag=1;
            }
            else if ([Str isEqualToString:@"Gas Certificate"])
            {
                btnEmail.tag=3;
            }
            btnEmail.center=CGPointMake(CGRectGetMinX(mainBgNoteDesc.frame)+currX+20,CGRectGetMinY(mainBgNoteDesc.frame)+15);
            [btnEmail setBackgroundImage:[UIImage imageNamed:@"emailagreecert"] forState:UIControlStateNormal];
            [btnEmail addTarget:self action:@selector(pressEmail:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            btnDropBox=[UIButton buttonWithType:UIButtonTypeCustom];
            btnDropBox.frame=CGRectMake(0, 0, 30, 30);
            if ([Str isEqualToString:@"Invoice"])
            {
                btnDropBox.tag=0;
            }
            
            if ([Str isEqualToString:@"Small Repair Agreement"])
            {
                btnDropBox.tag=2;
            }
            else if ([Str isEqualToString:@"Fixed Price Agreement"])
            {
                btnDropBox.tag=1;
            }
            else if ([Str isEqualToString:@"Gas Certificate"])
            {
                btnDropBox.tag=3;
            }
            btnDropBox.center=CGPointMake(CGRectGetMaxX(btnEmail.frame)+30,CGRectGetMinY(mainBgNoteDesc.frame)+15);
            [btnDropBox setBackgroundImage:[UIImage imageNamed:@"dropbox"] forState:UIControlStateNormal];
            [btnDropBox addTarget:self action:@selector(pressDropbox:) forControlEvents:UIControlEventTouchUpInside];
            
            currX=currX+CGRectGetWidth(webV.frame)+5;
            
            [bgVwNoteDesc addSubview:btnDropBox];
            
            
            if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
            {
                [bgVwNoteDesc addSubview:btnEmail];
            }
            
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
            {
                btnDropBox.hidden=YES;
            }
            
            
            
        }
    }
    
    NSLog(@"arrItems :%@",arrItems);
    
    segmentedControl = [[UISegmentedControl alloc] initWithItems:arrItems];
    segmentedControl.frame = CGRectMake(0,20, CGRectGetWidth(mainBgNoteDesc.frame), 45);
    [segmentedControl addTarget:self action:@selector(AgreementSegmentControl:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    UIFont *font = [UIFont fontWithName:@"TheSansArabic-Bold" size:16.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    segmentedControl.tintColor=[UIColor colorWithRed:137/255.0 green:182/255.0 blue:40/255.0 alpha:1];
    segmentedControl.backgroundColor = [UIColor whiteColor];
    segmentedControl.layer.cornerRadius = 0.0;
    [mainBgNoteDesc addSubview:segmentedControl];
    
    [bgVwNoteDesc setContentSize:CGSizeMake(currX, CGRectGetHeight(bgVwNoteDesc.frame))];
    
    
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

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [MBProgressHUD showHUDAddedTo:webView animated:YES];
    
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideAllHUDsForView:webView animated:YES];
    
    
}




-(void)cross:(UIButton *)sender
{
    [mainBgNoteDesc removeFromSuperview];
    mainBgNoteDesc=nil;
    
    [sender.superview removeFromSuperview];
    
    
    if ([strHeading isEqualToString:@"Invoice"]&&self.isInvoice==YES) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (![strHeading isEqualToString:@"Invoice"])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        
    }
    
    
    
}




#pragma mark - Agreement Tab Segment Method
- (void)AgreementSegmentControl:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex)
    {
        case 0:
        {
            bgVwNoteDesc.contentOffset=CGPointMake(0, bgVwNoteDesc.contentOffset.y);
            break;
        }
        case 1:
        {
            
            
            bgVwNoteDesc.contentOffset=CGPointMake(bgVwNoteDesc.frame.size.width, bgVwNoteDesc.contentOffset.y);
            break;
        }
    }
}

#pragma mark - ScrollView Delegate Method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==bgVwNoteDesc)
    {
        if (scrollView.contentOffset.x==scrollView.frame.size.width)
        {
            segmentedControl.selectedSegmentIndex=1;
        }
        else if(scrollView.contentOffset.x==0)
        {
            segmentedControl.selectedSegmentIndex=0;
        }
    }
}



#pragma mark -  Print Method
-(void)pressPrint:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    DLog(@"tag:%ld",(long)btn.tag);
    
    
    
    
    NSURL *url;
    NSString *strJobType;
    
    if (btn.tag==0)
    {
        strJobType=@"Invoice";
        DLog(@"agggg :%@",[arrAgrLinks valueForKey:@"Invoice"]);
        url = [NSURL URLWithString:[[arrAgrLinks valueForKey:@"Invoice"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    }
    else if (btn.tag==1)
    {
        strJobType=@"Fixed Price Agreement";
        DLog(@"agggg :%@",[arrAgrLinks valueForKey:@"Fixed Price Agreement"]);
        url = [NSURL URLWithString:[[arrAgrLinks valueForKey:@"Fixed Price Agreement"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    }
    else if (btn.tag==2)
    {
        strJobType=@"Small Repair Agreement";
        DLog(@"agggg :%@",[arrAgrLinks valueForKey:@"Small Repair Agreement"]);
        url = [NSURL URLWithString:[[arrAgrLinks valueForKey:@"Small Repair Agreement"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    }
    else if (btn.tag==3)
    {
        strJobType=@"Gas Certificate";
        DLog(@"Gas Certificate >>>:%@",[arrAgrLinks valueForKey:@"Gas Certificate"]);
        url = [NSURL URLWithString:[[arrAgrLinks valueForKey:@"Gas Certificate"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    }
    
    
    
    NSLog(@"url :%@",url);
    NSURL *requestURL = url;
    NSError *error;
    NSString *htmlStr = [NSString stringWithContentsOfURL:requestURL
                                                 encoding:NSASCIIStringEncoding
                                                    error:&error];
    
    NSLog(@"htmlStr :%@",htmlStr);
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = [NSString stringWithFormat:@"%@",strJobType];
    pic.printInfo = printInfo;
    
    UIMarkupTextPrintFormatter* textFormatter = [[UIMarkupTextPrintFormatter alloc]initWithMarkupText:htmlStr];
    textFormatter.startPage = 0;
    textFormatter.contentInsets = UIEdgeInsetsMake(0.0,0.0, 72.0, 72.0);
    textFormatter.maximumContentWidth = 6 * 72.0;
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

#pragma mark -  Dropboax Method
-(void)pressDropbox:(id)sender
{
    
    MBProgressHUD *hudRefdropbox =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudRefdropbox.labelText=@"Uploading into dropbox";
    
    UIButton *btn=(UIButton *)sender;
    DLog(@"tag:%ld",(long)btn.tag);
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString;
    _jobID=[_JobDic valueForKey:@"JobID"];
    
    
    if (btn.tag==0)
    {
        NSURL *fileurl = [NSURL URLWithString:[[arrAgrLinks valueForKey:@"Invoice"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        DLog(@"fileurl>>>>> %@",fileurl);
        
        urlString=[NSString stringWithFormat:@"%sUploadFileToDropbox?userToken=%@&jobId=%@&fileUrl=%@&certificateTypeId=%@&uniqueNo=%@",conn_url, (NSString *)[userdetails valueForKey:@"UserToken"],_jobID,fileurl,@"6",@""];
    }
    if (btn.tag==1)
    {
        NSURL *fileurl = [NSURL URLWithString:[[arrAgrLinks valueForKey:@"Fixed Price Agreement"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        DLog(@"fileurl>>>>> %@",fileurl);
        
        urlString=[NSString stringWithFormat:@"%sUploadFileToDropbox?userToken=%@&jobId=%@&fileUrl=%@&certificateTypeId=%@&uniqueNo=%@",conn_url, (NSString *)[userdetails valueForKey:@"UserToken"],_jobID,fileurl,@"7",@""];
    }
    else if (btn.tag==2)
    {
        
        NSURL *fileurl = [NSURL URLWithString:[[arrAgrLinks valueForKey:@"Small Repair Agreement"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        DLog(@"fileurl>>>>> %@",fileurl);
        
        urlString=[NSString stringWithFormat:@"%sUploadFileToDropbox?userToken=%@&jobId=%@&fileUrl=%@&certificateTypeId=%@&uniqueNo=%@",conn_url, (NSString *)[userdetails valueForKey:@"UserToken"],_jobID,fileurl,@"8",@""];
    }
    else if (btn.tag==3)
    {
        
    }
    
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
    request.timeoutInterval = 300;
    DLog(@"PostString=%@",request);
    connDropboxPost = [[NSURLConnection alloc]init];
    
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        
        DLog(@"PostString=%@",urlString);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error==nil) {
                _responseData=[data mutableCopy];
                [self connectionDidFinishLoading:connDropboxPost];
            }
            else
            {
                
            }
            
        });
        
    }];
    
}

#pragma mark - Email Post Method
-(void)pressEmail:(id)sender
{
    hudRefEmail =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudRefEmail.labelText=@"sending mail";
    
    UIButton *btn=(UIButton *)sender;
    DLog(@"tag:%ld",(long)btn.tag);
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString;
    _jobID=[_JobDic valueForKey:@"JobID"];
    
    if (btn.tag==0)
    {
        DLog(@"agggg :%@",[arrAgrLinks valueForKey:@"Invoice"]);
        
        DLog(@"Gas Certificate >>>:%@",[arrAgrLinks valueForKey:@"Gas Certificate"]);
        
        urlString=[NSString stringWithFormat:@"%sSendAgreementToUser?userToken=%@&jobId=%@&agreementType=%@",conn_url, (NSString *)[userdetails valueForKey:@"UserToken"],_jobID,@"InvoiceDetail"];
    }
    else if (btn.tag==1)
    {
        DLog(@"agggg :%@",[arrAgrLinks valueForKey:@"Fixed Price Agreement"]);
        
        urlString=[NSString stringWithFormat:@"%sSendAgreementToUser?userToken=%@&jobId=%@&agreementType=%@",conn_url, (NSString *)[userdetails valueForKey:@"UserToken"],_jobID,@"FixedPriceAgreement"];
    }
    else if (btn.tag==2)
    {
        DLog(@"agggg :%@",[arrAgrLinks valueForKey:@"Small Repair Agreement"]);
        
        urlString=[NSString stringWithFormat:@"%sSendAgreementToUser?userToken=%@&jobId=%@&agreementType=%@",conn_url, (NSString *)[userdetails valueForKey:@"UserToken"],_jobID,@"SmallRepairAgreement"];
    }
    else if (btn.tag==3)
    {
        
    }
    
    urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
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
    connEmailPost = [[NSURLConnection alloc]init];
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        
        DLog(@"PostString=%@",urlString);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error==nil)
            {
                _responseData=[data mutableCopy];
                [self connectionDidFinishLoading:connEmailPost];
            }
            else
            {
            }
        });
    }];
    
   
}


#pragma mark - Select Invoice Number PopUp Method
-(IBAction)SelectInvoiceNumberPopUp:(UIButton *)sender
{
    DLog(@"imgCheckSignature :%i",imgCheckSignature);
    if (imgCheckSignature==NO&&sender.tag!=212)
    {
        [self showAlert:@"Please do your signature first." withTitle:@"Wait"];
    }
    else if ([[_JobDic valueForKey:@"NatureofJob"]rangeOfString:@"Gas"].location!=NSNotFound)
    {
        if (IsGasFormSigned==1)
        {
            if (sender.tag==212)
            {
                imgCheckSignature=YES;
                ImgSign.image=[UIImage imageNamed:@"SignViaPaperwork"];
                
            }
            [self CreateInvoiceDropDown];
        }
        else
        {
            if (sender.tag==212)
            {
                imgCheckSignature=YES;
                ImgSign.image=[UIImage imageNamed:@"SignViaPaperwork"];
                
            }
            
            UIAlertController *ctrl = [UIAlertController alertControllerWithTitle:nil message:@"Do you require to fill out one of the gas compliance forms?" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
                
                [self GasFormCreated:YES];
                [self ProcessGasForms];
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
                
                [self CreateInvoiceDropDown];
            }];
            
            [ctrl addAction:ok]; [ctrl addAction:cancel];
            
            
            [self presentViewController:ctrl animated:YES completion:nil];
            
            
            
        }
    }
    else
    {
        if (sender.tag==212)
        {
            imgCheckSignature=YES;
            ImgSign.image=[UIImage imageNamed:@"SignViaPaperwork"];
            
        }
        [self CreateInvoiceDropDown];
    }
}

#pragma mark -  Create Invoice Dropdown Method
-(void)CreateInvoiceDropDown
{
    bgVw =[[UIControl alloc]initWithFrame:CGRectMake(0,0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    [bgVw addTarget:self action:@selector(bgPopupTouched:) forControlEvents:UIControlEventTouchUpInside];
    bgVw.backgroundColor=[UIColor colorWithWhite:0.0f alpha:0.5f];
    
    popUpVW=[[UIScrollView alloc]initWithFrame:CGRectMake(60,140, 280,220)];
    popUpVW.center=CGPointMake(CGRectGetWidth(bgVw.frame)/2.0f, CGRectGetHeight(bgVw.frame)/2.5f);
    
    popUpVW.layer.cornerRadius=6.0f;
    popUpVW.backgroundColor=[UIColor whiteColor];
    //popUpVW.center=bgVw.center;
    
    
    
    selectInvoiceNo=[[UITextField alloc] initWithFrame:CGRectMake(20,30,240,30)];
    selectInvoiceNo.textColor=[UIColor darkGrayColor];
    selectInvoiceNo.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    [selectInvoiceNo setBorderStyle:UITextBorderStyleNone];
    selectInvoiceNo.layer.borderWidth=0.5f;
    selectInvoiceNo.layer.borderColor=[[UIColor grayColor]CGColor];
    selectInvoiceNo.layer.cornerRadius=4.0f;
    selectInvoiceNo.background=[UIImage imageNamed:@"inputBox5"];
    selectInvoiceNo.delegate = self;
    selectInvoiceNo.userInteractionEnabled=YES;
    selectInvoiceNo.placeholder=@" Select Invoice No.";
    selectInvoiceNo.text=[[_JobDic valueForKey:@"InvoiceNumberID"]isKindOfClass:[NSNull class]]?@"":[NSString stringWithFormat:@"%@",[_JobDic valueForKey:@"InvoiceNumberID"]];
    
    int invoice= [selectInvoiceNo.text intValue];
    
    if (invoice==-1) {
        
        selectInvoiceNo.text =  @"No Invoice number";
    }
    

    NSLog(@"_JobDic <<<<<>>>>>>>> %@",_JobDic);
    NSString *invId=[GlobalDirector ReplaceStringNull:[_JobDic valueForKey:@"InvoiceNumberID"]];
    NSLog(@"invId >>>>>>>>>%@",invId);
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        selectInvoiceNo.userInteractionEnabled=NO;
        if (invId.length>0) {
            selectInvoiceNo.text=invId;
            
            int invoice= [selectInvoiceNo.text intValue];
            
            if (invoice==-1) {
                selectInvoiceNo.text =  @"No Invoice number";
            }
            UILabel *lblAlert=[[UILabel alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(popUpVW.frame)-20,60)];
            lblAlert.textAlignment=NSTextAlignmentCenter;
            lblAlert.numberOfLines=2;
            lblAlert.lineBreakMode=NSLineBreakByWordWrapping;
            lblAlert.textColor=[UIColor lightGrayColor];
            lblAlert.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:14.0];
            
            lblAlert.text=[NSString stringWithFormat:@"*invoice will be updated against this invoice number"];
            lblAlert.center=CGPointMake(CGRectGetWidth(popUpVW.frame)/2.0f, CGRectGetMaxY(selectInvoiceNo.frame)+CGRectGetHeight(lblAlert.frame));
            [popUpVW addSubview:lblAlert];
        }else{
            
            MBProgressHUD *hudprog =[MBProgressHUD showHUDAddedTo:popUpVW animated:YES];
            hudprog.labelText=@"Fetching available invoice no...";
            hudprog.labelFont=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
            
            arrFeedTblPopup =[[NSMutableArray alloc]init];
            
            [self FetchDropDowns:@"GetInvoiceNo"];
        }
        
        
    }
    
    
    
    UIButton *btnGo=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    [btnGo setBackgroundImage:[UIImage imageNamed:@"loginbutton"] forState:UIControlStateNormal];
    [btnGo setTitle:@"Next" forState:UIControlStateNormal];
    btnGo.center=CGPointMake(CGRectGetWidth(popUpVW.frame)/2.0f, CGRectGetHeight(popUpVW.frame)-CGRectGetHeight(btnGo.frame));
    [btnGo clipsToBounds];
    btnGo.tag=1212;
    [btnGo addTarget:self action:@selector(proceedWithInvoiceNumber) forControlEvents:UIControlEventTouchUpInside];
    [popUpVW addSubview:btnGo];
    
    UIImageView *imgDropdown1=[[UIImageView alloc] initWithFrame:CGRectMake(225,30, 35, 30)];
    [imgDropdown1 setImage:[UIImage imageNamed:@"dropdown"]];
    
    UIButton *btncross=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    btncross.center=CGPointMake(CGRectGetMaxX(popUpVW.frame), CGRectGetMinY(popUpVW.frame));
    btncross.backgroundColor=[UIColor clearColor];
    [btncross setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
    [btncross clipsToBounds];
    [btncross addTarget:self action:@selector(bgPopupTouched:) forControlEvents:UIControlEventTouchUpInside];
    selectInvoiceNo.alpha = 1.0;
    [popUpVW addSubview:selectInvoiceNo];
    [popUpVW addSubview:imgDropdown1];
    
    [bgVw addSubview:popUpVW];
    [bgVw addSubview:btncross];
    [self.view addSubview:bgVw];
}



#pragma mark -  Process With Invoice Method
-(void)proceedWithInvoiceNumber
{
    if (selectInvoiceNo.text.length>0) {
        [popUpVW addSubview:[self AddNotesView]];
    }
    else{
        [self showAlert:@"Please select invoice no" withTitle:@"Wait!"];
    }
}

#pragma mark -  Process GasForms Page Method
-(void)ProcessGasForms
{
    GasForms *obj = [[GasForms alloc] initWithNibName:@"GasForms" bundle:Nil];
    obj.jobDic=_JobDic;
    obj.imgSign=ImgSign.image;
    obj.delegate=self;
    obj.isAcceptPageRedirect=YES;
    [self presentViewController:obj animated:YES completion:nil];
    
    
}


#pragma mark -  Add Notes View Method
-(UIView *)AddNotesView
{
    UIView * VW=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 280, popUpVW.frame.size.height)];
    VW.layer.cornerRadius=6.0f;
    VW.backgroundColor=[UIColor whiteColor];
    
    UILabel *lbl=[[UILabel alloc]init];
    lbl.text=@"Proceed With :";
    lbl.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:13.0];
    lbl.textColor=[UIColor grayColor];
    [lbl sizeToFit];
    
    lbl.center=CGPointMake(CGRectGetWidth(lbl.frame)/2.0f+5, CGRectGetHeight(lbl.frame)/2.0f+10);
    
    
    [VW addSubview:lbl];
    
    
    if ([[_JobDic valueForKey:@"IsAgreementSign"]integerValue]>1) {
        
        
        UIButton *btnAddFIxedPrice=[UIButton buttonWithType:UIButtonTypeCustom];
        btnAddFIxedPrice.frame=CGRectMake(20,CGRectGetHeight(VW.frame)/2.0f+10,240,40);
        [btnAddFIxedPrice setTitle:@"Fixed Price Notes" forState:UIControlStateNormal];
        
        [btnAddFIxedPrice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnAddFIxedPrice.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:16.0];
        [btnAddFIxedPrice setBackgroundColor:[UIColor colorWithRed:82/255.0 green:30/255.0 blue:135/255.0 alpha:1.0]];
        [btnAddFIxedPrice addTarget:self action:@selector(CompletionNotesPressed:) forControlEvents:UIControlEventTouchUpInside];
        btnAddFIxedPrice.tag=99;
        [btnAddFIxedPrice.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
        [btnAddFIxedPrice.layer setBorderWidth: 1.0];
        [btnAddFIxedPrice.layer setCornerRadius:6.0f];
        [btnAddFIxedPrice.layer setMasksToBounds:YES];
        btnAddFIxedPrice.userInteractionEnabled=YES;
        btnAddFIxedPrice.alpha = 1.0;
        
        [VW addSubview:btnAddFIxedPrice];
        
    }
    
    UIButton *btnCompletion=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCompletion.frame=CGRectMake(20,CGRectGetHeight(popUpVW.frame)/2.0f-40,240,40);
    [btnCompletion setTitle:@"Completion Notes" forState:UIControlStateNormal];
    [btnCompletion setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCompletion.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:16.0];
    [btnCompletion setBackgroundColor:[UIColor colorWithRed:30/255.0 green:124/255.0 blue:41/255.0 alpha:1.0]];
    [btnCompletion addTarget:self action:@selector(CompletionNotesPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnCompletion.tag=999;
    [btnCompletion.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [btnCompletion.layer setBorderWidth: 0.5];
    [btnCompletion.layer setCornerRadius:0.0f];
    [btnCompletion.layer setMasksToBounds:YES];
    
    [VW addSubview:btnCompletion];
    return VW;
}


#pragma mark - Completion Notes Press Method
-(IBAction)CompletionNotesPressed:(UIButton *)sender
{
    txtvNoteInvoice = [[UITextView alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(selectInvoiceNo.frame)+20,240,80)];
    txtvNoteInvoice.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    txtvNoteInvoice.textColor=[UIColor darkGrayColor];
    [txtvNoteInvoice setBackgroundColor:[UIColor whiteColor]];
    txtvNoteInvoice.delegate = self;
    
    if (sender.tag==999) {
        txtvNoteInvoice.text= [GlobalDirector ReplaceStringNull:[_JobDic valueForKey:@"CompletetionNote"]];
        txtvNoteInvoice.userInteractionEnabled=YES;
        jobCompletetionNoteType=@"COM";
    }
    else if (sender.tag==99)
    {
        txtvNoteInvoice.text=[[_JobDic valueForKey:@"JobTotalNote"]isKindOfClass:[NSNull class]]?@"":[_JobDic valueForKey:@"JobTotalNote"];
        txtvNoteInvoice.userInteractionEnabled=YES;
        jobCompletetionNoteType=@"FP";
        
        
        
        
    }
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"]) {
        
        txtvNoteInvoice.userInteractionEnabled=NO;
    }
    
    if (sender.tag==99&&txtvNoteInvoice.text.length==0) {
        
        [self showAlert:@"No fixed price note added , proceed with complition notes" withTitle:@"Wait"];
    }
    else
    {
        
        [sender.superview removeFromSuperview];
        for (UIButton *btnNext in [popUpVW subviews]) {
            if (btnNext.tag==1212) {
                
                [btnNext removeFromSuperview];
                
            }
            
            
        }
        
        
        
        [txtvNoteInvoice.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [txtvNoteInvoice.layer setBorderWidth: 0.5];
        [txtvNoteInvoice.layer setCornerRadius:0.0f];
        [txtvNoteInvoice.layer setMasksToBounds:YES];
        
        UIButton *btnGenerateInvoice=[UIButton buttonWithType:UIButtonTypeCustom];
        btnGenerateInvoice.frame=CGRectMake(0,popUpVW.frame.size.height-35,popUpVW.frame.size.width,35);
        [btnGenerateInvoice setTitle:@"Generate Invoice" forState:UIControlStateNormal];
        [btnGenerateInvoice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnGenerateInvoice.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:18.0];
        [btnGenerateInvoice setBackgroundColor:[UIColor colorWithRed:30/255.0 green:124/255.0 blue:41/255.0 alpha:1.0]];
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
        {
            // [btnGenerateInvoice addTarget:self action:@selector(btnRecomandations) forControlEvents:UIControlEventTouchUpInside];
            [btnGenerateInvoice addTarget:self action:@selector(ShowPopupComplete) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            
            [btnGenerateInvoice addTarget:self action:@selector(btnRecomandations) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        
        [btnGenerateInvoice.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [btnGenerateInvoice.layer setBorderWidth: 0.5];
        [btnGenerateInvoice.layer setCornerRadius:0.0f];
        [btnGenerateInvoice.layer setMasksToBounds:YES];
        
        
        [popUpVW addSubview:btnGenerateInvoice];
        [popUpVW addSubview:txtvNoteInvoice];
        
    }
    
    
    
}



#pragma mark - YES Press Method
-(IBAction)YESPress:(id)sender
{
    UIView *bgview=[[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    bgview.backgroundColor=[UIColor colorWithWhite:0.2f alpha:0.6f];
    
    UIView *popUp=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    popUp.backgroundColor=[UIColor whiteColor];
    popUp.layer.cornerRadius=5.0f;
    popUp.center=CGPointMake(CGRectGetWidth(bgview.frame)/2.0f, CGRectGetHeight(bgview.frame)/2.0f);
    
    UILabel *lblTitle=[[UILabel alloc]init];
    lblTitle.text=@"Recommendations / disclaimers";
    lblTitle.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    lblTitle.textColor=[UIColor darkGrayColor];
    [lblTitle sizeToFit];
    lblTitle.center=CGPointMake(CGRectGetWidth(popUp.frame)/2.0f, 20.0f);
    
    _txtVRecomandation= [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 250, 100)];
    _txtVRecomandation.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtVRecomandation.layer.borderWidth=0.5f;
    _txtVRecomandation.layer.cornerRadius=0.0f;
    _txtVRecomandation.tag=12121;
    _txtVRecomandation.delegate=self;
    _txtVRecomandation.backgroundColor=[UIColor whiteColor];
    _txtVRecomandation.center=CGPointMake(lblTitle.center.x, CGRectGetMaxY(lblTitle.frame)+CGRectGetHeight(_txtVRecomandation.frame)/2.0f+10);
    _txtVRecomandation.text = [GlobalDirector ReplaceStringNull:[_JobDic valueForKey:@"RecommendationNoteInvoice"]];
    
    UIButton *btnSubmit =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(popUp.frame), 40)];
    btnSubmit.tag=101;
    [btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
    btnSubmit.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:18.0];
    [btnSubmit setBackgroundColor:[UIColor colorWithRed:30/255.0 green:124/255.0 blue:41/255.0 alpha:1.0]];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSubmit.center=CGPointMake(lblTitle.center.x, CGRectGetHeight(popUp.frame)-CGRectGetHeight(btnSubmit.frame)/2.0f);
    [btnSubmit addTarget:self action:@selector(ProceedToInvoice:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btnCrossRecomm=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCrossRecomm.frame=CGRectMake(-15, -15, 25, 25);
    btnCrossRecomm.center=CGPointMake(CGRectGetMaxX(popUp.frame),CGRectGetMinY(popUp.frame));
    [btnCrossRecomm setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
    [btnCrossRecomm addTarget:self action:@selector(cross:) forControlEvents:UIControlEventTouchUpInside];
    [btnCrossRecomm clipsToBounds];
    
    [popUp addSubview:lblTitle];
    [popUp addSubview:_txtVRecomandation];
    [popUp addSubview:btnSubmit];
    
    [bgview addSubview:popUp];
    [bgview addSubview:btnCrossRecomm];
    [self.view addSubview:bgview];
    
}

#pragma mark - Recommendation Press Method
- (IBAction)btnRecomandations
{
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Do you have any recommendations for us?"
                               message:@""
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
        [self YESPress:nil];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
        _txtRecomandation=@"";
        [self ProceedToInvoice:nil];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}




#pragma mark - Proceed to Invoice Press Method
-(IBAction)ProceedToInvoice:(id)sender
{
// new implementation
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"]) {
        
        if ([txtvNoteInvoice.text isEqualToString:@""])
                {
                    UIAlertController *alert= [UIAlertController
                                               alertControllerWithTitle:@"Please call the office on this 01992586311 to describe what has been done"
                                               message:@""
                                               preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action){
                        [self.navigationController popViewControllerAnimated:YES];
                        [alert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                }
        
        else  if ([txtvNoteInvoice.text isEqualToString:@"."])
           {
               UIAlertController *alert= [UIAlertController
                                          alertControllerWithTitle:@"Please call the office on this 01992586311 to describe what has done"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
               
               UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action){
                   [self.navigationController popViewControllerAnimated:YES];
                   [alert dismissViewControllerAnimated:YES completion:nil];
               }];
               
               [alert addAction:ok];
               [self presentViewController:alert animated:YES completion:nil];
           }
        else {
        UIButton *btn = (UIButton*)sender;
        if (btn.tag == 101 ) {

            
            if (_txtVRecomandation.text.length>0) {
                [self SetInvoiceNumberPress:nil];
            }else{
                [self showAlert:@"Please enter note." withTitle:@"info"];
            }
            
        }else{
            [self SetInvoiceNumberPress:nil];
        }
                }
        
    } else {
        UIButton *btn = (UIButton*)sender;
        if (btn.tag == 101 ) {

            
            if (_txtVRecomandation.text.length>0) {
                [self SetInvoiceNumberPress:nil];
            }else{
                [self showAlert:@"Please enter note." withTitle:@"info"];
            }
            
        }else{
            [self SetInvoiceNumberPress:nil];
        }
                }
    
}

#pragma mark- SetInvoiceNumberPress Cancel Method
-(IBAction)bgPopupTouched:(id)sender
{
    for (UIView *vw in [bgVw subviews])
    {
        [vw removeFromSuperview];
        
        
    }
    if (ImgSign.image==nil) {
        imgCheckSignature=0;
        
    }
    txtvNoteInvoice=nil;
    [bgVw removeFromSuperview];
    
    
}

#pragma mark- SetInvoiceNumberPress Save Method
-(void)SetInvoiceNumberPress:(id)sender
{
    if ([_txtVRecomandation.text isKindOfClass:[NSNull class]]) {
        _txtRecomandation=@"";
    }
    else
    {
        _txtRecomandation=_txtVRecomandation.text;
    }
    

    
    NSString *strselectInvoiceNo = [selectInvoiceNo.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    
    if (strselectInvoiceNo.length>0)
    {
        DLog(@"strselectInvoiceNo ::::%@",strselectInvoiceNo);
        NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
        NSString *post =[NSString stringWithFormat:@""];
        NSString *strInvoiceNote;
        
        if (![strselectInvoiceNo integerValue] || [strselectInvoiceNo integerValue]==-1 ) {
            strselectInvoiceNo = @"-1";
        }
        
        if (txtvNoteInvoice!=nil)
        {
            strInvoiceNote=txtvNoteInvoice.text;
        }
        else
        {
            strInvoiceNote=@"";
        }
        
        
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *urlString=[NSString stringWithFormat:@"%sSetInvoiceNumber?userToken=%@&jobId=%@&invoiceNumberId=%@&jobCompletetionNoteType=%@&jobCompletionNote=%@&userId=%@&jobRecommendationNote=%@",conn_url, (NSString *)[userdetails valueForKey:@"UserToken"],_jobID,strselectInvoiceNo,jobCompletetionNoteType,strInvoiceNote,[userdetails valueForKey:@"UserID"],_txtRecomandation];
        // urlString=[urlString stringByRemovingPercentEncoding];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //  urlString  =[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
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
        connSetInvoiceLink = [[NSURLConnection alloc]init];
        [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
            
            DLog(@"PostString=%@",urlString);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                if (error==nil)
                {
                    
                    
                    _responseData=[data mutableCopy];
                    [self connectionDidFinishLoading:connSetInvoiceLink];
                }
                else
                {
                }
            });
        }];
    }
    else
    {
        [self acceptPress:nil];
    }
}




#pragma mark - UITextView Delegate Method
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView !=_txtNoteDesComplete) {
        if([text isEqualToString:@"\n"])
        {
            [textView resignFirstResponder];
            
        }
    }
    
    
    
    
    return YES;
}
#pragma mark - UITextfield Delegate Method
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==selectInvoiceNo)
    {
        [textField resignFirstResponder];
        Activetxtfld=textField;
        
        [self GetDataForPoppup:Activetxtfld];
        
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField: (UITextField*) textField shouldChangeCharactersInRange: (NSRange) range replacementString: (NSString*)string
{
    
    if (textField.tag==1111) {
        
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange: range withString: string];
        
        // check string length
        NSInteger newLength = [newString length];
        // don't allow names longer than this
        
        // Find our Ok button
        UIResponder *responder = textField;
        Class uiacClass = [UIAlertController class];
        while (![responder isKindOfClass: uiacClass])
        {
            responder = [responder nextResponder];
        }
        UIAlertController *alert = (UIAlertController*) responder;
        UIAlertAction *okAction  = [alert.actions objectAtIndex: 0];
        
        // Dis/enable Ok button based on same-name
        BOOL duplicateName = NO;
        // <check for duplicates, here>
        if (newLength >=4)
        {
            okAction.enabled = !duplicateName;
        }
        else
        {
            okAction.enabled=NO;
            
        }
    }
    return YES;
}

#pragma mark - PopUp List & Fetch DropDown Master Method
-(void)popupList
{
    tblView=[[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMinX(Activetxtfld.frame),CGRectGetMaxY(Activetxtfld.frame)+2, CGRectGetWidth(Activetxtfld.frame), 0) style:UITableViewStylePlain];
    tblView.delegate=self;
    tblView.dataSource=self;
    [popUpVW addSubview:tblView];
    [tblView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [tblView.layer setBorderWidth: 2.0];
    [tblView.layer setCornerRadius:3.0f];
    [tblView.layer setMasksToBounds:YES];
    
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
        CGRect frame = tblView.frame;
        frame.size.height = [[UIScreen mainScreen]bounds].size.height/4.0f;
        tblView.frame = frame;
    }
                     completion:^(BOOL finished){
        DLog(@"Done!");
    }];
}
-(void)GetDataForPoppup:(UITextField *)fld
{
    if (fld==selectInvoiceNo){
        
        NSDictionary *dicNoVal=[[NSDictionary alloc]initWithObjects:@[@"No Invoice number",@"<null>",@"<null>"] forKeys:@[@"DisplayText",@"Extra",@"Value"]];
        arrFeedTblPopup =[[NSMutableArray alloc]initWithObjects:dicNoVal, nil];
        if (tblView!=nil)
        {
            [tblView removeFromSuperview];
            tblView=nil;
        }
        else
        {
            MBProgressHUD *hudprog =[MBProgressHUD showHUDAddedTo:popUpVW animated:YES];
            hudprog.labelText=@"Fetching available invoice no...";
            hudprog.labelFont=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
            [self FetchDropDowns:@"GetInvoiceNo"];
        }
    }
}



-(void)FetchDropDowns:(NSString *)key
{
    __block NSArray *arrVal;
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *urlString=[NSString stringWithFormat:@"%s%@?userToken=%@&jobId=%@",conn_url,key,(NSString *)[userdetails valueForKey:@"UserToken"],[_JobDic valueForKey:@"JobID"]];
    
    urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *returnData, NSURLResponse *response, NSError *error){
        
        DLog(@"PostString=%@",urlString);
        [MBProgressHUD hideAllHUDsForView:popUpVW animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error==nil) {
                if (returnData !=nil)
                {
                    NSMutableDictionary* temp;
                    NSError *error;
                    temp = [NSJSONSerialization JSONObjectWithData:returnData  options:NSJSONReadingMutableContainers error:&error];
                    if (!error)
                    {
                        if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
                        {
                            arrVal=(NSArray *)[temp objectForKey:@"DataResponses"];
                            NSMutableArray *arrFeed=[arrFeedTblPopup mutableCopy];
                            arrFeed=[[arrFeed arrayByAddingObjectsFromArray:arrVal] mutableCopy];
                            arrFeedTblPopup=arrFeed;
                            NSString *invId=[GlobalDirector ReplaceStringNull:[_JobDic valueForKey:@"InvoiceNumberID"]];
                            NSLog(@"invId >>>>>>>>>%@",invId);
                            
                            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"]&&invId.length==0)
                            {
                                
                                NSDictionary *dic=[arrFeedTblPopup objectAtIndex:0];
                                selectInvoiceNo.text=[GlobalDirector ReplaceStringNull:[dic valueForKey:@"DisplayText"]];
                                
                                
                            }else{
                                [self popupList];
                            }
                            [MBProgressHUD hideAllHUDsForView:popUpVW animated:YES];
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
            else
            {
                
            }
        });
    }];
}

#pragma mark TableView delegate datasource
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tblView)
    {
        return [arrFeedTblPopup count];
    }
    else{
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
        NSDictionary *dic=[arrFeedTblPopup objectAtIndex:indexPath.row];
        cell.textLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"DisplayText"]];
    }
    else
    {
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblView)
    {
        return 45;
    }
    else
    {
        return 0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblView)
    {
        NSDictionary *dic=[arrFeedTblPopup objectAtIndex:indexPath.row];
        Activetxtfld.text=[NSString stringWithFormat:@"  %@",[dic valueForKey:@"DisplayText"]];
        
        if (Activetxtfld==selectInvoiceNo)
        {
            NSLog(@"The active field is same as select invoice number field");
        }
        [tblView removeFromSuperview];
        tblView=nil;
    }
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
    NSMutableDictionary* temp;
    if (_responseData !=nil)
    {
        NSError *error;
        NSString *strRet = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
        
        DLog(@"Return String Response::::::::::%@",strRet);
        
        temp = [NSJSONSerialization JSONObjectWithData:_responseData  options:NSJSONReadingMutableContainers error:&error];
        if (!error)
        {
            if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
            {
                DLog(@"%@",temp);
                hud.hidden=YES;
                
                if (connection==connPostAgreement)
                {
                    [self agreementSigned:nil];
                }
                else if (connection==connGetInvoiceLink)
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [arrAgrLinks setObject:[temp valueForKey:@"ReturnValue"] forKey:@"Invoice"];
                    signURL= [temp valueForKey:@"SignatureUrl"]!=[NSNull null]?[temp valueForKey:@"SignatureUrl"]:@"";
                    [self viewPopUpCustomer1stAgreement];
                }
                else if (connection==connSetInvoiceLink)
                {
                    DLog(@"connSetInvoiceLink >>>>>>>> %@",temp);
                    
                    for (UIView *vw in [bgVw subviews])
                    {
                        [vw removeFromSuperview];
                    }
                    [bgVw removeFromSuperview];
                    // imgCheckSignature=YES;
                    if (imgCheckSignature==NO) {
                        imgCheckSignature=YES;
                        ImgSign.image=[UIImage imageNamed:@"SignViaPaperwork"];
                    }
                    
                    [self acceptPress:nil];
                }
                else if (connection==connEmailPost)
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [self showAlert:@"Email sent successfully." withTitle:@""];
                }
                else if (connection==connDropboxPost)
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [self showAlert:@"Dropbox upload successfully." withTitle:@""];
                }
                else
                {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }
            else
            {
                [self showAlert:[temp valueForKey:@"ResponseMessages"] withTitle:@""];
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
            }
        }
        else
        {
            NSLog([NSString stringWithFormat:@"%@", error]);
        }
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [self showAlert:@"No network connection. Please try again later."  withTitle:@"Error"];
    
}
#pragma mark- note selection after complete

- (IBAction)Complete:(UIButton *)sender {
    
    if (_txtNoteDesComplete.text.length>0 || _segNote.selectedSegmentIndex==2) {
        [_txtNoteDesComplete resignFirstResponder];
        [KLCPopup dismissAllPopups];
        // [btnGenerateInvoice addTarget:self action:@selector(btnRecomandations) forControlEvents:UIControlEventTouchUpInside];
        
        [self btnRecomandations];
    }else{
        
        _txtNoteDesComplete.layer.cornerRadius=8.0f;
        _txtNoteDesComplete.layer.masksToBounds=YES;
        _txtNoteDesComplete.layer.borderColor=[[UIColor redColor]CGColor];
        _txtNoteDesComplete.layer.borderWidth= 1.0f;
        
    }
    
}
- (IBAction)Cancel:(UIButton *)sender {
    _txtNoteDesComplete.text=@"";
    _segNote.enabled=YES;
}

-(void)ShowPopupComplete{
    
    _txtNoteDesComplete.layer.borderColor=[[UIColor clearColor]CGColor];
    _segNote.selectedSegmentIndex=2;
    _txtNoteDesComplete.tag=0;
    _txtNoteDesComplete.text=@"";
    _txtNoteDesComplete.editable=false;
    [_txtNoteDesComplete becomeFirstResponder];
    _segNote.enabled=NO;
    
    KLCPopup *pop=    [KLCPopup popupWithContentView:_viewNotePopup showType:KLCPopupShowTypeGrowIn dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    [pop show];
    
}

- (IBAction)SegmentClick:(UISegmentedControl *)sender {
    sender.enabled=NO;
    if (sender.selectedSegmentIndex != _txtNoteDesComplete.tag) {
        _txtNoteDesComplete.text=@"";
        _txtNoteDesComplete.tag = sender.selectedSegmentIndex;
        
        if (sender.selectedSegmentIndex==2) {
            [_txtNoteDesComplete resignFirstResponder];
            _txtNoteDesComplete.editable=NO;
        }else{
            _txtNoteDesComplete.editable=YES;
            [_txtNoteDesComplete becomeFirstResponder];
        }
    }
}
@end
