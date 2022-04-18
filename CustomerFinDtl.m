//
//  CustomerFinDtl.m
//  Partner Maintenance
//


#import "CustomerFinDtl.h"
#import "PaymentDtlsVC.h"

@interface CustomerFinDtl ()

@end

@implementation CustomerFinDtl
@synthesize jobDic;

#pragma mark - viewDidLoad Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    // Do any additional setup after loading the view from its nib.
    [self FetchFinDtls];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Back Press Method
-(IBAction)backPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)PaymentsDetailsClick:(id)sender {
    PaymentDtlsVC *vc = [[PaymentDtlsVC alloc] initWithNibName:@"PaymentDtlsVC" bundle:nil];
    vc.dictJob=jobDic;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - Financial Details Method
-(void)FetchFinDtls
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    [dict setObject:[GlobalDirector ReplaceStringNull:[jobDic valueForKey:@"JobID"]] forKey:@"jobId"];
    
    GlobalDirector *globe= [GlobalDirector SharedDirector];
    [globe SyncRequestGet:REQUEST_GetFinancialDetail withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        NSLog(@"%@",result);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            @try {
                [hud hide:YES];
                
                _txtFinNote.text= [NSString stringWithFormat:@"%.2f",[[GlobalDirector ReplaceStringNull:[[result valueForKey:@"FinancialDetail"] valueForKey:@"Note"]] floatValue]];
                _txtSubTotal.text =  [NSString stringWithFormat:@"%.2f",[[GlobalDirector ReplaceStringNull:[[result valueForKey:@"FinancialDetail"] valueForKey:@"JobSubTotal"]] floatValue]];
                
                _txtJobVat.text =  [NSString stringWithFormat:@"%.2f",[[GlobalDirector ReplaceStringNull:[[result valueForKey:@"FinancialDetail"] valueForKey:@"JobVat"]] floatValue]];
                _txtJobTotal.text = [NSString stringWithFormat:@"%.2f",[[GlobalDirector ReplaceStringNull:[[result valueForKey:@"FinancialDetail"] valueForKey:@"JobTotal"]] floatValue]];
                float paymentDue =  [[GlobalDirector ReplaceStringNull:[result valueForKey:@"OutstandingAmount"]] floatValue];
                _txtAmount.text=[NSString stringWithFormat:@"%.2f",paymentDue];
            } @catch (NSException *exception)
            {
                // _txtPost.text=@"";
                [self showAlert:@"There are some problem right now, try again later. " withTitle:@"Sorry!"];
            }
        });
    }];
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading Financial Details...";
    [hud show:YES];
}

#pragma mark - Outstanding Amount Details Method
-(void)AmountOutstanding
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    [dict setObject:[GlobalDirector ReplaceStringNull:[jobDic valueForKey:@"JobID"]] forKey:@"jobId"];
    
    GlobalDirector *globe= [GlobalDirector SharedDirector];
    [globe SyncRequestGet:REQUEST_GetJobPayments withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        NSLog(@"%@",result);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            @try{
                
                int jobtotal = [ _txtJobTotal.text intValue];
                int paymentDue =  [[GlobalDirector ReplaceStringNull:[result valueForKey:@"TotalPaymentDue"]] intValue];
                
                NSLog(@"jobtotal :%d",jobtotal);
                NSLog(@"jobtotal :%d",paymentDue);
                //int outstanding = jobtotal-paymentDue;
                
                _txtAmount.text=[NSString stringWithFormat:@"%d",paymentDue];
                [hud hide:YES];
                
            } @catch (NSException *exception) {
                [self showAlert:@"There are some problem right now, try again later. " withTitle:@"Sorry!"];
            }
        });
        
    }];
}



@end
