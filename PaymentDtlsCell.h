//
//  PaymentDtlsCell.h
//  PM247
//


#import <UIKit/UIKit.h>
#import "BaseTableCell.h"
@interface PaymentDtlsCell : BaseTableCell

@property (strong, nonatomic) IBOutlet UILabel *lblPayTaken;
@property (strong, nonatomic) IBOutlet UILabel *lblPaydate;
@property (strong, nonatomic) IBOutlet UILabel *lblPayAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblDes;
@property (strong, nonatomic) IBOutlet UIButton *btnAttachment;
@property (strong, nonatomic) IBOutlet UILabel *lblTranID;
@property (strong, nonatomic) IBOutlet UILabel *lblTranType;

@property (strong, nonatomic) IBOutlet UIView *viewFooter;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblTranTypeBottomConstr;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblTransIdBottom;



@end
