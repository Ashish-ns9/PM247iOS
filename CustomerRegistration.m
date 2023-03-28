//
//  CustomerRegistration.m
//  Partner Maintenance
//


#import "CustomerRegistration.h"
@class GlobalDirector;
@interface CustomerRegistration ()

@end

@implementation CustomerRegistration
@synthesize btnSlideMenu;
- (void)viewDidLoad {
    [super viewDidLoad];
    //_containerView.frame = [self view].frame;
    // Do any additional setup after loading the view from its nib.
    arrFeedTblPopup = [[NSArray alloc] init];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [_scrollVw addGestureRecognizer:singleTap];
    singleTap.delegate=self;
    
    arrOrgType = @[@"Small Organisation",@"Large Organisation",@"Residential"];
  

    [self SetupNavagation];
    
    _txtOrgType.text = [GlobalDirector ReplaceStringNull:[arrOrgType objectAtIndex:2]];
     strOrgTypeID = @"3";
   
   // _txtVAddress.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"]; //for testing
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Navagation
-(void)SetupNavagation {
    
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
        // Menu will get revealed
        // self.tapGestureRecognizer.enabled = YES;                 // Enable the tap gesture Recognizer
        //self.interactivePopGestureRecognizer.enabled = NO;        // Prevents the iOS7's pan gesture
        // self.topViewController.view.userInteractionEnabled = NO;       // Disable the topViewController's interaction
        
        //tab_browse.userInteractionEnabled=NO; //Table View Intercation NO
    }
    else if (position == FrontViewPositionLeft)
    {
        // Menu will close
        //self.tapGestureRecognizer.enabled = NO;
        //self.interactivePopGestureRecognizer.enabled = YES;
        // self.topViewController.view.userInteractionEnabled = YES;
        
        //tab_browse.userInteractionEnabled=YES;  //Table View Intercation YES
        
    }
}



#pragma mark - TEXTVIEW DELEGATES

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
CGPoint scrollPoint = CGPointMake(0, textView.frame.origin.y-100);
[_scrollVw setContentOffset:scrollPoint animated:YES];
    
    return YES;

}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    
    
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    actvtextbox=textView;
    
    //NSLog(@"Leangth%lu",(unsigned long)textView.text.length);
    
    return textView.text.length + (text.length - range.length) <= 200;
    
}


#pragma mark- UItextfield delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField ==_txtOrgName &&  [strOrgTypeID isEqualToString:@"3"]) {
        
       return NO; 
    }
    
    actvtextbox=textField;
    
    if (textField != _txtPopMob || textField != _txtMobile || textField != _txtPost || textField != _txtPopPost) {
        
        CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y-50);
        [_scrollVw setContentOffset:scrollPoint animated:YES];
        
        
    }
    
    

    
    if (textField==_txtPerType || textField==_txtOrgType || textField ==_txtTitle || textField==_txtGender) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [self.view endEditing:YES];
        [self popupList];
        return NO;
    }else  if (textField == _txtMobile) {
        
        [self ShowMobilePopUP];
        return NO;
    } else if (textField == _txtPost) {
        
       
        PostCodePopupController *post = [[PostCodePopupController alloc] initWithNibName:@"PostCodePopupController" bundle:nil];
        post.delegate=self;
        post.txtDelegate=_txtPost;
        [self presentViewController:post animated:YES completion:nil];
        
        
        return NO;
        
    }
else {
        
        [self handleTap];
    }
    
    
    
    
   return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
   
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


-(IBAction)backPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)ManadetoryFields:(UITextField*)field withText:(NSString*)str{
    
    UILabel *err=[[UILabel alloc]init];
    err.text = str;
    
    err.font=[UIFont systemFontOfSize:17.0];
    err.textColor=[UIColor redColor];
    [err sizeToFit];
    err.userInteractionEnabled=NO;
    
    field.rightViewMode = UITextFieldViewModeAlways;
    field.rightView =err;

}

