//
//  Messages.m
//  Partner Maintenance
//


#import "Messages.h"
AppDelegate *app;

@interface Messages ()
{
    NSDictionary *userdetails;
    UIRefreshControl * refreshControl;
}
@end

@implementation Messages
@synthesize btnSlideMenu;






#pragma mark - Viewdidload Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    self.navigationController.navigationBarHidden=YES;
    app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _tblMessageList.backgroundView=nil;
    _tblMessageList.backgroundColor=[UIColor clearColor];
    _tblMessageList.separatorColor=[UIColor clearColor];
    
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
    
    arrSelectedRecipients=[[NSMutableArray alloc]init];
    arrMessageList=[[NSMutableArray alloc]init];
    
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(FetchMessages) forControlEvents:UIControlEventValueChanged];
    [_tblMessageList addSubview:refreshControl];
    _tblMessageList.alwaysBounceVertical = YES;

    
    
    [self FetchMessages];
    
   
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [connFetchMessage cancel];
    connFetchMessage=nil;
    [self.dataTask cancel];
    
}



#pragma mark - SWRevealViewController Delegate Methods
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if (position == FrontViewPositionLeftSide)
    {
        ;
    }
    else if (position == FrontViewPositionLeft)
    {
        ;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FetchMessage Method
-(void)FetchMessages
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        DLog(@"There IS NO internet connection");
        [self showAlert:@"Check your Internet connection" withTitle:@"Connection Error!"];
    } else {
        
        [self.dataTask cancel];
        
        DLog(@"There IS internet connection");
    
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *urlString;
    NSString *post =[NSString stringWithFormat:@""];
    
    urlString=[NSString stringWithFormat:@"%sGetJobWiseMessage?userToken=%@&userId=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[user valueForKey:@"UserID"]]; //StaffID
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
        request.timeoutInterval = 300;
    DLog(@"PostString=%@",request);
    
        connIdentifier=@"connFetchMessage";
        
        
   MBProgressHUD * hudd=[MBProgressHUD showHUDAddedTo:self.tblMessageList animated:YES];
    hudd.labelText=@"Loading messages...";
        
        [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _responseData=[data mutableCopy];
                [self connectionDidFinishLoading:connFetchMessage];
            });
            
        }];
        
        
        
    }
    
    
    
}

#pragma mark - Textfield Delegate Method
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [txtUserType resignFirstResponder];
    [txtUserName resignFirstResponder];
    Activetxtfld=textField;
    if (textField==txtUserName&&txtUserType.text.length==0)
    {
        [self showAlert:@"Select User type to get user list " withTitle:@""];
        
    }
    else
    {
        [self popupList];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - TEXTVIEW DELEGATES
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}

#pragma mark - Pop Up list Fetch / Show Method
-(void)popupList
{
    arrFeedTblPopup= [self GetDataForPoppup:Activetxtfld];
    
    
    if (tblView!=nil)
    {
        [tblView removeFromSuperview];
        tblView=nil;
    }
    
    else
    {
        tblView=[[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMinX(Activetxtfld.frame)+3,CGRectGetMaxY(Activetxtfld.frame)+5, CGRectGetWidth(Activetxtfld.frame), 0) style:UITableViewStylePlain];
        tblView.delegate=self;
        tblView.dataSource=self;
        [bgVw addSubview:tblView];
        
        
        
        [tblView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [tblView.layer setBorderWidth: 2.0];
        [tblView.layer setCornerRadius:3.0f];
        [tblView.layer setMasksToBounds:YES];
        
        [UIView animateWithDuration:0.35
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect frame = tblView.frame;
                             frame.size.height = self.view.frame.size.height/4.0f;
                             tblView.frame = frame;
                         }
                         completion:^(BOOL finished){
                             DLog(@"Done!");
                         }];
    }
    
}
-(NSArray *)GetDataForPoppup:(UITextField *)fld
{
    
    
    
    if (fld==txtUserType)
    {
        arrFeedTblPopup=@[@"Customer",@"Manager",@"Engineer"];
        return arrFeedTblPopup;
    }
    else if (fld==txtUserName)
    {
        arrFeedTblPopup=arrRecipientList;
        return arrFeedTblPopup;
    }
    return nil;
    
}


