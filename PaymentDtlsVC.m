//
//  PaymentDtlsVC.m
//  PM247
//


#import "PaymentDtlsVC.h"
#import "GlobalDirector.h"
#import "PaymentDtlsCell.h"
#import "PaymentTransactionDtls.h"
#import "CreateCustomerVC.h"
#import <SquareInAppPaymentsSDK/SQIPInAppPaymentsSDK.h>
#import <SquareInAppPaymentsSDK/SQIPCardEntryViewController.h>
#import <SquareInAppPaymentsSDK/SQIPTheme.h>

#import "SquareUpPaymentDetailsVC.h"
#import "SquareInAppPaymentsSDK/SQIPCardDetails.h"

#import "SquareBuyerVerificationSDK/SQIPBuyerAction.h"
#import "SquareBuyerVerificationSDK/SQIPContact.h"
#import "SquareBuyerVerificationSDK/SQIPVerificationParameters.h"
#import "SquareBuyerVerificationSDK/SQIPBuyerVerificationSDK.h"
#import "SquareBuyerVerificationSDK/SQIPBuyerVerifiedDetails.h"
#import "SquareBuyerVerificationSDK/SQIPMoney.h"



@interface PaymentDtlsVC () < SQIPCardEntryViewControllerDelegate>
{
    CGFloat currX;
}
@end

@implementation PaymentDtlsVC
@synthesize dictJob;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    currX=2.0f;
    arrImages = [[NSMutableArray alloc] init];
    _tblPayment.rowHeight = UITableViewAutomaticDimension;
    _tblPayment.estimatedRowHeight = 100.0;
    [self GetPaymentDetails];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
           selector:@selector(invoiceLinkGeneratedNotification:)
           name:@"INVOICE_LINK_GENERATED_NOTIFICATION"
           object:nil];
}

- (void)dealloc {
    NSLog(@"dealloc*********");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) invoiceLinkGeneratedNotification:(NSNotification *) notification
{
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *invoiceLink = [userInfo objectForKey:@"invoice_link"];
    
    [self dismissViewControllerAnimated:NO completion:^{
        if (invoiceLink != nil) {
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = invoiceLink;
            
            NSArray* sharedObjects=[NSArray arrayWithObjects:invoiceLink,  nil];
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedObjects applicationActivities:nil];
            activityViewController.popoverPresentationController.sourceView = self.view;
                
          //  [self presentViewController:activityViewController animated:YES completion:nil];
     
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Link Generated" message:[NSString stringWithFormat:@"Link has been generated successfully./n%@",invoiceLink] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:NULL];
            }];
            
            [alertController addAction:actionOk];
            
//            UIAlertAction *actionCopy = [UIAlertAction actionWithTitle:@"Copy Link" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//                pasteboard.string = invoiceLink;
//                [self dismissViewControllerAnimated:YES completion:NULL];
//            }];
            
//            [alertController addAction:actionCopy];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }];
    
    
    
}

- (IBAction)ClickBack:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)ClickCancel:(UIButton *)sender {
    [KLCPopup dismissAllPopups];
}