- (IBAction)SubmitClick:(UIButton *)sender {
    
    if (_txtpwd.text.length==0) {
        _txtpwd.text=@"";
        _txtPwdCon.text=@"";
    }
    
    if (_txtPerType.text.length==0 || _txtOrgType.text.length==0  || _txtTitle.text.length==0 || _txtFirstName.text.length==0 || _txtLastName.text.length==0 || _txtEmail.text.length==0  || _txtGender.text.length==0 || _txtVAddress.text.length==0 || _txtTown.text.length==0 || _txtPost.text.length==0 || _txtcont.text.length==0  || strPerTypeID.length ==0 || strTitleTypeID.length ==0 || strOrgTypeID.length ==0  ) {
        
        [self ManadetoryFields:_txtPerType withText:@"*        "];
       // [self ManadetoryFields:_txtOrgType withText:@"*        "];
        [self ManadetoryFields:_txtTitle withText:@"*        "];
         [self ManadetoryFields:_txtGender withText:@"*        "];
        [self ManadetoryFields:_txtFirstName withText:@"*  "];
        [self ManadetoryFields:_txtLastName withText:@"*  "];
        [self ManadetoryFields:_txtEmail withText:@"*  "];
        //[self ManadetoryFields:_txtMobile withText:@"*  "];
        [self ManadetoryFields:_txtPost withText:@"*  "];
        [self ManadetoryFields:_txtcont withText:@"*  "];
        [self ManadetoryFields:_txtTown withText:@"*  "];
         _lblAddMan.hidden=NO;

        
        
        [self showAlert:@"Please fill all highlighted textfield." withTitle:@"Error"];
        
    }else if (![strOrgTypeID isEqualToString:@"3"] && _txtOrgName.text.length==0){
        
       
        [self showAlert:@"Please enter Organisation name." withTitle:@"Error"];
        
    }else if (![GlobalDirector emailValidation:_txtEmail.text]){
        
        _txtEmail.text=@"";
         [self showAlert:@"Please enter valid email address." withTitle:@"Error"];
        
    }else if (![_txtUserName.text isEqualToString:@""] && [_txtpwd.text isEqualToString:@""]){
        
        
        [self showAlert:@"Please enter Password. " withTitle:@"Error"];
        
    }
    else if (![_txtUserName.text isEqualToString:@""] && [_txtPwdCon.text isEqualToString:@""]){
        
        [self showAlert:@"Please enter  confirm Password. " withTitle:@"Error"];
        
    }
    else if (![_txtUserName.text isEqualToString:@""] &&![_txtpwd.text isEqualToString:_txtPwdCon.text]){
        
        _txtPwdCon.text=@"";
        
        [self showAlert:@"Password does not match. " withTitle:@"Error"];
        
    }else{
    
        if (_txtOrgName.text.length==0) {
            _txtOrgName.text=@"";
        }
    
    if (_txtPhone.text.length==0) {
        _txtPhone.text=@"";
    }
    
   
    
       
    if (_txtPhone.text.length==0) {
        _txtPhone.text=@"";
    }
        
        
        if (_txtVNote.text.length==0) {
            _txtVNote.text=@"";
        }
        
        
        if (_txtUserName.text.length==0) {
            _txtUserName.text=@"";
        }
        
        
        
        if (strGenderTypeID.length==0) {
            strGenderTypeID=@"";
        }
        

        if (_txtMobile.text.length==0) {
            _txtMobile.text=@"";
        }
    
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    
    [dict setObject:@"0" forKey:@"customerId"];
    [dict setObject:strPerTypeID forKey:@"personTypeId"];
    [dict setObject:strOrgTypeID forKey:@"organisationTypeId"];
    [dict setObject:_txtOrgName.text forKey:@"organisationName"];
    [dict setObject:_txtGender.text forKey:@"gender"];
    [dict setObject:_txtTitle.text forKey:@"title"];
    [dict setObject:strTitleTypeID forKey:@"titleID"];
    [dict setObject:_txtFirstName.text forKey:@"firstName"];
    
    [dict setObject:_txtLastName.text forKey:@"lastName"];
    [dict setObject:_txtMobile.text forKey:@"mobile"];
    [dict setObject:_txtPhone.text forKey:@"phoneNumber"];
    [dict setObject:_txtVNote.text forKey:@"notes"];
    [dict setObject:_txtVAddress.text forKey:@"addressLine1"];

    [dict setObject:_txtTown.text forKey:@"town"];
    [dict setObject:_txtPost.text forKey:@"postcode"];
    [dict setObject:_txtcont.text forKey:@"county"];
    [dict setObject:_txtEmail.text forKey:@"email"];
    [dict setObject:_txtUserName.text forKey:@"username"];
    [dict setObject:_txtpwd.text forKey:@"password"];
    
    GlobalDirector *globe = [GlobalDirector SharedDirector];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [globe SyncRequestPostWithJson:REQUEST_SaveCustomerProfile withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        
        NSLog(@"%@",result);
        
       
       
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            @try {
                
                NSDictionary *dict= [result valueForKey:@"SaveCustomerProfileResult"];
                
                int code = [[dict valueForKey:@"ResponseStatus"] intValue];
                
                if (code==1) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                   [self showAlert:[GlobalDirector ReplaceStringNull:[dict valueForKey:@"ResponseMessages"]] withTitle:@"Sorry!"];
                    
                }
                
                
            } @catch (NSException *exception) {
                _txtPost.text=@"";
                [self showAlert:@"There are some problem right now, try again later " withTitle:@"Sorry!"];
            }
        });
        
    }];
    
    }
   
}


