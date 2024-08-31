
//  AddNotes.m
//  Partner Maintenance


#import "AddNotes.h"
#import "CreateJob.h"
#import "CreateJobEng.h"

@interface AddNotes ()

@end

@implementation AddNotes
@synthesize strHeading;
@synthesize arrMAllNotes,Notes;
@synthesize strFromCustomerClass;


-(void)viewDidLoad
{
    [super viewDidLoad];
     [_lblHeading setFont:[UIFont fontWithName:@"TheSansArabic-Bold" size:18.0]];
   
    _lblHeading.text=strHeading;
    
    if (Notes==nil)
    {
        Notes=[[NSMutableArray alloc]init];
    }
    
    
    _tabvNotes.backgroundView=nil;
    _tabvNotes.backgroundColor=[UIColor clearColor];
    _tabvNotes.separatorColor=[UIColor clearColor];
    newNotes=[[NSMutableArray alloc]init];
    prevNotes=[[NSMutableArray alloc]init];
    arrImages=[[NSMutableArray alloc]init];

    
    DLog(@"From Class Name: %@",strFromCustomerClass);
    
    DLog(@"_jobID  ::::%@",_jobID);

    
    if ([strFromCustomerClass isEqualToString:@"ManagerJobDetails"]||[strFromCustomerClass isEqualToString:@"Customer_EngineerJobDetails"])
    {
        if ([_jobStatus integerValue]==3 && [strFromCustomerClass isEqualToString:@"Customer_EngineerJobDetails"]){
            _btnAdd.hidden=YES;
        }
        else
        {
            _btnAdd.hidden=NO;
        }
    
    }
    
   // [self btnNewNotesTapped:nil];
    
    if (_jobID) {
        [self fetchNoteList];
    }
    
   
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (IBAction)backTapped:(id)sender
{
    
   // DLog(@"%@",Notes);
    if([self.delegate respondsToSelector:@selector(addItemViewController:didFinishEnteringItem:)])
    {
        [self.delegate addItemViewController:self didFinishEnteringItem:Notes];
        
    }
   
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)fetchNoteList{
    
    
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[GlobalDirector ReplaceStringNull:[userdetails valueForKey:@"UserToken"]] forKey:@"userToken"];
    [dict setObject:_jobID forKey:@"jobID"];
    
    
    
    GlobalDirector *globe = [GlobalDirector SharedDirector];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [globe SyncRequestGet:REQUEST_FetchNoteList withPrams:dict andCompletionHandler:^(NSDictionary *result) {
        
        DLog(@"%@",result);
        
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            @try {
                
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                Notes = [[NSMutableArray alloc] init];
                
                NSArray *arrAdd= [result valueForKey:@"NoteRecordList"];
                [Notes addObjectsFromArray:arrAdd];
                
                 [self btnNewNotesTapped:nil];
                
            } @catch (NSException *exception) {
                
                if (!Notes) {
                    Notes = [[NSMutableArray alloc] init];
                }
                
            }@finally{
                
                [_tabvNotes reloadData];
                
            }
        });
        
    }];
    
    
}



    
#pragma mark - Add Note Method
- (IBAction)btnAddTapped:(id)sender
{
    
    arrImages = [[NSMutableArray alloc] init];
    dicNotes=[[NSMutableDictionary alloc]init];
    
    mainBg = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    mainBg.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    
    bgVw = [[UIView alloc] initWithFrame:CGRectMake(0,0,280,350)];
    bgVw.center=CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, CGRectGetHeight(self.view.frame)/2.0f);
    
    [bgVw.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [bgVw.layer setBorderWidth: 0.5];
    [bgVw.layer setCornerRadius:4.0f];
    [bgVw.layer setMasksToBounds:YES];
    bgVw.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    CGFloat currY=40.0f;
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20,5,240,29)];
    lblTitle.center=CGPointMake(CGRectGetWidth(bgVw.frame)/2.0f, lblTitle.center.y);
    
    lblTitle.text = @"Add Note";
    lblTitle.font = [UIFont fontWithName:@"TheSansArabic-Bold" size:18.0];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.textColor=[UIColor grayColor];
    [bgVw addSubview:lblTitle];
    
    //--------- Note Type ----------------
    txtNoteType = [[UITextField alloc] initWithFrame:CGRectMake(20,currY,240,30)];
    txtNoteType.textColor=[UIColor darkGrayColor];
    txtNoteType.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    [txtNoteType setBorderStyle:UITextBorderStyleNone];
    txtNoteType.layer.borderWidth=0.5f;
    txtNoteType.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    txtNoteType.layer.cornerRadius=0.0f;
    txtNoteType.backgroundColor=[UIColor whiteColor];
    txtNoteType.delegate = self;
    txtNoteType.userInteractionEnabled=YES;
    txtNoteType.placeholder=@" Note Type";
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
    {
        txtNoteType.text=@" Customer";
        txtNoteType.userInteractionEnabled=NO;
    }
    currY=CGRectGetMaxY(txtNoteType.frame);
    
    UIImageView *imgDropdown1=[[UIImageView alloc] initWithFrame:CGRectMake(225,currY, 35, 30)];
    imgDropdown1.center=CGPointMake(CGRectGetMaxX(txtNoteType.frame)-35, CGRectGetHeight(txtNoteType.frame)/2.0f);
    [imgDropdown1 setImage:[UIImage imageNamed:@"dropdown"]];
    
    UILabel *lbldesc = [[UILabel alloc] initWithFrame:CGRectMake(20,90,240,29)];
    lbldesc.text = @" Note Description";
    lbldesc.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    lbldesc.textAlignment = NSTextAlignmentLeft;
    lbldesc.textColor=[UIColor whiteColor];
    lbldesc.backgroundColor =[UIColor colorWithRed:52/255.0 green:54/255.0 blue:67/255.0 alpha:0.72];
    [lbldesc.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [lbldesc.layer setBorderWidth: 1.0];
    [lbldesc.layer setCornerRadius:0.0f];
    [lbldesc.layer setMasksToBounds:YES];
    
    txtvNoteBody = [[UITextView alloc] initWithFrame:CGRectMake(20,130,240,90)];
    txtvNoteBody.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    txtvNoteBody.textColor=[UIColor darkGrayColor];
    [txtvNoteBody setBackgroundColor:[UIColor whiteColor]];
    txtvNoteBody.delegate = self;
    [txtvNoteBody.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [txtvNoteBody.layer setBorderWidth: 1.0];
    [txtvNoteBody.layer setCornerRadius:0.0f];
    [txtvNoteBody.layer setMasksToBounds:YES];
    
    btnCross=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCross.frame=CGRectMake(0, 0, 25, 25);
    btnCross.center=CGPointMake(CGRectGetMaxX(bgVw.frame),CGRectGetMinY(bgVw.frame));
    [btnCross setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
    [btnCross addTarget:self action:@selector(cross:) forControlEvents:UIControlEventTouchUpInside];
    [btnCross clipsToBounds];
    
    UIButton * btnAttachFile=[UIButton buttonWithType:UIButtonTypeCustom];
    btnAttachFile.frame=CGRectMake(0, 0,120, 25);
    btnAttachFile.center=CGPointMake(CGRectGetMinX(txtvNoteBody.frame)+60,CGRectGetMaxY(txtvNoteBody.frame)+33);
    [btnAttachFile setTitle:@"Attach Image" forState:UIControlStateNormal];
    btnAttachFile.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13];
    [btnAttachFile setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnAttachFile.layer.cornerRadius=4.0f;
    [btnAttachFile.layer setMasksToBounds:YES];
    btnAttachFile.backgroundColor=[UIColor colorWithRed:137/255.0 green:182/255.0 blue:40/255.0 alpha:1.0];
    [btnAttachFile addTarget:self action:@selector(btnAttachFileTapped:) forControlEvents:UIControlEventTouchUpInside];
  
    btnAddNotes=[UIButton buttonWithType:UIButtonTypeCustom];
    btnAddNotes.frame=CGRectMake(0,CGRectGetHeight(bgVw.frame)-40,280,40);
    [btnAddNotes setTitle:@"Save" forState:UIControlStateNormal];
    [btnAddNotes setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnAddNotes.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:18.0];
    [btnAddNotes setBackgroundColor:[UIColor colorWithRed:30/255.0 green:124/255.0 blue:41/255.0 alpha:1.0]];
    [btnAddNotes addTarget:self action:@selector(savenotePress:) forControlEvents:UIControlEventTouchUpInside];
    [btnAddNotes.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [btnAddNotes.layer setBorderWidth: 1.0];
    [btnAddNotes.layer setCornerRadius:0.0f];
    [btnAddNotes.layer setMasksToBounds:YES];
   
    imgScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(txtvNoteBody.frame)-90, CGRectGetMaxY(txtvNoteBody.frame)+5, 90, 80)];
    imgScroll.backgroundColor=[UIColor clearColor];
    [bgVw addSubview:imgScroll];
   
    [txtNoteType addSubview:imgDropdown1];
    [bgVw addSubview:txtNoteType];
  
    [bgVw addSubview:lbldesc];
    [bgVw addSubview:txtvNoteBody];
    [bgVw addSubview:btnAddNotes];
    
    if (![strFromCustomerClass isEqualToString:@"CreateJobEng"]){
        [bgVw addSubview:btnAttachFile];
    }
    
   // [bgVw addSubview:btnAttachFile];
    
    [mainBg addSubview:bgVw];
    [mainBg addSubview:btnCross];
    //[self.view addSubview:mainBg];
    
    mainBg.alpha=0.0f;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        
        mainBg.alpha=1.0f;
        
        [self.view addSubview:mainBg];
        
    }];
    
    
    
}


