//
//  FinancialNoteList.m
//  PM247
//


#import "FinancialNoteList.h"

@interface FinancialNoteList ()

@end

@implementation FinancialNoteList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)ClickBack:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - TableView Delegate & Datasource
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arrFinNoteList.count>0) {
        return _arrFinNoteList.count;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_arrFinNoteList count]>0) {
        
        static NSString *CellIdentifier = @"FinNoteCell";
        FinNoteCell  *cell=(FinNoteCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // tableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tab_page.png"]];
        if(cell==nil)
        {
            cell =(FinNoteCell*)[BaseTableCell cellFromNibNamed:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSDictionary *dict = [_arrFinNoteList objectAtIndex:indexPath.row];
        cell.lblCreatedBy.text = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"CreatedBy"]];
        cell.lblCreateddate.text = [GlobalDirector ReplaceStringNull:[dict valueForKey:@"CreatedDate"]];
        cell.lblDes.text = [NSString stringWithFormat:@"Description: %@",[GlobalDirector ReplaceStringNull:[dict valueForKey:@"NoteBody"]]];
        
        return cell;
        
        
    }else{
        static NSString *cellidentifier=@"cellidentifier";
        UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.font=[UIFont fontWithName:@"TheSansArabic-Plain" size:13.0];
        cell.textLabel.text=@"No data to show.";
        return cell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
