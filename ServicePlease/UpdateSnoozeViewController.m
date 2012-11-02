//
//  UpdateSnoozeViewController.m
//  ServiceTech
//
//  Created by colan on 22/10/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "UpdateSnoozeViewController.h"
#import "ServiceHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "ServicePleaseValidation.h"
#import "AppDelegate.h"

@interface UpdateSnoozeViewController ()

@end

@implementation UpdateSnoozeViewController

@synthesize rootPopUpViewController;

@synthesize delegate;

@synthesize snoozeReasonTableView;

@synthesize snoozeReasonListTableView;

@synthesize snoozeReasonListBgView;

@synthesize snoozeReasonListView;

@synthesize snoozeDateTimeTableView;

@synthesize snoozeView;

@synthesize snoozeScrollView;

@synthesize snoozeIntervalTableView;

@synthesize snoozIntervalTypeListTableView;

@synthesize snoozeIntervalTypeBgView;

@synthesize snoozeIntervalTypeView;

@synthesize snoozeIntervalPopUpBGView;

@synthesize snoozeIntervalPopUpView;

@synthesize snoozeIntervalTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        reasonValue = @"";
        
        dateValue = @"";
        timeValue = @"";
        
        intervalValue = @"";
        intervalTypeValue = @"";

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *leftBtnImage=[UIImage imageNamed:@"left.png"];
    UIButton *leftnavBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftnavBtn.bounds=CGRectMake(0,0,26,26);
    [leftnavBtn setImage:leftBtnImage forState:UIControlStateNormal];
    [leftnavBtn addTarget:self action:@selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftnavBtn];
    self.navigationItem.leftBarButtonItem=leftBtnItem;
    
    listOfSnoozeReasons = [[NSMutableArray alloc] init];
    
    reasonListarray = [[NSMutableArray alloc] init];
    
    listOfSnoozeReasons = [ServiceHelper getAllSnoozeReasons];
    
    for (int i = 0; i < [listOfSnoozeReasons count]; i++)
    {
        SnoozeReason *snoozeReason = [listOfSnoozeReasons objectAtIndex:i];
        
        [reasonListarray addObject:snoozeReason.name];
    }
