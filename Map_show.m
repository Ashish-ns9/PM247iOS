//
//  Map_show.m
//  Partner Maintenance
//


#import "Map_show.h"
AppDelegate *app;
GlobalDirector *globe;

@interface Map_show ()

@end

@implementation Map_show
@synthesize strHeading;
@synthesize dicJobTemp;

#pragma mark - Fetch Job address from Dictionary
- (void)btnJobAdressTapped
{
    NSArray *arr=[dicJobTemp objectForKey:@"JobAddrListResponse"];
    NSDictionary *dicAdr;
    for (NSDictionary *dic in arr)
    {
        if ([[dic valueForKey:@"TypeOfAddress"]integerValue]==1)
        {
            dicAdr=dic;
        }
    }
    [self FetchAddressDicValue:dicAdr];
}

-(void)FetchAddressDicValue:(NSDictionary *)dic
{
    if (![[dic valueForKey:@"Address"]isKindOfClass:[NSNull class]])
    {
        DLog(@"Address: %@",[dic valueForKey:@"Address"]);
    }
    if (![[dic valueForKey:@"County"]isKindOfClass:[NSNull class]])
    {
        DLog(@"County: %@",[dic valueForKey:@"County"]);
    }
    if (![[dic valueForKey:@"City"]isKindOfClass:[NSNull class]])
    {
        DLog(@"City: %@",[dic valueForKey:@"City"]);
    }
    if (![[dic valueForKey:@"PostCode"]isKindOfClass:[NSNull class]])
    {
        DLog(@"PostCode: %@",[dic valueForKey:@"PostCode"]);
    }
    
    
    JobAddress =[NSString stringWithFormat:@"%@ %@ %@, %@",[dic valueForKey:@"Address"],[dic valueForKey:@"City"],[dic valueForKey:@"County"],[dic valueForKey:@"PostCode"]];
    
}
#pragma mark - ViewWillAppear Method
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    ismapDrawn=NO;
}

-(void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LocationUpdate" object:nil];
}


#pragma mark - ViewDidLoad Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UpdatedLocationOfUser:)
                                                 name:@"LocationUpdate" object:nil];
    
    
    self.navigationController.navigationBarHidden=YES;
    app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    globe = [GlobalDirector SharedDirector];
    
    
    
    
    // AppDelegate*  appDelegates=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    JobAddress=[[NSString alloc]init];
    
    [self btnJobAdressTapped];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
    {
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(app.locationManager.location.coordinate, 50, 50);
        [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
        _mapView.showsUserLocation=YES;
        _mapView.userTrackingMode= MKUserTrackingModeFollow;
        
        
        prevCurrLoc=[[CLLocation alloc] initWithLatitude:app.locationManager.location.coordinate.latitude longitude:app.locationManager.location.coordinate.longitude];
        [self getRouteTo:JobAddress EngLoc:app.locationManager.location];
        
    }
    
    else
    {
        
        app.statusTimer = [NSTimer scheduledTimerWithTimeInterval:120.0
                                                           target:self
                                                         selector:@selector(getEngLocation)
                                                         userInfo:nil
                                                          repeats:YES];
        [self getEngLocation];
        _mapView.delegate=nil;
        _mapView.showsUserLocation=NO;
    }
}

-(void)getRouteTo:(NSString*)dest EngLoc:(CLLocation *)loc{
    
    if (loc.coordinate.latitude>0||loc.coordinate.longitude>0) {
        
        DLog(@"%f\n%f",loc.coordinate.latitude,loc.coordinate.latitude);
        
        [self GetCoordinateFromAddress:dest andCompletionHandler:^(CLLocation *locD) {
            
            NSString *destLatLong;
            
            if (locD.coordinate.latitude>0||locD.coordinate.longitude>0) {
                destLatLong = [NSString stringWithFormat:@"%f,%f",locD.coordinate.latitude,locD.coordinate.longitude];
            }else{
                destLatLong = dest;
            }
            NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%@&sensor=true", loc.coordinate.latitude, loc.coordinate.longitude,destLatLong];
            baseUrl = [baseUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            NSURL *url = [NSURL URLWithString:baseUrl];
            DLog(@"%@",url);
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                
                NSError *error = nil;
                if (data!=nil) {
                    
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                    
                    NSArray *routes = [result objectForKey:@"routes"];
                    if (routes.count>0) {
                        
                        [self SetupMapANDData:result EngLoc:loc];
                        
                    }
                    else
                    {
                        
                        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedUser"] isEqualToString:@"fe"])
                        {
                            UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"No Route"
                                                                                                message: @"No route found from your location"
                                                                                         preferredStyle: UIAlertControllerStyleAlert];
                            
                            UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                                                  style: UIAlertActionStyleDestructive
                                                                                handler: ^(UIAlertAction *action) {
                                DLog(@"Dismiss button tapped!");
                            }];
                            
                            [controller addAction: alertAction];
                            
                            [self presentViewController: controller animated: YES completion: nil];
                        }
                    }
                }
            }];
        }];
    }
}

