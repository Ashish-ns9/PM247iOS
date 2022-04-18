//
//  AddJobPayment.m
//  Partner Maintenance
//


#import "AddJobPayment.h"
AppDelegate *app;
@interface AddJobPayment ()

@end

@implementation AddJobPayment

@synthesize strHeading;

- (void)viewDidLoad
{
    [super viewDidLoad];
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _lblHeading.text=strHeading;
    _tabvNotes.backgroundView=nil;
    _tabvNotes.backgroundColor=[UIColor clearColor];
    _tabvNotes.separatorColor=[UIColor grayColor];
}
- (IBAction)backTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnAddTapped:(id)sender
{

    mainBg = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    mainBg.backgroundColor =[UIColor colorWithRed:142/255.0 green:142/255.0 blue:143/255.0 alpha:0.8];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTest:)];
    [mainBg addGestureRecognizer:tap];
    
    _btnAdd.userInteractionEnabled=NO;
    
    bgVw = [[UIView alloc] initWithFrame:CGRectMake(20,80,280,330)];
    [bgVw.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [bgVw.layer setBorderWidth: 0.5];
    [bgVw.layer setCornerRadius:4.0f];
    [bgVw.layer setMasksToBounds:YES];
    bgVw.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    
    
    //--------- Payment  Method----------------
    txtPaymentMethod = [[UITextField alloc] initWithFrame:CGRectMake(20,40,240,30)];
    txtPaymentMethod.textColor=[UIColor darkGrayColor];
    txtPaymentMethod.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    [txtPaymentMethod setBorderStyle:UITextBorderStyleNone];
    txtPaymentMethod.layer.borderWidth=0.5f;
    txtPaymentMethod.layer.borderColor=[[UIColor grayColor]CGColor];
    txtPaymentMethod.layer.cornerRadius=6.0f;
    txtPaymentMethod.background=[UIImage imageNamed:@"inputBox5"];
    txtPaymentMethod.delegate = self;
    txtPaymentMethod.userInteractionEnabled=YES;
    txtPaymentMethod.placeholder=@" Payment mode";
    
    UIImageView *imgDropdown1=[[UIImageView alloc] initWithFrame:CGRectMake(225, 40, 35, 30)];
    [imgDropdown1 setImage:[UIImage imageNamed:@"dropdown"]];
    
    //------------------------------------
    txtAmount = [[UITextField alloc] initWithFrame:CGRectMake(20,85,240,30)];
    txtAmount.textColor=[UIColor darkGrayColor];
    txtAmount.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    [txtAmount setBorderStyle:UITextBorderStyleNone];
    txtAmount.layer.borderWidth=0.5f;
    txtAmount.layer.borderColor=[[UIColor grayColor]CGColor];
    txtAmount.layer.cornerRadius=6.0f;
    txtAmount.background=[UIImage imageNamed:@"inputBox5"];
    txtAmount.delegate = self;
    txtAmount.userInteractionEnabled=YES;
    txtAmount.placeholder=@" Amount";
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20,130,240,29)];
    lblTitle.text = @" Description";
    lblTitle.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.backgroundColor =[UIColor colorWithRed:52/255.0 green:54/255.0 blue:67/255.0 alpha:0.72];
    [lblTitle.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [lblTitle.layer setBorderWidth: 1.0];
    [lblTitle.layer setCornerRadius:4.0f];
    [lblTitle.layer setMasksToBounds:YES];
    
    txtvDescription = [[UITextView alloc] initWithFrame:CGRectMake(20,170,240,90)];
    txtvDescription.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    txtvDescription.textColor=[UIColor darkGrayColor];
    [txtvDescription setBackgroundColor:[UIColor whiteColor]];
    txtvDescription.delegate = self;
    [txtvDescription.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [txtvDescription.layer setBorderWidth: 1.0];
    [txtvDescription.layer setCornerRadius:4.0f];
    [txtvDescription.layer setMasksToBounds:YES];
    
    btnCross=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCross.frame=CGRectMake(0, 0, 25, 25);
    btnCross.center=CGPointMake(CGRectGetMaxX(bgVw.frame),CGRectGetMinY(bgVw.frame));
    [btnCross setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
    [btnCross addTarget:self action:@selector(cross:) forControlEvents:UIControlEventTouchUpInside];
    [btnCross clipsToBounds];
    
    btnSave=[UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.frame=CGRectMake(0,290,280,40);
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSave.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:18.0];
    [btnSave setBackgroundColor:[UIColor colorWithRed:30/255.0 green:124/255.0 blue:41/255.0 alpha:1.0]];
    [btnSave addTarget:self action:@selector(savePress:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnSave.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [btnSave.layer setBorderWidth: 1.0];
    [btnSave.layer setCornerRadius:0.0f];
    [btnSave.layer setMasksToBounds:YES];
    
    [bgVw addSubview:txtPaymentMethod];
    [bgVw addSubview:txtAmount];
    [bgVw addSubview:imgDropdown1];
    [bgVw addSubview:lblTitle];
    [bgVw addSubview:txtvDescription];
    [bgVw addSubview:btnSave];
    
    [mainBg addSubview:bgVw];
    [mainBg addSubview:btnCross];
    
    [self.view addSubview:mainBg];
    
    
}
-(void)cross:(id)sender
{
    
    [mainBg removeFromSuperview];
    _btnAdd.userInteractionEnabled=YES;
}
- (void)tapTest:(UITapGestureRecognizer *)sender
{
    [mainBg removeFromSuperview];
    _btnAdd.userInteractionEnabled=YES;
}
-(void)savePress:(UIButton *)sender
{
    DLog(@"payment saved");
}
#pragma mark - TEXTFIELD DELEGATES
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField==txtPaymentMethod)
    {
        DLog(@"Payment Mode");
    }
    else if (textField==txtAmount)
    {
        DLog(@"Amount");
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}
#pragma mark - TEXTVIEW DELEGATES
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}


#pragma mark tableview delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier=@"cellidentifier";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellidentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.backgroundColor=[UIColor clearColor];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}




@end
