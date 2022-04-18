//
//  GasFormAdress.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>

@protocol AdressDelegate <NSObject>

-(void)GasFormAddress:(NSArray*)address;


@end

@interface GasFormAdress : UIViewController<UITextViewDelegate>
{
    NSMutableArray *arrAllAdress;
    
}
@property(retain,nonatomic)NSMutableDictionary *dicAddress;
@property(weak,nonatomic)id <AdressDelegate>delegate;
@property (strong, nonatomic) IBOutlet UITextField *txtName;

@property (strong, nonatomic) IBOutlet UITextField *txtAdress;
@property (strong, nonatomic) IBOutlet UITextField *txtConNo;
@property (strong, nonatomic) IBOutlet UITextField *txtCounty;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtPostCode;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segAdress;
@property(retain,nonatomic)NSDictionary *jobDic;
- (IBAction)segAdressChange:(id)sender;
- (IBAction)btnBackTapped:(id)sender;

@end
