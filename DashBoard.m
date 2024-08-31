//
//  DashBoard.m
//  Partner Maintenance
//


#import "DashBoard.h"
#import "SWRevealViewController.h"
#import "GlobalDirector.h"
#import "GlobalDirector.h"
#import "EngineerList/EngineerListVC.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITYself.DEFAULT, 0)

@interface DashBoard ()

{
    AppDelegate *app;
    GlobalDirector *globe;
    BOOL refreshedList;
    NSString *connIdentifier;
    NSArray *arrJobStatus;
    NSArray *arrDates;
    BOOL isLoadMoreAvail;
    int isUserWantOnline;
    UIAlertController *distanceAlert;

}

@end

@implementation DashBoard
@synthesize btnSlideMenu;
@synthesize btnListandCalender,viewToDoList,ViewCalendar,tabvToDoList;
@synthesize managedObjectContext;




#pragma mark - AnimateToActiveButton Method
-(void)animateToActiveButton:(UIButton *)btn withImageview:(UIImageView *)img
{
    img.backgroundColor=[UIColor whiteColor];
    [UIView animateWithDuration:0.35 animations:^{
        img.frame=btn.frame;
        
    }];
}

#pragma mark Animation Method
-(void)animateSubSelectionViewForButton:(UIButton *)btn forView:(UIView *)view
{
    
    if (CGRectGetMinY(Vwtbl.frame)==40.0f) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            view.frame=CGRectMake(0, CGRectGetMaxY(btn.frame)+5, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
            Vwtbl.frame=CGRectMake(CGRectGetMinX(Vwtbl.frame), CGRectGetMaxY(view.frame)+2, CGRectGetWidth(Vwtbl.frame), CGRectGetHeight(Vwtbl.frame)-CGRectGetHeight(view.frame));
            CGRect frameTbl=tabvToDoList.frame;
            frameTbl.size.height=Vwtbl.frame.size.height;
            tabvToDoList.frame=frameTbl;
        }];
        
    }
    
}

#pragma mark Hide Selection View Method
-(void)hideSubSelectionView:(UIView *)view
{
    if (CGRectGetMinY(view.frame)!=0.0f) {
        [UIView animateWithDuration:0.2 animations:^{
            
            view.frame=CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
            Vwtbl.frame=CGRectMake(CGRectGetMinX(Vwtbl.frame), 40, CGRectGetWidth(Vwtbl.frame), CGRectGetHeight(Vwtbl.frame)+CGRectGetHeight(view.frame));
            CGRect frameTbl=tabvToDoList.frame;
            frameTbl.size.height=Vwtbl.frame.size.height;
            tabvToDoList.frame=frameTbl;
            
        }];
    }
    
}

#pragma mark Filter Method  [ All / Current / Previous / Future ]
-(NSArray *)filterJobsWithCategory:(UIButton *)tappedbtn andSubcategory:(UIButton *)subTappedbtn
{
    NSArray *FiterArray ;
    NSArray *arrTemp=arrCFilterJoblist;
    
    if (subTappedbtn==_btnAll)
    {
        return arrCFilterJoblist;
    }
    else if (subTappedbtn==_btnCurrent)
    {
        
        NSCalendar* myCalendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                                     fromDate:[NSDate date]];
        
        DLog(@"%@", components);
        
        NSMutableArray* arrresult = [NSMutableArray array];
        
        for (NSDictionary *dict in arrTemp) {
            
            
            NSString *dateString = dict[@"JobStartDate"];
            if (![dateString isKindOfClass:[NSNull class]]||![dateString isEqualToString:@""]) {
                
                DLog(@"dateString :%@",dateString);
                NSArray *array = [dateString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
                
                
                NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                NSDate * dateOne = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld/%ld/%ld",(long)components.day,(long)components.month,(long)components.year]];
                
                NSDate * dateTwo = [dateFormatter dateFromString:(NSString *)[array objectAtIndex:0]];
                
                DLog(@"DateOne::-%@\nDAteTwo::-%@",dateOne,dateTwo);
                switch ([dateTwo compare:dateOne]) {
                    case NSOrderedAscending:
                        // dateOne is earlier in time than dateTwo
                        break;
                    case NSOrderedSame:
                    {
                        // dateOne is later in time than dateTwo
                        [arrresult addObject:dict];
                        
                        break;
                    }
                        // The dates are the same
                        break;
                    case NSOrderedDescending:
                    {
                        
                    }
                }
                
            }
        }
        return arrresult;
    }
    else if (subTappedbtn==_btnNext)
    {
        NSCalendar* myCalendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                                     fromDate:[NSDate date]];
        
        DLog(@"%@", components);
        
        NSMutableArray* arrresult = [NSMutableArray array];
        
        for (NSDictionary *dict in arrTemp) {
            NSString *dateString = dict[@"JobStartDate"];
            if (![dateString isKindOfClass:[NSNull class]]||![dateString isEqualToString:@""]) {
                NSArray *array = [dateString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
                
                NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                NSDate * dateOne = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld/%ld/%ld",(long)components.day,(long)components.month,(long)components.year]];
                
                NSDate * dateTwo = [dateFormatter dateFromString:(NSString *)[array objectAtIndex:0]];
                
                DLog(@"DateOne::-%@\nDAteTwo::-%@",dateOne,dateTwo);
                switch ([dateTwo compare:dateOne]) {
                    case NSOrderedAscending:
                        // dateOne is earlier in time than dateTwo
                        break;
                    case NSOrderedSame:
                        // The dates are the same
                        break;
                    case NSOrderedDescending:
                    {
                        // dateOne is later in time than dateTwo
                        [arrresult addObject:dict];
                        
                        break;
                    }
                }
            }
        }
        return arrresult;
    }
    else if (subTappedbtn==_btnPrevious)
    {
        NSCalendar* myCalendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                                     fromDate:[NSDate date]];
        
        DLog(@"%@", components);
        
        NSMutableArray* arrresult = [NSMutableArray array];
        
        for (NSDictionary *dict in arrTemp) {
            
            NSString *dateString = dict[@"JobStartDate"];
            if (![dateString isKindOfClass:[NSNull class]]||![dateString isEqualToString:@""]) {
                NSArray *array = [dateString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
                
                NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                NSDate * dateOne = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld/%ld/%ld",(long)components.day,(long)components.month,(long)components.year]];
                
                NSDate * dateTwo = [dateFormatter dateFromString:(NSString *)[array objectAtIndex:0]];
                DLog(@"DateOne::-%@\nDAteTwo::-%@",dateOne,dateTwo);
                
                switch ([dateTwo compare:dateOne])
                {
                    case NSOrderedAscending:
                    {
                        // dateOne is earlier in time than dateTwo
                        [arrresult addObject:dict];
                        break;
                    }
                    case NSOrderedSame:
                        // The dates are the same
                        break;
                    case NSOrderedDescending:
                        // dateOne is later in time than dateTwo
                        break;
                }
                
            }
        }
        
        return arrresult;
    }
    
    return FiterArray;
}

#pragma mark - Job Filter Method [Job Invitation / Job Assgined]
-(IBAction)jobsInvitationPress:(UIButton *)sender
{
    page =0;
    [MBProgressHUD hideAllHUDsForView:Vwtbl animated:NO];
    arrMFilterJobsList = [[NSMutableArray alloc]init];
    _btnJobsInvitation.selected=YES;
    _btnAssignedJobs.selected=NO;
    isbtnAssignedClicked=NO;
    isbtnInvitationClicked=YES;
    [conn cancel];
    conn=nil;
    [self btnNewInvitationTapped:_btnNewInvitation];
    
    [self fetchJobdetails];
    
    [self animateToActiveButton:sender withImageview:_selectedEngineer];
}


-(IBAction)assignedJobsPress:(UIButton *)sender
{
    page=0;
    lblNoJobs.hidden=YES;
    [MBProgressHUD hideAllHUDsForView:Vwtbl animated:NO];
    
    arrMFilterJobsList = [[NSMutableArray alloc]init];
    
    _btnJobsInvitation.selected=NO;
    _btnAssignedJobs.selected=YES;
    
    [conn cancel];
    conn=nil;
    
    [arrMFilterJobsList addObjectsFromArray:arrMAssignedJobs];
    
    
    [tabvToDoList reloadData];
    isbtnAssignedClicked=YES;
    isbtnInvitationClicked=NO;
    
    [lblNoJobs removeFromSuperview];
    lblNoJobs=nil;
    
    [self fetchJobdetails];
    
    if (_btnAll.selected==YES)
    {
        [self allPress:_btnAll];
    }
    else if (_btnAssigned.selected==YES)
    {
        [self bookedPress:_btnAssigned];
    }
    else if (_btnActiveAssigns.selected==YES)
    {
        [self activePress:_btnActiveAssigns];
    }
    else if (_btnCompleteAssign.selected==YES)
    {
        [self completePress:_btnCompleteAssign];
    }
    else
    {
        [self bookedPress:_btnAssigned];
    }
    
    [self hideSubSelectionView:_vwSubInvitations];
    [self hideSubSelectionView:_viewsubTabAgreement];
    [self animateToActiveButton:sender withImageview:_selectedEngineer];
    [self animateSubSelectionViewForButton:sender forView:_viewSubTabAssignment];
}