//	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//    {
//        snoozeScrollView.frame = CGRectMake(0, 0, 280, 360);
//        snoozeScrollView.contentSize = CGSizeMake(280, 380);
//    }
    selectedSnoozeIndexPath = [[NSMutableArray alloc] init];
    selectedSnoozeReasonIndexPath = [[NSMutableArray alloc] init];
    selectedSnoozeDateTimeIndexPath = [[NSMutableArray alloc] init];
    selectedSnoozeIntervalIndexPath = [[NSMutableArray alloc] init];
    selectedIntervalTypeIndexPath = [[NSMutableArray alloc] init];

    snoozeReasonTableView.layer.cornerRadius = 10;
    snoozeReasonTableView.layer.borderWidth = 1;
    snoozeReasonTableView.layer.borderColor = [UIColor blackColor].CGColor;
    
    snoozeReasonListBgView.hidden = YES;
    snoozeReasonListBgView.layer.cornerRadius = 10;
    snoozeReasonListBgView.layer.borderWidth = 1;
    snoozeReasonListBgView.layer.borderColor = [UIColor blackColor].CGColor;

    snoozeReasonListView.layer.cornerRadius = 10;
    snoozeReasonListView.layer.borderWidth = 1;
    snoozeReasonListView.layer.borderColor = [UIColor blackColor].CGColor;

    snoozeReasonListTableView.layer.cornerRadius = 10;
    snoozeReasonListTableView.layer.borderWidth = 1;
    snoozeReasonListTableView.layer.borderColor = [UIColor blackColor].CGColor;

    snoozeDateTimeTableView.layer.cornerRadius = 10;
    snoozeDateTimeTableView.layer.borderWidth = 1;
    snoozeDateTimeTableView.layer.borderColor = [UIColor blackColor].CGColor;
    
    snoozeIntervalTypeBgView.hidden = YES;

    snoozeIntervalTypeBgView.layer.cornerRadius = 10;
    snoozeIntervalTypeBgView.layer.borderWidth = 1;
    snoozeIntervalTypeBgView.layer.borderColor = [UIColor blackColor].CGColor;

    snoozeIntervalTypeView.layer.cornerRadius = 10;
    snoozeIntervalTypeView.layer.borderWidth = 1;
    snoozeIntervalTypeView.layer.borderColor = [UIColor blackColor].CGColor;

    [self getAllIntervalTypes];
    
    for (int i = 0; i < [listOfIntervalTypes count]; i++)
    {
        IntervalType *intervalType = [listOfIntervalTypes objectAtIndex:i];
        
        if ([intervalTypeId isEqualToString:intervalType.intervalTypeId])
        {
            intervalTypeValue = intervalType.name;
        }

    }
    snoozeIntervalTableView.layer.cornerRadius = 10;
    snoozeIntervalTableView.layer.borderWidth = 1;
    snoozeIntervalTableView.layer.borderColor = [UIColor blackColor].CGColor;

    snoozIntervalTypeListTableView.layer.cornerRadius = 10;
    snoozIntervalTypeListTableView.layer.borderWidth = 1;
    snoozIntervalTypeListTableView.layer.borderColor = [UIColor blackColor].CGColor;

    snoozeIntervalPopUpBGView.hidden = YES;

    snoozeIntervalPopUpView.layer.cornerRadius = 10;
    snoozeIntervalPopUpView.layer.borderWidth = 1;
    snoozeIntervalPopUpView.layer.borderColor = [UIColor blackColor].CGColor;

}
-(void)doneClicked
{
    [delegate UpdateSnoozeServiceFinished];

    [AppDelegate activeIndicatorStopAnimating];

    [self.navigationController popViewControllerAnimated:YES];

	//[self dismissModalViewControllerAnimated:YES];
}


