//
//  SnoozeListViewController.m
//  ServiceTech
//
//  Created by karthik keyan on 28/09/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>


#import "SnoozeListsViewController.h"
#import "ServiceHelper.h"
#import "UpdateSnoozeViewController.h"
#import "AppDelegate.h"


@interface SnoozeListsViewController ()

@end

@implementation SnoozeListsViewController

@synthesize soonzeListTableView;

@synthesize inPseudoEditMode;
@synthesize selectedImage;
@synthesize unselectedImage;
@synthesize selectedArray;
@synthesize editButton;

@synthesize loadingView;
@synthesize manipulationTableView;

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
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    soonzeList = [[NSMutableArray alloc] init];
    
    soonzeReasonList = [[NSMutableArray alloc] init];
    
    soonzeList = [ServiceHelper getAllSnooze];
        
    
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    
    self.navigationItem.leftBarButtonItem = doneButton;
    
    editButton=[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(doDelete)];
    
    self.navigationItem.rightBarButtonItem = editButton;
    
    
    if ([soonzeList count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No snooze to list." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag = 1;
        [alert show];
        
    }
    soonzeReasonList = [ServiceHelper getAllSnoozeReasons];
    
    NSLog(@"soonzeReasonList = %d",[soonzeReasonList count]);
    
    listOfManipulation = [[NSMutableArray alloc] initWithObjects:@"Delete",@"Update", nil];
    
    [self populateSelectedArray];
    
    soonzeListTableView.layer.cornerRadius = 10;
    soonzeListTableView.separatorColor = [UIColor colorWithRed:88.0/255.0 green:34.0/255.0 blue:160.0/255.0 alpha:1.0];
    soonzeListTableView.layer.backgroundColor = [UIColor colorWithRed:88.0/255.0 green:34.0/255.0 blue:160.0/255.0 alpha:1.0].CGColor;
    
    manipulationTableView.layer.cornerRadius = 10;
    manipulationTableView.separatorColor = [UIColor colorWithRed:88.0/255.0 green:34.0/255.0 blue:160.0/255.0 alpha:1.0];
    manipulationTableView.backgroundColor = [UIColor colorWithRed:88.0/255.0 green:34.0/255.0 blue:160.0/255.0 alpha:1.0];
    
    selectedSnoozeIndexPath = [[NSMutableArray alloc] init];
    selectedManipulationIndexPath = [[NSMutableArray alloc] init];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        soonzeListTableView.frame = CGRectMake(10, 13, 300, 380);
        manipulationTableView.hidden = YES;
    }
    else
    {
        soonzeListTableView.frame = CGRectMake(20, 20, 500, 540);
        manipulationTableView.hidden = YES;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == 1)
    {
        if (buttonIndex == 0)
        {
            [AppDelegate activeIndicatorStopAnimating];
            
            [self dismissModalViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag == 100)
    {
        if (buttonIndex == 1)
        {
            [AppDelegate activeIndicatorStartAnimating:self.view];
            
            [self performSelector:@selector(deleteSelectedRows) withObject:nil afterDelay:0.1];
        }
    }

}
-(IBAction)doDelete
{
    if ([editButton.title isEqualToString:@"Edit"])
    {
        editButton.title=@"Save";
        inPseudoEditMode=YES;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            soonzeListTableView.frame = CGRectMake(10, 13, 300, 355);
        else
            soonzeListTableView.frame = CGRectMake(20, 20, 500, 480);
        manipulationTableView.hidden = NO;
        [UIView commitAnimations];
        
        [soonzeListTableView reloadData];
    }
    else if ([editButton.title isEqualToString:@"Save"])
    {
        inPseudoEditMode = NO;
        [self populateSelectedArray];
        [selectedSnoozeIndexPath removeAllObjects];
        [selectedManipulationIndexPath removeAllObjects];
        [soonzeListTableView reloadData];
        [manipulationTableView reloadData];
        editButton.title=@"Edit";
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            soonzeListTableView.frame = CGRectMake(10, 13, 300, 380);
        else
            soonzeListTableView.frame = CGRectMake(20, 20, 500, 540);
        manipulationTableView.hidden = YES;
        [UIView commitAnimations];
        
    }
}

-(void)deleteConfirmation
{
    if ([selectedSnoozeIndexPath count] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure you want to delete the selected row." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alert.tag = 100;
        [alert show];
    }
}

-(void)deleteSelectedRows
{
    NSMutableArray *rowsToBeDeleted = [[NSMutableArray alloc] init];
    
    for (NSIndexPath *indexPath in selectedSnoozeIndexPath)
    {
        [rowsToBeDeleted addObject:[soonzeList objectAtIndex:indexPath.row]];
    }
    
    NSLog(@"rowsToBeDeleted = %@",rowsToBeDeleted);
    
    for (Snooze *snooze in rowsToBeDeleted)
    {
        NSString *snoozeResponse = [ServiceHelper deleteSnooze:snooze.snoozeId];
        
        NSLog(@"snoozeResponse = %@",snoozeResponse);
        
        [soonzeList removeObject:snooze];
    }
    
    [self UpdateSnoozeServiceFinished];
    
    if ([soonzeList count]==0)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    
    [AppDelegate activeIndicatorStopAnimating];
}

- (void)populateSelectedArray
{
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[soonzeList count]];
	for (int i=0; i < [soonzeList count]; i++)
    {
		[array addObject:[NSNumber numberWithBool:NO]];
    }
	selectedSnoozeIndexPath = array;
    NSLog(@"selectedSnoozeIndexPath==>%@",selectedSnoozeIndexPath);
	
}