#pragma mark - Job Filter Method [Active / Book / Complete]
-(IBAction)activePress:(UIButton *)sender
{
    self.activity.hidden=YES;
    self.lblRefresh.hidden=YES;
    [self.activity stopAnimating];
    self.btnRefresh.hidden=NO;
   
 
    NSPredicate *predicate;
    lblNoJobs.hidden=YES;
    [tabvToDoList setContentOffset:CGPointZero];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        
        _btnActiveAssigns.selected=YES;
        _btnAssigned.selected=NO;
        _btnCompleteAssign.selected=NO;
        
        btnActiveCategory=_btnActiveAssigns;
        predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"JobStatus == %d",Active]];
        DLog(@"pree :%@",predicate);
        
        NSArray *newArray = [arrMAssignedJobs filteredArrayUsingPredicate:predicate];
        DLog(@"%lu", (unsigned long)[newArray count]);
        // DLog(@"%@", newArray);
        arrMFilterJobsList=(NSMutableArray *)newArray;
        if (arrMFilterJobsList.count==0) {
            lblNoJobs.text=@"No Active jobs";
            lblNoJobs.hidden=NO;
            
        }
        [tabvToDoList reloadData];
        
        
        for (UIButton  *btn in [_viewSubTabAssignment subviews])
        {
            if (btn==sender)
            {
                btn.backgroundColor=[UIColor colorWithRed:91/255.0f green:178/255.0f blue:50/255.0f alpha:1];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            else
            {
                btn.backgroundColor=[UIColor colorWithRed:132/255.0f green:172/255.0f blue:75/255.0f alpha:1];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        
    }
    else if ((arrMActiveJobDetails.count==0) || (loadActivePageCount!=0)||(refreshPagecount==0)||(SignAgreementCount==1))
    {
       
        
        SignAgreementCount=0;
        loadActivePageCount=0;
        _btnActive.selected=YES;
        _btnBooked.selected=NO;
        _btnComplete.selected=NO;
        btnActiveCategory=_btnActive;


        if (_btnNoAgreement.selected==YES)
        {
            predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"JobStatus == %d AND IsAgreementSign=%d",Active,No_agreement_signed]];
            self.activity.hidden=YES;
            self.lblRefresh.hidden=YES;
            [self.activity stopAnimating];
            self.btnRefresh.hidden=NO;
        }
        else if (_btnSmallRepairAgreement.selected==YES)
        {
            
            predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"JobStatus == %d AND IsAgreementSign=%d",Active,Small_repair_agreement_signed]];
            self.activity.hidden=YES;
            self.lblRefresh.hidden=YES;
            [self.activity stopAnimating];
            self.btnRefresh.hidden=NO;
        }
        else if (_btnBothAgreement.selected==YES)
        {
            
            predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"JobStatus == %d AND IsAgreementSign=%d",Active,Both_agreement_signed]];
            self.activity.hidden=YES;
            self.lblRefresh.hidden=YES;
            [self.activity stopAnimating];
            self.btnRefresh.hidden=NO;
        }
        else
        {
            predicate = [NSPredicate predicateWithFormat:@"JobStatus == 2"];
            self.activity.hidden=YES;
            self.lblRefresh.hidden=YES;
            [self.activity stopAnimating];
            self.btnRefresh.hidden=NO;
            
        }
        
        DLog(@"pree :%@",predicate);
        NSArray *newArray = [arrMJobDetails filteredArrayUsingPredicate:predicate];
        DLog(@"%lu", (unsigned long)[newArray count]);
        // DLog(@"%@", newArray);
        arrMFilterJobsList=(NSMutableArray *)newArray;
        arrCFilterJoblist=arrMFilterJobsList;
        
        if(arrMActiveFilterJobsList.count==0)
        {
            
            arrMActiveFilterJobsList=arrMFilterJobsList;
            
        }
        arrMActiveJobDetails=arrMFilterJobsList;
      

        if (arrMFilterJobsList.count==0)
        {
            if (_btnNoAgreement.selected==YES)
            {
                lblNoJobs.text=@"No Active jobs with no agreement";
                self.activity.hidden=YES;
                self.lblRefresh.hidden=YES;
                [self.activity stopAnimating];
                self.btnRefresh.hidden=NO;
            }
            else if (_btnSmallRepairAgreement.selected==YES)
            {
                lblNoJobs.text=@"No Active jobs with small repair agreement";
                self.activity.hidden=YES;
                self.lblRefresh.hidden=YES;
                [self.activity stopAnimating];
                self.btnRefresh.hidden=NO;
                
            }
            else if (_btnBothAgreement.selected==YES)
            {
                lblNoJobs.text=@"No Active jobs with both agreement";
                self.activity.hidden=YES;
                self.lblRefresh.hidden=YES;
                [self.activity stopAnimating];
                self.btnRefresh.hidden=NO;
            }
            else
            {
                lblNoJobs.text=@"";
                self.activity.hidden=YES;
                self.lblRefresh.hidden=YES;
                [self.activity stopAnimating];
                self.btnRefresh.hidden=NO;
            }
            lblNoJobs.numberOfLines=0;
            [lblNoJobs sizeToFit];
            lblNoJobs.center=CGPointMake(CGRectGetWidth(Vwtbl.frame)/2.0f, CGRectGetHeight(Vwtbl.frame)/2.0f);
            lblNoJobs.hidden=NO;
            
            
        }
        
        [tabvToDoList reloadData];
        [self fetchJobdetails];

        if(loadActivePageCount==1)
        {
            loadActivePageCount=0;
        }

        
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        
        _btnActive.selected=YES;
        _btnBooked.selected=NO;
        _btnComplete.selected=NO;
        btnActiveCategory=_btnActive;

        
        if (_btnNoAgreement.selected==YES)
        {
            
            predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"JobStatus == %d AND IsAgreementSign=%d",Active,No_agreement_signed]];
            self.activity.hidden=YES;
            self.lblRefresh.hidden=YES;
            [self.activity stopAnimating];
            self.btnRefresh.hidden=NO;
        }
        else if (_btnSmallRepairAgreement.selected==YES)
        {
            predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"JobStatus == %d AND IsAgreementSign=%d",Active,Small_repair_agreement_signed]];
            self.activity.hidden=YES;
            self.lblRefresh.hidden=YES;
            [self.activity stopAnimating];
            self.btnRefresh.hidden=NO;
        }
        else if (_btnBothAgreement.selected==YES)
        {
            predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"JobStatus == %d AND IsAgreementSign=%d",Active,Both_agreement_signed]];
            self.activity.hidden=YES;
            self.lblRefresh.hidden=YES;
            [self.activity stopAnimating];
            self.btnRefresh.hidden=NO;
        }
        else
        {
            predicate = [NSPredicate predicateWithFormat:@"JobStatus == 2"];
            
            self.activity.hidden=YES;
            self.lblRefresh.hidden=YES;
            [self.activity stopAnimating];
            self.btnRefresh.hidden=NO;
            
        }
        
        DLog(@"pree :%@",predicate);
        
     
       
        if((loadActivePageCount!=0)||(loadActivePageCount2==1))
        {

            NSArray *newArray = [arrMJobDetails filteredArrayUsingPredicate:predicate];
            DLog(@"%lu", (unsigned long)[newArray count]);
            arrMFilterJobsList=(NSMutableArray *)newArray;
            arrCFilterJoblist=arrMFilterJobsList;
            arrMActiveJobDetails=arrMFilterJobsList;
            self.activity.hidden=YES;
            self.lblRefresh.hidden=YES;
            [self.activity stopAnimating];
            self.btnRefresh.hidden=NO;

            
        }
       else if (loadActivePageCount==0)
       {
           
           NSArray *newArray = [arrMActiveJobDetails filteredArrayUsingPredicate:predicate];
           DLog(@"%lu", (unsigned long)[newArray count]);
           arrMFilterJobsList=(NSMutableArray *)newArray;
           arrCFilterJoblist=arrMFilterJobsList;
           self.activity.hidden=YES;
           self.lblRefresh.hidden=YES;
           [self.activity stopAnimating];
           self.btnRefresh.hidden=NO;
        }
       
 
        if (arrMFilterJobsList.count==0)
        {
            
            if (_btnNoAgreement.selected==YES) {
                lblNoJobs.text=@"No Active jobs with no agreement";
            }
            else if (_btnSmallRepairAgreement.selected==YES)
            {
                lblNoJobs.text=@"No Active jobs with small repair agreement";
                
            }
            else if (_btnBothAgreement.selected==YES)
            {
                lblNoJobs.text=@"No Active jobs with both agreement";
            }
            else
            {
                lblNoJobs.text=@"";
            }
            lblNoJobs.numberOfLines=0;
            [lblNoJobs sizeToFit];
            lblNoJobs.center=CGPointMake(CGRectGetWidth(Vwtbl.frame)/2.0f, CGRectGetHeight(Vwtbl.frame)/2.0f);
            lblNoJobs.hidden=NO;
            
            
            
        }
        
        [tabvToDoList reloadData];
        
    }
  
    [self hideSubSelectionView:_viewSubTabAllCurrPrevNext];
    [self animateSubSelectionViewForButton:sender forView:_viewsubTabAgreement];
    [self hideSubSelectionView:_vwSubInvitations];
    [self animateToActiveButton:sender withImageview:_selected];
    
    
}
-(IBAction)bookedPress:(UIButton *)sender
{
 
    lblNoJobs.hidden=YES;
    [tabvToDoList setContentOffset:CGPointZero];
    
    NSPredicate *predicate ;
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
             
        _btnAll.selected=NO;

        _btnActiveAssigns.selected=NO;

        _btnAssigned.selected=NO;

        _btnCompleteAssign.selected=NO;
        
        if(sender == _btnAll){
            _btnAll.selected=YES;
        }
        else if(sender == _btnAssigned){
            _btnAssigned.selected=YES;
            predicate = [NSPredicate predicateWithFormat:@"JobStatus == 1"];
            DLog(@"pree :%@",predicate);
            
            NSArray *newArray = [arrMAssignedJobs filteredArrayUsingPredicate:predicate];
            DLog(@"%lu", (unsigned long)[newArray count]);
            arrMFilterJobsList=(NSMutableArray *)newArray;
            if (arrMFilterJobsList.count==0) {
                lblNoJobs.text=@"No New Job Assigned";
                lblNoJobs.hidden=NO;
                
            }

        }
        else if(sender == _btnCompleteAssign){
            _btnCompleteAssign.selected=YES;

        }
        else if(sender == _btnActiveAssigns){
            _btnActiveAssigns.selected=YES;

        }
        
        btnActiveCategory=sender;

//        _btnActiveAssigns.selected=NO;
//        _btnAssigned.selected=YES;
//        _btnCompleteAssign.selected=NO;
//        btnActiveCategory=_btnAssigned;
        
      
        [tabvToDoList reloadData];
        
        for (UIButton  *btn in [_viewSubTabAssignment subviews]) {
            
            if (btn==sender)
            {
                btn.backgroundColor=[UIColor colorWithRed:91/255.0f green:178/255.0f blue:50/255.0f alpha:1];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            else
            {
                btn.backgroundColor=[UIColor colorWithRed:132/255.0f green:172/255.0f blue:75/255.0f alpha:1];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        
        
    }
    else if((arrMBookedJobDetails.count==0)|| (loadBookedPageCount!=0)||(refreshPagecount==0)||(refreshPagecount==2))
    {
        
        loadBookedPageCount=0;
        _btnActive.selected=NO;
        _btnBooked.selected=YES;
        _btnComplete.selected=NO;
        btnActiveCategory=_btnBooked;
        
     
        predicate = [NSPredicate predicateWithFormat:@"JobStatus == 1"];
        
        DLog(@"pree :%@",predicate);

      
        NSArray *newArray = [arrMJobDetails filteredArrayUsingPredicate:predicate];
        DLog(@"%lu", (unsigned long)[newArray count]);
        arrMFilterJobsList=(NSMutableArray *)newArray;
        arrCFilterJoblist=arrMFilterJobsList;
     
        if(arrMBookedJobDetails.count==0)
        {
            
            arrMBookedFilterJobsList=arrMFilterJobsList;
            
        }
        arrMBookedJobDetails=arrMFilterJobsList;
       
        [tabvToDoList reloadData];
        [self fetchJobdetails];
 
        
        [self animateToActiveButton:sender withImageview:_selected];
        [self hideSubSelectionView:_viewsubTabAgreement];
        [self hideSubSelectionView:_vwSubInvitations];
        [self animateSubSelectionViewForButton:sender forView:_viewSubTabAllCurrPrevNext];
        
        if (_btnAll.selected==YES)
        {
            [self allPress:_btnAll];
            
        }
        else if ( _btnCurrent.selected==YES)
        {
            [self currentPress:_btnCurrent];
            
        }
        else if (_btnPrevious.selected==YES)
        {
            [self previousPress:_btnPrevious];
            
        }
        else if ( _btnNext.selected==YES)
        {
            [self nextPress:_btnNext];
            
        }
        else
        {
            
        }
        if (refreshPagecount==0)
        {
            refreshPagecount=refreshPagecount+1;
            
        }
        if(refreshPagecount==2)
        {
            refreshPagecount=1;
        }
        if(loadBookedPageCount==1)
        {
            loadBookedPageCount=0;
        }


    
    }
    else if  ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
       
        
           _btnActive.selected=NO;
           _btnBooked.selected=YES;
           _btnComplete.selected=NO;
            btnActiveCategory=_btnBooked;
            lblNoJobs.hidden=YES;
            arrCFilterJoblist=arrMBookedJobDetails;
           arrMFilterJobsList=arrMBookedJobDetails;

        [tabvToDoList reloadData];
        if (_btnAll.selected==YES)
        {
            [self allPress:_btnAll];
            
        }
        else if ( _btnCurrent.selected==YES)
        {
            [self currentPress:_btnCurrent];
            
        }
        else if (_btnPrevious.selected==YES)
        {
            [self previousPress:_btnPrevious];
            
        }
        else if ( _btnNext.selected==YES)
        {
            [self nextPress:_btnNext];
            
        }
        else
        {
            
        }
               
           [self animateToActiveButton:sender withImageview:_selected];
           [self hideSubSelectionView:_viewsubTabAgreement];
           [self hideSubSelectionView:_vwSubInvitations];
           [self animateSubSelectionViewForButton:sender forView:_viewSubTabAllCurrPrevNext];
        
       }
        
  
   
    

}
-(IBAction)completePress:(UIButton *)sender
{
   
    lblNoJobs.hidden=YES;
    [tabvToDoList setContentOffset:CGPointZero];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"JobStatus > 2"];
    DLog(@"pree :%@",predicate);
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        _btnActiveAssigns.selected=NO;
        _btnAssigned.selected=NO;
        _btnCompleteAssign.selected=YES;
        btnActiveCategory=_btnCompleteAssign;
        
        NSArray *newArray = [arrMAssignedJobs filteredArrayUsingPredicate:predicate];
        DLog(@"%lu", (unsigned long)[newArray count]);
        // DLog(@"%@", newArray);
        arrMFilterJobsList=(NSMutableArray *)newArray;
        [tabvToDoList reloadData];
        
        
        for (UIButton  *btn in [_viewSubTabAssignment subviews])
        {
            if (btn==sender)
            {
                btn.backgroundColor=[UIColor colorWithRed:91/255.0f green:178/255.0f blue:50/255.0f alpha:1];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            else
            {
                btn.backgroundColor=[UIColor colorWithRed:132/255.0f green:172/255.0f blue:75/255.0f alpha:1];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
    else if (arrMCompleteJobDetails.count==0||(loadCompletePageCount!=0)||(refreshCompletePagecount==1))
    {
        
        loadCompletePageCount=0;
        _btnActive.selected=NO;
        _btnBooked.selected=NO;
        _btnComplete.selected=YES;
        btnActiveCategory=_btnComplete;
     
 
        NSArray *newArray = [arrMJobDetails filteredArrayUsingPredicate:predicate];
        DLog(@"%lu", (unsigned long)[newArray count]);
        // DLog(@"%@", newArray);
        arrMFilterJobsList=(NSMutableArray *)newArray;
        arrCFilterJoblist=arrMFilterJobsList;
        if (arrMCompleteJobDetails.count==0)
        {
            arrMCompleteFilterJobsList=arrMFilterJobsList;
        }
        arrMCompleteJobDetails = arrMFilterJobsList;
        if (arrCFilterJoblist.count==0)
        {
            lblNoJobs.text=@"";
            lblNoJobs.hidden=NO;
            
        }
        [tabvToDoList reloadData];
        [self fetchJobdetails];

        if(refreshCompletePagecount==1)
        {
            refreshCompletePagecount=2;
        }

       if(loadCompletePageCount==1)
       {
           loadCompletePageCount=0;
       }
        
        
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        
        _btnActive.selected=NO;
        _btnBooked.selected=NO;
        _btnComplete.selected=YES;
        btnActiveCategory=_btnComplete;
        arrMFilterJobsList =arrMCompleteJobDetails;
        [tabvToDoList reloadData];
    }
    [self hideSubSelectionView:_viewSubTabAllCurrPrevNext];
    [self hideSubSelectionView:_viewsubTabAgreement];
    [self hideSubSelectionView:_vwSubInvitations];
    [self animateToActiveButton:sender withImageview:_selected];
    
    
    
}

#pragma mark - Sub Tab Filter Method [No Agreement / Small Agreement / Both Agreement]
- (IBAction)btnNoAgreementPress:(id)sender
{
    _btnNoAgreement.selected=YES;
    _btnSmallRepairAgreement.selected=NO;
    _btnBothAgreement.selected=NO;
    
    [self activePress:_btnActive];
    
    
}

- (IBAction)btnSmallRepairAgreementPress:(id)sender {
    _btnNoAgreement.selected=NO;
    _btnSmallRepairAgreement.selected=YES;
    _btnBothAgreement.selected=NO;
    
    [self activePress:_btnActive];
}

- (IBAction)btnOnlineOfflineAction:(id)sender {

    if([[_btnOnlineOffline currentTitle]  isEqual: @"Online"]){
        [_btnOnlineOffline setBackgroundImage:[UIImage imageNamed:@"rejected"] forState:UIControlStateNormal];
        isUserWantOnline = 0;
        [_btnOnlineOffline setTitle:@"Offline" forState:UIControlStateNormal];
      //  [self showAlert:@"You are not available to accept jobs." withTitle:@"Offline"];

        [self setEngAvailabilityDetails:@"0" addressValue:@""];
    }
    else{
        PostCodePopupController *post = [[PostCodePopupController alloc] initWithNibName:@"PostCodePopupController" bundle:nil];
        post.delegate=self;
        post.isComeFromOnlineOffline = TRUE;
        [self presentViewController:post animated:YES completion:nil];
        
        isUserWantOnline = 1;


    }
}

- (IBAction)btnBothAgreementPress:(id)sender {
    _btnNoAgreement.selected=NO;
    _btnSmallRepairAgreement.selected=NO;
    _btnBothAgreement.selected=YES;
    
    [self activePress:_btnActive];
}

#pragma mark - Sub Tab Filter Method [All / Current / Previous / Next]
-(IBAction)allPress:(UIButton *)sender
{
    lblNoJobs.hidden=YES;
    
    UIView *selectionView;
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        _btnAll.selected=YES;
        _btnAssigned.selected=NO;
        _btnActiveAssigns.selected=NO;
        _btnCompleteAssign.selected=NO;
        selectionView=_viewSubTabAssignment;
        
        arrMFilterJobsList=arrMAssignedJobs;
        if (arrMFilterJobsList.count==0) {
            lblNoJobs.text=@"No Jobs to show";
            lblNoJobs.hidden=NO;
        }
        [tabvToDoList reloadData];
        
    }
    else
    {
        _btnAll.selected=YES;
        _btnCurrent.selected=NO;
        _btnPrevious.selected=NO;
        _btnNext.selected=NO;
        selectionView=_viewSubTabAllCurrPrevNext;
        
        arrMFilterJobsList=(NSMutableArray *)[self filterJobsWithCategory:btnActiveCategory andSubcategory:sender];
        if (arrMFilterJobsList.count==0) {
            lblNoJobs.text=@"";
            lblNoJobs.hidden=NO;
        }
        [tabvToDoList reloadData];
    }
    
    for (UIButton  *btn in [selectionView subviews])
    {
        if (btn.currentTitle == sender.currentTitle)
        {
            btn.backgroundColor=[UIColor colorWithRed:91/255.0f green:178/255.0f blue:50/255.0f alpha:1];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            btn.backgroundColor=[UIColor colorWithRed:132/255.0f green:172/255.0f blue:75/255.0f alpha:1];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    
    
}


-(IBAction)currentPress:(UIButton *)sender
{
    lblNoJobs.hidden=YES;
    _btnAll.selected=NO;
    _btnCurrent.selected=YES;
    _btnPrevious.selected=NO;
    _btnNext.selected=NO;
    for (UIButton  *btn in [_viewSubTabAllCurrPrevNext subviews]) {
        
        if (btn==sender)
        {
            btn.backgroundColor=[UIColor colorWithRed:91/255.0f green:178/255.0f blue:50/255.0f alpha:1];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }
        else {
            btn.backgroundColor=[UIColor colorWithRed:132/255.0f green:172/255.0f blue:75/255.0f alpha:1];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    arrMFilterJobsList=(NSMutableArray *)[self filterJobsWithCategory:btnActiveCategory andSubcategory:sender];
    if (arrMFilterJobsList.count==0) {
        lblNoJobs.text=@"No Current jobs";
        lblNoJobs.hidden=NO;
        
    }
    [tabvToDoList reloadData];
    
    
}


-(IBAction)previousPress:(UIButton *)sender
{
    lblNoJobs.hidden=YES;
    _btnAll.selected=NO;
    
    _btnCurrent.selected=NO;
    
    _btnPrevious.selected=YES;
    
    _btnNext.selected=NO;
    for (UIButton  *btn in [_viewSubTabAllCurrPrevNext subviews]) {
        
        if (btn==sender) {
            btn.backgroundColor=[UIColor colorWithRed:91/255.0f green:178/255.0f blue:50/255.0f alpha:1];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }
        else {
            btn.backgroundColor=[UIColor colorWithRed:132/255.0f green:172/255.0f blue:75/255.0f alpha:1];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    arrMFilterJobsList=(NSMutableArray *)[self filterJobsWithCategory:btnActiveCategory andSubcategory:sender];
    if (arrMFilterJobsList.count==0) {
        lblNoJobs.text=@"No Previous jobs";
        lblNoJobs.hidden=NO;
        
    }
    
    [tabvToDoList reloadData];
}
-(IBAction)nextPress:(UIButton *)sender
{
    lblNoJobs.hidden=YES;
    
    _btnAll.selected=NO;
    
    _btnCurrent.selected=NO;
    
    _btnPrevious.selected=NO;
    
    _btnNext.selected=YES;
    for (UIButton  *btn in [_viewSubTabAllCurrPrevNext subviews]) {
        
        if (btn==sender) {
            btn.backgroundColor=[UIColor colorWithRed:91/255.0f green:178/255.0f blue:50/255.0f alpha:1];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }
        else {
            
            btn.backgroundColor=[UIColor colorWithRed:132/255.0f green:172/255.0f blue:75/255.0f alpha:1];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    arrMFilterJobsList=(NSMutableArray *)[self filterJobsWithCategory:btnActiveCategory andSubcategory:sender];
    if (arrMFilterJobsList.count==0) {
        lblNoJobs.text=@"No Future jobs";
        lblNoJobs.hidden=NO;
        
    }
    
    [tabvToDoList reloadData];
    
}


#pragma mark - viewDidDisappear Method
-(void)viewDidDisappear:(BOOL)animated{
    
    [conn cancel];
    conn=nil;
    [self.dataTask cancel];
   
    
}


#pragma mark - ViewWillAppear method
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refershControlAction)
                                                 name:@"reloadView" object:nil];
    
}

#pragma mark - viewWillAppear Method
-(void)viewWillAppear:(BOOL)animated
{
    
        [super viewWillAppear:YES];
    
    
    page=0;
    loadBookedPageCount=0;
    loadActivePageCount=0;

    loadCompletePageCount=0;
 
    if(_btnBooked.isSelected==YES)
    {
        
        
        BookedPage=0;
    refreshPagecount=0;
    loadActivePageCount2=0;
        SignAgreementCount1 = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"StringCount"];
        if([SignAgreementCount1  isEqual: @"ndata"])
        {

//            _btnActive.selected=NO;
              _btnNoAgreement.selected =NO;
                _btnSmallRepairAgreement.selected=NO;
                _btnBothAgreement.selected = NO;
        arrMActiveJobDetails=nil;
        arrMActiveFilterJobsList =nil;
            NSString *Count = @"data";
            
            [[NSUserDefaults standardUserDefaults] setObject:Count forKey:@"StringCount"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

    
    }
    if(_btnActive.isSelected==YES)
    {
        
        ActivePage=0;
        refreshActivePagecount=0;
        SignAgreementCount1 = [[NSUserDefaults standardUserDefaults]
              stringForKey:@"StringCount"];
        if([SignAgreementCount1  isEqual: @"ndata"])
        {
        
            SignAgreementCount=1;
//        _btnActive.selected=NO;
        _btnNoAgreement.selected =NO;
          _btnSmallRepairAgreement.selected=NO;
          _btnBothAgreement.selected = NO;
         arrMActiveJobDetails=nil;
        arrMActiveFilterJobsList =nil;
         arrCFilterJoblist=nil;
            NSString *Count = @"data";
            
            [[NSUserDefaults standardUserDefaults] setObject:Count forKey:@"StringCount"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
    

    }
    if(_btnComplete.isSelected==YES)
    {
        CompletePage=0;
        refreshCompletePagecount=0;
        loadActivePageCount2=0;
        

    }
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"arrEditedJobDic"]) {
        NSArray *arr=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrEditedJobDic"];
        arrEditedJobDic=[[NSMutableArray alloc]initWithArray:arr];
  
    }
    
    
    [tabvToDoList reloadData];
    [_btnOnlineOffline setHidden:TRUE];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
    {
        [self fetchJobdetails];
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        
        [self fetchJobdetails];
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        
        [_btnOnlineOffline setHidden:FALSE];
        
        if (_btnJobsInvitation.selected==YES)
        {
            [self jobsInvitationPress:_btnJobsInvitation];
        }
        else if (_btnAssignedJobs.selected==YES)
        {
            [self assignedJobsPress:_btnAssignedJobs];
        }
        
       // [self fetchEngAvailabilityDetails];

    }
    
}



#pragma mark - viewDidLoad method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    globe = [GlobalDirector SharedDirector];
    
    yOffset =0.0f;
    page=0;
    loadBookedPageCount=0;
    loadActivePageCount=0;
//    loadActivePageCount2=0;
    loadCompletePageCount=0;
    BookedPage=0;
    ActivePage=0;
    CompletePage=0;
    NSString *Count = @"data";
    
    [[NSUserDefaults standardUserDefaults] setObject:Count forKey:@"StringCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"reloadView" object:nil];
    
    
    
    app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (app.locationManager==nil) {
        app.locationManager = [[CLLocationManager alloc] init];
        app.locationManager.delegate = app;
        app.locationManager.distanceFilter = 100;
        app.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        app.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        [app requestAlwaysAuthorization];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        NSDictionary *user = [[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
        engineerStaffId = [user valueForKey:@"StaffID"];
        
        [app.locationManager startUpdatingLocation];
        
        [_btnOnlineOffline.layer setCornerRadius:_btnOnlineOffline.frame.size.height/2.0];

    }
    
    
    
    
    [app GetMessageCount];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=YES;
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
    
    _btnaddjob.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:19.0];
    tabvToDoList.backgroundView=nil;
    tabvToDoList.backgroundColor=[UIColor clearColor];
    tabvToDoList.separatorColor=[UIColor clearColor];
    _btnAll.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    _btnCurrent.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    _btnPrevious.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    _btnNext.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    _btnAssigned.selected=YES;
    _HelpWidgetBtn.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:19.0];
    
    
    
    
    
    arrMJobDetails=[[NSMutableArray alloc]init];
    arrJobStatus=[[NSArray alloc]init];
    
    
    
    arrJobStatus= @[
        @{
            @"DisplayText" : @"Booked",
            @"Value" : @1
        },
        
        @{
            @"DisplayText":@"Active",
            @"Value" :@2
        },
        
        @{
            @"DisplayText":@"Complete",
            @"Value" :@3
            
        },
        @{
            
            @"DisplayText":@"Attention",
            @"Value" :@4
        },
        @{
            @"DisplayText":@"Quote",
            @"Value" :@5
        },
        @{
            
            @"DisplayText":@"Forward Booked",
            @"Value" :@6
        },
        @{
            
            @"DisplayText":@"Call Back",
            @"Value" :@7
        },
        @{
            
            @"DisplayText":@"Chase Up",
            @"Value" :@8
        },
        @{
            
            @"DisplayText":@"Reminders",
            @"Value" :@9
        },
        @{
            @"DisplayText":@"Parts on Order",
            @"Value" :@10
        },
        @{
            @"DisplayText":@"Continue Without Authorization",
            @"Value" :@11
        },
        @{
            @"DisplayText":@"Job Cancelled",
            @"Value" :@12
        }
    ];
    
    
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [self setRefreshControlText:@"Loading.."];
    [refreshControl addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
    [tabvToDoList addSubview:refreshControl];
    tabvToDoList.alwaysBounceVertical = YES;
    
    btnListandCalender.tag=0;
    viewToDoList.hidden=NO;
    ViewCalendar.hidden=YES;
    
    //**********************************************************************************
    lblNotifications.layer.cornerRadius=CGRectGetHeight(lblNotifications.frame)/2.0f;
    lblMesseges.layer.cornerRadius=CGRectGetHeight(lblMesseges.frame)/2.0f;
    lblNotifications.clipsToBounds=YES;
    lblMesseges.clipsToBounds=YES;
    lblNotifications.hidden=YES;
    lblMesseges.hidden=YES;
    //**********************************************************************************
    
    //-------------------- Button Sub Tab ----------------------------------------------
    [_btnAll.layer setBorderColor: [[UIColor clearColor] CGColor]];
    [_btnAll.layer setBorderWidth: 0.0];
    [_btnAll.layer setCornerRadius:0.0f];
    [_btnAll.layer setMasksToBounds:YES];
    
    [_btnCurrent.layer setBorderColor: [[UIColor clearColor] CGColor]];
    [_btnCurrent.layer setBorderWidth: 0.0];
    [_btnCurrent.layer setCornerRadius:0.0f];
    [_btnCurrent.layer setMasksToBounds:YES];
    
    [_btnPrevious.layer setBorderColor: [[UIColor clearColor] CGColor]];
    [_btnPrevious.layer setBorderWidth: 0.0];
    [_btnPrevious.layer setCornerRadius:0.0f];
    [_btnPrevious.layer setMasksToBounds:YES];
    
    [_btnNext.layer setBorderColor: [[UIColor clearColor] CGColor]];
    [_btnNext.layer setBorderWidth: 0.0];
    [_btnNext.layer setCornerRadius:0.0f];
    [_btnNext.layer setMasksToBounds:YES];
    //----------------------------------------------------------------------------------
    
    self.btnRefresh.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [self.btnRefresh setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [self.lblRefresh setHighlighted:YES];
    //----------------------------------------------------------------------------------
    
    for (UIButton *btn in [_viewsubTabAgreement subviews])
    {
        btn.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
        btn.titleLabel.numberOfLines=2;
        btn.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
        btn.titleLabel.textAlignment=NSTextAlignmentCenter;
        [btn.layer setBorderColor: [[UIColor clearColor] CGColor]];
        [btn.layer setBorderWidth: 0.0];
        [btn.layer setCornerRadius:0.0f];
        [btn.layer setMasksToBounds:YES];
    }
    
    DLog(@"LoggedUser ::::%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"]);
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
    {
        _vwtab.hidden=YES;
        _vwtab.userInteractionEnabled=NO;
        _vwSubInvitations.hidden=YES;
        
        viewToDoList.frame=CGRectMake(0,viewToDoList.frame.origin.y, viewToDoList.frame.size.width, viewToDoList.frame.size.height+CGRectGetHeight(_vwtab.frame));
        Vwtbl.frame=CGRectMake(0,40, Vwtbl.frame.size.width, Vwtbl.frame.size.height+CGRectGetHeight(_vwtab.frame));
        CGRect frameTbl=tabvToDoList.frame;
        frameTbl.size.height=Vwtbl.frame.size.height;
        tabvToDoList.frame=frameTbl;
        _btnaddjob.frame=CGRectMake(_btnaddjob.frame.origin.x,CGRectGetHeight(self.view.frame)-80, _btnaddjob.frame.size.width,_btnaddjob.frame.size.height);
        [self.view sendSubviewToBack:_vwtab];
        viewToDoList.backgroundColor=[UIColor clearColor];
        _HelpWidgetBtn.frame=CGRectMake(_HelpWidgetBtn.frame.origin.x,CGRectGetHeight(self.view.frame)-80, _HelpWidgetBtn.frame.size.width,_HelpWidgetBtn.frame.size.height);
        [self.view sendSubviewToBack:_vwtab];
        viewToDoList.backgroundColor=[UIColor clearColor];
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        arrMInvitations=[[NSMutableArray alloc]init];
        arrMAssignedJobs=[[NSMutableArray alloc]init];
        
        _vwtab.hidden=YES;
        _vwtab.userInteractionEnabled=NO;
        _viewUpperSelectionTab.hidden=YES;
        _viewEngineerTab.hidden=NO;
        _vwSubInvitations.hidden=NO;
        
        viewToDoList.frame=CGRectMake(0,viewToDoList.frame.origin.y, viewToDoList.frame.size.width, viewToDoList.frame.size.height+CGRectGetHeight(_vwtab.frame));
        Vwtbl.frame=CGRectMake(0,40, Vwtbl.frame.size.width, Vwtbl.frame.size.height+CGRectGetHeight(_vwtab.frame));
        _btnaddjob.frame=CGRectMake(_btnaddjob.frame.origin.x,CGRectGetHeight(self.view.frame)-80, _btnaddjob.frame.size.width,_btnaddjob.frame.size.height);
        CGRect frameTbl=tabvToDoList.frame;
        frameTbl.size.height=Vwtbl.frame.size.height-5;
        tabvToDoList.frame=frameTbl;
        isbtnAssignedClicked=NO;
        _btnJobsInvitation.selected=YES;
        viewToDoList.backgroundColor=[UIColor clearColor];
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        
        _vwtab.hidden=NO;
        _vwSubInvitations.hidden=YES;
        viewToDoList.backgroundColor=[UIColor clearColor];
        viewToDoList.frame=CGRectMake(0,viewToDoList.frame.origin.y, viewToDoList.frame.size.width, viewToDoList.frame.size.height+CGRectGetHeight(_vwtab.frame));
    }
}

#pragma mark - viewDidLoad method
-(void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadView" object:nil];
}



#pragma mark - RefershControlAction method
-(void)refershControlAction
{
    
    page=0;
    
    loadBookedPageCount=0;
    loadActivePageCount=0;
    loadCompletePageCount=0;
    refreshBookedPagecount=1;


    
    
    if(_btnBooked.isSelected==YES)
    {
        BookedPage=0;
    refreshPagecount=0;
   loadActivePageCount2 =2;
  refreshBookedPagecount2=1;


    
    }
    if(_btnActive.isSelected==YES)
    {
        
        ActivePage=0;
        refreshActivePagecount=0;
        refreshActiveloadmorePagecount=1;
        

    }
    if(_btnComplete.isSelected==YES)
    {      CompletePage=0;
        refreshCompletePagecount=0;
        loadActivePageCount2 =2;
        refreshCompleteloadmorePagecount=1;

    }
    
    DLog(@"Refersh Control Action");
    [conn cancel];
    conn=nil;
    [refreshControl beginRefreshing];
    [self fetchJobdetails];
   // [self fetchEngAvailabilityDetails];
}



-(void) receiveTestNotification:(NSNotification*)notification{
    
    
    
    if ([notification.name isEqualToString:@"reloadView"])
    {
        NSString *message;
        
        NSDictionary* userInfo = notification.userInfo;
        
        
        
        
        
        id alert = [userInfo objectForKey:@"alert"];
        if ([alert isKindOfClass:[NSString class]]) {
            message = alert;
        }
        
        
        NSString *string = message;
        if ([string rangeOfString:@"Invitation"].location != NSNotFound) {
            [self jobsInvitationPress:_btnJobsInvitation];
        }
        else if ([string rangeOfString:@"Assigned"].location != NSNotFound)
        {
            _btnAssigned.selected=YES;
            [self assignedJobsPress:_btnAssignedJobs];
            
        }
        
        else
        {
            [self fetchJobdetails];
        }
    }
}
- (void)setRefreshControlText:(NSString *)text
{
    
    UIFont * font =[UIFont boldSystemFontOfSize:12.0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on: %@",
                             [formatter stringFromDate:[NSDate date]]];
    
    //NSString *str=@"Loading..";
    NSDictionary *attributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName : [UIColor grayColor]};
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated attributes:attributes];
}





#pragma mark - Fetch Job Details method
-(void)fetchJobdetails
{

    
    lblNoJobs.text=@"";
    
    [self.dataTask cancel];
    
    self.btnRefresh.hidden=YES;
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        DLog(@"There IS NO internet connection");
        
        [self showAlert:@"Check your Internet connection" withTitle:@"Connection error!"];
        
        
        
        self.activity.hidden=YES;
        self.lblRefresh.hidden=YES;
        [self.activity stopAnimating];
        self.btnRefresh.hidden=NO;
       
    }
    
    else {
        DLog(@"There IS internet connection");

        self.activity.hidden=NO;
        self.lblRefresh.hidden=NO;
        [self.activity startAnimating];
        self.btnRefresh.hidden=YES;

        NSString *urlString;

        NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
        DLog(@"%@",user);
        
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
        {
            
            urlString=[NSString stringWithFormat:@"%sCustomerJobList?userToken=%@&UserID=%@&UserType=%@&page=%ld",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[user valueForKey:@"UserID"],(NSString *)[user valueForKey:@"UserType"],(long)page];
        }
        else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
        {
            
            
            if (isbtnAssignedClicked==YES)
            {
                //Engineer assigned Job
                urlString=[NSString stringWithFormat:@"%sGetAssignedJobListByEngineer?userToken=%@&staffID=%@&page=%ld",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[user valueForKey:@"StaffID"],(long)page];
            }
            else
            {
                //Engineer job Invited
                urlString=[NSString stringWithFormat:@"%sGetInvitationJobListByEngineer?userToken=%@&staffID=%@&page=%ld",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[user valueForKey:@"StaffID"],(long)page];
            }
            
        }
        else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
        {
            
            if(arrMJobDetails.count==0)
            {
                
            urlString=[NSString stringWithFormat:@"%sManagerBookedJobList?userToken=%@&BookedPage=%ld",conn_url,(NSString *)[user valueForKey:@"UserToken"],(long)BookedPage];
                refreshPagecount=1;
                refreshCompletePagecount=1;
                refreshActivePagecount=1;
            }
            if((_btnBooked.selected ==YES && arrMBookedJobDetails.count==0)||(loadBookedPageCount!=0)||(refreshPagecount==0))
            {
                
                urlString=[NSString stringWithFormat:@"%sManagerBookedJobList?userToken=%@&BookedPage=%ld",conn_url,(NSString *)[user valueForKey:@"UserToken"],(long)BookedPage];
                refreshPagecount=2;
        
            }
            if((_btnActive.selected ==YES && arrMActiveJobDetails.count==0) || (loadActivePageCount!=0)||(refreshActivePagecount==0)|| (SignAgreementCount==1))
            {
                
                urlString=[NSString stringWithFormat:@"%sManagerActiveJobList?userToken=%@&ActivePage=%ld",conn_url,(NSString *)[user valueForKey:@"UserToken"],(long)ActivePage];
                refreshActivePagecount=1;
            
               
            }
            
            if((_btnComplete.selected ==YES && arrMCompleteJobDetails.count==0) || (loadCompletePageCount!=0)||(refreshCompletePagecount==0))
            {
                
                urlString=[NSString stringWithFormat:@"%sManagerCompleteJobList?userToken=%@&CompletePage=%ld",conn_url,(NSString *)[user valueForKey:@"UserToken"],(long)CompletePage];
                refreshCompletePagecount=1;
            }
        }
        connIdentifier=@"conn";
        conn = [[NSURLConnection alloc]init];
        
        DLog(@"URLString=%@",urlString);
        [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
            //  DLog(@"PostString=%@",urlString);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error==nil) {
                    self->_responseData=[data mutableCopy];
                    [self connectionDidFinishLoading:self->conn];
                    
                    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
                    {
                        self.activity.hidden=YES;
                        self.lblRefresh.hidden=YES;
                        [self.activity stopAnimating];
                        self.btnRefresh.hidden=NO;
                        
                        [self->refreshControl endRefreshing];
                        
                        [self fetchEngAvailabilityDetails];

                    }
                }
                else
                {
                    self.activity.hidden=YES;
                    self.lblRefresh.hidden=YES;
                    [self.activity stopAnimating];
                    self.btnRefresh.hidden=NO;
                    
                    [self->refreshControl endRefreshing];
                }
                
            });
            
        }];
        
    }
}


#pragma mark - Fetch Engineer Availability method
-(void)fetchEngAvailabilityDetails
{
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString;
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    urlString=[NSString stringWithFormat:@"%sGetEngineerAvailabilityList?userToken=%@&staffId=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[user valueForKey:@"StaffID"]];

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
    DLog(@"PostString=%@",request);
    
    connGetAvailability = [[NSURLConnection alloc] init];
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        
        DLog(@"PostString=%@",urlString);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error==nil) {
                self->_responseEngineerAvailability=[data mutableCopy];
                [self connectionDidFinishLoading:self->connGetAvailability];
            }
            else
            {
                
                
            }
            
        });
        
    }];
    
    
//    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText=@"Loading Available time...";
//    [hud show:YES];
}


