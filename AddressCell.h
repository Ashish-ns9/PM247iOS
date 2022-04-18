//
//  AddressCell.h
//  Partner Maintenance
//
//  Created by Macmini2 on 9/8/16.
//  Copyright © 2016 SANDIPAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableCell.h"

@interface AddressCell : BaseTableCell
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@end
