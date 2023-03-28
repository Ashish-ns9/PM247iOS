//
//  GlobalDirector.m



#import "GlobalDirector.h"

@implementation GlobalDirector
@synthesize ctrl;
static GlobalDirector *singletonObject = nil;

+ (id) SharedDirector
{
    if (! singletonObject) {
        
        singletonObject = [[GlobalDirector alloc] init];
    }
    return singletonObject;
}

- (id)init
{
    if (! singletonObject) {
        
        singletonObject = [super init];
        // Uncomment the following line to see how many times is the init method of the class is called
        // NSLog(@"%s", __PRETTY_FUNCTION__);
    }
    return singletonObject;
}





#pragma mark- Send simple request with prams

-(void)SyncRequestPostWithJson:(int)reqID withPrams:(NSMutableDictionary*)dictPrams andCompletionHandler:(void (^)(NSDictionary *result))completionHandler
{
    
    // [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    
    
    
    
    NSError *error;
    NSURL* url = [NSURL URLWithString:[GlobalDirector urlForId:reqID]];
   //
   // NSLog(@"URL:%@",requestURL);  NSLog(@"Data:%@",dictPrams);
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictPrams
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"UR::%@  Json String:%@",jsonString,url);
    }
    
   // NSURL * url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [urlRequest setHTTPMethod:@"POST"];
  // [urlRequest setTimeoutInterval:300];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dictPrams options:0 error:&error];
    [urlRequest setHTTPBody:postData];

 
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.timeoutIntervalForResource = 300;
    sessionConfiguration.timeoutIntervalForRequest = 300;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // The server answers with an error because it doesn't receive the params
        
        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        
        
        if (error==nil) {
            
            NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
             
            completionHandler(dict);
            
            
        }else{
            NSLog(@"%@",error);
            completionHandler(nil);
            
        }
        
        
    }];
    
    
    [postDataTask resume];
    
    
    
}



-(void)SyncRequestPost:(int)reqID withPrams:(NSMutableDictionary*)dictPrams andCompletionHandler:(void (^)(NSDictionary *result))completionHandler{
    
    // [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    
   
    
    
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    NSURL* requestURL = [NSURL URLWithString:[GlobalDirector urlForId:reqID]];
    
     NSLog(@"URL:%@",requestURL);  NSLog(@"Data:%@",dictPrams);
    
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
   
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [[NSMutableData alloc] initWithLength:0];
    
    // add params (all params are strings)
    for (NSString *param in dictPrams) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dictPrams objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //  NSInputStream *stream =[[NSInputStream alloc] initWithData:body];
    
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    
    NSLog(@"URL:%@",requestURL);
    NSLog(@"%@",dictPrams);
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.timeoutIntervalForResource = 300;
    sessionConfiguration.timeoutIntervalForRequest = 300;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // The server answers with an error because it doesn't receive the params
        
        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        
        
        if (error==nil) {
            
            NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            
            
            
            completionHandler(dict);
            
            
        }else{
            NSLog(@"%@",error);
            completionHandler(nil);
            
        }
        
        
    }];
    
    
    [postDataTask resume];
    
    
}



-(void)SyncRequestGet:(int)reqID withPrams:(NSMutableDictionary*)dictPrams andCompletionHandler:(void (^)(NSDictionary *result))completionHandler{
    
    NSString *Prams=@"";
    
    for (NSString *key in [dictPrams allKeys]) {
        Prams =[Prams stringByAppendingFormat:@"%@=%@&",key,[dictPrams valueForKey:key]];
    }
    
    NSString *strURL=[NSString stringWithFormat:@"%@%@",[GlobalDirector urlForId:reqID],Prams];
    
    NSLog(@"URL:%@",strURL);
    
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   
    [self SyncGetWithURL:strURL andCompletionHandler:completionHandler];
    
}

-(void)SyncGetWithURL:(NSString*)strURL andCompletionHandler:(void (^)(NSDictionary *result))completionHandler{
    
    
    NSURL* requestURL = [NSURL URLWithString:strURL];
    
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.timeoutIntervalForResource = 300;
    sessionConfiguration.timeoutIntervalForRequest = 300;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"::::%@",str);
        
        
        if (error==nil) {
            
            NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            completionHandler(dict);
            
            
        }else{
            NSLog(@"%@",error);
            completionHandler(nil);
            
        }
        
        
    }];
    
    
    [postDataTask resume];
    
}



