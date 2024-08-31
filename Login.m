//
//  Login.m
//  Partner Maintenance
//
//  Created by SANDIPAN on 13/10/14.
//  Copyright (c) 2014 SANDIPAN. All rights reserved.
//

#import "Login.h"
//*********

//**********
AppDelegate *app;

@interface Login ()
{
  
}

@end

@implementation Login
@synthesize btnForgotPassword,btnLogin,txtPassword,txtUsername;
@synthesize managedObjectContext,activity;


-(IBAction)rememberMePress:(id)sender
{
    if (_btnRememberMe.selected==YES)
    {
        _btnRememberMe.selected=NO;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"rememberme"];
        [_btnRememberMe setImage:[UIImage imageNamed:@"off_tab"] forState:UIControlStateNormal];
    }
    else
    {
        _btnRememberMe.selected=YES;
        [[NSUserDefaults standardUserDefaults]setValue:txtUsername.text forKey:@"username"];
        [[NSUserDefaults standardUserDefaults]setValue:txtPassword.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"rememberme"];
        [_btnRememberMe setImage:[UIImage imageNamed:@"on_tab"] forState:UIControlStateSelected];
    }
}

-(void)RememberMEData
{
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"username"])
    {
        txtUsername.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    }
    else
    {
        txtUsername.text=@"";
    }
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"password"])
    {
        txtPassword.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"password"];
    }
    else
    {
        txtPassword.text=@"";
    }
}


#pragma mark - viewDidLoad  Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self SetViewDefaultProperty];
    
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    DLog(@"%@", user);
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"])
    {
        
        dicUserDetails=(NSMutableDictionary *)[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
        [self navToDashBoard];
    }
    _lblUsernamebg.layer.borderWidth=0.5f;
    _lblUsernamebg.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _lblUsernamebg.layer.cornerRadius=0.0f;
    _lblUsernamebg.backgroundColor=[UIColor whiteColor];
    _lblpasswordbg.layer.borderWidth=0.5f;
    _lblpasswordbg.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _lblpasswordbg.layer.cornerRadius=0.0f;
    _lblpasswordbg.backgroundColor=[UIColor whiteColor];
    btnLogin.layer.borderWidth=0.5f;
    btnLogin.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    btnLogin.layer.cornerRadius=0.0f;
    count=0;

}

//NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];

#pragma mark - SetViewDefaultProperty Method
-(void)SetViewDefaultProperty
{
    self.navigationController.navigationBarHidden=YES;
    self.title=@"Login";
    
    app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    activity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activity.hidden=YES;
    dicUserDetails=[[NSMutableDictionary alloc]init];
}

