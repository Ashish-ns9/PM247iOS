//
//  PaymentTransactionDtls.m
//  PM247
//


#import "PaymentTransactionDtls.h"
#import "GlobalDirector.h"
#import "CardPaymentController.h"

@interface PaymentTransactionDtls ()

@end

@implementation PaymentTransactionDtls
@synthesize dictJob,dictPaymentMethod,arrImages;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self infoFillUP];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)infoFillUP {
   
    
    NSArray *arr=[dictJob objectForKey:@"JobAddrListResponse"];
    NSDictionary *dictUser,*dictAdd;
    
    for (NSDictionary *dic in arr) {
        if ([[dic valueForKey:@"TypeOfAddress"]integerValue]==2) {
            dictAdd=dic;
            
        }
    }
    NSArray *arr2=[dictJob objectForKey:@"JobPeopleListResponse"];
    for (NSDictionary *dic in arr2) {
        
        if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==1 || [[dic valueForKey:@"TypeofCustomer"]integerValue]==3 || [[dic valueForKey:@"TypeofCustomer"]integerValue]==4) {
            dictUser=dic;
            
        }
        
    }
    
    if (!dictUser) {
         dictUser = [arr2 objectAtIndex:0];
    }
    
    
    _txtAmount.text=[GlobalDirector ReplaceStringNull:[dictPaymentMethod valueForKey:@"amount"]];
    _txtVDes.text = [GlobalDirector ReplaceStringNull:[dictPaymentMethod valueForKey:@"description"]];
 
    
    if (dictUser) {
        
    
    _txtFirstName.text = [GlobalDirector ReplaceStringNull:[dictUser valueForKey:@"FirstName"]];
    _txtLastName.text = [GlobalDirector ReplaceStringNull:[dictUser valueForKey:@"LastName"]];
    _txtMobile.text = [GlobalDirector ReplaceStringNull:[dictUser valueForKey:@"ContactNumber"]];
    _txtEmail.text = [GlobalDirector ReplaceStringNull:[dictUser valueForKey:@"EmailAddress"]];
    
    }
    
    if (dictAdd) {
        
        
        _txtORG.text = [GlobalDirector ReplaceStringNull:[dictAdd valueForKey:@"NameofOrganisation"]];
        _txtAddress.text = [GlobalDirector ReplaceStringNull:[dictAdd valueForKey:@"Address"]];
        _txtCity.text = [GlobalDirector ReplaceStringNull:[dictAdd valueForKey:@"City"]];
        _txtCounty.text = [GlobalDirector ReplaceStringNull:[dictAdd valueForKey:@"County"]];
        _txtPostcode.text = [GlobalDirector ReplaceStringNull:[dictAdd valueForKey:@"PostCode"]];
        
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)ContinuePayment:(UIButton *)sender {
    
    if (_txtFirstName.text.length == 0) {
        [GlobalDirector showAleart:@"Please enter First name." ctrl:self];
        return;
    }else if (_txtLastName.text.length == 0) {
          [GlobalDirector showAleart:@"Please enter Last name." ctrl:self];
         return;
    }else if (_txtAddress.text.length == 0) {
          [GlobalDirector showAleart:@"Please enter Address." ctrl:self];
         return;
    }else if (_txtCity.text.length == 0) {
          [GlobalDirector showAleart:@"Please enter City." ctrl:self];
         return;
    }else if (_txtPostcode.text.length == 0) {
          [GlobalDirector showAleart:@"Please enter Postcode." ctrl:self];
         return;
    }
   
    
    float actual_amount = [[GlobalDirector ReplaceStringNull:[dictPaymentMethod valueForKey:@"amount"]] floatValue];
    float amount = [_txtAmount.text floatValue];
    
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:_txtAmount.text];
    
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    
    if (amount <= 0) {
        [GlobalDirector showAleart:@"Please enter amount." ctrl:self];
    }else if (amount > actual_amount){
        [self showAlert:@"The amount cannot be greater than due amount." withTitle:@"Error"];
    }else if (stringIsValid==NO){
         [self showAlert:@"Please enter valid amount." withTitle:@"Error"];
    }else{
    
    CardPaymentController *card = [[CardPaymentController alloc] initWithNibName:@"CardPaymentController" bundle:nil];
    card.selfPaymentDtlsPage =self;
    [self.navigationController pushViewController:card animated:YES];
    }
    
}


- (IBAction)ClickBack:(UIButton *)sender {
    
     [self dismissViewControllerAnimated:YES completion:nil];
}

@end
