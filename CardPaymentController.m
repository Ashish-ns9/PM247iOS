//
//  CardPaymentController.m
//  PM247
//


#import "CardPaymentController.h"
#import "GlobalDirector.h"
#import "PaymentDtlsCell.h"
#import "ImageViewCat.h"
#include <ifaddrs.h>
#include <arpa/inet.h>



@interface CardPaymentController ()
{
    GlobalDirector *globe;
    MBProgressHUD *hudshow;
    
    UIWebView *webView;
    NSString *tID;
//    WKWebViewConfiguration *theConfiguration;
//    WKUserContentController *controller;
   
    float amount;
}
@end

@implementation CardPaymentController
@synthesize dictJob,dictPaymentDtls,selfPaymentDtlsPage;
 NSString *myString;
- (void)viewDidLoad {
    [super viewDidLoad];
    Count=0;
    myString = [self getIPAddress];
    NSLog(@"%@", myString);

    
    // Do any additional setup after loading the view, typically from a nib.
    globe = [GlobalDirector SharedDirector];
    _arrMonth = [[NSArray alloc] init];
    _arrYears = [[NSMutableArray alloc] init];
    _arrSaveCardBool = [[NSMutableArray alloc] init];
    _arrCards = [[NSMutableArray alloc] init];
    operationType = @"";

    isCardOpen=NO;
  
    
    
    amount = [[GlobalDirector ReplaceStringNull:selfPaymentDtlsPage.txtAmount.text] floatValue];
    
    [_btnPay setTitle:[NSString stringWithFormat:@"Pay £%.02f", amount] forState:UIControlStateNormal];
    
    NSString *authStr = [NSString stringWithFormat:@"%s:%s", integrationKey, integrationPassword];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    autKey = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    
    isCardFrontView = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self GetCustomerCardDetails];
}

-(void)GetCustomerCardDetails{
     NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *arr=[selfPaymentDtlsPage.dictJob objectForKey:@"JobPeopleListResponse"];
    NSString *custID=@"";
    
    if (!arr) {
        arr = [NSArray array];
    }
    
    if (arr.count>0) {
        
        
        for ( NSDictionary *dic  in arr) {
            
            if ([[dic valueForKey:@"CustID"]integerValue]>0)
            {
                custID = [GlobalDirector ReplaceStringNull:[dic valueForKey:@"CustID"]];
            }
            
        }
    }
    
    
    [dict setValue:custID forKey:@"customerId"];

    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
   
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    // [dict setObject:jobID forKey:@"jobID"];
    
    
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [globe SyncRequestGet:REQUEST_GetCustomerCardDetails withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        
        
        
        
       
        dispatch_async(dispatch_get_main_queue(), ^{
            DLog(@"%@",result);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            @try {
               
                
                NSArray *arr = [result valueForKey:@"ItemList"];
                _arrCards = [[NSMutableArray alloc] initWithArray:arr];
                
            } @catch (NSException *exception) {
                
                    _arrCards = [[NSMutableArray alloc] init];
                
            }@finally{
                
                
                
                if(_arrCards.count>0){
                    
                    for (NSDictionary *dict in _arrCards) {
                        
                        [_arrSaveCardBool addObject:[NSNumber numberWithInt:0]];
                    }
                    
                   
                    [_tblList reloadData];
                }else{
                  
                }
                
                
                
            }
        });
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)Payment:(UIButton *)sender {
    
    
    
    NSArray *arrTxt = [NSArray arrayWithObjects:_txtCardName,_txtCardNumber,_txtExpiry,_txtccv, nil];
    
    if (_txtCardName.text.length==0) {
        [GlobalDirector TextFieldErrorShow:arrTxt];
        [GlobalDirector showAleart:textfieldError ctrl:self];
    }else if (_txtCardNumber.text.length<10){
        
       [GlobalDirector TextFieldErrorShow:arrTxt];
        [GlobalDirector showAleart:textfieldError ctrl:self];
    }else if (_txtExpiry.text.length==0){
        
       [GlobalDirector TextFieldErrorShow:arrTxt];
        [GlobalDirector showAleart:textfieldError ctrl:self];
    }else if (_txtccv.text.length<3){
       [GlobalDirector TextFieldErrorShow:arrTxt];
        [GlobalDirector showAleart:textfieldError ctrl:self];
    }else{
        [self GetMerchantSessonKey];
    }
    
}



-(void)GetMerchantSessonKey{
    
  hudshow =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudshow.dimBackground =YES;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSString stringWithFormat:@"%s",vendorName] forKey:@"vendorName"];
    
    
   /* [globe SyncRequestPostURL:[NSString stringWithFormat:@"%s%s",Sageconn_url,sageMerchantSessionKey] withPrams:dict authorizationKey:[NSString stringWithFormat:@"%s",integrationKey] authorizationPWD:[NSString stringWithFormat:@"%s",integrationPassword] andCompletionHandler:^(NSDictionary *result) {*/
    
    [globe SyncRequestPostURL:[NSString stringWithFormat:@"%s%s",Sageconn_url,sageMerchantSessionKey] withPrams:dict authorizationKey:autKey  andCompletionHandler:^(NSDictionary *result) {
       
        NSLog(@"%@", result);
        if ([result valueForKey:@"merchantSessionKey"]) {
            _strMerchantSessionKey = [GlobalDirector ReplaceStringNull:[result valueForKey:@"merchantSessionKey"]];
            [self performSelectorOnMainThread:@selector(GetCardIdentifiers:) withObject:_strMerchantSessionKey waitUntilDone:YES];
        }else{
            [self performSelectorOnMainThread:@selector(HideProgressHUD) withObject:nil waitUntilDone:NO];
            NSLog(@"Error on payment.");
            [GlobalDirector showAleart:[GlobalDirector ReplaceStringNull:[result valueForKey:@"clientMessage"]] ctrl:self];
            [hudshow hide:YES];
        }
   
        
    }];
    
   
    
}