-(void)snoozeToUpdate:(Snooze *)snoozeObj reason:(NSString *)reason exprirationDate:(NSString *)date expirationTime:(NSString *)time interval:(NSString *)interval intervalType:(NSString *)intervalType
{
    reasonValue = reason;
    
    dateValue = date;
    timeValue = time;
    
    intervalValue = interval;
    intervalTypeId = intervalType;

    snooze = snoozeObj;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"MM/dd/yyyy"];
    
    selectedExpiryDate = [df dateFromString:dateValue];

    [df setTimeStyle:NSDateFormatterShortStyle];

    selectedExpiryTime = [df dateFromString:timeValue];

    NSLog(@"reason = %@",reasonValue);
    NSLog(@"reason = %@",dateValue);
    NSLog(@"reason = %@",timeValue);
    NSLog(@"reason = %@",intervalValue);
    NSLog(@"reason = %@",intervalTypeId);


}
#pragma  UITableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat height;
//    
//    if ([tableView isEqual:snoozeReasonTableView])
//    {
//        height = 117;
//    }
//    else if ([tableView isEqual:snoozeReasonListTableView])
//    {
//        height = 120;
//    }
//    return height;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    
    if ([tableView isEqual:snoozeReasonTableView])
    {
        count = 1;
    }
    else if ([tableView isEqual:snoozeReasonListTableView])
    {
        count = [reasonListarray count];
    }
    else if ([tableView isEqual:snoozeDateTimeTableView])
    {
        count = 2;
    }
    else if ([tableView isEqual:snoozeIntervalTableView])
    {
        count = 2;
    }
    else if ([tableView isEqual:snoozeIntervalTableView])
    {
        count = [reasonListarray count];
    }
    else if ([tableView isEqual:snoozIntervalTypeListTableView])
    {
        count = [intervalTypeName count];
    }

    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell;
    
        UIFont *sampleFont = [UIFont boldSystemFontOfSize:17.0];
    
    if ([tableView isEqual:snoozeReasonTableView])
    {
        static NSString *CellIdentifier = @"ReasonCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            UILabel *txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,2, 100, 40)];
            txtLabel.numberOfLines = 1;//Dynamic
            txtLabel.backgroundColor = [UIColor clearColor];
            txtLabel.text = @"Reason   :";
            txtLabel.font = sampleFont;
            [cell.contentView addSubview:txtLabel];
            
            sampleFont = [UIFont fontWithName:@"System" size:13.0];
            
            UILabel *reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(105,2, 160, 40)];
            reasonLabel.lineBreakMode = UILineBreakModeWordWrap;
            reasonLabel.numberOfLines = 1;//Dynamic
            reasonLabel.backgroundColor = [UIColor clearColor];
            reasonLabel.tag = 2;
            reasonLabel.font = sampleFont;
            reasonLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:84.0/255.0 blue:155.0/255.0 alpha:1.0];
            [cell.contentView addSubview:reasonLabel];


        }
        
        UILabel *reasonLabel = (UILabel*)[cell.contentView viewWithTag:2];

        NSLog(@"reason = %@",reasonValue);

        if ([reasonValue isEqualToString:@""])
           reasonLabel.text  = @"Reason value";
        else
            reasonLabel.text = reasonValue;
        
        if ([selectedSnoozeIndexPath containsObject:indexPath])
            [cell setAccessoryType :UITableViewCellAccessoryCheckmark];
        else
            [cell setAccessoryType :UITableViewCellAccessoryDisclosureIndicator];

        returnCell = cell;
    }
    else if ([tableView isEqual:snoozeReasonListTableView])
    {
        static NSString *CellIdentifier = @"reasonListCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = [reasonListarray objectAtIndex:indexPath.row];
        
        cell.textLabel.font = sampleFont;
        
        if ([selectedSnoozeReasonIndexPath containsObject:indexPath])
            
            [cell setAccessoryType :UITableViewCellAccessoryCheckmark];
        
        else
            
            [cell setAccessoryType :UITableViewCellAccessoryDisclosureIndicator];

        returnCell = cell;
    }
    else if ([tableView isEqual:snoozeDateTimeTableView])
    {
        static NSString *CellIdentifier = @"DateAndTimeCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            if (indexPath.row == 0)
            {
                UILabel *txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,2, 100, 40)];
                txtLabel.numberOfLines = 1;//Dynamic
                txtLabel.backgroundColor = [UIColor clearColor];
                txtLabel.text = @"Date   :";
                txtLabel.font = sampleFont;
                [cell.contentView addSubview:txtLabel];
                
                sampleFont = [UIFont fontWithName:@"System" size:13.0];
                
                UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(105,2, 160, 40)];
                dateLabel.lineBreakMode = UILineBreakModeWordWrap;
                dateLabel.numberOfLines = 1;//Dynamic
                dateLabel.backgroundColor = [UIColor clearColor];
                dateLabel.tag = 1;
                dateLabel.font = sampleFont;
                dateLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:84.0/255.0 blue:155.0/255.0 alpha:1.0];
                [cell.contentView addSubview:dateLabel];
            }
            else if (indexPath.row == 1)
            {
                UILabel *txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,2, 100, 40)];
                txtLabel.numberOfLines = 1;//Dynamic
                txtLabel.backgroundColor = [UIColor clearColor];
                txtLabel.text = @"Time   :";
                txtLabel.font = sampleFont;
                [cell.contentView addSubview:txtLabel];
                
                sampleFont = [UIFont fontWithName:@"System" size:13.0];
                
                UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(105,2, 160, 40)];
                timeLabel.lineBreakMode = UILineBreakModeWordWrap;
                timeLabel.numberOfLines = 1;//Dynamic
                timeLabel.backgroundColor = [UIColor clearColor];
                timeLabel.tag = 2;
                timeLabel.font = sampleFont;
                timeLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:84.0/255.0 blue:155.0/255.0 alpha:1.0];
                [cell.contentView addSubview:timeLabel];
            }
        }
        
        UILabel *dateLabel = (UILabel*)[cell.contentView viewWithTag:1];
        
        if ([dateValue isEqualToString:@""])
            dateLabel.text  = @"Date value";
        else
            dateLabel.text = dateValue;
        
        UILabel *timeLabel = (UILabel*)[cell.contentView viewWithTag:2];
        
        if ([timeValue isEqualToString:@""])
            timeLabel.text  = @"Time value";
        else
            timeLabel.text = timeValue;


        if ([selectedSnoozeDateTimeIndexPath containsObject:indexPath])
            [cell setAccessoryType :UITableViewCellAccessoryCheckmark];
        else
            [cell setAccessoryType :UITableViewCellAccessoryDisclosureIndicator];
        
        returnCell = cell;
    }
    else if ([tableView isEqual:snoozeIntervalTableView])
    {
        static NSString *CellIdentifier = @"IntervalCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            if (indexPath.row == 0)
            {
                UILabel *txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,2, 120, 40)];
                txtLabel.numberOfLines = 1;//Dynamic
                txtLabel.backgroundColor = [UIColor clearColor];
                txtLabel.text = @"Interval :";
                txtLabel.font = sampleFont;
                [cell.contentView addSubview:txtLabel];
                
                sampleFont = [UIFont fontWithName:@"System" size:13.0];
                
                UILabel *intervalLabel = [[UILabel alloc] initWithFrame:CGRectMake(105,2, 160, 40)];
                intervalLabel.lineBreakMode = UILineBreakModeWordWrap;
                intervalLabel.numberOfLines = 1;//Dynamic
                intervalLabel.backgroundColor = [UIColor clearColor];
                intervalLabel.tag = 1;
                intervalLabel.font = sampleFont;
                intervalLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:84.0/255.0 blue:155.0/255.0 alpha:1.0];
                [cell.contentView addSubview:intervalLabel];
            }
            else if (indexPath.row == 1)
            {
                UILabel *txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,2, 120, 40)];
                txtLabel.numberOfLines = 1;//Dynamic
                txtLabel.backgroundColor = [UIColor clearColor];
                txtLabel.text = @"Interval Type :";
                txtLabel.font = sampleFont;
                [cell.contentView addSubview:txtLabel];
                
                sampleFont = [UIFont fontWithName:@"System" size:13.0];
                
                UILabel *intervalTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(135,2, 120, 40)];
                intervalTypeLabel.lineBreakMode = UILineBreakModeWordWrap;
                intervalTypeLabel.numberOfLines = 1;//Dynamic
                intervalTypeLabel.backgroundColor = [UIColor clearColor];
                intervalTypeLabel.tag = 2;
                intervalTypeLabel.font = sampleFont;
                intervalTypeLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:84.0/255.0 blue:155.0/255.0 alpha:1.0];
                [cell.contentView addSubview:intervalTypeLabel];
            }
        }
        
        UILabel *intervalLabel = (UILabel*)[cell.contentView viewWithTag:1];
        
        if ([intervalValue isEqualToString:@""])
            intervalLabel.text  = @"Interval value";
        else
            intervalLabel.text = intervalValue;
        
        UILabel *intervalTypeLabel = (UILabel*)[cell.contentView viewWithTag:2];
        
        if ([intervalTypeValue isEqualToString:@""])
            intervalTypeLabel.text  = @"Interval Type";
        else
            intervalTypeLabel.text = intervalTypeValue;
        
        
        if ([selectedSnoozeIntervalIndexPath containsObject:indexPath])
            [cell setAccessoryType :UITableViewCellAccessoryCheckmark];
        else
            [cell setAccessoryType :UITableViewCellAccessoryDisclosureIndicator];
        
        returnCell = cell;
    }
    else if ([tableView isEqual:snoozIntervalTypeListTableView])
    {
        static NSString *CellIdentifier = @"intervalTypeListCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = [intervalTypeName objectAtIndex:indexPath.row];
        
        cell.textLabel.font = sampleFont;
        
        if ([selectedIntervalTypeIndexPath containsObject:indexPath])
            
            [cell setAccessoryType :UITableViewCellAccessoryCheckmark];
        
        else
            
            [cell setAccessoryType :UITableViewCellAccessoryDisclosureIndicator];
        
        returnCell = cell;
    }

        return returnCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    [selectedSnoozeIndexPath removeAllObjects];
    [selectedSnoozeReasonIndexPath removeAllObjects];
    [selectedSnoozeDateTimeIndexPath removeAllObjects];

    [selectedSnoozeIntervalIndexPath removeAllObjects];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([tableView isEqual:snoozeReasonTableView])
    {
        [selectedSnoozeIndexPath addObject:indexPath];
        [snoozeReasonTableView reloadData];
        [self performSelector:@selector(showSnoozeReasonListView) withObject:nil afterDelay:0.1];
    }
    else if ([tableView isEqual:snoozeReasonListTableView])
    {
        [selectedSnoozeReasonIndexPath addObject:indexPath];
        reasonValue = [reasonListarray objectAtIndex:indexPath.row];
        [snoozeReasonListTableView reloadData];
        [self performSelector:@selector(closeSnoozeReasonListView:) withObject:nil afterDelay:0.1];
    }
    else if ([tableView isEqual:snoozeDateTimeTableView])
    {
        [selectedSnoozeDateTimeIndexPath addObject:indexPath];
        [snoozeDateTimeTableView reloadData];
        [self performSelector:@selector(selectSnoozeDateTime:) withObject:indexPath afterDelay:0.1];
    }
    else if ([tableView isEqual:snoozeIntervalTableView])
    {
        [selectedSnoozeIntervalIndexPath addObject:indexPath];
        [snoozeIntervalTableView reloadData];
        if (indexPath.row == 0)
        {
            [self performSelector:@selector(showIntervalPopUpView) withObject:nil afterDelay:0.1];
        }
        else if (indexPath.row == 1)
        {
            [self performSelector:@selector(showIntervalTypeListView) withObject:nil afterDelay:0.1];
        }
    }
    else if ([tableView isEqual:snoozIntervalTypeListTableView])
    {
        [selectedIntervalTypeIndexPath addObject:indexPath];
        [snoozIntervalTypeListTableView reloadData];
        [self performSelector:@selector(closeIntervalTypeListView:) withObject:indexPath afterDelay:0.1];
    }

}

