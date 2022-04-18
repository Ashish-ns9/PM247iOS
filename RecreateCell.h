//
//  RecreateCell.h
//  PM247
//


#import <UIKit/UIKit.h>
#import "BaseTableCell.h"
@interface RecreateCell : BaseTableCell

@property (strong, nonatomic) IBOutlet UILabel *txtAddress;
@property (strong, nonatomic) IBOutlet UILabel *txtCity;
@property (strong, nonatomic) IBOutlet UILabel *txtCounty;
@property (strong, nonatomic) IBOutlet UILabel *txtPostCode;
@property (strong, nonatomic) IBOutlet UIView *viewLine;
@property (strong, nonatomic) IBOutlet UILabel *txtDes;
@property (strong, nonatomic) IBOutlet UILabel *txtcomName;
@property (strong, nonatomic) IBOutlet UILabel *txtDate;
@property (strong, nonatomic) IBOutlet UILabel *txtTA;
@property (strong, nonatomic) IBOutlet UIButton *btnRecreate;


@end
