//
//  MyTextField.m
//  DPX
//
//  Created by Chayan on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
    CGRect inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y-1, bounds.size.width - 5, bounds.size.height);
        return inset;
    }
    else
    {
        CGRect inset = CGRectMake(bounds.origin.x + 20, bounds.origin.y-4, bounds.size.width - 15, bounds.size.height);
        return inset;
    }
    
}
- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
    CGRect inset = CGRectMake(bounds.origin.x + 10, bounds.origin.y-1, bounds.size.width - 5, bounds.size.height);
    return inset;
    }
    else
    {
        CGRect inset = CGRectMake(bounds.origin.x + 20, bounds.origin.y-4, bounds.size.width - 15, bounds.size.height);
        return inset;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