-(void)selectSnoozeDateTime:(NSIndexPath *)indexPath
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];

    if (datePickerView != Nil)
        [datePickerView removeFromSuperview];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 157, 320, 260)];
    else
        datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 325, 540,250)];
    
    [datePickerView setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:39.0/255.0 blue:59.0/255.0 alpha:255.0/255.0]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        button.frame = CGRectMake(248, 0, 72, 37);
    else
        button.frame = CGRectMake(468, 0, 72, 37);
    
    [button setBackgroundImage:[UIImage imageNamed:@"keyboard-01-done-down.png"] forState:UIControlStateNormal];
    [button addTarget:self  action:@selector(done:) forControlEvents:UIControlEventTouchDown];
    [datePickerView addSubview:button];

    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        cancel.frame = CGRectMake(10, 0, 72, 37);
    else
        cancel.frame = CGRectMake(10, 0, 72, 37);
    
    [cancel setBackgroundImage:[UIImage imageNamed:@"keyboard-01-done-down.png"] forState:UIControlStateNormal];
    [cancel addTarget:self  action:@selector(cancel:) forControlEvents:UIControlEventTouchDown];
    [datePickerView addSubview:cancel];

    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 38, 320, 300)];
    else
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 38, 540, 300)];
    
    datePicker.hidden = NO;
    datePicker.date = [NSDate date];
    datePicker.alpha = 1.0;
    [datePicker addTarget:self action:@selector(LabelChange:) forControlEvents:UIControlEventValueChanged];
    [datePickerView addSubview:datePicker];
    
    [self.view addSubview:datePickerView];
    
    if(indexPath.row == 0)
    {
        datePicker.tag = 1;
        datePicker.datePickerMode = UIDatePickerModeDate;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            snoozeView.frame = CGRectMake(0, -50, snoozeView.frame.size.width, snoozeView.frame.size.height);
        
        
    }
    else if(indexPath.row == 1)
    {
        datePicker.datePickerMode = UIDatePickerModeTime;
        datePicker.tag = 2;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            snoozeView.frame = CGRectMake(0, -90, snoozeView.frame.size.width, snoozeView.frame.size.height);
    }

    [UIView commitAnimations];


}