#pragma mark - viewWillAppear Method
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.view.alpha=1.0f;
    
    //----------------------- Remember Me Functionality --------------------
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"rememberme"])
    {
        _btnRememberMe.selected=YES;
        [self RememberMEData];
    }
    else
    {
        _btnRememberMe.selected=NO;
    }
    //-----------------------------------------------------------------------
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    if (app.locationManager) {
        [app.locationManager stopUpdatingLocation];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Press FORGOT PASSWORD Method
-(IBAction)forgotpasswordPress:(id)sender
{
    [connLogin cancel];
    connLogin = nil;
    [activity stopAnimating];
    activity.hidden=YES;
    [btnLogin setTitle:@"Login" forState:UIControlStateNormal];
    [self popUpViewForgotPassword];
}
-(void)popUpViewForgotPassword
{
    mainBg = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    mainBg.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    [self .view addSubview:mainBg];
    
    viewForgotPassword = [[UIView alloc] initWithFrame:CGRectMake(0,0,280.0f,200.0f)];
    viewForgotPassword.center=CGPointMake(self.view.frame.size.width/2.0f, txtPassword.center.y);
    [viewForgotPassword.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [viewForgotPassword.layer setBorderWidth: 0.7];
    [viewForgotPassword.layer setCornerRadius:3.0f];
    [viewForgotPassword.layer setMasksToBounds:YES];
    viewForgotPassword.backgroundColor =[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    
    lblPopUpTitle = [[UILabel alloc] initWithFrame:CGRectMake(16,20,220,25)];
    lblPopUpTitle.text = @"Forgot Password ?";
    lblPopUpTitle.font = [UIFont fontWithName:@"TheSansArabic-Bold" size:15.0];
    lblPopUpTitle.textAlignment = NSTextAlignmentCenter;
    lblPopUpTitle.center=CGPointMake(CGRectGetWidth(viewForgotPassword.frame)/2.0f, lblPopUpTitle.center.y);
    lblPopUpTitle.textColor=[UIColor darkGrayColor];
    lblPopUpTitle.backgroundColor = [UIColor clearColor];
    
    
    txtPopUpEmailAddress = [[MyTextField alloc] initWithFrame:CGRectMake(0,55,CGRectGetWidth(viewForgotPassword.frame)-10,30)];
    txtPopUpEmailAddress.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:16.0];
    txtPopUpEmailAddress.center=CGPointMake(CGRectGetWidth(viewForgotPassword.frame)/2.0f, txtPopUpEmailAddress.center.y);
    txtPopUpEmailAddress.textColor=[UIColor darkGrayColor];
    txtPopUpEmailAddress.delegate = self;
    txtPopUpEmailAddress.placeholder=@"Enter your username";
    [txtPopUpEmailAddress.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [txtPopUpEmailAddress.layer setBorderWidth: 0.5];
    [txtPopUpEmailAddress.layer setCornerRadius:0.0f];
    txtPopUpEmailAddress.backgroundColor=[UIColor whiteColor];
    
    btnOk = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOk setTitle:@"OK" forState:UIControlStateNormal];
    btnOk.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:15.0];
    [btnOk setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnOk setBackgroundImage:[UIImage imageNamed:@"loginbutton"] forState:UIControlStateNormal];
    btnOk.frame = CGRectMake(15,120,103,30);
    btnOk.center=CGPointMake(10+CGRectGetWidth(btnOk.frame)/2.0f, btnOk.center.y);
    [btnOk addTarget:self action:@selector(pressOk) forControlEvents:UIControlEventTouchUpInside];
    
    
    btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    btnCancel.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:15.0];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancel setBackgroundColor:[UIColor colorWithRed:214/255.0 green:100/255.0 blue:4/255.0 alpha:1.0]];
    btnCancel.frame = CGRectMake(135,120,103,30);
    btnCancel.center=CGPointMake(CGRectGetWidth(viewForgotPassword.frame)-CGRectGetWidth(btnCancel.frame)/2.0f-10, btnCancel.center.y);
    [btnCancel addTarget:self action:@selector(pressCancel) forControlEvents:UIControlEventTouchUpInside];
    [mainBg addSubview:viewForgotPassword];
    [viewForgotPassword addSubview:lblPopUpTitle];
    [viewForgotPassword addSubview:txtPopUpEmailAddress];
    [viewForgotPassword addSubview:btnOk];
    [viewForgotPassword addSubview:btnCancel];
    //[self.view addSubview:viewForgotPassword];
}
-(void)pressCancel
{
    [mainBg removeFromSuperview];
    mainBg=nil;
    [txtPopUpEmailAddress setText:@""];
    
}
-(void)pressOk
{
    NSString *rawString = [txtPopUpEmailAddress text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    if ([trimmed length] == 0) {
        // Text was empty or only whitespace.
        [self showAlert:@"Username should not be empty " withTitle:@"Wait!!"];
    }
    else
    {
        activity.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
        activity.center=CGPointMake(viewForgotPassword.frame.size.width/2.0f, viewForgotPassword.frame.size.height/2.0f);
        activity.color=[UIColor grayColor];
        [activity startAnimating];
        viewForgotPassword.userInteractionEnabled=NO;
        
        [viewForgotPassword addSubview:activity];
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            DLog(@"There IS NO internet connection");
            [self showAlert:@"Check your Internet connection" withTitle:@"Connection Problem!"];
            
        }
        else
        {
            DLog(@"There IS internet connection");
            [self forgotpasswordrocess];
        }
    }
}


