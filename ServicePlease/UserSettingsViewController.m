//
//  UserSettingsViewController.m
//  ServiceTech
//
//  Created by Apple on 26/09/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "UserSettingsViewController.h"
#import "ServiceHelper.h"
#import "Category.h"
#import "AppDelegate.h"
#import "SettingsManipulationViewController.h"

@interface UserSettingsViewController ()

@end

@implementation UserSettingsViewController

@synthesize scrollView;

@synthesize assignTableView;

@synthesize snoozeTableView;

@synthesize categoryTableView;

@synthesize dailyRecapTableView;

@synthesize appTypeTableView;

@synthesize snoozeIntervalTableView;

@synthesize snoozeIntervalTypeTableView;

@synthesize snoozeIntervalPopUpBGView;

@synthesize snoozeIntervalPopUpView;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    //listOfItems = [[NSMutableArray alloc] initWithObjects:@"List of Tech's",@"Snooze Reasons List",@"Snooze Interval type",@"Categories List", nil];
    
    assignTableView.layer.cornerRadius = 10;
    assignTableView.layer.borderWidth = 1;
    assignTableView.layer.borderColor = [UIColor blackColor].CGColor;

    snoozeTableView.layer.cornerRadius = 10;
    snoozeTableView.layer.borderWidth = 1;
    snoozeTableView.layer.borderColor = [UIColor blackColor].CGColor;

    categoryTableView.layer.cornerRadius = 10;
    categoryTableView.layer.borderWidth = 1;
    categoryTableView.layer.borderColor = [UIColor blackColor].CGColor;
    
    dailyRecapTableView.layer.cornerRadius = 10;
    dailyRecapTableView.layer.borderWidth = 1;
    dailyRecapTableView.layer.borderColor = [UIColor blackColor].CGColor;

    appTypeTableView.layer.cornerRadius = 10;
    appTypeTableView.layer.borderWidth = 1;
    appTypeTableView.layer.borderColor = [UIColor blackColor].CGColor;

    snoozeIntervalTableView.layer.cornerRadius = 10;
    snoozeIntervalTableView.layer.borderWidth = 1;
    snoozeIntervalTableView.layer.borderColor = [UIColor blackColor].CGColor;

    snoozeIntervalPopUpView.layer.cornerRadius = 10;
    snoozeIntervalPopUpView.layer.borderWidth = 1;
    snoozeIntervalPopUpView.layer.borderColor = [UIColor blackColor].CGColor;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        scrollView.frame = CGRectMake(0, 0, 540, 620);
        scrollView.contentSize = CGSizeMake(540, 610);
    }
    else
    {
        scrollView.frame = CGRectMake(0, 0, 320, 460);
        scrollView.contentSize = CGSizeMake(320, 590);
    }
    
    [self getAllIntervalTypes];
    snoozeIntervalTypeBgView.hidden = YES;
    snoozeIntervalPopUpBGView.hidden = YES;
    intervalValue = @"";
    intervalTypeValue = @"";

}
-(void)viewWillAppear:(BOOL)animated
{    
    selectedAssignIndexPath = [[NSMutableArray alloc] init];
    selectedCategoryIndexPath = [[NSMutableArray alloc] init];
    selectedSnoozeIndexPath = [[NSMutableArray alloc] init];

    selectedContactIndexPath = [[NSMutableArray alloc] init];
    selectedTicketIndexPath = [[NSMutableArray alloc] init];

    selectedRecapIndexPath = [[NSMutableArray alloc] init];
    selectedAppTypeIndexPath = [[NSMutableArray alloc] init];
    selectedIntervalIndexPath = [[NSMutableArray alloc] init];

    selectedIntervalTypeIndexPath = [[NSMutableArray alloc] init];

    [assignTableView reloadData];
    [snoozeTableView reloadData];
    [categoryTableView reloadData];

    [dailyRecapTableView reloadData];
    [appTypeTableView reloadData];
    
    [snoozeIntervalTableView reloadData];
    [snoozeIntervalTypeTableView reloadData];

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

#pragma mark - snooze interval methods

//- (IBAction)actionSnoozeTimeListButtonWasPressed:(id)sender
//{
//    if (_dropwDownCustomTableView == nil)
//    {
//        if (![snoozeIntervalTextField.text isEqualToString:@""])
//        {
//            refButton = (UIButton *)sender;
//                        
//            NSMutableArray *intervalTypeName = [[NSMutableArray alloc] init];
//            
//            listOfIntervalTypes = [[NSMutableArray alloc] init];
//            
//            listOfIntervalTypes = [ServiceHelper getAllIntervalTypes];
//
//            for (IntervalType *intervalType in listOfIntervalTypes)
//            {
//                [intervalTypeName addObject:intervalType.name];
//            }
//            
//            NSLog(@"snoozeListButton = %@",snoozeListButton);
//            
//            _dropwDownCustomTableView = [[DropDownView alloc] initWithArrayData:intervalTypeName cellHeight:28 heightTableView:56 paddingTop:-6 paddingLeft:0 paddingRight:-2 refView:snoozeListButton animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2];
//            
//            _dropwDownCustomTableView.userSettingsSnoozeIntervalDelegate = self;
//            
//            [scrollView addSubview:_dropwDownCustomTableView.view];
//            
//            [_dropwDownCustomTableView openAnimation];
//        }
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter the time interval." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    }
//    else
//    {
//        [_dropwDownCustomTableView closeAnimation];
//        _dropwDownCustomTableView = nil;
//    }
//}
//
//
//-(void)userSettingsSnoozeIntervalSelected:(NSInteger)returnIndex
//{
//    [_dropwDownCustomTableView closeAnimation];
//    
//    _dropwDownCustomTableView = nil;
//    
//    IntervalType *intervalType = [listOfIntervalTypes objectAtIndex:returnIndex];
//    
//    NSString *buttonTitle = intervalType.name;
//    
//    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
//    
//    [appDelegate.snoozeIntervalValue setValue:snoozeIntervalTextField.text forKey:@"intervalTypeTime"];
//    
//    [appDelegate.snoozeIntervalValue setObject:intervalType forKey:@"intervalType"];
//    
//    //    NSLog(@"appDelegate.snoozeIntervalValue = %@",[appDelegate.snoozeIntervalValue objectForKey:@"intervalTypeTime"]);
//    //
//    //    NSLog(@"appDelegate.snoozeIntervalValue = %@",[appDelegate.snoozeIntervalValue objectForKey:@"intervalType"]);
//    
//    [snoozeListButton setTitle:buttonTitle forState:UIControlStateNormal];
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    int row = 0;
    
    if ([tableView isEqual:assignTableView])
    {
        row =  1;
    }
    else if ([tableView isEqual:snoozeTableView])
    {
        row = 2;
    }
    else if ([tableView isEqual:categoryTableView])
    {
        row = 1;
    }
    else if ([tableView isEqual:dailyRecapTableView])
    {
        row = 1;
    }
    else if ([tableView isEqual:appTypeTableView])
    {
        row = 1;
    }
    else if ([tableView isEqual:snoozeIntervalTableView])
    {
        row = 2;
    }
    else if ([tableView isEqual:snoozeIntervalTypeTableView])
    {
        row = [intervalTypeName count];
    }

    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableViewObj cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIFont *sampleFont = [UIFont fontWithName:@"System" size:14.0];
    
    if ([tableViewObj isEqual:assignTableView])
    {
        static NSString *CellIdentifier = @"Tech's";
        
        UITableViewCell *cell = [tableViewObj dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = @"List of Tech's";
        cell.textLabel.font = sampleFont;
        
        if ([selectedAssignIndexPath containsObject:indexPath])
            
            [cell setAccessoryType :UITableViewCellAccessoryCheckmark];
        
        else
            
            [cell setAccessoryType :UITableViewCellAccessoryDisclosureIndicator];

        return cell;
    }
    else if ([tableViewObj isEqual:snoozeTableView])
    {
        static NSString *CellIdentifier = @"Snooze";
        
        UITableViewCell *cell = [tableViewObj dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"Snooze Reasons List";
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"Snooze Interval type";
        }
        cell.textLabel.font = sampleFont;

        if ([selectedSnoozeIndexPath containsObject:indexPath])
            
            [cell setAccessoryType :UITableViewCellAccessoryCheckmark];
        
        else
            
            [cell setAccessoryType :UITableViewCellAccessoryDisclosureIndicator];

        return cell;
    }
    else if ([tableViewObj isEqual:categoryTableView])
    {
        static NSString *CellIdentifier = @"Cetagory";
        
        UITableViewCell *cell = [tableViewObj dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = @"Categories";
        
        cell.textLabel.font = sampleFont;

        if ([selectedCategoryIndexPath containsObject:indexPath])
            
            [cell setAccessoryType :UITableViewCellAccessoryCheckmark];
        
        else
            
            [cell setAccessoryType :UITableViewCellAccessoryDisclosureIndicator];

        return cell;
    }
    else if ([tableViewObj isEqual:dailyRecapTableView])
    {
        static NSString *CellIdentifier = @"Daily Recap";
        
        UITableViewCell *cell = [tableViewObj dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = @"Daily Recap";
        
        cell.textLabel.font = sampleFont;
        
        if ([selectedRecapIndexPath containsObject:indexPath])
            
            [cell setAccessoryType :UITableViewCellAccessoryCheckmark];
        
        else
            
            [cell setAccessoryType :UITableViewCellAccessoryDisclosureIndicator];
        
        return cell;
    }
    else if ([tableViewObj isEqual:appTypeTableView])
    {
        static NSString *CellIdentifier = @"App Type";
        
        UITableViewCell *cell = [tableViewObj dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = @"Application Type";
        
        cell.textLabel.font = sampleFont;
        
        if ([selectedAppTypeIndexPath containsObject:indexPath])
            
            [cell setAccessoryType :UITableViewCellAccessoryCheckmark];
        
        else
            
            [cell setAccessoryType :UITableViewCellAccessoryDisclosureIndicator];
        
        return cell;
    }
    else if ([tableViewObj isEqual:snoozeIntervalTableView])
    {
        static NSString *CellIdentifier = @"Snooze Interval";
        
        UITableViewCell *cell = [tableViewObj dequeueReusableCellWithIdentifier:CellIdentifier];
        
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
            intervalLabel.text  = @" ";
        else
            intervalLabel.text = intervalValue;
        
        UILabel *intervalTypeLabel = (UILabel*)[cell.contentView viewWithTag:2];

        if ([intervalTypeValue isEqualToString:@""])
            intervalTypeLabel.text  = @" ";
        else
            intervalTypeLabel.text = intervalTypeValue;
        
        cell.textLabel.font = sampleFont;
        
        if ([selectedIntervalIndexPath containsObject:indexPath])
            [cell setAccessoryType :UITableViewCellAccessoryCheckmark];
        else
            [cell setAccessoryType :UITableViewCellAccessoryDisclosureIndicator];
        
        return cell;
    }
    else if ([tableViewObj isEqual:snoozeIntervalTypeTableView])
    {
        static NSString *CellIdentifier = @"Snooze Interval Type";
        
        UITableViewCell *cell = [tableViewObj dequeueReusableCellWithIdentifier:CellIdentifier];
        
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
        
        return cell;
    }


    return nil;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableViewObj didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];

    [tableViewObj deselectRowAtIndexPath:indexPath animated:YES];

    [selectedAssignIndexPath removeAllObjects];
    [selectedSnoozeIndexPath removeAllObjects];
    [selectedCategoryIndexPath removeAllObjects];

    [selectedContactIndexPath removeAllObjects];
    [selectedTicketIndexPath removeAllObjects];

    [selectedRecapIndexPath removeAllObjects];
    [selectedAppTypeIndexPath removeAllObjects];
    [selectedIntervalIndexPath removeAllObjects];
    [selectedIntervalTypeIndexPath removeAllObjects];

    if ([tableViewObj isEqual:assignTableView])
    {
        appDelegate.selectedIndexInSettingsPage = 0;
        [selectedAssignIndexPath addObject:indexPath];
    }
    else if ([tableViewObj isEqual:snoozeTableView])
    {
        if (indexPath.row == 0)
        {
            appDelegate.selectedIndexInSettingsPage = 1;
        }
        else if (indexPath.row == 1)
        {
            appDelegate.selectedIndexInSettingsPage = 2;
        }
        [selectedSnoozeIndexPath addObject:indexPath];
    }
    else if ([tableViewObj isEqual:categoryTableView])
    {
        appDelegate.selectedIndexInSettingsPage = 3;
        [selectedCategoryIndexPath addObject:indexPath];
    }
    else if ([tableViewObj isEqual:dailyRecapTableView])
    {
        appDelegate.selectedIndexInSettingsPage = 5;
        [selectedRecapIndexPath addObject:indexPath];
    }
    else if ([tableViewObj isEqual:appTypeTableView])
    {
        appDelegate.selectedIndexInSettingsPage = 6;
        [selectedAppTypeIndexPath addObject:indexPath];
    }
    else if ([tableViewObj isEqual:snoozeIntervalTableView])
    {
        if (indexPath.row == 0)
        {
            appDelegate.selectedIndexInSettingsPage = 7;
        }
        else if (indexPath.row == 1)
        {
            appDelegate.selectedIndexInSettingsPage = 8;
        }
        [selectedIntervalIndexPath addObject:indexPath];
    }
    else if ([tableViewObj isEqual:snoozeIntervalTypeTableView])
    {
        appDelegate.selectedIndexInSettingsPage = 9;

        [selectedIntervalTypeIndexPath addObject:indexPath];
    }
    
    NSLog(@"selectedIndex= %d",appDelegate.selectedIndexInSettingsPage);
    
    [tableViewObj reloadData];

    if ([tableViewObj isEqual:snoozeIntervalTableView])
    {
        [snoozeIntervalTableView reloadData];
        if (indexPath.row == 0)
        {
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                [AppDelegate activityIndicatorStartAnimating:self.view];
            else
                [AppDelegate activeIndicatorStartAnimating:self.view];

            [self performSelector:@selector(showIntervalPopUpView) withObject:nil afterDelay:0.1];
        }
        else if (indexPath.row == 1)
        {
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                [AppDelegate activityIndicatorStartAnimating:self.view];
            else
                [AppDelegate activeIndicatorStartAnimating:self.view];

            [self performSelector:@selector(showIntervalTypeListView) withObject:nil afterDelay:0.1];
        }
    }
    else if ([tableViewObj isEqual:snoozeIntervalTypeTableView])
    {
        [selectedIntervalTypeIndexPath addObject:indexPath];
        [snoozeIntervalTypeTableView reloadData];
        [self performSelector:@selector(closeIntervalTypeListView:) withObject:indexPath afterDelay:0.1];
    }
    else
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [AppDelegate activityIndicatorStartAnimating:self.view];
        else
            [AppDelegate activeIndicatorStartAnimating:self.view];

        [self performSelector:@selector(switchView:) withObject:indexPath afterDelay:0.1];
    }
}

-(void)switchView:(NSIndexPath *)indexPath
{
    BOOL iPad = NO;
	
	UIStoryboard *mainStoryboard = nil;
	
#ifdef UI_USER_INTERFACE_IDIOM
	iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
	if (iPad)
	{
		// iPad specific code here
		mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle: nil];
	}
	else
	{
		// iPhone/iPod specific code here
		mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle: nil];
	}
    
	
	SettingsManipulationViewController *CategoryVC = (SettingsManipulationViewController*)[mainStoryboard
                                                                           instantiateViewControllerWithIdentifier:
                                                                           @"SettingsManipulationViewController"];
            
	[[self navigationController] pushViewController:CategoryVC animated:YES];
    
        [AppDelegate activeIndicatorStopAnimating];
}