-(void)animateToActiveButton:(UIButton *)btn withImageview:(UIImageView *)img
{
    img.backgroundColor=[UIColor whiteColor];
    [UIView animateWithDuration:0.35 animations:^{
        img.frame=btn.frame;
        
    }];
}



-(IBAction)btnAttachFileTapped:(id)sender{
    
    
    if (arrImages.count==4) {
        
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

- (IBAction)takePhoto:(UIButton *)sender {
    
    DLog(@"%@",[[UIDevice currentDevice] model]);
    
    if (![[[UIDevice currentDevice] model]isEqualToString:@"iPhone Simulator"]) {
        
   
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    }
    
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

 CGFloat currX=2.0f;


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo
{
   
    
    DLog(@"imageview subview :- %@",imgScroll.subviews);

   
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
-(void)cross:(id)sender
{
    [mainBg removeFromSuperview];
    _btnAdd.userInteractionEnabled=YES;
    currX=2.0f;
    [arrImages removeAllObjects];
}
- (void)tapTest:(UITapGestureRecognizer *)sender
{
    [mainBg removeFromSuperview];
    _btnAdd.userInteractionEnabled=YES;
}




-(void)savenotePress:(UIButton *)sender
{
    NSString *alertmsg;
    DLog(@"note saved");
    
    if ([txtNoteType.text isEqualToString:@""]||[self BlankSpaces:txtNoteType])
    {
        alertmsg=@"Enter Note Type";
        [self Showalert:alertmsg];
        
    }
    else if ([txtvNoteBody.text isEqualToString:@""]||[self BlankSpaces:txtvNoteBody])
    {
        alertmsg=@"Note should not be blanked / Enter Note ";
        [self Showalert:alertmsg];
    }
    else
    {
        NSString* encodedImageString,*base64String;
        encodedImageString=@"";
        NSMutableArray *arrImageSrtrings=[[NSMutableArray alloc]init];
        for (UIImageView *imgvw in arrImages)
        {
            NSData *imageData = UIImageJPEGRepresentation(imgvw.image, 1.0);
            base64String = [imageData base64EncodedStringWithOptions:0];
            encodedImageString = [base64String stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
            [arrImageSrtrings addObject:encodedImageString];
        }
      
        NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];

        [dicNotes setObject:[userdetails valueForKey:@"FullName"] forKey:@"CreatedBy"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss a"];
        [dicNotes setObject:[NSString stringWithFormat:@"%@",[dateFormat stringFromDate:[NSDate date]]] forKey:@"CreatedDate"];
        [dicNotes setObject:txtvNoteBody.text forKey:@"NoteBody"];
        [dicNotes setObject:[NSString stringWithFormat:@"false"] forKey:@"IsPreviousJobNote"];
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"cu"])
        {
            [dicNotes setObject:[NSString stringWithFormat:@"1"] forKey:@"NoteTypeID"];
            [dicNotes setObject:[NSString stringWithFormat:@"Customer"] forKey:@"DisplayTextNoteType"];
            
        }
        
        [dicNotes setObject:arrImageSrtrings forKey:@"imageUpload"];
        [dicNotes setObject:@"jpg" forKey:@"imageextension"];
       // DLog(@"%@",base64String);
        Notes = [Notes mutableCopy];
      //  [Notes addObject:dicNotes];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"CreatedDate" ascending: NO];
        NSArray *arr = [Notes sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        Notes = [arr mutableCopy];
        
        newNotes=[Notes mutableCopy];
        
        
        if ([strFromCustomerClass isEqualToString:@"ManagerJobDetails"]||[strFromCustomerClass isEqualToString:@"Customer_EngineerJobDetails"])
        {
            
            if ([self InternetConnectionAvailable]==YES) {
                
            NSError *error;
            
            NSArray *arrDic=[NSArray arrayWithObjects:dicNotes, nil];
            
            NSData *jsonAddress = [NSJSONSerialization dataWithJSONObject:arrDic
                                                                  options:0
                                                                    error:&error];
            NSString *note = [[NSString alloc] initWithBytes:[jsonAddress bytes] length:[jsonAddress length] encoding:NSUTF8StringEncoding];
            
            NSString *urlStr=[NSString stringWithFormat:@"%sSetJobNote",conn_url];
    
           
            NSString *json;
            NSError *jsonError;
            
            
            NSMutableData *body = [NSMutableData data];
            NSDictionary *_params=[[NSDictionary alloc]initWithObjects:@[(NSString *)[userdetails valueForKey:@"UserToken"],(NSString *)[userdetails valueForKey:@"UserID"],_jobID,note] forKeys:@[@"userToken",@"userId",@"jobId",@"note"]];
                NSLog(@"_params%@",_params);
                NSLog(@"urlStr%@",urlStr);

                ///only testing
                NSData *noteData = [NSJSONSerialization dataWithJSONObject:_params
                                                                      options:0
                                                                        error:&error];
                NSString *noteTest = [[NSString alloc] initWithBytes:[noteData bytes] length:[noteData length] encoding:NSUTF8StringEncoding];

                NSLog(@"%@",noteTest);
                //******
            
           NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
           // DLog(@"request :%@",request);
            NSData *reqData=[NSData dataWithBytes:[json UTF8String] length:[json length]];
            
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%ld",(unsigned long)[reqData length]] forHTTPHeaderField:@"Content-Length"];
            request.timeoutInterval = 300;
            //[request setHTTPBody:reqData];
            NSData *postData = [NSJSONSerialization dataWithJSONObject:_params options:0
                                                                 error:&jsonError];
                
                
                
            if (!jsonError)
            {
                //set POST body
                [request setHTTPBody:postData];
            }
      
                
            // set the content-length
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            
            // set URL
            [request setURL:[NSURL URLWithString:urlStr]];
            
            
            NSLog(@"Add Note %@", request);
            connPostNote = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [connPostNote start];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            }
            
            else
            {
                [self showAlert:@"Network connection not available" withTitle:@"Connection Problem!"];
            }
        }
     
        else
        {
             [Notes addObject:dicNotes];
            newNotes=[Notes mutableCopy];
            [mainBg removeFromSuperview];
            [_tabvNotes reloadData];
            txtNoteTo.text=@"";
            txtNoteType.text=@"";
            txtvNoteBody.text=@"";
            
            [self btnNewNotesTapped:nil];
            
        }
    }
  
    
    [_tabvNotes reloadData];
    
}





#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse *res=(NSHTTPURLResponse*)response;
    DLog(@"%@",res);
    
    if ([res statusCode] == 404)
    {
        /// do some stuff
         DLog(@"404 error");
        
    }
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSDictionary *dict = httpResponse.allHeaderFields;
    NSString *lengthString = [dict valueForKey:@"Content-Length"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *length = [formatter numberFromString:lengthString];
    self.totalBytes = length.unsignedIntegerValue;
   
    if (connection==connDownloadImage) {
        _imageData=[[NSMutableData alloc] initWithCapacity:self.totalBytes];
        
    }
    else
        
    {
        _responseData = [[NSMutableData alloc] init];
        
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
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

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection==connDownloadImage)
    {
        [webV loadData:_imageData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
        hud.hidden=YES;
    }
    else
    {
        NSMutableDictionary* temp;
        
    if (_responseData !=nil)
    {
        NSError *error;
        
        
        NSString *strRet = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
        DLog(@"adadasd::%@",strRet);
        
        
        
        temp = [NSJSONSerialization JSONObjectWithData:_responseData  options:NSJSONReadingMutableContainers error:&error];
        if (!error)
        {
            if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"])
            {
                DLog(@"%@",temp);
                
                NSArray *arrM=[[NSUserDefaults standardUserDefaults]objectForKey:@"arrEditedJobDic"];
                NSMutableArray *mutableCopy=[arrM mutableCopy];
                if (mutableCopy==nil) {
                    mutableCopy=[[NSMutableArray alloc]init];
                }
                
                [mutableCopy containsObject:_jobID]?NSLog(@"ID already Present"):[mutableCopy addObject:_jobID];
                [[NSUserDefaults standardUserDefaults]setObject:mutableCopy forKey:@"arrEditedJobDic"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                NSArray *arr = [temp valueForKey:@"NoteRecordList"];
                
                if (arr.count>0) {
                    NSDictionary *dict = [arr objectAtIndex:0];
                    [Notes insertObject:dict atIndex:0];
                }

                [self btnNewNotesTapped:_btnNewNotes];
                [_tabvNotes reloadData];
            }
        }
        else
        {
            DLog(@"JSONObjectWithData error: %@", error);
        }
        
    }
    
    
     [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
    [mainBg removeFromSuperview];
    [_tabvNotes reloadData];
    
    
    txtNoteTo.text=@"";
    txtNoteType.text=@"";
    txtvNoteBody.text=@"";
    }
    
  
    
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
  //  [[[UIAlertView alloc]initWithTitle:@"Error" message:@"No network connection. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
   
    
    
    [self showAlert:@"No network connection. Please try again later."  withTitle:@"Error"];
}






-(void)Showalert:(NSString *)msg{
    
    [self showAlert:msg withTitle:@""];
    
}

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


-(NSArray *)GetDataForPoppup:(UITextField *)fld{
    
    
    if (fld==txtNoteTo) {
   
          [MBProgressHUD showHUDAddedTo:Activetxtfld animated:YES];
        [self fetchDropDownForTextField:@"GetNoteToUsers" didFinishLoading:^(BOOL success , NSArray *arrData){
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                
                [MBProgressHUD hideAllHUDsForView:Activetxtfld animated:YES];
                
                Activetxtfld.userInteractionEnabled=YES;
                arrFeedTblPopup=arrData;
                [tblView reloadData];
                
            });
            
        }];

        
    }
    else if (fld==txtNoteType)
    {
        
        [MBProgressHUD showHUDAddedTo:Activetxtfld animated:YES];
        
      
        
        
        [self fetchDropDownForTextField:@"GetNoteType" didFinishLoading:^(BOOL success , NSArray *arrData){
            
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


#pragma mark tableview delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblView)
    {
        return 40;
    }
    return 130;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tblView) {
        return [arrFeedTblPopup count];
        
    }
    
    if (_btnPrevNotes.selected==YES) {
        
       return  [prevNotes count];
        
    }
    else if (_btnNewNotes.selected==YES)
    {
       return  [newNotes count];
        
    }
    else
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier=@"cellidentifier";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.backgroundColor=[UIColor clearColor];
    
   // DLog(@"newNotes:  %@",newNotes);
   // DLog(@"prevNotes: %@",prevNotes);
    
   
    
    if (tableView==tblView)
    {
        
        NSDictionary *dic=[arrFeedTblPopup objectAtIndex:indexPath.row];
        
        cell.textLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"DisplayText"]];
    }
    else
    {
        if (_btnNewNotes.selected==YES)
        {
            arrFeed=newNotes;
            
        }
        else if (_btnPrevNotes.selected==YES)
        {
            arrFeed=prevNotes;
            
        }
        
        UIImageView *imgvCellbg=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(_tabvNotes.frame),130)];
        [imgvCellbg setImage:[UIImage imageNamed:@"jobBox_clearbg"]];
        [cell.contentView addSubview:imgvCellbg];
        
        
        cell.backgroundColor=[UIColor colorWithRed:249/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
        NSDictionary *dic=[arrFeed objectAtIndex:indexPath.row];
        
        //---------- CreatedBy --------------------------------------------------------------------------------
        UILabel *lbl111;
        lbl111=[[UILabel alloc] initWithFrame:CGRectMake(15,5,70,30)];
        lbl111.textAlignment=NSTextAlignmentLeft;
        lbl111.textColor=[UIColor darkGrayColor];
        lbl111.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
        lbl111.backgroundColor=[UIColor clearColor];
        lbl111.text=@"Created By:";
        [cell.contentView addSubview:lbl111];
        
        UILabel *lblCreatedBy;
        lblCreatedBy=[[UILabel alloc] initWithFrame:CGRectMake(90,5,226,30)];
        lblCreatedBy.textAlignment=NSTextAlignmentLeft;
        lblCreatedBy.textColor=[UIColor blueColor];
        lblCreatedBy.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
        lblCreatedBy.backgroundColor=[UIColor clearColor];
        lblCreatedBy.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"CreatedBy"]];
        [cell.contentView addSubview:lblCreatedBy];
        //----------------------------------------------------------------------------------------------------
        
        //---------- CreatedDate --------------------------------------------------------------------------------
        UILabel *lbl222;
        lbl222=[[UILabel alloc] initWithFrame:CGRectMake(15,35,80,30)];
        lbl222.textAlignment=NSTextAlignmentLeft;
        lbl222.textColor=[UIColor darkGrayColor];
        lbl222.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
        lbl222.backgroundColor=[UIColor clearColor];
        lbl222.text=@"Created Date:";
        [cell.contentView addSubview:lbl222];
        
        //DLog(@"date time:%@",[dic valueForKey:@"CreatedDate"]);
       
        NSString *strStartDate =[NSString stringWithFormat:@"%@",[dic valueForKey:@"CreatedDate"]];
        strStartDate = [strStartDate substringToIndex:10];
        
        UILabel *lblCreatedDate;
        lblCreatedDate=[[UILabel alloc] initWithFrame:CGRectMake(90,35,226,30)];
        lblCreatedDate.textAlignment=NSTextAlignmentLeft;
        lblCreatedDate.textColor=[UIColor blueColor];
        lblCreatedDate.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
        lblCreatedDate.backgroundColor=[UIColor clearColor];
        lblCreatedDate.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"CreatedDate"]];
        [cell.contentView addSubview:lblCreatedDate];
        //----------------------------------------------------------------------------------------------------
        
        UILabel *lbl1;
        lbl1=[[UILabel alloc] initWithFrame:CGRectMake(15,65,70,30)];
        lbl1.textAlignment=NSTextAlignmentLeft;
        lbl1.textColor=[UIColor darkGrayColor];
        lbl1.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
        lbl1.backgroundColor=[UIColor clearColor];
        lbl1.text=@"Note type:";
        [cell.contentView addSubview:lbl1];
        
        UILabel *lblNotetypeValue;
        lblNotetypeValue=[[UILabel alloc] initWithFrame:CGRectMake(90,65,226,30)];
        lblNotetypeValue.textAlignment=NSTextAlignmentLeft;
        lblNotetypeValue.textColor=[UIColor colorWithRed:50/255.0 green:65/255.0 blue:75/255.0 alpha:1.0];
        lblNotetypeValue.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
        lblNotetypeValue.backgroundColor=[UIColor clearColor];
        lblNotetypeValue.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"DisplayTextNoteType"]];
        [cell.contentView addSubview:lblNotetypeValue];
        
        
        UILabel *lbl2;
        lbl2=[[UILabel alloc] initWithFrame:CGRectMake(15,95,70,30)];
        lbl2.textAlignment=NSTextAlignmentLeft;
        lbl2.textColor=[UIColor darkGrayColor];
        lbl2.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
        lbl2.backgroundColor=[UIColor clearColor];
        lbl2.text=@"Description:";
        [cell.contentView addSubview:lbl2];
        
        NSArray* imagesPath = [dic valueForKey:@"ImagePath"];
        
        if ([imagesPath isKindOfClass:[NSArray class]] && imagesPath.count > 0)
        {
            
            UIButton *btnAttachments;
            btnAttachments=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame)-50,66,32,32)];
            [btnAttachments setBackgroundImage:[UIImage imageNamed:@"attachement-icon"] forState:UIControlStateNormal];
            btnAttachments.backgroundColor=[UIColor clearColor];
            btnAttachments.tag=indexPath.row;
            [btnAttachments addTarget:self action:@selector(btnAttachmentPress:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btnAttachments];
            
        }
        
        
        UILabel *lblNoteBody;
        lblNoteBody=[[UILabel alloc] initWithFrame:CGRectMake(90,95,226,30)];
        lblNoteBody.textAlignment=NSTextAlignmentLeft;
        lblNoteBody.textColor=[UIColor colorWithRed:50/255.0 green:65/255.0 blue:75/255.0 alpha:1.0];
        lblNoteBody.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:12.0];
        lblNoteBody.backgroundColor=[UIColor clearColor];
        lblNoteBody.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"NoteBody"]];
        [cell.contentView addSubview:lblNoteBody];
        
        
    }
    
    
    return cell;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblView)
    {
        NSDictionary *dic=[arrFeedTblPopup objectAtIndex:indexPath.row];
        Activetxtfld.text=[NSString stringWithFormat:@"  %@",[dic valueForKey:@"DisplayText"]];
        Activetxtfld.tag=[[dic valueForKey:@"Value"]integerValue];
        
        
        
        if (Activetxtfld==txtNoteTo) {
            [dicNotes setObject:[NSString stringWithFormat:@"%@",[dic valueForKey:@"Value"]] forKey:@"NoteToUserID"];
            [dicNotes setObject:Activetxtfld.text forKey:@"DisplayTextNoteTo"];
        }
        if (Activetxtfld==txtNoteType)
        {
            [dicNotes setObject:[NSString stringWithFormat:@"%ld",(long)Activetxtfld.tag] forKey:@"NoteTypeID"];
            [dicNotes setObject:Activetxtfld.text forKey:@"DisplayTextNoteType"];
        }
        
        [tblView removeFromSuperview];
        tblView=nil;
    }
    else
    {
       
        if (_btnNewNotes.selected==YES)
        {
            arrFeed=newNotes;
            
        }
        else if (_btnPrevNotes.selected==YES)
        {
            arrFeed=prevNotes;
            
        }
         NSDictionary *dic=[arrFeed objectAtIndex:indexPath.row];
        
        mainBgNoteDesc = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
        mainBgNoteDesc.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
        
        bgVwNoteDesc = [[UIView alloc] initWithFrame:CGRectMake(0,0,280,280)];
        bgVwNoteDesc.center=CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, CGRectGetHeight(self.view.frame)/2.0f);
        
        [bgVwNoteDesc.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
        [bgVwNoteDesc.layer setBorderWidth: 0.5];
        [bgVwNoteDesc.layer setCornerRadius:4.0f];
        [bgVwNoteDesc.layer setMasksToBounds:YES];
        bgVwNoteDesc.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20,20,240,29)];
        lblTitle.text = @" Note Description";
        lblTitle.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
        lblTitle.textAlignment = NSTextAlignmentLeft;
        lblTitle.textColor=[UIColor whiteColor];
        lblTitle.backgroundColor =[UIColor colorWithRed:52/255.0 green:54/255.0 blue:67/255.0 alpha:0.72];
        [lblTitle.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [lblTitle.layer setBorderWidth: 1.0];
        [lblTitle.layer setCornerRadius:4.0f];
        [lblTitle.layer setMasksToBounds:YES];
        
        txtvNoteBodyNoteDesc = [[UITextView alloc] initWithFrame:CGRectMake(20,54,240,180)];
        txtvNoteBodyNoteDesc.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
        txtvNoteBodyNoteDesc.textColor=[UIColor darkGrayColor];
        [txtvNoteBodyNoteDesc setBackgroundColor:[UIColor whiteColor]];
        txtvNoteBodyNoteDesc.editable=NO;
        txtvNoteBodyNoteDesc.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"NoteBody"]];
        
        [txtvNoteBodyNoteDesc.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [txtvNoteBodyNoteDesc.layer setBorderWidth: 1.0];
        [txtvNoteBodyNoteDesc.layer setCornerRadius:4.0f];
        [txtvNoteBodyNoteDesc.layer setMasksToBounds:YES];
        
        btnCrossNoteDesc=[UIButton buttonWithType:UIButtonTypeCustom];
        btnCrossNoteDesc.frame=CGRectMake(0, 0, 25, 25);
        btnCrossNoteDesc.center=CGPointMake(CGRectGetMaxX(bgVwNoteDesc.frame),CGRectGetMinY(bgVwNoteDesc.frame));
        [btnCrossNoteDesc setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
        [btnCrossNoteDesc addTarget:self action:@selector(crossNoteDesc:) forControlEvents:UIControlEventTouchUpInside];
        [btnCrossNoteDesc clipsToBounds];
        
        
        [bgVwNoteDesc addSubview:lblTitle];
        [bgVwNoteDesc addSubview:txtvNoteBodyNoteDesc];
        [mainBgNoteDesc addSubview:bgVwNoteDesc];
        [mainBgNoteDesc addSubview:btnCrossNoteDesc];
        [self.view addSubview:mainBgNoteDesc];
    }
   
}


