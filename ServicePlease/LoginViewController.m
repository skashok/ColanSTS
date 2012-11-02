//
//  LoginViewController.m
//  ServicePlease
//
//  Created by Ed Elliott on 2/12/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "LoginViewController.h"
#import "TechPerfomanceViewController.h"
#import "UserRolls.h"
#import "UpdateSnoozeViewController.h"

@implementation LoginViewController

@synthesize appDelegate = _appDelegate;

@synthesize userNameField = _userNameField;
@synthesize passwordField = _passwordField;
@synthesize loginButton = _loginButton;
@synthesize currentTextField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

#pragma mark - View lifecycle

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
  
    [self.userNameField setReturnKeyType:UIReturnKeyGo];
    [self.passwordField setReturnKeyType:UIReturnKeyGo];
    
	if (_appDelegate == nil)
	{
		_appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	}
	
//	if ([[[self userNameField] text] length] < 1 ||
//		[[[self passwordField] text] length] < 1) 
//	{
//		[[self loginButton] setEnabled:NO];  
//	}
//	else
//	{
//		[[self loginButton] setEnabled:YES];
//	}
	
	[[self userNameField] setDelegate:self];
	[[self passwordField] setDelegate:self];
        
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
	
	[[self view] addGestureRecognizer:tapRecognizer];
	[tapRecognizer setCancelsTouchesInView:NO];
	[tapRecognizer setNumberOfTapsRequired:2];
	[tapRecognizer setNumberOfTouchesRequired:1];
	[tapRecognizer setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handleNotification:)
                                                 name:@"currentRecoResultChanged"
                                               object:nil];      

}

- (void)handleNotification:(NSNotification *) notification
{
    if([[self appDelegate] currentTextField] != nil)
    {
		NSString		*theText = [[self appDelegate] currentRecoResult];
		UITextField		*theTextField = [[self appDelegate] currentTextField];
		
		// Store the speech text.
		[theTextField setText: theText];
		
		[theTextField resignFirstResponder];
        

    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}


// Voice Recognition - EKE - 04/26/2011
- (void) recordVoiceEntry: (id) sender
{   
    [[self appDelegate] recordButtonAction:sender languageType:0];
}

// End of Voice Recognition



-(void) handleTapGesture:(UIGestureRecognizer *) sender 
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
        [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [UIView commitAnimations];
    }

	
	[self recordVoiceEntry:[self currentTextField]];
	
	// [self performSelector:@selector(showMessage) withObject:nil afterDelay:0.0];
}


- (void) viewWillAppear:(BOOL)animated
{

	[[self userNameField] setText:@""];
	[[self passwordField] setText:@""];
	
	if ([[self appDelegate] selectedEntities] != nil) 
	{
		[[self appDelegate] setSelectedEntities:[[SelectedEntities alloc] init]];
	}

}

