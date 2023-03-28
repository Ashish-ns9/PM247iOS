//
//  FinancialVC.m
//  Partner Maintenance


#import "FinancialVC.h"
#import "PaymentDtlsVC.h"

@interface FinancialVC ()
@end
@implementation FinancialVC

#pragma mark - viewDidLoad Mtehod
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    
    
    [_txtVNote.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_txtVNote.layer setBorderWidth: 0.5];
    [_txtVNote.layer setCornerRadius:0.0f];
    [_txtVNote.layer setMasksToBounds:YES];
  
    [_txtFixedPriceNote.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_txtFixedPriceNote.layer setBorderWidth: 0.5];
    [_txtFixedPriceNote.layer setCornerRadius:0.0f];
    [_txtFixedPriceNote.layer setMasksToBounds:YES];
  
    [_txtAddFixedPriceNote.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [_txtAddFixedPriceNote.layer setBorderWidth: 0.5];
    [_txtAddFixedPriceNote.layer setCornerRadius:0.0f];
    [_txtAddFixedPriceNote.layer setMasksToBounds:YES];
    
    
    [_txtCommissionRate setBorderStyle:UITextBorderStyleNone];
    _txtCommissionRate.layer.borderWidth=0.5f;
    _txtCommissionRate.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtCommissionRate.layer.cornerRadius=0.0f;
    
    [_txtJobPrice setBorderStyle:UITextBorderStyleNone];
    _txtJobPrice.layer.borderWidth=0.5f;
    _txtJobPrice.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtJobPrice.layer.cornerRadius=0.0f;
    
    [_txtsubTotalValue setBorderStyle:UITextBorderStyleNone];
    _txtsubTotalValue.layer.borderWidth=0.5f;
    _txtsubTotalValue.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtsubTotalValue.layer.cornerRadius=0.0f;
    
    [_txtJobVATPercentageValue setBorderStyle:UITextBorderStyleNone];
    _txtJobVATPercentageValue.layer.borderWidth=0.5f;
    _txtJobVATPercentageValue.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtJobVATPercentageValue.layer.cornerRadius=0.0f;
    
    [_txtJobVATValue setBorderStyle:UITextBorderStyleNone];
    _txtJobVATValue.layer.borderWidth=0.5f;
    _txtJobVATValue.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtJobVATValue.layer.cornerRadius=0.0f;
    
    [_txtJobVATTotalValue setBorderStyle:UITextBorderStyleNone];
    _txtJobVATTotalValue.layer.borderWidth=0.5f;
    _txtJobVATTotalValue.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtJobVATTotalValue.layer.cornerRadius=0.0f;
    
    [_txtActualMaterialSubTotalValue setBorderStyle:UITextBorderStyleNone];
    _txtActualMaterialSubTotalValue.layer.borderWidth=0.5f;
    _txtActualMaterialSubTotalValue.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtActualMaterialSubTotalValue.layer.cornerRadius=0.0f;
    
    [_txtActualMaterialVATValue setBorderStyle:UITextBorderStyleNone];
    _txtActualMaterialVATValue.layer.borderWidth=0.5f;
    _txtActualMaterialVATValue.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtActualMaterialVATValue.layer.cornerRadius=0.0f;
    
    [_txtActualCostSubTotalValue setBorderStyle:UITextBorderStyleNone];
    _txtActualCostSubTotalValue.layer.borderWidth=0.5f;
    _txtActualCostSubTotalValue.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtActualCostSubTotalValue.layer.cornerRadius=0.0f;
    
    [_txtActualCostVATValue setBorderStyle:UITextBorderStyleNone];
    _txtActualCostVATValue.layer.borderWidth=0.5f;
    _txtActualCostVATValue.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtActualCostVATValue.layer.cornerRadius=0.0f;
    
    [_txtEngineerMaterialSubTotalValue setBorderStyle:UITextBorderStyleNone];
    _txtEngineerMaterialSubTotalValue.layer.borderWidth=0.5f;
    _txtEngineerMaterialSubTotalValue.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtEngineerMaterialSubTotalValue.layer.cornerRadius=0.0f;
    
    [_txtEngineerMaterialVATValue setBorderStyle:UITextBorderStyleNone];
    _txtEngineerMaterialVATValue.layer.borderWidth=0.5f;
    _txtEngineerMaterialVATValue.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtEngineerMaterialVATValue.layer.cornerRadius=0.0f;
    
    [_txtEngineerCostSubTotalValue setBorderStyle:UITextBorderStyleNone];
    _txtEngineerCostSubTotalValue.layer.borderWidth=0.5f;
    _txtEngineerCostSubTotalValue.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtEngineerCostSubTotalValue.layer.cornerRadius=0.0f;
    
    [_txtEngineerCostVATValue setBorderStyle:UITextBorderStyleNone];
    _txtEngineerCostVATValue.layer.borderWidth=0.5f;
    _txtEngineerCostVATValue.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtEngineerCostVATValue.layer.cornerRadius=0.0f;
    
    [_txtCompanyJobProfitValue setBorderStyle:UITextBorderStyleNone];
    _txtCompanyJobProfitValue.layer.borderWidth=0.5f;
    _txtCompanyJobProfitValue.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtCompanyJobProfitValue.layer.cornerRadius=0.0f;
    
    [_txtEngineersCommissionValue setBorderStyle:UITextBorderStyleNone];
    _txtEngineersCommissionValue.layer.borderWidth=0.5f;
    _txtEngineersCommissionValue.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtEngineersCommissionValue.layer.cornerRadius=0.0f;
    
    [_txtCompanyProfiValue setBorderStyle:UITextBorderStyleNone];
    _txtCompanyProfiValue.layer.borderWidth=0.5f;
    _txtCompanyProfiValue.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txtCompanyProfiValue.layer.cornerRadius=0.0f;
    
     [_scrollDetails setAutoresizesSubviews:YES];
    
    
    NSString *Count = @"ndata";
    
    [[NSUserDefaults standardUserDefaults] setObject:Count forKey:@"StringCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}



#pragma mark - viewDidAppear Mtehod
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if(_btnSubmit != nil)
    {
        [_scrollDetails setContentSize:CGSizeMake(_scrollDetails.frame.size.width, CGRectGetMaxY(_btnSubmit.frame) + 10)];
    }
    else if (_btnPaymentDetail != nil){
        [_scrollDetails setContentSize:CGSizeMake(_scrollDetails.frame.size.width, CGRectGetMaxY(_btnPaymentDetail.frame) + 10)];
    }
    
    [self GetSquareUpPaymentDetails:true];
}

- (void)GetSquareUpPaymentDetails:(BOOL)isFirstTime
{
    MBProgressHUD   *hudd=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudd.labelText=@"Loading...";
    [hudd show:YES];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    [dict setObject:[GlobalDirector ReplaceStringNull:[_jobDic valueForKey:@"JobID"]] forKey:@"jobId"];
    
    GlobalDirector *globe= [GlobalDirector SharedDirector];
    [globe SyncRequestGet:REQUEST_GetSquareUpPaymentDetails withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        NSLog(@"%@",result);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [hudd hide:YES];
            @try{
                
                /*
                strAmtDue = [NSString stringWithFormat:@"%.02f",[[GlobalDirector ReplaceStringNull:[result valueForKey:@"TotalPaymentDue"]] floatValue]];
                
//                if ([strAmtDue intValue]>0) {
//                    _viewTakePayment.hidden=NO;
//                }else{
//                    _viewTakePayment.hidden=YES;
//                }
                */
                self->arrPayments = [result valueForKey:@"SquareUpPaymentDetailListResponse"];
                if(isFirstTime){
                    [self CheckInvoiceStatus:0];
                }
                
                
            } @catch (NSException *exception) {
                [self showAlert:@"There are some problem right now, try again later. " withTitle:@"Sorry!"];
            }
        });
        
    }];
}


