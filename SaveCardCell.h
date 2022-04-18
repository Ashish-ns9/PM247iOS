//
//  SaveCardCell.h
//  PM247
//


#import <UIKit/UIKit.h>
#import "BaseTableCell.h"
@interface SaveCardCell : BaseTableCell

@property (strong, nonatomic) IBOutlet UILabel *lblCardNumber;
@property (strong, nonatomic) IBOutlet UIImageView *imgType;
@property (strong, nonatomic) IBOutlet UILabel *lblccv;
@property (strong, nonatomic) IBOutlet UITextField *txtCCV;
@property (weak, nonatomic) IBOutlet UIButton *BtnCvvInfo;

@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (weak, nonatomic) IBOutlet UILabel *lblDescribtion;

@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (weak, nonatomic) IBOutlet UIButton *btnArrow;
@end
