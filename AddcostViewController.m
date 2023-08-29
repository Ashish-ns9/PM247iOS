//
//  AddcostViewController.m
//  Partner Maintenance
//


#import "AddcostViewController.h"

@interface AddCostViewController ()

@end

@implementation AddCostViewController
@synthesize Costs;
@synthesize strFromCustomerClass;
@synthesize strHeading,jobID;

#pragma mark - ViewDidLoad method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
     [_lblHeading setFont:[UIFont fontWithName:@"TheSansArabic-Bold" size:18.0]];
    
    _tblCost.backgroundView=nil;
    _tblCost.backgroundColor=[UIColor clearColor];
    _tblCost.separatorColor=[UIColor clearColor];
    _lblHeading.text=strHeading;
    arrImages=[[NSMutableArray alloc]init];
    currX=2.0f;
    
    //Manager Engineer Section >>>>  CreateJobEng / ManagerJobDetails
    if ([strFromCustomerClass isEqualToString:@"ManagerJobDetails"]){
        
        if ([_jobStatus integerValue]==3) {
            _btnAdd.hidden=NO;
        }
        else
            _btnAdd.hidden=NO;
         }
    
    if (Costs==nil){
        Costs=[[NSMutableArray alloc]init];
    }
    OnAccount=@"false";
    
    
    if (jobID) {
        [self fetchCostList];
    }
    
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}




-(void)fetchCostList{
    
    
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    [dict setObject:jobID forKey:@"jobID"];

    GlobalDirector *globe = [GlobalDirector SharedDirector];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [globe SyncRequestGet:REQUEST_FetchCostList withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        
        DLog(@"%@",result);
        
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            @try {
                
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                Costs = [[NSMutableArray alloc] init];
                
                NSArray *arrAdd= [result valueForKey:@"CostRecordList"];
                [Costs addObjectsFromArray:arrAdd];
                
                
                
            } @catch (NSException *exception) {
                
                if (!Costs) {
                    Costs = [[NSMutableArray alloc] init];
                }
                
            }@finally{
                
                [_tblCost reloadData];
                
            }
        });
        
    }];
    
    
}


