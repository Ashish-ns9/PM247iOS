//
//  PostCodePopupController.m
//  Partner Maintenance


#import "PostCodePopupController.h"
@class PostCodeCell;
@interface PostCodePopupController ()

@end

@implementation PostCodePopupController
@synthesize delegate;
@synthesize txtDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arraddresses = [[NSMutableArray alloc] init];
    [_tblView reloadData];
    [_txtPost becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- Uitextfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if (_txtPost.text.length>0) {
        [self ClickSearch:nil];
    }
    
    return YES;
}

#pragma mark -  TableView Delegate Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([arraddresses count]>0) {
       return [arraddresses count];
    }else{
        return 1;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return UITableViewAutomaticDimension;
    
    
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([arraddresses count]>0) {
        
        static NSString *CellIdentifier = @"PostCodeCell";
        PostCodeCell  *cell=(PostCodeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // tableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tab_page.png"]];
        if(cell==nil)
        {
            cell =(PostCodeCell*)[BaseTableCell cellFromNibNamed:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSDictionary *dict = [arraddresses objectAtIndex:indexPath.row];
        
        NSString *add = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"AddressLine1"]];
        NSString *Town = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"Town"]];
        NSString *County = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"County"]];
        NSString *Company = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"Company"]];
        NSString *postcode = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"Postcode"]];
        
     
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        if (Company.length>0) {
            [arr addObject:Company];
        }
        
        if (add.length>0) {
            [arr addObject:add];
        }
        
        if (Town.length>0) {
            [arr addObject:Town];
        }
        
        if (County.length>0) {
            [arr addObject:County];
        }
        if (postcode.length>0) {
            [arr addObject:postcode];
        }
        
        
        cell.lblAddress.text=[GlobalDirector ReplaceStringNull:[arr componentsJoinedByString:@", "]];
        

    
        
         return cell;
        
    }else{
        static NSString *cellid=@"CELL";
        UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
        cell.textLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
        cell.textLabel.text=@"No address to show";
        return cell;
        
    }
    
   
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    @try {
        
        
        
        NSDictionary *dictAdd = [arraddresses objectAtIndex:indexPath.row];
       
        
        if (dictAdd) {
            
            [dict setObject:[GlobalDirector ReplaceStringNull:[dictAdd valueForKey:@"AddressLine1"]] forKey:@"address"];
            [dict setObject:[GlobalDirector ReplaceStringNull:[dictAdd valueForKey:@"Town"]] forKey:@"town"];
            [dict setObject:[GlobalDirector ReplaceStringNull:[dictAdd valueForKey:@"County"]] forKey:@"county"];
            [dict setObject:[GlobalDirector ReplaceStringNull:[dictAdd valueForKey:@"Company"]] forKey:@"company"];
            [dict setObject:[GlobalDirector ReplaceStringNull:[dictAdd valueForKey:@"Postcode"]] forKey:@"postcode"];
            
            }
       
    } @catch (NSException *exception) {
        ;
    }@finally{
         [delegate PostCodeAddressSelection:dict];
    }
    */
    
    @try {
        NSDictionary *dictAdd = [arraddresses objectAtIndex:indexPath.row];
        NSString *addID = [GlobalDirector ReplaceStringNull:[dictAdd valueForKey:@"Id"]];
        [self performSelector:@selector(FetchAddress:) withObject:addID];
    } @catch (NSException *exception) { ;
    }
   
    
}