-(void)GetCoordinateFromAddress:(NSString*)dest andCompletionHandler:(void (^)(CLLocation *locD))completionHandler{
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    //Get the address through geoCoder
    [geoCoder geocodeAddressString:dest   completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLLocation *location ;
        if ([placemarks count] > 0 && !error) {
            
            //get the address from placemark
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            location = placemark.location;
            completionHandler(location);
        } else {
            
            completionHandler(location);
        }
    }];
    
}


-(void)SetupMapANDData:(NSDictionary*)result EngLoc:(CLLocation *)loc {
    NSArray *routes = [result objectForKey:@"routes"];
    NSDictionary *firstRoute1 = [routes objectAtIndex:0];
    
    NSDictionary *leg1 =  [[firstRoute1 objectForKey:@"legs"] objectAtIndex:0];
    NSString *distance=[[leg1 objectForKey:@"distance"]valueForKey:@"value"];
    if ([distance integerValue]>0) {
        NSString *str=[NSString stringWithFormat:@"Distance : %.2f Miles\nDuration:  %@\nTravel Mode: %@" ,distance.floatValue*0.0006214,[[leg1 objectForKey:@"duration"]valueForKey:@"text"],[(NSDictionary *)[[leg1 objectForKey:@"steps"]objectAtIndex:0]valueForKey:@"travel_mode"]];
        
        [_lbldist setText:str];
    }
    if (ismapDrawn==NO) {
        
        
        NSDictionary *firstRoute = [routes objectAtIndex:0];
        
        NSDictionary *leg =  [[firstRoute objectForKey:@"legs"] objectAtIndex:0];
        
        NSDictionary *end_location = [leg objectForKey:@"end_location"];
        
        double latitude = [[end_location objectForKey:@"lat"] doubleValue];
        double longitude = [[end_location objectForKey:@"lng"] doubleValue];
        
        endLoc=[[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        
        MyAnnotation* myAnnotation1=[[MyAnnotation alloc] init];
        myAnnotation1.coordinate = coordinate;
        myAnnotation1.title =  [leg objectForKey:@"end_address"];
        [self.mapView addAnnotation:myAnnotation1];
        
        
        
        NSDictionary *dicPolyline=[firstRoute objectForKey:@"overview_polyline"];
        
        MKPolyline *polyLine = [self polylineWithEncodedString:[dicPolyline valueForKey:@"points"]];
        
        DLog(@"%@",polyLine);
        
        [_mapView addOverlay:polyLine level:MKOverlayLevelAboveRoads];
        
        MKCoordinateSpan span = MKCoordinateSpanMake(0.10, 0.10);
        
        MKCoordinateRegion region = MKCoordinateRegionMake(loc.coordinate, span);
        [_mapView setRegion:region];
        [_mapView setCenterCoordinate:loc.coordinate animated:YES];
        
        ismapDrawn=YES;
        
        
    }
}

- (MKPolyline *)polylineWithEncodedString:(NSString *)encodedString {
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:coordIdx];
    free(coords);
    
    return polyline;
    
}

-(void )getEngLocation{
    //CLLocation *engLoc;
    NSOperationQueue *mainQueue = [[NSOperationQueue alloc] init];
    [mainQueue setMaxConcurrentOperationCount:5];
    
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    
    NSString *urlString=[NSString stringWithFormat:@"%sGetEnggCurrentLocation?userToken=%@&jobId=%@",conn_url,[user valueForKey:@"UserToken"],[dicJobTemp valueForKey:@"JobID"]];
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:@{@"Accepts-Encoding": @"gzip", @"Accept": @"application/json"}];
    request.timeoutInterval = 300;
    
    [NSURLConnection sendAsynchronousRequest:request queue:mainQueue completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
        if (!error) {
            DLog(@"Status Code: %li %@", (long)urlResponse.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:urlResponse.statusCode]);
            DLog(@"Response Body: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
            if (responseData!=nil) {
                
                NSDictionary * temp = [NSJSONSerialization JSONObjectWithData:responseData  options:NSJSONReadingMutableContainers error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"]) {
                        
                        
                        
                        [self showEnggOnMap:[[CLLocation alloc] initWithLatitude:[[temp valueForKey:@"LocLat"]floatValue] longitude:[[temp valueForKey:@"LocLong"]floatValue]]];
                        [self getRouteTo:JobAddress EngLoc:[[CLLocation alloc] initWithLatitude:[[temp valueForKey:@"LocLat"]floatValue] longitude:[[temp valueForKey:@"LocLong"]floatValue]]];
                    }
                    
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UIAlertController *controller = [UIAlertController alertControllerWithTitle: @""
                                                                                                message:@"Engineer location not available."
                                                                                         preferredStyle: UIAlertControllerStyleAlert];
                            
                            UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"OK"
                                                                                  style: UIAlertActionStyleDestructive
                                                                                handler: ^(UIAlertAction *action) {
                                
                                // [self dismissViewControllerAnimated:YES completion:nil];
                            }];
                            
                            [controller addAction: alertAction];
                            
                            [self presentViewController: controller animated: YES completion: nil];
                            //  [self SetupAddressPin:JobAddress];
                            [self GetCoordinateFromAddress:JobAddress andCompletionHandler:^(CLLocation *locD) {
                                
                                //Setup address pin
                                MyAnnotation* myAnnotation1=[[MyAnnotation alloc] init];
                                myAnnotation1.coordinate = locD.coordinate;
                                myAnnotation1.title =  JobAddress;
                                [self.mapView addAnnotation:myAnnotation1];
                                
                                MKCoordinateSpan span = MKCoordinateSpanMake(100.00, 100.00);
                                
                                MKCoordinateRegion region = MKCoordinateRegionMake(locD.coordinate, span);
                                [_mapView setRegion:region];
                                [_mapView setCenterCoordinate:locD.coordinate animated:YES];
                            }];
                            
                        });
                        
                        AppDelegate*  appDelegates=(AppDelegate *)[[UIApplication sharedApplication] delegate];
                        [appDelegates.statusTimer invalidate];
                        
                        
                    }
                    
                });
            }
        }
        else {
            DLog(@"An error occured, Status Code: %ld", (long)urlResponse.statusCode);
            DLog(@"Description: %@", [error localizedDescription]);
            DLog(@"Response Body: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        }
    }];
    
}
-(void)showEnggOnMap:(CLLocation *)loc{
    
    if (enggAnnotation==nil) {
        
        MKCoordinateSpan span = MKCoordinateSpanMake(1.00,1.00);
        MKCoordinateRegion region = MKCoordinateRegionMake(loc.coordinate, span);
        
        [_mapView setRegion:region];
        [_mapView setCenterCoordinate:loc.coordinate animated:YES];
        
        enggAnnotation=[[MyAnnotation alloc] init];
        enggAnnotation.coordinate = loc.coordinate;
        enggAnnotation.title = [NSString stringWithFormat:@"%@",[dicJobTemp valueForKey:@"EngineerName"]];
        
        [self.mapView addAnnotation:enggAnnotation];
    }
    
    else
    {
        enggAnnotation.coordinate = loc.coordinate;
    }
}