#pragma mark - Back Press method
- (IBAction)backTapped:(id)sender
{
    if([self.delegate respondsToSelector:@selector(addItemViewController:didFinishEnteringItem:)])
    {
        [self.delegate addItemViewController:self didFinishEnteringItem:Costs];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark TableView delegate datasource
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tblView) {
        return [arrFeedTblPopup count];
        
    }
    return [Costs count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellidentifier=@"cellidentifier";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.backgroundColor=[UIColor clearColor];
    
    if (tableView==tblView) {
        
        NSDictionary *dic=[arrFeedTblPopup objectAtIndex:indexPath.row];
        
        cell.textLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
        
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"DisplayText"]];
        
        
    }
    else
    {
   
        UIImageView *imgvCellbg=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(_tblCost.frame),150)];
        [imgvCellbg setImage:[UIImage imageNamed:@"jobBox_clearbg"]];
        [cell.contentView addSubview:imgvCellbg];
        
        NSDictionary *dic=[Costs objectAtIndex:indexPath.row];
        CGFloat currY=10;
        
        UILabel *lbl1;
        lbl1=[[UILabel alloc] initWithFrame:CGRectMake(15,currY,90,28)];
        lbl1.textAlignment=NSTextAlignmentLeft;
        lbl1.textColor=[UIColor darkGrayColor];
        lbl1.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
        lbl1.backgroundColor=[UIColor clearColor];
        lbl1.text=@"Cost type:";
        [cell.contentView addSubview:lbl1];
        
    
        UILabel *lblCostType;
        lblCostType=[[UILabel alloc] initWithFrame:CGRectMake(95,currY,215,28)];
        lblCostType.textAlignment=NSTextAlignmentLeft;
        lblCostType.textColor=[UIColor blueColor];
        lblCostType.font=[UIFont systemFontOfSize:12.0];
        lblCostType.backgroundColor=[UIColor clearColor];
        lblCostType.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"DisplayTextCostType"]];
        [cell.contentView addSubview:lblCostType];
        
        currY=CGRectGetMaxY(lblCostType.frame);
        UILabel *lbl2;
        lbl2=[[UILabel alloc] initWithFrame:CGRectMake(15,currY+2,90,28)];
        lbl2.textAlignment=NSTextAlignmentLeft;
        lbl2.textColor=[UIColor darkGrayColor];
        lbl2.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
        lbl2.backgroundColor=[UIColor clearColor];
        lbl2.text=@"EngineerTotal:";
        [cell.contentView addSubview:lbl2];
        
        UILabel *lblEngTotal;
        lblEngTotal=[[UILabel alloc] initWithFrame:CGRectMake(100,currY+2,215,28)];
        lblEngTotal.textAlignment=NSTextAlignmentLeft;
        lblEngTotal.textColor=[UIColor blueColor];
        lblEngTotal.font=[UIFont systemFontOfSize:12.0];
        lblEngTotal.backgroundColor=[UIColor clearColor];
        
        float AccTotal = [[GlobalDirector ReplaceStringNull:[dic valueForKey:@"EngineerTotal"]] floatValue];
        
        lblEngTotal.text=[NSString stringWithFormat:@"%0.2f",AccTotal];
        
        
        
        [cell.contentView addSubview:lblEngTotal];
        
        currY=CGRectGetMaxY(lblEngTotal.frame);
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
        {
            UILabel *lbl3;
            lbl3=[[UILabel alloc] initWithFrame:CGRectMake(15,currY,90,25)];
            lbl3.textAlignment=NSTextAlignmentLeft;
            lbl3.textColor=[UIColor darkGrayColor];
            lbl3.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
            lbl3.backgroundColor=[UIColor clearColor];
            lbl3.text=@"ActualTotal:";
            [cell.contentView addSubview:lbl3];
            
            
            UILabel *lblAccTotal;
            lblAccTotal=[[UILabel alloc] initWithFrame:CGRectMake(100,currY,215,28)];
            lblAccTotal.textAlignment=NSTextAlignmentLeft;
            lblAccTotal.textColor=[UIColor blueColor];
            lblAccTotal.font=[UIFont systemFontOfSize:12.0];
            lblAccTotal.backgroundColor=[UIColor clearColor];
            float AccTotal = [[GlobalDirector ReplaceStringNull:[dic valueForKey:@"ActualTotal"]] floatValue];
            
            lblAccTotal.text=[NSString stringWithFormat:@"%0.2f",AccTotal];
            
            
           
            [cell.contentView addSubview:lblAccTotal];
            
            
            currY=CGRectGetMaxY(lblAccTotal.frame);
        }
        
        UILabel *lbl4;
        lbl4=[[UILabel alloc] initWithFrame:CGRectMake(15,currY+2,90,28)];
        lbl4.textAlignment=NSTextAlignmentLeft;
        lbl4.textColor=[UIColor darkGrayColor];
        lbl4.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
        lbl4.backgroundColor=[UIColor clearColor];
        lbl4.text=@"Description:";
        [cell.contentView addSubview:lbl4];
        
        UILabel *lblNoteBody;
        lblNoteBody=[[UILabel alloc] initWithFrame:CGRectMake(100,currY+2,215,28)];
        lblNoteBody.textAlignment=NSTextAlignmentLeft;
        lblNoteBody.textColor=[UIColor blueColor];
        lblNoteBody.font=[UIFont systemFontOfSize:12.0];
        lblNoteBody.backgroundColor=[UIColor clearColor];
        lblNoteBody.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"Description"]];
        [cell.contentView addSubview:lblNoteBody];
     
        
        if (![(NSArray *)[dic valueForKey:@"ImagePath"] isKindOfClass:[NSNull class]])
        {
            if ([(NSArray *)[dic valueForKey:@"ImagePath"]count]>0)
            {
                
                UIButton *btnAttachments;
                btnAttachments=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame)-50,66,32,32)];
                [btnAttachments setBackgroundImage:[UIImage imageNamed:@"attachement-icon"] forState:UIControlStateNormal];
                btnAttachments.backgroundColor=[UIColor clearColor];
                btnAttachments.tag=indexPath.row;
                [btnAttachments addTarget:self action:@selector(btnAttachmentPress:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btnAttachments];
            }
        }
    }
  
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblView)
    {
        return 45;
    }
    return 150;
  
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
    if (tableView==tblView)
    {
        NSDictionary *dic=[arrFeedTblPopup objectAtIndex:indexPath.row];
        Activetxtfld.text=[NSString stringWithFormat:@"  %@",[dic valueForKey:@"DisplayText"]];
        Activetxtfld.tag=[[dic valueForKey:@"Value"]integerValue];
        
        
        if (Activetxtfld==txtCostType) {
            [dicCosts setObject:[NSString stringWithFormat:@"%@",[dic valueForKey:@"Value"]] forKey:@"CostTypeID"];
            [dicCosts setObject:Activetxtfld.text forKey:@"DisplayTextCostType"];
        }
        if (Activetxtfld==txtCostNo) {
            [dicCosts setObject:[NSString stringWithFormat:@"%@",[dic valueForKey:@"Value"]] forKey:@"CostNumberID"];
            [dicCosts setObject:Activetxtfld.text forKey:@"DisplayTextCostNo"];
        }
      
        [tblView removeFromSuperview];
        tblView=nil;
    }
    
}