-(void)GetCardIdentifiers:(NSString*)sessonKey{
    
    NSString *month = @"";
    
    NSString *m = [NSString stringWithFormat:@"%d",_mm];
    
    if (_mm>0 && _mm<10 && m.length==1) {
        
        month = [NSString stringWithFormat:@"0%d",_mm];
    }else{
        month = [NSString stringWithFormat:@"%d",_mm];
    }

    NSString *cardNumber = [_txtCardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSString stringWithFormat:@"%@", _txtCardName.text] forKey:@"cardholderName"];
    [dict setValue:cardNumber forKey:@"cardNumber"];
    [dict setValue:[NSString stringWithFormat:@"%@%d",month,_year] forKey:@"expiryDate"];
    [dict setValue:[NSString stringWithFormat:@"%@",_txtccv.text] forKey:@"securityCode"];
    
    NSMutableDictionary *mainDict =[[NSMutableDictionary alloc] init];
    [mainDict setObject:dict forKey:@"cardDetails"];
    
    [globe SyncRequestPostURL:[NSString stringWithFormat:@"%s%s",Sageconn_url,sagecard_identifiers] withPrams:mainDict authorizationKey:[NSString stringWithFormat:@"Bearer %@",sessonKey] andCompletionHandler:^(NSDictionary *result) {
                
            
        NSLog(@"%@", result);
        if ([result valueForKey:@"cardIdentifier"]) {
            
            
            _dictCardIdentifire = result;
            [self performSelectorOnMainThread:@selector(GetTranjactionProceed:) withObject:_dictCardIdentifire waitUntilDone:YES];
            
        }else{
            [self performSelectorOnMainThread:@selector(HideProgressHUD) withObject:nil waitUntilDone:NO];
            NSArray *arrErrors = [result valueForKey:@"errors"];
            NSDictionary *dicterror = [arrErrors objectAtIndex:0];
            [GlobalDirector showAleart:[GlobalDirector ReplaceStringNull:[dicterror valueForKey:@"clientMessage"]] ctrl:self];
           
            NSLog(@"Error on payment.");
            NSLog(@" client message is%@", [dicterror valueForKey:@"clientMessage"]);

        }
        
    }];
}

-(void)HideProgressHUD{
      [hudshow hide:YES];
}

-(void)GetTranjactionProceed:(NSDictionary*)dictCard{
    
    NSString *des = [GlobalDirector ReplaceStringNull:[selfPaymentDtlsPage.dictJob valueForKey:@"InvoiceNumberID"]] ;
    NSString *cusFirstname = [GlobalDirector ReplaceStringNull:selfPaymentDtlsPage.txtFirstName.text] ;
    NSString * custLastname = [GlobalDirector ReplaceStringNull:selfPaymentDtlsPage.txtLastName.text] ;
    
     NSString * street = [GlobalDirector ReplaceStringNull:selfPaymentDtlsPage.txtAddress.text] ;
     NSString * city = [GlobalDirector ReplaceStringNull:selfPaymentDtlsPage.txtCity.text] ;
     NSString * postcode = [GlobalDirector ReplaceStringNull:selfPaymentDtlsPage.txtPostcode.text] ;
  //  NSString * county = [GlobalDirector ReplaceStringNull:selfPaymentDtlsPage.txtCounty.text] ;
   
    if([des isEqualToString:@"-1"]){
        des = @"N/A";
    }
        
    
    des = [NSString stringWithFormat:@"Invoice ID %@",des];
    
    
    if (selfPaymentDtlsPage.txtVDes.text.length>0) {
        des = [NSString stringWithFormat:@"%@, %@",des,selfPaymentDtlsPage.txtVDes.text];
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSString stringWithFormat:@"Payment"] forKey:@"transactionType"];
    
   // [dict setObject:[NSNumber numberWithFloat:amount]  forKey:@"amount"];//for float
    
    int ant =  amount*100 ;
    
    [dict setObject:[NSNumber numberWithInt:ant]  forKey:@"amount"]; //for int
    
    [dict setValue:[NSString stringWithFormat:@"GBP"] forKey:@"currency"];
    [dict setValue:des forKey:@"description"];
    [dict setValue:[NSString stringWithFormat:@"UseMSPSetting"] forKey:@"apply3DSecure"];
    
    
    [dict setValue:cusFirstname forKey:@"customerFirstName"];
    [dict setValue:custLastname forKey:@"customerLastName"];
    [dict setValue:[NSString stringWithFormat:@"MailOrder"] forKey:@"entryMethod"];
   
    [dict setObject:[NSNumber numberWithInt:ant] forKey:@"amount"];
    
    NSMutableDictionary *authentication = [[NSMutableDictionary alloc] init];
