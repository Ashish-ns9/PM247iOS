//
//  ProfileEdit.m
//  Partner Maintenance


#import "ProfileEdit.h"

@interface ProfileEdit ()

@end

@implementation ProfileEdit
@synthesize btnSlideMenu;

#pragma mark ViewWillAppear Method
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    for (UITextField *txtfield in [_scrolView subviews])
    {
        if ([txtfield isKindOfClass:[UITextField class]])
        {
            UITextField *txtfld=(UITextField *)txtfield;
            [txtfld setBorderStyle:UITextBorderStyleNone];
            txtfld.layer.borderWidth=0.5f;
            txtfld.layer.borderColor=[[UIColor lightGrayColor]CGColor];
            txtfld.layer.cornerRadius=0.0f;
            txtfld.backgroundColor=[UIColor whiteColor];
        }
    }
    
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    _txtFirstname.text=[NSString stringWithFormat:@"%@",[user valueForKey:@"FirstName"]];
    _txtMiddlename.text=[NSString stringWithFormat:@"%@",[user valueForKey:@"MiddleName"]];
    _txtLastname.text=[NSString stringWithFormat:@"%@",[user valueForKey:@"LastName"]];
    
    _txtAddress1.text=[NSString stringWithFormat:@"%@",[user valueForKey:@"AddressLine1"]];
    _txtAddress2.text=[NSString stringWithFormat:@"%@",[user valueForKey:@"AddressLine2"]];
    _txtAddress3.text=[NSString stringWithFormat:@"%@",[user valueForKey:@"AddressLine3"]];
    _txtCityTown.text=[NSString stringWithFormat:@"%@",[user valueForKey:@"Town"]];
    _txtCountry.text=[NSString stringWithFormat:@"%@",[user valueForKey:@"County"]];
    _txtPostcode.text=[NSString stringWithFormat:@"%@",[user valueForKey:@"Postcode"]];
    _txtMobileno.text=[NSString stringWithFormat:@"%@",[user valueForKey:@"PhoneNumber"]];
    _txtEmail.text=[NSString stringWithFormat:@"%@",[user valueForKey:@"Email"]];
    
    if (_btnEditUpdate.tag==10)
    {
        _txtFirstname.userInteractionEnabled=NO;
        _txtMiddlename.userInteractionEnabled=NO;
        _txtLastname.userInteractionEnabled=NO;
        
        _txtAddress1.userInteractionEnabled=NO;
        _txtAddress2.userInteractionEnabled=NO;
        _txtAddress3.userInteractionEnabled=NO;
        _txtCityTown.userInteractionEnabled=NO;
        _txtCountry.userInteractionEnabled=NO;
        _txtPostcode.userInteractionEnabled=NO;
        _txtMobileno.userInteractionEnabled=NO;
        _txtEmail.userInteractionEnabled=NO;
    }
    else
    {
        _txtFirstname.userInteractionEnabled=YES;
        _txtMiddlename.userInteractionEnabled=YES;
        _txtLastname.userInteractionEnabled=YES;
        _txtAddress1.userInteractionEnabled=YES;
        _txtAddress2.userInteractionEnabled=YES;
        _txtAddress3.userInteractionEnabled=YES;
        _txtCityTown.userInteractionEnabled=YES;
        _txtCountry.userInteractionEnabled=YES;
        _txtPostcode.userInteractionEnabled=YES;
        _txtMobileno.userInteractionEnabled=YES;
        _txtEmail.userInteractionEnabled=YES;
    }
}

#pragma mark ViewDidLoad Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    
    [_btnEditUpdate.layer setBorderColor: [[UIColor clearColor] CGColor]];
    [_btnEditUpdate.layer setBorderWidth: 0.5];
    [_btnEditUpdate.layer setCornerRadius:0.0f];
    [_btnEditUpdate.layer setMasksToBounds:YES];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.barTintColor=[UIColor whiteColor];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(Next)],
                           nil];
    [numberToolbar sizeToFit];
    _txtPostcode.inputAccessoryView=numberToolbar;
    _txtMobileno.inputAccessoryView=numberToolbar;
    
    _lblFirstname.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    _lblMiddlename.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    _lblLastname.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    _lblAddress1.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    _lblAddress2.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    _lblAddress3.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    _lblCityTown.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    _lblCountry.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    _lblPostcode.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    _lblMobileno.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    _lblEmail.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    
    _txtFirstname.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    _txtMiddlename.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    _txtLastname.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    _txtAddress1.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    _txtAddress2.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    _txtAddress3.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    _txtCityTown.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    _txtCountry.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    _txtPostcode.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    _txtMobileno.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    _txtEmail.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    
    _btnEditUpdate.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:21.0];
    _btnEditUpdate.tag=10;
    [_btnEditUpdate setTitle:@"Edit" forState:UIControlStateNormal];
    
    
    
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITextField Delegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString: (NSString*) string
{
    if (textField == _txtMobileno)
    {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range
                                                                 withString: string];
        if (text.length<=13)
        {
            if (text.length == 5&&![string isEqualToString:@""])
            {
                textField.text = [NSString stringWithFormat: @"%@  ", text];
                return NO;
            }
        }
        else
        {
            return NO;
        }
    }
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y-150);
    [_scrolView setContentOffset:scrollPoint animated:YES];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField==_txtEmail)
    {
        if ([self validateEmailWithString:_txtEmail.text]==NO)
        {
            
            [self showAlert:@"Email is invalid" withTitle:@""];
            
        }
        else{}
    }
    else{}
    return YES;
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==_txtEmail)
    {
        if (![_txtEmail.text isEqualToString:@""])
        {
            if ([self validateEmailWithString:_txtEmail.text]==NO)
            {
                [self showAlert:@"Email is invalid" withTitle:@""];
                
            }
            else{}
        }
    }
}
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
-(void)cancel
{
    [_txtPostcode resignFirstResponder];
    [_txtMobileno resignFirstResponder];
}
-(void)Next
{
    if (_txtPostcode)
    {
        [_txtMobileno becomeFirstResponder];
    }
    else if (_txtMobileno)
    {
        [_txtEmail becomeFirstResponder];
    }
}