- (void)viewDidUnload
{
    [self setSoonzeListTableView:nil];
    [super viewDidUnload];
    
    self.selectedImage = [UIImage imageNamed:@"selected.png"];
	self.unselectedImage = [UIImage imageNamed:@"unselected.png"];
    
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doneBtnPressed:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)doneClicked
{
    [AppDelegate activityIndicatorStopAnimating];
    
	[self dismissModalViewControllerAnimated:YES];
}

#pragma  UITableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    
    if ([tableView isEqual:soonzeListTableView])
    {
        height = 117;
    }
    else if ([tableView isEqual:manipulationTableView])
    {
        height = 120;
    }
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    
    if ([tableView isEqual:soonzeListTableView])
    {
        count = [soonzeList count];
    }
    else if ([tableView isEqual:manipulationTableView])
    {
        count = [listOfManipulation count];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellToReturn;
    
    if ([tableView isEqual:soonzeListTableView])
    {
        
        static NSString *CellIdentifier = @"SnoozeCustomCell";
        
        SnoozeCustomCell *snoozeCustomCell  = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        Snooze *snooze = [soonzeList objectAtIndex:indexPath.row];
        
        NSDate *exactDate = [self dateString:snooze.startDate];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        
        [snoozeCustomCell.date setText:[dateFormatter stringFromDate:exactDate]];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        [snoozeCustomCell.time setText:[timeFormatter stringFromDate:exactDate]];
        
        if ([appDelegate.techNameList objectAtIndex:indexPath.row] != nil)
        {
//            NSString *userRollid=[[[appDelegate selectedEntities]user]userRollId];
//
//            if ([ST_User_Role_ADMIN isEqualToString:userRollid] || [ST_User_Role_BACK_OFFICE isEqualToString:userRollid])
//            {
                [snoozeCustomCell.techName setText:[NSString stringWithFormat:@"Name:%@",[appDelegate.techNameList objectAtIndex:indexPath.row]]];
//            }
//            else if([[[[appDelegate selectedEntities]user] userName] isEqualToString:[appDelegate.techNameList objectAtIndex:indexPath.row]])
//            {
//                [snoozeCustomCell.techName setText:[NSString stringWithFormat:@"Name:%@",[appDelegate.techNameList objectAtIndex:indexPath.row]]];
//            }
//            else 
//            {
//                [snoozeCustomCell.techName setText:[NSString stringWithFormat:@"Name:Tech%d",indexPath.row]];
//            }

        }
        
        for (int i = 0; i < [soonzeReasonList count]; i++)
        {
            SnoozeReason *snoozeReason = [soonzeReasonList objectAtIndex:i];
            
            if ([[snooze.reasonId lowercaseString] isEqualToString:[snoozeReason.reasonId lowercaseString]])
            {
                [snoozeCustomCell.snoozeReason setText:[NSString stringWithFormat:@"Reason : %@",snoozeReason.name]];
            }
        }
        
        NSDate *expiryDate = [self dateString:snooze.endDate];
        
        [snoozeCustomCell.expiryDate setText:[NSString stringWithFormat:@"Expiry date : %@",[dateFormatter stringFromDate:expiryDate]]];
        
        snoozeCustomCell.De_SelectImage.hidden = YES;
        
        //	NSNumber *selected = [selectedSnoozeIndexPath objectAtIndex:[indexPath row]];
        //
        //        if (![selected boolValue])
        //    {
        //        [snoozeCustomCell.De_SelectImage setImage:[UIImage imageNamed:@"unselected.png"]];
        //    }
        //    else
        //    {
        //        [snoozeCustomCell.De_SelectImage setImage:[UIImage imageNamed:@"selected.png"]];
        //    }
        //
        //
        //	snoozeCustomCell.De_SelectImage.hidden=!inPseudoEditMode;
        
        snoozeCustomCell.layer.cornerRadius = 10;
        snoozeCustomCell.layer.borderWidth = 4;
        snoozeCustomCell.layer.borderColor = [UIColor colorWithRed:88.0/255.0 green:34.0/255.0 blue:160.0/255.0 alpha:1.0].CGColor;
        
        snoozeCustomCell.selectedBackgroundView.layer.cornerRadius = 10;
        snoozeCustomCell.selectedBackgroundView.layer.borderWidth = 4;
        
        if ([selectedSnoozeIndexPath containsObject:indexPath])
            [snoozeCustomCell setAccessoryType :UITableViewCellAccessoryCheckmark];
        else
            [snoozeCustomCell setAccessoryType :UITableViewCellAccessoryDisclosureIndicator];
        
        cellToReturn = snoozeCustomCell;
    }
    else if ([tableView isEqual:manipulationTableView])
    {
        UIFont *sampleFont = [UIFont fontWithName:@"System" size:14.0];
        
        static NSString *CellIdentifier = @"ListCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = [listOfManipulation objectAtIndex:indexPath.row];
        
        cell.textLabel.font = sampleFont;
        
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        tableView.transform=CGAffineTransformMakeRotation(-M_PI/2);
        
        CGAffineTransform transform1 = CGAffineTransformMakeRotation(M_PI/2);
        
        cell.textLabel.transform = transform1;
        
        cell.layer.cornerRadius = 10;
        cell.layer.borderWidth = 4;
        cell.layer.borderColor = [UIColor blackColor].CGColor;
        
        cell.selectedBackgroundView.layer.cornerRadius = 10;
        cell.selectedBackgroundView.layer.borderWidth = 4;
        
        cellToReturn = cell;
        
    }
    
    return cellToReturn;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:soonzeListTableView])
    {
        if (cell.isSelected == YES)
        {
            [cell setBackgroundColor:[UIColor colorWithRed:88.0/255.0 green:34.0/255.0 blue:160.0/255.0 alpha:1.0]];
            [cell setAccessibilityTraits:UIAccessibilityTraitSelected];
        }
        else
        {
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell setAccessibilityTraits:0];
        }
    }
    else if ([tableView isEqual:manipulationTableView])
    {
        if ([selectedManipulationIndexPath containsObject:indexPath])
        {
            [cell setBackgroundColor:[UIColor colorWithRed:88.0/255.0 green:34.0/255.0 blue:160.0/255.0 alpha:1.0]];
            cell.textLabel.textColor = [UIColor whiteColor];
            [cell setAccessibilityTraits:UIAccessibilityTraitSelected];
        }
        else
        {
            [cell setBackgroundColor:[UIColor whiteColor]];
            cell.textLabel.textColor = [UIColor blackColor];
            [cell setAccessibilityTraits:0];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:soonzeListTableView])
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [selectedManipulationIndexPath removeAllObjects];
        
        if (inPseudoEditMode)
        {
            if(![selectedSnoozeIndexPath containsObject:indexPath])
                [selectedSnoozeIndexPath addObject:indexPath];
            else
                [selectedSnoozeIndexPath removeObject:indexPath];
            [soonzeListTableView reloadData];
        }
    }
    else if ([tableView isEqual:manipulationTableView])
    {
        NSLog(@"indexPath.row = %d",indexPath.row);
        
        [selectedManipulationIndexPath removeAllObjects];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (inPseudoEditMode)
        {
            if(![selectedManipulationIndexPath containsObject:indexPath])
                [selectedManipulationIndexPath addObject:indexPath];
            else
                [selectedManipulationIndexPath removeObject:indexPath];
            
            if ((indexPath.row == 1) && ([selectedSnoozeIndexPath count] > 0))
            {
                if([selectedSnoozeIndexPath count] == 1)
                {
                    [manipulationTableView reloadData];
                    
                    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                        [AppDelegate activityIndicatorStartAnimating:self.view];
                    else
                        [AppDelegate activeIndicatorStartAnimating:self.view];
                    
                    [self performSelector:@selector(updateSnoozeViewController:) withObject:[selectedSnoozeIndexPath objectAtIndex:0] afterDelay:0.1];
                }
                else if (indexPath.row == 1)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select single row and then try to update it." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    [selectedManipulationIndexPath removeAllObjects];
                    
                }
                
            }
            else if (indexPath.row == 1)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select a row and then try to update it." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
                [selectedManipulationIndexPath removeAllObjects];
                
            }
            else if ((indexPath.row == 0) && ([selectedSnoozeIndexPath count] > 0))
            {
                [manipulationTableView reloadData];
                
                [self deleteConfirmation];
                
            }
            else if (indexPath.row ==0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select a row and then try to delete it." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
                [selectedManipulationIndexPath removeAllObjects];
            }
            [manipulationTableView reloadData];
        }
        // [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
}