-(void)SyncRequestPostURL:(NSString*)reqURL withPrams:(NSMutableDictionary*)dictPrams authorizationKey:(NSString*)aut andCompletionHandler:(void (^)(NSDictionary *result))completionHandler{
    
    
    
    
    NSError *error;
    NSURL* url = [NSURL URLWithString:reqURL];
    //
    // NSLog(@"URL:%@",requestURL);  NSLog(@"Data:%@",dictPrams);
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictPrams
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"UR::%@  Json String:%@",jsonString,url);
    }
    
    
    // NSURL * url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest addValue:aut forHTTPHeaderField:@"Authorization"];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dictPrams options:0 error:&error];
    [urlRequest setHTTPBody:postData];
    
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.timeoutIntervalForResource = 300;
    sessionConfiguration.timeoutIntervalForRequest = 300;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // The server answers with an error because it doesn't receive the params
        
        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        
        
        if (error==nil) {
            
            NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            
            completionHandler(dict);
            
            
        }else{
            NSLog(@"%@",error);
            completionHandler(nil);
            
        }
        
        
    }];
    
    
    [postDataTask resume];
    
    
    
}













#pragma mark- Email validation

+(BOOL)emailValidation:(NSString*)emailId{
    
    NSString *email = emailId;
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:email];
    
    return myStringMatchesRegEx;
}


#pragma mark- Navagation setup

+(void)NavagationSetup{
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    // [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:40.0/255.0 green:141.0/255.0 blue:192.0/255.0 alpha:1.0]];
    
    
    
    [[UINavigationBar appearance]  setBackgroundImage:[UIImage new]
                                        forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].shadowImage = [UIImage new];
    [UINavigationBar appearance].translucent = YES;
    
    
    //     NSShadow *shadow = [[NSShadow alloc] init];
    //    shadow.shadowColor = [UIColor colorWithRed:40.0/255.0 green:141.0/255.0 blue:192.0/255.0 alpha:0.8];
    //    shadow.shadowOffset = CGSizeMake(0, 1);
    //    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
    //                                                           [UIColor colorWithRed:40.0/255.0 green:141.0/255.0 blue:192.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
    //                                                           shadow, NSShadowAttributeName,
    //                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    
    
    
    
    
}



-(void)SetupMenu:(UIViewController*)nav isBack:(BOOL)isBack{
    ctrl = nav;
    isback=isBack;
    
    nav.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"orange"]];
    nav.navigationController.navigationBar.translucent = NO;
   

    
    
    if (isBack) {
        
        
        nav.navigationItem.hidesBackButton=YES;
        
        UIButton* someButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [someButton setFrame:CGRectMake(0, 0, 21, 15)];
        [someButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [someButton addTarget:self action:@selector(LeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [someButton setShowsTouchWhenHighlighted:YES];
        UIBarButtonItem* someBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:someButton];
        [nav.navigationItem setLeftBarButtonItem:someBarButtonItem];
        
        
    }else{
        
     /*   nav.navigationItem.hidesBackButton=YES;
        
        UIButton* someButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [someButton setFrame:CGRectMake(0, 0, 21, 15)];
        [someButton setBackgroundImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
        [someButton addTarget:self action:@selector(LeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [someButton setShowsTouchWhenHighlighted:YES];
        UIBarButtonItem* someBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:someButton];
        [nav.navigationItem setLeftBarButtonItem:someBarButtonItem];
        */
        
    }
    
  
    
}

-(void)LeftButtonAction:(UIBarButtonItem*)btn{
    
    if (isback) {
        [ctrl.navigationController popViewControllerAnimated:YES];
    }else{
        
    }
    
}


#pragma mark- Aleart Setup
+(void)showAleart:(NSString*)msg ctrl:(UIViewController*)ctrl{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (msg.length>0) {
            UIAlertController *al = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
            [ctrl presentViewController:al animated:YES completion:nil];
            
            UIAlertAction *ac = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [al dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [al addAction:ac];
            
        }
        
    });
    
    
}


+ (void)showError:(NSString *)errorMsg {
    

    
}



#pragma mark- URL Setup

