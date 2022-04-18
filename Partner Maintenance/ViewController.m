//
//  ViewController.m
//  Partner Maintenance
//
//  Created by SANDIPAN on 13/10/14.
//  Copyright (c) 2014 SANDIPAN. All rights reserved.
//

#import "ViewController.h"
#import "AddNotes.h"


CGFloat animatedDistance;




@interface ViewController ()

@end

@implementation ViewController
@synthesize dataTask=_dataTask;


- (void)viewDidLoad {
    [super viewDidLoad];
    [_lblTitle setFont:[UIFont fontWithName:@"TheSansArabic-Bold" size:16.0]];
    
    
}





-(void)showAlert:(NSString *)alertmessage withTitle:(NSString *)title{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: title
                                                                            message:alertmessage
                                                                     preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                              style: UIAlertActionStyleDestructive
                                                            handler: ^(UIAlertAction *action) {
                                                                NSLog(@"Dismiss button tapped!");
                                                            }];
        
        [controller addAction: alertAction];
        
        [self presentViewController: controller animated: YES completion: nil];
        
    });
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)InternetConnectionAvailable{
    
    Reachability *networkReachability = [Reachability reachabilityWithHostName:[NSString stringWithFormat:@"%s",conn_url]];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    
    if  (networkStatus == NotReachable) {
      return   NO;
        
       }
    
    else
    {
     return   YES;
        
    }
    
}

-(void)fetchDropDownForTextField:(NSString *)text didFinishLoading:(finishedLoading)complete
{
    
  
    if ([self InternetConnectionAvailable]==YES) {
    
   __block NSArray *arr;
    NSString *post =[NSString stringWithFormat:@""];
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
       
        
    NSString *userType = [userdetails valueForKey:@"UserType"];
     NSString *urlString;
        if ([text isEqualToString:@"GetNoteType"]) {
            urlString=[NSString stringWithFormat:@"%s%@?userToken=%@&UserType=%@",conn_url,text,(NSString *)[userdetails valueForKey:@"UserToken"],userType];
        }else{
           urlString=[NSString stringWithFormat:@"%s%@?userToken=%@",conn_url,text,(NSString *)[userdetails valueForKey:@"UserToken"]];
        }
        
   
        
        
    
    NSLog(@"PostString=%@",urlString);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
        request.timeoutInterval = 300;
    NSLog(@"PostString=%@",request);
    
    
    
 [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *returnData, NSURLResponse *response, NSError *error){
      
        NSMutableDictionary* temp;
        if (returnData !=nil)
        {
            
            NSError *error;
            temp = [NSJSONSerialization JSONObjectWithData:returnData  options:NSJSONReadingMutableContainers error:&error];
            if (!error)
            {
                if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
                {
                    arr=(NSArray *)[temp objectForKey:@"DataResponses"];
                    complete(YES,arr);
                    
                }
                else
                {
                    NSLog(@"JSONObjectWithData error: %@", error);
                    complete(NO,nil);
                    
                }
                
            }
        }
        else
        {
        }
        NSLog(@"temp all static page:%@",temp);
        
    }];
    
    }
    else
    {
        [self showAlert:@"Check Connection" withTitle:@""];
         complete(NO,nil);
    }
    
    
   }



-(void)PostDataToServerWithUrl:(NSString *)urlString dataDictionary:(NSDictionary *)dataDic finishLoading:(completed)complete{
    NSError *error;
    
    
   
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDic
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"UR::%@  Json String:%@",urlString,jsonString);
    }
    
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [urlRequest setHTTPMethod:@"POST"];
    urlRequest.timeoutInterval = 300;
    NSDictionary *mapData = dataDic;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [urlRequest setHTTPBody:postData];
    
    _dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil)
                                                           {
                                                               NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                               NSLog(@"Data = %@",text);
                                                                complete(data,response,error);
                                                               
                                                           }
                                                           
                                                       }];
    [_dataTask resume];
    

}





-(void)getDataFromServerWithUrl:(NSString *)urlString finishLoading:(completed)complete{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.timeoutIntervalForRequest = 300.0;
    defaultConfigObject.timeoutIntervalForResource = 300.0;

    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    

    
    NSURL * url = [NSURL URLWithString:urlString];
    
    [_dataTask cancel];
    
     _dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        
                                                        
                                                        if(error == nil)
                                                        {
                                                            NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                            NSLog(@"Data = %@",text);
                                                         
                                                        }
                                                        
                                                       else if (error.code == NSURLErrorTimedOut)
                                                           
                                                        {
                                                            [self showAlert:@"REQUEST TIMEOUT" withTitle:@"Try Again"];
                                                        
                                                        _activity.hidden=YES;
                                                        _lblRefresh.hidden=YES;
                                                        [_activity stopAnimating];
                                                        [_btnRefresh setHidden:NO];
                                                            
                                                        }
                                                        
                                                        else
                                                        {
                                                            ;
                                                        }
                                                        
                                                        complete(data,response,error);
                                                    }];
    
    [_dataTask resume];
}






-(void)getAgreement:(NSString *)agreementType loadingCompleted:(finishedLoadingAgrr)finish{
    
    __block NSString *returnHtmlStr;
    
    
    NSString *urlString=[NSString stringWithFormat:@"%sGetHtmlPages?PageType=%@",conn_url,agreementType];
    urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
   // DLog(@"PostString=%@",urlString);
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfigObject.timeoutIntervalForRequest = 300;
    defaultConfigObject.timeoutIntervalForResource = 300;
    
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    [_dataTaskAgr cancel];
    
    _dataTaskAgr = [defaultSession dataTaskWithURL:url
                              completionHandler:^(NSData *_responseData, NSURLResponse *response, NSError *error) {
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                  NSMutableDictionary* temp;
                                                  if (_responseData !=nil)
                                                  {
                                                     NSError *error;
                                                     temp = [NSJSONSerialization JSONObjectWithData:_responseData  options:NSJSONReadingMutableContainers error:&error];
                                                      if (!error)
                                                      {
                                                          if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
                                     
                                                          {
                                                           returnHtmlStr=(NSString *)[temp valueForKey:@"ReturnValue"];
                                                           finish(YES,returnHtmlStr);
                                                             
                                                          
                                                         }
                                                      }
                                               }
                                      
                                             });

                                  
                                  finish(YES,returnHtmlStr);
                              }];
    
    [_dataTaskAgr resume];

    
    
}


@end
