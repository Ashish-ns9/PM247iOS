//
//  EditProfileVC.h
//  PM247
//
//  Created by Vikram on 01/07/23.
//  Copyright © 2023 SANDIPAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "SWRevealViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditProfileVC : ViewController<SWRevealViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnSlideMenu;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UITextField *txtRadius;

-(IBAction)btnSaveClicked:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
