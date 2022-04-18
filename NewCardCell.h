//
//  NewCardCell.h
//  PM247
//


#import <UIKit/UIKit.h>
#import "BaseTableCell.h"

@interface NewCardCell : BaseTableCell
@property (strong, nonatomic) IBOutlet UILabel *lblNewCard;
@property (weak, nonatomic) IBOutlet UIButton *btnArrow;



@end
