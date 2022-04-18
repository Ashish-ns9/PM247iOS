
//  HelpWidgetVC.m
//  PM247
//  Created by Shubham Tomar on 07/06/21.
//  Copyright © 2021 SANDIPAN. All rights reserved.
//

#import "HelpWidgetVC.h"

@interface HelpWidgetVC ()

@end

@implementation HelpWidgetVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.PracticeWebView.scrollView setScrollEnabled:false];
    [self.PracticeWebView loadHTMLString: [self getHTMLString] baseURL:[NSURL URLWithString:@""]];
    
}
- (NSString *)getHTMLString
{
    NSString *filePath =  [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString *strHTML = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",strHTML);
        if(self.dictData)
        NSLog(@"%@",_dictData);
    {
        strHTML = [strHTML stringByReplacingOccurrencesOfString:@"coustomername" withString:[_dictData valueForKey:@"var1"]];
        strHTML = [strHTML stringByReplacingOccurrencesOfString:@"postalcode" withString:[_dictData valueForKey:@"var2"]];
            
    }
    
    NSLog(@"%@",strHTML);
    return strHTML;
  
}


- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