-(void)CheckInvoiceStatus:(int)indexValue{
    if([self->arrPayments count] > indexValue){
        NSDictionary *dict = [self->arrPayments objectAtIndex:indexValue];
        if([[GlobalDirector ReplaceStringNull:[dict valueForKey:@"Status"]] isEqualToString:@"UNPAID"]){
            NSString *invoiceUrl = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"InvoiceUrl"]];

            NSString *publicUrl = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"PublishUrl"]];
            
            NSString *jobId = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"JobPaymentID"]];

            NSString *title = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"title"]];

            NSString *status = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"Status"]];
            
            NSString *amountString = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"Amount"]];
            
            NSString *objId = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"Id"]];
            
            NSString *dueDate = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"DueDate"]];

//            NSString *amount = [GlobalDirector ReplaceStringNull:[dict valueForKeyPath:@"invoice.next_payment_amount_money.amount"]];
//
//            double amountValue =  [amount floatValue] / 100;
//            NSString *amountString = [NSString stringWithFormat:@"%f", amountValue];
            
            [self GetInvoiceStatusAPI:invoiceUrl  jobId:jobId  publicUrl:publicUrl title:title status:status amountString:amountString objId:objId dueDate:dueDate currentIndex:indexValue];
            
        }
        else{
            [self CheckInvoiceStatus:indexValue+1];
        }
    }
    else{
        [self getFinancialdetails];
//        if(indexValue != 0){
//
//            [self GetSquareUpPaymentDetails:false];
//        }
    }
    
}