#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
    DLog(@"Connection Start::%@",_responseData);
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MBProgressHUD hideAllHUDsForView:self.tblMessageList animated:YES];
    [refreshControl endRefreshing];
    
    NSMutableDictionary* temp;
    if (_responseData !=nil)
    {
        NSError *error;
        temp = [NSJSONSerialization JSONObjectWithData:_responseData  options:NSJSONReadingMutableContainers error:&error];
        
        if (!error)
        {
            if ([[temp valueForKey:@"ResponseStatus"]boolValue]==true)
            {

                if (connection==connFetchMessage||[connIdentifier isEqualToString:@"connFetchMessage"])
                {
                    
                    arrMessageList=[temp valueForKey:@"jobMessageResponse"];
                    
                    
                    [self groupArrayWithValues:arrMessageList];
                    
                    
                    
                    
                    [_tblMessageList reloadData];
                    [hud hide:YES];
                    
                    if (arrMessageList.count==0) {
                        
                        lblNoJobs=[[UILabel alloc]init];
                        lblNoJobs.text=[NSString stringWithFormat:@"No Messages"];
                        
                        lblNoJobs.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:20.0];
                        [lblNoJobs sizeToFit];
                        lblNoJobs.tag=404;
                        lblNoJobs.center=CGPointMake(_tblMessageList.center.x, _tblMessageList.center.y);
                        [self.view addSubview:lblNoJobs];
                    }
                    else
                    {
                        [lblNoJobs removeFromSuperview];
                        lblNoJobs=nil;
                        
                    }
                }
                
            }
            else
            {
               
                [self showAlert:[temp valueForKey:@"ResponseMessages"] withTitle:@""];
                
            }
            
        }
    }
    

}