#pragma mark - Set Engineer Availability method
-(void)setEngAvailabilityDetails:(NSString *)flag addressValue:(NSString *)addressValue
{
    
    if([flag  isEqual: @"1"]){
        [self->_btnOnlineOffline setTitle:@"Online" forState:UIControlStateNormal];
        [self->_btnOnlineOffline setBackgroundImage:[UIImage imageNamed:@"allocated"] forState:UIControlStateNormal];
        [self setEngLocation:flag addressValue:addressValue];
    }
    else{
        [self->_btnOnlineOffline setTitle:@"Offline" forState:UIControlStateNormal];
        [self setEngLocation:flag addressValue:@""];
        [self->_btnOnlineOffline setBackgroundImage:[UIImage imageNamed:@"rejected"] forState:UIControlStateNormal];
    }
    
    
//    NSString *post =[NSString stringWithFormat:@""];
//    NSString *urlString;
//    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
//
//    urlString=[NSString stringWithFormat:@"%sEngineerAvailbilityUpdate?userToken=%@&staffId=%@&flag=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[user valueForKey:@"StaffID"],flag];

//
//    urlString=[urlString stringByReplacingOccurrencesOfString:@"" withString:@"%20"];
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"GET"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postData];
//    request.timeoutInterval = 300;
//    DLog(@"GetString=%@",request);
//
//    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
//
//        DLog(@"PostString=%@",urlString);
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (error==nil) {
//
//                if([flag  isEqual: @"1"]){
//                    [self->_btnOnlineOffline setTitle:@"Online" forState:UIControlStateNormal];
//                    [self->_btnOnlineOffline setBackgroundImage:[UIImage imageNamed:@"allocated"] forState:UIControlStateNormal];
//                    [self setEngLocation:flag addressValue:addressValue];
//                }
//                else{
//                    [self->_btnOnlineOffline setTitle:@"Offline" forState:UIControlStateNormal];
//                    [self setEngLocation:flag addressValue:@""];
//                    [self->_btnOnlineOffline setBackgroundImage:[UIImage imageNamed:@"rejected"] forState:UIControlStateNormal];
//                }
//            }
//            else
//            {
//
//
//            }
//
//        });
//
//    }];

}

#pragma mark - Set Engineer Location method
-(void)setEngLocation:(NSString *)flag addressValue:(NSString *)addressValue
{
    
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString;
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    CLLocationCoordinate2D coordinate = app.locationManager.location.coordinate;
    
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];

    NSLog(@"Latitude : %@", latitude);
    NSLog(@"Longitude : %@",longitude);
    
    if([flag  isEqual: @"1"]){
        MBProgressHUD *hudshow=[MBProgressHUD showHUDAddedTo:Vwtbl animated:YES];
        hudshow.labelText=@"";

        urlString=[NSString stringWithFormat:@"%sUpdateEngineerCurrentAddressDtl?userToken=%@&EngineerId=%@&IsActive=1&IsDelete=0&Lat=%@&Long=%@&CurrentAddress=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[user valueForKey:@"StaffID"],latitude,longitude, addressValue];

    }
    else{
        MBProgressHUD *hudshow=[MBProgressHUD showHUDAddedTo:Vwtbl animated:YES];
        hudshow.labelText=@"";

        urlString=[NSString stringWithFormat:@"%sUpdateEngineerCurrentAddressDtl?userToken=%@&EngineerId=%@&IsActive=0&IsDelete=1&Lat=%@&Long=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[user valueForKey:@"StaffID"],latitude,longitude];

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
    

    DLog(@"GetString=%@",request);
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        
        DLog(@"PostString=%@",urlString);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error==nil) {
                [MBProgressHUD hideAllHUDsForView:Vwtbl animated:YES];
                if([flag  isEqual: @"1"]){
                    [self showAlert:@"You are ready to accept jobs." withTitle:@"Online"];
                }
                else
                {
                    [self showAlert:@"You are not available to accept jobs." withTitle:@"Offline"];
                }
            }
            else
            {
                
                [MBProgressHUD hideAllHUDsForView:Vwtbl animated:YES];
            }
            
        });
        
    }];
  
}

#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (connection == connGetAvailability){
        _responseEngineerAvailability = [[NSMutableData alloc] init];

    }
    else{
        _responseData = [[NSMutableData alloc] init];

    }

}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == connGetAvailability){
        [_responseEngineerAvailability appendData:data];

    }
    else{
        [_responseData appendData:data];

    }
}


- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    
    return nil;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection == connGetAvailability){
        NSMutableDictionary* temp;
        if (_responseEngineerAvailability !=nil)
        {
            NSError *error;
            temp = [NSJSONSerialization JSONObjectWithData:_responseEngineerAvailability  options:NSJSONReadingMutableContainers error:&error];
            if (!error)
            {
                self.activity.hidden=YES;
                self.lblRefresh.hidden=YES;
                [self.activity stopAnimating];
                self.btnRefresh.hidden=NO;
                
                if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
                {
                        [_btnOnlineOffline setHidden:FALSE];
                   
                        id shedule=[temp objectForKey:@"EnggAvailabilityListResponse"];
                        
                        if ([shedule isKindOfClass:[NSArray class]])
                        {
                            if([shedule count] > 0){
                            for (NSDictionary *dict in shedule) {
                                NSString *engineerId = dict[@"EngineerID"];
                                if(engineerId == engineerStaffId){
                                    if ([[dict valueForKey:@"IsSelect"]boolValue]==1) {
                                        [_btnOnlineOffline setTitle:@"Online" forState:UIControlStateNormal];
                                       // [_btnOnlineOffline setBackgroundColor:[UIColor systemGreenColor]];
                                        [_btnOnlineOffline setBackgroundImage:[UIImage imageNamed:@"allocated"] forState:UIControlStateNormal];
                                    }
                                    else{
                                        [_btnOnlineOffline setBackgroundImage:[UIImage imageNamed:@"rejected"] forState:UIControlStateNormal];

//                                        [_btnOnlineOffline setBackgroundColor:[UIColor systemRedColor]];
                                        [_btnOnlineOffline setTitle:@"Offline" forState:UIControlStateNormal];

                                    }
                                    break;
                                }

                            }
                            }
                            else{
                                [_btnOnlineOffline setBackgroundImage:[UIImage imageNamed:@"rejected"] forState:UIControlStateNormal];
//                                [_btnOnlineOffline setBackgroundColor:[UIColor systemRedColor]];
                                [_btnOnlineOffline setTitle:@"Offline" forState:UIControlStateNormal];

                            }
                            //engineerStaffId
                        }

                }
                else
                {
                    DLog(@"JSONObjectWithData error: %@", error);
                }
            }
        }
    }
    else{
        isLoadMore =NO;
        if (lblNoJobs==nil)
        {
        lblNoJobs=[[UILabel alloc]init];
        
        lblNoJobs.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:20.0];
        [lblNoJobs setFrame:CGRectMake(0, 0, 300, 30)];
        lblNoJobs.tag=404;
        lblNoJobs.textAlignment=NSTextAlignmentCenter;
        
        lblNoJobs.center=CGPointMake(CGRectGetWidth(Vwtbl.frame)/2.0f, CGRectGetHeight(Vwtbl.frame)/2.0f);
        [Vwtbl addSubview:lblNoJobs];
    }
    
    
        NSMutableDictionary* temp;
        if (_responseData !=nil)
        {
        NSError *error;
        [MBProgressHUD hideAllHUDsForView:Vwtbl animated:YES];
        
        temp = [NSJSONSerialization JSONObjectWithData:_responseData  options:NSJSONReadingMutableContainers error:&error];
        if (!error)
        {
            if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
            {
                id jobs=[temp objectForKey:@"JobListResponse"];
                
                if ([jobs isKindOfClass:[NSArray class]]&&(![connIdentifier isEqualToString:@"connAccept"]||![connIdentifier isEqualToString:@"connReject"]))
                {
                    
                    DLog(@"arrMJobDetails :%ld",(unsigned long)[arrMJobDetails count]);
                    
                    if (page!=0)
                    {
                        
                        [arrMJobDetails addObjectsFromArray:jobs];
                    }
                    else
                    {
                        arrMJobDetails=jobs;
                    }
                    
                    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
                    {
                        self.activity.hidden=YES;
                        self.lblRefresh.hidden=YES;
                        [self.activity stopAnimating];
                        self.btnRefresh.hidden=NO;
                        
                        [arrEditedJobDic removeAllObjects];
                        [[NSUserDefaults standardUserDefaults]setObject:arrEditedJobDic forKey:@"arrEditedJobDic"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        
                        if (isbtnAssignedClicked==NO)
                        {
                            if (isbtnInvitationClicked==YES)
                            {
                                arrMFilterJobsList=arrMJobDetails;
                                [arrMInvitations removeAllObjects];
                                [arrMInvitations addObjectsFromArray:arrMJobDetails];
                            }
                            
                            refreshedList=YES;
                            arrCFilterJoblist=arrMFilterJobsList;
                            
                            if(_btnNewInvitation.selected==YES){
                                [self btnNewInvitationTapped:_btnNewInvitation];
                            }
                            else{
                                [self btnAcceptedInvitationTapped:_btnAcceptedInvitation];
                            }
                        }
                        else
                        {
                            arrMFilterJobsList=arrMJobDetails;
                            [arrMAssignedJobs removeAllObjects];
                            [arrMAssignedJobs addObjectsFromArray:arrMJobDetails];
                            
                            if (_btnAll.selected==YES)
                            {
                                [self allPress:_btnAll];
                            }
                            else if (_btnAssigned.selected==YES)
                            {
                                [self bookedPress:_btnAssigned];
                            }
                            else if (_btnActiveAssigns.selected==YES)
                            {
                                
                                [self activePress:_btnActiveAssigns];
                            }
                            else if (_btnCompleteAssign.selected==YES)
                            {
                                [self completePress:_btnCompleteAssign];
                            }
                            else
                            {
                                [self bookedPress:_btnAssigned];
                            }
                            
                            
                        }
                    }
                    else
                    {
                        if (_btnBooked.selected==YES)
                        {
                            [self bookedPress:_btnBooked];
                        }
                        else if (_btnActive.selected==YES)
                        {
                            
                            [self activePress:_btnActive];
                        }
                        else if (_btnComplete.selected==YES)
                        {
                            [self completePress:_btnComplete];
                        }
                        else
                        {
                            [self bookedPress:_btnBooked];
                        }
                        
                        
                        self.activity.hidden=YES;
                        self.lblRefresh.hidden=YES;
                        [self.activity stopAnimating];
                        self.btnRefresh.hidden=NO;
                        
                        [arrEditedJobDic removeAllObjects];
                        [[NSUserDefaults standardUserDefaults]setObject:arrEditedJobDic forKey:@"arrEditedJobDic"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }
                    
                    
                    
                    if ([[temp valueForKey:@"ResponseCode"]integerValue]==0)
                    {
                        
                        isNxtJobAvailable=YES;
                        
                    }
                    else
                    {
                        isNxtJobAvailable=NO;
                        
                    }
                    
                    [refreshControl endRefreshing];
                    
                }
                
                
            }
            
            
            else if ([[temp valueForKey:@"ResponseMessages"]rangeOfString:@"User is Expired"].location != NSNotFound)
            {
               
                UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"SessionExpired"
                                                                                    message: @"Please Login to Continue"
                                                                             preferredStyle: UIAlertControllerStyleAlert];
                
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                                      style: UIAlertActionStyleDestructive
                                                                    handler: ^(UIAlertAction *action) {
                    DLog(@"Dismiss button tapped!");
                    [self.navigationController popToRootViewControllerAnimated:NO];
                }];
                
                [controller addAction: alertAction];
                
                [self presentViewController: controller animated: YES completion: nil];
                
            }
            
            
            else
            {
                if (page == 0)
                {
                    
                    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
                    {
                        self.activity.hidden=YES;
                        self.lblRefresh.hidden=YES;
                        [self.activity stopAnimating];
                        self.btnRefresh.hidden=NO;
                        
                        
                        arrMFilterJobsList=nil;
                        arrCFilterJoblist=nil;
                        
                        [refreshControl endRefreshing];
                    }
                    
                    
                    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
                    {
                        self.activity.hidden=YES;
                        self.lblRefresh.hidden=YES;
                        self.btnRefresh.hidden=NO;
                        [self.activity stopAnimating];
                        
                        if (isbtnAssignedClicked==YES)
                        {
                            arrMFilterJobsList=nil;
                            
                            [refreshControl endRefreshing];
                            
                            
                            [arrMAssignedJobs removeAllObjects];
                            lblNoJobs.text=[NSString stringWithFormat:@"No New Job Assigned"];
                            lblNoJobs.hidden=NO;
                            [tabvToDoList reloadData];
                            
                            
                        }
                        else
                        {
                            arrMFilterJobsList=nil;
                            
                            [refreshControl endRefreshing];
                            
                            lblNoJobs.text=[NSString stringWithFormat:@"No Job Invitation There"];
                            lblNoJobs.hidden=NO;
                            [tabvToDoList reloadData];
                            
                            
                            [arrMInvitations removeAllObjects];
                            [_btnNewInvitation setTitle:[NSString stringWithFormat:@"New Invitations"] forState:UIControlStateNormal];
                            [_btnAcceptedInvitation setTitle:[NSString stringWithFormat:@"Accepted Invitations"] forState:UIControlStateNormal];
                            
                            
                        }
                        
                    }
                    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
                    {
                        
                        
                        self.activity.hidden=YES;
                        self.lblRefresh.hidden=YES;
                        [self.activity stopAnimating];
                        self.btnRefresh.hidden=NO;
                        
                        arrMFilterJobsList=nil;
                        arrCFilterJoblist=nil;
                        [self showAlert:@"No jobs there." withTitle:@""];
                        
                        [refreshControl endRefreshing];
                    }
                    
                    
                    
                }
                [MBProgressHUD hideAllHUDsForView:Vwtbl animated:YES];
                self.activity.hidden=YES;
                self.lblRefresh.hidden=YES;
                self.btnRefresh.hidden=NO;
                [self.activity stopAnimating];
                
                [refreshControl endRefreshing];
                [tabvToDoList reloadData];
            }
            
        }
        
    }
        else
        {
        
        }
    }
    
    //[cal removeFromSuperview];
    // cal=nil;
    // [self UpdateCalenderViewWithJobs:arrMJobDetails];
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    // [[[UIAlertView alloc]initWithTitle:@"Error" message:@"No network connection. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
    [self showAlert:@"No network connection. Please try again later."  withTitle:@"Error"];
    
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

#pragma mark - Job Create Button
- (IBAction)AddJob:(UIButton *)sender
{
    
    if (sender.tag==999) {
        
        [self LoadMore];
        
    }
    else{
        [self viewPopUPForm];
    }
    
}

#pragma mark - Pop Up design for New/Recraete Job
-(void)viewPopUPForm
{
    
    
    mainBg = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    mainBg.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    //[UIColor colorWithRed:142/255.0 green:142/255.0 blue:143/255.0 alpha:0.8];
    
    
    
    bgVw = [[UIView alloc] initWithFrame:CGRectMake(0,0,280,250)];
    bgVw.center=CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, CGRectGetHeight(self.view.frame)/2.0f);
    
    [bgVw.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [bgVw.layer setBorderWidth: 0.5];
    [bgVw.layer setCornerRadius:4.0f];
    [bgVw.layer setMasksToBounds:YES];
    
    bgVw.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    
    
    //--------------  New ---------------
    UIButton *btnNewJob = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNewJob.frame = CGRectMake(30,60,220,50);
    [btnNewJob setTitle:@"New Job" forState:UIControlStateNormal];
    [btnNewJob setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnNewJob.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:16.5];
    [btnNewJob setBackgroundColor:[UIColor colorWithRed:91/255.0 green:181/255.0 blue:51/255.0 alpha:1.0]];
    [btnNewJob addTarget:self action:@selector(newJobBookingPress:) forControlEvents:UIControlEventTouchUpInside];
    btnNewJob.tag=1923;
    [btnNewJob.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [btnNewJob.layer setBorderWidth: 0.0];
    [btnNewJob.layer setCornerRadius:0.5f];
    
    btnNewJob.layer.shadowRadius = 0.5f;
    btnNewJob.layer.shadowColor = [UIColor blackColor].CGColor;
    btnNewJob.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    btnNewJob.layer.shadowOpacity = 0.5f;
    [btnNewJob.layer setMasksToBounds:NO];
    
    
    
    
    //-------------- Recreate ------------
    UIButton *btnRecreateJob = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRecreateJob.frame = CGRectMake(30,150,220,50);
    [btnRecreateJob setTitle:@"Re-create Job" forState:UIControlStateNormal];
    [btnRecreateJob setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnRecreateJob.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:16.5];
    [btnRecreateJob setBackgroundColor:[UIColor colorWithRed:91/255.0 green:181/255.0 blue:51/255.0 alpha:1.0]];
    [btnRecreateJob addTarget:self action:@selector(recreateJobBookingPress:) forControlEvents:UIControlEventTouchUpInside];
    btnRecreateJob.tag=1922;
    
    [btnRecreateJob.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [btnRecreateJob.layer setBorderWidth: 0.0];
    [btnRecreateJob.layer setCornerRadius:0.5f];
    
    btnRecreateJob.layer.shadowRadius = 0.5f;
    btnRecreateJob.layer.shadowColor = [UIColor blackColor].CGColor;
    btnRecreateJob.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    btnRecreateJob.layer.shadowOpacity = 0.5f;
    
    [btnRecreateJob.layer setMasksToBounds:NO];
    
    
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        
        btnRecreateJob.frame = CGRectMake(30,100,220,50);
    }else{
        [bgVw addSubview:btnNewJob];
    }
    
    
    
    [bgVw addSubview:btnRecreateJob];
    
    btnCross=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCross.frame=CGRectMake(0, 0, 25, 25);
    btnCross.center=CGPointMake(CGRectGetMaxX(bgVw.frame),CGRectGetMinY(bgVw.frame));
    [btnCross setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
    [btnCross addTarget:self action:@selector(cross:) forControlEvents:UIControlEventTouchUpInside];
    [btnCross clipsToBounds];
    
    mainBg.alpha=0.0;
    
    [mainBg addSubview:bgVw];
    [mainBg addSubview:btnCross];
    // [self.view addSubview:mainBg];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        
        mainBg.alpha=1.0f;
        
        [self.view addSubview:mainBg];
        
    }];
    
    
    
}
-(void)newJobBookingPress:(id)sender
{
    DLog(@"New Job add");
    [mainBg removeFromSuperview];
    
    [self showPopUpAgreementPage:@"1"];
    
}
-(void)recreateJobBookingPress:(id)sender
{
    DLog(@"New Recreate Class");
    [mainBg removeFromSuperview];
    
    [self showPopUpAgreementPage:@"2"];
    
    
}
-(void)cross:(UIButton *)sender
{
    [mainBg removeFromSuperview];
    
}

#pragma mark - Agreement 1 Page job create
-(void)showPopUpAgreementPage :(NSString *)strNewOrRecReate
{
    mainBg1 = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    mainBg1.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    
    bgVw1 = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame)-10,self.view.frame.size.height-60)];
    bgVw1.center=CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, CGRectGetHeight(self.view.frame)/2.0f);
    
    [bgVw1.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [bgVw1.layer setBorderWidth: 0.5];
    [bgVw1.layer setCornerRadius:4.0f];
    [bgVw1.layer setMasksToBounds:YES];
    bgVw1.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
    {
        
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
    }
    else
    {
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10,10,270,30)];
        lblTitle.text = @"Are you sure about the Customer awareness?";
        lblTitle.font = [UIFont fontWithName:@"TheSansArabic-Bold" size:13.4];
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
    }
    
    [mainBg1 addSubview:bgVw1];
    //[self.view addSubview:mainBg1];
    
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
}

#pragma mark - Agreement 2 Page job create
-(void)showPopUpAgreement2Page :(NSString *)strNewOrRecReate
{
    mainBg2 = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    mainBg2.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    
    bgVw2 = [[UIView alloc] initWithFrame:CGRectMake(5,44,CGRectGetWidth(self.view.frame)-10,self.view.frame.size.height-60)];
    bgVw2.center=CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, CGRectGetHeight(self.view.frame)/2.0f);
    
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
    
    UIButton *btn=(UIButton *)sender;
    DLog(@"tag :%ld",(long)btn.tag);
    [mainBg2 removeFromSuperview];
    
    if (btn.tag==1)
    {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
        {
            CreateJob *createJob =[[CreateJob alloc]initWithNibName:@"CreateJob" bundle:nil];
            [self.navigationController pushViewController:createJob animated:YES];
            
        }
        else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
        {
            
            CreateJobEng *createJob;
            
            createJob=  [[CreateJobEng alloc]initWithNibName:@"CreateJobEng" bundle:nil];
            
            [self.navigationController pushViewController:createJob animated:YES];
            
            
        }
        else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
        {
            
            
            CreateJobEng *createJob =  [[CreateJobEng alloc]initWithNibName:@"EngineerJobCreate" bundle:nil];
            
            [self.navigationController pushViewController:createJob animated:YES];
        }
        
    }
    else if (btn.tag==2)
    {
        ReCreateJob *createJob=  [[ReCreateJob alloc]initWithNibName:@"ReCreateJob" bundle:nil];
        
        [self.navigationController pushViewController:createJob animated:YES];
    }
}






-(void)pressDeclineNo2:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    DLog(@"tag :%ld",(long)btn.tag);
    [self.dataTaskAgr cancel];
    [mainBg2 removeFromSuperview];
}

#pragma mark Detail Button Press Method
-(void)pressDetails:(id)sender
{
    
    UIButton *btn=(UIButton *)sender;
    DLog(@"Selected IndexPath :%ld",(long)btn.tag);
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
    {
        
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        
        
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        
    }
    
}

#pragma mark Map Button Press Method
-(void)pressMapLocation:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    DLog(@"Selected IndexPath :%ld",(long)btn.tag);
    
    
    NSMutableArray *tblarr;
    if (tabvToDoList.tag==111)
    {
        tblarr=JobsOnDate;
    }
    else
    {
        tblarr=arrMFilterJobsList;
        
    }
    NSMutableDictionary *dicTemp=[tblarr objectAtIndex:(long)btn.tag];
    NSArray *arr=[dicTemp objectForKey:@"JobAddrListResponse"];
    
    bool isJobAddress = NO;
    
    for (NSDictionary *dic in arr) {
        if ([[dic valueForKey:@"TypeOfAddress"]integerValue]==1) {
            isJobAddress=YES;
        }
        
    }
    
    if (isJobAddress) {
        
        
        
        DLog(@"dicTemp :%@",dicTemp);
        
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        // If the status is denied or only granted for when in use, display an alert
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
            NSString *title;
            title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
            NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
            
            
            
            UIAlertController *controller = [UIAlertController alertControllerWithTitle: title
                                                                                message:message
                                                                         preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle: @"Cancel"
                                                                        style: UIAlertActionStyleDestructive
                                                                      handler: ^(UIAlertAction *action) {
                
            }];
            
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Settings"
                                                                  style: UIAlertActionStyleDestructive
                                                                handler: ^(UIAlertAction *action) {
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:settingsURL];
            }];
            
            
            
            [controller addAction: alertActionCancel];
            [controller addAction: alertAction];
            
            [self presentViewController: controller animated: YES completion: nil];
            
        }
        // The user has not enabled any location services. Request background authorization.
        
        
        
        else if (status == kCLAuthorizationStatusNotDetermined) {
            [app.locationManager requestAlwaysAuthorization];
        }
        
        else
        {
            Map_show *mapShow=[[Map_show alloc]initWithNibName:@"Map_show" bundle:nil];

            mapShow.strHeading=@"Map Navigation";
            mapShow.dicJobTemp=dicTemp;
            [self presentViewController:mapShow animated:YES completion:nil];
        }
    }else{
        [self showAlert:@"Job address not available." withTitle:@"info"];
    }
}