- (void)LabelChange:(id)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"dd/MM/yyyy"];
    
    if ([sender tag] == 1)
    {
        dateValue = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
        selectedExpiryDate = datePicker.date;
    }
    else if ([sender tag] == 2)
    {
        [df setTimeStyle:NSDateFormatterShortStyle];
        timeValue = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
        selectedExpiryTime = datePicker.date;
    }
}


- (void)done:(id)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"dd/MM/yyyy"];
    
    if (datePicker.tag == 1)
    {
        dateValue = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
        selectedExpiryDate = datePicker.date;
    }
    else if (datePicker.tag == 2)
    {
        [df setTimeStyle:NSDateFormatterShortStyle];
        timeValue = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
        selectedExpiryTime = datePicker.date;
    }

    if (datePickerView != Nil)
    {
        [UIView animateWithDuration:0.1 animations:^{
            datePickerView.alpha = 1.0; datePickerView.alpha = 0.0;
        } completion:^(BOOL success) {
            if (success) {
                [datePickerView removeFromSuperview];
                [selectedSnoozeDateTimeIndexPath removeAllObjects];
                [snoozeDateTimeTableView reloadData];
            }
        }];
    }
    
    BOOL iPhone = NO;
	
#ifdef UI_USER_INTERFACE_IDIOM
	iPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