#pragma mark - forgotpasswordrocess WebService Method
-(void)forgotpasswordrocess
{
    
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString=[NSString stringWithFormat:@"%sForgotPassword?&userName=%@",conn_url,txtPopUpEmailAddress.text];
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
    
    connForgetPass = [[NSURLConnection alloc] init];
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        DLog(@"PostString=%@",urlString);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error==nil) {
                self->_responseData=[data mutableCopy];
                [self connectionDidFinishLoading:connForgetPass];
            }
            else
            {
            }
        });
    }];
}
#pragma mark - loginPress Method
-(IBAction)loginPress:(UIButton *)sender
{
    
    if ([self InternetConnectionAvailable]==NO)
    {
        DLog(@"There IS NO internet connection");
        [self showAlert:@"Check your Internet connection" withTitle:@"Connection Error!"];
    }
    else if (txtUsername.text.length==0)
    {
        [txtUsername becomeFirstResponder];
        [self showAlert:@"Enter Username" withTitle:@""];
    }
    else if (txtPassword.text.length==0)
    {
        [txtPassword becomeFirstResponder];
        [self showAlert:@"Enter Password" withTitle:@""];
    }
    else
    {
        DLog(@"There IS internet connection");
        activity.center=CGPointMake(sender.frame.size.width/2.0f, sender.frame.size.height/2.0f);
        activity.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
        [sender addSubview:activity];
        activity.hidden=NO;
        [activity startAnimating];
        [self.view endEditing:YES];
        [sender setTitle:@"" forState:UIControlStateNormal];
        [self ChkLoginData];
    }
}
#pragma mark - ChkLoginData Method
-(void)ChkLoginData
{
    
    NSString *token =  [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString=[NSString stringWithFormat:@"%slogin?userName=%@&password=%@&deviceId=%@&device=iOS",conn_url,txtUsername.text,txtPassword.text,token];

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
    connLogin = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connLogin start];
    
}

#pragma mark - checkLoginFromOffline Method
-(void)checkLoginFromOffline
{
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"OfflineChk"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    if (_offlinechk.isOn==YES)
    {
        
        
        DLog(@"Offline chcking.................");
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"OfflineChk"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        managedObjectContext=[app managedObjectContext];
        NSError *error;
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"Partner_UserDetails" inManagedObjectContext:managedObjectContext];
        [request setEntity:entity];
        
        
        
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(user_name = %@)",txtUsername.text];
        [request setPredicate:predicate];
        
        NSArray *arrFetchedObjects;
        arrFetchedObjects=[managedObjectContext executeFetchRequest:request error:&error];
        
        for (NSManagedObject *fetchedObject in arrFetchedObjects)
        {
            dicUserDetails=[[NSMutableDictionary alloc] init];
            
            [dicUserDetails setObject:[fetchedObject valueForKey:@"user_id"] forKey:@"user_id"];
            [dicUserDetails setObject:[fetchedObject valueForKey:@"user_name"] forKey:@"user_name"];
            [dicUserDetails setObject:[fetchedObject valueForKey:@"user_role"] forKey:@"user_role"];
        }
        [self navToDashBoard];
    }
    else
    {
        DLog(@"online Ckcninggg.....................");
        [self ChkLoginData];
    }
    
}

-(void)navToDashBoard
{
    
    /*
     1 SuperAdmin
     2 Admin
     3 Office Staff
     4 Engineer
     5 Engineer Manager
     6 Customer
     */
    
    self.view.alpha=0.0f;
    NSString *username=@"UserName";//
    NSString *userid=@"user_id";
    NSString *userRole=@"UserType";//
    
    NSString *customer=@"6";//
    NSString *manager=@"5";
    NSString *engg=@"4";//
    
    if (_offlinechk.isOn==YES)
    {
        username=@"user_name";//UserName
        userid=@"user_id";
        userRole=@"user_role";//UserType
        
        customer=@"cu";
        manager=@"fm";
        engg=@"fe";
    }
    
    DLog(@"%@",dicUserDetails);


    
    if ([[dicUserDetails valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"]||[txtUsername.text isEqualToString:[dicUserDetails valueForKey:@"user_name"]])
    {
        id userrole=[dicUserDetails objectForKey:userRole];
        if ([userrole isKindOfClass:[NSNumber class]])
        {
            userrole=[NSString stringWithFormat:@"%@",userrole];
        }
    http://pm247uat-mobile.azurewebsites.net/PartnersService.svc/GetWorkNumber?UserToken=i[PLUS]y5npXPnXksiLDAAy5b1djOiif3H12ZOTV1NTXpJHpzp7i6At[SLASH]lf[SLASH]hnFRCSoc57st6Xn[PLUS]NLHZ1cRHoFKri[SLASH]TEnCrBvJzE6tktFAwCljR99s3IAr3AOhQeGq1Zb9KSRN79fBcqS4[SLASH]5I7KRW4eoILYpUSA5rSka6gThXLEw[PLUS]nVUsPJJFKm2dmjDjJU38Zfl66KNHmbDJ26yQSwkUyay5sgvpmiXjm[PLUS]S[SLASH]g2FwnL[SLASH]sqPxNVaExIAY0SNpxQcwVOznYsIWKGkRKq6difJHsmwc3[PLUS]BAzAd4wX58glJsDeVdPa4cQ[SLASH]f4uLJRZCqUxobjlKWO5CHc4K[PLUS]67R6bc2UCuprErLYxLvamo[SLASH]w5Ie96nFTO0njTQ=&staffid=314      DLog(@"userrole :%@",userrole);
        
        if ([userrole isEqualToString:customer])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"cu" forKey:@"LoggedUser"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:dicUserDetails forKey:@"userdetails"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self gotoDasshhh];
            
        }
        else if ([userrole isEqualToString:engg])
        {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"fe" forKey:@"LoggedUser"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setObject:dicUserDetails forKey:@"userdetails"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self gotoDasshhh];
        }
        else if ([userrole isEqualToString:manager])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"fm" forKey:@"LoggedUser"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setObject:dicUserDetails forKey:@"userdetails"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self gotoDasshhh];
        }
        else
        {
            
            self.view.alpha=1.0f;
            [self showAlert:@"Invalid Login" withTitle:@"Error!"];
            [btnLogin setTitle:@"Login" forState:UIControlStateNormal];
        }
    }
    else
    {
        
        self.view.alpha=1.0f;
        [self showAlert:@"Invalid user login" withTitle:@"Error!"];
        [btnLogin setTitle:@"Login" forState:UIControlStateNormal];
    }
}