//
  [authentication setValue:[NSString stringWithFormat:@"https://pm247uat.azurewebsites.net/Admin/Payments/Validate3DTransaction"] forKey:@"notificationURL"];
    [authentication setValue:[NSString stringWithFormat:@"%@", myString] forKey:@"browserIP"];
    [authentication setValue:[NSString stringWithFormat:@"text/html, application/json"] forKey:@"browserAcceptHeader"];
    [authentication setValue:[NSString stringWithFormat:@"false"] forKey:@"browserJavascriptEnabled"];
    [authentication setValue:[NSString stringWithFormat:@"en-GB"] forKey:@"browserLanguage"];
    [authentication setValue:[NSString stringWithFormat:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:67.0) Gecko/20100101 Firefox/67.0"] forKey:@"browserUserAgent"];
    [authentication setValue:[NSString stringWithFormat:@"Small"] forKey:@"challengeWindowSize"];
    [authentication setValue:[NSString stringWithFormat:@"GoodsAndServicePurchase"] forKey:@"transType"];

    [dict setObject:authentication forKey:@"strongCustomerAuthentication"];
    

    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSString * txtCode =  [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *invoice = [GlobalDirector ReplaceStringNull:[selfPaymentDtlsPage.dictJob valueForKey:@"InvoiceNumberID"]] ;
    
    if([invoice isEqualToString:@"-1"]){
        invoice = @"";
    }
    
    if (invoice.length>0)
    {
         [dict setValue:[NSString stringWithFormat:@"%@_%@",invoice,txtCode ] forKey:@"vendorTxCode"];
    }else{
        [dict setValue:[NSString stringWithFormat:@"%@",txtCode ] forKey:@"vendorTxCode"];
    }
    
    NSMutableDictionary *dictC = [[NSMutableDictionary alloc] init];
    [dictC setObject:[GlobalDirector ReplaceStringNull:_strMerchantSessionKey] forKey:@"merchantSessionKey"];
    [dictC setObject:[GlobalDirector ReplaceStringNull:[GlobalDirector ReplaceStringNull:[dictCard valueForKey:@"cardIdentifier"]]] forKey:@"cardIdentifier"];
    [dictC setObject:[GlobalDirector ReplaceStringNull:[dictCard valueForKey:@"false"]] forKey:@"save"];
    NSMutableDictionary *dictPay = [[NSMutableDictionary alloc] init];
    
    [dictPay setObject:dictC forKey:@"card"];
    
    [dict setObject:dictPay forKey:@"paymentMethod"];
    [dict setObject:@"4.00" forKey:@"vpsprotocol"];

    NSMutableDictionary *address = [[NSMutableDictionary alloc] init];
    [address setValue:street forKey:@"address1"];
    [address setValue:city forKey:@"city"];
    [address setValue:postcode forKey:@"postalCode"];
    [address setValue:@"GB" forKey:@"country"];
    
    [dict setObject:address forKey:@"billingAddress"];
    
    [globe SyncRequestPostURL:[NSString stringWithFormat:@"%s%s",Sageconn_url,transactions] withPrams:dict authorizationKey:autKey andCompletionHandler:^(NSDictionary *result)
     {
        
        
        [self performSelectorOnMainThread:@selector(HideProgressHUD) withObject:nil waitUntilDone:NO];
        NSLog(@"Tranjection:%@",result);
        dispatch_async(dispatch_get_main_queue(), ^
    {
            NSArray *arr  = [result valueForKey:@"errors"];
        NSString *code = [GlobalDirector ReplaceStringNull:[result valueForKey:@"statusCode"]] ;
        NSString *status = [GlobalDirector ReplaceStringNull:[result valueForKey:@"status"]] ;
            
            
        if ([code isEqualToString:@"0000"] && [status isEqualToString:@"Ok"]) {
            if (btnIsSave.selected) {
                operationType = @"I";
              
            }else{
               operationType = @"";
            }
            
            // [self performSelectorOnMainT-hread:@selector(SaveCardDetails:) withObject:nil waitUntilDone:NO];
            NSString *tranID = [GlobalDirector ReplaceStringNull:[result valueForKey:@"transactionId"]];
            [self performSelectorOnMainThread:@selector(SavePayments:) withObject:tranID waitUntilDone:NO];
            
        }
        else
        {
            
            NSLog(@"Error on payment.");
            
            printf("This is code from response %s",[code UTF8String]);
              operationType = @"I";
             [self performSelectorOnMainThread:@selector(HideProgressHUD) withObject:nil waitUntilDone:NO];
            NSString *dtls = [GlobalDirector ReplaceStringNull:[result valueForKey:@"statusDetail"]];
            if ((dtls.length>0) && ([code isEqualToString:@"2007"])) {
              //   [GlobalDirector showAleart:dtls ctrl:self];
               webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                NSString *termUrl = [NSString stringWithFormat:@"%s" , term_url_segpayresponse];
                NSString *ascUrl = [GlobalDirector ReplaceStringNull:[result valueForKey:@"acsUrl"]];
                NSString *paraReq =  [GlobalDirector ReplaceStringNull:[result valueForKey:@"paReq"]];
                NSString *md = [GlobalDirector ReplaceStringNull:[result valueForKey:@"transactionId"]];
                tID = md;
                printf("md string we got  %s",[md UTF8String]);
                webView.delegate = self;
                NSString *templateString = [[NSBundle mainBundle] pathForResource:@"3d_secure_page" ofType:@"html"];
                NSString *template = [NSString stringWithContentsOfFile:templateString encoding:NSUTF8StringEncoding error:nil];
                 printf("template string we have  %s",[template UTF8String]);
                NSMutableString *htmlContentString = [[NSMutableString alloc] initWithString:template];
                [htmlContentString replaceOccurrencesOfString:@"[[ascurl]]" withString:ascUrl options:NSLiteralSearch range:NSMakeRange(0, htmlContentString.length)];
                [htmlContentString replaceOccurrencesOfString:@"[[paRes]]" withString:paraReq options:NSLiteralSearch range:NSMakeRange(0, htmlContentString.length)];
                [htmlContentString replaceOccurrencesOfString:@"[[TermUrl]]" withString:termUrl options:NSLiteralSearch range:NSMakeRange(0, htmlContentString.length)];
                [htmlContentString replaceOccurrencesOfString:@"[[MD]]" withString:md options:NSLiteralSearch range:NSMakeRange(0, htmlContentString.length)];
                [webView setScalesPageToFit:YES];
                [webView loadHTMLString:htmlContentString baseURL:nil];
                [self.view addSubview:webView];
               }else
               {
                   
            [GlobalDirector showAleart:[result valueForKey:@"statusDetail"] ctrl:self];
            }
        }
        });
        
    }];

}
- (NSString *)appURL
{
    return [[[NSBundle mainBundle] URLForResource:@"3d_secure_page" withExtension:@"html"] absoluteString];
}


- (IBAction)ClickBack:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
   
}
- (IBAction)Cancelcard:(UIButton *)sender {
    
    [KLCPopup dismissAllPopups];
}