- (IBAction)Cancel:(UIButton *)sender {
    
    
}

-(void)popupList
{
    arrFeedTblPopup = [[NSArray alloc] init];
    [tblView reloadData];
    
    if (tblView!=nil)
    {
        [self handleTap];
        [dataTask cancel];
        
    }
    
    else
    {
        
        
        
        UITextField *field = (UITextField*)actvtextbox;
        
        tblView=[[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMinX(field.frame),CGRectGetMaxY(field.frame)+2, CGRectGetWidth(field.frame), 0) style:UITableViewStylePlain];
        tblView.delegate=self;
        tblView.dataSource=self;
        [_scrollVw addSubview:tblView];
        
        
        
        [tblView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [tblView.layer setBorderWidth: 2.0];
        [tblView.layer setCornerRadius:3.0f];
        [tblView.layer setMasksToBounds:YES];
        
        [UIView animateWithDuration:0.35
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect frame = tblView.frame;
                             frame.size.height = self.view.frame.size.height/2.5f;
                             tblView.frame = frame;
                         }
                         completion:^(BOOL finished){
                             
                             if (actvtextbox == _txtOrgType) {
                                 [tblView reloadData];
                             }else if (actvtextbox == _txtPerType || actvtextbox == _txtTitle || actvtextbox ==_txtGender){
                                 [self FetchPopWebservice];
                             }
                             
                         }];
    }
    
    
    
    
}


-(void)FetchPopWebservice{
    
    arrFeedTblPopup = [[NSArray alloc] init];
    
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
 
    
    int idReq = 0;
    
    if (actvtextbox == _txtPerType){
        idReq = REQUEST_GetCustomerTypeList;
    }else if (actvtextbox == _txtTitle) {
        idReq = REQUEST_GetCustomerTitleList;
    }else {
        idReq = REQUEST_CustomerGenders;
    }

    
    
    GlobalDirector *globe = [GlobalDirector SharedDirector];
    
    [MBProgressHUD showHUDAddedTo:tblView animated:YES];
    
    [globe SyncRequestGet:idReq withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        
        NSLog(@"%@",result);
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
      
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:tblView animated:YES];
            @try {
                
              
                    int strValue= [[GlobalDirector ReplaceStringNull:[result valueForKey:@"ResponseStatus"]] intValue];
                    
                    if (strValue==1) {
                        
                        arrFeedTblPopup = [result valueForKey:@"DataResponses"];
                        
                    }else{
                         [self showAlert:@"There are some problem right now, try again later " withTitle:@"Sorry!"];
                    }
                    
                    
                
                
                
            } @catch (NSException *exception) {
               // _txtPost.text=@"";
                [self showAlert:@"There are some problem right now, try again later " withTitle:@"Sorry!"];
            } @finally {
                if (arrFeedTblPopup)
                {
                    [tblView reloadData];
                }
                
            }
        });
        
    }];
    
    
    
}



#pragma mark -  TableView Delegate Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (actvtextbox == _txtOrgType) {
        return [arrOrgType count];
    }else{
        return [arrFeedTblPopup count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"CELL";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    
    cell.textLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    cell.textLabel.textColor=[UIColor darkGrayColor];
   
    if (actvtextbox == _txtOrgType) {
        
       cell.textLabel.text = [GlobalDirector ReplaceStringNull:[arrOrgType objectAtIndex:indexPath.row]];
    
    }else{
        NSDictionary *tempDic=[arrFeedTblPopup objectAtIndex:indexPath.row];
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[tempDic valueForKey:@"DisplayText"]];
    }

    
    

    
    return cell;
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (actvtextbox == _txtOrgType) {
        
        _txtOrgType.text = [GlobalDirector ReplaceStringNull:[arrOrgType objectAtIndex:indexPath.row]];
        strOrgTypeID = [NSString stringWithFormat:@"%ld",(long)(indexPath.row+1)];
        
        
    }else if (actvtextbox == _txtPerType) {
        
        NSDictionary *tempDic=[arrFeedTblPopup objectAtIndex:indexPath.row];
        
        _txtPerType.text = [GlobalDirector ReplaceStringNull:[tempDic valueForKey:@"DisplayText"]];
        strPerTypeID = [GlobalDirector ReplaceStringNull:[tempDic valueForKey:@"Value"]];
        
    }else if (actvtextbox == _txtTitle) {
        
        NSDictionary *tempDic=[arrFeedTblPopup objectAtIndex:indexPath.row];
        
        _txtTitle.text = [GlobalDirector ReplaceStringNull:[tempDic valueForKey:@"DisplayText"]];
        strTitleTypeID = [GlobalDirector ReplaceStringNull:[tempDic valueForKey:@"Value"]];
        
    }else if (actvtextbox == _txtGender) {
        
        NSDictionary *tempDic=[arrFeedTblPopup objectAtIndex:indexPath.row];
        
        _txtGender.text = [GlobalDirector ReplaceStringNull:[tempDic valueForKey:@"DisplayText"]];
        strGenderTypeID = [GlobalDirector ReplaceStringNull:[tempDic valueForKey:@"Value"]];
        
    }else{
        ;
    }
    
    [self handleTap];
   
}

