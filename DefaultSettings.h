

//  DefaultSettings.h
//  Partner Maintenance


#ifndef Partner_Maintenance_DefaultSettings_h
#define Partner_Maintenance_DefaultSettings_h

//LIVE azure API
// #define conn_url  "http://pm247live-mobile.azurewebsites.net/PartnersService.svc/"

//Stage new azure API
//#define conn_url "http://0df1-42-111-16-54.ngrok.io/PartnersService.svc/"
//
#define conn_url  "http://pm247uat-mobile.azurewebsites.net/PartnersService.svc/"

// API Names
#define REQUEST_ValidateMobileNumber 1
#define REQUEST_GetPostcodes 2
#define REQUEST_SaveCustomerProfile 3
#define REQUEST_GetCustomerTypeList 4
#define REQUEST_GetCustomerTitleList 5
#define REQUEST_CustomerGenders 6
#define REQUEST_GetCustomerAddresses 7
#define REQUEST_CalculateFinancialDetail 8 ///get
#define REQUEST_SaveFinancialDetail 9 ///get
#define REQUEST_SendJobDetailsSms 10 ///get
#define REQUEST_GetJobDetails 11
#define REQUEST_GetFinancialDetail 12
#define REQUEST_GetJobPayments 13
#define REQUEST_GetPaymentModeList 14
#define REQUEST_SaveJobPayment 15
#define REQUEST_GetMessageCount 16
#define REQUEST_SetEnggCurrentLocation 17
#define REQUEST_GetAddress 18
#define REQUEST_FetchMaterialList 19
#define REQUEST_FetchCostList 20
#define REQUEST_FetchNoteList 21
#define REQUEST_GetCustomerDetails 22
#define REQUEST_JobCancellation 23
#define REQUEST_SetEngineerUnAssigned 24
#define REQUEST_GetCalendarJob 25
#define REQUEST_GetCalendarDate 26
#define REQUEST_GetCustomerCardDetails 27
#define REQUEST_SaveCardDetail 28
#define REQUEST_GetNoteTypeForEngineers 29
#define REQUEST_paRes 30

typedef enum jobStaus
{
    Book = 1,
    Active = 2,
    Complete = 3,
    ATTENTION = 4,
    Quote = 5,
    ForwardBooked = 6,
    CallBack = 7,
    ChaseUp = 8,
    Reminders = 9,
    PartsOnOrder = 10,
    ContinueWithoutAuthorization = 11,
    JobCancelled = 12,
    AbroadJob = 13
    
} jobStatus;

typedef enum AgreementSatus {
    
    No_agreement_signed=0,
    Small_repair_agreement_signed=1,
    Both_agreement_signed=2
    
    
} AgreementSatus;
//#define NSLog   //

//-------- Job Status ----
/*
 Book = 1,
 Active = 2,
 Complete = 3,
 ATTENTION = 4,
 Quote = 5,
 ForwardBooked = 6,
 CallBack = 7,
 ChaseUp = 8,
 Reminders = 9,
 PartsOnOrder = 10,
 ContinueWithoutAuthorization = 11,
 JobCancelled = 12,
 AbroadJob = 13
 */
//-------------------------




//SagePay


// live term url (3d secure redirect term url for payment)
//#define term_url_segpayresponse "http://pm247live-mobile.azurewebsites.net/PartnersService.svc/Validate3DTransaction"
//#define sageMerchantSessionKey  "merchant-session-keys"
//#define sagecard_identifiers "card-identifiers"
//#define transactions "transactions"

//term url for stage (3d secure redirect term url for payment)
#define term_url_segpayresponse "http://pm247uat-mobile.azurewebsites.net/PartnersService.svc/Validate3DTransaction"
#define sageMerchantSessionKey  "merchant-session-keys"
#define sagecard_identifiers "card-identifiers"
#define transactions "transactions"


//Basic profile test (payment test account)

#define Sageconn_url  "https://pi-test.sagepay.com/api/v1/"  //test sage pay url
#define vendorName "pm247ltd"
#define integrationKey "E0l8iFAkS0nehVSUrx5AnrrlVWtwjXUDuS93sOJw1uulmsKRxy"

#define integrationPassword "tjnjHmrLIz8QGSRbE2LTHGvzf1TG9xDt2zsyN55fKN58msuFPSNPy1dVJd6qclfem"



//Basic profile test (payment live account)
//#define Sageconn_url  "https://pi-live.sagepay.com/api/v1/" //test sage pay url
//#define vendorName "pm247ltd"
//#define integrationKey "9v7fmp14s7safQjrC7QxfLXtRg9wyF3VqBbbEf8mwPuJ8IOGwF"
//#define integrationPassword "wAioONamdHXb4ylATCCh09LHDajYjZNJJgfgCSFxdMrYmjAGOE6VpsOpo6jtowvMN"




/**********************
 */
// Old version Crads (not in use)

////Text
//#define Sageconn_url  "https://pi-test.sagepay.com/api/v1/"
//
////Live
//#define Sageconn_url  "https://pi-live.sagepay.com/api/v1/"
//
//#define sageMerchantSessionKey  "merchant-session-keys"
//#define sagecard_identifiers "card-identifiers"
//
////Basic profile
//#define transactions "transactions"
//#define vendorName "pm365ltd"
//
////Sanbox
//#define integrationKey "KvmUptrndQW8Rs69U8uwvEpSleEBG7HOadZvIR84GiROGDo0Vx"
//#define integrationPassword "kMaYERF4EjuU4zwAzabyllhwYhPuv0qzelleTyXPm1FNk7VdeLqAOf0OvFgMdD9vS"
/***********************/

#endif

//Message section

#define textfieldError @"Please enter the textfield marked in red."
#define msgOTP @"Please enter One Time Password(OTP) sent to your registered mobile number."