-(UIImage*)getCardImage :(NSString*)numberString
{
    
    
    OLCreditCardType type =   [Luhn typeFromString:numberString];
    
    //  NSLog(@"CardType: %ld  String:%@",(long)type,textField.text);
    
    switch (type) {
        case OLCreditCardTypeAmex:
            // [_imgCard setImage:[UIImage imageNamed:@"amex.png"]];
            numberString=@"amexCardLogo.png";
            break;
            
        case OLCreditCardTypeVisa:
            // [_imgCard setImage:[UIImage imageNamed:@"visa.png"]];
            numberString=@"visaCardLogo.png";
            break;
            
        case OLCreditCardTypeMastercard:
            // [_imgCard setImage:[UIImage imageNamed:@"mastercard.png"]];
            numberString=@"masterCardLogo.png";
            break;
            
        case OLCreditCardTypeDiscover:
            //[_imgCard setImage:[UIImage imageNamed:@"discover.png"]];
            numberString=@"discoverCardLogo.png";
            break;
            
        case OLCreditCardTypeDinersClub:
            //[_imgCard setImage:[UIImage imageNamed:@"diners.png"]];
            numberString=@"diners.png";
            break;
            
        case OLCreditCardTypeJCB:
            //[_imgCard setImage:[UIImage imageNamed:@"jcb.png"]];
            numberString=@"jcb.png";
            break;
            
        case OLCreditCardTypeUnsupported:
            // [_imgCard setImage:[UIImage imageNamed:@"placeholder.png"]];
            numberString=@"placeholder.png";
            break;
            
        case OLCreditCardTypeInvalid:
            //  [_imgCard setImage:[UIImage imageNamed:@"placeholder.png"]];
            numberString=@"placeholder.png";
            break;
            
        default:
            break;
    }
    
    
    NSString *filename = [NSString stringWithFormat:@"%@", numberString];
    
    return [UIImage imageNamed:filename];
    
}



- (IBAction)ClickSave:(UIButton *)sender {
    if (sender.selected) {
        sender.selected=NO;
    }else{
        sender.selected=YES;
    }
}





# pragma mark- UItextfield deligate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    int len =20;
    
    if (textField == _txtccv || textField.tag == 501) {
        len =4;
    }else if (textField == _txtCardNumber){
        len = 20;
    }else{
        len = 40;
    }
    
  
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
   
    if (newLength>len) {
        return NO;
    }
    
    
    NSLog(@"%@ : %@",textField.text,string);
    
    NSString *actualTxt = @"";
    
    if (string.length>0) {
        actualTxt = [NSString stringWithFormat:@"%@%@",textField.text,string];
        
       
    }else{
        actualTxt = [textField.text substringToIndex:textField.text.length-1];
        
    }
    

    if (textField==_txtCardName) {
        if (!isCardFrontView) {
            isCardFrontView=YES;
            [card flip];
        }
        
        //card.cardHoldersName = actualTxt;
        card.cardNumberLabel.text = actualTxt;
    }
    
    if (textField==_txtCardNumber) {
        
        
        NSString *strnumber = actualTxt;;
        
        [_imgCard setImage:[self getCardImage:strnumber]];
        
        
    }
    
    if (textField==_txtCardNumber) {
        if (!isCardFrontView) {
            isCardFrontView=YES;
            [card flip];
        }
        
        //card.cardNumber = actualTxt;
        card.cardNumberLabel.text = actualTxt;
        
        if (string.length>0) {
            textField.text = [self stringByFormattingAsCreditCardNumber:[NSString stringWithFormat:@"%@%@",textField.text,string]];
             return NO;
         }
       
    }
    
    if (textField==_txtccv) {
        
        //card.cvv = actualTxt;
        card.cvvLabel.text = actualTxt;
        if (isCardFrontView) {
            isCardFrontView=NO;
             [card flip];
        }
       
    }
    
    

    
    
    
  
    return YES;
    
}