+(NSString *)urlForId:(int)reqId {
    switch (reqId) {
       
        case REQUEST_ValidateMobileNumber:
            return [NSString stringWithFormat:@"%sValidateMobileNumber?",conn_url];
            break;
            
        case REQUEST_GetPostcodes:
            return [NSString stringWithFormat:@"%sGetPostcodes?",conn_url];
            break;
            
        case REQUEST_SaveCustomerProfile:
            return [NSString stringWithFormat:@"%sSaveCustomerProfile?",conn_url];
            break;
            
        
      
        case REQUEST_GetCustomerTypeList:
            return [NSString stringWithFormat:@"%sGetCustomerTypeList?",conn_url];
            break;
            
        case REQUEST_GetCustomerTitleList:
            return [NSString stringWithFormat:@"%sGetCustomerTitleList?",conn_url];
            break;
            
        case REQUEST_CustomerGenders:
            return [NSString stringWithFormat:@"%sCustomerGenders?",conn_url];
            break;
            
        case REQUEST_GetCustomerAddresses:
            return [NSString stringWithFormat:@"%sGetCustomerAddresses?",conn_url];
            break;
            
        case REQUEST_CalculateFinancialDetail:
            return [NSString stringWithFormat:@"%sCalculateFinancialDetail?",conn_url];
            break;
            
        case REQUEST_SaveFinancialDetail:
            return [NSString stringWithFormat:@"%sSaveFinancialDetail?",conn_url];
            break;
            
        case REQUEST_SendJobDetailsSms:
            return [NSString stringWithFormat:@"%sSendJobDetailsSms?",conn_url];
            break;
            
        case REQUEST_GetJobDetails:
            return [NSString stringWithFormat:@"%sGetJobDetails?",conn_url];
            break;
            
        case REQUEST_GetFinancialDetail:
            return [NSString stringWithFormat:@"%sGetFinancialDetail?",conn_url];
            break;
            
        case REQUEST_GetJobPayments:
            return [NSString stringWithFormat:@"%sGetJobPayments?",conn_url];
            break;
            
        case REQUEST_GetPaymentModeList:
            return [NSString stringWithFormat:@"%sGetPaymentModeList?",conn_url];
            break;
            
        case REQUEST_SaveJobPayment:
            return [NSString stringWithFormat:@"%sSaveJobPayment?",conn_url];
            break;
            
        case REQUEST_GetMessageCount:
            return [NSString stringWithFormat:@"%sGetMessageCount?",conn_url];
            break;
            
        case REQUEST_SetEnggCurrentLocation:
            return [NSString stringWithFormat:@"%sSetEnggCurrentLocation?",conn_url];
            break;
            
        case REQUEST_GetAddress:
            return [NSString stringWithFormat:@"%sGetAddress?",conn_url];
            break;
            
        case REQUEST_FetchMaterialList:
            return [NSString stringWithFormat:@"%sFetchMaterialList?",conn_url];
            break;
        case REQUEST_FetchCostList:
            return [NSString stringWithFormat:@"%sFetchCostList?",conn_url];
            break;
        case REQUEST_FetchNoteList:
            return [NSString stringWithFormat:@"%sFetchNoteList?",conn_url];
            break;
            
        case REQUEST_GetCustomerDetails:
            return [NSString stringWithFormat:@"%sGetCustomerDetails?",conn_url];
            break;
            
        case REQUEST_JobCancellation:
            return [NSString stringWithFormat:@"%sJobCancellation?",conn_url];
            break;
            
        case REQUEST_SetEngineerUnAssigned:
            return [NSString stringWithFormat:@"%sSetEngineerUnAssigned?",conn_url];
            break;

        case REQUEST_GetCalendarJob:
            return [NSString stringWithFormat:@"%sGetCalendarJob?",conn_url];
            break;
            
        case REQUEST_GetCalendarDate:
            return [NSString stringWithFormat:@"%sGetCalendarDate?",conn_url];
            break;

        case REQUEST_GetCustomerCardDetails:
            return [NSString stringWithFormat:@"%sGetCustomerCardDetails?",conn_url];
            break;
        case REQUEST_SaveCardDetail:
            return [NSString stringWithFormat:@"%sSaveCardDetail?",conn_url];
            break;
            
        case REQUEST_GetNoteTypeForEngineers:
            return [NSString stringWithFormat:@"%sGetNoteTypeForEngineers?",conn_url];
            break;
            
        case REQUEST_paRes:
            return [NSString stringWithFormat:@"%sSecure3D?",conn_url];
            break;
            
        case REQUEST_SaveSquarePaymentDetailAndSendSms:
            return [NSString stringWithFormat:@"%sSaveSquarePaymentDetailAndSendSms?",conn_url];
            break;
            
        case REQUEST_GetSquareUpInvoiceID:
            return [NSString stringWithFormat:@"%sGetSquareUpInvoiceID?",conn_url];
            break;
            
        case REQUEST_GetSquareUpPaymentDetails:
            return [NSString stringWithFormat:@"%sGetSquareUpPaymentDetails?",conn_url];
            break;
     
        case REQUEST_GetInvoice:
            return [NSString stringWithFormat:@"%sGetInvoice?",conn_url];
            break;
            
        default:
            return @"";
            break;
            
    }
    return @"";
}