#pragma mark - Cost Add Method
- (IBAction)btnAddTapped:(id)sender
{
    
    arrImages = [[NSMutableArray alloc] init];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.barTintColor=[UIColor whiteColor];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)],
                           nil];
    [numberToolbar sizeToFit];
    CGFloat currY=40;
    dicCosts=[[NSMutableDictionary alloc]init];
    
    mainBg = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    mainBg.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    [mainBg setContentSize:CGSizeMake(self.view.frame.size.width,self.view.frame.size.height+120)];
    
    bgVw = [[UIView alloc] initWithFrame:CGRectMake(0,0,280,480)];
    bgVw.center=CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, CGRectGetHeight(self.view.frame)/2.0f);
    [bgVw.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [bgVw.layer setBorderWidth: 0.5];
    [bgVw.layer setCornerRadius:4.0f];
    [bgVw.layer setMasksToBounds:YES];
    bgVw.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    
    UILabel *lbheader = [[UILabel alloc] initWithFrame:CGRectMake(20,5,240,29)];
    lbheader.center=CGPointMake(CGRectGetWidth(bgVw.frame)/2.0f, lbheader.center.y);
    lbheader.text = @"Add Cost";
    lbheader.font = [UIFont fontWithName:@"TheSansArabic-Bold" size:18.0];
    lbheader.textAlignment = NSTextAlignmentCenter;
    lbheader.textColor=[UIColor grayColor];
    [bgVw addSubview:lbheader];
    
    txtCostNo = [[UITextField alloc] initWithFrame:CGRectMake(20,currY,240,30)];
    txtCostNo.textColor=[UIColor darkGrayColor];
    txtCostNo.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    [txtCostNo setBorderStyle:UITextBorderStyleNone];
    txtCostNo.layer.borderWidth=0.5f;
    txtCostNo.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    txtCostNo.layer.cornerRadius=0.0f;
    txtCostNo.backgroundColor=[UIColor whiteColor];
    txtCostNo.delegate = self;
    txtCostNo.userInteractionEnabled=YES;
    txtCostNo.placeholder=@" Cost No";
  
    UIImageView *imgDropdown1=[[UIImageView alloc] initWithFrame:CGRectMake(225, currY, 35, 30)];
    [imgDropdown1 setImage:[UIImage imageNamed:@"dropdown"]];

    currY =CGRectGetMaxY(txtCostNo.frame);
    
    txtCostType = [[UITextField alloc] initWithFrame:CGRectMake(20,currY+10,240,30)];
    txtCostType.textColor=[UIColor darkGrayColor];
    txtCostType.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    [txtCostType setBorderStyle:UITextBorderStyleNone];
    txtCostType.layer.borderWidth=0.5f;
    txtCostType.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    txtCostType.layer.cornerRadius=0.0f;
    txtCostType.backgroundColor=[UIColor whiteColor];
    txtCostType.delegate = self;
    txtCostType.userInteractionEnabled=YES;
    txtCostType.placeholder=@" Cost Type";

    UIImageView *imgDropdown2=[[UIImageView alloc] initWithFrame:CGRectMake(225,currY+10, 35, 30)];
    [imgDropdown2 setImage:[UIImage imageNamed:@"dropdown"]];
    currY =CGRectGetMaxY(txtCostType.frame);
    
    
    txtEngineerTotal = [[UITextField alloc] initWithFrame:CGRectMake(20,currY +10,240,30)];
    txtEngineerTotal.textColor=[UIColor darkGrayColor];
    txtEngineerTotal.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    [txtEngineerTotal setBorderStyle:UITextBorderStyleNone];
    txtEngineerTotal.layer.borderWidth=0.5f;
    txtEngineerTotal.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    txtEngineerTotal.layer.cornerRadius=0.0f;
    txtEngineerTotal.backgroundColor=[UIColor whiteColor];
    txtEngineerTotal.delegate = self;
    txtEngineerTotal.userInteractionEnabled=YES;
    txtEngineerTotal.placeholder=@" Costs Engineer Sub Total";
    
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(10,0,19,30)];
    leftView.backgroundColor = [UIColor clearColor];
    leftView.textAlignment=NSTextAlignmentLeft;
    leftView.text=@" \u00a3 ";
    
    txtEngineerTotal.leftView = leftView;
    txtEngineerTotal.leftViewMode = UITextFieldViewModeAlways;
    txtEngineerTotal.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtEngineerTotal.keyboardType=UIKeyboardTypeDecimalPad;
    txtEngineerTotal.inputAccessoryView = numberToolbar;
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        txtEngineerTotal.placeholder=@"Costs Sub Total";
        txtActualTotal = [[UITextField alloc] init];
        txtActualTotal.text=@"0";
    }
    currY =CGRectGetMaxY(txtEngineerTotal.frame);
   
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        txtActualTotal = [[UITextField alloc] initWithFrame:CGRectMake(20,currY +10,240,30)];
        txtActualTotal.textColor=[UIColor darkGrayColor];
        txtActualTotal.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
        [txtActualTotal setBorderStyle:UITextBorderStyleNone];
        txtActualTotal.layer.borderWidth=0.5f;
        txtActualTotal.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        txtActualTotal.layer.cornerRadius=0.0f;
        txtActualTotal.backgroundColor=[UIColor whiteColor];
        txtActualTotal.delegate = self;
        txtActualTotal.userInteractionEnabled=YES;
        txtActualTotal.text=@"";
        txtActualTotal.placeholder=@"  Costs Actual Sub Total";
        
        UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(10,0,19,30)];
        leftView.backgroundColor = [UIColor clearColor];
        leftView.textAlignment=NSTextAlignmentLeft;
        leftView.text=@" \u00a3 ";
        
        txtActualTotal.leftView = leftView;
        txtActualTotal.leftViewMode = UITextFieldViewModeAlways;
        txtActualTotal.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtActualTotal.keyboardType=UIKeyboardTypeDecimalPad;
        txtActualTotal.inputAccessoryView = numberToolbar;
        
        currY =CGRectGetMaxY(txtActualTotal.frame);
    }
    
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20,currY +10,240,29)];
    lblTitle.text = @" Description";
    lblTitle.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.backgroundColor =[UIColor colorWithRed:52/255.0 green:54/255.0 blue:67/255.0 alpha:0.72];
    [lblTitle.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [lblTitle.layer setBorderWidth: 1.0];
    [lblTitle.layer setCornerRadius:0.0f];
    [lblTitle.layer setMasksToBounds:YES];
      currY =CGRectGetMaxY(lblTitle.frame);
    
    txtvNoteBody = [[UITextView alloc] initWithFrame:CGRectMake(20,currY +10,240,70)];
    txtvNoteBody.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    txtvNoteBody.textColor=[UIColor darkGrayColor];
    [txtvNoteBody setBackgroundColor:[UIColor whiteColor]];
    txtvNoteBody.delegate = self;
    [txtvNoteBody.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [txtvNoteBody.layer setBorderWidth: 1.0];
    [txtvNoteBody.layer setCornerRadius:0.0f];
    [txtvNoteBody.layer setMasksToBounds:YES];
    
    currY =CGRectGetMaxY(txtvNoteBody.frame);
    UILabel *onAcc=[[UILabel alloc]initWithFrame:CGRectMake(20,currY +10,80, 20)];
    onAcc.text=@"On Account: ";
    onAcc.font=[UIFont systemFontOfSize:13.0];
    UIButton *chkBox=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(onAcc.frame)+6,currY+8, 20, 20)];
    [chkBox setBackgroundImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    [chkBox addTarget:self action:@selector(ChkUnchk:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    btnCross=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCross.frame=CGRectMake(0, 0, 25, 25);
    btnCross.center=CGPointMake(CGRectGetMaxX(bgVw.frame),CGRectGetMinY(bgVw.frame));
    [btnCross setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
    [btnCross addTarget:self action:@selector(cross:) forControlEvents:UIControlEventTouchUpInside];
    [btnCross clipsToBounds];
    
    UIButton * btnAttachFile=[UIButton buttonWithType:UIButtonTypeCustom];
    btnAttachFile.frame=CGRectMake(0, 0,120, 25);
    btnAttachFile.center=CGPointMake(CGRectGetMinX(txtvNoteBody.frame)+60,CGRectGetMaxY(txtvNoteBody.frame)+53);
    [btnAttachFile setTitle:@"Attach Image" forState:UIControlStateNormal];
    btnAttachFile.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Bold" size:13];
    [btnAttachFile setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnAttachFile.layer.cornerRadius=4.0f;
    [btnAttachFile.layer setMasksToBounds:YES];
    btnAttachFile.backgroundColor=[UIColor colorWithRed:121/255.0 green:174/255.0 blue:31/255.0 alpha:1.0];
    [btnAttachFile addTarget:self action:@selector(btnAttachFileTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    btnSave=[UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.frame=CGRectMake(0,CGRectGetHeight(bgVw.frame)-40,280,40);
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSave.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:18.0];
    [btnSave setBackgroundColor:[UIColor colorWithRed:30/255.0 green:124/255.0 blue:41/255.0 alpha:1.0]];
    [btnSave addTarget:self action:@selector(savePress:) forControlEvents:UIControlEventTouchUpInside];
    [btnSave.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [btnSave.layer setBorderWidth: 1.0];
    [btnSave.layer setCornerRadius:0.0f];
    [btnSave.layer setMasksToBounds:YES];
    
    imgScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(txtvNoteBody.frame)-90, CGRectGetMaxY(txtvNoteBody.frame)+5, 90, 80)];
    imgScroll.backgroundColor=[UIColor clearColor];
    [bgVw addSubview:imgScroll];
    
    
    [bgVw addSubview:txtCostNo];
    [bgVw addSubview:imgDropdown1];
    [bgVw addSubview:txtCostType];
    [bgVw addSubview:imgDropdown2];
    [bgVw addSubview:txtEngineerTotal];
    [bgVw addSubview:txtActualTotal];
    [bgVw addSubview:lblTitle];
    [bgVw addSubview:txtvNoteBody];
    [bgVw addSubview:onAcc];
    [bgVw addSubview:chkBox];
    [bgVw addSubview:btnSave];
    
     if (![strFromCustomerClass isEqualToString:@"CreateJobEng"]){
         [bgVw addSubview:btnAttachFile];
     }
    
    
    [mainBg addSubview:bgVw];
    [mainBg addSubview:btnCross];

    mainBg.alpha=0.0f;
    
    [UIView animateWithDuration:0.2 animations:^{
        mainBg.alpha=1.0f;
        [self.view addSubview:mainBg];
    }];
}


-(void)cancel
{
    [Activetxtfld resignFirstResponder];
    //numberTextField.text = @"";
}
-(void)cross:(UIButton *)sender
{
    [mainBg removeFromSuperview];
    _btnAdd.userInteractionEnabled=YES;
    [arrImages removeAllObjects];
    currX=2.0f;
}

-(void)ChkUnchk:(UIButton *)sender
{
    if ([OnAccount isEqualToString:@"false"])
    {
        OnAccount=@"true";
        [sender setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
    else
    {
        OnAccount=@"false";
        [sender setBackgroundImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    }
   // DLog(@"OnAccount :%@",OnAccount);
}

#pragma mark - Cost Save method
-(void)savePress:(UIButton *)sender
{
    NSString *alertmsg;
    //DLog(@"note saved");
    
    if ([txtEngineerTotal.text isEqualToString:@""]||[self BlankSpaces:txtEngineerTotal]) {
        alertmsg=@"Enter Engineer Total";
        [self Showalert:alertmsg];
    }
    else if ([txtActualTotal.text isEqualToString:@""]||[self BlankSpaces:txtActualTotal])
    {
        alertmsg=@"Enter Actual Total";
        [self Showalert:alertmsg];
    }
    else if ([txtCostNo.text isEqualToString:@""]||[self BlankSpaces:txtCostNo])
    {
        alertmsg=@"Enter Cost Number";
        [self Showalert:alertmsg];
    }
    else if ([txtCostType.text isEqualToString:@""]||[self BlankSpaces:txtCostType])
    {
        alertmsg=@"Enter Cost Type";
        [self Showalert:alertmsg];
    }
    else if ([txtvNoteBody.text isEqualToString:@""]||[self BlankSpaces:txtvNoteBody])
    {
        alertmsg=@"Enter Cost Description";
        [self Showalert:alertmsg];
    }
    else
    {
        
        NSString* encodedImageString,*base64String;
        encodedImageString=@"";
        NSMutableArray *arrImageSrtrings=[[NSMutableArray alloc]init];
        
        for (UIImageView *imgvw in arrImages) {
            NSData *imageData = UIImageJPEGRepresentation(imgvw.image, 1.0);
            base64String = [imageData base64EncodedStringWithOptions:0];
            encodedImageString = [base64String stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
            [arrImageSrtrings addObject:encodedImageString];
            
        }
        [dicCosts setObject:arrImageSrtrings forKey:@"imageUpload"];
        [dicCosts setObject:@"jpg" forKey:@"imageextension"];
       // DLog(@"%@",base64String);
        
        [dicCosts setObject:txtvNoteBody.text forKey:@"Description"];
        [dicCosts setObject:txtEngineerTotal.text forKey:@"EngineerTotal"];
        [dicCosts setObject:txtActualTotal.text forKey:@"ActualTotal"];
        [dicCosts setObject:txtCostNo.text forKey:@"CostNumberID"];
        [dicCosts setObject:OnAccount forKey:@"OnAccount"];
        
        Costs = [Costs mutableCopy];
       // [Costs addObject:dicCosts];
        
        
        NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
        
        if ([strFromCustomerClass isEqualToString:@"ManagerJobDetails"]||[strFromCustomerClass isEqualToString:@"Customer_EngineerJobDetails"])
        {
            
            if ([self InternetConnectionAvailable]==YES) {
            
            NSError *error;
            NSArray *arrDic=[NSArray arrayWithObjects:dicCosts, nil];
            NSData *jsonAddress = [NSJSONSerialization dataWithJSONObject:arrDic
                                                                  options:0
                                                                    error:&error];
            NSString *materialsJsonString = [[NSString alloc] initWithBytes:[jsonAddress bytes] length:[jsonAddress length] encoding:NSUTF8StringEncoding];
            NSString *urlStr=[NSString stringWithFormat:@"%sSetJobCost",conn_url];
            
            NSString *json;
            NSError *jsonError;
            NSMutableData *body = [NSMutableData data];
            NSDictionary *_params=[[NSDictionary alloc]initWithObjects:@[(NSString *)[userdetails valueForKey:@"UserToken"],(NSString *)[userdetails valueForKey:@"UserID"],jobID,materialsJsonString] forKeys:@[@"userToken",@"userId",@"jobId",@"cost"]];
            
            NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
           
            NSData *reqData=[NSData dataWithBytes:[json UTF8String] length:[json length]];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%ld",(unsigned long)[reqData length]] forHTTPHeaderField:@"Content-Length"];
                request.timeoutInterval = 300;
            NSData *postData = [NSJSONSerialization dataWithJSONObject:_params options:0
                                                                 error:&jsonError];
            if (!jsonError)
            {
                [request setHTTPBody:postData];
            }
                
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setURL:[NSURL URLWithString:urlStr]];
            
            connPostCost = [[NSURLConnection alloc]init];
                
                [self PostDataToServerWithUrl:urlStr dataDictionary:_params finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error==nil) {

                            _responseData=[data mutableCopy];
                            [self connectionDidFinishLoading:connPostCost];
                            
                        }
                        
                        else
                        {
                            [self showAlert:[NSString stringWithFormat:@"%@",error.localizedDescription] withTitle:@"Try Again !!"];
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            
                        }
                    });
                    
                }];
            // [connPostCost start];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            }
            
            
            else
            {
                [self showAlert:@"Network connection not available" withTitle:@"Connection Problem!"];
            }
        }
        else
        {
            [Costs addObject:dicCosts];
            [mainBg removeFromSuperview];
            [_tblCost reloadData];
        }
    }

}




#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *res=(NSHTTPURLResponse*)response;
    if ([res statusCode] == 404)
    {
        DLog(@"404 error");
    }
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSDictionary *dict = httpResponse.allHeaderFields;
    NSString *lengthString = [dict valueForKey:@"Content-Length"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *length = [formatter numberFromString:lengthString];
    self.totalBytes = length.unsignedIntegerValue;
    
    if (connection==connDownloadImage)
    {
        _imageData=[[NSMutableData alloc] initWithCapacity:self.totalBytes];
    }
    else
    {
        _responseData = [[NSMutableData alloc] init];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the instance variable you declared
    if (connection==connDownloadImage) {
        [_imageData appendData:data];
        self.receivedBytes += data.length;
        hud.progress=(float)_receivedBytes/(float)_totalBytes;
        
        
        
        
        
    }
    else
    {
        [_responseData appendData:data];
    }
}
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    return nil;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection==connDownloadImage)
    {
        
        [webV loadData:_imageData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@""]];
        hud.hidden=YES;
        
    }
    else
    {
        NSMutableDictionary* temp;
        if (_responseData !=nil)
        {
            NSError *error;
            
            temp = [NSJSONSerialization JSONObjectWithData:_responseData  options:NSJSONReadingMutableContainers error:&error];
            if (!error)
            {
                if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
                {
                    NSArray *arrM=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrEditedJobDic"];
                    NSMutableArray *mutableCopy=[arrM mutableCopy];
                    if (mutableCopy==nil) {
                        mutableCopy=[[NSMutableArray alloc]init];
                    }
                    
                    [mutableCopy containsObject:jobID]?NSLog(@"ID already Present"):[mutableCopy addObject:jobID];
                    [[NSUserDefaults standardUserDefaults]setObject:mutableCopy forKey:@"arrEditedJobDic"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    NSArray *arr = [temp valueForKey:@"CostRecordList"];
                    
                    if (arr.count>0) {
                        NSDictionary *dict = [arr objectAtIndex:0];
                        [Costs insertObject:dict atIndex:0];
                    }
                    
                    
                    DLog(@"%@",temp);
                }
            }
            else
            {
                DLog(@"JSONObjectWithData error: %@", error);
            }
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [mainBg removeFromSuperview];
        [_tblCost reloadData];
    }
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
   // [[[UIAlertView alloc]initWithTitle:@"Error" message:@"No network connection. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
    
    
    [self showAlert:@"No network connection. Please try again later."  withTitle:@"Error"];

}


#pragma mark - Form Validation Checking Method
-(void)Showalert:(NSString *)msg
{
    [self showAlert:msg withTitle:@""];
    
    
}
-(BOOL)BlankSpaces:(id )txtfld
{
    NSString *rawString;
    if([txtfld isKindOfClass:[UITextField class]])
    {
        rawString=[(UITextField*)txtfld text];
        
    }
    if([txtfld isKindOfClass:[UITextView class]])
    {
        rawString=[(UITextView*)txtfld text];
        
    }
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    if ([trimmed length] == 0) {
        // Text was empty or only whitespace.
        return YES;
        
    }
    return NO;
    
}


#pragma mark - PopUp List & Fetch DropDown Master Method
-(void)popupList
{
    
   
    
    if (tblView!=nil)
    {
        [tblView removeFromSuperview];
        tblView=nil;
    }
    else
    {
        arrFeedTblPopup= [self GetDataForPoppup:Activetxtfld];
        tblView=[[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMinX(Activetxtfld.frame),CGRectGetMaxY(Activetxtfld.frame)+2, CGRectGetWidth(Activetxtfld.frame), 0) style:UITableViewStylePlain];
        tblView.delegate=self;
        tblView.dataSource=self;
        [bgVw addSubview:tblView];
        
        
        
        [tblView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [tblView.layer setBorderWidth: 2.0];
        [tblView.layer setCornerRadius:3.0f];
        [tblView.layer setMasksToBounds:YES];
        
        [UIView animateWithDuration:0.35
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect frame = tblView.frame;
                             frame.size.height = self.view.frame.size.height/4.0f;
                             tblView.frame = frame;
                         }
                         completion:^(BOOL finished){
                             DLog(@"Done!");
                         }];
    }
    
}
-(NSArray *)GetDataForPoppup:(UITextField *)fld
{
     [MBProgressHUD showHUDAddedTo:Activetxtfld animated:YES];
    
    if (fld==txtCostType){
        
        [self fetchDropDownForTextField:@"GetJobCostType" didFinishLoading:^(BOOL success , NSArray *arrData){
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                
                [MBProgressHUD hideAllHUDsForView:Activetxtfld animated:YES];
                
                Activetxtfld.userInteractionEnabled=YES;
                arrFeedTblPopup=arrData;
                [tblView reloadData];
                
            });
            
        }];
        
    }
    if (fld==txtCostNo){
       
        [self fetchDropDownForTextField:@"GetCostNumberID" didFinishLoading:^(BOOL success , NSArray *arrData){
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                
                [MBProgressHUD hideAllHUDsForView:Activetxtfld animated:YES];
                
                Activetxtfld.userInteractionEnabled=YES;
                arrFeedTblPopup=arrData;
                [tblView reloadData];
                
            });
            
        }];
    }
    return nil;
}



#pragma mark UITextField Delegates
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
       Activetxtfld=textField;
    if (textField==txtCostType||textField==txtCostNo)
    {
        [self.view endEditing:YES];
        
     
        [self popupList];
    }
    
    return YES;
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
     Activetxtfld=textField;
    if (textField==txtCostType||textField==txtCostNo)
    {
        [self.view endEditing:YES];
        
       
       
    }
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextView Delegates
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}