-(IBAction)btnAttachmentPress:(UIButton *)sender
{
    DLog(@"sender.tag ::: %ld",(long)sender.tag);
    NSDictionary *dic;
    if (_btnNewNotes.selected==YES)
    {
        dic=[newNotes objectAtIndex:sender.tag];
    }
    else{
        dic=[prevNotes objectAtIndex:sender.tag];
    }
    
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
    
    CGFloat currX=20.0f;
    for (int i=0;i<[arr count];i++)
    {
        bgVwNoteDesc = [[UIView alloc] initWithFrame:CGRectMake(currX,0,300,360)];
        bgVwNoteDesc.center=CGPointMake(bgVwNoteDesc.center.x, self.view.frame.size.height/2.0f);
        
        [bgVwNoteDesc.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
        [bgVwNoteDesc.layer setBorderWidth: 0.5];
        [bgVwNoteDesc.layer setCornerRadius:4.0f];
        [bgVwNoteDesc.layer setMasksToBounds:YES];
        bgVwNoteDesc.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
        
            
        NSString *urlStr=[arr objectAtIndex:i];
        
        
        NSURL *url = [NSURL URLWithString:[urlStr stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        
        
      
        DLog(@"urlurlurlurlurlurlurlurl %@",url);
        
       
        
        webV=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 300, 360)];
        
        webV.center=CGPointMake(CGRectGetWidth(bgVwNoteDesc.frame)/2.0f, CGRectGetHeight(bgVwNoteDesc.frame)/2.0f);
        webV.backgroundColor=[UIColor lightGrayColor];
        webV.delegate=self;
        [webV loadRequest:[NSURLRequest requestWithURL:url]];
        [webV setScalesPageToFit:YES];
        [bgVwNoteDesc addSubview:webV];
        
        hud=[MBProgressHUD showHUDAddedTo:webV animated:YES];
         hud.labelText = @"Loading...";
        
       
        
        btnCrossNoteDesc=[UIButton buttonWithType:UIButtonTypeCustom];
        btnCrossNoteDesc.frame=CGRectMake(0, 0, 25, 25);
        btnCrossNoteDesc.center=CGPointMake(CGRectGetMaxX(webV.frame)-15,CGRectGetMinY(webV.frame)+15);
        [btnCrossNoteDesc setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
        [btnCrossNoteDesc addTarget:self action:@selector(crossNoteDesc:) forControlEvents:UIControlEventTouchUpInside];
        [btnCrossNoteDesc clipsToBounds];
        currX=currX+CGRectGetWidth(bgVwNoteDesc.frame)+10 ;
        [mainBgNoteDesc addSubview:bgVwNoteDesc];
        [bgVwNoteDesc addSubview:btnCrossNoteDesc];
        [self.view addSubview:mainBgNoteDesc];
    }
    mainBgNoteDesc.contentSize=CGSizeMake(currX, mainBgNoteDesc.frame.size.height);
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:webView animated:YES];
    
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    DLog(@"%@",touch.view);
    if ([touch.view isDescendantOfView:tblView])
    {
        return NO;
    }
    return YES;
}

#pragma mark - TEXTFIELD DELEGATES
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self.view endEditing:YES];
    
    Activetxtfld=textField;
    [self popupList];
    return YES;
    
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.view endEditing:YES];
    
    Activetxtfld=textField;

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

- (IBAction)btnPrevNotes:(UIButton *)sender
{
    [_btnAdd setHidden:YES];
    [prevNotes  removeAllObjects];
    for (NSDictionary *dic in Notes)
    {
        if ([[dic valueForKey:@"IsPreviousJobNote"]boolValue]==true)
        {
            [prevNotes addObject:dic];
        }
    }
    _btnPrevNotes.selected=YES;
    _btnNewNotes.selected=NO;
    
    [_tabvNotes reloadData];
    [self animateToActiveButton:_btnPrevNotes withImageview:_selected];
}



- (IBAction)btnNewNotesTapped:(UIButton *)sender
{
    if ([_jobStatus integerValue]!=3) {
        [_btnAdd setHidden:NO];
    }
    [newNotes removeAllObjects];
    for (NSDictionary *dic in Notes)
    {
        if ([[dic valueForKey:@"IsPreviousJobNote"]boolValue]==false)
        {
            [newNotes addObject:dic];
        }
    }
    _btnPrevNotes.selected=NO;
    _btnNewNotes.selected=YES;
    [_tabvNotes reloadData];
    [self animateToActiveButton:_btnNewNotes withImageview:_selected];
}

@end