- (IBAction)ClickSubmit:(UIButton *)sender {
    
    
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:_txtAmt.text];
    
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    
    float amount = [strAmtDue floatValue];
    
    if (isEdit) {
        amount = amount+editedAmount;
    }
    
    if (_txtPayType.tag==0 || _txtPayType.tag==-1) {
        [self showAlert:@"Please select payment type." withTitle:@"Error"];
    }else if (_txtAmt.text.length==0){
        [self showAlert:@"Please fill up amount." withTitle:@"Error"];
    }else if ([_txtAmt.text floatValue]>amount){
        [self showAlert:@"The amount cannot be greater than due amount." withTitle:@"Error"];
    }else if ([_txtAmt.text floatValue]<= 0) {
        [GlobalDirector showAleart:@"Please enter amount." ctrl:self];
    }else if (stringIsValid==NO) {
        [GlobalDirector showAleart:@"Please enter valid amount." ctrl:self];
    }else{
        [KLCPopup dismissAllPopups];
        if (_txtVDes.text.length==0) {
            _txtVDes.text=@"";
        }
        
        
        if ((_txtPayType.tag == 14 || _txtPayType.tag == 15)  && isEdit == NO) {  //real
            //  if (_txtPayType.tag == 144 || _txtPayType.tag == 154 ) { //fake
            
            NSString *invoice = [GlobalDirector ReplaceStringNull:[dictJob valueForKey:@"InvoiceNumberID"]] ;
            if (invoice.length>0) {
                PaymentTransactionDtls *dtls = [[PaymentTransactionDtls alloc] initWithNibName:@"PaymentTransactionDtls" bundle:nil];
                
                
                NSMutableDictionary *dictDtls = [[NSMutableDictionary alloc] init];
                
                [dictDtls setObject:[GlobalDirector ReplaceStringNull:[dictJob valueForKey:@"JobID"]] forKey:@"jobId"];
                [dictDtls setObject:[GlobalDirector ReplaceStringNull:_txtVDes.text] forKey:@"description"];
                [dictDtls setObject:[GlobalDirector ReplaceStringNull:_txtAmt.text] forKey:@"amount"];
                [dictDtls setObject:[NSString stringWithFormat:@"%ld",(long)_txtPayType.tag] forKey:@"paymentMethodId"];
                [dictDtls setObject:[NSString stringWithFormat:@"%ld",(long)jobPaymentId] forKey:@"jobPaymentId"];
                
                dtls.dictJob = dictJob;
                dtls.dictPaymentMethod = dictDtls;
                dtls.arrImages=arrImages;
                [self.navigationController pushViewController:dtls animated:YES];
            }
            else{
                UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"info"
                                                                                    message:@"please allocate an invoice number to proceed with payment."
                                                                             preferredStyle: UIAlertControllerStyleAlert];
                
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                                      style: UIAlertActionStyleDestructive
                                                                    handler: ^(UIAlertAction *action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                }];
                
                [controller addAction: alertAction];
                
                [self presentViewController: controller animated: YES completion: nil];
            }
            
        }
        else if ((_txtPayType.tag == 4)  && isEdit == NO) { // SQUARE UP LINK
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PaymentStoryboard" bundle: nil];
            CreateCustomerVC * vc = [storyboard instantiateViewControllerWithIdentifier:@"CreateCustomerVC"];
            //[[CreateCustomerVC alloc] initWithNibName:@"CreateCustomerVC" bundle:nil];
            
            NSMutableDictionary *dictDtls = [[NSMutableDictionary alloc] init];
            [dictDtls setObject:[GlobalDirector ReplaceStringNull:_txtAmt.text] forKey:@"amount"];
            [dictDtls setObject:_outStandingAmount forKey:@"DueAmount"];

            vc.dictJob=dictJob;
            vc.dictPaymentMethod = dictDtls;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else if ((_txtPayType.tag == 19)  && isEdit == NO) { // SQUARE UP CARD
            [self showCardEntryViewController];
        }
        else{
            
            MBProgressHUD   *hudd=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hudd.labelText=@"Please wait...";
            [hudd show:YES];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
            [dict setObject:[GlobalDirector ReplaceStringNull:[dictJob valueForKey:@"JobID"]] forKey:@"jobId"];
            [dict setObject:[GlobalDirector ReplaceStringNull:_txtVDes.text] forKey:@"description"];
            [dict setObject:[GlobalDirector ReplaceStringNull:_txtAmt.text] forKey:@"amount"];
            [dict setObject:[NSString stringWithFormat:@"%ld",(long)_txtPayType.tag] forKey:@"paymentMethodId"];
            [dict setObject:[NSString stringWithFormat:@"%ld",(long)jobPaymentId] forKey:@"jobPaymentId"];
            [dict setObject:@"" forKey:@"transactionId"];
            
            NSString *base64String;
            NSMutableArray *arrImgExit=[[NSMutableArray alloc] init];
            
            NSMutableArray *arrImageSrtrings=[[NSMutableArray alloc]init];
            for (ImageViewCat *imgvw in arrImages)
            {
                if (imgvw.strURL.length==0) {
                    NSData *imageData = UIImageJPEGRepresentation(imgvw.image, 0.2);
                    base64String = [imageData base64EncodedStringWithOptions:0];
                    NSString *encodedImageString = [base64String stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
                    [arrImageSrtrings addObject:encodedImageString];
                }else{
                    
                    [arrImgExit addObject:imgvw.strURL];
                    
                }
            }
            
            NSMutableDictionary *dicNotes = [[NSMutableDictionary alloc] init];
            
            if (arrImageSrtrings.count>0) {
                [dicNotes setObject:arrImageSrtrings forKey:@"ImageUpload"];
                [dicNotes setObject:@"jpg" forKey:@"ImageExtension"];
            }
            
            
            NSError *error;
            NSArray *arrDic=[NSArray arrayWithObjects:dicNotes, nil];
            
            NSData *jsonAddress = [NSJSONSerialization dataWithJSONObject:arrDic
                                                                  options:0
                                                                    error:&error];
            
            
            
            NSString *note = [[NSString alloc] initWithBytes:[jsonAddress bytes] length:[jsonAddress length] encoding:NSUTF8StringEncoding];
            
            
            [dict setObject:note forKey:@"note"];
            NSString *exit=@"";
            if ([arrImgExit count]>0) {
                exit = [arrImgExit componentsJoinedByString:@","];
            }
            
            [dict setObject:exit forKey:@"existingImagePaths"];
            
            
            GlobalDirector *globe= [GlobalDirector SharedDirector];
            [globe SyncRequestPostWithJson:REQUEST_SaveJobPayment withPrams:dict andCompletionHandler:^(NSDictionary *result) {
                NSLog(@"%@",result);
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    
                    @try{
                        
                        int code = [[[result valueForKey:@"SaveJobPaymentResult"] valueForKey:@"ResponseCode"] intValue] ;
                        
                        if (code==0) {
                            if (!isEdit) {
                                [self showAlert:@"Payment successful" withTitle:@"info"];
                            }
                            
                            
                        }else{
                            [self showAlert:[GlobalDirector ReplaceStringNull:[[result valueForKey:@"SaveJobPaymentResult"] valueForKey:@"ResponseMessages"]] withTitle:@"Error"];
                        }
                        
                        
                        [self GetPaymentDetails];
                        
                        [hudd hide:YES];
                        
                    } @catch (NSException *exception) {
                        [self showAlert:@"There are some problem right now, try again later. " withTitle:@"Sorry!"];
                    }
                });
                
            }];
        }
        
    }
}

- (void)showCardEntryViewController
{
    SQIPTheme *theme = [[SQIPTheme alloc] init];
    //theme.errorColor = .red
    //theme.keyboardAppearance = .light
    //theme.messageColor = .magenta
    theme.saveButtonTitle = @"Submit";
    
    SQIPCardEntryViewController *cardEntryForm = [[SQIPCardEntryViewController alloc] initWithTheme:theme];
    cardEntryForm.collectPostalCode = true;
    cardEntryForm.delegate = self;
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:cardEntryForm];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)CancelPicker:(UIButton *)sender {
    [popPicker dismiss:YES];
}