-(void)GetInvoiceStatusAPI:(NSString *)invoiceUrl jobId:(NSString *)jobId publicUrl:(NSString *)publicUrl title:(NSString *)title status:(NSString *)status amountString:(NSString *)amountString objId:(NSString *)objId dueDate:(NSString *)dueDate currentIndex:(int)currentIndex
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
        
        urlString=[NSString stringWithFormat:@"%sinvoices/%@",squareUpBaseURL, invoiceUrl];
        
        NSString *authToken = [NSString stringWithFormat:@"Bearer %s", squareUpAccessToken];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:authToken forHTTPHeaderField:@"Authorization"];
        [request setValue:@"2022-10-19" forHTTPHeaderField:@"Square-Version"];
        
        NSMutableDictionary *body=[[NSMutableDictionary alloc]init];
        NSString *uuid = [[NSUUID UUID] UUIDString];
        [body setValue:uuid forKey:@"idempotency_key"];
        [body setValue:@"0" forKey:@"version"];

        NSData * postData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingFragmentsAllowed error:NULL];
        
        NSLog(@"PARAMS = %@",body);
        
        //[request setHTTPBody:postData];
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
                    
                    NSString *status = [dict valueForKeyPath:@"invoice.status"];
                    if (publicUrl != nil) {
                        if(![status isEqualToString:@"UNPAID"]){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self saveSquarePaymentDetailAndSendSms:invoiceUrl publishUrl:publicUrl
                                            jobId:jobId  title:title status:status amount:amountString objId:objId dueDate:dueDate
                                                           currentIndex:currentIndex];
                            });
                            
                        }
                        else{
                            [self CheckInvoiceStatus:currentIndex+1];
                        }
                    }
                    else {
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



-(void) saveSquarePaymentDetailAndSendSms:(NSString *)invoiceUrl publishUrl:(NSString *)publishUrl  jobId:(NSString *)jobId
                                    title:(NSString *)title
                                   status:(NSString *)status
                                   amount:(NSString *)amount
                                    objId:(NSString *)objId
                                  dueDate:(NSString *)dueDate

                             currentIndex:(int)currentIndex
{
    
    MBProgressHUD   *hudd=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudd.labelText=@"Loading...";
    [hudd show:YES];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSDictionary *userdetails = [[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    [dict setObject:[GlobalDirector ReplaceStringNull:[_jobDic valueForKey:@"JobID"]] forKey:@"jobId"];
    
    [dict setObject:invoiceUrl forKey:@"invoiceUrl"];
    [dict setObject:publishUrl forKey:@"publishUrl"];
    [dict setObject:title forKey:@"title"];
    [dict setObject:dueDate forKey:@"dueDate"];
    [dict setObject:status forKey:@"status"];
    [dict setObject:amount forKey:@"amount"];
    [dict setObject:objId forKey:@"id"];
    [dict setObject:jobId forKey:@"JobPaymentID"];

    
    NSArray *users = [_jobDic valueForKey:@"JobPeopleListResponse"];
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
                    
                    [self CheckInvoiceStatus:currentIndex+1];

//                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:publishUrl forKey:@"invoice_link"];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:
//                     @"INVOICE_LINK_GENERATED_NOTIFICATION" object:nil userInfo:userInfo];
                    
                }else{
                    [self showAlert:[GlobalDirector ReplaceStringNull:[[result valueForKey:@"SaveJobPaymentResult"] valueForKey:@"ResponseMessages"]] withTitle:@"Error"];
                }
            } @catch (NSException *exception) {
                [self showAlert:@"There are some problem right now, try again later. " withTitle:@"Sorry!"];
            }
        });
        
    }];
}