#pragma mark String Checking null
+(NSString*)ReplaceStringNull:(id)str
{
    
    NSString *st=[NSString stringWithFormat:@"%@",str];
    
    st = [st stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    st = [st stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    st = [st stringByTrimmingCharactersInSet:
          [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return st;
    
}


#pragma mark UItextfield Placeholder color

+(void)ChangePlaceholderColor:(UIColor*)color{
    
     [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITextField class]]] setTextColor:color];
}
#pragma mar Self Defined function

+(UIImage *) scaleAndRotateImage: (UIImage *)image
{
    int kMaxResolution = 1000; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef),      CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}



#pragma mark- UItextfield Mandatery

+(void)TextFieldBorderColorChangeWithArray:(NSArray*)arrTextfield withColor:(UIColor*)colour{
  
    for (UITextField *txt in arrTextfield) {
        if (txt.text.length==0) {
           
            [GlobalDirector TextFieldBorderColorChange:txt withColor:colour];
            
        }
        
    }
}


+(void)TextFieldBorderColorChange:(UITextField*)txt withColor:(UIColor*)colour{
    txt.layer.borderColor=[[UIColor redColor]CGColor];
    txt.layer.borderWidth= 2.0f;
}



+(void)TextFieldErrorShow:(NSArray*)arrTextfield {
    
    for (UITextField *txt in arrTextfield) {
        if (txt.text.length==0) {
            
            txt.rightView.hidden=NO;
            txt.rightViewMode = UITextFieldViewModeAlways;
            txt.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error_i"]];
            
            
        }
        
    }
}



+(void)ManadetoryFields:(UITextField*)field{
    
    UILabel *err=[[UILabel alloc]init];
    err.text=[NSString stringWithFormat:@"*  "];
    
    err.font=[UIFont systemFontOfSize:17.0];
    err.textColor=[UIColor redColor];
    [err sizeToFit];
    err.userInteractionEnabled=NO;
    
    field.rightViewMode = UITextFieldViewModeAlways;
    field.rightView =err;
    
}


+(void)cleanTextView:(UITextView *)textV{
    for (UILabel *lbl in [textV subviews]) {
        if (lbl.tag==999) {
            
            [lbl removeFromSuperview];
            
            
        }
    }
    
}


+(void)ShowErrorAtTextView:(UITextView *)txtfld alert:(NSString *)alrt{
    
    for (UILabel *lbl in [txtfld subviews]) {
        if (lbl.tag==999)
        {
            [lbl removeFromSuperview];
            
        }
    }
    UILabel *err=[[UILabel alloc]init];
    err.text=[NSString stringWithFormat:@"%@",alrt];
    
    err.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:10];
    err.textColor=[UIColor redColor];
    
    // err.backgroundColor=[UIColor redColor];
    [err sizeToFit];
    err.userInteractionEnabled=NO;
    err.textAlignment= NSTextAlignmentRight;
    err.tag=999;
    err.frame=CGRectMake(CGRectGetWidth(txtfld.frame)-CGRectGetWidth(err.frame), 10, CGRectGetWidth(err.frame), 12);
   
    // err.center=CGPointMake(CGRectGetWidth(txtfld.frame)-CGRectGetWidth(err.frame), 10);
    
     [txtfld addSubview:err];
    
    
}



+(void)ManadetoryFields:(UITextField*)field withText:(NSString*)str{
    
    UILabel *err=[[UILabel alloc]init];
    err.text = str;
    
    err.font=[UIFont systemFontOfSize:17.0];
    err.textColor=[UIColor redColor];
    [err sizeToFit];
    err.userInteractionEnabled=NO;
    
    field.rightViewMode = UITextFieldViewModeAlways;
    field.rightView =err;
    
}





@end