#endif
	if (iPhone)
	{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        snoozeView.frame = CGRectMake(0, 0, snoozeView.frame.size.width, snoozeView.frame.size.height);
        [UIView commitAnimations];
    }
    
}

- (void)cancel:(id)sender
{    
    if (datePickerView != Nil)
    {
        [UIView animateWithDuration:0.1 animations:^{
            datePickerView.alpha = 1.0; datePickerView.alpha = 0.0;
        } completion:^(BOOL success) {
            if (success) {
                [datePickerView removeFromSuperview];
                [selectedSnoozeDateTimeIndexPath removeAllObjects];
                [snoozeDateTimeTableView reloadData];
            }
        }];
    }
    
    BOOL iPhone = NO;
	
#ifdef UI_USER_INTERFACE_IDIOM
	iPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
#endif
	if (iPhone)
	{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        snoozeView.frame = CGRectMake(0, 0, snoozeView.frame.size.width, snoozeView.frame.size.height);
        [UIView commitAnimations];
    }
    
}


-(void)showSnoozeReasonListView
{
    snoozeReasonListBgView.hidden = NO;
    [UIView animateWithDuration:1.0 animations:^{
        snoozeReasonListBgView.alpha = 0.0; snoozeReasonListBgView.alpha = 1.0;
    } completion:^(BOOL success) {
        if (success) {
            [snoozeReasonTableView reloadData];
            [selectedSnoozeIndexPath removeAllObjects];
        }
    }];
}
-(IBAction)closeSnoozeReasonListView:(id)sender
{
    [UIView animateWithDuration:1.0 animations:^{
        snoozeReasonListBgView.alpha = 1.0; snoozeReasonListBgView.alpha = 0.0;
    } completion:^(BOOL success) {
        if (success) {
            snoozeReasonListBgView.hidden = YES;
            [snoozeReasonTableView reloadData];
            [snoozeReasonListTableView reloadData];
            [selectedSnoozeReasonIndexPath removeAllObjects];
        }
    }];
}