-(void)doneClicked
{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark Snooze Interval PopUp

-(void)showIntervalTypeListView
{
        [AppDelegate activeIndicatorStopAnimating];

    snoozeIntervalTypeBgView.hidden = NO;
    [UIView animateWithDuration:1.0 animations:^{
        snoozeIntervalTypeBgView.alpha = 0.0; snoozeIntervalTypeBgView.alpha = 1.0;
    } completion:^(BOOL success) {
        if (success) {
            [snoozeIntervalTableView reloadData];
            [selectedIntervalIndexPath removeAllObjects];
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
    {
        intervalTypeValue = [intervalTypeName objectAtIndex:indexPath.row];
        
        IntervalType *intervalType = [listOfIntervalTypes objectAtIndex:indexPath.row];
        
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];

        [appDelegate.snoozeIntervalValue setValue:intervalValue forKey:@"intervalTypeTime"];
        
        [appDelegate.snoozeIntervalValue setObject:intervalType forKey:@"intervalType"];
        
        NSLog(@"appDelegate.snoozeIntervalValue = %@",[appDelegate.snoozeIntervalValue objectForKey:@"intervalTypeTime"]);
        
        NSLog(@"appDelegate.snoozeIntervalValue = %@",[appDelegate.snoozeIntervalValue objectForKey:@"intervalType"]);

    }
    [snoozeIntervalTableView reloadData];
    
    [UIView animateWithDuration:1.0 animations:^{
        snoozeIntervalTypeBgView.alpha = 1.0; snoozeIntervalTypeBgView.alpha = 0.0;
    } completion:^(BOOL success) {
        if (success) {
            snoozeIntervalTypeBgView.hidden = YES;
        }
    }];
}

#pragma mark snoozeIntervalPopUpBGView delegate

-(void)showIntervalPopUpView
{
        [AppDelegate activeIndicatorStopAnimating];
    snoozeIntervalTextField.text =  @"";
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
    [selectedIntervalIndexPath removeAllObjects];
    
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
    [selectedIntervalIndexPath removeAllObjects];
    
    [snoozeIntervalTableView reloadData];
    [UIView animateWithDuration:1.0 animations:^{
        snoozeIntervalPopUpBGView.alpha = 1.0; snoozeIntervalPopUpBGView.alpha = 0.0;
    } completion:^(BOOL success) {
        if (success) {
            snoozeIntervalPopUpBGView.hidden = YES;
        }
    }];
}

#pragma mark textFieldDelegete
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL iPhone = NO;
	
#ifdef UI_USER_INTERFACE_IDIOM
	iPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
#endif
	if (iPhone) 
	{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        scrollView.frame = CGRectMake(0, -180, scrollView.frame.size.width, scrollView.frame.size.height);
        [UIView commitAnimations];
    }    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    

    BOOL iPhone = NO;
	
#ifdef UI_USER_INTERFACE_IDIOM
	iPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
#endif
	if (iPhone) 
	{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        scrollView.frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        [UIView commitAnimations];
    }
    [textField resignFirstResponder];
    return NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