-(void)updateSnoozeViewController:(NSIndexPath *)indexPath
{
    
    NSLog(@"soonzeList = %@",soonzeList);
    
    Snooze *snooze = [soonzeList objectAtIndex:indexPath.row];
    
    //  NSDate *exactDate = [self dateString:snooze.startDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    //  NSLog(@"date = %@",[dateFormatter stringFromDate:exactDate]);
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    //  NSLog(@"time = %@",[timeFormatter stringFromDate:exactDate]);
    
    NSString *snoozeReasonName;
    
    NSString *snoozeinterval;
    
    NSString *snoozeintervalType;
    
    for (int i = 0; i < [soonzeReasonList count]; i++)
    {
        SnoozeReason *snoozeReason = [soonzeReasonList objectAtIndex:i];
        
        if ([[snooze.reasonId lowercaseString] isEqualToString:[snoozeReason.reasonId lowercaseString]])
        {
            snoozeReasonName = [NSString stringWithFormat:@"%@",snoozeReason.name];
            
            snoozeintervalType = [NSString stringWithFormat:@"%@",snooze.intervalTypeId];
            
            snoozeinterval = [NSString stringWithFormat:@"%d",snooze.snoozeInterval];
            
            //            NSLog(@"snoozeinterval = %@",snoozeinterval);
            //
            //            NSLog(@"snoozeReasonName = %@",snoozeReasonName);
            //
            //            NSLog(@"snoozeintervalType = %@",snoozeintervalType);
        }
    }
    
    NSDate *expiryDate = [self dateString:snooze.endDate];
    
    // NSLog(@"Expiry date = %@",[NSString stringWithFormat:@"Expiry date : %@",[dateFormatter stringFromDate:expiryDate]]);
    
    NSDateFormatter *timeFormatter1 = [[NSDateFormatter alloc] init];
    [timeFormatter1 setTimeStyle:NSDateFormatterShortStyle];
    
    //NSLog(@"Expiry time = %@",[timeFormatter1 stringFromDate:expiryDate]);
    
    UIStoryboard *mainStoryboard = nil;
    
    BOOL iPad = NO;
	
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
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        updateSnoozeView = (UpdateSnoozeViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"UpdateSnoozeViewController"];
        
        [updateSnoozeView snoozeToUpdate:snooze reason:snoozeReasonName exprirationDate:[dateFormatter stringFromDate:expiryDate] expirationTime:[timeFormatter1 stringFromDate:expiryDate] interval:snoozeinterval intervalType:snoozeintervalType];
        
        [updateSnoozeView setDelegate:self];
        
        [[self navigationController] pushViewController:updateSnoozeView animated:YES];
        
        //        CGRect frame = updateSnoozeView.view.frame;
        //
        //        frame.origin.y = 0;
        //
        //        updateSnoozeView.view.frame = frame;
        //
        //        [self.view addSubview:updateSnoozeView.view];
        
        //        [UIView animateWithDuration:1.0 animations:^{
        //            updateSnoozeView.view.alpha = 0.0; updateSnoozeView.view.alpha = 1.0;
        //        } completion:^(BOOL success) {
        //            if (success) {
        [selectedSnoozeIndexPath removeAllObjects];
        [soonzeListTableView reloadData];
        //            }
        //        }];
        
    }
    else
    {
        
        updateSnoozeView = (UpdateSnoozeViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"UpdateSnoozeViewController"];
        
        [updateSnoozeView snoozeToUpdate:snooze reason:snoozeReasonName exprirationDate:[dateFormatter stringFromDate:expiryDate] expirationTime:[timeFormatter1 stringFromDate:expiryDate] interval:snoozeinterval intervalType:snoozeintervalType];
        
        [updateSnoozeView setDelegate:self];
        
        [[self navigationController] pushViewController:updateSnoozeView animated:YES];
        
        //        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:updateSnoozeView];
        //
        //        navController.navigationBar.tintColor = [[UIColor alloc] initWithRed:4.0 / 255 green:4.0 / 255 blue:7.0 / 255 alpha:1.0];
        //
        //        [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        //
        //        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        //
        //        [self presentModalViewController:navController animated:YES];
        
        [AppDelegate activeIndicatorStopAnimating];
        
    }
}


-(void)UpdateSnoozeServiceFinished
{
    soonzeList = [ServiceHelper getAllSnooze];
    
    soonzeReasonList = [ServiceHelper getAllSnoozeReasons];
    
    NSLog(@"soonzeReasonList = %d",[soonzeReasonList count]);
    
    [selectedSnoozeIndexPath removeAllObjects];
    [selectedManipulationIndexPath removeAllObjects];
    [soonzeListTableView reloadData];
    [manipulationTableView reloadData]; 
}
-(NSDate *)dateString:(NSString *)myString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMddyyyyHHmmss"];
    
    NSString *search1 = @"(";
    NSString *search2 = @")";
    
    NSString *startTrim = [myString substringFromIndex:NSMaxRange([myString rangeOfString:search1])];
    NSString *endTrim = [startTrim substringToIndex:NSMaxRange([startTrim rangeOfString:search2]) - 6];
    
    NSLog(@"endTrim = %@",endTrim);
    
    NSDate *myDate = [dateFormatter dateFromString:endTrim];
    
    NSLog(@"myDate = %@",myDate);
    
    return myDate;
}

@end
