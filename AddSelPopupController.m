//
//  PostCodePopupController.m
//  Partner Maintenance
//


#import "AddSelPopupController.h"
@class PostCodeCell;
@interface AddSelPopupController ()

@end

@implementation AddSelPopupController
@synthesize delegate,customerId;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    arraddresses = [[NSMutableArray alloc] init];
    [_tblView reloadData];
   
    [self fetchPreviousAddList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
        
        static NSString *CellIdentifier = @"AddressCell";
        AddressCell  *cell=(AddressCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // tableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tab_page.png"]];
        if(cell==nil)
        {
            cell =(AddressCell*)[BaseTableCell cellFromNibNamed:CellIdentifier];
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
        
        
        int  orgID = [[GlobalDirector ReplaceStringNull:[dict valueForKey:@"OrganisationTypeId"]] intValue];
        
        if (orgID == 2)
        {
             cell.lblType.text=@"Large Organisation";
            
            
        }else if (orgID == 3)
        {
            
            cell.lblType.text=@"Residential";
           
        }else{
            
             cell.lblType.text=@"Small Organisation";
            
        }

        
        
        
         return cell;
        
    }else{
        static NSString *cellid=@"CELL";
        UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
        cell.textLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
        cell.textLabel.text=@"Loading...";
        return cell;
    }
    
   
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dict = [arraddresses objectAtIndex:indexPath.row];
    NSMutableDictionary *dicJobAddress ;
    
            @try {
               
                dicJobAddress= [[NSMutableDictionary alloc] initWithDictionary:dict];
                
            } @catch (NSException *exception) {
                dicJobAddress=nil;
            }@finally{
                [delegate AddressSelection:dicJobAddress];
            }
    
}



- (IBAction)ClickBack:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)fetchPreviousAddList{
    
    
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    [dict setObject:customerId forKey:@"customerId"];
    
    
    
    GlobalDirector *globe = [GlobalDirector SharedDirector];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [globe SyncRequestGet:REQUEST_GetCustomerAddresses withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        
        DLog(@"%@",result);
        
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  
        dispatch_async(dispatch_get_main_queue(), ^{
            
            @try {
                
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
               
                NSArray *arrAdd= [result valueForKey:@"RecordList"];
                [arraddresses addObjectsFromArray:arrAdd];
                [_tblView reloadData];
                 
                
            } @catch (NSException *exception) {
                
                if (!arraddresses) {
                    arraddresses = [[NSMutableArray alloc] init];
                }
                
            }@finally{
                if ([arraddresses count]==0) {
                    
                     [delegate AddressSelection:nil];
                       
                    ;
                    
                }
            }
        });
        
    }];
    
    
}






@end









