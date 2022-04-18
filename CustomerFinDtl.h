//
//  CustomerFinDtl.h
//  Partner Maintenance
//
//  Created by Macmini2 on 11/17/16.
//  Copyright © 2016 SANDIPAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalDirector.h"
#import "ViewController.h"
#import "MBProgressHUD.h"


@interface CustomerFinDtl : ViewController
{
    MBProgressHUD *hud;
}

@property(retain,nonatomic)NSDictionary *jobDic;



@property (strong, nonatomic) IBOutlet UITextView *txtFinNote;
@property (strong, nonatomic) IBOutlet UITextView *txtSubTotal;
@property (strong, nonatomic) IBOutlet UITextView *txtJobVat;
@property (strong, nonatomic) IBOutlet UITextView *txtJobTotal;
@property (strong, nonatomic) IBOutlet UITextView *txtAmount;

@end
