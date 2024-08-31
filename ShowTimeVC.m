//
//  ShowTimeVC.m
//  PM247
//
//  Created by Nitin Raj on 06/05/23.
//  Copyright © 2023 SANDIPAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShowTimeVC.h"
#import "GlobalDirector.h"
#import "ShowTimerTableViewCell.h"
#import "ShowActivityTypeCell.h"

AppDelegate *app;
@interface ShowTimeVC ()
{
    GlobalDirector *globe;
    NSArray *arrActivityValues;
    NSDate *stopTimeDate;
    NSString *selectedActivityType;

}
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSArray *arrTimerValues;


@end

@implementation ShowTimeVC

int timerValue;

- (void)viewDidLoad
{
    [super viewDidLoad];
    timerValue = 0;
    
    arrActivityValues = [[NSArray alloc] init];
    arrActivityValues = @[@"choice", @"Travelling to job", @"Investigation", @"Waiting payment &amp", @"Contracts", @"Fixed Price work", @"completed work wating"];

    NSInteger savedTimer = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"JOB_ID_%@", _jobID]];
    
    timerValue = (int)(savedTimer);
    
    NSString *isPausedDefaultKey = [NSString stringWithFormat:@"JOB_ID_IS_PAUSED_%@", _jobID];
    NSString *defaultKey = [NSString stringWithFormat:@"JOB_ID_BG_DATE_%@", _jobID];
    NSInteger timestamp = [[NSUserDefaults standardUserDefaults] integerForKey:defaultKey];
    if (timestamp != 0) {
        NSInteger diff = [[NSDate date] timeIntervalSince1970] - timestamp;
        NSLog(@"%ld VIKK", (long)diff);
        timerValue += diff;
        
        BOOL isPaused = [[NSUserDefaults standardUserDefaults] boolForKey: isPausedDefaultKey];
        if (!isPaused) {
            [_btnPlayPause setSelected:YES];
            [self startTimer];
        }
    }

    [self formatValues];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:defaultKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:isPausedDefaultKey];
    
    [_tblView registerNib:[UINib nibWithNibName:@"ShowTimerTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShowTimerTableViewCell"];
    
    [_tblViewActionType registerNib:[UINib nibWithNibName:@"ShowActivityTypeCell" bundle:nil] forCellReuseIdentifier:@"ShowActivityTypeCell"];

    [self getEngineerTimer];
    [ self.viewMainActionType setHidden:true];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
           selector:@selector(willEnterForeground:)
           name:UIApplicationWillEnterForegroundNotification
           object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
           selector:@selector(didEnterBackground:)
           name:UIApplicationDidEnterBackgroundNotification
           object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_timer invalidate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) willEnterForeground:(NSNotification *)notification
{
    if (![_btnPlayPause isSelected]) {
        return;
    }
    NSLog(@"willEnterForeground");
    NSString *defaultKey = [NSString stringWithFormat:@"JOB_ID_BG_DATE_%@", _jobID];
    NSInteger timestamp = [[NSUserDefaults standardUserDefaults] integerForKey:defaultKey];
    
    NSInteger diff = [[NSDate date] timeIntervalSince1970] - timestamp;
    NSLog(@"%ld VIKK", (long)diff);
    
    timerValue += diff;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:defaultKey];
    [self startTimer];
}

- (void)didEnterBackground:(NSNotification *)notification
{
    if (![_btnPlayPause isSelected]) {
        return;
    }
    [_timer invalidate];
    NSLog(@"didEnterBackground");
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *defaultKey = [NSString stringWithFormat:@"JOB_ID_BG_DATE_%@", _jobID];
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:timestamp] forKey:defaultKey];
}