#pragma mark - snooze interval methods

-(void)showIntervalPopUpView
{
    snoozeIntervalTextField.text =  intervalValue;
    snoozeIntervalPopUpBGView.hidden = NO;
    [UIView animateWithDuration:1.0 animations:^{
        snoozeIntervalPopUpBGView.alpha = 0.0; snoozeIntervalPopUpBGView.alpha = 1.0;
    } completion:^(BOOL success) {
        if (success) {
            [snoozeIntervalTableView reloadData];
        }
    }];
}

-(IBAction)okBuutonWasPressed:(id)sender
{
    [snoozeIntervalTextField resignFirstResponder];
    [selectedSnoozeIntervalIndexPath removeAllObjects];

    if (![snoozeIntervalTextField.text isEqualToString:@""])
    {
        if ([ServicePleaseValidation validateNumeric:[snoozeIntervalTextField text]])
        {
            intervalValue = snoozeIntervalTextField.text;
            [snoozeIntervalTableView reloadData];
            [UIView animateWithDuration:1.0 animations:^{
                snoozeIntervalPopUpBGView.alpha = 1.0; snoozeIntervalPopUpBGView.alpha = 0.0;
            } completion:^(BOOL success) {
                if (success) {
                    snoozeIntervalPopUpBGView.hidden = YES;
                }
            }];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter valid interval."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok."
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter the snooze interval."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok."
                                              otherButtonTitles:nil];
        
        [alert show];
    }

}

-(IBAction)closeIntervalButtonWasPressed:(id)sender
{
    [snoozeIntervalTextField resignFirstResponder];
    [selectedSnoozeIntervalIndexPath removeAllObjects];
    
    [snoozeIntervalTableView reloadData];
    [UIView animateWithDuration:1.0 animations:^{
        snoozeIntervalPopUpBGView.alpha = 1.0; snoozeIntervalPopUpBGView.alpha = 0.0;
    } completion:^(BOOL success) {
        if (success) {
            snoozeIntervalPopUpBGView.hidden = YES;
        }
    }];
}

-(void)showIntervalTypeListView
{
    snoozeIntervalTypeBgView.hidden = NO;
    [UIView animateWithDuration:1.0 animations:^{
        snoozeIntervalTypeBgView.alpha = 0.0; snoozeIntervalTypeBgView.alpha = 1.0;
    } completion:^(BOOL success) {
        if (success) {
            [snoozeIntervalTableView reloadData];
            [selectedSnoozeIntervalIndexPath removeAllObjects];
        }
    }];
}
-(IBAction)closeButtonIntervalTypeListView:(id)sender
{
    [self closeIntervalTypeListView:nil];
}
-(void)closeIntervalTypeListView:(NSIndexPath *)indexPath
{
    [selectedIntervalTypeIndexPath removeAllObjects];
    if (indexPath != nil)
        intervalTypeValue = [intervalTypeName objectAtIndex:indexPath.row];
    [snoozeIntervalTableView reloadData];

    [UIView animateWithDuration:1.0 animations:^{
        snoozeIntervalTypeBgView.alpha = 1.0; snoozeIntervalTypeBgView.alpha = 0.0;
    } completion:^(BOOL success) {
        if (success) {
            snoozeIntervalTypeBgView.hidden = YES;
        }
    }];
}

- (void)getAllIntervalTypes
{
        intervalTypeName = [[NSMutableArray alloc] init];
        
        listOfIntervalTypes = [[NSMutableArray alloc] init];
    
        listOfIntervalTypes = [ServiceHelper getAllIntervalTypes];
        
        for (IntervalType *intervalType in listOfIntervalTypes)
        {
            [intervalTypeName addObject:intervalType.name];
        }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}


