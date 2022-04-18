//
//  FinNoteCell.h
//  PM247
//


#import <UIKit/UIKit.h>
#import "BaseTableCell.h"
@interface FinNoteCell : BaseTableCell
@property (strong, nonatomic) IBOutlet UILabel *lblCreatedBy;
@property (strong, nonatomic) IBOutlet UILabel *lblCreateddate;
@property (strong, nonatomic) IBOutlet UILabel *lblDes;

@end