#pragma mark - didReceiveMemoryWarning Method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark TableView Delegate && Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        return 155.0;
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
    {
        return 180.0;
    }
    else
    {
        
        if (tableView.tag==111)
        {
            return 153.0;
        }
        else
        {
            if (indexPath.row==[arrMFilterJobsList count])
            {
                return 160.0;
            }
            else
            {
                return 155.0;
            }
        }
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (tableView.tag==111)
    {
        return [JobsOnDate count];
    }
    else
    {
        if ([arrMFilterJobsList count]>0)
        {
            return [arrMFilterJobsList count]+1;
        }
        else
        {
            return 0;
        }
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tblarr;
    static NSString *cellidentifier=@"cellidentifier";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellidentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.backgroundColor=[UIColor clearColor];
    
    NSString *dateTimeForStatus = @"";
    
    if (tableView.tag==111)
    {
        tblarr=JobsOnDate;
    }
    else
    {
        tblarr=arrMFilterJobsList;
        
        if (indexPath.row==[tblarr count])
        {
            cell.indentationLevel=3;
            cell.tag=3333;
            
            //-----------  Previous Button ------------------------------------------------------
            UIButton *btnPrev = [UIButton buttonWithType:UIButtonTypeCustom];
            btnPrev.frame = CGRectMake(6,10,100,30);
            [btnPrev setBackgroundColor:[UIColor clearColor]];
            [btnPrev setTitle:@"previos page" forState:UIControlStateNormal];
            btnPrev.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:11.0];
            [btnPrev.layer setBorderColor: [[UIColor clearColor] CGColor]];
            [btnPrev.layer setBorderWidth: 0.0];
            [btnPrev.layer setCornerRadius:5.0f];
            [btnPrev.layer setMasksToBounds:YES];
            
            if (page==0)
            {
                btnPrev.backgroundColor=[UIColor grayColor];
                btnPrev.hidden=YES;
                btnPrev.userInteractionEnabled=NO;
                isPrevJobAvailable=NO;
            }
            else
            {
                btnPrev.backgroundColor=[UIColor colorWithRed:96/255.0 green:145/255.0 blue:45/255.0 alpha:1.0];
                btnPrev.userInteractionEnabled=YES;
                btnPrev.hidden=NO;
                isPrevJobAvailable=YES;
            }
            [btnPrev addTarget:self action:@selector(btnPrevJobPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            //-----------  Next Button ------------------------------------------------------
            UIButton *btnNxt = [UIButton buttonWithType:UIButtonTypeCustom];
            btnNxt.frame = CGRectMake(CGRectGetWidth(self.tabvToDoList.frame)-100,10,100,30);
            btnNxt.center=CGPointMake(CGRectGetWidth(self.tabvToDoList.frame)/2.0f,40 );
            [btnNxt setBackgroundColor:[UIColor clearColor]];
            btnNxt.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:11.0];
            [btnNxt.layer setBorderColor: [[UIColor clearColor] CGColor]];
            [btnNxt.layer setBorderWidth: 0.0];
            [btnNxt.layer setCornerRadius:5.0f];
            [btnNxt.layer setMasksToBounds:YES];
            
            if (isNxtJobAvailable==YES)
            {
                btnNxt.backgroundColor=[UIColor colorWithRed:96/255.0 green:145/255.0 blue:45/255.0 alpha:1.0];
                btnNxt.userInteractionEnabled=YES;
                btnNxt.hidden=YES;
            }
            else
            {
                btnNxt.backgroundColor=[UIColor grayColor];
                btnNxt.userInteractionEnabled=NO;
                btnNxt.hidden=YES;
            }
            [btnNxt addTarget:self action:@selector(btnNxtJobPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btnNxt setTitle:@"Load More" forState:UIControlStateNormal];
            
            CGRect f = CGRectMake(0,0,80,30);
            pageControl = [[UIPageControl alloc] initWithFrame:f];
            pageControl.center=CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, 70);
            pageControl.numberOfPages = page+1;
            pageControl.currentPage = page+1;
            pageControl.pageIndicatorTintColor = [UIColor blueColor];
            pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
            
            if (isLoadMore==YES)
            {
                [btnNxt setTitle:@"Loading ..." forState:UIControlStateNormal];
                [btnNxt setTintColor:[UIColor grayColor]];
                btnNxt.userInteractionEnabled=NO;
            }
            else
            {
                [btnNxt setTitle:@"Load More" forState:UIControlStateNormal];
                [btnNxt setTintColor:[UIColor whiteColor]];
                btnNxt.userInteractionEnabled=YES;
            }
            [cell addSubview:btnNxt];
            return cell;
        }
    }
    
    UIImageView *imgvCellbg;
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        imgvCellbg=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(tabvToDoList.frame),155.0)];
        [imgvCellbg setImage:[UIImage imageNamed:@"jobBox_clearbg"]];
        [cell.contentView addSubview:imgvCellbg];
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
    {
        imgvCellbg=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(tabvToDoList.frame),180)];
        [imgvCellbg setImage:[UIImage imageNamed:@"jobBox_clearbg"]];
        [cell.contentView addSubview:imgvCellbg];
    }
    else
    {
        
        imgvCellbg=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(tabvToDoList.frame),155)];
        [imgvCellbg setImage:[UIImage imageNamed:@"jobBox_clearbg"]];
        [cell.contentView addSubview:imgvCellbg];
    }
    
    NSDictionary *dicTemp=[tblarr objectAtIndex:indexPath.row];
    NSArray *arr=[dicTemp objectForKey:@"JobAddrListResponse"];
    NSDictionary *PresentingJob,*PresentingUser;
    for (NSDictionary *dic in arr)
    {
        if ([[dic valueForKey:@"TypeOfAddress"]integerValue]==1)
        {
            PresentingJob=dic;
        }
    }
    NSArray *arr2=[dicTemp objectForKey:@"JobPeopleListResponse"];
    for (NSDictionary *dic in arr2)
    {
        
        if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==1) {
            PresentingUser=dic;
            
        }else if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==3 || [[dic valueForKey:@"TypeofCustomer"]integerValue]==4){
            
            if (!PresentingUser) {
                PresentingUser=dic;
            }
            
            
        }
    }
    
    NSLog(@"dicTemp :%@",dicTemp);
    
    UIButton *btnDetails = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDetails.frame = CGRectMake(CGRectGetMaxX(imgvCellbg.frame)-26,CGRectGetMaxY(imgvCellbg.frame)-34,24,24);
    btnDetails.tag=indexPath.row;
    btnDetails.userInteractionEnabled=NO;
    [btnDetails setBackgroundColor:[UIColor clearColor]];
    [btnDetails addTarget:self action:@selector(pressDetails:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *jobstatus=[NSString stringWithFormat:@"%@",[dicTemp objectForKey:@"JobStatus"]];
    NSString *IsEngAccept=[NSString stringWithFormat:@"%@",[dicTemp objectForKey:@"IsEngAccept"]];
    NSString *IsEngAssign=[NSString stringWithFormat:@"%@",[dicTemp objectForKey:@"IsEngAssign"]];
    NSString *IsJobExpired=[NSString stringWithFormat:@"%@",[dicTemp objectForKey:@"IsJobExpired"]];
    DLog(@"IsJobExpired :%@",IsJobExpired);
    
    //------------------------------------------------ Map Button -------------------------------------------------
    UIButton *btnMapLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMapLocation.frame = CGRectMake(5,0,115,115);
    btnMapLocation.center=CGPointMake(btnMapLocation.center.x,CGRectGetHeight(imgvCellbg.frame)/2.0f+10);
    btnMapLocation.tag=indexPath.row;
    [btnMapLocation setBackgroundImage:[UIImage imageNamed:@"No_ImageEngg"] forState:UIControlStateNormal];
    [btnMapLocation addTarget:self action:@selector(pressMapLocation:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btnMapLocation];
    
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
    {
        
        btnMapLocation.userInteractionEnabled=NO;
        [btnMapLocation.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [btnMapLocation.layer setBorderWidth: 1.1];
        [btnMapLocation.layer setCornerRadius:1.0f];
        [btnMapLocation.layer setMasksToBounds:YES];
        
        UIButton *btnFMDetailsPage = [UIButton buttonWithType:UIButtonTypeCustom];
        btnFMDetailsPage.frame = CGRectMake(130,CGRectGetMaxY(btnMapLocation.frame)-15,70,20);
        [btnFMDetailsPage setTitle:[NSString stringWithFormat:@"%@",[dicTemp objectForKey:@"job_statusname"]] forState:UIControlStateNormal];
        [btnFMDetailsPage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnFMDetailsPage.titleLabel.font=[UIFont boldSystemFontOfSize:11.0];
        btnFMDetailsPage.tag=99;
        [btnFMDetailsPage.layer setBorderColor: [[UIColor clearColor] CGColor]];
        [btnFMDetailsPage.layer setBorderWidth: 0.0];
        [btnFMDetailsPage.layer setCornerRadius:3.0f];
        [btnFMDetailsPage.layer setMasksToBounds:YES];
        
        //----------------------------------- Engineer name && Image --------------------------------------------------
        UILabel *lblEngineerName=[[UILabel alloc] initWithFrame:CGRectMake(202,101,130,18)];
        lblEngineerName.textAlignment=NSTextAlignmentLeft;
        lblEngineerName.textColor=[UIColor darkGrayColor];
        lblEngineerName.textAlignment=NSTextAlignmentCenter;
        lblEngineerName.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
        lblEngineerName.backgroundColor=[UIColor clearColor];
        
        if (![[dicTemp valueForKey:@"EngineerName"] isKindOfClass:[NSNull class]])
        {
            if ([[dicTemp valueForKey:@"EngineerName"] isEqualToString:@""])
            {
                lblEngineerName.text=@"NOT ASSIGNED";
                [lblEngineerName sizeToFit];
                lblEngineerName.center=CGPointMake(lblEngineerName.center.x, btnFMDetailsPage.center.y);
                
                
                DLog(@"Engineer Image Url :%@",[dicTemp valueForKey:@"ImagePath"]);
                NSURL *url = [NSURL URLWithString:[dicTemp valueForKey:@"ImagePath"]];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *img = [UIImage imageWithData:data];
                [btnMapLocation setBackgroundImage:img forState:UIControlStateNormal];
                
                [btnMapLocation setBackgroundImage:[UIImage imageNamed:@"notassign"] forState:UIControlStateNormal];
            }
            else
            {
                lblEngineerName.text=[dicTemp valueForKey:@"EngineerName"];
                [lblEngineerName sizeToFit];
                lblEngineerName.center=CGPointMake(lblEngineerName.center.x, btnFMDetailsPage.center.y);
                
                DLog(@"Engineer Image Url :%@",[dicTemp valueForKey:@"ImagePath"]);
                NSURL *url = [NSURL URLWithString:[[dicTemp valueForKey:@"ImagePath"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                if (![dicTemp  valueForKey:@"EngineerImage"])
                {
                    
                    [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
                        if (succeeded) {
                            [btnMapLocation setBackgroundImage:image forState:UIControlStateNormal];
                            // cache the image for use later (when scrolling up)
//                            [dicTemp setValue:image forKey:@"EngineerImage"];
                        }
                    }];
                }
                else
                {
//                    [btnMapLocation setBackgroundImage:[dicTemp  valueForKey:@"EngineerImage"] forState:UIControlStateNormal];
                }
                //[btnMapLocation setBackgroundImage:[UIImage imageNamed:@"afterassign"] forState:UIControlStateNormal];
            }
        }
        else
        {
            lblEngineerName.text=@"NOT ASSIGNED";
            
            DLog(@"Engineer Image Url :%@",[dicTemp valueForKey:@"ImagePath"]);
            NSURL *url = [NSURL URLWithString:[dicTemp valueForKey:@"ImagePath"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [UIImage imageWithData:data];
            [btnMapLocation setBackgroundImage:img forState:UIControlStateNormal];
            
            [btnMapLocation setBackgroundImage:[UIImage imageNamed:@"notassign"] forState:UIControlStateNormal];
            
            btnMapLocation.userInteractionEnabled=NO;
        }
        [cell.contentView addSubview:lblEngineerName];
        //--------------------------------------------------------------------------------------------------------------
        
        if ([jobstatus integerValue]==Book)
        {
            [btnFMDetailsPage setBackgroundColor:[UIColor colorWithRed:228/255.0 green:138/255.0 blue:24/255.0 alpha:1.0]];
            [btnFMDetailsPage setTitle:@"Booked" forState:UIControlStateNormal];
            
            if ([IsEngAccept isEqualToString:@"0"]&&[IsEngAssign isEqualToString:@"0"])
            {
                //Booked
                [btnDetails setBackgroundImage:[UIImage imageNamed:@"blackman"] forState:UIControlStateNormal];
                
            }
            else if ([IsEngAccept isEqualToString:@"1"]&&[IsEngAssign isEqualToString:@"0"])
            {
                
                //Invited
                [btnDetails setBackgroundImage:[UIImage imageNamed:@"orangeman"] forState:UIControlStateNormal];
                
            }
            else if ([IsEngAccept isEqualToString:@"2"]&&[IsEngAssign isEqualToString:@"0"])
            {
                //Invitation Accepted/decline
                
                [btnDetails setBackgroundImage:[UIImage imageNamed:@"orangeman"] forState:UIControlStateNormal];
                [UIView animateWithDuration:0.7 delay:0 options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction) animations:^{
                    
                    btnDetails.alpha=0.0;
                    
                }completion:^(BOOL finished){
                    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        
                        btnDetails.alpha=1.0;
                        
                    }completion:^(BOOL finished){
                        
                        
                    }];
                    
                }];
                
                
                
            }
            else if ([IsEngAccept isEqualToString:@"3"]&&[IsEngAssign isEqualToString:@"0"])
            {
                //Invitation Expire
                
                [btnDetails setBackgroundImage:[UIImage imageNamed:@"redman"] forState:UIControlStateNormal];
                [UIView animateWithDuration:0.7 delay:0 options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction) animations:^{
                    
                    btnDetails.alpha=0.0;
                    
                }completion:^(BOOL finished){
                    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        
                        btnDetails.alpha=1.0;
                        
                    }completion:^(BOOL finished){
                        
                        
                    }];
                    
                }];
                
                
                
            }
            else if ([IsEngAssign isEqualToString:@"1"])
            {
                //Assigned
                [btnDetails setBackgroundImage:[UIImage imageNamed:@"greenman"] forState:UIControlStateNormal];
                
            }
            
        }
        else if([jobstatus integerValue]==Active)
        {
            //Active
            [btnDetails setBackgroundImage:[UIImage imageNamed:@"greenman"] forState:UIControlStateNormal];
            [btnFMDetailsPage setBackgroundColor:[UIColor colorWithRed:96/255.0 green:145/255.0 blue:45/255.0 alpha:1.0]];
            [btnFMDetailsPage setTitle:@"Active" forState:UIControlStateNormal];
            
            if ([[dicTemp valueForKey:@"IsAgreementSign"]boolValue]==YES)
            {
                UILabel *lblSubStatus=[[UILabel alloc]init];
                lblSubStatus.text=@"agreement Signed/Job in progress";
                lblSubStatus.backgroundColor=[UIColor clearColor];
                lblSubStatus.textAlignment=NSTextAlignmentLeft;
                lblSubStatus.textColor=[UIColor darkGrayColor];
                lblSubStatus.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:11];
                lblSubStatus.frame=CGRectMake(CGRectGetMinX(btnMapLocation.frame), CGRectGetMaxY(btnMapLocation.frame)+3, 200, 20);
                [cell.contentView addSubview:lblSubStatus];
                
            }
        }
        else if([jobstatus integerValue]==JobCancelled)
        {
            //Completed
            [btnFMDetailsPage setBackgroundColor:[UIColor redColor]];
            [btnFMDetailsPage setTitle:@"Cancelled" forState:UIControlStateNormal];
        }
        else if([jobstatus integerValue]==Complete)
        {
            //Completed
            [btnFMDetailsPage setBackgroundColor:[UIColor colorWithRed:96/255.0 green:145/255.0 blue:45/255.0 alpha:1.0]];
            [btnFMDetailsPage setTitle:@"Completed" forState:UIControlStateNormal];
        }
        [cell.contentView addSubview:btnFMDetailsPage];
        
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
      
        btnMapLocation.frame = CGRectMake(0,0,110,120);
        btnMapLocation.center=CGPointMake(CGRectGetMinX(imgvCellbg.frame)+CGRectGetWidth(btnMapLocation.frame)/2.0f+5,CGRectGetHeight(btnMapLocation.frame)/2.0f+10);
        
        UIButton *btnFMDetailsPage = [UIButton buttonWithType:UIButtonTypeCustom];
        // btnFMDetailsPage.frame = CGRectMake(CGRectGetMaxX(btnMapLocation.frame)+10,CGRectGetMaxY(btnMapLocation.frame)-15,70,20);
        btnFMDetailsPage.frame = CGRectMake(CGRectGetMaxX(btnMapLocation.frame)+10,CGRectGetMaxY(btnMapLocation.frame)-1,70,20);
        [btnFMDetailsPage setTitle:[NSString stringWithFormat:@"%@",[dicTemp objectForKey:@"job_statusname"]] forState:UIControlStateNormal];
        [btnFMDetailsPage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnFMDetailsPage.titleLabel.font=[UIFont boldSystemFontOfSize:11.0];
        btnFMDetailsPage.tag=99;
        [btnFMDetailsPage.layer setBorderColor: [[UIColor clearColor] CGColor]];
        [btnFMDetailsPage.layer setBorderWidth: 0.0];
        [btnFMDetailsPage.layer setCornerRadius:3.0f];
        [btnFMDetailsPage.layer setMasksToBounds:YES];
        
        NSString *jobstatus=[NSString stringWithFormat:@"%@",[dicTemp objectForKey:@"JobStatus"]];
        NSString *IsAccepted=[NSString stringWithFormat:@"%@",[dicTemp objectForKey:@"IsAccepted"]];
        //NSString *IsActive=[NSString stringWithFormat:@"%@",[dicTemp objectForKey:@"IsActive"]];
        
        if ([jobstatus integerValue]==Book)
        {
            //Booked
            [btnFMDetailsPage setBackgroundColor:[UIColor colorWithRed:228/255.0 green:138/255.0 blue:24/255.0 alpha:1.0]];
            [btnFMDetailsPage setTitle:@"Booked" forState:UIControlStateNormal];
            [cell.contentView addSubview:btnFMDetailsPage];
            
            if ([IsAccepted isEqualToString:@"0"]&&[[dicTemp objectForKey:@"IsEngAssign"]integerValue]==0)
            {
                
                //----------------- Agree ------------
                UIButton *btnagree=[UIButton buttonWithType:UIButtonTypeCustom];
                btnagree.frame=CGRectMake(CGRectGetMaxX(imgvCellbg.frame)-100,CGRectGetMaxY(btnMapLocation.frame)-35,40,40);
                btnagree.tag=[[dicTemp objectForKey:@"JobID"] integerValue];
                [btnagree setBackgroundImage:[UIImage imageNamed:@"e-Sigagree"] forState:UIControlStateNormal];
                [btnagree setBackgroundColor:[UIColor clearColor]];
                [btnagree addTarget:self action:@selector(agree:) forControlEvents:UIControlEventTouchUpInside];
                btnagree.titleLabel.textColor=[UIColor colorWithRed:26/255.0 green:137/255.0 blue:44/255.0 alpha:1.0];
                btnagree.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:16.0];
                [cell.contentView addSubview:btnagree];
                
                //----------------- Refuse ------------
                UIButton *btnRefuse=[UIButton buttonWithType:UIButtonTypeCustom];
                btnRefuse.frame=CGRectMake(CGRectGetMaxX(imgvCellbg.frame)-50,CGRectGetMinY(btnagree.frame),40,40);
                btnRefuse.tag=[[dicTemp objectForKey:@"JobID"] integerValue];
                [btnRefuse setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
                [btnRefuse setBackgroundColor:[UIColor clearColor]];
                [btnRefuse addTarget:self action:@selector(refuse:) forControlEvents:UIControlEventTouchUpInside];
                btnRefuse.titleLabel.textColor=[UIColor colorWithRed:26/255.0 green:137/255.0 blue:44/255.0 alpha:1.0];
                btnRefuse.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:16.0];
                [cell.contentView addSubview:btnRefuse];
                
                if(![[dicTemp valueForKey:@"CreatedOn"] isKindOfClass:[NSNull class]] && [[dicTemp objectForKey:@"CreatedOn"] length] > 0){
                    dateTimeForStatus = [NSString stringWithFormat:@"%@", [dicTemp objectForKey:@"CreatedOn"]];
                }
                
            }
            else if ([IsAccepted isEqualToString:@"1"])
            {
                [btnFMDetailsPage setBackgroundColor:[UIColor colorWithRed:96/255.0 green:145/255.0 blue:45/255.0 alpha:1.0]];
                [btnFMDetailsPage setTitle:@"Accepted" forState:UIControlStateNormal];
                if(![[dicTemp valueForKey:@"AcceptedDate"] isKindOfClass:[NSNull class]] && [[dicTemp objectForKey:@"AcceptedDate"] length] > 0){
                    dateTimeForStatus = [NSString stringWithFormat:@"%@", [dicTemp objectForKey:@"AcceptedDate"]];
                }
            }
            
            if ([IsEngAssign isEqualToString:@"1"])
            {
                //Assigned
                [btnDetails setBackgroundImage:[UIImage imageNamed:@"greenman"] forState:UIControlStateNormal];
                [btnFMDetailsPage setBackgroundColor:[UIColor colorWithRed:96/255.0 green:145/255.0 blue:45/255.0 alpha:1.0]];
                [btnFMDetailsPage setTitle:@"Assigned" forState:UIControlStateNormal];
                if(![[dicTemp valueForKey:@"AssignedDate"] isKindOfClass:[NSNull class]] && [[dicTemp objectForKey:@"AssignedDate"] length] > 0){
                    dateTimeForStatus = [NSString stringWithFormat:@"%@", [dicTemp objectForKey:@"AssignedDate"]];
                }

            }
            
        }
        else if([jobstatus integerValue]==Active)
        {
            //Active
            [btnDetails setBackgroundImage:[UIImage imageNamed:@"greenman"] forState:UIControlStateNormal];
            [btnFMDetailsPage setBackgroundColor:[UIColor colorWithRed:96/255.0 green:145/255.0 blue:45/255.0 alpha:1.0]];
            [btnFMDetailsPage setTitle:@"Active" forState:UIControlStateNormal];
            [cell.contentView addSubview:btnFMDetailsPage];
            
            if ([[dicTemp valueForKey:@"IsAgreementSign"]boolValue]==YES)
            {
                UILabel *lblSubStatus=[[UILabel alloc]init];
                lblSubStatus.text=@"Jobs in progress";
                lblSubStatus.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:12];
                [lblSubStatus sizeToFit];
                lblSubStatus.center=CGPointMake(CGRectGetMaxX(btnFMDetailsPage.frame)+CGRectGetWidth(lblSubStatus.frame)/2.0f+4.0f, CGRectGetMidY(btnFMDetailsPage.frame));
                [cell.contentView addSubview:lblSubStatus];
                
                
                
            }
            
            
        }
        else // if([jobstatus isEqualToString:@"3"])
        {
            //Completed
            [btnFMDetailsPage setBackgroundColor:[UIColor colorWithRed:96/255.0 green:145/255.0 blue:45/255.0 alpha:1.0]];
            [btnFMDetailsPage setTitle:@"Completed" forState:UIControlStateNormal];
            [cell.contentView addSubview:btnFMDetailsPage];
            
            UILabel *lblSubStatusText;
            lblSubStatusText=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btnFMDetailsPage.frame),CGRectGetMaxY(btnFMDetailsPage.frame)-50,110,30)];
            lblSubStatusText.textAlignment=NSTextAlignmentLeft;
            lblSubStatusText.lineBreakMode = NSLineBreakByWordWrapping;
            lblSubStatusText.textColor=[UIColor darkGrayColor];
            lblSubStatusText.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:10.0];
            lblSubStatusText.backgroundColor=[UIColor clearColor];
            lblSubStatusText.numberOfLines=1;
            // [lblTimeAllowance sizeToFit]; //4566446445645646456
            
            if (![[dicTemp valueForKey:@"SubStatusText"]isKindOfClass:[NSNull class]])
            {
                lblSubStatusText.text=[GlobalDirector ReplaceStringNull:[dicTemp valueForKey:@"SubStatusText"]];
            }
            [cell.contentView addSubview:lblSubStatusText];
            
            
            
            for (NSDictionary *dic in arrJobStatus) {
                
                
                if ([[dic valueForKey:@"Value"]integerValue]==[jobstatus integerValue]) {
                    
                    if (![[dic valueForKey:@"DisplayText"] isEqualToString:@"Complete"]) {
                        
                        UILabel *lblSubStatus=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnFMDetailsPage.frame)+2,CGRectGetMinY(btnFMDetailsPage.frame),100,18)];
                        lblSubStatus.textAlignment=NSTextAlignmentLeft;
                        lblSubStatus.textColor=[UIColor colorWithRed:117/255.0f green:143/255.0f blue:39/255.0f alpha:1];
                        lblSubStatus.textAlignment=NSTextAlignmentCenter;
                        lblSubStatus.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
                        lblSubStatus.backgroundColor=[UIColor clearColor];
                        lblSubStatus.text=[NSString stringWithFormat:@"%@",[[dic valueForKey:@"DisplayText"] isEqualToString:@"Complete"]?@"":[dic valueForKey:@"DisplayText"]];
                        
                        lblSubStatus.numberOfLines=0;
                        [lblSubStatus sizeToFit];
                        [cell.contentView addSubview:lblSubStatus];
                        
                        
                    }
                    
                    
                    
                }
                
            }
            
            
            
        }
        
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        
        UIButton *btnFMDetailsPage = [UIButton buttonWithType:UIButtonTypeCustom];
        btnFMDetailsPage.frame = CGRectMake(CGRectGetMaxX(btnMapLocation.frame)+5,CGRectGetMaxY(btnMapLocation.frame)-15,70,20);
        [btnFMDetailsPage setTitle:[NSString stringWithFormat:@"%@",[dicTemp objectForKey:@"job_statusname"]] forState:UIControlStateNormal];
        [btnFMDetailsPage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnFMDetailsPage.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:11.0];;
        btnFMDetailsPage.tag=99;
        [btnFMDetailsPage.layer setBorderColor: [[UIColor clearColor] CGColor]];
        [btnFMDetailsPage.layer setBorderWidth: 0.0];
        [btnFMDetailsPage.layer setCornerRadius:3.0f];
        [btnFMDetailsPage.layer setMasksToBounds:YES];
        [btnFMDetailsPage setBackgroundColor:[UIColor colorWithRed:228/255.0 green:138/255.0 blue:24/255.0 alpha:1.0]];
        [btnFMDetailsPage setTitle:@"Booked" forState:UIControlStateNormal];
        NSString *jobstatus=[NSString stringWithFormat:@"%@",[dicTemp objectForKey:@"JobStatus"]];
        if ([jobstatus integerValue]==Book)
        {
//            if ([IsJobExpired isEqualToString:@"1"])
//            {
//
//                //Job Expired
//                imgvCellbg.image=nil;
//                imgvCellbg.backgroundColor=[UIColor orangeColor];
//                UIImageView *imgProxybg=[[UIImageView  alloc]initWithFrame:imgvCellbg.frame];
//                imgProxybg.backgroundColor=[UIColor whiteColor];
//                [cell.contentView addSubview:imgProxybg];
//                [cell.contentView   sendSubviewToBack:imgProxybg];
//                [UIView animateWithDuration:0.7 delay:0 options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction) animations:^{
//
//                    imgvCellbg.alpha=0.0;
//
//                }completion:^(BOOL finished){
//                    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//
//                        imgvCellbg.alpha=1.0;
//
//                    }completion:^(BOOL finished){
//
//
//                    }];
//
//                }];
//            }
            if ([IsEngAccept isEqualToString:@"0"]&&[IsEngAssign isEqualToString:@"0"])
            {
                //Booked
                [btnDetails setBackgroundImage:[UIImage imageNamed:@"blackman"] forState:UIControlStateNormal];
                
            }
            else if ([IsEngAccept isEqualToString:@"1"]&&[IsEngAssign isEqualToString:@"0"])
            {
                
                //Invited
                [btnDetails setBackgroundImage:[UIImage imageNamed:@"orangeman"] forState:UIControlStateNormal];
                
            }
            else if ([IsEngAccept isEqualToString:@"2"]&&[IsEngAssign isEqualToString:@"0"])
            {
                //Invitation Accepted/decline
                
                [btnDetails setBackgroundImage:[UIImage imageNamed:@"orangeman"] forState:UIControlStateNormal];
                [UIView animateWithDuration:0.7 delay:0 options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction) animations:^{
                    
                    btnDetails.alpha=0.0;
                    
                }completion:^(BOOL finished){
                    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        
                        btnDetails.alpha=1.0;
                        
                    }completion:^(BOOL finished){
                        
                        
                    }];
                    
                }];
                
            }
            else if ([IsEngAccept isEqualToString:@"3"]&&[IsEngAssign isEqualToString:@"0"])
            {
                //Invitation Expire
                
                [btnDetails setBackgroundImage:[UIImage imageNamed:@"redman"] forState:UIControlStateNormal];
                [UIView animateWithDuration:0.7 delay:0 options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction) animations:^{
                    
                    btnDetails.alpha=0.0;
                    
                }completion:^(BOOL finished){
                    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        
                        btnDetails.alpha=1.0;
                        
                    }completion:^(BOOL finished){
                        
                        
                    }];
                    
                }];
                
            }
            else if ([IsEngAssign isEqualToString:@"1"])
            {
                //Assigned
                [btnDetails setBackgroundImage:[UIImage imageNamed:@"greenman"] forState:UIControlStateNormal];
                
                //------------------------------ Engineer name -----------------------------------------------
                UILabel *lblEngineerName=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btnDetails.frame)-120,102,120,18)];
                lblEngineerName.textColor=[UIColor darkGrayColor];
                lblEngineerName.textAlignment=NSTextAlignmentRight;
                lblEngineerName.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
                lblEngineerName.backgroundColor=[UIColor clearColor];
                lblEngineerName.center=CGPointMake(lblEngineerName.center.x, btnFMDetailsPage.center.y);
                
                UIImageView *imgvEngineer=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgvCellbg.frame)-35,CGRectGetMaxY(btnFMDetailsPage.frame)-60,32,32)];
                [imgvEngineer.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
                [imgvEngineer.layer setBorderWidth: 1.0];
                [imgvEngineer.layer setCornerRadius:16.0f];
                [imgvEngineer.layer setMasksToBounds:YES];
                [imgvEngineer setImage:[UIImage imageNamed:@"No_ImageEngg"]];   //rky
                imgvEngineer.hidden=YES;
                
                if (![[dicTemp valueForKey:@"EngineerName"] isKindOfClass:[NSNull class]])
                {
                    if ([[dicTemp valueForKey:@"EngineerName"] isEqualToString:@""])
                    {
                        lblEngineerName.text=@"NOT ASSIGNED";
                    }
                    else
                    {
                        imgvEngineer.hidden=NO;
                        
                        lblEngineerName.text=[dicTemp valueForKey:@"EngineerName"];
                        
                        //  DLog(@"Engineer Image Url :%@",[dicTemp valueForKey:@"ImagePath"]);
                        NSURL *url = [NSURL URLWithString:[[dicTemp valueForKey:@"ImagePath"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                        
                        if (![dicTemp  valueForKey:@"EngineerImage"]) {
                            
                            [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
                                if (succeeded) {
                                    // change the image in the cell
                                    
                                    [imgvEngineer setImage:image];
                                    // cache the image for use later (when scrolling up)
                                    
                                  //  [dicTemp setValue:image forKey:@"EngineerImage"];
                                    
                                }
                            }];
                            
                        }
                        
                        else
                        {
//                            imgvEngineer.hidden=NO;
//                            [imgvEngineer setImage:[dicTemp  valueForKey:@"EngineerImage"]];
                            
                        }
                        
                        
                    }
                }
                else
                {
                    lblEngineerName.text=@"NOT ASSIGNED";
                    btnMapLocation.userInteractionEnabled=NO;
                }
                [cell.contentView addSubview:lblEngineerName];
                [cell.contentView addSubview:imgvEngineer];
                //-----------------------------------------------------------------------------------------------
            }
        }
        else if([jobstatus integerValue]==Active)
        {
            //Active
            [btnDetails setBackgroundImage:[UIImage imageNamed:@"greenman"] forState:UIControlStateNormal];
            [btnFMDetailsPage setBackgroundColor:[UIColor colorWithRed:96/255.0 green:145/255.0 blue:45/255.0 alpha:1.0]];
            [btnFMDetailsPage setTitle:@"Active" forState:UIControlStateNormal];
            
            //------------------------------ Engineer name -----------------------------------------------
            UILabel *lblEngineerName=[[UILabel alloc] initWithFrame:CGRectMake(202,101,80,18)];
            lblEngineerName.textAlignment=NSTextAlignmentLeft;
            lblEngineerName.textColor=[UIColor darkGrayColor];
            lblEngineerName.textAlignment=NSTextAlignmentCenter;
            lblEngineerName.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
            lblEngineerName.backgroundColor=[UIColor clearColor];
            
            UIImageView *imgvEngineer=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgvCellbg.frame)-35,CGRectGetMaxY(btnFMDetailsPage.frame)-60,32,32)];
            [imgvEngineer.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
            [imgvEngineer.layer setBorderWidth: 1.0];
            [imgvEngineer.layer setCornerRadius:16.0f];
            [imgvEngineer.layer setMasksToBounds:YES];
            [imgvEngineer setImage:[UIImage imageNamed:@"No_ImageEngg"]];
            imgvEngineer.hidden=YES;
            
            if (![[dicTemp valueForKey:@"EngineerName"] isKindOfClass:[NSNull class]])
            {
                if ([[dicTemp valueForKey:@"EngineerName"] isEqualToString:@""])
                {
                    lblEngineerName.text=@"NOT ASSIGNED";
                }
                else
                {
                    imgvEngineer.hidden=NO;
                    
                    lblEngineerName.text=[dicTemp valueForKey:@"EngineerName"];
                    
                    DLog(@"Engineer Image Url :%@",[dicTemp valueForKey:@"ImagePath"]);
                    NSURL *url = [NSURL URLWithString:[[dicTemp valueForKey:@"ImagePath"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                    
                    if (![dicTemp  valueForKey:@"EngineerImage"]) {
                        
                        [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
                            if (succeeded) {
                                // change the image in the cell
                                
                                [imgvEngineer setImage:image];
                                // cache the image for use later (when scrolling up)
                                
                              //  [dicTemp setValue:image forKey:@"EngineerImage"];
                                
                            }
                        }];
                        
                    }
                    
                    else
                    {
//                        imgvEngineer.hidden=NO;
//                        [imgvEngineer setImage:[dicTemp  valueForKey:@"EngineerImage"]];
                        
                    }
                    
                    
                }
            }
            else
            {
                lblEngineerName.text=@"NOT ASSIGNED";
                btnMapLocation.userInteractionEnabled=NO;
            }
            
            lblEngineerName.center=CGPointMake(lblEngineerName.center.x, btnFMDetailsPage.center.y);
            
            [cell.contentView addSubview:lblEngineerName];
            [cell.contentView addSubview:imgvEngineer];
            //-----------------------------------------------------------------------------------------------
            
            if ([[dicTemp valueForKey:@"IsAgreementSign"]boolValue]==YES)
            {
                UILabel *lblSubStatus=[[UILabel alloc]init];
                lblSubStatus.text=@"agreement Signed/Job in progress";
                lblSubStatus.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:10];
                lblSubStatus.center=CGPointMake(CGRectGetMidX(btnFMDetailsPage.frame), CGRectGetMaxY(btnFMDetailsPage.frame)+CGRectGetHeight(lblSubStatus.frame)/2.0f);
                [lblSubStatus sizeToFit];
                //[cell.contentView addSubview:lblSubStatus];
                
            }
            
            
        }
        else if([jobstatus integerValue]==JobCancelled)
        {
            //Completed
            [btnFMDetailsPage setBackgroundColor:[UIColor redColor]];
            [btnFMDetailsPage setTitle:@"Cancelled" forState:UIControlStateNormal];
            
            [btnDetails setBackgroundImage:[UIImage imageNamed:@"blackmancross"] forState:UIControlStateNormal];
        }
        else //if([jobstatus isEqualToString:@"3"])
        {
            //Completed
            [btnFMDetailsPage setBackgroundColor:[UIColor colorWithRed:96/255.0 green:145/255.0 blue:45/255.0 alpha:1.0]];
            [btnFMDetailsPage setTitle:@"Completed" forState:UIControlStateNormal];
            
            UILabel *lblSubStatusText;
            lblSubStatusText=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btnFMDetailsPage.frame),CGRectGetMaxY(btnFMDetailsPage.frame)-50,120,30)];
            lblSubStatusText.textAlignment=NSTextAlignmentLeft;
            lblSubStatusText.lineBreakMode = NSLineBreakByWordWrapping;
            lblSubStatusText.textColor=[UIColor darkGrayColor];
            lblSubStatusText.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:10.0];
            lblSubStatusText.backgroundColor=[UIColor clearColor];
            lblSubStatusText.numberOfLines=1;
            // [lblTimeAllowance sizeToFit]; //4566446445645646456
            
            if (![[dicTemp valueForKey:@"SubStatusText"]isKindOfClass:[NSNull class]])
            {
                lblSubStatusText.text=[GlobalDirector ReplaceStringNull:[dicTemp valueForKey:@"SubStatusText"]];
            }
            [cell.contentView addSubview:lblSubStatusText];
            
            
            
            //------------------------------ Engineer name -----------------------------------------------
            UILabel *lblEngineerName=[[UILabel alloc] initWithFrame:CGRectMake(202,101,110,18)];
            lblEngineerName.textAlignment=NSTextAlignmentLeft;
            lblEngineerName.textColor=[UIColor darkGrayColor];
            lblEngineerName.textAlignment=NSTextAlignmentCenter;
            lblEngineerName.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
            lblEngineerName.backgroundColor=[UIColor clearColor];
            
            UIImageView *imgvEngineer=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgvCellbg.frame)-35,CGRectGetMaxY(btnFMDetailsPage.frame)-60,32,32)];
            
            [imgvEngineer.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
            [imgvEngineer.layer setBorderWidth: 1.0];
            [imgvEngineer.layer setCornerRadius:16.0f];
            [imgvEngineer.layer setMasksToBounds:YES];
            [imgvEngineer setImage:[UIImage imageNamed:@"No_ImageEngg"]];
            
            imgvEngineer.hidden=YES;
            
            
            
            
            
            if (![[dicTemp valueForKey:@"EngineerName"] isKindOfClass:[NSNull class]])
            {
                if ([[dicTemp valueForKey:@"EngineerName"] isEqualToString:@""])
                {
                    lblEngineerName.text=@"NOT ASSIGNED";
                }
                else
                {
                    imgvEngineer.hidden=NO;
                    
                    lblEngineerName.text=[dicTemp valueForKey:@"EngineerName"];
                    
                    DLog(@"Engineer Image Url :%@",[dicTemp valueForKey:@"ImagePath"]);
                    NSURL *url = [NSURL URLWithString:[[dicTemp valueForKey:@"ImagePath"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                    
                    if (![dicTemp  valueForKey:@"EngineerImage"]) {
                        
                        [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
                            if (succeeded) {
                                // change the image in the cell
                                
                                [imgvEngineer setImage:image];
                                // cache the image for use later (when scrolling up)
                                
                               // [dicTemp setValue:image forKey:@"EngineerImage"];
                                
                            }
                        }];
                        
                    }
                    
                    else
                    {
//                        imgvEngineer.hidden=NO;
//                        [imgvEngineer setImage:[dicTemp  valueForKey:@"EngineerImage"]];
                        
                    }
                    
                    
                }
            }
            else
            {
                lblEngineerName.text=@"NOT ASSIGNED";
                btnMapLocation.userInteractionEnabled=NO;
            }
            
            
            for (NSDictionary *dic in arrJobStatus) {
                
                
                if ([[dic valueForKey:@"Value"]integerValue]==[jobstatus integerValue]) {
                    
                    if (![[dic valueForKey:@"DisplayText"] isEqualToString:@"Complete"]) {
                        
                        UILabel *lblSubStatus=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnFMDetailsPage.frame)+2,CGRectGetMinY(btnFMDetailsPage.frame),100,18)];
                        lblSubStatus.textAlignment=NSTextAlignmentLeft;
                        lblSubStatus.textColor=[UIColor colorWithRed:117/255.0f green:143/255.0f blue:39/255.0f alpha:1];
                        lblSubStatus.textAlignment=NSTextAlignmentCenter;
                        lblSubStatus.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
                        lblSubStatus.backgroundColor=[UIColor clearColor];
                        lblSubStatus.text=[NSString stringWithFormat:@"%@",[[dic valueForKey:@"DisplayText"] isEqualToString:@"Complete"]?@"":[dic valueForKey:@"DisplayText"]];
                        
                        lblSubStatus.numberOfLines=0;
                        [lblSubStatus sizeToFit];
                        
                        lblEngineerName.frame=CGRectMake(CGRectGetMaxX(lblSubStatus.frame)+5, CGRectGetMinY(lblSubStatus.frame), CGRectGetWidth(lblEngineerName.frame), 18);
                        lblEngineerName.numberOfLines=0;
                        [lblEngineerName sizeToFit];
                        lblEngineerName.center=CGPointMake(lblEngineerName.center.x, lblSubStatus.center.y);
                        
                        
                        [cell.contentView addSubview:lblSubStatus];
                        
                    }
                    
                    
                    
                }
                
            }
            
            
            lblEngineerName.center=CGPointMake(lblEngineerName.center.x, btnFMDetailsPage.center.y);
            
            [cell.contentView addSubview:lblEngineerName];
            [cell.contentView addSubview:imgvEngineer];
            //-----------------------------------------------------------------------------------------------
        }
        [cell.contentView addSubview:btnFMDetailsPage];
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"] && [jobstatus integerValue]==Book)
        {
            UIButton *btnInvite = [UIButton buttonWithType:UIButtonTypeCustom];
            btnInvite.frame = CGRectMake(CGRectGetMaxX(btnMapLocation.frame)+5,CGRectGetMaxY(btnMapLocation.frame)-40,70,20);
            [btnInvite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnInvite.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];;
            [btnInvite.layer setBorderColor: [[UIColor clearColor] CGColor]];
            [btnInvite.layer setBorderWidth: 0.0];
            [btnInvite.layer setCornerRadius:3.0f];
            [btnInvite.layer setMasksToBounds:YES];
            [btnInvite setBackgroundColor:[UIColor colorWithRed:96/255.0 green:145/255.0 blue:45/255.0 alpha:1.0]];
            [btnInvite setTitle:@"Invite" forState:UIControlStateNormal];
            btnInvite.tag=indexPath.row;
            btnInvite.accessibilityValue = [dicTemp valueForKey:@"JobID"];
            [btnInvite addTarget:self action:@selector(pressInvite:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btnInvite];
        }
    }
    
    //*********************************************** Cell Management **********************************************************************
    UILabel *lblJobTitle;
    UILabel *lblName;
    UILabel *lblTimePeriod;
    UILabel *lblTimePeriod2;

    UILabel *lblAddress;
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
    {
        //-----------------------------------------------  Job Description --------------------------------------------
        lblJobTitle=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnMapLocation.frame)+5,CGRectGetMinY(btnMapLocation.frame)-5,CGRectGetWidth(imgvCellbg.frame)-CGRectGetWidth(btnMapLocation.frame)-10,15)];
        lblJobTitle.textAlignment=NSTextAlignmentLeft;
        lblJobTitle.textColor=[UIColor darkGrayColor];
        lblJobTitle.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:13.0];
        lblJobTitle.backgroundColor=[UIColor clearColor];
        if (![[dicTemp valueForKey:@"JobDescription"] isKindOfClass:[NSNull class]])
        {
            lblJobTitle.text=[dicTemp valueForKey:@"JobDescription"];
        }
        else
        {
            lblJobTitle.text=@"";
        }
        lblJobTitle.numberOfLines=2;
        //lblJobTitle.lineBreakMode=NSLineBreakByWordWrapping;
        [lblJobTitle sizeToFit];
        [cell.contentView addSubview:lblJobTitle];
        
        //-------------------------------------------------- Customer Name ----------------------------------------
        lblName=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lblJobTitle.frame),CGRectGetMaxY(lblJobTitle.frame)+2,150,15)];
        lblName.textAlignment=NSTextAlignmentLeft;
        lblName.textColor=[UIColor blackColor];
        lblName.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.text=[NSString stringWithFormat:@"%@",@"Customer name"];
        if (![[PresentingUser valueForKey:@"FullName"] isKindOfClass:[NSNull class]])
        {
            lblName.text=[PresentingUser valueForKey:@"FullName"];
        }
        [cell.contentView addSubview:lblName];
        
        
        
        //-------------------------------------------------- Start date time --------------------------------------------------------------------------
        UIImageView *imgvTimeP=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(lblJobTitle.frame),CGRectGetMaxY(lblName.frame)+5, 13, 12)];
        [imgvTimeP setImage:[UIImage imageNamed:@"clock_icon"]];
        [cell.contentView addSubview:imgvTimeP];
        
        lblTimePeriod=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgvTimeP.frame)+2,CGRectGetMinY(imgvTimeP.frame),80,15)];
        lblTimePeriod.center=CGPointMake(CGRectGetMaxX(imgvTimeP.frame)+CGRectGetWidth(lblTimePeriod.frame)/2.0f+5, imgvTimeP.center.y);
        lblTimePeriod.textAlignment=NSTextAlignmentLeft;
        lblTimePeriod.textColor=[UIColor lightGrayColor];
        lblTimePeriod.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:10.0];
        lblTimePeriod.backgroundColor=[UIColor clearColor];
        lblTimePeriod.text=[NSString stringWithFormat:@"%@",@""];
        if ([[dicTemp valueForKey:@"JobStartDate"]length]>9)
        {
            NSString *strStartDate =[NSString stringWithFormat:@"%@",[dicTemp valueForKey:@"JobStartDate"]];
            NSArray* foo = [strStartDate componentsSeparatedByString: @" "];
            strStartDate=[foo objectAtIndex:0];
            // strStartDate = [strStartDate substringToIndex:10];
            lblTimePeriod.text=[NSString stringWithFormat:@"%@ %@",strStartDate,[dicTemp valueForKey:@"JobStartTime"]];
        }
        [cell.contentView addSubview:lblTimePeriod];
        
        //--------------------------------------------- Job Address -----------------------------------------------------------------------------------
        UIImageView *imgvAddr=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(lblJobTitle.frame),CGRectGetMaxY(lblTimePeriod.frame)+9, 14, 12)];
        [imgvAddr setImage:[UIImage imageNamed:@"address_icon"]];
        [cell.contentView addSubview:imgvAddr];
        
        lblAddress=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lblTimePeriod.frame),CGRectGetMinY(imgvAddr.frame)-2,80,24)];
        
        lblAddress.textAlignment=NSTextAlignmentLeft;
        lblAddress.textColor=[UIColor lightGrayColor];
        lblAddress.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:11];
        lblAddress.backgroundColor=[UIColor clearColor];
        lblAddress.text=[NSString stringWithFormat:@"%@",@""];
        
        
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
        {
            
            if ([PresentingJob valueForKey:@"Address"])
            {
                lblAddress.text=[NSString stringWithFormat:@"%@,%@",[PresentingJob valueForKey:@"City"],[PresentingJob valueForKey:@"Address"]];
                
            }
            else
            {
                lblAddress.text=@"";
            }
        }
        else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
        {
            if ([PresentingJob valueForKey:@"Address"])
            {
                lblAddress.text=[NSString stringWithFormat:@"%@,%@,%@,%@",[PresentingJob valueForKey:@"City"],[PresentingJob valueForKey:@"Address"],[PresentingJob valueForKey:@"County"],[PresentingJob valueForKey:@"PostCode"]];
            }
            else
            {
                lblAddress.text=@"";
            }
            lblAddress.numberOfLines=2;
        }
        else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
        {
            if ([PresentingJob valueForKey:@"Address"])
            {
                lblAddress.text=[NSString stringWithFormat:@"%@,%@",[PresentingJob valueForKey:@"City"],[PresentingJob valueForKey:@"Address"]];
                
            }
            else
            {
                lblAddress.text=@"";
            }
            
        }
        
        lblAddress.lineBreakMode=NSLineBreakByWordWrapping;
        lblAddress.numberOfLines=2;
        [lblAddress sizeToFit];
        [cell.contentView addSubview:lblAddress];
        
        
        
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        
        btnMapLocation.hidden=YES;
        
        //-----------------------------------------------  Job Description --------------------------------------------
        
        lblJobTitle=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnMapLocation.frame)+10,CGRectGetMinY(btnMapLocation.frame)-5,CGRectGetWidth(imgvCellbg.frame)-CGRectGetWidth(btnMapLocation.frame)-20,24)];
        lblJobTitle.textAlignment=NSTextAlignmentLeft;
        lblJobTitle.textColor=[UIColor blackColor];
        lblJobTitle.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
        lblJobTitle.backgroundColor=[UIColor clearColor];
        if (![[dicTemp valueForKey:@"JobDescription"] isKindOfClass:[NSNull class]])
        {
            lblJobTitle.text=[dicTemp valueForKey:@"JobDescription"];
        }
        else
        {
            lblJobTitle.text=@"";
        }
        lblJobTitle.numberOfLines=2;
        lblJobTitle.lineBreakMode=NSLineBreakByWordWrapping;
        //[lblJobTitle sizeToFit];
        [cell.contentView addSubview:lblJobTitle];
        
        //-------------------------------------------------- Customer Name ----------------------------------------
        
        lblName=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lblJobTitle.frame),CGRectGetMaxY(lblJobTitle.frame)+5,100,15)];
        lblName.textAlignment=NSTextAlignmentLeft;
        lblName.textColor=[UIColor blackColor];
        lblName.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.text=[NSString stringWithFormat:@"%@",@"Customer name"];
        
        NSString *orgName = [GlobalDirector ReplaceStringNull:[PresentingJob valueForKey:@"NameofOrganisation"]];
        
        if (orgName.length>0) {
            
            lblName.text=orgName;
            
        }else{
            
            if (![[PresentingUser valueForKey:@"FullName"] isKindOfClass:[NSNull class]])
            {
                lblName.text=[PresentingUser valueForKey:@"FullName"];
            }
            
        }
        
        [cell.contentView addSubview:lblName];
        
        
        //-------------------------------------------------- Start date time --------------------------------------------------------------------------
        UIImageView *imgvTimeP=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(lblJobTitle.frame),CGRectGetMaxY(lblName.frame)+8, 13, 12)];
        [imgvTimeP setImage:[UIImage imageNamed:@"clock_icon"]];
        [cell.contentView addSubview:imgvTimeP];
        
        lblTimePeriod=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgvTimeP.frame)+2,CGRectGetMinY(imgvTimeP.frame),130,20)];
        
        if(![dateTimeForStatus isEqual: @""]){
            
            UIImageView *imgvTimeP2=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(lblJobTitle.frame),CGRectGetMaxY(lblTimePeriod.frame)-5, 13, 12)];
            [imgvTimeP2 setImage:[UIImage imageNamed:@"clock_icon"]];
            [cell.contentView addSubview:imgvTimeP2];
            
            lblTimePeriod2=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgvTimeP2.frame)+2,CGRectGetMinY(imgvTimeP2.frame),130,20)];
            lblTimePeriod2.center=CGPointMake(CGRectGetMaxX(imgvTimeP2.frame)+CGRectGetWidth(lblTimePeriod2.frame)/2.0f+5, imgvTimeP2.center.y);
            
            lblTimePeriod2.textAlignment=NSTextAlignmentLeft;
            lblTimePeriod2.numberOfLines=0;
            
            lblTimePeriod2.textColor=[UIColor lightGrayColor];
            lblTimePeriod2.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:10.0];
            lblTimePeriod2.backgroundColor=[UIColor clearColor];
            lblTimePeriod2.text= dateTimeForStatus;
            [cell.contentView addSubview:lblTimePeriod2];
            
            
        }
        else{
            
        }
        lblTimePeriod.center=CGPointMake(CGRectGetMaxX(imgvTimeP.frame)+CGRectGetWidth(lblTimePeriod.frame)/2.0f+5, imgvTimeP.center.y);
        lblTimePeriod.textAlignment=NSTextAlignmentLeft;
        lblTimePeriod.numberOfLines=0;
        
        lblTimePeriod.textColor=[UIColor lightGrayColor];
        lblTimePeriod.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:10.0];
        lblTimePeriod.backgroundColor=[UIColor clearColor];
        lblTimePeriod.text=[NSString stringWithFormat:@"%@",@""];
        if ([[dicTemp valueForKey:@"JobStartDate"]length]>9)
        {
            NSString *strStartDate =[NSString stringWithFormat:@"%@",[dicTemp valueForKey:@"JobStartDate"]];
            // strStartDate = [strStartDate substringToIndex:10];
            NSArray* foo = [strStartDate componentsSeparatedByString: @" "];
            strStartDate=[foo objectAtIndex:0];
            lblTimePeriod.text=[NSString stringWithFormat:@"%@ %@",strStartDate,[dicTemp valueForKey:@"JobStartTime"]];
        }
        
        if(![dateTimeForStatus isEqual: @""]){
            lblTimePeriod.text = [NSString stringWithFormat:@"%@\n%@",lblTimePeriod.text,dateTimeForStatus];
        }
        
        [cell.contentView addSubview:lblTimePeriod];
        
        DLog(@"gdfghdfh :%@",[dicTemp valueForKey:@"TimeAllowance"]);
        
        UILabel *lblTimeAllowance;
        lblTimeAllowance=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lblJobTitle.frame),CGRectGetMaxY(lblTimePeriod.frame)+7,100,30)];
        lblTimeAllowance.textAlignment=NSTextAlignmentLeft;
        lblTimeAllowance.lineBreakMode = NSLineBreakByWordWrapping;
        lblTimeAllowance.textColor=[UIColor darkGrayColor];
        lblTimeAllowance.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:10.0];
        lblTimeAllowance.backgroundColor=[UIColor clearColor];
        lblTimeAllowance.numberOfLines=2;
        // [lblTimeAllowance sizeToFit]; //4566446445645646456
        
        if (![[dicTemp valueForKey:@"TimeAllowance"]isKindOfClass:[NSNull class]])
        {
            lblTimeAllowance.text=[NSString stringWithFormat:@"Time Allowance: %@",[dicTemp valueForKey:@"TimeAllowance"]];
        }
        [cell.contentView addSubview:lblTimeAllowance];
        
        
        
        
        
        
        UILabel *lblAddressBorder=[[UILabel alloc] initWithFrame:CGRectMake(2,2,120,CGRectGetHeight(imgvCellbg.frame)-5)];
        [lblAddressBorder.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [lblAddressBorder.layer setBorderWidth: 1.0];
        [lblAddressBorder.layer setCornerRadius:2.0f];
        [lblAddressBorder.layer setMasksToBounds:YES];
        [cell.contentView addSubview:lblAddressBorder];
        
        //------------------------------------------------ Address Details -----------------------------------------------------------
        UILabel *lblAddress1=[[UILabel alloc] initWithFrame:CGRectMake(10,10,100,15)];
        lblAddress1.textAlignment=NSTextAlignmentLeft;
        lblAddress1.textColor=[UIColor darkGrayColor];
        lblAddress1.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:10.8];
        lblAddress1.backgroundColor=[UIColor clearColor];
        lblAddress1.text=[NSString stringWithFormat:@"%@",@""];
        
        if ([PresentingJob valueForKey:@"Address"])
        {
            NSString *add =[NSString stringWithFormat:@"%@",[PresentingJob valueForKey:@"Address"]];
            NSString *org = [GlobalDirector ReplaceStringNull:[PresentingJob valueForKey:@"NameofOrganisation"]];
            
            if (org.length>0) {
                lblAddress1.text= [NSString stringWithFormat:@"%@, %@",org,add];
                
            }else{
                lblAddress1.text= add;
            }
            
        }
        else
        {
            lblAddress1.text=@"";
        }
        
        
        lblAddress1.numberOfLines=3;
        lblAddress1.lineBreakMode=NSLineBreakByCharWrapping;
        [lblAddress1 sizeToFit];
        
        NSString *IsEngAssign=[NSString stringWithFormat:@"%@",[dicTemp objectForKey:@"IsEngAssign"]];
        
        if (![IsEngAssign isEqualToString:@"1"]){
            lblAddress1.text = @"";
           lblAddress1=[[UILabel alloc] initWithFrame:CGRectMake(10,5,100,1)];

        }
        else{

        }
        [cell.contentView addSubview:lblAddress1];


        UILabel *lblAddress2=[[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(lblAddress1.frame)+4,100,15)];
        lblAddress2.textAlignment=NSTextAlignmentLeft;
        lblAddress2.textColor=[UIColor darkGrayColor];
        lblAddress2.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:10.8];
        lblAddress2.backgroundColor=[UIColor clearColor];
        lblAddress2.text=[NSString stringWithFormat:@"%@",@""];
        if ([PresentingJob valueForKey:@"City"])
        {
            lblAddress2.text=[NSString stringWithFormat:@"City/Town: %@",[PresentingJob valueForKey:@"City"]];
        }
        else
        {
            lblAddress2.text=@"";
        }
        lblAddress2.numberOfLines=1;
        lblAddress2.lineBreakMode=NSLineBreakByWordWrapping;
        //[lblAddress2 sizeToFit];
        [cell.contentView addSubview:lblAddress2];
        
        UILabel *lblAddress3=[[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(lblAddress2.frame)+4,100,15)];
        lblAddress3.textAlignment=NSTextAlignmentLeft;
        lblAddress3.textColor=[UIColor darkGrayColor];
        lblAddress3.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:10.8];
        lblAddress3.backgroundColor=[UIColor clearColor];
        lblAddress3.text=[NSString stringWithFormat:@"%@",@""];
        if ([PresentingJob valueForKey:@"County"])
        {
            lblAddress3.text=[NSString stringWithFormat:@"County: %@",[PresentingJob valueForKey:@"County"]];
        }
        else
        {
            lblAddress3.text=@"";
        }
        lblAddress3.numberOfLines=1;
        lblAddress3.lineBreakMode=NSLineBreakByWordWrapping;
        // [lblAddress3 sizeToFit];
        [cell.contentView addSubview:lblAddress3];
        
        UILabel *lblAddress4=[[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(lblAddress3.frame)+4,100,15)];
        lblAddress4.textAlignment=NSTextAlignmentLeft;
        lblAddress4.textColor=[UIColor darkGrayColor];
        lblAddress4.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:10.8];
        lblAddress4.backgroundColor=[UIColor clearColor];
        lblAddress4.text=[NSString stringWithFormat:@"%@",@""];
        if ([PresentingJob valueForKey:@"PostCode"])
        {
            lblAddress4.text=[NSString stringWithFormat:@"PostCode: %@",[PresentingJob valueForKey:@"PostCode"]];
        }
        else
        {
            lblAddress4.text=@"";
        }
        lblAddress4.numberOfLines=1;
        lblAddress4.lineBreakMode=NSLineBreakByWordWrapping;
        // [lblAddress4 sizeToFit];
        [cell.contentView addSubview:lblAddress4];
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        btnMapLocation.hidden=YES;
        
        //-----------------------------------------------  Job Description --------------------------------------------
        
        lblJobTitle=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnMapLocation.frame)+5,1,CGRectGetWidth(imgvCellbg.frame)-CGRectGetWidth(btnMapLocation.frame)-10,13)];
        lblJobTitle.textAlignment=NSTextAlignmentLeft;
        lblJobTitle.textColor=[UIColor darkGrayColor];
        lblJobTitle.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:13.0];
        lblJobTitle.backgroundColor=[UIColor clearColor];
        if (![[dicTemp valueForKey:@"JobDescription"] isKindOfClass:[NSNull class]])
        {
            lblJobTitle.text=[dicTemp valueForKey:@"JobDescription"];
        }
        else
        {
            lblJobTitle.text=@"";
        }
        lblJobTitle.numberOfLines=2;
        [lblJobTitle sizeToFit];
        [cell.contentView addSubview:lblJobTitle];
        
        //-------------------------------------------------- Customer Name ----------------------------------------
        
        lblName=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lblJobTitle.frame),CGRectGetMaxY(lblJobTitle.frame)+2,100,15)];
        lblName.textAlignment=NSTextAlignmentLeft;
        lblName.textColor=[UIColor blackColor];
        lblName.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.text=[NSString stringWithFormat:@"%@",@"Customer name"];
        
        NSString *orgName = [GlobalDirector ReplaceStringNull:[PresentingJob valueForKey:@"NameofOrganisation"]];
        
        if (orgName.length>0) {
            
            lblName.text=orgName;
            
        }else{
            if (![[PresentingUser valueForKey:@"FullName"] isKindOfClass:[NSNull class]])
            {
                lblName.text=[PresentingUser valueForKey:@"FullName"];
            }
            
        }
        
        
        
        [cell.contentView addSubview:lblName];
        
        //-------------------------------------------------- Start date time --------------------------------------------------------------------------
        UIImageView *imgvTimeP=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(lblJobTitle.frame),CGRectGetMaxY(lblName.frame)+5, 13, 12)];
        [imgvTimeP setImage:[UIImage imageNamed:@"clock_icon"]];
        [cell.contentView addSubview:imgvTimeP];
        
        
        lblTimePeriod=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgvTimeP.frame)+2,CGRectGetMinY(imgvTimeP.frame),80,15)];
        lblTimePeriod.center=CGPointMake(CGRectGetMaxX(imgvTimeP.frame)+CGRectGetWidth(lblTimePeriod.frame)/2.0f+5, imgvTimeP.center.y);
        lblTimePeriod.textAlignment=NSTextAlignmentLeft;
        lblTimePeriod.textColor=[UIColor lightGrayColor];
        lblTimePeriod.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:10.0];
        lblTimePeriod.backgroundColor=[UIColor clearColor];
        lblTimePeriod.text=[NSString stringWithFormat:@"%@",@""];
        if ([[dicTemp valueForKey:@"JobStartDate"]length]>9)
        {
            NSString *strStartDate =[NSString stringWithFormat:@"%@",[dicTemp valueForKey:@"JobStartDate"]];
            //strStartDate = [strStartDate substringToIndex:10];
            NSArray* foo = [strStartDate componentsSeparatedByString: @" "];
            strStartDate=[foo objectAtIndex:0];
            lblTimePeriod.text=[NSString stringWithFormat:@"%@ %@",strStartDate,[dicTemp valueForKey:@"JobStartTime"]];
        }
        [cell.contentView addSubview:lblTimePeriod];
        
        DLog(@"gdfghdfh :%@",[dicTemp valueForKey:@"TimeAllowance"]);
        
        UILabel *lblTimeAllowance;
        lblTimeAllowance=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lblJobTitle.frame),CGRectGetMaxY(lblTimePeriod.frame)+4,150,15)];
        lblTimeAllowance.textAlignment=NSTextAlignmentLeft;
        lblTimeAllowance.textColor=[UIColor darkGrayColor];
        lblTimeAllowance.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
        lblTimeAllowance.backgroundColor=[UIColor clearColor];
        if (![[dicTemp valueForKey:@"TimeAllowance"]isKindOfClass:[NSNull class]])
        {
            lblTimeAllowance.text=[NSString stringWithFormat:@"T.A: %@",[dicTemp valueForKey:@"TimeAllowance"]];
        }
        [cell.contentView addSubview:lblTimeAllowance];
        
        
        
        
        
        UILabel *lblAddressBorder=[[UILabel alloc] initWithFrame:CGRectMake(2,2,120,CGRectGetHeight(imgvCellbg.frame)-5)];
        [lblAddressBorder.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [lblAddressBorder.layer setBorderWidth: 1.0];
        [lblAddressBorder.layer setCornerRadius:2.0f];
        [lblAddressBorder.layer setMasksToBounds:YES];
        [cell.contentView addSubview:lblAddressBorder];
        
        //------------------------------------------------ Address Details -----------------------------------------------------------
        UILabel *lblAddress1=[[UILabel alloc] initWithFrame:CGRectMake(10,10,100,15)];
        lblAddress1.textAlignment=NSTextAlignmentLeft;
        lblAddress1.textColor=[UIColor darkGrayColor];
        lblAddress1.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:10.8];
        lblAddress1.backgroundColor=[UIColor clearColor];
        lblAddress1.text=[NSString stringWithFormat:@"%@",@""];
        if ([PresentingJob valueForKey:@"Address"])
        {
            // lblAddress1.text=[NSString stringWithFormat:@"%@",[PresentingJob valueForKey:@"Address"]];
            NSString *add =[NSString stringWithFormat:@"%@",[PresentingJob valueForKey:@"Address"]];
            NSString *org = [GlobalDirector ReplaceStringNull:[PresentingJob valueForKey:@"NameofOrganisation"]];
            
            if (org.length>0) {
                lblAddress1.text= [NSString stringWithFormat:@"%@, %@",org,add];
                
            }else{
                lblAddress1.text= add;
            }
            
        }
        else
        {
            lblAddress1.text=@"";
        }
        lblAddress1.numberOfLines=2;
        lblAddress1.lineBreakMode=NSLineBreakByWordWrapping;
        [lblAddress1 sizeToFit];
        [cell.contentView addSubview:lblAddress1];
        
        UILabel *lblAddress2=[[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(lblAddress1.frame)+4,100,15)];
        lblAddress2.textAlignment=NSTextAlignmentLeft;
        lblAddress2.textColor=[UIColor darkGrayColor];
        lblAddress2.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:10.8];
        lblAddress2.backgroundColor=[UIColor clearColor];
        lblAddress2.text=[NSString stringWithFormat:@"%@",@""];
        if ([PresentingJob valueForKey:@"City"])
        {
            lblAddress2.text=[NSString stringWithFormat:@"City/Town: %@",[PresentingJob valueForKey:@"City"]];
        }
        else
        {
            lblAddress2.text=@"";
        }
        lblAddress2.numberOfLines=1;
        lblAddress2.lineBreakMode=NSLineBreakByWordWrapping;
        //[lblAddress2 sizeToFit];
        [cell.contentView addSubview:lblAddress2];
        
        UILabel *lblAddress3=[[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(lblAddress2.frame)+4,100,15)];
        lblAddress3.textAlignment=NSTextAlignmentLeft;
        lblAddress3.textColor=[UIColor darkGrayColor];
        lblAddress3.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:10.8];
        lblAddress3.backgroundColor=[UIColor clearColor];
        lblAddress3.text=[NSString stringWithFormat:@"%@",@""];
        if ([PresentingJob valueForKey:@"County"])
        {
            lblAddress3.text=[NSString stringWithFormat:@"County: %@",[PresentingJob valueForKey:@"County"]];
        }
        else
        {
            lblAddress3.text=@"";
        }
        lblAddress3.numberOfLines=1;
        lblAddress3.lineBreakMode=NSLineBreakByWordWrapping;
        //[lblAddress3 sizeToFit];
        [cell.contentView addSubview:lblAddress3];
        
        UILabel *lblAddress4=[[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(lblAddress3.frame)+4,100,15)];
        lblAddress4.textAlignment=NSTextAlignmentLeft;
        lblAddress4.textColor=[UIColor darkGrayColor];
        lblAddress4.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:10.8];
        lblAddress4.backgroundColor=[UIColor clearColor];
        lblAddress4.text=[NSString stringWithFormat:@"%@",@""];
        if ([PresentingJob valueForKey:@"PostCode"])
        {
            lblAddress4.text=[NSString stringWithFormat:@"PostCode: %@",[PresentingJob valueForKey:@"PostCode"]];
        }
        else
        {
            lblAddress4.text=@"";
        }
        lblAddress4.numberOfLines=1;
        lblAddress4.lineBreakMode=NSLineBreakByWordWrapping;
        [lblAddress4 sizeToFit];
        [cell.contentView addSubview:lblAddress4];
    }
    
    //------------- Engineer Check AND Job Status > 2 ------------------------------------------------------------------------
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"]&&[jobstatus integerValue]>2)
    {
        
        
        
        //------- INVOICE NUMBER ---------
        UILabel *invoiceNumber=[[UILabel alloc]init];
        invoiceNumber.frame=CGRectMake(CGRectGetWidth(imgvCellbg.frame),CGRectGetMinY(lblName.frame)+3,80,30);
        invoiceNumber.textColor=[UIColor colorWithRed:96/255.0 green:145/255.0 blue:45/255.0 alpha:1.0];
        invoiceNumber.textAlignment=NSTextAlignmentCenter;
        invoiceNumber.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:9];
        invoiceNumber.backgroundColor=[UIColor clearColor];
        NSDictionary *attrs22222 = @{ NSForegroundColorAttributeName : [UIColor blueColor],NSFontAttributeName:[UIFont fontWithName:@"TheSansArabic-Bold" size:13]};
        UIColor *color2121 = [UIColor redColor];
        NSDictionary *attrs11111 = @{ NSForegroundColorAttributeName : color2121 };
        NSString *strINVn = @"INVOICE NO.";
        NSAttributedString *attr123 = [[NSAttributedString alloc] initWithString:strINVn attributes:attrs11111];
        NSString *strINVn1 = [NSString stringWithFormat:@"%@",[dicTemp valueForKey:@"InvoiceNumberID"]];
        if ([strINVn1 intValue]== -1) {
            strINVn1=@"N/A";
        }
        
        NSAttributedString *attr124 = [[NSAttributedString alloc] initWithString:strINVn1 attributes:attrs22222];
        NSMutableAttributedString *InvNoTotal = [[NSMutableAttributedString alloc] init];
        [InvNoTotal appendAttributedString:attr123];
        [InvNoTotal appendAttributedString:attr124];
        
        
        invoiceNumber.attributedText=InvNoTotal;
        [invoiceNumber setNumberOfLines:0];
        [invoiceNumber.layer setBorderColor: [[UIColor colorWithRed:137/255.0 green:182/255.0 blue:40/255.0 alpha:1.0] CGColor]];
        [invoiceNumber.layer setBorderWidth: 0.5];
        [invoiceNumber.layer setCornerRadius:0.0f];
        [invoiceNumber.layer setMasksToBounds:YES];
        
        CGRect tempFrame1=invoiceNumber.frame;
        tempFrame1.origin.x=CGRectGetMaxX(imgvCellbg.frame)-CGRectGetWidth(invoiceNumber.frame)-10;
        invoiceNumber.frame=tempFrame1;
        [cell.contentView addSubview:invoiceNumber];
        
        //-------- INVOICE TOTAL ----------
        UILabel *lblInvoiceTotal=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(imgvCellbg.frame),CGRectGetMaxY(invoiceNumber.frame)+4,80,40)];
        lblInvoiceTotal.textAlignment=NSTextAlignmentCenter;
        lblInvoiceTotal.textColor=[UIColor darkGrayColor];
        lblInvoiceTotal.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:9];
        lblInvoiceTotal.backgroundColor=[UIColor whiteColor];
        lblInvoiceTotal.text=[NSString stringWithFormat:@"%@",@""];
        [lblInvoiceTotal.layer setBorderColor: [[UIColor colorWithRed:137/255.0 green:182/255.0 blue:40/255.0 alpha:1.0] CGColor]];
        [lblInvoiceTotal.layer setBorderWidth: 0.5];
        [lblInvoiceTotal.layer setCornerRadius:0.0f];
        [lblInvoiceTotal.layer setMasksToBounds:YES];
        // NSString *strTotalInvoice = [NSString stringWithFormat:@"£%.2f",[[dicTemp valueForKey:@"JobTotal"]floatValue]*(100+[[dicTemp valueForKey:@"CurrentVat"]floatValue])/100];  we are change this according to client 21/02/2017
        
        NSString *strTotalInvoice = [GlobalDirector ReplaceStringNull:[dicTemp valueForKey:@"JobTotal"]];
        
        NSDictionary *attrs1 = @{ NSForegroundColorAttributeName : [UIColor blueColor],NSFontAttributeName:[UIFont fontWithName:@"TheSansArabic-Bold" size:13]};
        NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString:strTotalInvoice attributes:attrs1];
        UIColor *color = [UIColor redColor];
        NSString *string = @"\nINVOICE TOTAL";
        NSDictionary *attrs = @{ NSForegroundColorAttributeName : color };
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:string attributes:attrs];
        NSMutableAttributedString *invoiceTotal = [[NSMutableAttributedString alloc] init];
        [invoiceTotal appendAttributedString:attrStr1];
        [invoiceTotal appendAttributedString:attrStr];
        lblInvoiceTotal.attributedText=invoiceTotal;
        [lblInvoiceTotal setNumberOfLines:0];
        
        CGRect tempFrame=lblInvoiceTotal.frame;
        tempFrame.origin.x=CGRectGetMaxX(imgvCellbg.frame)-CGRectGetWidth(lblInvoiceTotal.frame)-10;
        lblInvoiceTotal.frame=tempFrame;
        [cell.contentView addSubview:lblInvoiceTotal];
        
        //-------- COST TOTAL ---------
        UILabel *lblCostTotal=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(imgvCellbg.frame)-120,CGRectGetMaxY(lblInvoiceTotal.frame)+4,60,40)];
        lblCostTotal.textAlignment=NSTextAlignmentCenter;
        lblCostTotal.textColor=[UIColor darkGrayColor];
        lblCostTotal.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:9];
        lblCostTotal.backgroundColor=[UIColor whiteColor];
        lblCostTotal.text=[NSString stringWithFormat:@"%@",@""];
        [lblCostTotal.layer setBorderColor: [[UIColor colorWithRed:137/255.0 green:182/255.0 blue:40/255.0 alpha:1.0] CGColor]];
        [lblCostTotal.layer setBorderWidth: 0.5];
        [lblCostTotal.layer setCornerRadius:0.0f];
        [lblCostTotal.layer setMasksToBounds:YES];
        NSString *strCostInvoice = [NSString stringWithFormat:@"£%.2f",[[dicTemp valueForKey:@"AllTotalCost"]floatValue]];
        NSAttributedString *attrStrCost = [[NSAttributedString alloc] initWithString:strCostInvoice attributes:attrs1];
        NSString *stringVal = @"\nCOST TOTAL";
        NSAttributedString *attrCostVal = [[NSAttributedString alloc] initWithString:stringVal attributes:attrs];
        NSMutableAttributedString *CostTotal = [[NSMutableAttributedString alloc] init];
        [CostTotal appendAttributedString:attrStrCost];
        [CostTotal appendAttributedString:attrCostVal];
        lblCostTotal.attributedText=CostTotal;
        [lblCostTotal setNumberOfLines:0];
        lblCostTotal.center=CGPointMake(lblInvoiceTotal.center.x, lblCostTotal.center.y);
        [cell.contentView addSubview:lblCostTotal];
    }
    else
    {
        UIButton *btnAgreement;
        
        NSString *smallAgre = [GlobalDirector ReplaceStringNull:[dicTemp valueForKey:@"CustomerAgreementLink"]];
        NSString *FixedAgre = [GlobalDirector ReplaceStringNull:[dicTemp valueForKey:@"DetailsAgreementLink"]];
        
        if ([[dicTemp valueForKey:@"IsAgreementSign"]boolValue]==YES && (smallAgre.length>0 || FixedAgre.length>0))
        {
            btnAgreement=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            
            
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
            {
                // btnInvoice.center=CGPointMake(btnAgreement.center.x, btnAgreement.center.y+btnAgreement.frame.size.height+2);
                btnAgreement.center=CGPointMake(CGRectGetWidth(imgvCellbg.frame)-24, CGRectGetHeight(imgvCellbg.frame)/2.0f+7);
            }else{
                btnAgreement.center=CGPointMake(CGRectGetWidth(imgvCellbg.frame)-24, CGRectGetHeight(imgvCellbg.frame)/2.0f-10);
            }
            
            
            [btnAgreement addTarget:self action:@selector(openAgreement:) forControlEvents:UIControlEventTouchUpInside];
            btnAgreement.tag=indexPath.row;
            [btnAgreement setBackgroundImage:[UIImage imageNamed:@"agreement"] forState:UIControlStateNormal];
            
            UILabel *lblagrStatus=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
            lblagrStatus.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12];
            lblagrStatus.text=[NSString stringWithFormat:@"%ld",(long)[[dicTemp valueForKey:@"IsAgreementSign"]integerValue]];
            lblagrStatus.textAlignment=NSTextAlignmentCenter;
            lblagrStatus.backgroundColor=[UIColor redColor];
            lblagrStatus.textColor=[UIColor whiteColor];
            lblagrStatus.center=CGPointMake(CGRectGetMaxX(btnAgreement.frame)-8, CGRectGetMinY(btnAgreement.frame));
            lblagrStatus.layer.cornerRadius=CGRectGetHeight(lblagrStatus.frame)/2.0f;
            lblagrStatus.layer.masksToBounds=YES;
            
            
            [cell.contentView addSubview:btnAgreement];
            [cell.contentView addSubview:lblagrStatus];
        }
        
        if ([[dicTemp valueForKey:@"InvoiceDetailsLink"]length]>0)
        {
            UIButton *btnInvoice=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            btnInvoice.center=CGPointMake(CGRectGetWidth(imgvCellbg.frame)-70, CGRectGetHeight(imgvCellbg.frame)/2.0f-10);
            
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
            {
                // btnInvoice.center=CGPointMake(btnAgreement.center.x, btnAgreement.center.y+btnAgreement.frame.size.height+2);
                btnInvoice.center=CGPointMake(CGRectGetWidth(imgvCellbg.frame)-70, CGRectGetHeight(imgvCellbg.frame)/2.0f+4);
            }
            
            
            btnInvoice.layer.borderColor=[[UIColor grayColor]CGColor];
            [btnInvoice addTarget:self action:@selector(openInvoice:) forControlEvents:UIControlEventTouchUpInside];
            btnInvoice.tag=indexPath.row;
            [btnInvoice setBackgroundImage:[UIImage imageNamed:@"invoice"] forState:UIControlStateNormal];
            
            
            //  NSLog(@"InvoiceNumbeID :%@",[dicTemp valueForKey:@"InvoiceNumberID"]);
            
            NSString *str = [GlobalDirector ReplaceStringNull:[dicTemp valueForKey:@"InvoiceNumberID"]];
            NSString *strLink = [GlobalDirector ReplaceStringNull:[dicTemp valueForKey:@"InvoiceDetailsLink"]];
            
            if ([str intValue]== -1) {
                str=@"N/A";
            }
            
            if (str.length>0 && strLink.length>0)
            {
                [cell.contentView addSubview:btnInvoice];
                
                UILabel *invoiceNo=[[UILabel alloc]init];
                invoiceNo.textColor=[UIColor colorWithRed:96/255.0 green:145/255.0 blue:45/255.0 alpha:1.0];
                invoiceNo.textAlignment=NSTextAlignmentRight;
                invoiceNo.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
                invoiceNo.backgroundColor=[UIColor clearColor];
                invoiceNo.text=[NSString stringWithFormat:@"%@",str];
                [invoiceNo sizeToFit];
                invoiceNo.center=CGPointMake(btnInvoice.center.x, btnInvoice.center.y+CGRectGetHeight(btnInvoice.frame)/2.0f+4.4);
                [cell.contentView addSubview:invoiceNo];
            }
            
            
            
        }
        
    }
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        
        if ([IsJobExpired isEqualToString:@"1"])
        {
            lblJobTitle.textColor=[UIColor darkGrayColor];
            lblName.textColor=[UIColor darkGrayColor];
            lblTimePeriod.textColor=[UIColor darkGrayColor];
            lblAddress.textColor=[UIColor darkGrayColor];
        }
    }
    [cell.contentView addSubview:btnDetails];
    
    //------------- EDIT JOB DETAILS ----------------------------
    for (NSString *Str in arrEditedJobDic)
    {
        if ([Str integerValue]==[[dicTemp valueForKey:@"JobID"]integerValue])
        {
            cell.userInteractionEnabled=NO;
            UIActivityIndicatorView *activityIndicator;
            activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
            activityIndicator.center = CGPointMake(CGRectGetWidth(imgvCellbg.frame)-60, imgvCellbg.center.y+10);
            [activityIndicator startAnimating];
            [cell.contentView addSubview: activityIndicator];
        }
    }
    //------------------------------------------------------------
    
    return cell;
}