#pragma mark - didReceiveMemoryWarning Mtehod
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Back Press Mtehod
- (IBAction)btnBack:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark- UItextview delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)PaymentDetails:(UIButton *)sender
{
    NSLog(@"payment details click");
    
    PaymentDtlsVC *vc = [[PaymentDtlsVC alloc] initWithNibName:@"PaymentDtlsVC" bundle:nil];
    vc.outStandingAmount = [NSString stringWithFormat:@"%.02f",[[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"OutstandingAmount"]] floatValue]];
    
    

    vc.dictJob=_jobDic;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


#pragma mark - Get Financial Details Method
- (IBAction)Submit:(UIButton *)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"dicFinanceDetails :%@",dicFinanceDetails);
//
//    NSLog(@"FinancialDetailId :%@",[dicFinanceDetails valueForKey:@"FinancialDetailId"]);
//
//    GlobalDirector *globe = [GlobalDirector SharedDirector];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//
//    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
//
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
//    [dict setObject:[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"JobId"]] forKey:@"jobId"];
//    [dict setObject:[GlobalDirector ReplaceStringNull:[NSString stringWithFormat:@"%ld",(long)_txtCommissionRate.tag]] forKey:@"commissionId"];
//    [dict setObject:[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"VatId"]] forKey:@"vatId"];
//    [dict setObject:[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"VatPercentage"]] forKey:@"vatPercentage"];
//    [dict setObject:[GlobalDirector ReplaceStringNull:[NSString stringWithFormat:@"%ld",(long)_txtJobPrice.tag]] forKey:@"jobPriceId"];
//    [dict setObject:[GlobalDirector ReplaceStringNull:_txtVNote.text] forKey:@"note"];
//    [dict setObject:[GlobalDirector ReplaceStringNull:_txtAddFixedPriceNote.text] forKey:@"fixedPriceNotes"];
//    [dict setObject:[GlobalDirector ReplaceStringNull:_txtsubTotalValue.text] forKey:@"jobSubTotal"];
//    [dict setObject:[GlobalDirector ReplaceStringNull:_txtActualMaterialSubTotalValue.text] forKey:@"actualMaterialSubTotal"];
//    [dict setObject:[GlobalDirector ReplaceStringNull:_txtActualCostSubTotalValue.text] forKey:@"actualCostSubTotal"];
//    [dict setObject:[GlobalDirector ReplaceStringNull:_txtEngineerMaterialSubTotalValue.text] forKey:@"engineerMaterialSubTotal"];
//    [dict setObject:[GlobalDirector ReplaceStringNull:_txtEngineerCostSubTotalValue.text] forKey:@"engineerCostSubTotal"];
//    [dict setObject:[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"FinancialDetailId"]] forKey:@"financialDetailId"];//**
//
//    NSString *boolean;
//    if ([[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"IsEngineerVatRegistered"]] intValue] == 1)
//    {
//        boolean=@"true";
//    }
//    else
//    {
//        boolean=@"false";
//    }
//    [dict setObject:boolean forKey:@"isEngineerVatRegistered"];
//
//    [globe SyncRequestPostWithJson:REQUEST_SaveFinancialDetail withPrams:dict andCompletionHandler:^(NSDictionary *result) {
//    NSLog(@"%@",result);
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            @try {
//                BOOL strValue = [[result valueForKey:@"SaveFinancialDetailResult"] valueForKey:@"ResponseStatus"];
//
//                [hud setHidden:YES];
//
//                if (strValue)
//                {
//                    [self dismissViewControllerAnimated:YES completion:^{
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [self showAlert:[GlobalDirector ReplaceStringNull:[[result valueForKey:@"SaveFinancialDetailResult"] valueForKey:@"ResponseMessages"]]  withTitle:@"Sorry!"];
//                         });
//                    }];
//                }else{
//                    [self showAlert:@"There are some problem right now, try again later. " withTitle:@"Sorry!"];
//                }
//            } @catch (NSException *exception) {
//                // _txtPost.text=@"";
//                [self showAlert:@"There are some problem right now, try again later. " withTitle:@"Sorry!"];
//            }
//        });
//
//    }];
//
//    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText=@"Saving Financial Details...";
//    [hud show:YES];
}