- (IBAction)FetchAddress:(NSString *)idAddress {
    
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
        [dict setObject:idAddress forKey:@"id"];
        
        GlobalDirector *globe = [GlobalDirector SharedDirector];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_txtPost resignFirstResponder];
        
        [globe SyncRequestGet:REQUEST_GetAddress withPrams:dict andCompletionHandler:^(NSDictionary *result) {
            
            NSLog(@"%@",result);
            
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                @try {
                    
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    int code = [[result valueForKey:@"TotalRecordCount"] intValue];
                    
                    if (code>0) {
                        
                        
                        NSArray *arrAdd= [result valueForKey:@"RecordList"];
                        
                        if (arrAdd) {
                           
                            
                            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                            @try {
                                
                                
                                
                                NSDictionary *dictAdd = [arrAdd objectAtIndex:0];
                                
                                
                                if (dictAdd) {
                                    
                                    NSString *add1 =  [GlobalDirector ReplaceStringNull:[dictAdd valueForKey:@"AddressLine1"]] ;
                                    NSString *add2 =  [GlobalDirector ReplaceStringNull:[dictAdd valueForKey:@"AddressLine2"]] ;
                                    NSString *add3 =  [GlobalDirector ReplaceStringNull:[dictAdd valueForKey:@"AddressLine3"]] ;
                                    NSString *strAddress = [[NSString alloc] init];
                                    if (add1.length>0) {
                                        strAddress = [NSString stringWithFormat:@"%@",add1];
                                    }
                                    
                                    if (add2.length>0){
                                        strAddress =[strAddress stringByAppendingFormat:@",%@",add2];
                                    }
                                    
                                    if (add3.length>0){
                                        strAddress =[strAddress stringByAppendingFormat:@",%@",add3];
                                    }
                                    
                                    
                                    [dict setObject:strAddress forKey:@"address"];
                                    [dict setObject:[GlobalDirector ReplaceStringNull:[dictAdd valueForKey:@"Town"]] forKey:@"town"];
                                    [dict setObject:[GlobalDirector ReplaceStringNull:[dictAdd valueForKey:@"County"]] forKey:@"county"];
                                    [dict setObject:[GlobalDirector ReplaceStringNull:[dictAdd valueForKey:@"Company"]] forKey:@"company"];
                                    [dict setObject:[GlobalDirector ReplaceStringNull:[dictAdd valueForKey:@"Postcode"]] forKey:@"postcode"];
                                    
                                }
                                
                            } @catch (NSException *exception) {
                                ;
                            }@finally{
                                [delegate PostCodeAddressSelection:dict];
                            }


                        }
                        
                        
                    }else{
                        [_txtPost becomeFirstResponder];
                        [self showAlert:@"Error on fetching address." withTitle:@"Sorry!"];
                    }
                    
                    
                    
                } @catch (NSException *exception) {
                    
                    [_txtPost becomeFirstResponder];
                    [self showAlert:@"There are some problem right now, try again later " withTitle:@"Sorry!"];
                }
                
                
            });
            
            
        }];
    
    
    
}


- (IBAction)ClickSearch:(UIButton *)sender {
    
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    if (_txtPost.text.length>0) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
        [dict setObject:_txtPost.text forKey:@"postcode"];
        
        GlobalDirector *globe = [GlobalDirector SharedDirector];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_txtPost resignFirstResponder];
        
        [globe SyncRequestGet:REQUEST_GetPostcodes withPrams:dict andCompletionHandler:^(NSDictionary *result) {
            
            NSLog(@"%@",result);
            
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                @try {
                    
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    int code = [[result valueForKey:@"TotalRecordCount"] intValue];
                    
                    if (code>0) {
                        
                        
                        NSArray *arrAdd= [result valueForKey:@"RecordList"];
                        [self performSelector:@selector(AddressActionSelection:) withObject:arrAdd];
                        
                        
                        
                    }else{
                        [_txtPost becomeFirstResponder];
                        [self showAlert:@"Post code is not valid." withTitle:@"Sorry!"];
                    }
                    
                    
                    
                } @catch (NSException *exception) {
                    
                    [_txtPost becomeFirstResponder];
                    [self showAlert:@"There are some problem right now, try again later " withTitle:@"Sorry!"];
                }
                
                
            });
            
            
        }];
    }else{
         [self showAlert:@"Postcode field is blank." withTitle:@"Sorry!"];
    }
    
    
}



-(void)AddressActionSelection:(NSArray*)arr
{
    if(_isComeFromOnlineOffline){
        [arraddresses removeAllObjects];
        [arraddresses addObjectsFromArray:arr];
        [_tblView reloadData];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Postcode"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionBill = [UIAlertAction actionWithTitle:@"Set Postcode"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                           
                                                           NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                                                          
                                                           txtDelegate.text=_txtPost.text;
                                                            [delegate PostCodeAddressSelection:nil];
                                                           
                                                       }];
    
    
    
    UIAlertAction *actionPre = [UIAlertAction actionWithTitle:@"Search Address"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                          
                                                          if (arr) {
                                                              
                                                              [arraddresses removeAllObjects];
                                                              [arraddresses addObjectsFromArray:arr];
                                                              [_tblView reloadData];
                                                              
                                                              
                                                          }
                                                          
                                                          
                                                          
                                                      }];
    
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                       [_txtPost becomeFirstResponder];
                                                       
                                                   }];
    
    
    
    [alertController addAction:actionBill];
    [alertController addAction:actionPre];

    [alertController addAction:cancel];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}



- (IBAction)ClickBack:(UIButton *)sender {
    
   [delegate PostCodeAddressSelection:nil];
}





@end