- (NSString *)stringByFormattingAsCreditCardNumber:(NSString*)aNumber
{
    NSMutableString *stringWithAddedSpaces = [[NSMutableString alloc] init];
    aNumber = [aNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    for (NSUInteger i=0; i<[aNumber length]; i++) {
        if ((i>0) && ((i % 4) == 0)) {
            [stringWithAddedSpaces appendString:@" "];
        }
        unichar characterToAdd = [aNumber characterAtIndex:i];
        NSString *stringToAdd =
        [NSString stringWithCharacters:&characterToAdd length:1];
        
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    
    return stringWithAddedSpaces;
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //textField.layer.borderColor=[[UIColor blackColor]CGColor];
    //textField.layer.borderWidth= 1.0f;
    textField.rightView.hidden=YES;
    
    if (textField.tag ==501) {
        
        CGPoint pnt = [_tblList convertPoint:textField.bounds.origin fromView:textField];
        NSIndexPath* path = [_tblList indexPathForRowAtPoint:pnt];
        [_tblList scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
        // NSIndexPath *indexPath = [_tblList indexPathForCell:cell];
    }
    
    if (textField ==_txtExpiry) {
        
        [self GetYearList];
        return NO;
    }
    
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //    UITouch * touch = [touches anyObject];
    //    if(touch.phase == UITouchPhaseBegan) {
    //        [aTextField resignFirstResponder];
    //    }
    
    [self.view endEditing:YES];
}


-(void)GetYearList{
    
    [self.view endEditing:YES];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    int i2  = [[formatter stringFromDate:[NSDate date]] intValue];
    
    int countYear = i2+60;
    
    //Create Years Array from 1960 to This year
    _arrYears = [[NSMutableArray alloc] init];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    _arrMonth = [df shortMonthSymbols];
    
    
    for (int i=i2; i<=countYear; i++) {
        [_arrYears addObject:[NSString stringWithFormat:@"%d",i]];
    }
    _picker.tag=1;
    [_picker reloadAllComponents];
    
    KLCPopup *pop=    [KLCPopup popupWithContentView:_pickerView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToTop maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    
    
    [pop showWithLayout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
     [self setupMonthYearWithRow:0 inComponent:0];[self setupMonthYearWithRow:0 inComponent:1];
    
}



- (IBAction)PopupDismiss:(UIButton *)sender {
    
    [self.view endEditing:YES];
    [KLCPopup dismissAllPopups];
    
}



#pragma mark-Delegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component==0) {
        
        return [_arrMonth count];
        
    }else{
        
        return [_arrYears count];
        
    }
    
    
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
     if (component==0) {
     if (_arrMonth) {
     return [NSString stringWithFormat:@"%@ (%ld)",[GlobalDirector ReplaceStringNull:[_arrMonth objectAtIndex:row]],row+1];
     
     }else{
     return@"";
     }
     }else{
     
     if (_arrYears) {
     return [GlobalDirector ReplaceStringNull:[_arrYears objectAtIndex:row]];
     }else{
     return@"";
     }
     }
    
   
    
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    [self setupMonthYearWithRow:row inComponent:component];
    
}

-(void)setupMonthYearWithRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component==0) {
        
        _mm= (int)row+1;
    }else{
        
        NSString *year = [GlobalDirector ReplaceStringNull:[_arrYears objectAtIndex:row]];
        
        _year =  [[year substringWithRange:NSMakeRange(1, year.length-1)] intValue];
        
    }
    
    NSString *month = @"";
    
    if (_mm>0 && _mm<10) {
        
        month = [NSString stringWithFormat:@"0%d",_mm];
    }else{
        month = [NSString stringWithFormat:@"%d",_mm];
    }
    
    
    
    if (_mm>0 || _year>0) {
        
        if (_mm>0 && _year==0) {
            _txtExpiry.text = [NSString stringWithFormat:@"%@/",month];
        }else if (_mm==0 && _year>0)
        {
            _txtExpiry.text = [NSString stringWithFormat:@" /%d",_year];
        }else{
            _txtExpiry.text = [NSString stringWithFormat:@"%@/%d",month,_year];
        }
        
        
    }
}


#pragma mark- UItableview deligate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else{
        return [_arrCards count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f; // 0.0f does not work
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 5)];
    [view setBackgroundColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:0.69]];
    // [view setBackgroundColor:[UIColor lightGrayColor]];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    if (indexPath.section==0) {
        
        static NSString *CellIdentifier = @"NewCardCell";
        NewCardCell  *cell=(NewCardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // tableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tab_page.png"]];
        if(cell==nil)
        {
            cell =(NewCardCell*)[BaseTableCell cellFromNibNamed:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
       [_btnPay setTitle:[NSString stringWithFormat:@"Pay £%.02f",amount] forState:UIControlStateNormal];
        
        
        [viewCard setFrame:CGRectMake(0.0, 0.0,cell.contentView.frame.size.width, viewCard.frame.size.height)];
        
        
       
        [cell.contentView addSubview:viewCard];
        
        return cell;
       
        
    }
    else{
   
        static NSString *CellIdentifier = @"SaveCardCell";
        SaveCardCell  *cell=(SaveCardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // tableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tab_page.png"]];
        if(cell==nil)
        {
            cell =(SaveCardCell*)[BaseTableCell cellFromNibNamed:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    
    NSDictionary *dic = [_arrCards objectAtIndex:indexPath.row];
    
    
    NSString *strnumber= [NSString stringWithFormat:@"%@",[GlobalDirector ReplaceStringNull:[dic valueForKey:@"CardNumber"]]];
    
    NSString *lastFourString=[strnumber substringFromIndex:MAX((int)[strnumber length]-4, 0)];
    //in case string is less than 4 characters long.
    
    NSLog(@"trimmedString :%@",lastFourString);
    cell.lblCardNumber.text= [NSString stringWithFormat:@"XXXXXXXXXXXX %@",lastFourString];
    
    
    [ cell.imgType setImage:[self getCardImage:strnumber]];
    
    cell.btnPay.tag = indexPath.row;
    [cell.btnPay addTarget:self action:@selector(PressbtnPay:) forControlEvents:UIControlEventTouchUpInside];
    
        cell.txtCCV.tag=501;
        cell.txtCCV.delegate=self;
   
        [cell.btnPay setTitle:[NSString stringWithFormat:@"Pay £%.02f",amount] forState:UIControlStateNormal];
        
      
      
        
    
    cell.btnDelete.tag = indexPath.row;
    [cell.btnDelete addTarget:self action:@selector(PressDeleteCard:) forControlEvents:UIControlEventTouchUpInside];

    
    
    
    cell.BtnCvvInfo.tag = indexPath.row;
    [cell.BtnCvvInfo addTarget:self action:@selector(CVVPopUpOpen:) forControlEvents:UIControlEventTouchUpInside];
     cell.BtnCvvInfo.layer.cornerRadius =  cell.BtnCvvInfo.frame.size.width/2;
    cell.BtnCvvInfo.clipsToBounds = true ;
    
   return cell;
    }
 
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    if (indexPath.section==0) {
          NewCardCell  *cellZero = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
        
        for (int k = 0; k <_arrSaveCardBool.count; k++) {
            SaveCardCell  *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:k inSection:1]];
           
                cell.lblccv.hidden=YES;
                cell.txtCCV.hidden=YES;
                cell.BtnCvvInfo.hidden=YES;
                cell.btnDelete.hidden=YES;
                cell.btnPay.hidden=YES;
                cell.lblDescribtion.hidden=YES;
                [_arrSaveCardBool replaceObjectAtIndex:k withObject:[NSNumber numberWithInt:0]];
                cell.btnArrow.hidden=NO;
        }
        
        if (isCardOpen){
            isCardOpen=NO;
            viewCard.hidden=YES;
            cellZero.btnArrow.hidden=NO;
        }else{
            isCardOpen=YES;
            viewCard.hidden=NO;
             cellZero.btnArrow.hidden=YES;
        }
        
        
      
        
        
        
    }else{
    
    int isOpen = [[_arrSaveCardBool objectAtIndex:indexPath.row] intValue];
    
    if (isOpen==0) {
        isCardOpen=NO;
        viewCard.hidden=YES;
        NewCardCell  *cellZero = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
         cellZero.btnArrow.hidden=NO;
       // [_arrSaveCardBool replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:1]];
        for (int k = 0; k <_arrSaveCardBool.count; k++) {
             SaveCardCell  *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:k inSection:indexPath.section]];
            if (k==indexPath.row) {
                [UIView animateWithDuration:0.2 animations:^{
                    cell.lblccv.hidden=NO;
                    cell.txtCCV.hidden=NO;
                    cell.BtnCvvInfo.hidden=NO;
                    
                    cell.btnDelete.hidden=NO;
                    cell.btnPay.hidden=NO;
                    cell.lblDescribtion.hidden=NO;
                    cell.btnArrow.hidden=YES;
                }];
                 [_arrSaveCardBool replaceObjectAtIndex:k withObject:[NSNumber numberWithInt:1]];
            }else{
                cell.lblccv.hidden=YES;
                cell.txtCCV.hidden=YES;
                cell.BtnCvvInfo.hidden=YES;
                cell.btnDelete.hidden=YES;
                cell.btnPay.hidden=YES;
                cell.lblDescribtion.hidden=YES;
                 [_arrSaveCardBool replaceObjectAtIndex:k withObject:[NSNumber numberWithInt:0]];
                cell.btnArrow.hidden=NO;
            }
        }
        
    }else{
         SaveCardCell  *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [UIView animateWithDuration:0.2 animations:^{
            cell.lblccv.hidden=YES;
            cell.txtCCV.hidden=YES;
            cell.BtnCvvInfo.hidden=YES;
            cell.btnDelete.hidden=YES;
            cell.btnPay.hidden=YES;
            cell.lblDescribtion.hidden=YES;
            cell.btnArrow.hidden=NO;

            
            
        }];
         [_arrSaveCardBool replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:0]];
        
        
    }
    
   
    
    }
    
     [tableView reloadData];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.section==0) {
            
            if(isCardOpen){
                return 541.00;
            }else{
               return 50.00;
            }
            
        }else{
            int isOpen = 0;
            
            if (_arrSaveCardBool.count>0) {
                isOpen =  [[_arrSaveCardBool objectAtIndex:indexPath.row] intValue];
            }
            
            if (isOpen==1) {
                return 170.00;
            }else{
                return 50.00;
            }
            
        }
        
        
        
    }
    


