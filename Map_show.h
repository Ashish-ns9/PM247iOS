//
//  Map_show.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"

#define conn_mapurl  "http://maps.google.com/maps/api/geocode/json?"

@interface Map_show : ViewController<NSURLConnectionDelegate,MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>
{
    NSString *strHeading;
    NSMutableData *_responseData;
    NSURLConnection *connMap,*connSendStatus;
    
    NSMutableDictionary *dicJobTemp;
    
    CLLocation *endLoc;
    UIView  *mainBg ,*bgVw;
    UITextField *txtStatusType;
    
    UIButton *btnCross,*btnSend;
    UILabel *lblSliderval;
    UISlider *slider;
    NSString *RunningStatusVal;
   
    MyAnnotation* enggAnnotation;
    
    
    NSString *JobAddress;
    
    BOOL ismapDrawn;
    
    NSMutableArray *arrCoordinate,*arrAnnotation;
    NSString *strJobaddresslat,*strJobaddresslong,*strFormattedJobaddresss;
    UITableView *tblView;
    UITextField *Activetxtfld;
    NSArray *arrFeedTblPopup;
    CLLocation *currLoc,*prevCurrLoc;
    UITextView *txtvNoteBody;
    
    MKPolyline *_routeOverlay;
    MKRoute *_currentRoute;
    
}
@property(nonatomic,retain)NSMutableDictionary *dicJobTemp;
//@property(retain,nonatomic)CLLocationManager *locationManager;


@property(nonatomic,retain)NSString *strHeading;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *lbldist;
- (IBAction)sendStatus:(id)sender;
//-(void)StopAllTimer;

-(IBAction)backPress:(id)sender;
-(void)mapvgotolocation;
@end
