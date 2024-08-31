//
//  ShowTimerTableViewCell.h
//  PM247
//
//  Created by Vikram on 28/06/23.
//  Copyright © 2023 SANDIPAN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowTimerTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblStartTimer;
@property (strong, nonatomic) IBOutlet UILabel *lblEndTimer;
@property (strong, nonatomic) IBOutlet UILabel *lblTimer;
@property (weak, nonatomic) IBOutlet UILabel *lblActionType;

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIStackView *timerStackView;

@end

NS_ASSUME_NONNULL_END
