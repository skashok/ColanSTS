    //
//  DropDownView.m
//  CustomTableView
//
//  Created by Ameya on 19/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DropDownView.h"

#import <QuartzCore/QuartzCore.h>

@implementation DropDownView

@synthesize uiTableView;

@synthesize arrayData,heightOfCell,refView;

@synthesize paddingLeft,paddingRight,paddingTop;

@synthesize open,close;

@synthesize heightTableView;

@synthesize delegate;

@synthesize selectedIndexPath;

@synthesize snoozedelegate;

@synthesize userSettingsTechDelegate;

@synthesize userSettingsSnoozeIntervalDelegate;

@synthesize dailyRecapDelegate;

- (id)initWithArrayData:(NSArray*)data cellHeight:(CGFloat)cHeight heightTableView:(CGFloat)tHeightTableView paddingTop:(CGFloat)tPaddingTop paddingLeft:(CGFloat)tPaddingLeft paddingRight:(CGFloat)tPaddingRight refView:(UIView*)rView animation:(AnimationType)tAnimation openAnimationDuration:(CGFloat)openDuration closeAnimationDuration:(CGFloat)closeDuration{

	if ((self = [super init])) {
		
		self.arrayData = data;
		
		self.heightOfCell = cHeight;
		
		self.refView = rView;
		
		self.paddingTop = tPaddingTop;
		
		self.paddingLeft = tPaddingLeft;
		
		self.paddingRight = tPaddingRight;
		
		self.heightTableView = tHeightTableView;
		
		self.open = openDuration;
		
		self.close = closeDuration;
		
		CGRect refFrame = refView.frame;
		
		self.view.frame = CGRectMake(refFrame.origin.x-paddingLeft,refFrame.origin.y+refFrame.size.height+paddingTop,refFrame.size.width+paddingRight, heightTableView);
		
		self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
		
		self.view.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
		
		self.view.layer.shadowOpacity =1.0f;
		
		self.view.layer.shadowRadius = 5.0f;
		
		animationType = tAnimation;
		
	}
	
	return self;
	
}	

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	[super viewDidLoad];
	
	CGRect refFrame = refView.frame;
		
	uiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,7,refFrame.size.width+paddingRight, (animationType == BOTH || animationType == BLENDIN)?heightTableView:1) style:UITableViewStylePlain];
	
	uiTableView.dataSource = self;
	
	uiTableView.delegate = self;
	
	[self.view addSubview:uiTableView];
	
	self.view.hidden = YES;
	
	if(animationType == BOTH || animationType == BLENDIN)
	[self.view setAlpha:1];       
    
    uiTableView.separatorColor = [UIColor blackColor];	
    uiTableView.layer.borderWidth=1.0;
    uiTableView.layer.borderColor=[[UIColor blackColor]CGColor]; 
    selectedIndexes = [[NSMutableArray alloc] init];
    uiTableView.allowsMultipleSelection = YES;
    
    selectedIndexPath = [[NSMutableArray alloc] init];
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return heightOfCell;
}	

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	
	return [arrayData count];
}	

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
        
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (delegate != nil)
    {
        if ([selectedIndexes containsObject:indexPath]) {
            
            [cell setAccessoryType :UITableViewCellAccessoryCheckmark];
        
        }else{
            [cell setAccessoryType :UITableViewCellAccessoryNone];
        }
    }
    else if (dailyRecapDelegate != nil)
    {
        if ([selectedIndexes containsObject:indexPath])
            [cell setAccessoryType :UITableViewCellAccessoryCheckmark];
        else
            [cell setAccessoryType :UITableViewCellAccessoryNone];
    }
    else if(userSettingsTechDelegate != nil)
    {
        if ([selectedIndexPath containsObject:indexPath]) {
            
            [cell setAccessoryType :UITableViewCellAccessoryCheckmark];
            
        }else{
            [cell setAccessoryType :UITableViewCellAccessoryNone];
        }
    }
    else
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    if ([arrayData count]!=0) {
     
        cell.textLabel.text = [arrayData objectAtIndex:indexPath.row];
    }
     cell.textLabel.font = [UIFont systemFontOfSize:14.0];
     return cell;
}	

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (snoozedelegate != nil)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [snoozedelegate snoozeCellSelected:indexPath.row];
        [self closeAnimation];
    }
    else if (delegate != nil)
    {
        if (indexPath.row==0) {
            
            if ([selectedIndexes count] ==[arrayData count]) {
                
                [delegate dropDownCellDeselected:0];
                [selectedIndexes removeAllObjects];
                
            }else {
                
                [selectedIndexes removeAllObjects];
                
                [delegate dropDownCellSelected:indexPath.row];
                
                for (int i=0; i<[arrayData count];i++) {
                    
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                    [selectedIndexes addObject:indexPath];
                }
            }
        }else {
            
            if ([selectedIndexes count] == [arrayData count]) {
                
                NSIndexPath *zeroindexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                [selectedIndexes removeObject:zeroindexPath];
                [selectedIndexes removeObject:indexPath];
                
                for (int i=1; i<[arrayData count];i++) {
                    
                    [delegate dropDownCellSelected:i];
                }
                [delegate dropDownCellDeselected:indexPath.row];
                [delegate dropDownCellDeselected:0];
            }else {
                
                if ([selectedIndexes containsObject:indexPath]) {
                    
                    [selectedIndexes removeObject:indexPath];
                    [delegate dropDownCellDeselected:indexPath.row];
                    
                }else {
                    [selectedIndexes addObject:indexPath];
                    [delegate dropDownCellSelected:indexPath.row];
                }
            }
        }
        
        [tableView reloadData];
    }
    else if (dailyRecapDelegate !=nil)
    {
        if (indexPath.row==0) {
            
            if ([selectedIndexes count] ==[arrayData count])
            {
                [dailyRecapDelegate dailyRecapCellDselected:0];
                [selectedIndexes removeAllObjects];
                
            }else
            {
                [selectedIndexes removeAllObjects];
                
                [dailyRecapDelegate dailyRecapCellSelected:indexPath.row];
                
                for (int i=0; i<[arrayData count];i++)
                {
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                    [selectedIndexes addObject:indexPath];
                }
            }
        }
        else
        {
            if ([selectedIndexes count] == [arrayData count])
            {
                NSIndexPath *zeroindexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                [selectedIndexes removeObject:zeroindexPath];
                [selectedIndexes removeObject:indexPath];
                
                for (int i=1; i<[arrayData count];i++)
                {
                    [delegate dropDownCellSelected:i];
                }
                [dailyRecapDelegate dailyRecapCellDselected:indexPath.row];
                // [dailyRecapDelegate dailyRecapCellDselected:0];
            }
            else
            {
                if ([selectedIndexes containsObject:indexPath])
                {
                    [selectedIndexes removeObject:indexPath];
                    [dailyRecapDelegate dailyRecapCellDselected:indexPath.row];
                }
                else
                {
                    [selectedIndexes addObject:indexPath];
                    [dailyRecapDelegate dailyRecapCellSelected:indexPath.row];
                }
            }
        }
        [tableView reloadData];
    }
    else if (userSettingsTechDelegate != nil)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if(![selectedIndexPath containsObject:indexPath])
            [selectedIndexPath addObject:indexPath];
        else
           [selectedIndexPath removeObject:indexPath];
        [tableView reloadData];
    }
    else if (userSettingsSnoozeIntervalDelegate != nil)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [userSettingsSnoozeIntervalDelegate userSettingsSnoozeIntervalSelected:indexPath.row];
        [self closeAnimation];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

	return 0;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

	return 0;
	
}	

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

	return @"";
}	

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{

	return @"";
	
}	


