//
//  CreateCustomerVC.m
//  PM247
//
//  Created by Vikram on 11/11/22.
//  Copyright © 2022 SANDIPAN. All rights reserved.
//

#import "CreateCustomerVC.h"
#import "CreateOrderVC.h"

@interface CreateCustomerVC ()
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtOrgaz;

@end

@implementation CreateCustomerVC
@synthesize dictJob;
@synthesize dictPaymentMethod;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *users = [dictJob valueForKey:@"JobPeopleListResponse"];
    NSDictionary * user = [users firstObject];
    
    _txtFirstName.text = [user valueForKey:@"FirstName"];
    _txtLastName.text = [user valueForKey:@"LastName"];
    _txtMobile.text = [user valueForKey:@"ContactNumber"];
    _txtEmail.text = [user valueForKey:@"EmailAddress"];
//    _txtEmail.text = @"a@mailinator.com";

    [_txtFirstName setUserInteractionEnabled:NO];
    [_txtLastName setUserInteractionEnabled:NO];
    [_txtMobile setUserInteractionEnabled:NO];
    [_txtEmail setUserInteractionEnabled:NO];
    [_txtOrgaz setUserInteractionEnabled:NO];
}

- (IBAction)popVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)createCustomerAction:(id)sender {
    [self createCustomerAPI];
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PaymentStoryboard" bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"CreateOrderVC"];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:vc animated:YES completion:NULL];
     */
}

#pragma mark - createCustomerAPI Method
-(void)createCustomerAPI
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
        
        urlString=[NSString stringWithFormat:@"%s%@",squareUpBaseURL, @"customers"];
        
        NSString *authToken = [NSString stringWithFormat:@"Bearer %s", squareUpAccessToken];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:authToken forHTTPHeaderField:@"Authorization"];
        [request setValue:@"2022-10-19" forHTTPHeaderField:@"Square-Version"];
        
        
        NSString *phone = [
            NSString stringWithFormat:@"+44%@",
            [_txtMobile.text stringByReplacingOccurrencesOfString:@" " withString:@""]
        ];
        
        NSMutableDictionary *body=[[NSMutableDictionary alloc]init];
        [body setValue:_txtFirstName.text forKey:@"given_name"];
        [body setValue:_txtLastName.text forKey:@"family_name"];
        [body setValue:phone forKey:@"phone_number"];
        [body setValue:_txtEmail.text forKey:@"email_address"];
        NSString *uuid = [[NSUUID UUID] UUIDString];
        [body setValue:uuid forKey:@"idempotency_key"];
        NSLog(@"PARAMS = %@",body);
        
        NSData * postData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingFragmentsAllowed error:NULL];
        
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
                    NSString *customerId = [dict valueForKeyPath:@"customer.id"];
                    if (customerId != nil) {
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PaymentStoryboard" bundle: nil];
                        CreateOrderVC * vc = [storyboard instantiateViewControllerWithIdentifier:@"CreateOrderVC"];
                        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                        vc.dictJob = self->dictJob;
                        vc.customerID = customerId;
                        vc.amount = [self->dictPaymentMethod valueForKey:@"amount"];
                        vc.dueAmount = [self->dictPaymentMethod valueForKey:@"DueAmount"];
                                                
                        [self presentViewController:vc animated:YES completion:NULL];
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