#pragma mark Edit Update Button Press Method
-(IBAction)editupdatePress:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
    if (btn.tag==10)
    {
        btn.tag=11;
        [_btnEditUpdate setTitle:@"Update" forState:UIControlStateNormal];
        
        _txtFirstname.userInteractionEnabled=YES;
        _txtMiddlename.userInteractionEnabled=YES;
        _txtLastname.userInteractionEnabled=YES;
        _txtAddress1.userInteractionEnabled=YES;
        _txtAddress2.userInteractionEnabled=YES;
        _txtAddress3.userInteractionEnabled=YES;
        _txtCityTown.userInteractionEnabled=YES;
        _txtCountry.userInteractionEnabled=YES;
        _txtPostcode.userInteractionEnabled=YES;
        _txtMobileno.userInteractionEnabled=YES;
        _txtEmail.userInteractionEnabled=YES;
    }
    else
    {
        [self updateEditProfileService];
    }
}

- (IBAction)ChangePrflImg:(id)sender
{
    
    
}

#pragma mark Update Web service
-(void)updateEditProfileService
{
    
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString=[NSString stringWithFormat:@"%sCustomerProfileEdit?userToken=%@&UserID=%@&FullName=%@&Email=%@&UserName=%@&UserType=%@&StaffID=%@&IsMobile=%@&Title=%@&TitleID=%@&FirstName=%@&MiddleName=%@&LastName=%@&PhoneNumber=%@&Notes=%@&AddressLine1=%@&AddressLine2=%@&AddressLine3=%@&Town=%@&Postcode=%@&County=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[user valueForKey:@"UserID"],(NSString *)[user valueForKey:@"FullName"],_txtEmail.text,(NSString *)[user valueForKey:@"UserName"],(NSString *)[user valueForKey:@"UserType"],(NSString *)[user valueForKey:@"StaffID"],(NSString *)[user valueForKey:@"IsMobile"],(NSString *)[user valueForKey:@"Title"],(NSString *)[user valueForKey:@"TitleID"],_txtFirstname.text,_txtMiddlename.text,_txtLastname.text,_txtMobileno.text,(NSString *)[user valueForKey:@"Notes"],_txtAddress1.text,_txtAddress2.text,_txtAddress3.text,_txtCityTown.text,_txtPostcode.text,_txtCountry.text];
    
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
    
    connEditProfile = [[NSURLConnection alloc]init];
    
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error==nil) {
                _responseData=[data mutableCopy];
                [self connectionDidFinishLoading:connEditProfile];
            }
            else
            {
                [self showAlert:@"There are some problem right now, try again later" withTitle:@"Sorry!"];
            }
        });
    }];
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
        temp = [NSJSONSerialization JSONObjectWithData:_responseData  options:NSJSONReadingMutableContainers error:&error];
        if (!error)
        {
            if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
            {
                if (connection==connEditProfile)
                {
                    _btnEditUpdate.tag=10;
                    [_btnEditUpdate setTitle:@"Edit" forState:UIControlStateNormal];
                    
                    _txtFirstname.userInteractionEnabled=NO;
                    _txtMiddlename.userInteractionEnabled=NO;
                    _txtLastname.userInteractionEnabled=NO;
                    _txtAddress1.userInteractionEnabled=NO;
                    _txtAddress2.userInteractionEnabled=NO;
                    _txtAddress3.userInteractionEnabled=NO;
                    _txtCityTown.userInteractionEnabled=NO;
                    _txtCountry.userInteractionEnabled=NO;
                    _txtPostcode.userInteractionEnabled=NO;
                    _txtMobileno.userInteractionEnabled=NO;
                    _txtEmail.userInteractionEnabled=NO;
                    NSMutableDictionary *user1=[[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"] mutableCopy];
                    
                    [user1 setValue:_txtFirstname.text forKey:@"FirstName"];
                    [user1 setValue:_txtMiddlename.text forKey:@"MiddleName"];
                    [user1 setValue:_txtLastname.text forKey:@"LastName"];
                    [user1 setValue:_txtAddress1.text forKey:@"AddressLine1"];
                    [user1 setValue:_txtAddress2.text forKey:@"AddressLine2"];
                    [user1 setValue:_txtAddress3.text forKey:@"AddressLine3"];
                    [user1 setValue:_txtCityTown.text forKey:@"Town"];
                    [user1 setValue:_txtCountry.text forKey:@"County"];
                    [user1 setValue:_txtPostcode.text forKey:@"Postcode"];
                    [user1 setValue:_txtMobileno.text forKey:@"PhoneNumber"];
                    [user1 setValue:_txtEmail.text forKey:@"Email"];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:user1 forKey:@"userdetails"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self showAlert:@"Profile has been upadated successfully." withTitle:@""];
                }
                else{}
            }
            else
            {
                if (connection==connEditProfile)
                {
                    [self showAlert:@"Please try again later."  withTitle:@""];
                    
                }
            }
        }
    }
    else
    {
        return;
    }
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [self showAlert:@"No network connection. Please try again later."  withTitle:@"Error"];
    
}
@end