- (CLLocationCoordinate2D)coordinateWithLocation:(NSDictionary*)location
{
    double latitude = [[location objectForKey:@"lat"] doubleValue];
    double longitude = [[location objectForKey:@"lng"] doubleValue];
    return CLLocationCoordinate2DMake(latitude, longitude);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - Back Press Method
- (IBAction)sendStatus:(id)sender {
    mainBg = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    mainBg.backgroundColor =[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    
    bgVw = [[UIView alloc] initWithFrame:CGRectMake(0,0,300,260)];
    bgVw.center=CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, CGRectGetHeight(self.view.frame)/2.0f);
    
    [bgVw.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [bgVw.layer setBorderWidth: 0.5];
    [bgVw.layer setCornerRadius:4.0f];
    [bgVw.layer setMasksToBounds:YES];
    bgVw.backgroundColor =[UIColor colorWithRed:238/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
    bgVw.alpha=0.0f;
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(bgVw.frame),29)];
    lblTitle.text = @" Send Location Status";
    lblTitle.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:15.0];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.backgroundColor =[UIColor colorWithRed:52/255.0 green:54/255.0 blue:67/255.0 alpha:0.72];
    [lblTitle.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [lblTitle.layer setBorderWidth: 1.0];
    [lblTitle.layer setCornerRadius:4.0f];
    [lblTitle.layer setMasksToBounds:YES];
    
    
    UIButton *btnRuningLate,*btnOnTime,*btnStuckinTraffic,*btnArrivedonSite;
    CGFloat btnwidth=70;
    
    btnRuningLate=[UIButton buttonWithType:UIButtonTypeCustom];
    btnRuningLate.frame=CGRectMake(4,CGRectGetMaxY(lblTitle.frame)+5,btnwidth,btnwidth);
    [btnRuningLate setTitle:@"Runing Late" forState:UIControlStateNormal];
    btnRuningLate.titleLabel.numberOfLines=3;
    btnRuningLate.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    btnRuningLate.titleLabel.textAlignment=NSTextAlignmentCenter;
    
    [btnRuningLate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnRuningLate.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    [btnRuningLate setBackgroundColor:[UIColor colorWithRed:203/255.0f green:106/255.0f blue:0.0f alpha:1.0f]];
    [btnRuningLate addTarget:self action:@selector(UpdateStatus:) forControlEvents:UIControlEventTouchUpInside];
    [btnRuningLate.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [btnRuningLate.layer setBorderWidth: 1.0];
    [btnRuningLate.layer setCornerRadius:CGRectGetWidth(btnRuningLate.frame)/2.0f];
    btnRuningLate.tag=20;
    [self addGradient:btnRuningLate];
    
    [btnRuningLate.layer setMasksToBounds:YES];
    
    btnOnTime=[UIButton buttonWithType:UIButtonTypeCustom];
    btnOnTime.frame=CGRectMake(CGRectGetMaxX(btnRuningLate.frame)+4,CGRectGetMaxY(lblTitle.frame)+5,btnwidth,btnwidth);
    [btnOnTime setTitle:@"On Time" forState:UIControlStateNormal];
    btnOnTime.titleLabel.numberOfLines=3;
    btnOnTime.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    btnOnTime.titleLabel.textAlignment=NSTextAlignmentCenter;
    [btnOnTime setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOnTime.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    [btnOnTime setBackgroundColor:[UIColor grayColor]];
    [btnOnTime addTarget:self action:@selector(UpdateStatus:) forControlEvents:UIControlEventTouchUpInside];
    [btnOnTime.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [btnOnTime.layer setBorderWidth: 1.0];
    [btnOnTime.layer setCornerRadius:CGRectGetWidth(btnRuningLate.frame)/2.0f];
    btnOnTime.tag=21;
    [self addGradient:btnOnTime];
    [btnOnTime.layer setMasksToBounds:YES];
    
    
    btnStuckinTraffic=[UIButton buttonWithType:UIButtonTypeCustom];
    btnStuckinTraffic.frame=CGRectMake(CGRectGetMaxX(btnOnTime.frame)+4,CGRectGetMaxY(lblTitle.frame)+5,btnwidth,btnwidth);
    [btnStuckinTraffic setTitle:@"Stuck in Traffic" forState:UIControlStateNormal];
    btnStuckinTraffic.titleLabel.numberOfLines=3;
    btnStuckinTraffic.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    btnStuckinTraffic.titleLabel.textAlignment=NSTextAlignmentCenter;
    [btnStuckinTraffic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnStuckinTraffic.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    [btnStuckinTraffic setBackgroundColor:[UIColor grayColor]];
    [btnStuckinTraffic addTarget:self action:@selector(UpdateStatus:) forControlEvents:UIControlEventTouchUpInside];
    [btnStuckinTraffic.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [btnStuckinTraffic.layer setBorderWidth: 1.0];
    [btnStuckinTraffic.layer setCornerRadius:CGRectGetWidth(btnRuningLate.frame)/2.0f];
    btnStuckinTraffic.tag=22;
    [self addGradient:btnStuckinTraffic];
    [btnStuckinTraffic.layer setMasksToBounds:YES];
    
    
    btnArrivedonSite=[UIButton buttonWithType:UIButtonTypeCustom];
    btnArrivedonSite.frame=CGRectMake(CGRectGetMaxX(btnStuckinTraffic.frame)+4,CGRectGetMaxY(lblTitle.frame)+5,btnwidth,btnwidth);
    [btnArrivedonSite setTitle:@"Arrived on Site" forState:UIControlStateNormal];
    btnArrivedonSite.titleLabel.numberOfLines=3;
    btnArrivedonSite.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    btnArrivedonSite.titleLabel.textAlignment=NSTextAlignmentCenter;
    [btnArrivedonSite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnArrivedonSite.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    
    [btnArrivedonSite setBackgroundColor:[UIColor grayColor]];
    [btnArrivedonSite addTarget:self action:@selector(UpdateStatus:) forControlEvents:UIControlEventTouchUpInside];
    [btnArrivedonSite.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [btnArrivedonSite.layer setBorderWidth: 1.0];
    [btnArrivedonSite.layer setCornerRadius:CGRectGetWidth(btnRuningLate.frame)/2.0f];
    btnArrivedonSite.tag=23;
    [self addGradient:btnArrivedonSite];
    [btnArrivedonSite.layer setMasksToBounds:YES];
    
    btnCross=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCross.frame=CGRectMake(0, 0, 25, 25);
    btnCross.center=CGPointMake(CGRectGetMaxX(bgVw.frame),CGRectGetMinY(bgVw.frame));
    [btnCross setBackgroundImage:[UIImage imageNamed:@"e-Sigacros"] forState:UIControlStateNormal];
    [btnCross addTarget:self action:@selector(cross:) forControlEvents:UIControlEventTouchUpInside];
    [btnCross clipsToBounds];
    
    btnSend=[UIButton buttonWithType:UIButtonTypeCustom];
    btnSend.frame=CGRectMake(0,CGRectGetHeight(bgVw.frame)-40,CGRectGetWidth(bgVw.frame),40);
    [btnSend setTitle:@"Send" forState:UIControlStateNormal];
    [btnSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSend.titleLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:18.0];
    [btnSend setBackgroundColor:[UIColor colorWithRed:30/255.0 green:124/255.0 blue:41/255.0 alpha:1.0]];
    [btnSend addTarget:self action:@selector(LocationStatusService:) forControlEvents:UIControlEventTouchUpInside];
    [btnSend.layer setBorderColor: [[UIColor darkGrayColor] CGColor]];
    [btnSend.layer setBorderWidth: 1.0];
    [btnSend.layer setCornerRadius:0.0f];
    [btnSend.layer setMasksToBounds:YES];
    
    
    CGRect frame = CGRectMake(0.0, 0.0, 250.0, 10.0);
    slider = [[UISlider alloc] initWithFrame:frame];
    slider.center=CGPointMake(CGRectGetWidth(bgVw.frame)/2.0f, CGRectGetHeight(bgVw.frame)/2.0f+25);
    
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [slider setBackgroundColor:[UIColor clearColor]];
    slider.minimumValue = 0.0;
    slider.maximumValue = 120.0;
    slider.continuous = YES;
    slider.value = 10.0;
    [bgVw addSubview:slider];
    
    
    UILabel *lblarrivedWithin = [[UILabel alloc] init];
    lblarrivedWithin.center=CGPointMake(CGRectGetMinX(slider.frame)-10, CGRectGetMinY(slider.frame)-32);
    lblarrivedWithin.text = @"Arrive within -";
    [lblarrivedWithin sizeToFit];
    lblarrivedWithin.font = [UIFont fontWithName:@"TheSansArabic-Bold" size:15.0];
    lblarrivedWithin.textAlignment = NSTextAlignmentLeft;
    lblarrivedWithin.textColor=[UIColor darkGrayColor];
    
    UILabel *lblminSliderval = [[UILabel alloc] init];
    lblminSliderval.text = @"0 min";
    [lblminSliderval sizeToFit];
    lblminSliderval.center=CGPointMake(CGRectGetMinX(slider.frame)+3, CGRectGetMaxY(slider.frame)+13);
    lblminSliderval.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:10.0];
    lblminSliderval.textAlignment = NSTextAlignmentLeft;
    lblminSliderval.textColor=[UIColor darkGrayColor];
    
    
    UILabel *lblmaxSliderval = [[UILabel alloc] init];
    lblmaxSliderval.text = @"2 Hour";
    [lblmaxSliderval sizeToFit];
    lblmaxSliderval.center=CGPointMake(CGRectGetMaxX(slider.frame), CGRectGetMaxY(slider.frame)+13);
    lblmaxSliderval.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:10.0];
    lblmaxSliderval.textAlignment = NSTextAlignmentLeft;
    lblmaxSliderval.textColor=[UIColor darkGrayColor];
    
    
    lblSliderval = [[UILabel alloc] initWithFrame:CGRectMake(0,0,85,29)];
    lblSliderval.center=CGPointMake(slider.center.x, slider.center.y+30);
    lblSliderval.text = [NSString stringWithFormat:@"%.0f min",slider.value];
    lblSliderval.font = [UIFont fontWithName:@"TheSansArabic-Plain" size:14.0];
    lblSliderval.textAlignment = NSTextAlignmentLeft;
    lblSliderval.textColor=[UIColor darkGrayColor];
    
    [lblSliderval.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [lblSliderval.layer setBorderWidth: 1.0];
    [lblSliderval.layer setCornerRadius:4.0f];
    [lblSliderval.layer setMasksToBounds:YES];
    
    RunningStatusVal=@"1";
    [bgVw addSubview:lblTitle];
    [bgVw addSubview:btnRuningLate];
    [bgVw addSubview:btnArrivedonSite];
    
    [bgVw addSubview:btnOnTime];
    [bgVw addSubview:btnStuckinTraffic];
    [bgVw addSubview:lblminSliderval];
    [bgVw addSubview:lblmaxSliderval];
    [bgVw addSubview:lblarrivedWithin];
    [bgVw addSubview:lblSliderval];
    
    
    [bgVw addSubview:btnSend];
    //[bgVw addSubview:txtvNoteBody];
    [mainBg addSubview:bgVw];
    [mainBg addSubview:btnCross];
    [UIView animateWithDuration:0.3 animations:^{
        bgVw.alpha=1.0f;
        [self.view addSubview:mainBg];
    }];
}

-(void)sliderAction:(id)sender
{
    slider = (UISlider*)sender;
    float value = slider.value;
    if (value>60) {
        
        lblSliderval.text=[NSString stringWithFormat:@"%d hour %@",(int)value/60,(int)value%60==0?[NSString stringWithFormat:@""]:[NSString stringWithFormat:@"%d min",(int)value%60]];
    }
    else
    {
        lblSliderval.text=[NSString stringWithFormat:@"%.0f min",value];
    }
}
-(IBAction)UpdateStatus:(UIButton*)sender
{
    
    UIColor *btnColor;
    if (sender.tag==20) {
        btnColor=  [UIColor colorWithRed:203/255.0f green:106/255.0f blue:0.0f alpha:1.0f];
        slider.userInteractionEnabled=YES;
        slider.value=10.0f;
        lblSliderval.text=@"10 min";
        RunningStatusVal=@"1";
        
        
        
    }
    else if (sender.tag==21) {
        btnColor= [UIColor  colorWithRed:67/255.0f green:99/255.0f blue:3/255.0f alpha:1.0f];
        slider.userInteractionEnabled=NO;
        slider.value=0.0f;
        lblSliderval.text=@"0.0 min";
        RunningStatusVal=@"2";
        
        
    }
    else if (sender.tag==22) {
        btnColor=[UIColor blackColor];
        slider.userInteractionEnabled=YES;
        slider.value=10.0f;
        lblSliderval.text=@"10 min";
        RunningStatusVal=@"3";
        
    }
    else  if (sender.tag==23) {
        btnColor=  [UIColor purpleColor];
        slider.userInteractionEnabled=NO;
        slider.value=0.0f;
        lblSliderval.text=@"0 min";
        RunningStatusVal=@"4";
        
    }
    else{}
    
    for (UIButton *btn in [bgVw subviews]) {
        if (btn.tag==sender.tag) {
            [btn setBackgroundColor:btnColor];
        }
        else if(btn.tag>0&&btn.tag<24)
        {
            [btn setBackgroundColor:[UIColor grayColor]];
        }
    }
}
-(IBAction)LocationStatusService:(id)sender{
    
    if (RunningStatusVal ==nil) {
        RunningStatusVal=@"0";
    }
    NSDictionary *user=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    NSString *post =[NSString stringWithFormat:@""];
    NSString *urlString=[NSString stringWithFormat:@"%sSetEnggCurrentLocation?userToken=%@&jobId=%@&userID=%@&locLat=%f&locLong=%f&enggRunningStatusID=%@&arrivalWithIn=%.0f&updatedTime=%@&position=%@",conn_url,(NSString *)[user valueForKey:@"UserToken"],(NSString *)[dicJobTemp valueForKey:@"JobID"],(NSString *)[user valueForKey:@"UserID"], currLoc.coordinate.latitude, currLoc.coordinate.longitude,RunningStatusVal,slider.value,currentTime,_lbldist.text];
    urlString=[urlString stringByReplacingOccurrencesOfString:@"\n" withString:@","];
    urlString= [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    request.timeoutInterval = 300;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    connSendStatus = [[NSURLConnection alloc] init];
    [self getDataFromServerWithUrl:urlString finishLoading:^(NSData *data, NSURLResponse *response, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error==nil) {
                _responseData=[data mutableCopy];
                [self connectionDidFinishLoading:connSendStatus];
            }
            else{}
        });
        
    }];
}
-(void)cross:(id)sender
{
    [mainBg removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tblView) {
        return [arrFeedTblPopup count];
        
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier=@"cellidentifier";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.backgroundColor=[UIColor clearColor];
    NSDictionary *dic=[arrFeedTblPopup objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
    cell.textLabel.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"DisplayText"]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblView)
    {
        NSDictionary *dic=[arrFeedTblPopup objectAtIndex:indexPath.row];
        Activetxtfld.text=[NSString stringWithFormat:@"  %@",[dic valueForKey:@"DisplayText"]];
        Activetxtfld.tag=[[dic valueForKey:@"Value"]integerValue];
        [tblView removeFromSuperview];
        tblView=nil;
    }
}

-(void) addGradient:(UIButton *) _button {
    
    // Add Border
    CALayer *layer = _button.layer;
    
    layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;
    
    // Add Shine
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    [layer addSublayer:shineLayer];
}

#pragma mark - TEXTFIELD DELEGATES
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    Activetxtfld=textField;
    [self popupList];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
            frame.size.height = bgVw.frame.size.height/3.0f;
            tblView.frame = frame;
        }
                         completion:^(BOOL finished){
            DLog(@"Done!");
        }];
    }
    
}


-(NSArray *)GetDataForPoppup:(UITextField *)fld{
    if (fld==txtStatusType) {
        
        return [self FetchDropDowns:@"GetEnggRunningStatus"];
        
    }
    return nil;
}
-(NSArray *)FetchDropDowns:(NSString *)key
{
    NSArray *arr;
    NSString *post =[NSString stringWithFormat:@""];
    NSDictionary *userdetails=[[NSUserDefaults standardUserDefaults]valueForKey:@"userdetails"];
    NSString *urlString=[NSString stringWithFormat:@"%s%@?userToken=%@",conn_url,key,(NSString *)[userdetails valueForKey:@"UserToken"]];
    
    //[post stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    request.timeoutInterval = 300;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *returnstring=[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil];
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
            }
            else
            {
                DLog(@"JSONObjectWithData error: %@", error);
            }
        }
    }
    else{}
    return arr;
}