-(void)SavePayments:(NSString*)strTranID {
    
    MBProgressHUD   *hudd=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudd.labelText=@"Please wait...";
    [hudd show:YES];
    
    
    NSString *des = [GlobalDirector ReplaceStringNull:[selfPaymentDtlsPage.dictJob valueForKey:@"InvoiceNumberID"]] ;
    if([des isEqualToString:@"-1"]){
        des = @"N/A";
    }
    
    
    des = [NSString stringWithFormat:@"Invoice ID %@",des];
    
    
    if (selfPaymentDtlsPage.txtVDes.text.length>0) {
        des = [NSString stringWithFormat:@"%@, %@",des,selfPaymentDtlsPage.txtVDes.text];
    }
    
    
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    [dict setObject:[GlobalDirector ReplaceStringNull:[selfPaymentDtlsPage.dictJob valueForKey:@"JobID"]] forKey:@"jobId"];
    [dict setObject:[GlobalDirector ReplaceStringNull:des] forKey:@"description"];
    [dict setObject:[NSString stringWithFormat:@"%.02f",amount] forKey:@"amount"];
    [dict setObject:[GlobalDirector ReplaceStringNull:[selfPaymentDtlsPage.dictPaymentMethod valueForKey:@"paymentMethodId"]] forKey:@"paymentMethodId"];
    [dict setObject:[GlobalDirector ReplaceStringNull:[selfPaymentDtlsPage.dictPaymentMethod valueForKey:@"jobPaymentId"]] forKey:@"jobPaymentId"];
    [dict setObject:strTranID forKey:@"transactionId"];
    
    
    
    

    NSString *base64String;
    NSMutableArray *arrImgExit=[[NSMutableArray alloc] init];
    
    NSMutableArray *arrImageSrtrings=[[NSMutableArray alloc]init];
    for (ImageViewCat *imgvw in selfPaymentDtlsPage.arrImages)
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
            @try{
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                int code = [[[result valueForKey:@"SaveJobPaymentResult"] valueForKey:@"ResponseCode"] intValue] ;
                
                if (code==0)
                {
                   
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"info"
                                                                                            message:@"Payment successful"
                                                                                     preferredStyle: UIAlertControllerStyleAlert];
                        
                        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                                              style: UIAlertActionStyleDestructive
                                                                            handler: ^(UIAlertAction *action) {
                                                                                [self dismissViewControllerAnimated:YES completion:nil];
                                                                                
                                                                            }];
                        
                        [controller addAction: alertAction];
                        
                        [self presentViewController: controller animated: YES completion: nil];
                        
                    });
                    
                  
                   
                }else{
                    [self showAlert:[GlobalDirector ReplaceStringNull:[[result valueForKey:@"SaveJobPaymentResult"] valueForKey:@"ResponseMessages"]] withTitle:@"Error"];
                }
                
                
                [self performSelectorOnMainThread:@selector(SaveCardDetails:) withObject:nil waitUntilDone:NO];
                
                
                [hudd hide:YES];
                
            } @catch (NSException *exception) {
                [self showAlert:@"There are some problem right now, try again later. " withTitle:@"Sorry!"];
            }
        });
        
    }];
    
}
 
   


