//
//  FinancialNoteList.h
//  PM247
//
//  Created by Macmini2 on 1/18/17.
//  Copyright © 2017 SANDIPAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinNoteCell.h"
#import "GlobalDirector.h"
@interface FinancialNoteList : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tblList;

@property(strong,nonatomic)NSArray *arrFinNoteList;

@end