-(IBAction)backPress:(id)sender
{
    AppDelegate * appDelegates=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegates.statusTimer invalidate];
    appDelegates.statusTimer=nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSMutableDictionary* temp;
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if (_responseData !=nil)
    {
        NSError *error;
        
        temp = [NSJSONSerialization JSONObjectWithData:_responseData  options:NSJSONReadingMutableContainers error:&error];
        if (!error)
        {
            if ([[temp valueForKey:@"ResponseMessages"]isEqualToString:@"SUCCESS"]&&connection==connSendStatus) {
                
                [self cross:nil];
                NSString *message;
                switch ([RunningStatusVal integerValue]) {
                    case 1:
                        message= [NSString stringWithFormat:@"%d hour %@",(int)slider.value/60,(int)slider.value%60==0?[NSString stringWithFormat:@""]:[NSString stringWithFormat:@"%d min",(int)slider.value%60]];
                        break;
                    case 2:
                        message=[NSString stringWithFormat:@"Arrived on Site"];;
                        break;
                    case 3:
                        message= [NSString stringWithFormat:@"%d hour %@",(int)slider.value/60,(int)slider.value%60==0?[NSString stringWithFormat:@""]:[NSString stringWithFormat:@"%d min",(int)slider.value%60]];
                        
                        break;
                    case 4:
                        message=[NSString stringWithFormat:@"Arrived on Site"];
                        break;
                    default:
                        break;
                }
            }
        }
        else { DLog(@"error :%@",error); }
    }
    else
    {
        return;
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    [self showAlert:@"No network connection. Please try again later."  withTitle:@"Error"];
}


