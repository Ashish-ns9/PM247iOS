

//  DefaultSettings.h
//  Partner Maintenance

#ifndef Partner_Maintenance_DefaultSettings_h
#define Partner_Maintenance_DefaultSettings_h


//Testing Url
#define conn_url  "http://pm247uat-mobile.azurewebsites.net/PartnersService.svc/"
//Test Mahendra Account
#define squareUpBaseURL "https://connect.squareupsandbox.com/v2/"
#define squareUpLocationId  "LN3B806FJJ5CY"
#define squareUpApplicationId "sandbox-sq0idb-Z5IEv4BrecUJhwCf-9d1zw"
#define squareUpAccessToken  "EAAAEGbNeznS0jzWJKSgIc7qSVI2bfPGxOr0b9tNZZ7But1qvULid3acsM2CIxM4"

//LIVE azure API
// #define conn_url  "http://pm247live-mobile.azurewebsites.net/PartnersService.svc/"
////Live Square Up Client
//#define squareUpBaseURL  "https://connect.squareup.com/v2/"
//#define squareUpLocationId  "LH5DF4N9CFZPK"
//#define squareUpApplicationId "sq0idp-3Znix2LDK_rDkwql1fBarg"
//#define squareUpAccessToken  "EAAAFM2j-JVMj0UtbvZpFPHCD_BVmISy3aCp5HobcqYfFllqgmjv0bJ0j2napQuC"


// TESTING VOLT
#define voltBaseURL "https://api.sandbox.volt.io/"
#define voltClientID "308bc389-00cf-4a1d-8122-6e116db6aa66"
#define voltClientSecret "67aaca17-1394-413f-ae4a-c79761389bf6"
#define voltUsername "pm264df9deac0e805.77008803@volt.io"
#define voltPassword "X1q$&kE8PVT%Z#!745f9iz@wu0S3*Ib1"

// PRODUCTION VOLT
//#define voltBaseURL "https://api.volt.io/"
//#define voltClientID "9b31ea15-a857-4fd9-b8ba-fc1f25f9b2e9"
//#define voltClientSecret "f5f196f4-be8e-4751-86e4-e883b5075c76"
//#define voltUsername "pm264facb49d898e6.28096146@volt.io"
//#define voltPassword "pG*8cXe0#%f$95iS1&@!C27VRjPM3gb1"


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

#define REQUEST_SaveSquarePaymentDetailAndSendSms 31
#define REQUEST_GetSquareUpInvoiceID 32
#define REQUEST_GetSquareUpPaymentDetails 33
#define REQUEST_GetInvoice 34

#define REQUEST_SetEngineerTimer 35
#define REQUEST_GetEngineerTimer 36

#define REQUEST_GetEngineerList 37
#define REQUEST_UpdateEngineerCurrentAddressDtl 38
#define REQUEST_UpdateEngineerProfileDtl 39
#define REQUEST_GetEngineerProfileDtl 40
#define REQUEST_SendInvitation 41
#define REQUEST_UpdateEngLocation 42
#define REQUEST_GetEngineerByDistance 43





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
#define term_url_segpayresponse "http://pm247live-mobile.azurewebsites.net/PartnersService.svc/Validate3DTransaction"
#define sageMerchantSessionKey  "merchant-session-keys"
#define sagecard_identifiers "card-identifiers"
#define transactions "transactions"

//term url for stage (3d secure redirect term url for payment)
//    #define term_url_segpayresponse "http://pm247uat-mobile.azurewebsites.net/PartnersService.svc/Validate3DTransaction"
//    #define sageMerchantSessionKey  "merchant-session-keys"
//    #define sagecard_identifiers "card-identifiers"
//    #define transactions "transactions"


//Basic profile test (payment test account)
//
#define Sageconn_url  "https://pi-test.sagepay.com/api/v1/"  //test sage pay url
//#define vendorName "pm247ltd"
//#define integrationKey "E0l8iFAkS0nehVSUrx5AnrrlVWtwjXUDuS93sOJw1uulmsKRxy"
//#define integrationPassword "tjnjHmrLIz8QGSRbE2LTHGvzf1TG9xDt2zsyN55fKN58msuFPSNPy1dVJd6qclfem"


//Basic profile test (payment live account)
//#define Sageconn_url  "https://pi-live.sagepay.com/api/v1/" //test sage pay url
#define vendorName "pm247ltd"
#define integrationKey "9v7fmp14s7safQjrC7QxfLXtRg9wyF3VqBbbEf8mwPuJ8IOGwF"
#define integrationPassword "wAioONamdHXb4ylATCCh09LHDajYjZNJJgfgCSFxdMrYmjAGOE6VpsOpo6jtowvMN"




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