-(NSArray *)donePressed
{
    NSLog(@"selectedIndexPath = %@",selectedIndexPath);
    return selectedIndexPath;
}

#pragma mark -
#pragma mark DropDownViewDelegate

-(void)dropDownCellSelected:(NSInteger)returnIndex{
	
}	

#pragma mark -
#pragma mark Class Methods


-(void)openAnimation{
	
	self.view.hidden = NO;
	
	NSValue *contextPoint = [NSValue valueWithCGPoint:self.view.center];
	
	[UIView beginAnimations:nil context:(__bridge_retained void *)contextPoint];
	
	[UIView setAnimationDuration:open];
	
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDelay:0];
	
	if(animationType == BOTH || animationType == GROW)
		self.uiTableView.frame = CGRectMake(uiTableView.frame.origin.x,uiTableView.frame.origin.y,uiTableView.frame.size.width, heightTableView);
	
	if(animationType == BOTH || animationType == BLENDIN)
		self.view.alpha = 1;
	
	[UIView commitAnimations];

}

-(void)closeAnimation{
	
	NSValue *contextPoint = [NSValue valueWithCGPoint:self.view.center];
	
	[UIView beginAnimations:nil context:(__bridge_retained void *)contextPoint];
	
	[UIView setAnimationDuration:close];
	
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDelay:0];
	
	if(animationType == BOTH || animationType == GROW)
		self.uiTableView.frame = CGRectMake(uiTableView.frame.origin.x,uiTableView.frame.origin.y,uiTableView.frame.size.width, 1);
	
	if(animationType == BOTH || animationType == BLENDIN)
		self.view.alpha = 0;
	
	[UIView commitAnimations];
	
	[self performSelector:@selector(hideView) withObject:nil afterDelay:close];

}

	 
-(void)hideView{
	
	self.view.hidden = YES;

}	 


@end