- (void)backPress:(id)sender
{
    if ([_btnPlayPause isSelected]) {
        NSLog(@"Back pressed");
        int timestamp = [[NSDate date] timeIntervalSince1970];
        NSString *defaultKey = [NSString stringWithFormat:@"JOB_ID_BG_DATE_%@", _jobID];
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:timestamp] forKey:defaultKey];
    }
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)playPausePress:(UIButton*)sender
{
    [sender setSelected:![sender isSelected]];
    
    NSString *defaultKey = [NSString stringWithFormat:@"JOB_ID_IS_PAUSED_%@", _jobID];
    [[NSUserDefaults standardUserDefaults] setBool:![sender isSelected] forKey:defaultKey];
    
    if ([sender isSelected]) {
        [self startTimer];
        
        NSString *startJobKey = [NSString stringWithFormat:@"JOB_ID_START_%@", _jobID];
        double savedTimeStamp = [[NSUserDefaults standardUserDefaults] doubleForKey:startJobKey];
        if (savedTimeStamp == 0) {
            double timeStamp = [[NSDate date] timeIntervalSince1970];
            [[NSUserDefaults standardUserDefaults] setDouble:timeStamp forKey:startJobKey];
        }
    } else {
        [_timer invalidate];
    }
}

- (void)stopPress:(id)sender
{
    [_btnPlayPause setSelected:NO];
    [_timer invalidate];
    if (timerValue == 0) {
        return;
    }
    selectedActivityType = @"";
    stopTimeDate = [NSDate date];
    self->_tblViewActionType.delegate = self;
    self->_tblViewActionType.dataSource = self;

    [self->_tblViewActionType reloadData];

    [ self.viewMainActionType setHidden:false];

    
}

-(void)startTimer
{
    _timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)updateTimer:(NSTimer*)timer
{
    NSLog(@"Tick...");
    timerValue += 1;
 
    [self formatValues];
}

-(void)formatValues
{
    _lblTimer.text = [self getFormattedTime];
    
    [[NSUserDefaults standardUserDefaults] setInteger:timerValue forKey:[NSString stringWithFormat:@"JOB_ID_%@", _jobID]];
}

-(void)showNotePopup{
    
    AddNotes *notes=[[AddNotes alloc]initWithNibName:@"AddNotes" bundle:nil];
            
        
   // notes.Notes=arrNotes;
    notes.jobID=[NSString stringWithFormat:@"%@",_jobID];
    notes.strFromCustomerClass=[NSString stringWithFormat:@"%@",[self class]];
    notes.modalPresentationStyle = UIModalPresentationCustom;

    [self presentViewController:notes animated:YES completion:nil];
}

-(NSString *)getFormattedTime
{
    NSUInteger h = timerValue / 3600;
    NSUInteger m = (timerValue / 60) % 60;
    NSUInteger s = timerValue % 60;

    NSString *formattedTime = [NSString stringWithFormat:@"%02u:%02u:%02u", h, m, s];
    return formattedTime;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == _tblView){
        return [_arrTimerValues count];
    }
    else if(tableView == _tblViewActionType){
        return [arrActivityValues count];
    }
    return 0;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _tblView){
        NSDictionary *data = _arrTimerValues[indexPath.section];
        if(data[@"ActivityBy"] == nil || [data[@"ActivityBy"]  isEqual: @""]){
            return 70;
        }
        else{
            return 120;
        }
    }
    else{
        return 40;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ;
    if(tableView == _tblView){
        ShowTimerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowTimerTableViewCell" forIndexPath:indexPath];

        NSDictionary *data = _arrTimerValues[indexPath.section];
        NSString *totalTime = [data valueForKey:@"TotalTime"];
        cell.lblTimer.text = totalTime;
        
        NSString *startTime = [data valueForKey:@"StartTimer"];
        NSString *endTime = [data valueForKey:@"EndTimer"];
        
        cell.lblStartTimer.text = startTime;
        cell.lblEndTimer.text = endTime;
        
        if(data[@"ActivityBy"] == nil || [data[@"ActivityBy"]  isEqual: @""]){
            [cell.lblName setHidden:true];
            [cell.lblActionType setHidden:true];
        }
        else{
            [cell.lblName setHidden:false];
            [cell.lblActionType setHidden:false];
            cell.lblName.text = [NSString stringWithFormat:@"Activity By - %@",data[@"ActivityBy"]];
            cell.lblActionType.text = [NSString stringWithFormat:@"Activity Type - %@",data[@"ActionType"]];

        }
        return cell;
    }
    else {

        ShowActivityTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowActivityTypeCell" forIndexPath:indexPath];
        NSString *value = arrActivityValues[indexPath.section];
        NSLog(@"%@", value);

        cell.lblActionType.text = value;
        return cell;

    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _tblViewActionType){
        selectedActivityType = arrActivityValues[indexPath.section];

    }
}