#pragma mark - Calculate Fianancial Method
- (IBAction)Calculate:(UIButton *)sender{
    

   
    float emtv  =  [_txtEngineerMaterialVATValue.text floatValue];
    float ectv  =  [_txtEngineerCostVATValue.text floatValue];
    float emt  =  [_txtEngineerMaterialSubTotalValue.text floatValue];
    float ect  =  [_txtEngineerCostSubTotalValue.text floatValue];
    
    NSString *str =@"%";
    float ecr = [[_txtCommissionRate.text stringByReplacingOccurrencesOfString:str withString:@""] floatValue];
 
    
     float jst=  [_txtsubTotalValue.text floatValue];
    float amt=  [_txtActualMaterialSubTotalValue.text floatValue];
    float act=  [_txtActualCostSubTotalValue.text floatValue];
    
    float cjp = jst-(amt+act);
    float ec =0.0;
    
    BOOL ischeckeng=[[dicFinanceDetails valueForKey:@"IsEngineerVatRegistered"] boolValue];
    if (ischeckeng==NO){
        ec = (jst-emtv-ectv)*ecr/100;
        
    }else{
        ec = (jst-emt-ect)*ecr/100;
       
    }
    
     _txtCompanyJobProfitValue.text= [NSString stringWithFormat:@"%.02f",cjp];
     _txtEngineersCommissionValue.text= [NSString stringWithFormat:@"%.02f",ec];
     _txtCompanyProfiValue.text= [NSString stringWithFormat:@"%.02f",(cjp-ec)];
    
    
}

#pragma mark - Get Financial Details Method
-(void)getFinancialdetails
{
    
    NSLog(@"_JobDic :%@",[_jobDic valueForKey:@"JobID"]);
    
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString=[NSString stringWithFormat:@"%sGetFinancialDetail?userToken=%@&jobId=%@",conn_url, (NSString *)[userdetails valueForKey:@"UserToken"],(NSString *)[_jobDic valueForKey:@"JobID"]];
    urlString=[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
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
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"Loading Financial Details...";
    [hud show:YES];
    
    connFinancialDetails = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connFinancialDetails start];
}



#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}


- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [hud hide:YES];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [hud hide:YES];
    NSString *data_Response = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Responseyyyyyyyyyyyyyyyyyyyyyy=%@",data_Response);
    
    NSMutableDictionary* temp;
    if (_responseData !=nil)
    {
        NSError *error;
        temp = [NSJSONSerialization JSONObjectWithData:_responseData  options:NSJSONReadingMutableContainers error:&error];
        if (!error)
        {
            if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
            {
                if (connection==connFinancialDetails)
                {
                    
                    dicFinanceDetails = [temp valueForKey:@"FinancialDetail"];
                    arrFinNoteList = [temp valueForKey:@"FinancialNoteList"];
                    
                    if ([arrFinNoteList count]>0) {
                        
                        NSDictionary *dict=[arrFinNoteList firstObject];
                        
                         _lblcreatedBy.text=[GlobalDirector ReplaceStringNull:[dict valueForKey:@"CreatedBy"]];
                         _lblCreatDate.text=[GlobalDirector ReplaceStringNull:[dict valueForKey:@"CreatedDate"]];
                         _lblDecription.text=[GlobalDirector ReplaceStringNull:[dict valueForKey:@"NoteBody"]];
                        
                    }
                    
                    
                    
                    NSLog(@"dicFinanceDetails :%@",dicFinanceDetails);
                    
                    _txtCommissionRate.text=[GlobalDirector ReplaceStringNull:[temp valueForKey:@"CommissionRate"]];
                    
                    if (_txtCommissionRate.text.length==0) {
                        _txtCommissionRate.text = @"0.0%";
                    }
                    
                    _txtOutstanding.text = [NSString stringWithFormat:@"%.02f",[[GlobalDirector ReplaceStringNull:[temp valueForKey:@"OutstandingAmount"]] floatValue]];
                    
                    
                    
                    _txtJobPrice.text=[GlobalDirector ReplaceStringNull:[temp valueForKey:@"JobPrice"]];
                    
                    _txtJobPrice.tag=[[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"JobPriceId"]] intValue];
                    
                     _txtCommissionRate.tag=[[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"CommissionId"]] intValue];
                    
                    
                    _txtJobVATPercentageValue.text= [NSString stringWithFormat:@"%.02f",[[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"VatPercentage"]] floatValue]];
                    _txtsubTotalValue.text=[NSString stringWithFormat:@"%.02f",[[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"JobSubTotal"]] floatValue]];
                    _txtJobVATValue.text= [NSString stringWithFormat:@"%.02f",[[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"JobVat"]] floatValue]];
                     _txtJobVATTotalValue.text= [NSString stringWithFormat:@"%.02f",[[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"JobTotal"]] floatValue]];
                    
                   
                     _txtFixedPriceNote.text= [GlobalDirector ReplaceStringNull:[temp valueForKey:@"LastFixedPriceNote"]];
                     _txtAddFixedPriceNote.text= [GlobalDirector ReplaceStringNull:[temp valueForKey:@"LastFixedPriceNote"]];
                    
                    
                    
                    _txtActualMaterialSubTotalValue.text= [NSString stringWithFormat:@"%.02f",[[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"ActualMaterialSubTotal"]] floatValue]];
                    
                    _txtActualMaterialVATValue.text= [NSString stringWithFormat:@"%.02f",[[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"ActualMaterialTotalVat"]] floatValue]];
                    _txtActualCostSubTotalValue.text= [NSString stringWithFormat:@"%.02f",[[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"ActualCostSubTotal"]] floatValue]];
                    _txtActualCostVATValue.text= [NSString stringWithFormat:@"%.02f",[[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"ActualCostTotalVat"]] floatValue]];
                    
                    
                    _txtEngineerMaterialSubTotalValue.text= [NSString stringWithFormat:@"%.02f",[[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"EngineerMaterialSubTotal"]] floatValue]];
                    _txtEngineerMaterialVATValue.text= [NSString stringWithFormat:@"%.02f",[[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"EngineerMaterialTotalVat"]] floatValue]];
                    _txtEngineerCostSubTotalValue.text= [NSString stringWithFormat:@"%.02f",[[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"EngineerCostSubTotal"]] floatValue]];
                    _txtEngineerCostVATValue.text= [NSString stringWithFormat:@"%.02f",[[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"EngineerCostTotalVat"]] floatValue]];
                    
                    BOOL ischeckeng=[[dicFinanceDetails valueForKey:@"IsEngineerVatRegistered"] boolValue];
                    if (ischeckeng==NO){
                        _lblProfitCommissionMessage.text=[NSString stringWithFormat:@" %@ is not VAT Registered",[GlobalDirector ReplaceStringNull:[_jobDic valueForKey:@"EngineerName"]]];
                    }else{
                        _lblProfitCommissionMessage.text=[NSString stringWithFormat:@" %@ is VAT Registered",[GlobalDirector ReplaceStringNull:[_jobDic valueForKey:@"EngineerName"]]];
                    }
                    
                    _txtCompanyJobProfitValue.text= [NSString stringWithFormat:@"%.02f",[[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"CompanyJobProfit"]] floatValue]];
                    _txtEngineersCommissionValue.text=[NSString stringWithFormat:@"%.02f",[[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"EngineerCommission"]] floatValue]];
                    _txtCompanyProfiValue.text=[NSString stringWithFormat:@"%.02f",[[GlobalDirector ReplaceStringNull:[dicFinanceDetails valueForKey:@"CompanyProfit"]] floatValue]];
                    
                    
                    [self performSelector:@selector(VatCalculation) withObject:nil afterDelay:0.1];
                    
                    if(_btnSubmit != nil)
                    {
                        [_scrollDetails setContentSize:CGSizeMake(_scrollDetails.frame.size.width, CGRectGetMaxY(_btnSubmit.frame) + 10)];
                    }
                    else if (_btnPaymentDetail != nil){
                        [_scrollDetails setContentSize:CGSizeMake(_scrollDetails.frame.size.width, CGRectGetMaxY(_btnPaymentDetail.frame) + 10)];
                    }
                    
                
                }
            }
            else
            {
                DLog(@"JSONObjectWithData error: %@", error);
                if (connection==connFinancialDetails)
                {
                }
                if(_btnSubmit != nil)
                {
                    [_scrollDetails setContentSize:CGSizeMake(_scrollDetails.frame.size.width, CGRectGetMaxY(_btnSubmit.frame) + 10)];
                }
                else if (_btnPaymentDetail != nil){
                    [_scrollDetails setContentSize:CGSizeMake(_scrollDetails.frame.size.width, CGRectGetMaxY(_btnPaymentDetail.frame) + 10)];
                }
                
            }
        }
    }
    else
    {
        return;
    }
}