-(void)pressInvite:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    DLog(@"Selected IndexPath :%ld",(long)btn.tag);
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        
        distanceAlert = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter distance in miles." preferredStyle:UIAlertControllerStyleAlert];
        [distanceAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            [textField addTarget:self action:@selector(alertTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];


            textField.placeholder = @"distance(miles)";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if(![[[self->distanceAlert textFields][0] text]  isEqual: @""]){
                EngineerListVC *vcObj = [[EngineerListVC alloc]initWithNibName:@"EngineerListVC" bundle:nil];
                vcObj.distnceValue = [[self->distanceAlert textFields][0] text];
                NSString *jobId = btn.accessibilityValue;
                vcObj.jobId = [jobId integerValue];

                [self.navigationController pushViewController:vcObj animated:YES];

                NSLog(@"Current password %@", [[self->distanceAlert textFields][0] text]);

            }
            else{
                [self pressInvite:btn];
            }
            //compare the current password and do action here

        }];
        [confirmAction setEnabled:FALSE];          // Initially disabled

        [distanceAlert addAction:confirmAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Canelled");
        }];
        [distanceAlert addAction:cancelAction];
        [self presentViewController:distanceAlert animated:YES completion:nil];
        
        
        
    }
}
-(void)alertTextFieldDidChange:(UITextField*)sender
{
    [distanceAlert.actions[0] setEnabled: sender.text.length > 0 ? TRUE: FALSE];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    NSMutableDictionary *dicTemp;
    
    if (tableView.tag==111)
    {
        dicTemp=[JobsOnDate objectAtIndex:indexPath.row];
    }
    else
    {//this is to remove crash
        if (indexPath.row==[arrMFilterJobsList count])
        {
            return;
        }
        
        dicTemp=[arrMFilterJobsList objectAtIndex:indexPath.row];
    }
    
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
    {
        Customer_EngineerJobDetails *customerjobdetails;
        
        customerjobdetails=[[Customer_EngineerJobDetails alloc]initWithNibName:@"Customer_EngineerJobDetails" bundle:nil];
        customerjobdetails.dicCustomerJobDetails=dicTemp;
        [self.navigationController pushViewController:customerjobdetails animated:YES];
        
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        
        
        NSString *IsEngAssign=[NSString stringWithFormat:@"%@",[dicTemp objectForKey:@"IsEngAssign"]];
        
        if ([IsEngAssign isEqualToString:@"1"])
        {
            //Assigned
            ManagerJobDetails *mJobdetails;
            mJobdetails=[[ManagerJobDetails alloc]initWithNibName:@"EngineerJobDetails" bundle:nil];
            mJobdetails.dicManagerJobDetails=dicTemp;
            mJobdetails.stausCell=[NSString stringWithFormat:@"%@",[dicTemp objectForKey:@"JobStatus"]];
            [self.navigationController pushViewController:mJobdetails animated:YES];
            
            
        }
        else
        {
            
            [self ShowDetailJobPopUp:dicTemp];
        }
        
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        
        ManagerJobDetails *mJobdetails;
        
        mJobdetails=[[ManagerJobDetails alloc]initWithNibName:@"ManagerJobDetails" bundle:nil];
        mJobdetails.dicManagerJobDetails=dicTemp;
        mJobdetails.stausCell=[NSString stringWithFormat:@"%@",[dicTemp objectForKey:@"JobStatus"]];
        [self.navigationController pushViewController:mJobdetails animated:YES];
    }
    
    //}
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell setAlpha:0.0f];
    
    //fade in
    [UIView animateWithDuration:0.5f animations:^{
        
        [cell setAlpha:1.0f];
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}



#pragma mark - Change Page Method
-(IBAction)changepage:(id)sender
{
    
    if (isPrevJobAvailable==YES)
    {
        page = pageControl.currentPage-1;
        [self fetchJobdetails];
    }
    else{
    }
}

#pragma mark Async Image Loading Method
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

#pragma mark Previous Button Press Method
-(IBAction)btnPrevJobPressed:(UIButton *)sender
{
    if (isPrevJobAvailable==YES)
    {
        page=page-1;
        MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:Vwtbl animated:YES];
        hud.labelText=@"loading jobs from previous page";
        [conn cancel];
        conn=nil;
        [self fetchJobdetails];
    }
    else{
    }
}

