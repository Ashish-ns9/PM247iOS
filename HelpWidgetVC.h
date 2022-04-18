//
//  HelpWidgetVC.h
//  PM247
//
//  Created by Shubham Tomar on 07/06/21.
//  Copyright © 2021 SANDIPAN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HelpWidgetVC : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *PracticeWebView;
- (IBAction)backBtn:(id)sender;
@property (strong, nonatomic) IBOutlet NSDictionary *dictData;


@end

NS_ASSUME_NONNULL_END
