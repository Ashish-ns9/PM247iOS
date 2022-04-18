//
//  GlobalDirector.h
//  ShareCrazy
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "PPRevealSideViewController.h"
//#import "SideTableViewController.h"
#import "DefaultSettings.h"
//#import "YRDropdownView.h"
//#import "SVProgressHUD.h"
#import "GlobalDirector.h"

@interface GlobalDirector : NSObject
{
    UIViewController *ctrl;
     BOOL isback;
}

@property(nonatomic,strong)UIViewController *ctrl;

+ (id) SharedDirector;


//+ (void)showSuccess:(NSString *)msg;
+ (void)showError:(NSString *)errorMsg;
+(void)showAleart:(NSString*)msg ctrl:(UIViewController*)ctrl;



-(void)SyncRequestPost:(int)reqID withPrams:(NSMutableDictionary*)dictPrams andCompletionHandler:(void (^)(NSDictionary *result))completionHandler;
-(void)SyncRequestGet:(int)reqID withPrams:(NSMutableDictionary*)dictPrams andCompletionHandler:(void (^)(NSDictionary *result))completionHandler;
-(void)SyncRequestPostWithJson:(int)reqID withPrams:(NSMutableDictionary*)dictPrams andCompletionHandler:(void (^)(NSDictionary *result))completionHandler;

-(void)SyncRequestPostURL:(NSString*)reqURL withPrams:(NSMutableDictionary*)dictPrams authorizationKey:(NSString*)aut andCompletionHandler:(void (^)(NSDictionary *result))completionHandler;
-(void)SyncGetWithURL:(NSString*)strURL andCompletionHandler:(void (^)(NSDictionary *result))completionHandler;



+(BOOL)emailValidation:(NSString*)emailId;
+(void)NavagationSetup;
-(void)SetupMenu:(UIViewController*)nav isBack:(BOOL)isBack;
+(NSString*)ReplaceStringNull:(id)str;
+(NSString *)urlForId:(int)reqId;
+(void)ChangePlaceholderColor:(UIColor*)color;
+(UIImage *) scaleAndRotateImage: (UIImage *)image;
+(void)ManadetoryFields:(UITextField*)field;
+(void)cleanTextView:(UITextView *)textV;
+(void)ShowErrorAtTextView:(UITextView *)txtfld alert:(NSString *)alrt;
+(void)ManadetoryFields:(UITextField*)field withText:(NSString*)str;
+(void)TextFieldBorderColorChangeWithArray:(NSArray*)arrTextfield withColor:(UIColor*)colour;
+(void)TextFieldBorderColorChange:(UITextField*)txt withColor:(UIColor*)colour;
+(void)TextFieldErrorShow:(NSArray*)arrTextfield;


@end