- (void)groupArrayWithValues:(NSArray *)arr
{
    NSMutableArray *filterdarr=[[NSMutableArray alloc]init];
    for (NSDictionary *dic in arr)
    {
        NSArray *filteredarray = [arr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(JobID == %@)", [dic valueForKey:@"JobID"],[dic valueForKey:@"SenderId"]]];
        [filterdarr addObject:filteredarray];
        
    }
    
    NSMutableArray *uniqueArray = [NSMutableArray array];
    [uniqueArray addObjectsFromArray:[[NSSet setWithArray:filterdarr] allObjects]];
    NSLog(@"filtered data ::--%@",uniqueArray);
}


#pragma mark - UITableView Delegate Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (tableView==tblView){
        return 44;
    }
    else{
        return 135.0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tblView)
    {
        return [arrFeedTblPopup count];
    }
    else
    {
        return [arrMessageList count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier=@"cellidentifier";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellidentifier];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.backgroundColor=[UIColor clearColor];
    
    DLog(@"arrFeedTblPopup :%@",arrFeedTblPopup);
    
    if (tableView==tblView)
    {
       
    }
    else
    {
        
        
        UIImageView *imgvCellbg=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(_tblMessageList.frame),135)];
        [imgvCellbg setImage:[UIImage imageNamed:@"jobBox_clearbg"]];
        [cell.contentView addSubview:imgvCellbg];
        
        NSDictionary *dic=[arrMessageList objectAtIndex:indexPath.row];
        DLog(@"dicdicdicdicdicdicdic ::: %@",dic);
        
        //---------- CreatedBy --------------------------------------------------------------------------------
        UILabel *lbl111;
        lbl111=[[UILabel alloc] initWithFrame:CGRectMake(15,5,70,30)];
        lbl111.textAlignment=NSTextAlignmentLeft;
        lbl111.textColor=[UIColor darkGrayColor];
        lbl111.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
        lbl111.backgroundColor=[UIColor clearColor];
        lbl111.text=@"From:";
        if ([[userdetails valueForKey:@"UserID"]integerValue]==[[dic valueForKey:@"SenderId"]integerValue]) {
             lbl111.text=@"Sent To:";
        }
      
        [cell.contentView addSubview:lbl111];
        
        UILabel *lblCreatedBy;
        lblCreatedBy=[[UILabel alloc] initWithFrame:CGRectMake(100,5,226,30)];
        lblCreatedBy.textAlignment=NSTextAlignmentLeft;
        lblCreatedBy.textColor=[UIColor blueColor];
        lblCreatedBy.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
        lblCreatedBy.backgroundColor=[UIColor clearColor];
        lblCreatedBy.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"CreatedBy"]];
        if ([[userdetails valueForKey:@"UserID"]integerValue]==[[dic valueForKey:@"SenderId"]integerValue]) {
            
            lblCreatedBy.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"Receiver"]];
        }
        
        [cell.contentView addSubview:lblCreatedBy];
        //----------------------------------------------------------------------------------------------------
        
        //---------- CreatedDate --------------------------------------------------------------------------------
        UILabel *lbl222;
        lbl222=[[UILabel alloc] initWithFrame:CGRectMake(15,35,80,30)];
        lbl222.textAlignment=NSTextAlignmentLeft;
        lbl222.textColor=[UIColor darkGrayColor];
        lbl222.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
        lbl222.backgroundColor=[UIColor clearColor];
        lbl222.text=@"Sent on:";
        [cell.contentView addSubview:lbl222];
        
        DLog(@"date time:%@",[dic valueForKey:@"CreatedDate"]);
        
        NSString *strStartDate =[NSString stringWithFormat:@"%@",[dic valueForKey:@"CreatedDate"]];
        strStartDate = [strStartDate substringToIndex:10];
        
        UILabel *lblCreatedDate;
        lblCreatedDate=[[UILabel alloc] initWithFrame:CGRectMake(100,35,226,30)];
        lblCreatedDate.textAlignment=NSTextAlignmentLeft;
        lblCreatedDate.textColor=[UIColor blueColor];
        lblCreatedDate.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
        lblCreatedDate.backgroundColor=[UIColor clearColor];
        lblCreatedDate.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"CreatedDate"]];
        [cell.contentView addSubview:lblCreatedDate];
        //----------------------------------------------------------------------------------------------------
        
        //---------- Messagetext --------------------------------------------------------------------------------
        UILabel *lbl2;
        lbl2=[[UILabel alloc] initWithFrame:CGRectMake(15,80,80,30)];
        lbl2.textAlignment=NSTextAlignmentLeft;
        lbl2.textColor=[UIColor darkGrayColor];
        lbl2.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
        lbl2.backgroundColor=[UIColor clearColor];
        lbl2.text=@"Message Text:";
        [lbl2 sizeToFit];
        [cell.contentView addSubview:lbl2];
        
        UILabel *lblNoteBody;
        lblNoteBody=[[UILabel alloc] initWithFrame:CGRectMake(100,CGRectGetMinY(lbl2.frame),226,50)];
        lblNoteBody.textAlignment=NSTextAlignmentLeft;
        lblNoteBody.lineBreakMode=NSLineBreakByTruncatingTail;
        
        lblNoteBody.textColor=[UIColor colorWithRed:50/255.0 green:65/255.0 blue:75/255.0 alpha:1.0];
        lblNoteBody.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
        lblNoteBody.backgroundColor=[UIColor clearColor];
        if ([dic valueForKey:@"MessageBody"]== [NSNull null])
        {
            lblNoteBody.text=[NSString stringWithFormat:@"%@",@""];
        }
        else
        {
            lblNoteBody.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"MessageBody"]];
        }
        
        lblNoteBody.numberOfLines=0;
        [lblNoteBody sizeThatFits:lblNoteBody.frame.size];
        [cell.contentView addSubview:lblNoteBody];
        //----------------------------------------------------------------------------------------------------
        
         //----------------- Reply ------------
        UIButton *reply=[UIButton buttonWithType:UIButtonTypeCustom];
        reply.frame=CGRectMake(CGRectGetWidth(_tblMessageList.frame)-147,CGRectGetMinY(lblCreatedDate.frame)+4,65,25);
        reply.tag=indexPath.row;
        [reply setTitle:@"Reply" forState:UIControlStateNormal];
        [reply setBackgroundColor:[UIColor clearColor]];
        [reply addTarget:self action:@selector(replyMessage:) forControlEvents:UIControlEventTouchUpInside];
        reply.backgroundColor=[UIColor colorWithRed:137/255.0 green:182/255.0 blue:40/255.0 alpha:1.0];
        [reply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        if ([[userdetails valueForKey:@"UserID"]integerValue]==[[dic valueForKey:@"SenderId"]integerValue])
        {
             reply.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
             [reply setTitle:@"Sent" forState:UIControlStateNormal];
             [reply setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
             reply.userInteractionEnabled=NO;
            
            
        }
        reply.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
        
        reply.layer.cornerRadius=4.0f;
        reply.layer.borderColor=[[UIColor clearColor]CGColor];
        reply.layer.borderWidth=0.0f;
        [reply.layer setMasksToBounds:YES];
        
        [cell.contentView addSubview:reply];
        
        //----------------- Refuse ------------
        UIButton *btnGoToJob=[UIButton buttonWithType:UIButtonTypeCustom];
        btnGoToJob.frame=CGRectMake(CGRectGetWidth(_tblMessageList.frame)-69,CGRectGetMinY(lblCreatedDate.frame)+4,65,25);
        btnGoToJob.tag=indexPath.row;//[[dic objectForKey:@"JobID"] integerValue];
        [btnGoToJob setTitle:@"View Job" forState:UIControlStateNormal];
        [btnGoToJob setBackgroundColor:[UIColor clearColor]];
        [btnGoToJob addTarget:self action:@selector(OpenJob:) forControlEvents:UIControlEventTouchUpInside];
        btnGoToJob.backgroundColor=[UIColor colorWithRed:137/255.0 green:182/255.0 blue:40/255.0 alpha:1.0];
        [btnGoToJob setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnGoToJob.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
        
        btnGoToJob.layer.cornerRadius=4.0f;
        btnGoToJob.layer.borderColor=[[UIColor clearColor]CGColor];
        btnGoToJob.layer.borderWidth=0.0f;
        [btnGoToJob.layer setMasksToBounds:YES];
        
         [cell.contentView addSubview:btnGoToJob];
        
         BOOL IsEngAssign=[[dic objectForKey:@"IsEnggAssign"] boolValue];
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"] && IsEngAssign==NO)
        {
            btnGoToJob.hidden=YES;
        }else{
           btnGoToJob.hidden=NO;
        }
        
        
        
        if ([[UIScreen mainScreen]bounds].size.width==320.0f) {
            btnGoToJob.center=CGPointMake(btnGoToJob.center.x, btnGoToJob.center.y-10);
            reply.center=CGPointMake(btnGoToJob.center.x, btnGoToJob.center.y+CGRectGetHeight(reply.frame)+2);
        }
       
    }
    
   
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=[arrMessageList objectAtIndex:indexPath.row];
    if ([dic valueForKey:@"MessageBody"]== [NSNull null])
    {
       _txtVmsgPop.text=@"";
    }
    else
    {
        //lblNoteBody.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"MessageBody"]];
        _txtVmsgPop.text = [GlobalDirector ReplaceStringNull:[dic valueForKey:@"MessageBody"]];
        [self ShowPopup];
    }
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
     NSDictionary *dic=[arrMessageList objectAtIndex:indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Message will be deleted/Cancelled. Continue ?"
                                                                            message:@""
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"YES"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                DLog(@"Dismiss button tapped!");
                                                                [MBProgressHUD showHUDAddedTo:_tblMessageList animated:YES];
                                                                [self getDataFromServerWithUrl:[NSString stringWithFormat:@"%sSetJobMessageDelete?userToken=%@&jobId=%d&jobMessageId=%ld",conn_url,[userdetails valueForKey:@"UserToken" ],[[dic valueForKey:@"JobID"]integerValue],[[dic valueForKey:@"JobMessageID"]integerValue]] finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
                                                                    
                                                                    [MBProgressHUD hideAllHUDsForView:_tblMessageList animated:YES];
                                                                    
                                                                    NSMutableDictionary* temp;
                                                                    
                                                                    if (data !=nil)
                                                                    {
                                                                        NSError *error;
                                                                        
                                                                        temp = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingMutableContainers error:&error];
                                                                        if (!error)
                                                                        {
                                                                            DLog(@"%@",temp);
                                                                            if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
                                                                                
                                                                            {
                                                                                [arrMessageList removeObjectAtIndex:indexPath.row];
                                                                                [_tblMessageList reloadData];
                                                                                
                                                                                
                                                                            }
                                                                        }
                                                                    }
                                                                    
                                                                    
                                                                }];

                                                            }];
        
        
        UIAlertAction *Cancel = [UIAlertAction actionWithTitle: @"NO"
                                                              style: UIAlertActionStyleDefault
                                                            handler: ^(UIAlertAction *action) {
                                                                DLog(@"Dismiss button tapped!");
                                                                
                                                            }];
        
        [controller addAction: alertAction];
        [controller addAction:Cancel];
        
        [self presentViewController: controller animated: YES completion: nil];
        
    
    }
}



