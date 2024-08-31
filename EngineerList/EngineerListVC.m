//
//  EngineerListVC.m
//  PM247
//
//  Created by Vikram on 01/07/23.
//  Copyright © 2023 SANDIPAN. All rights reserved.
//

#import "EngineerListVC.h"
#import "EngineerListTableViewCell.h"
#import "GlobalDirector.h"

@interface EngineerListVC (){
    NSMutableArray *selectedIds;

}

@end

@implementation EngineerListVC

#pragma mark - Init Method

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedIds = [[NSMutableArray alloc] init];

    self.navigationController.navigationBarHidden=YES;
    
    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [_btnSlideMenu addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:revealController action:@selector(rightRevealToggle:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    UISwipeGestureRecognizer *recognizer1;
    recognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:revealController action:@selector(revealToggle:)];
    [recognizer1 setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:recognizer1];
    [[self view] addGestureRecognizer:recognizer];
    

    _searchBar.placeholder=@"Search via name";
    _searchBar.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"EngineerListTableViewCell" bundle:nil] forCellReuseIdentifier:@"EngineerListTableViewCell"];
    [self GetEngineerList];
}

#pragma mark - IBAction Method

- (IBAction)btnInviteClicked:(id)sender {
    if(selectedIds.count == 0){
        [self showAlert:@"Select atleast one engineer for job request." withTitle:@"Job Request"];
    }
    else{
        [self SetEngineerInvite];
    }
}

-(IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Custom Method
-(void)SetEngineerInvite
{
    MBProgressHUD   *hudd=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudd.labelText=@"Loading...";
    [hudd show:YES];

    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString;
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *idStringFromArray = [selectedIds componentsJoinedByString:@","];

    urlString=[NSString stringWithFormat:@"%sSendMultipleInvitation?userToken=%@&TagType=&EnggTimeAllowance&jobid=%ld&MultipleEnggIds=%@&userId=%@", conn_url,(NSString *)[user valueForKey:@"UserToken"],_jobId,idStringFromArray,(NSString *)[user valueForKey:@"StaffID"]];

    urlString=[urlString stringByReplacingOccurrencesOfString:@"" withString:@"%20"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    request.timeoutInterval = 300;
    DLog(@"GetString=%@",request);
    
    //connGetAvailability = [[NSURLConnection alloc] init];
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        [hudd hide:YES];

        DLog(@"PostString=%@",urlString);
        
        dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableData *responseData=[data mutableCopy];
                NSMutableDictionary* temp;
                if (responseData !=nil)
                {
                    NSError *error;
                    
                    temp = [NSJSONSerialization JSONObjectWithData:responseData  options:NSJSONReadingMutableContainers error:&error];
                    if (!error)
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                        [self showAlert:@"Job request sent to the selected engineer." withTitle:@"Job Request"];

                       
                    }
                }
        });
        
    }];
    
}

-(void)GetEngineerList
{
    MBProgressHUD   *hudd=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudd.labelText=@"Loading...";
    [hudd show:YES];

    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString;
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    urlString=[NSString stringWithFormat:@"%sGetEngineerByDistance?userToken=%@&Distance=%@&jobid=%ld", conn_url,(NSString *)[user valueForKey:@"UserToken"],_distnceValue,_jobId];

    urlString=[urlString stringByReplacingOccurrencesOfString:@"" withString:@"%20"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    request.timeoutInterval = 300;
    DLog(@"GetString=%@",request);
    
    //connGetAvailability = [[NSURLConnection alloc] init];
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        [hudd hide:YES];

        DLog(@"PostString=%@",urlString);
        
        dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableData *responseData=[data mutableCopy];
                NSMutableDictionary* temp;
                if (responseData !=nil)
                {
                    NSError *error;
                    
                    temp = [NSJSONSerialization JSONObjectWithData:responseData  options:NSJSONReadingMutableContainers error:&error];
                    if (!error)
                    {
                        self->arrList = [[NSMutableArray alloc] init];
                        self->filterArray =  [[NSMutableArray alloc] init];
                        if([temp valueForKey:@"AvailableEngineerList"])
                        {
                            self->arrList = [temp valueForKey:@"AvailableEngineerList"];
                        }
                        
                        if([self->arrList isEqual:[NSNull null]] || self->arrList.count == 0){
                            [self->_lblPlaceHolder setHidden:FALSE];
                            [self->_btnInvite setHidden:TRUE];

                        }
                        else{
                            [self->_lblPlaceHolder setHidden:TRUE];
                            [self->_btnInvite setHidden:FALSE];
                        }
                        self->filterArray = self->arrList;
                        [self->_tableView reloadData];
                    }
                }
        });
        
    }];
    
}

