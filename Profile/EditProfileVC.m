//
//  EditProfileVC.m
//  PM247
//
//  Created by Vikram on 01/07/23.
//  Copyright © 2023 SANDIPAN. All rights reserved.
//

#import "EditProfileVC.h"
#import "GlobalDirector.h"

@interface EditProfileVC ()

@end

@implementation EditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
    
    NSDictionary *userdetails = [[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *name = [userdetails valueForKey:@"UserName"];
    _lblName.text = name;
    
    [self GetEngineerProfileDtl];
}

-(IBAction)btnSaveClicked:(id)sender {
    
}

- (void)GetEngineerProfileDtl
{
    MBProgressHUD   *hudd=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudd.labelText=@"Loading...";
    [hudd show:YES];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserID"]] forKey:@"EngineerId"];
    
    GlobalDirector *globe= [GlobalDirector SharedDirector];
    [globe SyncRequestGet:REQUEST_GetEngineerProfileDtl withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        NSLog(@"%@",result);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [hudd hide:YES];
            @try{
                
                
            } @catch (NSException *exception) {
                [self showAlert:@"There are some problem right now, try again later. " withTitle:@"Sorry!"];
            }
        });
        
    }];
}

@end
