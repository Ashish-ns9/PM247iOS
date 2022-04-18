//
//  BaseTableCell.m
//  E2MRichmond
//
//  Created by Atanu on 09/10/13.
//  Copyright (c) 2013 EmpiricaTecnologies. All rights reserved.
//

#import "BaseTableCell.h"


@implementation BaseTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

+ (BaseTableCell *)cellFromNibNamed:(NSString *)nibName {
	NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
	NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
	BaseTableCell *customCell = nil;
	NSObject* nibItem = nil;
	while ((nibItem = [nibEnumerator nextObject]) != nil) {
		if ([nibItem isKindOfClass:[BaseTableCell class]]) {
			customCell = (BaseTableCell *)nibItem;
			break; // we have a winner
		}
	}
	return customCell;
}



@end