#pragma mark MKMAPview delegate
-(void)UpdatedLocationOfUser:(NSNotification*)notification{
    if ([notification.name isEqualToString:@"LocationUpdate"])
    {
        currLoc = app.currentLocation;
        if ([prevCurrLoc distanceFromLocation:currLoc]>100) {
            [self LocationStatusService:nil];
            prevCurrLoc=currLoc;
        }
        CLLocationDistance distance = [currLoc distanceFromLocation:endLoc];
        if (distance/ 1000<0.1&&distance/ 1000>0.0) {
            /*UIAlertView *alview=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You are at your destination" delegate:self cancelButtonTitle:@"Send Status" otherButtonTitles:nil, nil];
             alview.tag=9999;
             [alview show];*/
            
            UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Alert"
                                                                                message:@"You are at your destination"
                                                                         preferredStyle: UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Send Status"
                                                                  style: UIAlertActionStyleDestructive
                                                                handler: ^(UIAlertAction *action) {
                AppDelegate * appDelegates=(AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                [appDelegates.statusTimer invalidate];
                appDelegates.statusTimer=nil;
                [self sendStatus:nil];
            }];
            [controller addAction: alertAction];
            [self presentViewController: controller animated: YES completion: nil];
        }
        [self getRouteTo:JobAddress EngLoc:app.locationManager.location];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView* pinView ;
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    pinView= [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        pinView.canShowCallout=YES;
        pinView.pinTintColor = [UIColor greenColor];
        pinView.annotation = annotation;
        return pinView;
        
    }
    else if(![annotation isKindOfClass:[MKUserLocation class]])
    {
        pinView.animatesDrop=YES;
        pinView.canShowCallout=YES;
        pinView.frame = CGRectMake(0, 0,35,35);
        pinView.annotation = annotation;
        pinView.pinTintColor=[UIColor redColor];
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        MyAnnotation *annt=annotation;
        rightButton.tag=[annt.brnchID intValue];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightButton;
        return pinView;
    }
    return pinView;
}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor colorWithRed:204/255. green:45/255. blue:70/255. alpha:1.0];
    polylineView.lineWidth = 10.0;
    return polylineView;
}