-(IBAction)replyMessage:(UIButton *)sender{
    DLog(@"%ld",(long)sender.tag);
    NSDictionary *dic=[arrMessageList objectAtIndex:sender.tag];
    __block UITextField *txtRecom;
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:[NSString stringWithFormat:@"Send a quick reply to %@",[dic valueForKey:@"CreatedBy"]]
                               message:@""
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   
                                                   
                                                   UITextField *temp = alert.textFields.firstObject;
                                                   
                                                   DLog(@"%@",temp.text);
                                                 
                                                   
                                                   [self sendMessage:temp.text jobIndex:sender.tag];
                                 
                                               }];
    
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                      
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                   }];
    
    
    ok.enabled=NO;
    [alert addAction:ok];
    [alert addAction:cancel];
    
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        txtRecom = textField;
        textField.tag=1111;
        
        textField.delegate=self;
        textField.placeholder = @"type you message here";
        textField.keyboardType = UIKeyboardTypeDefault;
        
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
    

}



-(void)sendMessage:(NSString *)message jobIndex:(NSInteger)index{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        DLog(@"There IS NO internet connection");
        
        [self showAlert:@"Check your Internet connection" withTitle:@"Connection error!"];
        
        
        
        
    } else {
        
        
    [MBProgressHUD showHUDAddedTo:self.tblMessageList animated:YES];
    NSDictionary *dic=[arrMessageList objectAtIndex:index];
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *urlString;
    //NSString *post =[NSString stringWithFormat:@""];
    NSString *selectedEnggIds=[dic valueForKey:@"SenderId"];;
    DLog(@"%@",selectedEnggIds);
    
    
    urlString=[NSString stringWithFormat:@"%sSetJobWiseMessage?userToken=%@&jobID=%@&userToIds=%@&userFromId=%@&messageBody=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],[NSString stringWithFormat:@"%@",[dic valueForKey:@"JobID"]],selectedEnggIds,(NSString *)[user valueForKey:@"UserID"],message];
     urlString= [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        DLog(@"%@",urlString);
        
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        
        [MBProgressHUD hideAllHUDsForView:_tblMessageList animated:YES];
        
        NSMutableDictionary* temp;
        
        if (data !=nil)
        {
            NSError *error;
            
            temp = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingMutableContainers error:&error];
            if (!error)
            {
                [MBProgressHUD hideAllHUDsForView:_tblMessageList animated:YES];
                DLog(@"%@",temp);
                if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
                {
                    
                    [self showAlert:@"Message sent" withTitle:@""];
                    [self FetchMessages];
                    
                }
            }
        }
        
    }];
        
    }
    
    
}