- (IBAction)PickerDone:(UIButton *)sender {
    
    [popPicker dismiss:YES];
}

- (void)GetPaymentDetails
{
    
    MBProgressHUD   *hudd=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudd.labelText=@"Loading...";
    [hudd show:YES];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    [dict setObject:[GlobalDirector ReplaceStringNull:[dictJob valueForKey:@"JobID"]] forKey:@"jobId"];
    
    GlobalDirector *globe= [GlobalDirector SharedDirector];
    [globe SyncRequestGet:REQUEST_GetJobPayments withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        NSLog(@"%@",result);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [hudd hide:YES];
            @try{
                
                self->strAmtDue = self->_outStandingAmount;
                self->desc = [self->dictJob valueForKey:@"JobDescription"];
                if ([self->strAmtDue intValue]>0) {
                    self->_viewTakePayment.hidden=NO;
                }else{
                    self->_viewTakePayment.hidden=YES;
                }
                
                self->arrPayments = [result valueForKey:@"JobPayments"];
                [self->_tblPayment reloadData];
                
                
            } @catch (NSException *exception) {
                [self showAlert:@"There are some problem right now, try again later. " withTitle:@"Sorry!"];
            }
        });
        
    }];
}

-(void) GetSquareUpInvoiceID
{
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    [dict setObject:[GlobalDirector ReplaceStringNull:[dictJob valueForKey:@"JobID"]] forKey:@"jobId"];

    GlobalDirector *globe = [GlobalDirector SharedDirector];
    
    //  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [globe SyncRequestGet:REQUEST_GetSquareUpInvoiceID withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        
        NSLog(@"%@",result);
        
        
        // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            @try {
                
                
                BOOL strValue= [[result valueForKey:@"ResponseStatus"] intValue];
                
                if (strValue==1) {
                    
                    //[self showAlert:[GlobalDirector ReplaceStringNull:[result valueForKey:@"ReturnValue"]] withTitle:@"Success"];
                    
                }else{
                    //[self showAlert:[GlobalDirector ReplaceStringNull:[result valueForKey:@"ReturnValue"]] withTitle:@"Error!"];
                }
            } @catch (NSException *exception) {
                // _txtPost.text=@"";
                [self showAlert:@"There are some problem right now, try again later " withTitle:@"Sorry!"];
            }
        });
    }];
}


-(void) GetInvoice:(NSString *)urlStr
{
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    [dict setObject:urlStr forKey:@"invoiceId"];

    GlobalDirector *globe = [GlobalDirector SharedDirector];
    
    //  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [globe SyncRequestGet:REQUEST_GetInvoice withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        
        NSLog(@"%@",result);
        
        
        // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            @try {
                
                
                BOOL strValue= [[result valueForKey:@"ResponseStatus"] intValue];
                
                if (strValue==1) {
                    
                    //[self showAlert:[GlobalDirector ReplaceStringNull:[result valueForKey:@"ReturnValue"]] withTitle:@"Success"];
                    
                }else{
                    //[self showAlert:[GlobalDirector ReplaceStringNull:[result valueForKey:@"ReturnValue"]] withTitle:@"Error!"];
                }
            } @catch (NSException *exception) {
                // _txtPost.text=@"";
                [self showAlert:@"There are some problem right now, try again later " withTitle:@"Sorry!"];
            }
        });
    }];
}

-(IBAction)crossNoteDesc:(id)sender
{
    [KLCPopup dismissAllPopups];
}


- (IBAction)ClickSquareUpStatus:(UIButton *)sender {
    SquareUpPaymentDetailsVC *vc = [[SquareUpPaymentDetailsVC alloc] initWithNibName:@"SquareUpPaymentDetailsVC" bundle:nil];
    vc.dictJob=dictJob;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)ClickTakePayment:(UIButton *)sender {
    
    jobPaymentId=sender.tag;
    _totalBytes=0;
    _receivedBytes=0;
    currX=2.0f;
    arrImages = [[NSMutableArray alloc] init];
    for (UIView *subview in imgScroll.subviews) {
        [subview removeFromSuperview];
    }
    
    
    [imgAttacted setImage:nil];
    _txtPayType.text=@"";
    _txtVDes.text=@"";
    _txtAmt.text=strAmtDue;
    _txtVDes.text = desc;
    MBProgressHUD   *hudd=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudd.labelText=@"Loading...";
    [hudd show:YES];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    
    
    GlobalDirector *globe= [GlobalDirector SharedDirector];
    [globe SyncRequestGet:REQUEST_GetPaymentModeList withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        NSLog(@"%@",result);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            @try{
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                NSDictionary *dict = @{@"DisplayText":@"Please select type of payment",@"Value":@"-1"};
                
                self->arrModeList = [NSMutableArray arrayWithObject:dict];
                [self->arrModeList addObjectsFromArray:[result valueForKey:@"DataResponses"]] ;
                
                
                NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];

                int i;
                int u_Type = [[userdetails valueForKey:@"UserType"] intValue];
                
                for (i = 0; i<[self->arrModeList count]; i++) {
                    NSDictionary *dictInner = self->arrModeList[i];
                    if([dictInner[@"Value"]  isEqual: @"14"]){
                        // Remove Card
                        [self->arrModeList removeObjectAtIndex:i];
                    }
                    if(u_Type == 4 && [dictInner[@"Value"] isEqual:@"4"])
                    {
                        // Square up Link removed from Eng login
                        [self->arrModeList removeObjectAtIndex:i];
                    }
                    
                    if([dictInner[@"Value"] isEqual:@"15"])
                    {
                        // Dabit Square removed
                        [self->arrModeList removeObjectAtIndex:i];
                    }
                }
                

                
                //Remove payment link
                
                [hudd hide:YES];
                
                
                
                KLCPopup *pop=    [KLCPopup popupWithContentView:_viewPop showType:KLCPopupShowTypeGrowIn dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
                
                
                [pop show];
                [self performSelector:@selector(popupFieldSetup) withObject:nil];
                
            } @catch (NSException *exception) {
                [self showAlert:@"There are some problem right now, try again later. " withTitle:@"Sorry!"];
            }
        });
        
    }];
    
}