-(void)SetEngineerTimer:(int)totalTime endDate:(NSDate *)endDate
{
    MBProgressHUD   *hudd=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudd.labelText=@"Please wait...";
    [hudd show:YES];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSDictionary *userdetails = [[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    
    NSString *engineerID = (NSString *)[userdetails valueForKey:@"StaffID"];
    
    [dict setObject:_jobID forKey:@"JobId"];
    [dict setObject:engineerID forKey:@"EngineerId"];
    
    NSString *startJobKey = [NSString stringWithFormat:@"JOB_ID_START_%@", _jobID];
    double savedTimeStamp = [[NSUserDefaults standardUserDefaults] doubleForKey:startJobKey];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:savedTimeStamp];
    
    NSDateFormatter * formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *startDateString = [formatter stringFromDate:startDate];
    
    NSString *endDateString = [formatter stringFromDate:endDate];
    
    [dict setObject:startDateString forKey:@"StartTimer"];
    [dict setObject:endDateString forKey:@"EndTimer"];
    
//    selectedActivityType = [selectedActivityType stringByReplacingOccurrencesOfString:@" " withString:@""];
    [dict setObject:selectedActivityType forKey:@"ActionType"];

    
    long h = (totalTime / 3600);
    long m = (totalTime / 60) % 60;
    long s = totalTime % 60;
    NSString *formattedTotalTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", h, m, s];
    [dict setObject:formattedTotalTime forKey:@"TotalTime"];
    
    NSLog(@"%@", dict);
    
    GlobalDirector *globe= [GlobalDirector SharedDirector];
    [globe SyncRequestGet:REQUEST_SetEngineerTimer withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        NSLog(@"%@",result);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [hudd hide:YES];
            
            @try{
                
                if (result != nil) {
                    self->_lblTimer.text = @"00:00:00";
                    timerValue = 0;
                    
                    NSString *defaultKey = [NSString stringWithFormat:@"JOB_ID_BG_DATE_%@", self->_jobID];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:defaultKey];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:startJobKey];
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"JOB_ID_%@", self->_jobID]];
                }
                
                [self getEngineerTimer];
            } @catch (NSException *exception) {
                [self showAlert:@"There are some problem right now, try again later. " withTitle:@"Sorry!"];
            }
        });
        
    }];
}

-(void)getEngineerTimer
{
    MBProgressHUD   *hudd=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudd.labelText=@"Please wait...";
    [hudd show:YES];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSDictionary *userdetails = [[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    
    NSString *engineerID = (NSString *)[userdetails valueForKey:@"StaffID"];
    
    [dict setObject:_jobID forKey:@"JobId"];
    [dict setObject:engineerID forKey:@"EngineerId"];
    
    GlobalDirector *globe= [GlobalDirector SharedDirector];
    [globe SyncRequestGet:REQUEST_GetEngineerTimer withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        NSLog(@"%@",result);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [hudd hide:YES];
            
            @try{
                
                NSArray *arrData = [result valueForKey:@"EngineerTimerDetailResponseListResponse"];
                if (arrData != nil) {
                    self->_arrTimerValues = arrData;
                }
                [self->_tblView reloadData];
            } @catch (NSException *exception) {
                [self showAlert:@"There are some problem right now, try again later. " withTitle:@"Sorry!"];
            }
        });
        
    }];
}

- (IBAction)actionCancelPress:(id)sender {
    [ self.viewMainActionType setHidden:true];

}

- (IBAction)actionTypePress:(id)sender {
    if([selectedActivityType  isEqual: @""]){
        [self showAlert:@"Please select Action type in the list.."  withTitle:@"Action Type"];

    }
    else{
        [ self.viewMainActionType setHidden:true];
        [self SetEngineerTimer:timerValue endDate:stopTimeDate];

    }

}

@end

#pragma mark- JobactivationbyEngineer Method