-(void)SaveCardDetails:(NSDictionary*)dictCards{
    
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    
    NSArray *arr=[selfPaymentDtlsPage.dictJob objectForKey:@"JobPeopleListResponse"];
    NSString *custID=@"";
    
    if (!arr) {
        arr = [NSArray array];
    }
        
    if (arr.count>0) {
        
        
        for ( NSDictionary *dic  in arr) {
            
            if ([[dic valueForKey:@"CustID"]integerValue]>0) {
                custID = [GlobalDirector ReplaceStringNull:[dic valueForKey:@"CustID"]];
            }
            
        }
    }
    
    
     [dict setValue:custID forKey:@"CustID"];
    
    
    if (dictCards) {
        
        [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
        [dict setValue:operationType forKey:@"operationType"];
        [dict setValue:[GlobalDirector ReplaceStringNull:[dictCards valueForKey:@"CardDtlID"]] forKey:@"cardDtlID"];
        
        [dict setValue:@"" forKey:@"cardName"];
        [dict setValue:@"" forKey:@"cardNumber"];
        [dict setValue:[GlobalDirector ReplaceStringNull:[dictCards valueForKey:@"Expiry"]] forKey:@"expiryDate"];
        [dict setValue:@"" forKey:@"cardType"];
        [dict setValue:[selfPaymentDtlsPage.dictJob valueForKey:@""] forKey:@"CustID"];
       
        
        
    }else{
    NSString *month = @"";
    
    if (_mm>0 && _mm<10) {
        
        month = [NSString stringWithFormat:@"0%d",_mm];
    }else{
        month = [NSString stringWithFormat:@"%d",_mm];
    }

    
   
    
    
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    // [dict setObject:jobID forKey:@"jobID"];
    
   
    [dict setValue:[NSString stringWithFormat:@"%@", _txtCardName.text] forKey:@"cardName"];
    [dict setValue:[NSString stringWithFormat:@"%@",_txtCardNumber.text] forKey:@"cardNumber"];
    [dict setValue:[NSString stringWithFormat:@"%@/%d",month,_year] forKey:@"expiryDate"];
    [dict setValue:operationType forKey:@"operationType"];
    [dict setValue:@"" forKey:@"cardType"];
    [dict setValue:@"0" forKey:@"cardDtlID"];
    }
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
   
    [globe SyncRequestPost:REQUEST_SaveCardDetail withPrams:dict andCompletionHandler:^(NSDictionary *result) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            DLog(@"%@",result);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            int code = [[result valueForKey:@"ResponseCode"] intValue];
            if (code==0) {
                if (![operationType isEqualToString:@"I"]) {
                MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:NO];
                    hud.labelText=@"Delete successfully.";
                    [hud hide:YES afterDelay:0.3];
                }
            }else{
                
                [GlobalDirector showAleart:[GlobalDirector ReplaceStringNull:[result valueForKey:@"ResponseMessages"]] ctrl:self];
            }
           
             operationType = @"";
            
        });
        
    }];
   
    
}



-(void)ClickWithPayCard:(UIButton*)btn{
 //NewCardCell  *cell = [_tblList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    //cell.card.txtCvc
    
   
    
    
/*
if cardNumber.count <= 13 {
    error = "Please enter valid card number"
}else if viewExpiryMonth.labelValue.text! == "MM" {
    error = "Please Select Expiry Month"
}else if viewExpiryYear.labelValue.text! == "YYYY" {
    error = "Please Select Expiry Year"
}else if (txtCvc.text?.count)! < 3 {
    error = "Please enter valid Cvv"
}
if (error == "" || error == nil) {
    card = Card(holderName: txtCardName.text, number: cardNumber, month: Month(rawValue: viewExpiryMonth!.labelValue.text!)!, year: viewExpiryYear!.labelValue.text!, cvc: txtCvc.text!, paymentType: Card.PaymentType.card, cardType:addedCardType!, userId: 1)
}
*/


}