-(IBAction)OpenJob:(UIButton *)sender{
    
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        DLog(@"There IS NO internet connection");
        [self showAlert:@"Check your Internet connection" withTitle:@"Connection error!"];
    }
    else
    {
        MBProgressHUD *hudd=  [MBProgressHUD showHUDAddedTo:_tblMessageList animated:YES];
        hudd.labelText=@"Loading Job ..";
        
        DLog(@"%ld",(long)sender.tag);
        NSDictionary *dic=[arrMessageList objectAtIndex:sender.tag];
        [self.dataTask cancel];
        
        NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
        DLog(@"There IS internet connection");
        //JobResponse GetJobDetails(string userToken, long jobId);
        NSString *urlString=[NSString stringWithFormat:@"%sGetJobDetails?userToken=%@&jobId=%ld",conn_url,(NSString *)[user valueForKey:@"UserToken"],[[dic valueForKey:@"JobID"]integerValue]];
        urlString= [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        DLog(@"PostString=%@",urlString);
        
        [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error)
         {
             if (error==nil) {
             
                dispatch_async(dispatch_get_main_queue(), ^{
                     
             [MBProgressHUD hideAllHUDsForView:_tblMessageList animated:YES];
             
             NSMutableDictionary* temp;
             
             if (data !=nil)
             {
                 NSError *error;
                 
                 temp = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingMutableContainers error:&error];
                 if (!error)
                 {
                     //DLog(@"%@",temp);
                     
                     if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
                         
                     {
                         id jobs=[temp objectForKey:@"JobResponseList"];
                         
                         if ([jobs isKindOfClass:[NSDictionary class]])
                         {
                              [self navToJobDetailsPage:jobs];
                         }
                         
                     }
                 }
             }
                     
                 });
                 
             }
             
         }];
        
        
        
    }
    
    
}