#pragma mark Next Button Press Method



-(IBAction)onClickNextJobPressed:(id)sender {
    NSLog(@"Calle OnCLicknext job Button");
}
-(IBAction)btnNxtJobPressed:(UIButton *)sender
{
    
    
    if (isNxtJobAvailable==YES) {
        page=page+1;
        
        isLoadMore=YES;
        [sender setTitle:@"Loading ..." forState:UIControlStateNormal];
        [sender setTintColor:[UIColor grayColor]];
        
        
        [conn cancel];
        conn=nil;
        
        [self fetchJobdetails];
        
        
    }
    else
    {
        
    }
    
}

#pragma mark - Agreement Open Press Method
-(IBAction)openAgreement:(UIButton *)sender
{
    DLog(@"Agreement Pressed");
    
    SignAgreement *signagree=[[SignAgreement alloc]initWithNibName:@"SignAgreement" bundle:nil];
    
    signagree.strHeading=@"Agreement";
    signagree.jobID=[dicJobDetails valueForKey:@"JobID"];
    NSDictionary *dicTemp;
    
    if (btnListandCalender.tag==1)
    {
        dicTemp=[JobsOnDate objectAtIndex:sender.tag];
    }else{
        dicTemp=[arrMFilterJobsList objectAtIndex:sender.tag];
    }
    
    signagree.JobDic=dicTemp;
    signagree.isAgreementSigned=[[dicTemp valueForKey:@"IsAgreementSign"]boolValue];
    [self.navigationController pushViewController:signagree animated:true];
     DLog(@"Agreement Pressed complete ");
}

