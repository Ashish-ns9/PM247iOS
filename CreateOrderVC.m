//
//  CreateOrderVC.m
//  PM247
//
//  Created by Vikram on 11/11/22.
//  Copyright © 2022 SANDIPAN. All rights reserved.
//

#import "CreateOrderVC.h"
#import "GlobalDirector.h"
#import "CreateInvoiceVC.h"

@interface CreateOrderVC ()
@property (weak, nonatomic) IBOutlet UITextField *txtBalance;
@property (weak, nonatomic) IBOutlet UITextView *txtDesc;

@end

@implementation CreateOrderVC
@synthesize dictJob;
@synthesize customerID;

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *jobdesc = [dictJob valueForKey:@"JobDescription"];
    NSString *jobTotal = [NSString stringWithFormat:@"%.02f",[[GlobalDirector ReplaceStringNull:[dictJob valueForKey:@"JobTotal"]] floatValue]];
    
   // _txtDesc.text = jobdesc;
    _txtDesc.text = @"Carrying out Services of Plumbing Heating & Drainage work, with regards to the quotation and verbal price communicated with you over the phone, by email and sms.";
    [_txtDesc setEditable:NO];
    _txtBalance.text = _amount;
    float dueAmount = [_dueAmount floatValue];
    
    float remaining = dueAmount - [_amount floatValue] ;
    _txtBalance.text = [NSString stringWithFormat:@"%.02f",remaining];

    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)dismissKeyboard:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

- (IBAction)btnCloseAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)btnCreateOrderAction:(id)sender {
    
//    if (_txtBalance.text.length==0){
//        [self showAlert:@"Please fill up Outstanding Balance." withTitle:@"Error"];
//    }else
        
    if ([_txtBalance.text floatValue] < 0) {
        [GlobalDirector showAleart:@"Outstanding amount can't be less then 0." ctrl:self];
    }else {
        [self createOrderAPI];
    }
}

#pragma mark - createOrderAPI Method

-(void)createOrderAPI
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        DLog(@"There IS NO internet connection");
        [self showAlert:@"Check your Internet connection" withTitle:@"Connection Error!"];
    } else {
        
        [self.dataTask cancel];
        
        DLog(@"There IS internet connection");
        
        
        NSString *urlString;
        
        urlString=[NSString stringWithFormat:@"%s%@",squareUpBaseURL, @"orders"];
        
        NSString *authToken = [NSString stringWithFormat:@"Bearer %s", squareUpAccessToken];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:authToken forHTTPHeaderField:@"Authorization"];
        [request setValue:@"2022-10-19" forHTTPHeaderField:@"Square-Version"];
                
        double dec2 = ([_amount floatValue]);
        double SquareUpCal = dec2 * 100;
        double ClientCal = SquareUpCal / 1.20;
        double WholeNumber = ClientCal / 100;
        double RoundTwoNumber = WholeNumber;
        int LastNumber = ((int)(RoundTwoNumber * 100)) % 10;
        if (LastNumber >= 5)
        {
            RoundTwoNumber += 0.01;
        }
        NSNumber *FinalRoundNumber = [NSNumber numberWithLong:(long)(RoundTwoNumber * 100)];
        
        
        NSString *vat = [dictJob valueForKey:@"CurrentVat"];
        NSMutableDictionary *basePriceMoney=[[NSMutableDictionary alloc]init];
        
        [basePriceMoney setValue:FinalRoundNumber forKey:@"amount"];
        [basePriceMoney setValue:@"GBP" forKey:@"currency"];
        
        NSMutableDictionary *lineItems=[[NSMutableDictionary alloc]init];
        [lineItems setValue:@"1" forKey:@"quantity"];
        [lineItems setValue:basePriceMoney forKey:@"base_price_money"];
//        [lineItems setValue:_txtDesc.text forKey:@"name"];

//        [lineItems setValue:_txtDesc.text forKey:@"note"];
        
        
        if([_txtDesc.text length] >= 255){
             NSString *subStr = [_txtDesc.text substringToIndex:255];
            [lineItems setValue:subStr forKey:@"name"];
        }
        else{
            [lineItems setValue:_txtDesc.text forKey:@"name"];
        }
        
        
       // NSString *firstFour = [string substringToIndex:4];
        
        //NSMutableDictionary *taxAppliedMoney=[[NSMutableDictionary alloc]init];
        //[taxAppliedMoney setValue:@105 forKey:@"amount"];
        //[taxAppliedMoney setValue:@"USD" forKey:@"currency"];
        
        NSMutableDictionary *tax=[[NSMutableDictionary alloc]init];
        //[tax setValue:taxAppliedMoney forKey:@"applied_money"];
        
        
        [tax setValue:@"VAT" forKey:@"name"];
        [tax setValue:@"ORDER" forKey:@"scope"];
        [tax setValue:@"ADDITIVE" forKey:@"type"];
        [tax setValue:@"20" forKey:@"percentage"];
        
        NSMutableDictionary *order=[[NSMutableDictionary alloc]init];
        NSString *locationID = [NSString stringWithFormat:@"%s", squareUpLocationId];
        [order setValue:locationID forKey:@"location_id"];
        [order setValue:customerID forKey:@"customer_id"];
        [order setValue:[NSArray arrayWithObject:lineItems] forKey:@"line_items"];
        [order setValue:[NSArray arrayWithObject:tax] forKey:@"taxes"];
        
        NSMutableDictionary *body=[[NSMutableDictionary alloc]init];
        NSString *uuid = [[NSUUID UUID] UUIDString];
        [body setValue:uuid forKey:@"idempotency_key"];
        [body setValue:order forKey:@"order"];
    
        NSData * postData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingFragmentsAllowed error:NULL];
        
        NSLog(@"PARAMS = %@",body);
        
        [request setHTTPBody:postData];
        request.timeoutInterval = 300;
        DLog(@"PostString=%@",request);
        
        //NSLog(@"%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"]);
        
        MBProgressHUD * hudd=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hudd.labelText=@"Loading...";
        
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURLSessionDataTask * _dataTask =[defaultSession dataTaskWithRequest:request
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
            NSLog(@"Data = %@",text);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                
                if (data != nil) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                    NSLog(@"%@", dict);
                    NSString *orderId = [dict valueForKeyPath:@"order.id"];
                    if (orderId != nil) {
                        UIViewController *parent = self.presentingViewController;
                        [self dismissViewControllerAnimated:YES completion:^{
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PaymentStoryboard" bundle: nil];
                            CreateInvoiceVC * vc = [storyboard instantiateViewControllerWithIdentifier:@"CreateInvoiceVC"];
                            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                            vc.dictJob = self->dictJob;
                            vc.orderID = orderId;
                            vc.customerID = self->customerID;
                            [parent presentViewController:vc animated:YES completion:NULL];
                        }];
                        
                        
                    }else {
                        NSArray *errors = [dict valueForKey:@"errors"];
                        NSString *error;
                        if (errors && errors.count > 0) {
                            error = errors[0][@"detail"];
                        }
                        if (error) {
                            [self showAlert:error withTitle:@"Error!"];
                        } else {
                            [self showAlert:@"Something went wrong. Please try again later." withTitle:@"Error!"];
                        }
                    }
                }
            });
            
        }];
        [_dataTask resume];
        
    }
    
    
    
}

@end