#pragma mark - UITableView Delegate/Datasource
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self->arrList isEqual:[NSNull null]] || self->arrList.count == 0){
        return 0;
    }
    int subForselectAllIndex = 0;
    if([_searchBar.text isEqual: @""]){
        subForselectAllIndex = 1;
    }
    else{
        subForselectAllIndex = 0;
        //Remove Select All
    }
    return filterArray.count + subForselectAllIndex;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    EngineerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EngineerListTableViewCell" forIndexPath:indexPath];
    
    int subForselectAllIndex = 0;
    if([_searchBar.text isEqual: @""]){
        subForselectAllIndex = 1;
    }
    else{
        subForselectAllIndex = 0;
        //Remove Select All
    }
    
    if(indexPath.row == 0 && subForselectAllIndex == 1){
        cell.lblName.text = @"Select All";
        if(selectedIds.count == filterArray.count){
            [cell.btnInvite setBackgroundImage:[UIImage imageNamed:@"check"] forState:normal];
        }
        else{
            [cell.btnInvite setBackgroundImage:[UIImage imageNamed:@"uncheck"] forState:normal];
        }
    }
    else{
        NSDictionary *dicTemp=[filterArray objectAtIndex:indexPath.row - subForselectAllIndex];
        NSString *name=[NSString stringWithFormat:@"%@ %@",[dicTemp objectForKey:@"FirstName"] ,[dicTemp objectForKey:@"LastName"]];

        if([selectedIds containsObject:[dicTemp objectForKey:@"StaffID"]]){
            [cell.btnInvite setBackgroundImage: [UIImage imageNamed:@"check"] forState:normal];
        }
        else{
            [cell.btnInvite setBackgroundImage:[UIImage imageNamed:@"uncheck"] forState:normal];
        }
        cell.lblName.text = name;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int subForselectAllIndex = 0;
    if([_searchBar.text isEqual: @""]){
        subForselectAllIndex = 1;
    }
    else{
        subForselectAllIndex = 0;
        //Remove Select All
    }
    
    if(indexPath.row == 0 && subForselectAllIndex == 1){
        if(selectedIds.count == filterArray.count){
             selectedIds=[[NSMutableArray alloc] init];

        }
        else{
            selectedIds=[[NSMutableArray alloc] init];
            for (id dicTemp in filterArray)
            {
                [selectedIds addObject:[dicTemp objectForKey:@"StaffID"]];

//                if(selectedIds == nil){
//                    selectedIds = [dicTemp objectForKey:@"StaffID"];
//                }
//                else{
//                    [selectedIds addObject:[dicTemp objectForKey:@"StaffID"]];
//                }
            }
        }
    }
    else{
        NSDictionary *dicTemp=[filterArray objectAtIndex:indexPath.row - subForselectAllIndex];
        if([selectedIds containsObject:[dicTemp objectForKey:@"StaffID"]]){
            NSInteger index = [selectedIds indexOfObject:[dicTemp objectForKey:@"StaffID"]];
            [selectedIds removeObjectAtIndex:index];
        }
        else{
            if(selectedIds == nil || selectedIds.count == 0){
                selectedIds=[[NSMutableArray alloc] init];
            }
                [selectedIds addObject:[dicTemp objectForKey:@"StaffID"]];
            }
        
    }
    [self->_tableView reloadData];
}


#pragma mark - SearchBar Delegate/Datasource
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    DLog(@"search button clicked");

    [searchBar resignFirstResponder];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    DLog(@"search cancel clicked");
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(arrList.count > 0){
        NSPredicate *searchSearch = [NSPredicate predicateWithFormat:@"FirstName CONTAINS[cd] %@ OR LastName CONTAINS[cd] %@", searchText, searchText];
        NSArray *searchResults = [arrList filteredArrayUsingPredicate:searchSearch];
        if([searchText isEqual: @""]){
            filterArray = arrList;
        }
        else{
            filterArray = [NSMutableArray arrayWithArray:searchResults];
        }
        
        [self->_tableView reloadData];
        DLog(@"%@", searchResults);

    }
}


@end
