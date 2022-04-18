//
//  GasFormAdress.m
//  Partner Maintenance
//


#import "GasFormAdress.h"

@interface GasFormAdress ()

@end

@implementation GasFormAdress

- (void)viewDidLoad {
    [super viewDidLoad];
 
     arrAllAdress=[[NSMutableArray alloc]initWithObjects:@"",@"",@"", nil];
    
     [self FeedAdressFieldsWithtag:3];
     [self FeedAdressFieldsWithtag:2];
     [self FeedAdressFieldsWithtag:1];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)segAdressChange:(id)sender {
    
    UISegmentedControl *seg=(UISegmentedControl *)sender;
    
    switch (seg.selectedSegmentIndex) {
        case 0:
            
            [self FeedAdressFieldsWithtag:1];
        
            break;
        case 1:
              [self FeedAdressFieldsWithtag:2];
            break;
        case 2:
              [self FeedAdressFieldsWithtag:3];
            break;
            
        default:
            break;
    }
}

- (IBAction)btnBackTapped:(id)sender {
    
    NSLog(@"arrAllAdress :%@",arrAllAdress);
    
    if([self.delegate respondsToSelector:@selector(GasFormAddress:)]) {
        [self.delegate GasFormAddress:arrAllAdress];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

-(void)FeedAdressFieldsWithtag:(NSInteger)tag{
    
    NSArray *arr=[_jobDic valueForKey:@"JobAddrListResponse"];
    NSArray *arrPpl=[_jobDic valueForKey:@"JobPeopleListResponse"];
    NSDictionary *adressDic;
    NSDictionary *PeopleDic;
    
    _dicAddress=[[NSMutableDictionary alloc]init];
    
    for (NSDictionary *dic in arr) {
        if ([[dic valueForKey:@"TypeOfAddress"]integerValue]==tag) {
            adressDic=dic;
            //_dicAddress =[adressDic mutableCopy];
        }
    }
    for (NSDictionary *dic in arrPpl) {
        if ([[dic valueForKey:@"TypeofCustomer"]integerValue]==1 || [[dic valueForKey:@"TypeofCustomer"]integerValue]==3 || [[dic valueForKey:@"TypeofCustomer"]integerValue]==4) {
            PeopleDic=dic;
           // _dicAddress =[adressDic mutableCopy];
        }
    }
    
    
    if (![[PeopleDic valueForKey:@"FullName"]isKindOfClass:[NSNull class]])
    {
        _txtName.text=[PeopleDic valueForKey:@"FullName"];
        [_dicAddress setValue:[PeopleDic valueForKey:@"FullName"] forKey:@"FullName"];
        
    }
    
    [_dicAddress setValue:[NSString stringWithFormat:@"%ld",(long)tag] forKey:@"TypeOfAddress"];
    
    
    if (![[adressDic valueForKey:@"Address"]isKindOfClass:[NSNull class]])
    {
       _txtAdress.text=[adressDic valueForKey:@"Address"];
        [_dicAddress setValue:[adressDic valueForKey:@"Address"] forKey:@"Address"];
    }
    if (![[adressDic valueForKey:@"County"]isKindOfClass:[NSNull class]])
    {
        _txtCounty.text=[adressDic valueForKey:@"County"];
        [_dicAddress setValue:[adressDic valueForKey:@"County"] forKey:@"County"];
    }
    if (![[adressDic valueForKey:@"City"]isKindOfClass:[NSNull class]]) {
        
        _txtCity.text=[adressDic valueForKey:@"City"];
        [_dicAddress setValue:[adressDic valueForKey:@"City"] forKey:@"City"];
    }
    if (![[adressDic valueForKey:@"PostCode"]isKindOfClass:[NSNull class]])
    {
        _txtPostCode.text=[adressDic valueForKey:@"PostCode"];
        [_dicAddress setValue:[adressDic valueForKey:@"PostCode"] forKey:@"PostCode"];
    }
    if (![[adressDic valueForKey:@"ContactNo"]isKindOfClass:[NSNull class]])
    {
        _txtConNo.text=[adressDic valueForKey:@"ContactNo"];
        [_dicAddress setValue:[adressDic valueForKey:@"ContactNo"] forKey:@"ContactNo"];
    }

    
 
    [arrAllAdress replaceObjectAtIndex:[_segAdress selectedSegmentIndex] withObject:_dicAddress];
    
    
    
}

#pragma mark- UItextfield delegate                                              
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}






@end