-(void)popupFieldSetup{
    
    if (jobPaymentId==0) {
        _txtPayType.userInteractionEnabled=YES;
        _txtAmt.userInteractionEnabled=YES;
        isEdit = NO;
    }else{
        isEdit = YES;
        if (_txtPayType.tag==14) {
            _txtPayType.userInteractionEnabled=NO;
            _txtAmt.userInteractionEnabled=NO;
        }else{
            _txtPayType.userInteractionEnabled=YES;
            _txtAmt.userInteractionEnabled=YES;
        }
        
    }
}


#pragma mark- UItextview delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField ==_txtPayType) {
        
        popPicker =    [KLCPopup popupWithContentView:_viewPicker showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeBounceOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
        
        
        KLCPopupLayout layout =  KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom);
        [popPicker showWithLayout:layout];
        [popPicker show];
        return NO;
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - SQIPCardEntryViewControllerDelegate

- (void)cardEntryViewController:(nonnull SQIPCardEntryViewController *)cardEntryViewController
          didCompleteWithStatus:(SQIPCardEntryCompletionStatus)status;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cardEntryViewController:(nonnull SQIPCardEntryViewController *)cardEntryViewController
           didObtainCardDetails:(nonnull SQIPCardDetails *)cardDetails
              completionHandler:(void (^_Nonnull)(NSError *_Nullable))completionHandler;
{
    double amountFloat = ([_txtAmt.text floatValue]);
    NSNumber *finalAmount = [NSNumber numberWithLong:(long)(amountFloat * 100)];
    NSInteger amountMoney = [finalAmount intValue];
    
    SQIPVerificationParameters *params = [self makeVerificationParameters:cardDetails.nonce buyerAction:[SQIPBuyerAction chargeActionWithMoney:[[SQIPMoney alloc] initWithAmount:amountMoney currency:SQIPCurrencyGBP]]];
    
    [SQIPBuyerVerificationSDK.shared verifyWithParameters:params theme:[self makeSquareTheme] viewController:cardEntryViewController success:^(SQIPBuyerVerifiedDetails * _Nonnull verifiedDetails) {
        NSLog(@"nonce = %@", cardDetails.nonce);
        NSLog(@"verificationToken = %@", verifiedDetails.verificationToken);
        
        [self squareUpPaymentAPI:cardDetails.nonce verificationTokenId: verifiedDetails.verificationToken completionHandler:^(NSString * paymentId) {
            if (paymentId != nil) {
                [self chargeAPI:paymentId verificationTokenId: verifiedDetails.verificationToken  completionHandler:^(NSError *error) {
                    completionHandler(error);
                }];
            } else {
                NSError * error = [NSError errorWithDomain:@"test" code:404 userInfo:nil];
                completionHandler(error);
            }
        }];
        
//        completionHandler(nil);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        completionHandler(error);
    }];
    
    /*
    [self squareUpPaymentAPI:cardDetails.nonce completionHandler:^(NSString * paymentId) {
        if (paymentId != nil) {
            [self chargeAPI:paymentId completionHandler:^(NSError *error) {
                completionHandler(error);
            }];
        } else {
            NSError * error = [NSError errorWithDomain:@"test" code:404 userInfo:nil];
            completionHandler(error);
        }
    }];
     */
}


- (void) chargeAPI:(NSString *)paymentId verificationTokenId:(NSString *) verificationTokenId completionHandler: (void (^_Nonnull)(NSError *_Nullable))completionHandler;

