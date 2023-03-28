//
//  CreateInvoiceVC.m
//  PM247
//
//  Created by Vikram on 11/11/22.
//  Copyright © 2022 SANDIPAN. All rights reserved.
//

#import "CreateInvoiceVC.h"
#import "GeneratePaymentLinkInvoiceVC.h"

@interface CreateInvoiceVC ()
@property (weak, nonatomic) IBOutlet UITextField *txtDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;

@end

@implementation CreateInvoiceVC
@synthesize orderID;
@synthesize customerID;
@synthesize datePicker;
@synthesize dictJob;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    if (@available(iOS 13.4, *)) {
        [datePicker setPreferredDatePickerStyle:UIDatePickerStyleWheels];
    }
    [self.txtDatePicker setInputView:datePicker];
    NSArray *jobAddrList = [dictJob valueForKey:@"JobAddrListResponse"];
    if (jobAddrList.count > 0) {
        _txtTitle.text = [[jobAddrList firstObject] valueForKey:@"PostCode"];
    }

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

-(void)updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.txtDatePicker.inputView;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *newDate = [dateFormatter stringFromDate:picker.date];
    self.txtDatePicker.text = newDate;
}

- (IBAction)btnCloseAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)btnCreateInvoiceAction:(id)sender {
    if (_txtDatePicker.text.length==0){
        [self showAlert:@"Please select due date." withTitle:@"Error"];
    }else if (_txtTitle.text.length == 0) {
        [self showAlert:@"Please enter title." withTitle:@"Error"];
    }else {
        [self createInvoiceAPI];
    }
    
}

#pragma mark - createInvoiceAPI Method
-(void)createInvoiceAPI
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
        
        urlString=[NSString stringWithFormat:@"%s%@",squareUpBaseURL, @"invoices"];
        
        NSString *authToken = [NSString stringWithFormat:@"Bearer %s", squareUpAccessToken];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:authToken forHTTPHeaderField:@"Authorization"];
        [request setValue:@"2022-10-19" forHTTPHeaderField:@"Square-Version"];
        
        NSMutableDictionary *primaryRecipient=[[NSMutableDictionary alloc]init];
        [primaryRecipient setValue:customerID forKey:@"customer_id"];
        
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [datePicker date];
        NSString *dueDate = [formatter stringFromDate:date];
    
        NSMutableDictionary *paymentRequests=[[NSMutableDictionary alloc]init];
        [paymentRequests setValue:@"BALANCE" forKey:@"request_type"];
        [paymentRequests setValue:dueDate forKey:@"due_date"];
        
        NSMutableDictionary *acceptedPaymentMethods=[[NSMutableDictionary alloc]init];
//        [acceptedPaymentMethods setValue:@YES forKey:@"bank_account"];
        [acceptedPaymentMethods setValue:@YES forKey:@"card"];

        NSString *invoiceNoId = [dictJob valueForKey:@"InvoiceNumberID"];
        NSString *postCode = @"";
        NSArray *jobAddrList = [dictJob valueForKey:@"JobAddrListResponse"];
        if (jobAddrList.count > 0) {
            postCode = [[jobAddrList firstObject] valueForKey:@"PostCode"];
        }
        
        
        NSString *invoiceTitle = [NSString stringWithFormat:@"Invoice %@ || PostCode %@", invoiceNoId, postCode];
//        NSString *salesDate = [formatter stringFromDate:[NSDate date]];
        
        NSMutableDictionary *invoice=[[NSMutableDictionary alloc]init];
        [invoice setValue:orderID forKey:@"order_id"];
        [invoice setValue:primaryRecipient forKey:@"primary_recipient"];
        [invoice setValue:@"EMAIL" forKey:@"delivery_method"];
        [invoice setValue:[NSArray arrayWithObject:paymentRequests] forKey:@"payment_requests"];
        [invoice setValue:invoiceTitle forKey:@"title"];
        //[invoice setValue:salesDate forKey:@"sale_or_service_date"];
        [invoice setValue:acceptedPaymentMethods forKey:@"accepted_payment_methods"];
        
        //NSString *jobdesc = [dictJob valueForKey:@"JobDescription"];
        //[invoice setValue:jobdesc forKey:@"description"];
        
        NSMutableDictionary *body=[[NSMutableDictionary alloc]init];
        NSString *uuid = [[NSUUID UUID] UUIDString];
        [body setValue:uuid forKey:@"idempotency_key"];
        [body setValue:invoice forKey:@"invoice"];
    
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
                    NSString *invoiceID = [dict valueForKeyPath:@"invoice.id"];
                    if (invoiceID != nil) {
                        UIViewController *parent = self.presentingViewController;
                        [self dismissViewControllerAnimated:YES completion:^{
                            
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PaymentStoryboard" bundle: nil];
                            GeneratePaymentLinkInvoiceVC * vc = [storyboard instantiateViewControllerWithIdentifier:@"GeneratePaymentLinkInvoiceVC"];
                            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                            vc.dictJob = self->dictJob;
                            vc.invoiceID = invoiceID;
                            vc.dueDate = dueDate;
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