#pragma mark - Invoice Open Press Method
-(IBAction)openInvoice:(UIButton *)sender{
    
    SignAgreement *signagree=[[SignAgreement alloc]initWithNibName:@"SignAgreement" bundle:nil];
    
    signagree.strHeading=@"Invoice";
    signagree.jobID=[dicJobDetails valueForKey:@"JobID"];
    
    NSDictionary *dicTemp;
    
    if (btnListandCalender.tag==1)
    {
        dicTemp=[JobsOnDate objectAtIndex:sender.tag];
    }else{
        dicTemp=[arrMFilterJobsList objectAtIndex:sender.tag];
    }
    signagree.JobDic=dicTemp;
    signagree.isAgreementSigned=[[dicTemp valueForKey:@"IsAgreementSign"]boolValue];
    signagree.isInvoice=YES;
    [self.navigationController pushViewController:signagree animated:true];
}

#pragma mark Engineer Accept/Decline Details PopUp View
-(void)ShowDetailJobPopUp:(NSDictionary *)dic
{
    
    mainBg33 = [[UIControl alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    mainBg33.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    
    bgVw22 = [[UIControl alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame)-40,self.view.frame.size.height-100)];
    bgVw22.center=CGPointMake(CGRectGetWidth(mainBg33.frame)/2.0f, CGRectGetHeight(mainBg33.frame)/2.0f);
    [bgVw22.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [bgVw22.layer setBorderWidth: 0.5];
    [bgVw22.layer setCornerRadius:4.0f];
    [bgVw22.layer setMasksToBounds:YES];
    bgVw22.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    bgVw22.alpha=0.0f;
    
    
    UILabel *lblHeadingTitle = [[UILabel alloc] initWithFrame:CGRectMake(5,22,CGRectGetWidth(bgVw22.frame)-10,33)];
    lblHeadingTitle.text = @"Job Details";
    lblHeadingTitle.font = [UIFont fontWithName:@"TheSansArabic-Bold" size:15.0];
    lblHeadingTitle.textAlignment = NSTextAlignmentCenter;
    lblHeadingTitle.textColor=[UIColor whiteColor];
    lblHeadingTitle.backgroundColor = [UIColor darkGrayColor];
    [lblHeadingTitle.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [lblHeadingTitle.layer setBorderWidth: 1.0];
    [lblHeadingTitle.layer setCornerRadius:0.0f];
    [lblHeadingTitle.layer setMasksToBounds:YES];
    [bgVw22 addSubview:lblHeadingTitle];
    
    NSMutableAttributedString *strJobDetails=[[NSMutableAttributedString alloc]initWithString:@""];
    NSAttributedString *cr = [[NSAttributedString alloc] initWithString: @"\n\n"];
    NSAttributedString *strJobDesc=[self FormatString:[NSString stringWithFormat:@"Job Description: %@",[dic valueForKey:@"JobDescription"]] initial:@"Job Description"];
    
    
    
    
    
    NSString *jobstatus=[NSString stringWithFormat:@"%@",[dic objectForKey:@"JobStatus"]];
    NSString *IsAccepted=[NSString stringWithFormat:@"%@",[dic objectForKey:@"IsAccepted"]];
    NSString *IsEngAssign=[NSString stringWithFormat:@"%@",[dic objectForKey:@"IsEngAssign"]];

    NSAttributedString * dateTimeForStatus = [[NSMutableAttributedString alloc]initWithString:@""];

    //NSString *IsActive=[NSString stringWithFormat:@"%@",[dicTemp objectForKey:@"IsActive"]];
    
    if ([jobstatus integerValue]==Book)
    {
        //Booked
        if ([IsAccepted isEqualToString:@"0"]&&[[dic objectForKey:@"IsEngAssign"]integerValue]==0)
        {
            if(![[dic valueForKey:@"CreatedOn"] isKindOfClass:[NSNull class]] && [[dic objectForKey:@"CreatedOn"] length] > 0){
                dateTimeForStatus=[self FormatString:[NSString stringWithFormat:@"Invited Date & Time:: %@",[GlobalDirector ReplaceStringNull: [dic objectForKey:@"CreatedOn"]]] initial:@"Invited Date & Time:"];

            }
           
        }
        else if ([IsAccepted isEqualToString:@"1"])
        {
            if(![[dic valueForKey:@"AcceptedDate"] isKindOfClass:[NSNull class]] && [[dic objectForKey:@"AcceptedDate"] length] > 0){
                dateTimeForStatus=[self FormatString:[NSString stringWithFormat:@"Accepted Date & Time: %@",[GlobalDirector ReplaceStringNull: [dic objectForKey:@"AcceptedDate"]]] initial:@"Accepted Date & Time:"];

            }
        }
        
        if ([IsEngAssign isEqualToString:@"1"])
        {
            //Assigned
            if(![[dic valueForKey:@"AssignedDate"] isKindOfClass:[NSNull class]] && [[dic objectForKey:@"AssignedDate"] length] > 0){
                dateTimeForStatus=[self FormatString:[NSString stringWithFormat:@"Assigned Date & Time:: %@",[GlobalDirector ReplaceStringNull: [dic objectForKey:@"AssignedDate"]]] initial:@"Assigned Date & Time:"];

            }

        }
        
    }
    
    NSString *StartDate =[NSString stringWithFormat:@"%@",[dic valueForKey:@"JobStartDate"]];
    //StartDate = [StartDate substringToIndex:10];
    NSArray* foo = [StartDate componentsSeparatedByString: @" "];
    StartDate=[foo objectAtIndex:0];
    
    NSAttributedString *strStartDate=[self FormatString:[NSString stringWithFormat:@"Job StartDate: %@",StartDate] initial:@"Job StartDate"];
    NSAttributedString *strStartTime=[self FormatString:[NSString stringWithFormat:@"Job StartTime: %@",[dic valueForKey:@"JobStartTime"]] initial:@"Job StartTime"];

    
    
    NSArray *arr=[dic objectForKey:@"JobAddrListResponse"];
    NSDictionary *PresentingJob,*PresentingUser;
    
    for (NSDictionary *dic in arr) {
        if ([[dic valueForKey:@"TypeOfAddress"]integerValue]==1) {
            PresentingJob=dic;
            
        }
    }
    NSArray *arr2=[dic objectForKey:@"JobPeopleListResponse"];
    for (NSDictionary *dic in arr2) {
        
        /* if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==1) {
         PresentingUser=dic;
         
         }*/
        
        if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==1) {
            PresentingUser=dic;
            
        }else if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==3 || [[dic valueForKey:@"TypeofCustomer"]integerValue]==4){
            
            if (!PresentingUser) {
                PresentingUser=dic;
            }
            
            
        }
        
        
    }
    
    
    
    NSAttributedString *strTitle=[self FormatString:[NSString stringWithFormat:@"Title: %@",[GlobalDirector ReplaceStringNull:[PresentingUser valueForKey:@"Title"]]] initial:@"Title"];
    NSAttributedString *strFullName=[self FormatString:[NSString stringWithFormat:@"Full Name: %@",[GlobalDirector ReplaceStringNull:[PresentingUser valueForKey:@"FullName"]]] initial:@"Full Name"];
    NSAttributedString *strJobType=[self FormatString:[NSString stringWithFormat:@"Job Type: %@",[GlobalDirector ReplaceStringNull:[dic valueForKey:@"NatureofJob"]]] initial:@"Job Type"];
    
    NSDictionary *dictAddress;
    if(([[[dic valueForKey:@"JobAddrListResponse"] objectAtIndex:0] count]==0)){
        
        dictAddress=[[NSDictionary alloc] init];
        
    }else{
        
        dictAddress=[[dic valueForKey:@"JobAddrListResponse"] objectAtIndex:0];
        
    }
    
    
    NSAttributedString *strAddress=[self FormatString:[NSString stringWithFormat:@"Address: %@",[GlobalDirector ReplaceStringNull:[dictAddress valueForKey:@"Address"]]] initial:@"Address"];
    NSAttributedString *strCity=[self FormatString:[NSString stringWithFormat:@"Town: %@",[GlobalDirector ReplaceStringNull:[dictAddress valueForKey:@"City"]]] initial:@"City"];
    NSAttributedString *strCountry=[self FormatString:[NSString stringWithFormat:@"County: %@",[GlobalDirector ReplaceStringNull:[dictAddress valueForKey:@"County"]]] initial:@"County"];
    NSAttributedString *strPostcode=[self FormatString:[NSString stringWithFormat:@"PostCode: %@",[GlobalDirector ReplaceStringNull:[dictAddress valueForKey:@"PostCode"]]] initial:@"PostCode"];
    
    
    [strJobDetails appendAttributedString:strJobDesc];
    [strJobDetails appendAttributedString:cr];
    [strJobDetails appendAttributedString:strStartDate];
    [strJobDetails appendAttributedString:cr];
    [strJobDetails appendAttributedString:strStartTime];
    [strJobDetails appendAttributedString:cr];
    [strJobDetails appendAttributedString:dateTimeForStatus];
    [strJobDetails appendAttributedString:cr];
    [strJobDetails appendAttributedString:strTitle];
    [strJobDetails appendAttributedString:cr];
    [strJobDetails appendAttributedString:strFullName];
    [strJobDetails appendAttributedString:cr];
    [strJobDetails appendAttributedString:strJobType];
    [strJobDetails appendAttributedString:cr];
//    [strJobDetails appendAttributedString:strAddress];
//    [strJobDetails appendAttributedString:cr];
    [strJobDetails appendAttributedString:strCity];
    [strJobDetails appendAttributedString:cr];
    [strJobDetails appendAttributedString:strCountry];
    [strJobDetails appendAttributedString:cr];
    [strJobDetails appendAttributedString:strPostcode];
    
    UITextView *txtvAgreement = [[UITextView alloc] initWithFrame:CGRectMake(5,58,CGRectGetWidth(bgVw22.frame)-10,CGRectGetHeight(bgVw22.frame)-58)];
    txtvAgreement.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
    txtvAgreement.textColor=[UIColor darkGrayColor];
    [txtvAgreement setBackgroundColor:[UIColor whiteColor]];
    txtvAgreement.editable=NO;
    txtvAgreement.scrollEnabled=YES;
    txtvAgreement.attributedText = strJobDetails;
    
    [txtvAgreement.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [txtvAgreement.layer setBorderWidth: 1.0];
    [txtvAgreement.layer setCornerRadius:0.0f];
    [txtvAgreement.layer setMasksToBounds:YES];
    [bgVw22 addSubview:txtvAgreement];
    
//    NSString *IsAccepted=[NSString stringWithFormat:@"%@",[dic objectForKey:@"IsAccepted"]];
    
    DLog(@"jobdetails :%@",dic);
    DLog(@"IsAccepted :%@",IsAccepted);
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(bgVw22.frame.size.width-2,37,32,32);
    btnClose.center=CGPointMake(CGRectGetMaxX(bgVw22.frame), CGRectGetMinY(bgVw22.frame));
    [btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnClose.titleLabel.font=[UIFont boldSystemFontOfSize:16.0];
    [btnClose setTitle:@"X" forState:UIControlStateNormal];
    [btnClose setBackgroundColor:[UIColor redColor]];
    [btnClose addTarget:self action:@selector(pressDeclineNo22:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnClose.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [btnClose.layer setBorderWidth: 0.0];
    [btnClose.layer setCornerRadius:16.0f];
    [btnClose.layer setMasksToBounds:YES];
    
    [mainBg33 addSubview:bgVw22];
    [mainBg33 addSubview:btnClose];
    
    [UIView animateWithDuration:0.4 animations:^{
        bgVw22.alpha=1.0f;
        [self.view addSubview:mainBg33];
    }];
}

#pragma mark Attributed String Format Method
-(NSAttributedString *)FormatString:(NSString *)string initial:(NSString *)initial
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:string];
    UIFont *font = [UIFont fontWithName:@"TheSansArabic-Bold" size:12.0];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, initial.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, initial.length)];
    return str;
}

#pragma mark LoadMore Method
-(void)LoadMore{
    

    [self fetchJobdetails];
}

#pragma mark - UIbutton Blinking Method
-(void)willStartBlinking:(id)sender
{
    DLog(@"sender :%@",sender);
}

#pragma mark Engineer Job Accept/Decline Swipe Left/Right
-(void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer
{
    //DLog(@"gestureRecognizer.view.tag ::%ld",(long)gestureRecognizer.view.tag);
    selectedIndex=gestureRecognizer.view.tag;
    DLog(@"selectedIndex ::%ld",(long)selectedIndex);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    
    UITableViewCell *cell = [tabvToDoList cellForRowAtIndexPath:indexPath];
    cell.accessoryView=nil;
    
    myView=[[UIView alloc]initWithFrame:CGRectMake(0,0,310,155)];
    myView.backgroundColor=[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    myView.layer.cornerRadius=1.0f;
    myView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    myView.layer.borderWidth=1.0f;
    myView.tag=selectedIndex;
    
    
    //----------------- Agree ------------
    UIButton *btnagree=[UIButton buttonWithType:UIButtonTypeCustom];
    btnagree.frame=CGRectMake(55,10,60,60);
    btnagree.center=CGPointMake(btnagree.center.x, myView.frame.size.height/2.0f);
    btnagree.tag=indexPath.row;
    [btnagree setBackgroundImage:[UIImage imageNamed:@"e-Sigagree"] forState:UIControlStateNormal];
    [btnagree setBackgroundColor:[UIColor clearColor]];
    [btnagree addTarget:self action:@selector(agree:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:btnagree];
    
    UILabel *lblagree;
    lblagree=[[UILabel alloc] initWithFrame:CGRectMake(55,110,60,20)];
    lblagree.textColor=[UIColor colorWithRed:26/255.0 green:137/255.0 blue:44/255.0 alpha:1.0];
    lblagree.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:16.0];
    lblagree.backgroundColor=[UIColor clearColor];
    lblagree.textAlignment=NSTextAlignmentCenter;
    lblagree.text=@"Accept";
    [myView addSubview:lblagree];
    //----------------------------------
    
    //----------------- Refuse ------------
    UIButton *btnRefuse=[UIButton buttonWithType:UIButtonTypeCustom];
    btnRefuse.frame=CGRectMake(185,10,60,60);
    btnRefuse.center=CGPointMake(btnRefuse.center.x, myView.frame.size.height/2.0f);
    btnRefuse.tag=indexPath.row;
    [btnRefuse setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
    [btnRefuse setBackgroundColor:[UIColor clearColor]];
    [btnRefuse addTarget:self action:@selector(refuse:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:btnRefuse];
    
    UILabel *lblrefuse;
    lblrefuse=[[UILabel alloc] initWithFrame:CGRectMake(185,110,60,20)];
    lblrefuse.textColor=[UIColor colorWithRed:227/255.0 green:14/255.0 blue:28/255.0 alpha:1.0];
    lblrefuse.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:16.0];
    lblrefuse.backgroundColor=[UIColor clearColor];
    lblrefuse.textAlignment=NSTextAlignmentCenter;
    lblrefuse.text=@"Decline";
    [myView addSubview:lblrefuse];
    //----------------------------------
    
    UIImageView *imgvArr=[[UIImageView alloc]initWithFrame:CGRectMake(15,CGRectGetHeight(myView.frame)/2-5,10,15)];
    imgvArr.image=[UIImage imageNamed:@"leftDArrow"];
    [myView addSubview:imgvArr];
    
    [cell.contentView addSubview:myView];
    
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setDuration:0.50];
    [animation setTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [myView.layer addAnimation:animation forKey:kCATransition];
    
    gestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector (handleSwipeRight:)];
    [gestureR setDirection:UISwipeGestureRecognizerDirectionRight];
    [myView addGestureRecognizer:gestureR];
}
-(void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer
{
    // DLog(@"gestureRecognizer.view.tag ::%ld",(long)gestureRecognizer.view.tag);
    selectedIndex=gestureRecognizer.view.tag;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    
    UITableViewCell *cell = [tabvToDoList cellForRowAtIndexPath:indexPath];
    cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rightDArrow"]];
    
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionFromRight];
    [animation setSubtype:kCATransitionFromRight];
    [animation setDuration:0.40];
    [animation setTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [myView.layer addAnimation:animation forKey:kCATransition];
    [gestureRecognizer.view removeFromSuperview];
}

#pragma mark Engineer Refuse Method
-(void)refuse:(UIButton *)sender
{
    //UIButton *btn=(UIButton *)sender;
    
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString=[NSString stringWithFormat:@"%sDeclineJobByEngineer?userToken=%@&staffID=%@&jobID=%ld&companyID=0",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[user valueForKey:@"StaffID"],(long)sender.tag];
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
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    DLog(@"%@",data);
    
    connIdentifier=@"connReject";
    /*
     connReject = [[NSURLConnection alloc] initWithRequest:request delegate:self];
     [connReject start];
     */
    NSArray *arrM=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrEditedJobDic"];
    NSMutableArray *mutableCopy=[arrM mutableCopy];
    if (mutableCopy==nil) {
        mutableCopy=[[NSMutableArray alloc]init];
    }
    
    [mutableCopy addObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    [[NSUserDefaults standardUserDefaults]setObject:mutableCopy forKey:@"arrEditedJobDic"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    arrEditedJobDic=mutableCopy;
    
    [tabvToDoList reloadData];
    
    
    connReject = [[NSURLConnection alloc] init];
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _responseData=[data mutableCopy];
            NSMutableDictionary* temp;
            if (_responseData !=nil)
            {
                NSError *error;
                [MBProgressHUD hideAllHUDsForView:Vwtbl animated:YES];
                
                temp = [NSJSONSerialization JSONObjectWithData:_responseData  options:NSJSONReadingMutableContainers error:&error];
                if (!error)
                {
                    if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
                        
                    {
                        [self jobsInvitationPress:_btnJobsInvitation];
                        
                    }
                }
            }
            
        });
        
    }];
    
    [mainBg33 removeFromSuperview];
    
    
}

#pragma mark Engineer Agree Method
-(void)agree:(UIButton *)sender
{
    UIButton *btn=(UIButton *)sender;
    [mainBg33 removeFromSuperview];
    
    DLog(@"selected Row  :%ld",(long)btn.tag);
    [self showPopUpAgreementPage11:(long)btn.tag];
}


#pragma mark - Accept Agreement1 PopUp
-(void)showPopUpAgreementPage11:(long)isSelectedRow
{
    mainBg11 = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    mainBg11.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    
    bgVw11 =[[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width-30,self.view.frame.size.height-80)];
    bgVw11.center=CGPointMake(CGRectGetWidth(mainBg11.frame)/2.0f, CGRectGetHeight(mainBg11.frame)/2.0f);
    [bgVw11.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [bgVw11.layer setBorderWidth: 0.5];
    [bgVw11.layer setCornerRadius:4.0f];
    [bgVw11.layer setMasksToBounds:YES];
    bgVw11.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    
    
    UITextView *txtvAgreement = [[UITextView alloc] initWithFrame:CGRectMake(5,20,CGRectGetWidth(bgVw11.frame)-10,CGRectGetHeight(bgVw11.frame)-50)];
    txtvAgreement.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
    txtvAgreement.textColor=[UIColor darkGrayColor];
    [txtvAgreement setBackgroundColor:[UIColor whiteColor]];
    txtvAgreement.editable=NO;
    MBProgressHUD *hudshow=[MBProgressHUD showHUDAddedTo:txtvAgreement animated:YES];
    hudshow.labelText=@"loading T&C ...";
    
    [self getAgreement:@"AcceptDecline_Agree1" loadingCompleted:^(BOOL completed,NSString *htmlString){
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        txtvAgreement.attributedText = attributedString;
        
        [MBProgressHUD hideAllHUDsForView:txtvAgreement animated:YES];
        
        
        
    }];
    
    
    
    [txtvAgreement.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [txtvAgreement.layer setBorderWidth: 1.0];
    [txtvAgreement.layer setCornerRadius:4.0f];
    [txtvAgreement.layer setMasksToBounds:YES];
    
    UIButton *btnacceptYes11 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnacceptYes11.frame =CGRectMake(CGRectGetWidth(bgVw11.frame)/2.0f,bgVw11.frame.size.height-40,CGRectGetWidth(bgVw11.frame)/2.0f,40);
    [btnacceptYes11 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnacceptYes11.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    btnacceptYes11.tag=isSelectedRow;
    [btnacceptYes11 setTitle:@"Accept" forState:UIControlStateNormal];
    [btnacceptYes11 setBackgroundColor:[UIColor colorWithRed:120/255.0 green:171/255.0 blue:30/255.0 alpha:1.0]];
    [btnacceptYes11 addTarget:self action:@selector(pressAcceptYes11:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btndeclineNo11 = [UIButton buttonWithType:UIButtonTypeCustom];
    btndeclineNo11.frame = CGRectMake(0,bgVw11.frame.size.height-40,CGRectGetWidth(bgVw11.frame)/2.0f,40);
    [btndeclineNo11 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btndeclineNo11.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    btndeclineNo11.tag=11;
    [btndeclineNo11 setTitle:@"Decline" forState:UIControlStateNormal];
    [btndeclineNo11 setBackgroundColor:[UIColor colorWithRed:214/255.0 green:100/255.0 blue:4/255.0 alpha:1.0]];
    [btndeclineNo11 addTarget:self action:@selector(pressDeclineNo11:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [bgVw11 addSubview:txtvAgreement];
    [bgVw11 addSubview:btnacceptYes11];
    [bgVw11 addSubview:btndeclineNo11];
    
    [mainBg11 addSubview:bgVw11];
    [self.view addSubview:mainBg11];
}
-(void)pressAcceptYes11:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    DLog(@"selected Row  :%ld",(long)btn.tag);
    [mainBg11 removeFromSuperview];
    [self showPopUpAgreementPage22:btn.tag];
}
-(void)pressDeclineNo11:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    DLog(@"tag :%ld",(long)btn.tag);
    [self.dataTaskAgr cancel];
    [mainBg11 removeFromSuperview];
}

#pragma mark - Accept Agreement2 PopUp
-(void)showPopUpAgreementPage22:(long)isSelectedRow22
{
    
    mainBg22 = [[UIControl alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    mainBg22.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    
    
    
    
    
    
    bgVw22 = [[UIControl alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width-30,self.view.frame.size.height-80)];
    bgVw22.center=CGPointMake(CGRectGetWidth(mainBg22.frame)/2.0f, CGRectGetHeight(mainBg22.frame)/2.0f);
    [bgVw22.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [bgVw22.layer setBorderWidth: 0.5];
    [bgVw22.layer setCornerRadius:4.0f];
    [bgVw22.layer setMasksToBounds:YES];
    bgVw22.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    
    UITextView *txtvAgreement = [[UITextView alloc] initWithFrame:CGRectMake(5,20,CGRectGetWidth(bgVw22.frame)-10,CGRectGetHeight(bgVw22.frame)-50)];
    txtvAgreement.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
    txtvAgreement.textColor=[UIColor darkGrayColor];
    [txtvAgreement setBackgroundColor:[UIColor whiteColor]];
    txtvAgreement.editable=NO;
    
    MBProgressHUD *hudshow=[MBProgressHUD showHUDAddedTo:txtvAgreement animated:YES];
    hudshow.labelText=@"loading T&C ...";
    
    [self getAgreement:@"AcceptDecline_Agree2" loadingCompleted:^(BOOL completed,NSString *htmlString){
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        txtvAgreement.attributedText = attributedString;
        
        [MBProgressHUD hideAllHUDsForView:txtvAgreement animated:YES];
        
        
        
    }];
    
    [txtvAgreement.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [txtvAgreement.layer setBorderWidth: 1.0];
    [txtvAgreement.layer setCornerRadius:4.0f];
    [txtvAgreement.layer setMasksToBounds:YES];
    
    UIButton *btnacceptYes22 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnacceptYes22.frame =  CGRectMake(CGRectGetWidth(bgVw22.frame)/2.0f,bgVw22.frame.size.height-40,CGRectGetWidth(bgVw22.frame)/2.0f,40);
    [btnacceptYes22 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnacceptYes22.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    btnacceptYes22.tag=isSelectedRow22;
    [btnacceptYes22 setTitle:@"Accept" forState:UIControlStateNormal];
    [btnacceptYes22 setBackgroundColor:[UIColor colorWithRed:120/255.0 green:171/255.0 blue:30/255.0 alpha:1.0]];
    [btnacceptYes22 addTarget:self action:@selector(pressAcceptYes22:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btndeclineNo22 = [UIButton buttonWithType:UIButtonTypeCustom];
    btndeclineNo22.frame =CGRectMake(0,bgVw22.frame.size.height-40,CGRectGetWidth(bgVw22.frame)/2.0f,40);
    [btndeclineNo22 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btndeclineNo22.titleLabel.font=[UIFont boldSystemFontOfSize:14.0];
    btndeclineNo22.tag=22;
    [btndeclineNo22 setTitle:@"Decline" forState:UIControlStateNormal];
    [btndeclineNo22 setBackgroundColor:[UIColor colorWithRed:214/255.0 green:100/255.0 blue:4/255.0 alpha:1.0]];
    [btndeclineNo22 addTarget:self action:@selector(pressDeclineNo22:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [bgVw22 addSubview:txtvAgreement];
    [bgVw22 addSubview:btnacceptYes22];
    [bgVw22 addSubview:btndeclineNo22];
    
    [mainBg22 addSubview:bgVw22];
    [self.view addSubview:mainBg22];
}
-(void)pressAcceptYes22:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    DLog(@"selected Row  :%ld",(long)btn.tag);
    [mainBg22 removeFromSuperview];
    
    
    self.activity.hidden=NO;
    self.lblRefresh.hidden=NO;
    self.btnRefresh.hidden=YES;
    
    NSArray *arrM=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrEditedJobDic"];
    NSMutableArray *mutableCopy=[arrM mutableCopy];
    if (mutableCopy==nil) {
        mutableCopy=[[NSMutableArray alloc]init];
    }
    [mutableCopy addObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
    [[NSUserDefaults standardUserDefaults]setObject:mutableCopy forKey:@"arrEditedJobDic"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    arrEditedJobDic=mutableCopy;
    [self.activity startAnimating];
    
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString=[NSString stringWithFormat:@"%sAcceptJobByEngineer?userToken=%@&staffID=%@&jobID=%ld&companyID=0",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[user valueForKey:@"StaffID"],(long)btn.tag];
    
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
    
    
    [tabvToDoList reloadData];
    connIdentifier=@"connAccept";
    connAccept = [[NSURLConnection alloc]init];
    
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            _responseData=[data mutableCopy];
            NSMutableDictionary* temp;
            if (_responseData !=nil)
            {
                NSError *error;
                [MBProgressHUD hideAllHUDsForView:Vwtbl animated:YES];
                temp = [NSJSONSerialization JSONObjectWithData:_responseData  options:NSJSONReadingMutableContainers error:&error];
                if (!error)
                {
                    if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
                    {
                        [self jobsInvitationPress:_btnJobsInvitation];
                        
                    }
                }
            }
        });
    }];
}

-(void)pressDeclineNo22:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    DLog(@"tag :%ld",(long)btn.tag);
    [self.dataTaskAgr cancel];
    
    [mainBg22 removeFromSuperview];
    [mainBg33 removeFromSuperview];
    
}

#pragma mark Calender View Method

-(void)FetchCalanderJobDates:(NSDate*)date
{
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(NSString *)[user valueForKey:@"UserToken"] forKey:@"userToken"];
    [dict setObject:stringFromDate forKey:@"jobDate"];
    // [dict setObject:@"01/01/2018" forKey:@"jobDate"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [globe SyncRequestGet:REQUEST_GetCalendarDate withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            @try {
                
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                
                arrDates = [result valueForKey:@"ItemList"];
                
                
                
                
            } @catch (NSException *exception) {
                
                if (!arrDates) {
                    arrDates = [[NSArray alloc] init];
                }
                
            }@finally{
                
                if ([arrDates isKindOfClass:[NSArray class]]) {
                    
                    [self UpdateCalenderViewWithJobs:arrDates];
                }
                
                
            }
        });
        
        
        
    }];
    
}



-(void)UpdateCalenderViewWithJobs:(NSArray*)Jobs
{
    
    NSString *dateStr ;
    NSMutableDictionary *EventsDic=[[NSMutableDictionary alloc]init];
    
    //Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    
    for (int i=0;i<[Jobs count] ;i++ )
    {
        [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        // NSDictionary *dic=[Jobs objectAtIndex:i];
        
        //-------as per Start Date Time ----------------------------------------------------------------------------------
        NSString *strStartDate = [GlobalDirector ReplaceStringNull:[Jobs objectAtIndex:i]];
        //strStartDate = [strStartDate substringToIndex:10];
        NSArray* foo = [strStartDate componentsSeparatedByString: @" "];
        strStartDate=[foo objectAtIndex:0];
        NSString *strStartDateTime=[NSString stringWithFormat:@"%@ %@",strStartDate,@"00:00:00"];
        // DLog(@"Started DateTime :%@",strStartDateTime);
        
        //-------as per Created Date Time ----------------------------------------------------------------------------------
        //   dateStr=[dic valueForKey:@"DateJobPost"];
        //  DLog(@"Created DateTime :%@",dateStr);
        
        NSDate *date = [dateFormat dateFromString:strStartDateTime];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
        
        [EventsDic setValue:[NSString stringWithFormat:@"%@",@""] forKey:[NSString stringWithFormat:@"%ld/%ld/%ld",(long)components.day,(long)components.month,(long)components.year]];
        
    }
    
    
    //  NSDictionary *dic=@{@"29/10/2014" : @"Ev1", @"5/10/2014" : @"ev2", @"16/10/2014" : @"Event3",@"16/11/2014" : @"new Event",@"29/4/2015" : @"Ev1"};
    
    DLog(@"%@",EventsDic);
    if (cal==nil) {
        cal=[[DSLCalendarView alloc]initWithDatesWithEvent:EventsDic];
        CGRect calFrame=CGRectMake(0,0,322,300) ;
        cal.delegate=self;
        cal.frame=calFrame;
        cal.center=CGPointMake(CGRectGetWidth(ViewCalendar.frame)/2.0f, CGRectGetHeight(calFrame)/2.0f);
     
        
        [ViewCalendar addSubview:cal];
    }else{
        
        NSDateComponents *visibleMon =  cal.visibleMonth;
        
        [cal removeFromSuperview];
        cal=nil;
        cal=[[DSLCalendarView alloc]initWithDatesWithEvent:EventsDic];
        CGRect calFrame=CGRectMake(0,0,322,300) ;
        cal.delegate=self;
        cal.frame=calFrame;
        cal.center=CGPointMake(CGRectGetWidth(ViewCalendar.frame)/2.0f, CGRectGetHeight(calFrame)/2.0f);
        
        //  [cal setEventsDic:EventsDic];
        [cal setVisibleMonth:visibleMon];
        [ViewCalendar addSubview:cal];
        
    }
    
}
#pragma mark Calender Button Press Method

-(IBAction)listandCalenderPress:(id)sender
{
    if (btnListandCalender.tag==0)
    {
        
        
        // [btnListandCalender setTitle:@"To Do" forState:UIControlStateNormal];
        _imgVtoggleCalTodo.image=[UIImage imageNamed:@"todolist"];
        
        btnListandCalender.tag=1;
        viewToDoList.hidden=YES;
        ViewCalendar.hidden=NO;
        self.btnRefresh.hidden=YES;
        [self FetchCalanderJobDates:[NSDate date]];
    }
    else if (btnListandCalender.tag==1)
    {
        
        
        //[btnListandCalender setTitle:@"Calender" forState:UIControlStateNormal];
        _imgVtoggleCalTodo.image=[UIImage imageNamed:@"calendar"];
        btnListandCalender.tag=0;
        viewToDoList.hidden=NO;
        ViewCalendar.hidden=YES;
        self.btnRefresh.hidden=NO;
    }
    
}


-(IBAction)onlineOfflineSwitchAction:(UISwitch*)sender
{
    if (sender.isOn)
    {
        [self showAlert:@"You are ready to accept jobs." withTitle:@"Online"];
    }
    else
    {
        [self showAlert:@"You are not available to accept jobs." withTitle:@"Offline"];
    }
    
}

#pragma mark - PopUp Touch Method
-(IBAction)removeBgAndPopUp:(id)sender
{
    [bgView removeFromSuperview];
    bgView=nil;
}
-(void)PopUptableViewListingJobs
{
    
    bgView=[[UIControl alloc]initWithFrame:self.view.frame];
    bgView.backgroundColor=[UIColor colorWithWhite:0.1f alpha:1.0f];
    //[bgView addTarget:self action:@selector(removeBgAndPopUp:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITableView *jobs=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.view.frame)-2,self.view.frame.size.height-80)];
    jobs.center=CGPointMake(bgView.frame.size.width/2.0f, bgView.frame.size.height/2.0f);
    jobs.layer.cornerRadius=5.0f;
    jobs.layer.borderColor=[[UIColor blackColor]CGColor];
    jobs.layer.borderWidth=2.0f;
    jobs.tag=111;
    jobs.separatorColor=[UIColor clearColor];
    jobs.backgroundColor=[UIColor colorWithWhite:0.8f alpha:1.0f];
    jobs.delegate=self;
    jobs.dataSource=self;
    
    UIButton *btncross=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    //    btncross.center=CGPointMake(CGRectGetMaxX(jobs.frame)-10, CGRectGetMinY(jobs.frame)+3);
    btncross.center=CGPointMake(bgView.center.x, CGRectGetMaxY(jobs.frame)+19);
    
    btncross.backgroundColor=[UIColor clearColor];
    [btncross setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
    [btncross clipsToBounds];
    
    [btncross addTarget:self action:@selector(bgPopupTouched:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:jobs];
    [bgView addSubview:btncross];
    
    bgView.alpha=0.0f;
    [UIView animateWithDuration:0.2 animations:^{
        bgView.alpha=1.0f;
        [self.view addSubview:bgView];
        
    }];
    DLog(@"%@",JobsOnDate);
    
}
-(IBAction)bgPopupTouched:(id)sender
{
    
    for (UIView *vw in [bgView subviews])
    {
        [vw removeFromSuperview];
    }
    [bgView removeFromSuperview];
}

-(void)fetchDayWiseJobs:(NSString*)date
{
    
    
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(NSString *)[user valueForKey:@"UserToken"] forKey:@"userToken"];
    [dict setObject:date forKey:@"jobDate"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [globe SyncRequestGet:REQUEST_GetCalendarJob withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            @try {
                
                JobsOnDate=[[NSMutableArray alloc]init];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [JobsOnDate addObjectsFromArray:[result valueForKey:@"JobListResponse"]];
                
            } @catch (NSException *exception) {
                
                if (!JobsOnDate) {
                    JobsOnDate = [[NSMutableArray alloc] init];
                }
                
            }
            @finally{
                
                
                if ([JobsOnDate isKindOfClass:[NSMutableArray class]]) {
                    [self PopUptableViewListingJobs];
                }
            }
        });
    }];
    
}


#pragma mark - DSLCalendarView Delegate and Datasource Method
- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range
{
    
    if (range != nil)
    {
        
        NSArray *allKey = [calendarView.EventsDic allKeys];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        
        bool isEvent = NO;
        
        for (NSString *strDate in allKey) {
            NSDate *date = [dateFormat dateFromString:strDate];
            if ([range.startDay.date compare:date] == NSOrderedSame) {
                isEvent = YES;
            }
        }
        
        if (isEvent) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM/dd/yyyy"];
            
            [self fetchDayWiseJobs:[dateFormat stringFromDate:range.startDay.date]];
        }
    }
    
}
- (DSLCalendarRange*)calendarView:(DSLCalendarView *)calendarView didDragToDay:(NSDateComponents *)day selectingRange:(DSLCalendarRange *)range
{
    
    
    if (NO)
    { // Only select a single day
        return [[DSLCalendarRange alloc] initWithStartDay:day endDay:day];
    }
    else if (/* DISABLES CODE */ (NO))
    { // Don't allow selections before today
        NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:calendarView.visibleMonth.calendar];
        
        NSDateComponents *startDate = range.startDay;
        NSDateComponents *endDate = range.endDay;
        
        if ([self day:startDate isBeforeDay:today] && [self day:endDate isBeforeDay:today]) {
            return nil;
        }
        else {
            if ([self day:startDate isBeforeDay:today]) {
                startDate = [today copy];
            }
            if ([self day:endDate isBeforeDay:today]) {
                endDate = [today copy];
            }
            
            return [[DSLCalendarRange alloc] initWithStartDay:startDate endDay:endDate];
        }
    }
    
    return range;
}
- (void)calendarView:(DSLCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents *)month duration:(NSTimeInterval)duration
{
    
    // [self FetchCalanderJobDates:month.date];
    DLog(@"Will show %@ in %.3f seconds", month, duration);
    
}

-(void)NewVisibleMonthWillCome:(NSDateComponents *)month
{
    
    
    [self FetchCalanderJobDates:month.date];
}
- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents *)month
{
    
    DLog(@"Now showing %@", month);
    
}
- (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2
{
    
    return ([day1.date compare:day2.date] == NSOrderedAscending);
}

-(NSDictionary *)EventsForCalendarMonth
{
    
    
    NSDictionary *dic=@{@"29/10/2014" : @"Ev1", @"5/10/2014" : @"ev2", @"16/10/2014" : @"Event3"};
    return dic;
}


#pragma mark - New Invitation Press Method
- (IBAction)btnNewInvitationTapped:(UIButton *)sender
{
    _btnNewInvitation.selected=YES;
    _btnAcceptedInvitation.selected=NO;
    lblNoJobs.hidden=YES;
    btnActiveCategory=_btnNewInvitation;
    NSPredicate *predicate;
    NSNumber *valueA=[NSNumber numberWithInt:1];
    NSNumber *valueB=[NSNumber numberWithInt:2];
    NSMutableArray *arr=[[NSMutableArray alloc] initWithObjects:valueA,valueB, nil];
    NSLog(@"arr :%@",arr);
    
    predicate = [NSPredicate predicateWithFormat:@"JobStatus == 1 AND IsAccepted = 0 "];
    //predicate=[NSPredicate predicateWithFormat:@"(IsAccepted==%@)AND(ANY JobStatus IN %@)",@"0",arr];
    
    DLog(@"pree :%@",predicate);
    NSArray *newArray = [arrMInvitations filteredArrayUsingPredicate:predicate];
    if (refreshedList==YES) {
        refreshedList=NO;
        [sender setTitle:[NSString stringWithFormat:@"New Invitations(%ld)",(unsigned long)[newArray count]] forState:UIControlStateNormal];
        [_btnAcceptedInvitation setTitle:[NSString stringWithFormat:@"Accepted Invitations(%lu)",arrMFilterJobsList.count-[newArray count]] forState:UIControlStateNormal];
    }
    
    
    DLog(@"%lu", (unsigned long)[newArray count]);
    // DLog(@"%@", newArray);
    arrMFilterJobsList=[newArray mutableCopy];
    if (arrMFilterJobsList.count==0)
    {
        lblNoJobs.text=@"No new Invitations";
        lblNoJobs.hidden=NO;
    }
    [tabvToDoList reloadData];
    [self hideSubSelectionView:_viewSubTabAssignment];
    [self animateSubSelectionViewForButton:sender forView:_vwSubInvitations];
}

#pragma mark - Accept Invitation Press Method
- (IBAction)btnAcceptedInvitationTapped:(UIButton *)sender
{
    _btnNewInvitation.selected=NO;
    _btnAcceptedInvitation.selected=YES;
    lblNoJobs.hidden=YES;
    btnActiveCategory=_btnAcceptedInvitation;
    NSPredicate *predicate;
    NSNumber *valueA=[NSNumber numberWithInt:1];
    NSNumber *valueB=[NSNumber numberWithInt:2];
    NSMutableArray *arr=[[NSMutableArray alloc] initWithObjects:valueA,valueB, nil];
    NSLog(@"arr :%@",arr);
    
    predicate = [NSPredicate predicateWithFormat:@"JobStatus == 1 AND IsAccepted = 1 "];
    //predicate=[NSPredicate predicateWithFormat:@"(IsAccepted==%@)AND(ANY JobStatus IN %@)",@"0",arr];
    
    DLog(@"pree :%@",predicate);
    NSArray *newArray = [arrMInvitations filteredArrayUsingPredicate:predicate];
    
    DLog(@"%lu", (unsigned long)[newArray count]);
    // DLog(@"%@", newArray);
    arrMFilterJobsList=[newArray mutableCopy];
    //arrCFilterJoblist=arrMFilterJobsList;
    if (arrMFilterJobsList.count==0)
    {
        lblNoJobs.text=@"No Accepted jobs";
        lblNoJobs.hidden=NO;
    }
    [tabvToDoList reloadData];
    [self animateSubSelectionViewForButton:sender forView:_vwSubInvitations];
    [self animateToActiveButton:sender withImageview:_selected];
}

#pragma mark- PostcodeDelegate
-(void)PostCodeAddressSelection:(NSMutableDictionary*)dict{

    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (dict) {
        @try {
            
            NSLog(@"Address dict : %@",dict);
            NSString * addressValue = @"";
            if(![[GlobalDirector ReplaceStringNull:[dict valueForKey:@"address"]]  isEqual: @""]){
                addressValue =  [GlobalDirector ReplaceStringNull:[dict valueForKey:@"address"]];
            }
            if(![[GlobalDirector ReplaceStringNull:[dict valueForKey:@"postcode"]]  isEqual: @""]){
                addressValue =  [NSString stringWithFormat:@"%@, %@", addressValue,[GlobalDirector ReplaceStringNull:[dict valueForKey:@"postcode"]]];
            }
            if(![[GlobalDirector ReplaceStringNull:[dict valueForKey:@"county"]]  isEqual: @""]){
                addressValue =  [NSString stringWithFormat:@"%@, %@", addressValue,[GlobalDirector ReplaceStringNull:[dict valueForKey:@"county"]]];
            }
            
            [self setEngAvailabilityDetails:@"1" addressValue:addressValue];


        } @catch (NSException *exception) {
            ;
        }
    }
}


#pragma mark - Refresh Press Method
- (IBAction)btnRefreshTapped:(id)sender
{
    [super viewWillAppear:YES];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        if (isNxtJobAvailable == YES)
        {
        
            page=page+1;
            conn=nil;
            [self fetchJobdetails];

    }
    }
        
        else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
          {
              
    page=0;
    loadBookedPageCount=0;
    loadActivePageCount=0;
    loadCompletePageCount=0;
 
   
  
    if(_btnBooked.isSelected==YES)
    {
        BookedPage=0;
    refreshPagecount=0;
    loadActivePageCount2=0;
//    refreshCompletePagecount=1;
//    refreshActivePagecount=1;
    
    }
    if(_btnActive.isSelected==YES)
    {
        ActivePage=0;
        refreshActivePagecount=0;
        
//        refreshPagecount=1;
//        refreshCompletePagecount=1;
    }
    if(_btnComplete.isSelected==YES)
    {
        CompletePage=0;
        refreshCompletePagecount=0;
        loadActivePageCount2=0;
        
//        refreshActivePagecount=1;
//        refreshPagecount=1;
    }
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"arrEditedJobDic"]) {
        NSArray *arr=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrEditedJobDic"];
        arrEditedJobDic=[[NSMutableArray alloc]initWithArray:arr];
        //arrEditedJobDic=[arr mutableCopy];
    }
    
    
    [tabvToDoList reloadData];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
    {
        [self fetchJobdetails];
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        [self fetchJobdetails];
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        
        
        
        if (_btnJobsInvitation.selected==YES)
        {
            [self jobsInvitationPress:_btnJobsInvitation];
        }
        else if (_btnAssignedJobs.selected==YES)
        {
            [self assignedJobsPress:_btnAssignedJobs];
        }
        
        
    }
          
          }
    
}
// new implemention
- (IBAction)btnLoadMore:(id)sender
{
    
    
    
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        
        
        if (isNxtJobAvailable == YES)
        {
        
            page=page+1;
            conn=nil;
            [self fetchJobdetails];

    }
        
    }
    
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
      {
           
    
    if (isNxtJobAvailable == YES)
    {
        
        if (_btnBooked.isSelected==YES)
        {
            
            if(page==0)
            {
            page=page+1;
            }
            if(arrMBookedJobDetails.count>arrMBookedFilterJobsList.count)
            {
                arrMBookedJobDetails=NULL;
            
            }
            

            if(arrMCompleteJobDetails.count==0&&arrMActiveJobDetails.count==0)
            {
                arrMBookedJobDetails=NULL;
            }
            if (refreshBookedPagecount2==1)
            {

                arrMBookedJobDetails=NULL;
            }
            [arrMJobDetails addObjectsFromArray:arrMBookedJobDetails];
            
        
           loadBookedPageCount=0;

          
            conn=nil;
            BookedPage=BookedPage+1;
            loadBookedPageCount = loadBookedPageCount+1;

            [self fetchJobdetails];
      
            
        }
        if (_btnActive.isSelected==YES)
        {
            if(page==0)
            {
                
            page=page+1;
            }
            
            if(arrMActiveJobDetails.count>arrMActiveFilterJobsList.count)
            {
                arrMActiveJobDetails=NULL;
            }
            if(arrMCompleteJobDetails.count==0)
            {
                arrMActiveJobDetails=NULL;
            }
            
            if (ActivePage>2)
            {

            if(arrMActiveJobDetails.count<9)
            {
                arrMActiveJobDetails=NULL;
            }
            }

            if(refreshActiveloadmorePagecount==1)
            {
                arrMActiveJobDetails=NULL;
            }
            
            [arrMJobDetails addObjectsFromArray:arrMActiveJobDetails];
    
      
            ActivePage=ActivePage+1;
            
            loadActivePageCount=0;
             conn=nil;
            
            loadActivePageCount = loadActivePageCount+1;
            loadActivePageCount2=1;

         
            [self fetchJobdetails];

         
            
        }
        
        if (_btnComplete.isSelected==YES)
        {
            
            if(page==0)
            {
            page=page+1;
            }
      
            if(arrMCompleteJobDetails.count>arrMCompleteFilterJobsList.count)
            {
                arrMCompleteJobDetails=NULL;
            }
            
          if(CompletePage==0&&refreshBookedPagecount!=1)
          {
              arrMCompleteJobDetails=NULL;
              
          }
            if (refreshCompleteloadmorePagecount==1)
            {
                arrMCompleteJobDetails=NULL;
//                refreshBookedPagecount=2;
            }
              
              
            
            [arrMJobDetails addObjectsFromArray:arrMCompleteJobDetails];
            loadCompletePageCount=0;
            CompletePage=CompletePage+1;
            conn=nil;
            loadCompletePageCount = loadCompletePageCount+1;
           
            [self fetchJobdetails];

            
        }
        

    }
          
      }
    else
    {
        
    }
    
}
// working with HelpWidget button
- (IBAction)HelpWidget:(id)sender
{

    HelpWidgetVC *createJob = [[HelpWidgetVC alloc] initWithNibName: @"HelpWidgetVC" bundle: nil];
    [self.navigationController pushViewController:createJob animated:YES];

  
    
}


@end
