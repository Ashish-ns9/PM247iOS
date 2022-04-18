//
//  PaymentTransactionDtls.h
//  PM247


#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface PaymentTransactionDtls : ViewController
@property(nonatomic,retain)  NSDictionary *dictJob;
@property(nonatomic,retain)  NSMutableDictionary *dictPaymentMethod;

@property (strong, nonatomic) IBOutlet UITextField *txtAmount;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtMobile;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtORG;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtCounty;
@property (strong, nonatomic) IBOutlet UITextField *txtPostcode;
@property (strong, nonatomic) IBOutlet UITextView *txtVDes;
@property (strong, nonatomic) NSMutableArray *arrImages;




@end