#pragma mark - Textfield Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField==_txtCommissionRate||textField ==_txtJobPrice)
    {
        arrFeedTblPopup= [[NSArray alloc]init];
        
        [self.view endEditing:YES];
        Activetxtfld=textField;
        [self popupList];
        
        return NO;
    }
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField==_txtsubTotalValue)
    {
        [self VatCalculation];
    }

}

#pragma mark - POPUP List Fetch and Populate Method
-(void)GetDataForPoppup:(UITextField *)fld
{
    if(fld==_txtCommissionRate){
        [self FetchDataForField:@"GetCommisionRate"];
  
    }
    else if(fld==_txtJobPrice){
        [self FetchDataForField:@"GetJobPrice"];
    }
}

-(void)FetchDataForField:(NSString *)key
{
    DLog(@"%@",self.dataTask.originalRequest.URL);
    [MBProgressHUD showHUDAddedTo:Activetxtfld animated:YES];
    
    [self fetchDropDownForTextField:key didFinishLoading:^(BOOL success , NSArray *arrData){
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            [MBProgressHUD hideAllHUDsForView:Activetxtfld animated:YES];
            arrFeedTblPopup=arrData;
            [tblView reloadData];
            [self.dataTask cancel];
            
        });
        
    }];
}

-(void)popupList
{
    if (tblView!=nil)
    {
        [self handleTap];
        [self.dataTask cancel];
    }
    else
    {
        [self GetDataForPoppup:Activetxtfld];
        
        tblView=[[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMinX(Activetxtfld.frame),CGRectGetMaxY(Activetxtfld.frame)+2, CGRectGetWidth(Activetxtfld.frame), 0) style:UITableViewStylePlain];
        tblView.delegate=self;
        tblView.dataSource=self;
        [self.scrollDetails addSubview:tblView];
       
        [tblView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [tblView.layer setBorderWidth: 2.0];
        [tblView.layer setCornerRadius:3.0f];
        [tblView.layer setMasksToBounds:YES];
        
        [UIView animateWithDuration:0.35
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect frame = tblView.frame;
                             frame.size.height = self.view.frame.size.height/2.0f;
                             tblView.frame = frame;
                         }
                         completion:^(BOOL finished){
                             DLog(@"Done!");
                         }];
    }
}
-(void)handleTap
{
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = tblView.frame;
                         frame.size.height = 0;
                         tblView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         DLog(@"Done!");
                         [tblView removeFromSuperview];
                         tblView=nil;
                     }];
}