#pragma mark- Image Attchment Upload Section
-(void)animateToActiveButton:(UIButton *)btn withImageview:(UIImageView *)img
{
    img.backgroundColor=[UIColor whiteColor];
    [UIView animateWithDuration:0.35 animations:^{
        img.frame=btn.frame;
        
    }];
}
-(IBAction)btnAttachFileTapped:(id)sender
{
    
    if (arrImages.count==4)
    {
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
        [self.view addSubview:mainBgNoteDesc];
    }
}
- (IBAction)takePhoto:(UIButton *)sender
{
    DLog(@"%@",[[UIDevice currentDevice] model]);
    if (![[[UIDevice currentDevice] model]isEqualToString:@"iPhone Simulator"])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
- (IBAction)selectPhoto:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark- UIImagePickerController Delegates
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo
{
    UIImage *chosenImage  = [editInfo objectForKey:@"UIImagePickerControllerOriginalImage"];
    DLog(@"imageview subview :- %@",imgScroll.subviews);
    DLog(@"chosenImage:%@",chosenImage);
    
    NSString* encodedImageString;
    encodedImageString=@"";
    
    UIImageView *imgvw=[[UIImageView alloc]initWithFrame:CGRectMake(currX+2, 2, 80, 80)];
    imgvw.userInteractionEnabled=YES;
    imgvw.image=img;
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
    imgScroll.pagingEnabled=YES;
    currX=CGRectGetMaxX(imgvw.frame);
    [imgScroll addSubview:imgvw];
    [arrImages addObject:imgvw];
    [self crossNoteDesc:nil];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark- UIGesture Controller Delegates
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    DLog(@"%@",touch.view);
    if ([touch.view isDescendantOfView:tblView])
    {
        return NO;
    }
    return YES;
}

#pragma mark- UIWebView delegate Method
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
}

