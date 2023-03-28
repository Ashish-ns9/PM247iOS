//
//  CreateInvoiceVC.h
//  PM247
//
//  Created by Vikram on 11/11/22.
//  Copyright © 2022 SANDIPAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateInvoiceVC : ViewController
@property(nonatomic,retain)  NSDictionary *dictJob;
@property(nonatomic,retain)  NSString *orderID;
@property(nonatomic,retain)  NSString *customerID;
@property(nonatomic,retain)  UIDatePicker *datePicker;
@end

NS_ASSUME_NONNULL_END