- (IBAction)loginButtonWasPressed:(id)sender
{

    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
   BOOL iPhone = NO;
	
#ifdef UI_USER_INTERFACE_IDIOM
	iPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
#endif
	if (iPhone)
	{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [UIView commitAnimations];
    }


	if ([[[self userNameField] text] length] < 1 ||
		[[[self passwordField] text] length] < 1) 
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Failed" 
															message:@"You must supply both a User Name and Password before pressing the Login Button." 
														   delegate:self 
												  cancelButtonTitle:@"Ok" 
												  otherButtonTitles:nil];  
		
		[alertView show];
		
		return;
	}
	
	if ([ServiceHelper validateUser:[[self userNameField] text] password:[[self passwordField] text]] != [NSNumber numberWithBool:YES]) 
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Failed" 
															message:@"Either your User Name or Password or both are incorrect.  Please try again." 
														   delegate:self 
												  cancelButtonTitle:@"Ok" 
												  otherButtonTitles:nil];  
		
		[alertView show];
		
		return;
	}
	
	// If we made it this far, get the User object and Organization of the User
	User *user = [ServiceHelper getUserByUserName:[[self userNameField] text]];
	
	Organization *organization = nil;
    
    NSString *userResponseRollid;
	
	if (user != nil) 
	{
		organization = [ServiceHelper getOrganizationByUserId:[user userId]];
        
        userResponseRollid=[ServiceHelper getUserRollid:[user userId]];
        
        if (userResponseRollid!=nil) 
        {
            user.userRollId=userResponseRollid; 
        }  
	}
	
	if (user != nil && organization != nil)
	{
		SelectedEntities *selectedEntities = [[SelectedEntities alloc] init];
		
		[selectedEntities setUser:user];
		[selectedEntities setOrganization:organization];
		
		[[self appDelegate] setSelectedEntities:selectedEntities];
	}
    
    NSLog(@"[[appDelegate selectedEntities] user] = %@",[[self appDelegate] selectedEntities]);

    NSString *userRollid=[[[[self appDelegate]selectedEntities]user]userRollId];
    
    NSMutableArray *responseRollArray=[ServiceHelper getRolls];
    
    UserRolls *userroles;
    
    if ([responseRollArray count]>0) 
    {
        for (int loop =0; loop<[responseRollArray count]; loop++) 
        {
            userroles=[responseRollArray objectAtIndex:loop];
            
            if ([userRollid isEqualToString:userroles.RoleID]) 
            {
                //NSLog(@"Roll Name :%@",userroles.Name);
            }
            
        }
    }
    
    
    
	
	// Let's clear the Category list if it exists from previous user
	if([[self appDelegate] categoryList] != nil &&
	   [[[self appDelegate] categoryList] count] > 1)
	{
		[[[self appDelegate] categoryList] removeAllObjects]; 
	}
	
	// Now that we have validated and got necessary bits, we can push to the Category Picker
   
    
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

	
	ApplicationListViewController *ApplicationListVC = (ApplicationListViewController*)[mainStoryboard
                                                                               instantiateViewControllerWithIdentifier: @"ApplicationListViewController"];
	
	[[self navigationController] pushViewController:ApplicationListVC animated:YES];
 
   


/*    BOOL iPad = NO;
	
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
    
	
	TicketMonitorViewController *CategoryVC = (TicketMonitorViewController*)[mainStoryboard
                                                                   instantiateViewControllerWithIdentifier: @"TicketMonitorViewController"];
	
	[[self navigationController] pushViewController:CategoryVC animated:YES];
    
//    UpdateSnoozeViewController *CategoryVC = (UpdateSnoozeViewController*)[mainStoryboard
//                                                                             instantiateViewControllerWithIdentifier: @"UpdateSnoozeViewController"];
//	
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:CategoryVC];
//    
//    navController.navigationBar.tintColor = [[UIColor alloc] initWithRed:4.0 / 255 green:4.0 / 255 blue:7.0 / 255 alpha:1.0];
//    
//    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//    
//    navController.modalPresentationStyle = UIModalPresentationFormSheet;
//    
//    [self presentModalViewController:navController animated:YES];

	//[[self navigationController] pushViewController:CategoryVC animated:YES];
*/

    
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
        [self.view setFrame:CGRectMake(0, -110, self.view.frame.size.width, self.view.frame.size.height)];
        [UIView commitAnimations];
    }
    
    [self setCurrentTextField:textField];

    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
    BOOL iPhone = NO;
	
#ifdef UI_USER_INTERFACE_IDIOM
	iPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
#endif
	if (iPhone) 
	{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [UIView commitAnimations];
    }
    [self loginButtonWasPressed:nil];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//	if ([[[self userNameField] text] length] < 1 ||
//		[[[self passwordField] text] length] < 1) 
//	{
//		[[self loginButton] setEnabled:NO];  
//	}
//	else
//	{
//		[[self loginButton] setEnabled:YES];
//	}
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
