//
//  ViewController.h
//  Partner Maintenance
//
//  Created by SANDIPAN on 13/10/14.
//  Copyright (c) 2014 SANDIPAN. All rights reserved.


#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "DefaultSettings.h"
typedef void(^finishedLoading)(BOOL,NSArray *arr);
typedef void(^finishedLoadingAgrr)(BOOL,NSString *str);

typedef void  (^completed)(NSData *data, NSURLResponse *response, NSError *error);
@interface ViewController : UIViewController
@property(retain,nonatomic)IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UILabel *lblRefresh;
@property (strong, nonatomic) IBOutlet UIButton *btnRefresh;
@property(retain,nonatomic) NSURLSessionDataTask * dataTask,* dataTaskAgr;
-(void)showAlert:(NSString *)alertmessage withTitle:(NSString *)title;
-(BOOL)InternetConnectionAvailable;
-(void)fetchDropDownForTextField:(NSString *)text didFinishLoading:(finishedLoading)complete;
-(void)PostDataToServerWithUrl:(NSString *)urlString dataDictionary:(NSDictionary *)dataDic finishLoading:(completed)complete;
-(void)getDataFromServerWithUrl:(NSString *)urlString finishLoading:(completed)complete;
-(void)getAgreement:(NSString *)agreementType loadingCompleted:(finishedLoadingAgrr)finish;



#ifdef DEBUG
#    define DLog(...) NSLog(__VA_ARGS__)
#else
#    define DLog(...) 
#endif
#define ALog(...) NSLog(__VA_ARGS__)

@end

