{
    
    MBProgressHUD   *hudd=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudd.labelText=@"Please wait...";
    [hudd show:YES];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    [dict setObject:[GlobalDirector ReplaceStringNull:[dictJob valueForKey:@"JobID"]] forKey:@"jobId"];
    [dict setObject:[GlobalDirector ReplaceStringNull:_txtVDes.text] forKey:@"description"];
    [dict setObject:[GlobalDirector ReplaceStringNull:_txtAmt.text] forKey:@"amount"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)_txtPayType.tag] forKey:@"paymentMethodId"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)jobPaymentId] forKey:@"jobPaymentId"];
    
    [dict setObject:paymentId forKey:@"transactionId"];
    
    NSString *base64String;
    NSMutableArray *arrImgExit=[[NSMutableArray alloc] init];
    
    NSMutableArray *arrImageSrtrings=[[NSMutableArray alloc]init];
    for (ImageViewCat *imgvw in arrImages)
    {
        if (imgvw.strURL.length==0) {
            NSData *imageData = UIImageJPEGRepresentation(imgvw.image, 0.2);
            base64String = [imageData base64EncodedStringWithOptions:0];
            NSString *encodedImageString = [base64String stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
            [arrImageSrtrings addObject:encodedImageString];
        }else{
            
            [arrImgExit addObject:imgvw.strURL];
        }
    }
    
    NSMutableDictionary *dicNotes = [[NSMutableDictionary alloc] init];
    
    if (arrImageSrtrings.count>0) {
        [dicNotes setObject:arrImageSrtrings forKey:@"ImageUpload"];
        [dicNotes setObject:@"jpg" forKey:@"ImageExtension"];
    }
    
    
    NSError *error;
    NSArray *arrDic=[NSArray arrayWithObjects:dicNotes, nil];
    
    NSData *jsonAddress = [NSJSONSerialization dataWithJSONObject:arrDic
                                                          options:0
                                                            error:&error];
    
    
    
    NSString *note = [[NSString alloc] initWithBytes:[jsonAddress bytes] length:[jsonAddress length] encoding:NSUTF8StringEncoding];
    
    
    [dict setObject:note forKey:@"note"];
    NSString *exit=@"";
    if ([arrImgExit count]>0) {
        exit = [arrImgExit componentsJoinedByString:@","];
    }
    
    [dict setObject:exit forKey:@"existingImagePaths"];
    
    GlobalDirector *globe= [GlobalDirector SharedDirector];
    NSLog(@"Param %@",dict);
//    NSLog(@"Url %@",REQUEST_SaveJobPayment);

    [globe SyncRequestPostWithJson:REQUEST_SaveJobPayment withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        NSLog(@"%@",result);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            @try{
                
                int code = [[[result valueForKey:@"SaveJobPaymentResult"] valueForKey:@"ResponseCode"] intValue] ;
                
                if (code==0) {
                    if (!self->isEdit) {
                        //[self showAlert:@"Payment successful" withTitle:@"info"];
                    }
                    
                    
                }else{
                    //[self showAlert:[GlobalDirector ReplaceStringNull:[[result valueForKey:@"SaveJobPaymentResult"] valueForKey:@"ResponseMessages"]] withTitle:@"Error"];
                }

                [self GetPaymentDetails];
                
                
                [hudd hide:YES];
                
                completionHandler(nil);
                
            } @catch (NSException *exception) {
                completionHandler(error);
                //[self showAlert:@"There are some problem right now, try again later. " withTitle:@"Sorry!"];
            }
        });
        
    }];
}

-(void)squareUpPaymentAPI:(NSString *)sourceId verificationTokenId:(NSString *)verificationTokenId completionHandler:(void (^_Nonnull)(NSString *_Nullable))completionHandler;
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
        
        urlString=[NSString stringWithFormat:@"%s%@",squareUpBaseURL, @"payments"];
        
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
        NSMutableDictionary *amountMoney=[[NSMutableDictionary alloc]init];
        double amountFloat = ([_txtAmt.text floatValue]);
        NSNumber *finalAmount = [NSNumber numberWithLong:(long)(amountFloat * 100)];
        [amountMoney setValue:finalAmount forKey:@"amount"];
        [amountMoney setValue:@"GBP" forKey:@"currency"];
        [body setValue:amountMoney forKey:@"amount_money"];
        [body setValue:sourceId forKey:@"source_id"];
        [body setValue:verificationTokenId forKey:@"verification_token"];
        
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
                    NSLog(@"%@", dict);
                    NSString *paymentId = [dict valueForKeyPath:@"payment.id"];
                    completionHandler(paymentId);
                } else {
                    completionHandler(nil);
                }
            });
            
        }];
        [_dataTask resume];
        
    }
}