#pragma mark gesture recognizer delegates and action methods


-(void)handleTap
{
    
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
     
                     animations:^{
                         CGRect frame = tblView.frame;
                         frame.size.height = 0;
                         tblView.frame = frame;
                     }
                     completion:^(BOOL finished){
                        
                         [tblView removeFromSuperview];
                         tblView=nil;
                         
                     }];
    
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
   
    if ([touch.view isDescendantOfView:tblView]) {
        
        
        return NO;
    }
    
    return YES;
}


#pragma mark- mobile popup field

-(void)ShowMobilePopUP{
    
    _txtPopMob.text=@"";
    _mobileMainView.frame = [UIScreen mainScreen].bounds;
    _mobileMainView.alpha=0;
    
    
    [UIView animateWithDuration:0.2 animations:^{
            _mobileMainView.alpha=1;
          [self.view addSubview:_mobileMainView];
    }];
    
  
    [_txtPopMob becomeFirstResponder];
    
    
}

- (IBAction)ClickMobileVerify:(UIButton *)sender {
    
    if (_txtPopMob.text.length>0) {
        
     NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    [dict setObject:_txtPopMob.text forKey:@"mobile"];
    
    GlobalDirector *globe = [GlobalDirector SharedDirector];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [MBProgressHUD showHUDAddedTo:_mobileMainView animated:YES];
    [_txtPopMob resignFirstResponder];
    
    [globe SyncRequestGet:REQUEST_ValidateMobileNumber withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        
        NSLog(@"%@",result);
        
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:_mobileMainView animated:YES];
            @try {
                
                int code = [[result valueForKey:@"ResponseCode"] intValue];
                
                if (code==0) {
                    NSString *strValue= [GlobalDirector ReplaceStringNull:[result valueForKey:@"ReturnValue"]];
                    
                    if ([strValue isEqualToString:@"TRUE"]) {
                        
                       _txtMobile.text = _txtPopMob.text;
                        [self CrossClick:nil];
                        
                    }else{
                        
                        _txtMobile.text = @"";  [_txtPopMob becomeFirstResponder];
                        [self showAlert:@"Mobile number is not valid." withTitle:@"Sorry!"];
                    }
                    
                    
                }else{
                    _txtMobile.text = @"";  [_txtPopMob becomeFirstResponder];
                    [self showAlert:@"Mobile number is not valid." withTitle:@"Sorry!"];
                }
                
                
            } @catch (NSException *exception) {
                _txtMobile.text=@"";  [_txtPopMob becomeFirstResponder];
                [self showAlert:@"There are some problem right now, try again later " withTitle:@"Sorry!"];
            }
        });
        
        
        
        
    }];
    }else{
        [self showAlert:@"Please enter mobile number." withTitle:@"Error"];
    }


}

- (IBAction)CrossClick:(UIButton *)sender {
     [_txtPopMob resignFirstResponder];
    
    [UIView animateWithDuration:0.2 animations:^{
        _mobileMainView.alpha=1;
        [_mobileMainView removeFromSuperview];
        
    }];
    
}





#pragma mark- PostcodeDelegate
-(void)PostCodeAddressSelection:(NSMutableDictionary*)dict{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (dict) {
        @try {
            
            _txtPost.text=[GlobalDirector ReplaceStringNull:[dict valueForKey:@"postcode"]];
            _txtTown.text=[GlobalDirector ReplaceStringNull:[dict valueForKey:@"town"]];
            _txtcont.text=[GlobalDirector ReplaceStringNull:[dict valueForKey:@"county"]];
            _txtVAddress.text = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"address"]];
            
            NSString *com = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"company"]];
            
            if (com.length>0) {
                _txtOrgName.text = com;
               _txtOrgType.text = [arrOrgType objectAtIndex:0];
                strOrgTypeID =@"1";
                
            }

            
            
        } @catch (NSException *exception) {
            ;
        }
    }
    
    
}







@end











