//
//  EngineerListTableViewCell.h
//  PM247
//
//  Created by Vikram on 01/07/23.
//  Copyright © 2023 SANDIPAN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EngineerListTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UIButton *btnInvite;

@end

NS_ASSUME_NONNULL_END
