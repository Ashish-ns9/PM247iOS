//
//  Menu.m
//  Partner Maintenance
//


#import "Menu.h"
AppDelegate *app;

@interface Menu ()

@end

@implementation Menu

#pragma mark - ViewDidLoad Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    app=(AppDelegate *)[[UIApplication  sharedApplication] delegate];
    self.navigationController.navigationBarHidden=YES;
    
    [_lblMenu setFont:[UIFont fontWithName:@"TheSansArabic-Bold" size:16.0]];
    DLog(@"LoggedUser ::::%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"]);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadTabel) name:@"reloadCount" object:nil];
}

-(void)ReloadTabel{
    [_tab_Menu reloadData];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - didReceiveMemoryWarning Method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - viewDidAppear Method
- (void)viewDidAppear:(BOOL)animated
{
    app.menuCount++;
    if (app.menuCount<=1)
    {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [_tab_Menu selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
    }
    
    [_tab_Menu reloadData];
}

#pragma mark - UITableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
    {
        return 5;
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        return 5;
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        return 6;
    }
    else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 50.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    cell.backgroundColor=[UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSInteger row = indexPath.row;
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:16.0];
    
    UIImageView *imgvIcon=[[UIImageView alloc]init];
    [cell.contentView addSubview:imgvIcon];
    
    UILabel *lblSeparator=[[UILabel alloc] initWithFrame:CGRectMake(15,49.8,305,0.2)];
    lblSeparator.backgroundColor=[UIColor colorWithRed:247/255.0 green:246/255.0 blue:255/255.0 alpha:1.0];
    [cell.contentView addSubview:lblSeparator];
    
    NSString *count = [NSString stringWithFormat:@"%d", [app.strMsgCount intValue]];
    
    
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
    {
        if (row == 0)
        {
            cell.textLabel.text = @"                                Dashboard";
            
            [imgvIcon setFrame:CGRectMake(88,12,23,23)];
            [imgvIcon setImage:[UIImage imageNamed:@"slide_dashboard"]];
        }
        else if (row == 1)
        {
            cell.textLabel.text = @"                                User Profile";
            
            [imgvIcon setFrame:CGRectMake(88,14,23,23)];
            [imgvIcon setImage:[UIImage imageNamed:@"slide_userprofile"]];
        }
        else if (row == 2)
        {
            cell.textLabel.text = @"                                Messages";
            
            [imgvIcon setFrame:CGRectMake(88,14,23,23)];
            [imgvIcon setImage:[UIImage imageNamed:@"slide_message"]];
            
            UILabel *lblNotification=[[UILabel alloc]init];
            [lblNotification setFrame:CGRectMake(205,14,26,26)];
            lblNotification.font=[UIFont fontWithName:@"Arial" size:13.0];
            lblNotification.textColor = [UIColor whiteColor];
            lblNotification.backgroundColor=[UIColor redColor];
            lblNotification.layer.borderWidth=2;
            lblNotification.layer.borderColor=(__bridge CGColorRef _Nullable)([UIColor whiteColor]);
            lblNotification.layer.cornerRadius = 13;
            lblNotification.layer.masksToBounds=YES;
            lblNotification.textAlignment=NSTextAlignmentCenter;
            
            lblNotification.text = count;
            [cell.contentView addSubview:lblNotification];

            
        }
        else if (row == 3)
        {
            cell.textLabel.text = @"                                Call Us";
            
            [imgvIcon setFrame:CGRectMake(88,14,23,23)];
            [imgvIcon setImage:[UIImage imageNamed:@"slide_call"]];
        }
        else if (row == 4)
        {
            cell.textLabel.text = @"                                Logout";
            
            [imgvIcon setFrame:CGRectMake(88,14,23,20)];
            [imgvIcon setImage:[UIImage imageNamed:@"slide_logout"]];
        }
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        if (row == 0)
        {
            cell.textLabel.text = @"                                Dashboard";
            
            [imgvIcon setFrame:CGRectMake(88,12,23,23)];
            [imgvIcon setImage:[UIImage imageNamed:@"slide_dashboard"]];
        }
        else if (row == 1)
        {
            cell.textLabel.text = @"                                Engineer's Invitation";
            
            [imgvIcon setFrame:CGRectMake(88,12,23,24)];
            [imgvIcon setImage:[UIImage imageNamed:@"slide_engineerbehaf"]];
        }
        else if (row == 2)
        {
            cell.textLabel.text = @"                                Messages";
            
            [imgvIcon setFrame:CGRectMake(88,14,23,23)];
            [imgvIcon setImage:[UIImage imageNamed:@"slide_message"]];
            
            UILabel *lblNotification=[[UILabel alloc]init];
            [lblNotification setFrame:CGRectMake(205,14,26,26)];
            lblNotification.font=[UIFont fontWithName:@"Arial" size:13.0];
            lblNotification.textColor = [UIColor whiteColor];
            lblNotification.backgroundColor=[UIColor redColor];
            lblNotification.layer.borderWidth=2;
            lblNotification.layer.borderColor=(__bridge CGColorRef _Nullable)([UIColor whiteColor]);
            lblNotification.layer.cornerRadius = 13;
            lblNotification.layer.masksToBounds=YES;
            lblNotification.textAlignment=NSTextAlignmentCenter;
            
            lblNotification.text = count;
            [cell.contentView addSubview:lblNotification];

            
        }
        else if (row == 3)
        {
            cell.textLabel.text = @"                                Call Us";
            
            [imgvIcon setFrame:CGRectMake(88,14,23,23)];
            [imgvIcon setImage:[UIImage imageNamed:@"slide_call"]];
        }
        else if (row == 4)
        {
            cell.textLabel.text = @"                                Logout";
            
            [imgvIcon setFrame:CGRectMake(88,14,23,20)];
            [imgvIcon setImage:[UIImage imageNamed:@"slide_logout"]];
        }
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        
        if (row == 0)
        {
            cell.textLabel.text = @"                                Dashboard";
            
            [imgvIcon setFrame:CGRectMake(88,12,23,23)];
            [imgvIcon setImage:[UIImage imageNamed:@"slide_dashboard"]];
        }
        else if (row == 1)
        {
            cell.textLabel.text = @"                              Engineer Availability  ";
            
            [imgvIcon setFrame:CGRectMake(88,14,23,25)];
            [imgvIcon setImage:[UIImage imageNamed:@"slide_engavialblity"]];
        }
        else if (row == 2)
        {
            
            cell.textLabel.text = @"                            EngineerCalendar Availability";
            
            [imgvIcon setFrame:CGRectMake(88,14,23,23)];
            [imgvIcon setImage:[UIImage imageNamed:@"calendar"]];
        }
        else if (row == 3)
        {
            cell.textLabel.text = @"                                Messages";
            
            [imgvIcon setFrame:CGRectMake(88,14,23,23)];
            [imgvIcon setImage:[UIImage imageNamed:@"slide_message"]];
            
            UILabel *lblNotification=[[UILabel alloc]init];
            [lblNotification setFrame:CGRectMake(205,14,26,26)];
            lblNotification.font=[UIFont fontWithName:@"Arial" size:13.0];
            lblNotification.textColor = [UIColor whiteColor];
            lblNotification.backgroundColor=[UIColor redColor];
            lblNotification.layer.borderWidth=2;
            lblNotification.layer.borderColor=(__bridge CGColorRef _Nullable)([UIColor whiteColor]);
            lblNotification.layer.cornerRadius = 13;
            lblNotification.layer.masksToBounds=YES;
            lblNotification.textAlignment=NSTextAlignmentCenter;
            
            
            
            lblNotification.text = count;
            [cell.contentView addSubview:lblNotification];

            
        }
        else if (row == 4)
        {
            cell.textLabel.text = @"                                Call Us";
            
            [imgvIcon setFrame:CGRectMake(88,14,23,23)];
            [imgvIcon setImage:[UIImage imageNamed:@"slide_call"]];
        }
        else if (row == 5)
        {
            cell.textLabel.text = @"                                Logout";
            
            [imgvIcon setFrame:CGRectMake(88,14,23,20)];
            [imgvIcon setImage:[UIImage imageNamed:@"slide_logout"]];
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWRevealViewController *revealController = self.revealViewController;
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    NSInteger row = indexPath.row;
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
    {
        if (row == 0)
        {
            
            if ( ![frontNavigationController.topViewController isKindOfClass:[DashBoard class]] )
            {
                DashBoard *frontViewController;
                CGSize screenSize=[[UIScreen mainScreen]bounds].size;
                
                if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
                {
                    if (screenSize.height==568.0f)
                    {
                        frontViewController=[[DashBoard alloc] initWithNibName:@"DashBoard" bundle:Nil];
                    }
                    else if(screenSize.height == 667.0f)
                    {
                        frontViewController=[[DashBoard alloc] initWithNibName:@"DashBoard6" bundle:Nil];
                    }
                    else if(screenSize.height == 736.0f)
                    {
                        frontViewController=[[DashBoard alloc] initWithNibName:@"DashBoard6Plus" bundle:Nil];
                    }
                    else
                    {
                        frontViewController=[[DashBoard alloc] initWithNibName:@"DashBoard4S" bundle:Nil];
                    }
                }
                
                else
                {
                    //iPad
                }
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                [revealController setFrontViewController:navigationController animated:YES];
            }
            else
            {
                [revealController revealToggle:self];
            }
        }
        else if (row == 1)
        {
            if ( ![frontNavigationController.topViewController isKindOfClass:[ProfileEdit class]] )
            {
                
                ProfileEdit *CommunityViewController=[[ProfileEdit alloc] initWithNibName:@"ProfileEdit" bundle:Nil];
                    
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:CommunityViewController];
                [revealController setFrontViewController:navigationController animated:YES];
            }
            else
            {
                [revealController revealToggle:self];
            }
        }
        else if (row == 2)
        {
            if ( ![frontNavigationController.topViewController isKindOfClass:[Messages class]] )
            {
                Messages *mssg =[[Messages alloc] initWithNibName:@"Messages" bundle:Nil];
                    
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mssg];
                [revealController setFrontViewController:navigationController animated:YES];
            }
            else
            {
                [revealController revealToggle:self];
            }
        }
        else if (row == 3)
        {
            //Phone Call
          /*  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Do you want to call ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert setTag:61];
            [alert show];*/
            
            UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Confirmation"
                                                                                message:@"Do you want to call ?"
                                                                         preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle: @"No"
                                                                        style: UIAlertActionStyleDestructive
                                                                      handler: ^(UIAlertAction *action) {
                                                                          NSLog(@"Dismiss button tapped!");
                                                                      }];
            
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Yes"
                                                                  style: UIAlertActionStyleDestructive
                                                                handler: ^(UIAlertAction *action) {
                                                                    [self buttonIndex61];
                                                                    
                                                                    NSLog(@"Dismiss button tapped!");
                                                                }];
            
            
            
            [controller addAction: alertActionCancel];
            
            [controller addAction: alertAction];
            
            
            [self presentViewController: controller animated: YES completion: nil];

            
        }
        else if (row == 4)
        {
            if ([self InternetConnectionAvailable]==YES) {
            
            MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText=@"Logging out ..";
            NSDictionary *userData= [[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
            NSString *token =  [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
            //NSString *post =[NSString stringWithFormat:@""];
            NSString *urlString=[NSString stringWithFormat:@"%sLogout?userToken=%@&userId=%@&deviceId=%@&device=iOS",conn_url,[userData valueForKey:@"UserToken"],[userData valueForKey:@"UserID"],token];
            
            urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];;
            
            
            // [post stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            DLog(@"PostString=%@",urlString);
          
                [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
                    
                    DLog(@"PostString=%@",urlString);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        
                        if (error==nil) {
                            if (data !=nil)
                            {
                                NSError *error;
                                
                                NSDictionary *   temp = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingMutableContainers error:&error];
                                if (!error)
                                {
                                    
                                    if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"]) {
                                        
                                        
                                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
                                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
                                        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"rememberme"];
                                        
                                        
                                        
                                        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"userdetails"];
                                        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"arrEditedJobDic"];
                                        [[NSUserDefaults standardUserDefaults]synchronize];
                                        
                                       
                                        
                                        
                                        AppDelegate * appDelegates=(AppDelegate *)[[UIApplication sharedApplication] delegate];
                                        
                                        [appDelegates.statusTimer invalidate];
                                        appDelegates.statusTimer=nil;
                                        
                                        // Logout(string userToken, string userId, string deviceId)
                                        
                                        if ( ![frontNavigationController.topViewController isKindOfClass:[Login class]] )
                                        {
                                            Login *homeViewController ;
                                            CGSize screenSize=[[UIScreen mainScreen]bounds].size;
                                            
                                            if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
                                            {
                                                if (screenSize.height==568.0f)
                                                {
                                                    homeViewController = [[Login alloc] initWithNibName:@"Login" bundle:nil];
                                                }
                                                else if(screenSize.height == 667.0f)
                                                {
                                                    homeViewController = [[Login alloc] initWithNibName:@"Login6" bundle:nil];
                                                }
                                                else if(screenSize.height == 736.0f)
                                                {
                                                    homeViewController = [[Login alloc] initWithNibName:@"Login6Plus" bundle:nil];
                                                }
                                                else
                                                {
                                                    homeViewController = [[Login alloc] initWithNibName:@"Login4S" bundle:nil];
                                                }
                                                
                                            }
                                            else{
                                                //iPad
                                            }
                                            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
                                            [revealController setFrontViewController:navigationController animated:YES];
                                        }
                                        
                                        else
                                        {
                                            [revealController revealToggle:self];
                                        }
                                        
                                        
                                    }
                                }
                            }
                            

                           
                        }
                        else
                        {
                            
                            
                        }
                        
                    });
                    
                }];


        }
            
            else
            {
                [self showAlert:@"Check Your Internet Connection" withTitle:@"Connection Problem!"];
            }
        }

    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        if (row == 0)
        {
            
            if ( ![frontNavigationController.topViewController isKindOfClass:[DashBoard class]] )
            {
                DashBoard *frontViewController;
                CGSize screenSize=[[UIScreen mainScreen]bounds].size;
                
                if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
                {
                    if (screenSize.height==568.0f)
                    {
                        frontViewController=[[DashBoard alloc] initWithNibName:@"DashBoard" bundle:Nil];
                    }
                    else if(screenSize.height == 667.0f)
                    {
                        frontViewController=[[DashBoard alloc] initWithNibName:@"DashBoard6" bundle:Nil];
                    }
                    else if(screenSize.height == 736.0f)
                    {
                        frontViewController=[[DashBoard alloc] initWithNibName:@"DashBoard6Plus" bundle:Nil];
                    }
                    else
                    {
                        frontViewController=[[DashBoard alloc] initWithNibName:@"DashBoard4S" bundle:Nil];
                    }
                }
                else
                {
                    //iPad
                }
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                [revealController setFrontViewController:navigationController animated:YES];
            }
            else
            {
                [revealController revealToggle:self];
            }
        }
        else if (row == 1)
        {
            if ( ![frontNavigationController.topViewController isKindOfClass:[EngineerBehalfInvitation class]] )
             {
                 
                 EngineerBehalfInvitation *CommunityViewController=[[EngineerBehalfInvitation alloc] initWithNibName:@"EngineerBehalfInvitation" bundle:Nil];
                 
                 UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:CommunityViewController];
                 [revealController setFrontViewController:navigationController animated:YES];
                 
                 
             }
             else
             {
                 [revealController revealToggle:self];
             }
        }
        else if (row == 2)
        {
            if ( ![frontNavigationController.topViewController isKindOfClass:[Messages class]] )
            {
                Messages *mssg =[[Messages alloc] initWithNibName:@"Messages" bundle:Nil];
                    
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mssg];
                [revealController setFrontViewController:navigationController animated:YES];
            }
            else
            {
                [revealController revealToggle:self];
            }
        }
        else if (row == 3)
        {
           
            
            UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Confirmation"
                                                                                message:@"Do you want to call ?"
                                                                         preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle: @"No"
                                                                        style: UIAlertActionStyleDestructive
                                                                      handler: ^(UIAlertAction *action) {
                                                                          NSLog(@"Dismiss button tapped!");
                                                                      }];
            
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Yes"
                                                                  style: UIAlertActionStyleDestructive
                                                                handler: ^(UIAlertAction *action) {
                                                                    [self buttonIndex61];
                                                                    
                                                                    NSLog(@"Dismiss button tapped!");
                                                                }];
            
            
            
            [controller addAction: alertActionCancel];
            
            [controller addAction: alertAction];
            
            
            [self presentViewController: controller animated: YES completion: nil];
            
        }
        else if (row == 4)
        {
            MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText=@"Logging out ..";
            NSDictionary *userData= [[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
            NSString *token =  [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
            //NSString *post =[NSString stringWithFormat:@""];
            NSString *urlString=[NSString stringWithFormat:@"%sLogout?userToken=%@&userId=%@&deviceId=%@&device=iOS",conn_url,[userData valueForKey:@"UserToken"],[userData valueForKey:@"UserID"],token];
            
            urlString=[urlString stringByRemovingPercentEncoding];
            
            
            // [post stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            DLog(@"PostString=%@",urlString);
            //NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:urlString]];
            request.timeoutInterval = 300;
            
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                
                
                dispatch_async(dispatch_get_main_queue(),^ {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                });
            
                
                if (data !=nil)
                {
                    NSError *error;
                    
                    NSDictionary *   temp = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingMutableContainers error:&error];
                    if (!error)
                    {
                        
                        if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"]) {
                            
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
                            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"rememberme"];
                            

                            
                            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"userdetails"];
                            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"arrEditedJobDic"];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            
                           
                            
                            
                            AppDelegate * appDelegates=(AppDelegate *)[[UIApplication sharedApplication] delegate];
                            
                            [appDelegates.statusTimer invalidate];
                            appDelegates.statusTimer=nil;
                            
                            // Logout(string userToken, string userId, string deviceId)
                            
                            if ( ![frontNavigationController.topViewController isKindOfClass:[Login class]] )
                            {
                                Login *homeViewController ;
                                CGSize screenSize=[[UIScreen mainScreen]bounds].size;
                                
                                if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
                                {
                                    if (screenSize.height==568.0f)
                                    {
                                        homeViewController = [[Login alloc] initWithNibName:@"Login" bundle:nil];
                                    }
                                    else if(screenSize.height == 667.0f)
                                    {
                                        homeViewController = [[Login alloc] initWithNibName:@"Login6" bundle:nil];
                                    }
                                    else if(screenSize.height == 736.0f)
                                    {
                                         homeViewController = [[Login alloc] initWithNibName:@"Login6Plus" bundle:nil];
                                    }
                                    else
                                    {
                                        homeViewController = [[Login alloc] initWithNibName:@"Login4S" bundle:nil];
                                    }
                                    
                                }
                                else{
                                    //iPad
                                }
                                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
                                [revealController setFrontViewController:navigationController animated:YES];
                            }
                            else
                            {
                                [revealController revealToggle:self];
                            }
                            
                        }
                    }
                }
                
            }];
            
        }
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        if (row == 0)
        {
            
            if ( ![frontNavigationController.topViewController isKindOfClass:[DashBoard class]] )
            {
                DashBoard *frontViewController;
                CGSize screenSize=[[UIScreen mainScreen]bounds].size;
                
                if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
                {
                    if (screenSize.height==568.0f)
                    {
                        frontViewController=[[DashBoard alloc] initWithNibName:@"DashBoard" bundle:Nil];
                    }
                    else if(screenSize.height == 667.0f)
                    {
                        frontViewController=[[DashBoard alloc] initWithNibName:@"DashBoard6" bundle:Nil];
                    }
                    else if(screenSize.height == 736.0f)
                    {
                        frontViewController=[[DashBoard alloc] initWithNibName:@"DashBoard6Plus" bundle:Nil];
                    }
                    else
                    {
                        frontViewController=[[DashBoard alloc] initWithNibName:@"DashBoard4S" bundle:Nil];
                    }
                }
                
                else
                {
                    //iPad
                }
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                [revealController setFrontViewController:navigationController animated:YES];
            }
            else
            {
                [revealController revealToggle:self];
            }
        }
        else if (row == 1)
        {
            if ( ![frontNavigationController.topViewController isKindOfClass:[EngineerSetAvialability class]] )
            {
                EngineerSetAvialability *setavialbilityViewController=[[EngineerSetAvialability alloc] initWithNibName:@"EngineerSetAvialability" bundle:Nil];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:setavialbilityViewController];
                [revealController setFrontViewController:navigationController animated:YES];
                
            }
            else
            {
                [revealController revealToggle:self];
            }
            
        }
        else if (row == 2)
        {
            if ( ![frontNavigationController.topViewController isKindOfClass:[EngineerCalenderAvialabiltyVC class]] )
            {
                EngineerCalenderAvialabiltyVC *setavialbilityViewController=[[EngineerCalenderAvialabiltyVC alloc] initWithNibName:@"EngineerCalenderAvialabiltyVC" bundle:Nil];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:setavialbilityViewController];
                [revealController setFrontViewController:navigationController animated:YES];
                
            }
            else
            {
                [revealController revealToggle:self];
            }
            
        }
        else if (row == 3)
        {
            if ( ![frontNavigationController.topViewController isKindOfClass:[Messages class]] )
            {
                Messages *mssg =[[Messages alloc] initWithNibName:@"Messages" bundle:Nil];
                    
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mssg];
                [revealController setFrontViewController:navigationController animated:YES];
            }
            else
            {
                [revealController revealToggle:self];
            }
        }
        else if (row == 4)
        {
            //Phone Call
            UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Confirmation"
                                                                                message:@"Do you want to call ?"
                                                                         preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle: @"No"
                                                                        style: UIAlertActionStyleDestructive
                                                                      handler: ^(UIAlertAction *action) {
                                                                          NSLog(@"Dismiss button tapped!");
                                                                      }];
            
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Yes"
                                                                  style: UIAlertActionStyleDestructive
                                                                handler: ^(UIAlertAction *action) {
                                                                    [self buttonIndex61];
                                                                    
                                                                    NSLog(@"Dismiss button tapped!");
                                                                }];
            
            
            
            [controller addAction: alertActionCancel];
            
            [controller addAction: alertAction];
            
            
            [self presentViewController: controller animated: YES completion: nil];
        }
        
        else if (row == 5)
        {
            NSDictionary *userData= [[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
            MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText=@"Logging out ..";
            NSString *token =  [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
            //NSString *post =[NSString stringWithFormat:@""];
            NSString *urlString=[NSString stringWithFormat:@"%sLogout?userToken=%@&userId=%@&deviceId=%@&device=iOS",conn_url,[userData valueForKey:@"UserToken"],[userData valueForKey:@"UserID"],token];
            
            urlString=[urlString stringByRemovingPercentEncoding];
            
            
            // [post stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            DLog(@"PostString=%@",urlString);
            //NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:urlString]];
            request.timeoutInterval = 300;
            
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                
                
                dispatch_async(dispatch_get_main_queue(),^ {
                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                });
                
                
                
                if (data !=nil)
                {
                    NSError *error;
                    
                  
                    if (!error)
                    {
                        
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
                        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"rememberme"];
                     
                            
                            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"userdetails"];
                            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"arrEditedJobDic"];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            
                                                        
                            AppDelegate * appDelegates=(AppDelegate *)[[UIApplication sharedApplication] delegate];
                            
                            [appDelegates.statusTimer invalidate];
                            appDelegates.statusTimer=nil;
                            
                            
                            
                            if ( ![frontNavigationController.topViewController isKindOfClass:[Login class]] )
                            {
                                Login *homeViewController ;
                                CGSize screenSize=[[UIScreen mainScreen]bounds].size;
                                
                                if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
                                {
                                    if (screenSize.height==568.0f)
                                    {
                                        homeViewController = [[Login alloc] initWithNibName:@"Login" bundle:nil];
                                    }
                                    else if(screenSize.height == 667.0f)
                                    {
                                        homeViewController = [[Login alloc] initWithNibName:@"Login6" bundle:nil];
                                    }
                                    else if(screenSize.height == 736.0f)
                                    {
                                         homeViewController = [[Login alloc] initWithNibName:@"Login6Plus" bundle:nil];
                                    }
                                    else
                                    {
                                        homeViewController = [[Login alloc] initWithNibName:@"Login4S" bundle:nil];
                                    }
                                    
                                }
                                else{
                                    //iPad
                                }
                                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
                                [revealController setFrontViewController:navigationController animated:YES];
                            }
                            else
                            {
                                [revealController revealToggle:self];
                            }
                        
                        
                        //}
                        
                        
                        
                    }
                }
                
            }];
        }
    }
}

-(void)buttonIndex61
{
    NSString *phNo = @"01707255130";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
        
    } else
    {
        
        [self showAlert:@"Your device doesn't support this feature."  withTitle:@"Alert"];
        
    }
    
}

@end