#pragma mark - Go To DashBoard Method
-(void)gotoDasshhh
{
    
    DashBoard *obj;
    CGSize screenSize=[[UIScreen mainScreen]bounds].size;
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if (screenSize.height==568.0f)
        {
            obj=[[DashBoard alloc] initWithNibName:@"DashBoard" bundle:Nil];
        }
        else if(screenSize.height == 667.0f)
        {
            obj=[[DashBoard alloc] initWithNibName:@"DashBoard6" bundle:Nil];
        }
        else if(screenSize.height == 736.0f)
        {
            obj=[[DashBoard alloc] initWithNibName:@"DashBoard6" bundle:Nil];
        }
        else
        {
            obj=[[DashBoard alloc] initWithNibName:@"DashBoard4S" bundle:Nil];
        }
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        //[[self navigationController] popViewControllerAnimated:NO];
        [self.navigationController pushViewController:obj animated:NO];
    }
    else
    {
        //iPad
    }
}
#pragma mark - textfield Delegate Method
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==txtPassword)
    {
        activity.center=CGPointMake(btnLogin.frame.size.width/2.0f, btnLogin.frame.size.height/2.0f);
        activity.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
        [btnLogin addSubview:activity];
        activity.hidden=NO;
        [activity startAnimating];
        
        [self.view endEditing:YES];
        [btnLogin setTitle:@"" forState:UIControlStateNormal];
        
        [self ChkLoginData];
    }
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
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
    NSMutableDictionary* temp;
    if (_responseData !=nil)
    {
        NSError *error;
        temp = [NSJSONSerialization JSONObjectWithData:_responseData  options:NSJSONReadingMutableContainers error:&error];
        if (!error)
        {
            if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
            {
                if (connection==connLogin)
                {
                   
                    if(count==0)
                    {
                        
                    dicUserDetails=temp;
                    }
                    if(count==1)
                    {
                    dicUserDetailsafterotp = temp;
                    NSDictionary *user= dicUserDetailsafterotp;
                    returnvalue = (NSString *)[user valueForKey:@"ReturnValue"];
                  
                        if (txtPopUpEmailAddress.text== returnvalue)
                        {
                            [self navToDashBoard];
                        }
                    }
                    
                    if(count==0)
                    {
                        [self navToDashBoard];
                    
                       // [self popUpViewTwoFactorAuthentication];
                    }
                    
                }
                else if (connection==connForgetPass)
                {
                    [self showAlert:[GlobalDirector ReplaceStringNull:[temp valueForKey:@"Message"]] withTitle:@"info"];
                    [self pressCancel];
                }
                else
                {
                }
            }
            else
            {
                DLog(@"JSONObjectWithData error: %@", error);
                if (connection==connLogin)
                {
                    
                    [self showAlert:[GlobalDirector ReplaceStringNull: [temp valueForKey:@"ResponseMessages"]] withTitle:@"Error!"];
                    
                }
                else if (connection==connForgetPass)
                {
                    [self showAlert:@"Username does not exist." withTitle:@"Error!"];
                }
                
                viewForgotPassword.userInteractionEnabled=YES;
                [btnLogin setTitle:@"Login" forState:UIControlStateNormal];
                [activity stopAnimating];
                activity.hidden=YES;
            }
        }
    }
    else
    {
        return;
    }
    
    [activity stopAnimating];
    activity.hidden=YES;
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [self showAlert:@"No network connection. Please try again later."  withTitle:@"Error"];
}
// Adding new functionality  in app
-(void)popUpViewTwoFactorAuthentication
{

    mainBg = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    mainBg.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    [self .view addSubview:mainBg];

    viewForgotPassword = [[UIView alloc] initWithFrame:CGRectMake(0,0,280.0f,200.0f)];
    viewForgotPassword.center=CGPointMake(self.view.frame.size.width/2.0f, txtPassword.center.y);
    [viewForgotPassword.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [viewForgotPassword.layer setBorderWidth: 0.7];
    [viewForgotPassword.layer setCornerRadius:3.0f];
    [viewForgotPassword.layer setMasksToBounds:YES];
    viewForgotPassword.backgroundColor =[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];

    lblPopUpTitle = [[UILabel alloc] initWithFrame:CGRectMake(16,20,220,25)];
    lblPopUpTitle.text = @"Two factor authentication";
    lblPopUpTitle.font = [UIFont fontWithName:@"TheSansArabic-Bold" size:15.0];
    lblPopUpTitle.textAlignment = NSTextAlignmentCenter;
    lblPopUpTitle.center=CGPointMake(CGRectGetWidth(viewForgotPassword.frame)/2.0f, lblPopUpTitle.center.y);
    lblPopUpTitle.textColor=[UIColor darkGrayColor];
    lblPopUpTitle.backgroundColor = [UIColor clearColor];
    // we define second label for again sending code
    lblPopUpTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(16,70,220,25)];
    lblPopUpTitle1.text = @"did not recieve otp?";
    lblPopUpTitle1.font = [UIFont fontWithName:@"TheSansArabic-Bold" size:10.0];
    lblPopUpTitle1.textAlignment = NSTextAlignmentCenter;
    lblPopUpTitle1.center=CGPointMake(CGRectGetWidth(viewForgotPassword.frame)/2.0f, lblPopUpTitle1.center.y/1.2f);
    lblPopUpTitle1.textColor=[UIColor darkGrayColor];
    lblPopUpTitle1.backgroundColor = [UIColor clearColor];
    txtPopUpEmailAddress = [[MyTextField alloc] initWithFrame:CGRectMake(0,55,CGRectGetWidth(viewForgotPassword.frame)-10,30)];
    txtPopUpEmailAddress.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:16.0];
    txtPopUpEmailAddress.center=CGPointMake(CGRectGetWidth(viewForgotPassword.frame)/2.0f, txtPopUpEmailAddress.center.y);
    txtPopUpEmailAddress.textColor=[UIColor darkGrayColor];
    txtPopUpEmailAddress.delegate = self;
    [txtPopUpEmailAddress.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [txtPopUpEmailAddress.layer setBorderWidth: 0.5];
    [txtPopUpEmailAddress.layer setCornerRadius:0.0f];
    txtPopUpEmailAddress.backgroundColor=[UIColor whiteColor];
    
    NSDictionary *user= dicUserDetails;
    DLog(@"%@",user);
    
    NSString *phoneNumber1 =  (NSString *)[user valueForKey:@"PhoneNumber"];
    NSString *trimmedNumber =  [phoneNumber1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([trimmedNumber hasPrefix:@"0"] && [trimmedNumber length] > 1) {
        trimmedNumber = [trimmedNumber substringFromIndex:1];
    }
 
    if (count==0)
    {
        
    txtPopUpEmailAddress.text = trimmedNumber;
    txtPopUpEmailAddress.userInteractionEnabled = NO;
       userPhoneNumber = trimmedNumber;
        count =1;
    }
    returnvalue = (NSString *)[user valueForKey:@"ReturnValue"];
    
    btnOk = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOk setTitle:@"Send Otp" forState:UIControlStateNormal];
    btnOk.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:15.0];
    [btnOk setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnOk setBackgroundImage:[UIImage imageNamed:@"loginbutton"] forState:UIControlStateNormal];
    btnOk.frame = CGRectMake(15,120,103,30);
    btnOk.center=CGPointMake(10+CGRectGetWidth(btnOk.frame)/2.0f, btnOk.center.y);
    [btnOk addTarget:self action:@selector(pressSendOtP) forControlEvents:UIControlEventTouchUpInside];
    
    btnOk1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOk1 setTitle:@"Login" forState:UIControlStateNormal];
    btnOk1.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:15.0];
    [btnOk1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnOk1 setBackgroundImage:[UIImage imageNamed:@"loginbutton"] forState:UIControlStateNormal];
    btnOk1.frame = CGRectMake(15,120,103,30);
    btnOk1.center=CGPointMake(10+CGRectGetWidth(btnOk1.frame)/2.0f, btnOk1.center.y);
    [btnOk1 addTarget:self action:@selector(pressnavafterMatchingOtp)
     forControlEvents:UIControlEventTouchUpInside];
    

    btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setTitle:@" Resend Otp " forState:UIControlStateNormal];
    btnCancel.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:15.0];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancel setBackgroundColor:[UIColor colorWithRed:214/255.0 green:100/255.0 blue:4/255.0 alpha:1.0]];
    btnCancel.frame = CGRectMake(125,120,103,30);
    btnCancel.center=CGPointMake(CGRectGetWidth(viewForgotPassword.frame)-CGRectGetWidth(btnCancel.frame)/2.0f-10, btnCancel.center.y);
    [btnCancel addTarget:self action:@selector(resendcode) forControlEvents:UIControlEventTouchUpInside];
    [mainBg addSubview:viewForgotPassword];
    [viewForgotPassword addSubview:lblPopUpTitle];
    [viewForgotPassword addSubview:lblPopUpTitle1];
    [viewForgotPassword addSubview:txtPopUpEmailAddress];
    [viewForgotPassword addSubview:btnOk];
    [viewForgotPassword addSubview:btnOk1];
    [viewForgotPassword addSubview:btnCancel];
    //[self.view addSubview:viewForgotPassword];
    btnCancel.hidden = true;
    btnOk1.hidden=true;
}
-(void)pressSendOtP
{

    [self twoFactorAuthenticationProcess];
    
    txtPopUpEmailAddress.text = @"";

    txtPopUpEmailAddress.placeholder = @" Please enter otp";
    txtPopUpEmailAddress.userInteractionEnabled = YES;
    btnOk.hidden=YES;
    btnOk1.hidden=false;

    timeLeft = 30;
    //Fire this timer every second.
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                    selector:@selector(reduceTimeLeft:)
                                                        userInfo:nil
                                                         repeats:YES];




}
-(void)resendcode
{

    [self twoFactorAuthenticationProcess];
    
}
-(void)pressnavafterMatchingOtp
{
    
    if (txtPopUpEmailAddress.text.length==0)
    {
        [txtPopUpEmailAddress becomeFirstResponder];
        [self showAlert:@"Please enter Otp" withTitle:@""];
    }
    else if(txtPopUpEmailAddress.text != returnvalue)
    {
        [txtPopUpEmailAddress becomeFirstResponder];
        [self showAlert:@"Invalid Otp" withTitle:@"Error"];
    }
    else{
    [self connectionDidFinishLoading:connLogin];
    }
    
}
- (void)reduceTimeLeft:(NSTimer *)timer {

    //Countown timeleft by a second each time this function is called
    timeLeft--;
   
    if (timeLeft == 0)
    {

        btnOk.hidden = YES;
        btnCancel.hidden = false;
        
        


        [self.timer invalidate];
    }
    NSLog(@"Time Left In Seconds: %i",timeLeft);
}
  
#pragma mark - forgotpasswordrocess WebService Method
-(void)twoFactorAuthenticationProcess
{

    
    NSDictionary *user= dicUserDetails;
    DLog(@"%@",user);
   NSString *phonenumber = userPhoneNumber;
   NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString=[NSString stringWithFormat:@"%sSend2FactorAuthorizationSms?UserToken=%@&phonenumber=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],phonenumber];

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

@end














