-(void)navToJobDetailsPage:(NSDictionary *)jobDic{
    
    UIViewController *pushView;
    
  
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
        {
            Customer_EngineerJobDetails *customerjobdetails =[[Customer_EngineerJobDetails alloc]initWithNibName:@"Customer_EngineerJobDetails" bundle:nil];
            customerjobdetails.dicCustomerJobDetails=[jobDic mutableCopy];
            pushView=customerjobdetails;
        }
        else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
        {
            
            NSString *IsEngAssign=[NSString stringWithFormat:@"%@",[jobDic objectForKey:@"IsEngAssign"]];
            
            if ([IsEngAssign isEqualToString:@"1"])
            {
                //Assigned
                ManagerJobDetails *mJobdetails;
            
                mJobdetails=[[ManagerJobDetails alloc]initWithNibName:@"EngineerJobDetails" bundle:nil];
                mJobdetails.dicManagerJobDetails=[jobDic mutableCopy];
                mJobdetails.stausCell=[NSString stringWithFormat:@"%@",[jobDic objectForKey:@"JobStatus"]];
                pushView=mJobdetails;
                
                
            }
           
            
        }
        else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
        {
            
            ManagerJobDetails *mJobdetails;
           
           
            mJobdetails=[[ManagerJobDetails alloc]initWithNibName:@"ManagerJobDetails" bundle:nil];
            mJobdetails.dicManagerJobDetails=[jobDic mutableCopy];
            mJobdetails.stausCell=[NSString stringWithFormat:@"%@",[jobDic objectForKey:@"JobStatus"]];
            pushView=mJobdetails;
            
        }
    
    
    [self.navigationController pushViewController:pushView animated:YES];
    
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
        if (newLength >=2)
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



    
#pragma mark- Back Press Method
- (IBAction)backTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)CrossPopClick:(UIButton *)sender {
    _txtVmsgPop.text=@"";
    [KLCPopup dismissAllPopups];
}


-(void)ShowPopup{
    
    _viewPopSub.layer.cornerRadius = 5;
    _viewPopSub.layer.masksToBounds=YES;
    
  KLCPopup  *popPicker =    [KLCPopup popupWithContentView:_viewMsgPopup showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeBounceOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    
    
    KLCPopupLayout layout =  KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter);
    [popPicker showWithLayout:layout];
    [popPicker show];
    
}






@end