-(SQIPVerificationParameters *)makeVerificationParameters:(NSString *)paymentSourceID buyerAction:(SQIPBuyerAction *)buyerAction;
{
    SQIPContact *contact = [[SQIPContact alloc] init];
    NSArray *users = [dictJob valueForKey:@"JobPeopleListResponse"];
    NSDictionary * user = [users firstObject];
    NSDictionary *jobAddr = [[dictJob valueForKey:@"JobAddrListResponse"] firstObject];
    NSArray *addressLines = [[[jobAddr valueForKey:@"Address"] componentsSeparatedByString:@","] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
    NSString *city = [jobAddr valueForKey:@"City"];
    NSString *postCode = [jobAddr valueForKey:@"PostCode"];
    
    contact.givenName = [user valueForKey:@"FirstName"];
    contact.familyName = [user valueForKey:@"LastName"];
    contact.email = [user valueForKey:@"EmailAddress"];
    contact.addressLines = addressLines;
    contact.city = city;
    contact.country = SQIPCountryGB;
    contact.postalCode = postCode;
    contact.phone = [user valueForKey:@"ContactNumber"];

    SQIPVerificationParameters *params = [[SQIPVerificationParameters alloc] initWithPaymentSourceID:paymentSourceID buyerAction:buyerAction locationID:@squareUpLocationId contact:contact];
    return params;
}

-(SQIPTheme *)makeSquareTheme;
{
    SQIPTheme *theme = [[SQIPTheme alloc] init];
    theme.errorColor = [UIColor redColor];
    //theme.tintColor = Color.primaryAction
    //theme.keyboardAppearance = .light
    //theme.messageColor = Color.descriptionFont
    return theme;
}


#pragma mark -  TableView Delegate Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([arrPayments count]>0) {
        return [arrPayments count];
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 115.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return UITableViewAutomaticDimension;
    //return 95.0;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([arrPayments count]>0) {
        
        static NSString *CellIdentifier = @"PaymentDtlsCell";
        PaymentDtlsCell  *cell=(PaymentDtlsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // tableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tab_page.png"]];
        if(cell==nil)
        {
            cell =(PaymentDtlsCell*)[BaseTableCell cellFromNibNamed:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSDictionary *dic = [arrPayments objectAtIndex:indexPath.row];
        
        cell.lblPayTaken.text= [NSString stringWithFormat:@"Payment Taken: %@",[GlobalDirector ReplaceStringNull:[dic valueForKey:@"CreatedBy"]]];
        cell.lblPaydate.text= [NSString stringWithFormat:@"Payment Date: %@",[GlobalDirector ReplaceStringNull:[dic valueForKey:@"CreatedOn"]]];
        cell.lblPayAmt.text= [NSString stringWithFormat:@"Payment Amount: %.02f",[[GlobalDirector ReplaceStringNull:[dic valueForKey:@"Amount"]] floatValue]];
        
        NSString *des = [GlobalDirector ReplaceStringNull:[dic valueForKey:@"Description"]];
        if (des.length>0) {
            cell.linkTextView.hidden=NO;
            cell.linkTextView.text= [NSString stringWithFormat:@"Description: %@",[GlobalDirector ReplaceStringNull:[dic valueForKey:@"Description"]]] ;
            cell.linkTextViewHeight.constant = 50.0;

        }else{
            cell.linkTextViewHeight.constant = 0.0;

            cell.linkTextView.text=@"";
            cell.linkTextView.hidden=YES;
            
        }
        // cell.lblDes.text= [NSString stringWithFormat:@"Description: %@",[GlobalDirector ReplaceStringNull:[dic valueForKey:@"Description"]]] ;
        
        cell.lblTranType.text= [NSString stringWithFormat:@"Transaction Type: %@",[GlobalDirector ReplaceStringNull:[dic valueForKey:@"PaymentMethodName"]]] ;
        
        NSString *tran = [GlobalDirector ReplaceStringNull:[dic valueForKey:@"TransactionID"]];
        
        if (tran.length>0) {
            cell.lblTranID.text= [NSString stringWithFormat:@"Transaction ID: %@",[GlobalDirector ReplaceStringNull:[dic valueForKey:@"TransactionID"]]] ;
            
            cell.lblTranID.hidden=NO;
            
            
        }else{
            cell.lblTranID.text=@"";
            cell.lblTranID.hidden=YES;
            
        }
        
        
        
        NSArray *arr= [dic valueForKey:@"ImagePath"];
        
        // NSString *imgUrl=  [GlobalDirector ReplaceStringNull:[dic valueForKey:@"ImagePath"]];
        cell.btnAttachment.tag=indexPath.row;
        [cell.btnAttachment addTarget:self action:@selector(btnAttachmentPress:) forControlEvents:UIControlEventTouchUpInside];
        if (arr.count>0) {
            cell.btnAttachment.hidden=NO;
            
        }else{
            cell.btnAttachment.hidden=YES;
            
        }
        return cell;
        
    }else{
        static NSString *cellid=@"CELL";
        UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
        cell.textLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
        cell.textLabel.text=@"No payment history to show";
        return cell;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fm"])
    {
        //return
        // isEdit = YES;
        index=indexPath.row;
        NSDictionary *dic = [arrPayments objectAtIndex:indexPath.row];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag=[[GlobalDirector ReplaceStringNull:[dic valueForKey:@"JobPaymentID"]] intValue];
        [self ClickTakePayment:btn];
        
        _txtAmt.text= [GlobalDirector ReplaceStringNull:[dic valueForKey:@"Amount"]];
        editedAmount = [[GlobalDirector ReplaceStringNull:[dic valueForKey:@"Amount"]]intValue];
        _txtVDes.text=[GlobalDirector ReplaceStringNull:[dic valueForKey:@"Description"]];
        _txtPayType.text= [GlobalDirector ReplaceStringNull:[dic valueForKey:@"PaymentMethodName"]];
        _txtPayType.tag= [[GlobalDirector ReplaceStringNull:[dic valueForKey:@"PaymentMethodID"]] intValue];
        
        [arrImages removeAllObjects];
        NSArray *arr= [dic valueForKey:@"ImagePath"];
        if (arr.count>0) {
            
            for (NSString *url in arr) {
                
                NSString *urlCorrect = [url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
                [self ScrollImgSetup:urlCorrect];
                
            }
            
        }
    }
    
}


#pragma mark- UIpicker view delegate

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (int)arrModeList.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *dict=[arrModeList objectAtIndex:row];
    return [GlobalDirector ReplaceStringNull:[dict valueForKey:@"DisplayText"]];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSDictionary *dict=[arrModeList objectAtIndex:row];
    _txtPayType.text= [GlobalDirector ReplaceStringNull:[dict valueForKey:@"DisplayText"]];
    _txtPayType.tag= [[GlobalDirector ReplaceStringNull:[dict valueForKey:@"Value"]] intValue];
    
    
}



-(void)animateToActiveButton:(UIButton *)btn withImageview:(UIImageView *)img
{
    img.backgroundColor=[UIColor whiteColor];
    [UIView animateWithDuration:0.35 animations:^{
        img.frame=btn.frame;
        
    }];
}


-(IBAction)btnAttachFileTapped:(id)sender{
    
    
    if (arrImages.count==4) {
        
        [self showAlert:@"Maximum 4 image can be uploaded at a time" withTitle:@"Sorry!"];
        
        
    }
    
    else
    {
        mainBgNoteDesc = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
        mainBgNoteDesc.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
        
        
        UIView *vw=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 150)];
        vw.backgroundColor=[UIColor whiteColor];
        vw.center=CGPointMake(CGRectGetWidth(mainBgNoteDesc.frame)/2.0f, CGRectGetHeight(mainBgNoteDesc.frame)/2.0f);
        
        
        UIButton * btnSelectCam=[UIButton buttonWithType:UIButtonTypeCustom];
        btnSelectCam.frame=CGRectMake(0, 0, 120, 120);
        //btnSelectCam.center=CGPointMake(CGRectGetMaxX(bgVwNoteDesc.frame),CGRectGetMinY(bgVwNoteDesc.frame));
        [btnSelectCam setTitle:@"From Camera" forState:UIControlStateNormal];
        btnSelectCam.center=CGPointMake(CGRectGetWidth(vw.frame)/2.0f-CGRectGetWidth(btnSelectCam.frame)/2.0f-2, CGRectGetHeight(vw.frame)/2.0f);
        btnSelectCam.titleLabel.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
        [btnSelectCam setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btnSelectCam addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
        btnSelectCam.layer.borderColor=[[UIColor grayColor]CGColor];
        btnSelectCam.layer.borderWidth=2.0f;
        
        
        
        UIButton * btnSelectGallery=[UIButton buttonWithType:UIButtonTypeCustom];
        btnSelectGallery.frame=CGRectMake(0, 0, 120, 120);
        btnSelectGallery.center=CGPointMake(CGRectGetWidth(vw.frame)/2.0f+CGRectGetWidth(btnSelectGallery.frame)/2.0f+2, CGRectGetHeight(vw.frame)/2.0f);
        //btnSelectGallery.center=CGPointMake(CGRectGetMaxX(bgVwNoteDesc.frame),CGRectGetMinY(bgVwNoteDesc.frame));
        [btnSelectGallery setTitle:@"From gallery" forState:UIControlStateNormal];
        btnSelectGallery.titleLabel.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
        [btnSelectGallery setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btnSelectGallery addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
        btnSelectGallery.layer.borderColor=[[UIColor grayColor]CGColor];
        btnSelectGallery.layer.borderWidth=2.0f;
        
        [vw addSubview:btnSelectCam];
        [vw addSubview:btnSelectGallery];
        
        
        btnCrossNoteDesc=[UIButton buttonWithType:UIButtonTypeCustom];
        btnCrossNoteDesc.frame=CGRectMake(0, 0, 25, 25);
        btnCrossNoteDesc.center=CGPointMake(CGRectGetMaxX(vw.frame),CGRectGetMinY(vw.frame));
        [btnCrossNoteDesc setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
        [btnCrossNoteDesc addTarget:self action:@selector(ClosePopUpAndClearData) forControlEvents:UIControlEventTouchUpInside];
        [btnCrossNoteDesc clipsToBounds];
        
        
        [mainBgNoteDesc addSubview:vw];
        [mainBgNoteDesc addSubview:btnCrossNoteDesc];
        
        popImage = [KLCPopup popupWithContentView:mainBgNoteDesc showType:KLCPopupShowTypeGrowIn dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
        
        
        [popImage show];
        
        
        
    }
    
    
    
}


-(void)ClosePopUpAndClearData
{
    
    
    [popImage dismiss:YES];
    _totalBytes=0;
    _receivedBytes=0;
    currX=2.0f;
    [arrImages removeAllObjects];
}


- (IBAction)takePhoto:(UIButton *)sender {
    
    DLog(@"%@",[[UIDevice currentDevice] model]);
    
    if (![[[UIDevice currentDevice] model]isEqualToString:@"iPhone Simulator"]) {
        
        
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo
{
    
    DLog(@"imageview subview :- %@",imgScroll.subviews);
    [self ScrollImgSetup:img];
    [popImage dismiss:YES];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



-(void)ScrollImgSetup:(id)img
{
    
    ImageViewCat *imgvw=[[ImageViewCat alloc]initWithFrame:CGRectMake(currX+2, 2, 80, 80)];
    imgvw.userInteractionEnabled=YES;
    
    if ([img isKindOfClass:[NSString class]]) {
        //        [imgvw sd_setImageWithURL:[NSURL URLWithString:(NSString*)img]];
        imgvw.strURL=(NSString*)img;
        
    }else{
        imgvw.strURL = @"";
        imgvw.image=(UIImage*)img;
    }
    
    
    UIButton *btnDlt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 18)];
    btnDlt.center=CGPointMake(CGRectGetWidth(imgvw.frame)/2.0f, CGRectGetHeight(imgvw.frame)-CGRectGetHeight(btnDlt.frame)/2.0f);
    btnDlt.backgroundColor=[UIColor colorWithWhite:0.1 alpha:0.5];
    [btnDlt setTitle:@"Remove" forState:UIControlStateNormal];
    btnDlt.titleLabel.textAlignment=NSTextAlignmentCenter;
    [btnDlt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDlt.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    [btnDlt addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    btnDlt.tag=arrImages.count+1;
    imgvw.tag=arrImages.count+1+100;
    [imgvw addSubview:btnDlt];
    imgScroll.contentSize=CGSizeMake(currX+80, imgScroll.frame.size.height);
    currX=CGRectGetMaxX(imgvw.frame);
    [imgScroll addSubview:imgvw];
    [arrImages addObject:imgvw];
}



-(IBAction)deleteImage:(UIButton *)sender{
    DLog(@"tapped Arr count ::-%lu",(unsigned long)arrImages.count);
    
    DLog(@"senderctag::-%lu\n\nNo of subviews ::%@",(unsigned long)sender.tag,[imgScroll subviews]);
    CGFloat currXimg=0.0f;
    int i=1;
    
    NSMutableArray *toDestroy = [NSMutableArray arrayWithCapacity:arrImages.count];
    for (UIImageView *vw in arrImages) {
        
        
        if ([vw isKindOfClass:[UIImageView class]]) {
            
            UIImageView *imgVw=(UIImageView *)vw;
            if (imgVw.tag-100 == sender.tag) {
                [imgVw removeFromSuperview];
                [toDestroy addObject:[arrImages objectAtIndex:sender.tag-1]];
                currX=currX-CGRectGetWidth(imgVw.frame);
                imgVw=nil;
            }
        }
        
    }
    
    [arrImages removeObjectsInArray:toDestroy];
    
    
    for (UIImageView *vw in arrImages) {
        
        vw.frame=CGRectMake(currXimg+2, CGRectGetMinY(vw.frame), CGRectGetWidth(vw.frame), CGRectGetHeight(vw.frame));
        currXimg=CGRectGetMaxX(vw.frame);
        vw.tag=i+100;
        for (UIButton *btn in [vw subviews]) {
            btn.tag=i;
            
        }
        i++;
        
        imgScroll.contentSize=CGSizeMake(CGRectGetWidth(vw.frame)*i, imgScroll.frame.size.height);
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [popImage dismiss:YES];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}




-(IBAction)btnAttachmentPress:(UIButton *)sender
{
    DLog(@"sender.tag ::: %ld",(long)sender.tag);
    NSDictionary *dic =[arrPayments objectAtIndex:sender.tag];
    
    
    DLog(@"dicdicdic :%@",dic);
    NSArray *arr=(NSArray *) [dic valueForKey:@"ImagePath"];
    mainBgNoteDesc = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    mainBgNoteDesc.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(bgVwNoteDesc.frame),CGRectGetMinY(bgVwNoteDesc.frame)-25,300,25)];
    lblTitle.text = @"  Attachments";
    lblTitle.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.backgroundColor =[UIColor colorWithRed:52/255.0 green:54/255.0 blue:67/255.0 alpha:0.72];
    [lblTitle.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [lblTitle.layer setBorderWidth: 1.0];
    [lblTitle.layer setCornerRadius:4.0f];
    [lblTitle.layer setMasksToBounds:YES];
    
    currX=20.0f;
    for (int i=0;i<[arr count];i++)
    {
        bgVwNoteDesc = [[UIView alloc] initWithFrame:CGRectMake(currX,0,300,360)];
        bgVwNoteDesc.center=CGPointMake(bgVwNoteDesc.center.x, self.view.frame.size.height/2.0f);
        
        [bgVwNoteDesc.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
        [bgVwNoteDesc.layer setBorderWidth: 0.5];
        [bgVwNoteDesc.layer setCornerRadius:4.0f];
        [bgVwNoteDesc.layer setMasksToBounds:YES];
        bgVwNoteDesc.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
        
        
        NSString *urlStr=[arr objectAtIndex:i];
        //urlStr=[urlStr stringByReplacingOccurrencesOfString:@"\\\\" withString:@""];
        
        NSURL *url = [NSURL URLWithString:[urlStr stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        
        
        // NSURL *url = [NSURL URLWithString:[[arr objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        DLog(@"urlurlurlurlurlurlurlurl %@",url);
        
        
        
        webV=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 300, 360)];
        
        webV.center=CGPointMake(CGRectGetWidth(bgVwNoteDesc.frame)/2.0f, CGRectGetHeight(bgVwNoteDesc.frame)/2.0f);
        webV.backgroundColor=[UIColor lightGrayColor];
        webV.delegate=self;
        [webV loadRequest:[NSURLRequest requestWithURL:url]];
        [webV setScalesPageToFit:YES];
        [bgVwNoteDesc addSubview:webV];
        
        hud=[MBProgressHUD showHUDAddedTo:webV animated:YES];
        hud.labelText = @"Loading...";
        
        
        
        btnCrossNoteDesc=[UIButton buttonWithType:UIButtonTypeCustom];
        btnCrossNoteDesc.frame=CGRectMake(0, 0, 25, 25);
        btnCrossNoteDesc.center=CGPointMake(CGRectGetMaxX(webV.frame)-15,CGRectGetMinY(webV.frame)+15);
        [btnCrossNoteDesc setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
        [btnCrossNoteDesc addTarget:self action:@selector(crossNoteDescc:) forControlEvents:UIControlEventTouchUpInside];
        [btnCrossNoteDesc clipsToBounds];
        currX=currX+CGRectGetWidth(bgVwNoteDesc.frame)+10 ;
        [mainBgNoteDesc addSubview:bgVwNoteDesc];
        [bgVwNoteDesc addSubview:btnCrossNoteDesc];
        [self.view addSubview:mainBgNoteDesc];
    }
    mainBgNoteDesc.contentSize=CGSizeMake(currX, mainBgNoteDesc.frame.size.height);
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:webView animated:YES];
    
}

-(void)crossNoteDescc:(id)sender
{
    [mainBgNoteDesc removeFromSuperview];
    _totalBytes=0;
    _receivedBytes=0;
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    DLog(@"%@",touch.view);
    if ([touch.view isDescendantOfView:_tblPayment])
    {
        return NO;
    }
    return YES;
}


@end
