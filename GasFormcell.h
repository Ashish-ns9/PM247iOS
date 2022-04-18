//
//  GasFormcell.h
//  Partner Maintenance
//


#import <UIKit/UIKit.h>
#import "BaseTableCell.h"
@interface GasFormcell : BaseTableCell

@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *serial;
@property (strong, nonatomic) IBOutlet UIButton *btnInvoice;


@end