-(void)showDetails:(id)sender{}

-(void)removeAllAnnotations
{
    id userAnnotation=_mapView.userLocation;
    [_mapView removeAnnotations:_mapView.annotations];
    if(userAnnotation!=nil)
        [_mapView addAnnotation:userAnnotation];
}
-(void)mapvgotolocation
{
    
    CLLocation *userLoc = _mapView.userLocation.location;
    CLLocationCoordinate2D userCoordinate = userLoc.coordinate;
    DLog(@"user latitude = %f",userCoordinate.latitude);
    DLog(@"user longitude = %f",userCoordinate.longitude);
    app.currentUserlatitude=userCoordinate.latitude;
    app.currentUserlongitude=userCoordinate.longitude;
    _mapView.delegate=self;
    
    arrCoordinate=[[NSMutableArray alloc] init];
    
    CLLocationCoordinate2D theCoordinate1;
    theCoordinate1.latitude = [strJobaddresslat doubleValue];
    theCoordinate1.longitude = [strJobaddresslong doubleValue];
    CLLocation *branchLocation = [[CLLocation alloc] initWithLatitude:theCoordinate1.latitude longitude:theCoordinate1.longitude];
    [arrCoordinate addObject:branchLocation];
    arrAnnotation=[[NSMutableArray alloc] init];
    MyAnnotation* myAnnotation1=[[MyAnnotation alloc] init];
    
    myAnnotation1.coordinate=[[arrCoordinate objectAtIndex:0] coordinate];
    myAnnotation1.title=[NSString stringWithFormat:@"%@",strFormattedJobaddresss];
    [arrAnnotation addObject:myAnnotation1];
    [_mapView addAnnotation:myAnnotation1];
    DLog(@"%ld",(unsigned long)[arrAnnotation count]);
    
    MKMapRect flyTo = MKMapRectNull;
    for (id <MKAnnotation> annotation in arrAnnotation) {
        DLog(@"fly to on");
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(flyTo)) {
            flyTo = pointRect;
        } else {
            flyTo = MKMapRectUnion(flyTo, pointRect);
            
        }
    }
    _mapView.visibleMapRect = flyTo;
    
}

#pragma mark - Utility Methods
- (void)plotRouteOnMap:(MKRoute *)route
{
    if(_routeOverlay) {
        [self.mapView removeOverlay:_routeOverlay];
    }
    
    // Update the ivar
    _routeOverlay = route.polyline;
    
    // Add it to the map
    [self.mapView addOverlay:_routeOverlay];
    
}

#pragma mark - MKMapViewDelegate methods
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 2.0;
    return  renderer;
}

@end