-(IBAction)saveButtonWasPressed:(id)sender
{
    if (![reasonValue isEqualToString:@""] && ![dateValue isEqualToString:@""] && ![timeValue isEqualToString:@""] && ![intervalValue isEqualToString:@""] && ![intervalTypeValue isEqualToString:@""])
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [AppDelegate activityIndicatorStartAnimating:self.view];
        else
            [AppDelegate activeIndicatorStartAnimating:self.view];

        [self performSelector:@selector(savingInProgress) withObject:nil afterDelay:0.1];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter the empty field first and then try to update it." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    [delegate UpdateSnoozeServiceFinished];
}

-(void)savingInProgress
{
    Snooze *updatedSnooze = [ServiceHelper updateSnooze:[self createSnoozeInstance]];
    
    NSLog(@"updatedSnooze = %@",updatedSnooze);
    
    [delegate UpdateSnoozeServiceFinished];
        
    [AppDelegate activeIndicatorStopAnimating];
        
    [self.navigationController popViewControllerAnimated:YES];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Snooze updated successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];

}
-(IBAction)cancelButtonWasPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [AppDelegate activeIndicatorStopAnimating];

    [delegate UpdateSnoozeServiceFinished];
}

- (Snooze *) createSnoozeInstance
{
   // NSLog(@"reasonListButton.titleLabel.text = %@",reasonListButton.titleLabel.text );
    
	Snooze *updatesnooze = nil;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMdd"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hhmmss"];
    
    NSDateFormatter *timeZone = [[NSDateFormatter alloc] init];
    [timeZone setDateFormat:@"ZZZ"];
            
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMddyyyyHHmmssZZZ"];
    
    NSDate *today = [NSDate date];
    
    NSString *reasonId;
    
    for (int i = 0; i < [listOfSnoozeReasons count]; i++)
    {
        SnoozeReason *snoozeReason = [listOfSnoozeReasons objectAtIndex:i];
        
        if([snoozeReason.name isEqualToString:reasonValue])
        {
            reasonId = snoozeReason.reasonId;
        }
    }
    
    NSString *currentIntervalTypeId;
    
    for (int i = 0; i < [listOfIntervalTypes count]; i++)
    {
        IntervalType *intervalType = [listOfIntervalTypes objectAtIndex:i];
        
        if ([intervalType.name isEqualToString:intervalTypeValue])
        {
            currentIntervalTypeId = intervalType.intervalTypeId;
        }
    }

    
	@try
	{
		if (updatesnooze == nil)
		{
			updatesnooze = [[Snooze alloc] init];
		}
        
        [updatesnooze setSnoozeId:snooze.snoozeId];
        [updatesnooze setTicketId:snooze.ticketId];
		[updatesnooze setReasonId:reasonId];
		[updatesnooze setIsCompleted:snooze.isCompleted];
        [updatesnooze setCompletedDate:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:today]]];
		[updatesnooze setIsDateInterval:snooze.isDateInterval];
        [updatesnooze setIsQuickShare:snooze.isQuickShare];
		[updatesnooze setStartDate:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:today]]];
        [updatesnooze setEndDate:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[self dateFormat:selectedExpiryDate anddate2:selectedExpiryTime andZone:selectedExpiryDate]]]];
        [updatesnooze setSnoozeInterval:[intervalValue intValue]];
        [updatesnooze setIntervalTypeId:currentIntervalTypeId];
		[updatesnooze setCreateDate:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:today]]];
		[updatesnooze setEditDate:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:today]]];
        
   	}
	@catch (NSException *exception)
	{
		NSLog(@"Error in createTicketInstance.  Error: %@", [exception description]);
	}
	@finally
	{
		return updatesnooze;
	}
}

-(NSDate *)dateFormat:(NSDate *)date1 anddate2:(NSDate *)date2 andZone:(NSDate *)zone
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date1];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    NSTimeZone *timezone = [components timeZone];
    
    components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit fromDate:date2];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:second];
    [comps setTimeZone:timezone];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *originalDate = [cal dateFromComponents:comps];
    
    return originalDate;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