#pragma mark- Cvv pop up open Button call----
-(void)CVVPopUpOpen:(UIButton*)sender
{
    _lblCVC.layer.cornerRadius =  2;
    _lblCVC.clipsToBounds = true ;
    
    
    KLCPopup *pop=    [KLCPopup popupWithContentView:_ViewCVCPopUp showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToTop maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    
    [pop show];
    
    
    
}

-(void)PressbtnPay:(UIButton*)sender
{
    //(IBAction)Payment:(UIButton *)sender {
    // Your code here
    [[self view] endEditing:true];
     SaveCardCell  *cell = [_tblList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:1]];
    
    if (cell.txtCCV.text.length>0) {
         NSDictionary *dic = [_arrCards objectAtIndex:sender.tag];
        
        _txtCardName.text = [GlobalDirector ReplaceStringNull:[dic valueForKey:@"CardName"]];
        _txtCardNumber.text = [GlobalDirector ReplaceStringNull:[dic valueForKey:@"CardNumber"]];
        _txtExpiry.text = [GlobalDirector ReplaceStringNull:[dic valueForKey:@"Expiry"]];
        _txtccv.text = [GlobalDirector ReplaceStringNull:cell.txtCCV.text];
        
        NSArray *arr = [_txtExpiry.text componentsSeparatedByString:@"/"];
        
        _mm = [[arr objectAtIndex:0] intValue];
        _year = [[arr objectAtIndex:1] intValue];
        
        [self Payment:nil];
       
        
    }else{
        [self showAlert:@"Please enter CVC numner." withTitle:@"info"];
    }
   
    
}

#pragma mark- PressDeleteCard Button call----
-(void)PressDeleteCard:(UIButton*)sender
{
    NSDictionary *dict = [_arrCards objectAtIndex:sender.tag];
    [_arrCards removeObjectAtIndex:sender.tag];
    
    [_tblList reloadData];
    
    
    
    operationType = @"d";
    [self SaveCardDetails:dict];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
   
    if (navigationType == UIWebViewNavigationTypeFormSubmitted) {
        NSLog(@"link clicked = %@",request.mainDocumentURL);
        if ([[request.URL absoluteString] isEqualToString:[NSString stringWithFormat:@"%s" , term_url_segpayresponse]])
        {
            webView.hidden = YES;
//            hudshow =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hudshow.dimBackground =YES;
//            [hudshow hide:YES afterDelay:1.5];
        }
        
    }
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //NSLog("%@",@"hello");
    hudshow =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudshow.dimBackground =YES;
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
   NSLog(@"Error: %@", error);
    [self showAlert:@"Some error" withTitle:@"Error"];
    [hudshow show:YES];
    [hudshow hide:YES afterDelay:2.5];
    [webView removeFromSuperview];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
     [hudshow hide:YES];
    if ([[[[webView request] URL] absoluteString] isEqualToString:[NSString stringWithFormat:@"%s" , term_url_segpayresponse]])
    {
         NSLog(@"inside webViewDidFinishLoad: %@", [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"]);
        NSString *resultTemp  = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
        NSString *unencodedUrlString = [resultTemp stringByRemovingPercentEncoding];
        NSArray *items1 = [unencodedUrlString componentsSeparatedByString:@"&amp"];
        if (items1.count > 0)
        {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[[[items1 objectAtIndex:0] componentsSeparatedByString:@"PaRes="] objectAtIndex:1] forKey:@"paRes"];
        [dict setObject:[[[items1 objectAtIndex:1] componentsSeparatedByString:@";MD="] objectAtIndex:1] forKey:@"resMD"];
        [self validateTransaction:dict];
        }
        else {
            dispatch_sync(dispatch_get_main_queue(), ^{
              MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:NO];
                hud.labelText=@"3D Authorisation Unsuccessful.";
                [hud show:YES];
                [hud hide:YES afterDelay:2.5];
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.5 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            });
        }
      
  }
    else {
        
    }
}

-(void)validateTransaction:(NSMutableDictionary*)dict
{
    [hudshow hide:YES];
    MBProgressHUD   *hudd=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hudd.labelText=@"Please wait...";
    [hudd show:YES];
     NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
     [dict1 setValue:[dict objectForKey:@"paRes"] forKey:@"paRes"];
       [globe SyncRequestPostURL:[NSString stringWithFormat:@"%s%@%@%@",Sageconn_url,@"transactions/",[dict objectForKey:@"resMD"],@"/3d-secure"] withPrams:dict1 authorizationKey:autKey andCompletionHandler:^(NSDictionary *result)
        {
        NSLog(@"Tranjection:%@",result);
           
           if ([[result objectForKey:@"status"] isEqualToString:@"Authenticated"])
           {
             dispatch_sync(dispatch_get_main_queue(), ^{
                [hudd hide:YES];
                   MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:NO];
                   hud.labelText=@"3D Authorisation successful.";
                    [hud show:YES];
                   [hud hide:YES afterDelay:2.5];
               });
               //          [GlobalDirector sho
               dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.5 * NSEC_PER_SEC);
               dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                   [self performSelectorOnMainThread:@selector(SavePayments:) withObject:tID waitUntilDone:NO];
               });
              
           
          [GlobalDirector showAleart:@"3D Authorisation successful. Taking you back to Payments Page." ctrl:self];
          
           }
           else {
                dispatch_sync(dispatch_get_main_queue(), ^{
               [hudd hide:YES];
               MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:NO];
               hud.labelText=@"3D Authorisation Unsuccessful.";
               [hud show:YES];
               [hud hide:YES afterDelay:2.5];
               dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.5 * NSEC_PER_SEC);
               dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
               [self dismissViewControllerAnimated:YES completion:nil];
                     });
                });
           }

    }];
}

- (NSString *)getIPAddress
{
struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;

    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                //NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself

                if([name isEqualToString:@"en0"])
                {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                    break;
                }
                else
                    if([name isEqualToString:@"pdp_ip0"])
                        
                    {
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                        break;
                    }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
  

    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    
    return addr;
    

}



@end





















