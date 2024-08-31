//
//  EngineerListVC.h
//  PM247
//
//  Created by Vikram on 01/07/23.
//  Copyright © 2023 SANDIPAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "SWRevealViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EngineerListVC : ViewController<SWRevealViewControllerDelegate,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate>
{
    NSMutableArray *arrList, *filterArray;
}
@property(nonatomic,retain)IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UIButton *btnInvite;
@property (strong, nonatomic) IBOutlet UILabel *lblPlaceHolder;

@property (strong, nonatomic) IBOutlet UIButton *btnSlideMenu;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSString *distnceValue;
@property NSInteger jobId;

-(IBAction)btnBackClicked:(UIButton *)sender;
- (IBAction)btnInviteClicked:(id)sender;

@end

NS_ASSUME_NONNULL_END
