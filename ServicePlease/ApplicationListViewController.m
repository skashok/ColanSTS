//
//  CategoryViewController.m
//  ServicePlease
//
//  Created by Ed Elliott on 2/8/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "ApplicationListViewController.h"

#import "TicketMonitorViewController.h"
#import "TechPerfomanceViewController.h"

@implementation ApplicationListViewController

@synthesize appDelegate = _appDelegate;
@synthesize categoryPickerView = _categoryPickerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self)
	{
        // Custom initialization
    }
	
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction) recordVoiceEntry: (id) sender
{
	
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    if (_appDelegate == nil)
	{
		_appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	}
	    
	if (_categoryPickerView == nil)
	{
		_categoryPickerView = [[UIPickerView alloc] init];
	}
	
    if([[self appDelegate] applicationList] != nil || [[self appDelegate]applicationList] != 0) {
        
        [[[self appDelegate] applicationList] removeAllObjects];
    }
	
    if([[self appDelegate] applicationList] == nil ||
	   [[[self appDelegate] applicationList] count] < 1)
	{
        [[self appDelegate] setApplicationList:[ServiceHelper getAllApplicationTypes]];
	}
	
	[[self categoryPickerView] setDelegate:self];
	[[self categoryPickerView] setDataSource:self];
	
	if([[[self appDelegate] applicationList] count] > 0)
	{
		[[self categoryPickerView] reloadAllComponents];
	}
    
    int count = [[[self appDelegate] applicationList] count];
    
    if (count >0)
        
        for (int i = 0; i < count;  i++) {
            
            ApplicationType *appType = [[[self appDelegate] applicationList] objectAtIndex:i];
            
            if ([appType.applicationName isEqualToString:@"Support"]) {
                
                [self.categoryPickerView selectRow:i inComponent:0 animated:YES];
                
            }
        }
    
    self.categoryPickerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(pickerTapped:)];
    [self.categoryPickerView addGestureRecognizer:tapGesture];
}

-(void)leftNavBtnPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pickerTapped:(UIGestureRecognizer *)gestureRecognizer
{
    
    CGPoint myP = [gestureRecognizer locationInView:self.categoryPickerView];
    
    CGFloat heightOfPickerRow = self.categoryPickerView.frame.size.height/5;
    
    if ((myP.y<3*heightOfPickerRow) && (myP.y>2*heightOfPickerRow))
    {
        [self.categoryPickerView selectRow:[self.categoryPickerView selectedRowInComponent:0] inComponent:0 animated:YES];
        [self pickerView:self.categoryPickerView didSelectRow:[self.categoryPickerView selectedRowInComponent:0] inComponent:0];
        
        [[[self appDelegate] selectedEntities] setApplicationType:[[[self appDelegate] applicationList] objectAtIndex:[self.categoryPickerView selectedRowInComponent:0]]];
        
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
        TechPerfomanceViewController *techPerfomanceViewController = (TechPerfomanceViewController*)[mainStoryboard
                                                                                                     instantiateViewControllerWithIdentifier: @"TechPerfomanceViewController"];
        
        [[self navigationController] pushViewController:techPerfomanceViewController animated:YES];
        
    }
    
}

-(IBAction)applicationTypeView:(id)sender
{
    NSString *userRollid=[[[[self appDelegate] selectedEntities]user]userRollId];

    if ([ST_User_Role_ADMIN isEqualToString:userRollid] || [ST_User_Role_BACK_OFFICE isEqualToString:userRollid])
    {
        [AppDelegate activeIndicatorStartAnimating:self.view];
        
        [self performSelector:@selector(switchingToApplicationType) withObject:nil afterDelay:0.1];
    }
    else
    {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"Privilege" message:@"Please check your login, For accessing Settings you should have Admin, Back office access." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertV show];
    }

}

-(void)switchingToApplicationType
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
        
        _appDelegate.selectedIndexInSettingsPage = 6;
        
        SettingsManipulationViewController *SettingsManipulationVC = (SettingsManipulationViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:
                                                                                                           @"SettingsManipulationViewController"];
    
        SettingsManipulationVC.delegate = self;
    
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:SettingsManipulationVC];
        
        navController.navigationBar.tintColor = [[UIColor alloc] initWithRed:4.0 / 255 green:4.0 / 255 blue:7.0 / 255 alpha:1.0];
        
        [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [self presentModalViewController:navController animated:YES];
        
        //[[self navigationController] pushViewController:CategoryVC animated:YES];
        
}

-(void)applicationTypeFinished
{
    [self viewWillAppear:NO];
}
/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

#pragma mark UIPickerView Delegate members
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	//NSLog(@"You picked the category: %@", [[[[self appDelegate] categoryList] objectAtIndex:row] valueForKey:@"categoryName"]);
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[[self appDelegate] applicationList] count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [[[[self appDelegate] applicationList] objectAtIndex:row] valueForKey:@"applicationName"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
