//
//  GeneratePaymentLinkInvoiceVC.m
//  PM247
//
//  Created by Vikram on 11/11/22.
//  Copyright © 2022 SANDIPAN. All rights reserved.
//

#import "GeneratePaymentLinkInvoiceVC.h"
#import "GlobalDirector.h"

@interface GeneratePaymentLinkInvoiceVC ()

@end

@implementation GeneratePaymentLinkInvoiceVC

@synthesize dictJob;
@synthesize invoiceID;
@synthesize dueDate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)generatePaymentLinkAction:(id)sender {
    [self generateInvoiceLinkAPI];
}
- (IBAction)dismissVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - generateInvoiceLinkAPI Method
-(void)generateInvoiceLinkAPI
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
        
        urlString=[NSString stringWithFormat:@"%s%@/%@/publish",squareUpBaseURL, @"invoices", invoiceID];
        
        NSString *authToken = [NSString stringWithFormat:@"Bearer %s", squareUpAccessToken];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:authToken forHTTPHeaderField:@"Authorization"];
        [request setValue:@"2022-10-19" forHTTPHeaderField:@"Square-Version"];
        
        NSMutableDictionary *body=[[NSMutableDictionary alloc]init];
        NSString *uuid = [[NSUUID UUID] UUIDString];
        [body setValue:uuid forKey:@"idempotency_key"];
        [body setValue:@"0" forKey:@"version"];

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
        
        NSURLSessionDataTask * _dataTask =[defaultSession dataTaskWithRequest:request  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
            NSLog(@"Data = %@",text);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                
                if (data != nil) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                    NSLog(@"%@", dict);
                    NSString *invoiceUrl = [dict valueForKeyPath:@"invoice.id"];

                    NSString *publicUrl = [dict valueForKeyPath:@"invoice.public_url"];
                    NSLog(@"INVOICE LINK: %@", publicUrl);
                    if (publicUrl != nil) {
                        
                        NSString *title = [dict valueForKeyPath:@"invoice.title"];
                        NSString *status = [dict valueForKeyPath:@"invoice.status"];
                        NSString *amount = [dict valueForKeyPath:@"invoice.next_payment_amount_money.amount"];
                        double amountValue =  [amount floatValue] / 100;
                        
                        NSString *amountString = [NSString stringWithFormat:@"%.02f", amountValue];
                        
                        NSString *objId = [dict valueForKeyPath:@"invoice.invoice_number"];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self saveSquarePaymentDetailAndSendSms:invoiceUrl publishUrl:publicUrl title:title status:status amount:amountString objId:objId];
                        });
                        
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

-(void) saveSquarePaymentDetailAndSendSms:(NSString *)invoiceUrl
                               publishUrl:(NSString *)publishUrl
                                    title:(NSString *)title
                                   status:(NSString *)status
                                   amount:(NSString *)amount
                                   objId:(NSString *)objId
{

    MBProgressHUD   *hudd=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudd.labelText=@"Please wait...";
    [hudd show:YES];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSDictionary *userdetails = [[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    [dict setObject:[GlobalDirector ReplaceStringNull:[dictJob valueForKey:@"JobID"]] forKey:@"jobId"];
    
    [dict setObject:invoiceUrl forKey:@"invoiceUrl"];
    [dict setObject:publishUrl forKey:@"publishUrl"];
    [dict setObject:title forKey:@"title"];
    [dict setObject:dueDate forKey:@"dueDate"];
    [dict setObject:status forKey:@"status"];
    [dict setObject:amount forKey:@"amount"];
    [dict setObject:objId forKey:@"id"];
    
    NSArray *users = [dictJob valueForKey:@"JobPeopleListResponse"];
    NSDictionary * user = [users firstObject];
    NSString *phoneNo = [[user valueForKey:@"ContactNumber"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [dict setObject:phoneNo forKey:@"phoneNumber"];
    
    GlobalDirector *globe= [GlobalDirector SharedDirector];
    [globe SyncRequestGet:REQUEST_SaveSquarePaymentDetailAndSendSms withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        NSLog(@"%@",result);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [hudd hide:YES];
            
            @try{
                
                int code = [[[result valueForKey:@"SaveJobPaymentResult"] valueForKey:@"ResponseCode"] intValue] ;
                
                if (code==0) {
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:publishUrl forKey:@"invoice_link"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:
                                           @"INVOICE_LINK_GENERATED_NOTIFICATION" object:nil userInfo:userInfo];
                    
                }else{
                    [self showAlert:[GlobalDirector ReplaceStringNull:[[result valueForKey:@"SaveJobPaymentResult"] valueForKey:@"ResponseMessages"]] withTitle:@"Error"];
                }
            } @catch (NSException *exception) {
                [self showAlert:@"There are some problem right now, try again later. " withTitle:@"Sorry!"];
            }
        });
        
    }];
}

@end