#pragma mark - TableView Delegate & Datasource
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tblView)
    {
        return [arrFeedTblPopup count];
    }
    else{
        return 0;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier=@"cellidentifier";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.backgroundColor=[UIColor clearColor];
    
    if (tableView==tblView)
    {
        NSDictionary *dic=[arrFeedTblPopup objectAtIndex:indexPath.row];
        cell.textLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"DisplayText"]];
    }
    else
    {
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblView)
    {
        return 45;
    }
    else
    {
        return 0;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblView)
    {
        NSDictionary *dic=[arrFeedTblPopup objectAtIndex:indexPath.row];
        Activetxtfld.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"DisplayText"]];
        Activetxtfld.tag=[[dic valueForKey:@"Value"]integerValue];
        
        [tblView removeFromSuperview];
        tblView=nil;
    }
}

#pragma mark- Calculation

-(void)VatCalculation
{
    //job vat
    float jst = [_txtsubTotalValue.text intValue];
    float v = [_txtJobVATPercentageValue.text intValue];
    float amt = [_txtActualMaterialSubTotalValue.text intValue];
    float act = [_txtActualCostSubTotalValue.text intValue];
    float emt = [_txtEngineerMaterialSubTotalValue.text intValue];
    float ect = [_txtEngineerCostSubTotalValue.text intValue];
    
    float jv = jst * (v/100);
    
    _txtJobVATValue.text = [NSString stringWithFormat:@"%.02f",jv];
    
    //job total
    
    _txtJobVATTotalValue.text = [NSString stringWithFormat:@"%.02f",(jst+jv)];
   _txtActualMaterialVATValue.text = [NSString stringWithFormat:@"%.02f",(amt*(1+(v/100)))];//amtv
    _txtActualCostVATValue.text = [NSString stringWithFormat:@"%.02f",(act*(1+(v/100)))];//actv
    _txtEngineerMaterialVATValue.text = [NSString stringWithFormat:@"%.02f",(emt*(1+(v/100)))];//emtv
    _txtEngineerCostVATValue.text = [NSString stringWithFormat:@"%.02f",(ect*(1+(v/100)))];//ectv
    
}


- (IBAction)MoreNoteClick:(UIButton *)sender {
    
    
    FinancialNoteList *fin = [[FinancialNoteList alloc] initWithNibName:@"FinancialNoteList" bundle:nil];
    fin.arrFinNoteList=arrFinNoteList;
    [self presentViewController:fin animated:YES completion:nil];
    
}


@end