#pragma mark- Attchment PopUp View Method Press
-(IBAction)btnAttachmentPress:(UIButton *)sender
{
    DLog(@"sender.tag ::: %ld",(long)sender.tag);
    
   
     NSDictionary *dic=[Costs objectAtIndex:sender.tag];
    
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
    
    CGFloat currXx=20.0f;
    for (int i=0;i<[arr count];i++)
    {
        bgVwNoteDesc = [[UIView alloc] initWithFrame:CGRectMake(currXx,0,300,360)];
        bgVwNoteDesc.center=CGPointMake(bgVwNoteDesc.center.x, self.view.frame.size.height/2.0f);
        
        [bgVwNoteDesc.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
        [bgVwNoteDesc.layer setBorderWidth: 0.5];
        [bgVwNoteDesc.layer setCornerRadius:4.0f];
        [bgVwNoteDesc.layer setMasksToBounds:YES];
        bgVwNoteDesc.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
        
        NSURL *url = [NSURL URLWithString:[[arr objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        DLog(@"urlurlurlurlurlurlurlurl %@",url);
      
        
        webV=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 300, 360)];
        webV.center=CGPointMake(CGRectGetWidth(bgVwNoteDesc.frame)/2.0f, CGRectGetHeight(bgVwNoteDesc.frame)/2.0f);
        webV.backgroundColor=[UIColor lightGrayColor];
        webV.delegate=self;
        [webV loadRequest:[NSURLRequest requestWithURL:url]];
        [webV setScalesPageToFit:YES];
        [bgVwNoteDesc addSubview:webV];
        
        btnCrossNoteDesc=[UIButton buttonWithType:UIButtonTypeCustom];
        btnCrossNoteDesc.frame=CGRectMake(0, 0, 25, 25);
        btnCrossNoteDesc.center=CGPointMake(CGRectGetMaxX(webV.frame)-15,CGRectGetMinY(webV.frame)+15);
        [btnCrossNoteDesc setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
        [btnCrossNoteDesc addTarget:self action:@selector(crossNoteDesc:) forControlEvents:UIControlEventTouchUpInside];
        [btnCrossNoteDesc clipsToBounds];
        currXx=currXx+CGRectGetWidth(bgVwNoteDesc.frame)+10 ;
        [mainBgNoteDesc addSubview:bgVwNoteDesc];
        [bgVwNoteDesc addSubview:btnCrossNoteDesc];
        [self.view addSubview:mainBgNoteDesc];
    }
    
    mainBgNoteDesc.contentSize=CGSizeMake(currXx, mainBgNoteDesc.frame.size.height);

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
-(void)crossNoteDesc:(id)sender
{
    [mainBgNoteDesc removeFromSuperview];
    _totalBytes=0;
    _receivedBytes=0;
    
    
}
-(void)ClosePopUpAndClearData
{
    [mainBgNoteDesc removeFromSuperview];
    _totalBytes=0;
    _receivedBytes=0;
    currX=2.0f;
    [arrImages removeAllObjects];
}

@end
