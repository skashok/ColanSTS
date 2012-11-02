//
//  AddSolutionViewController.m
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 15/06/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "AddSolutionViewController.h"
#import "Solution.h"
#import "AppDelegate.h"
#import "ServicePleaseValidation.h"
#import "ServiceHelper.h"

@implementation AddSolutionViewController

@synthesize appDelegate,contentView,scrollView,currentTextView,shortDescriptionTextView;

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
	// Do any additional setup after loading the view.
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
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

- (IBAction) pushVoiceSubviewForButton: (id) sender
{
	
}

// Voice Recognition - EKE - 04/26/2011
- (void) recordVoiceEntry: (id) sender
{   
    [[self appDelegate] recordButtonAction:sender languageType:0];
}

// End of Voice Recognition


- (IBAction)saveButtonWasPressed:(id)sender
{
    
    if (([ServicePleaseValidation validateNotEmpty:[[self currentTextView] text]]))
    {
        Solution *ticket = [self createSolutionInstance];
        
        if ([self saveSolution:ticket] == YES) 
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Solution Saved" 
                                                                message:@"The Solution entry was saved successfully" 
                                                               delegate:self 
                                                      cancelButtonTitle:@"Ok" 
                                                      otherButtonTitles:nil];
            
            [alertView show];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Problem Saving Solution" 
                                                                message:@"The Solution entry was not saved successfully" 
                                                               delegate:self 
                                                      cancelButtonTitle:@"Ok" 
                                                      otherButtonTitles:nil];
            
            [alertView show];
            
            return;
        }
        [[self navigationController] popViewControllerAnimated:YES];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SolutionInfo Empty" 
                                                            message:@"The SolutionInfoInfo should not be empty" 
                                                           delegate:self 
                                                  cancelButtonTitle:@"Ok" 
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)cancelButtonWasPressed:(id)sender
{
	[[self navigationController] popViewControllerAnimated:YES];	
}

- (Solution *) createSolutionInstance
{
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
	
    Solution *solution = nil;
	
	@try 
	{
		if (solution == nil) 
		{
			solution = [[Solution alloc] init];
		}

		[solution setTicketId:[[[[self appDelegate] selectedEntities] ticketMonitor] ticketTicketId]];		
		[solution setSolutionId:[NSString stringWithUUID]];
		[solution setSolutionShortDesc:[[self shortDescriptionTextView] text]];
		[solution setSolutionText:[[self currentTextView] text]];
		[solution setCreateDate:[NSDate date]];
		[solution setEditDate:[NSDate date]];
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in createTicketInstance.  Error: %@", [exception description]);
	}
	@finally 
	{    		
		return solution;
	}	
}

- (BOOL) doesSolutionExist:(Solution *) solution
{
	BOOL solutionExists = NO;
	
	@try 
	{
		// ticketExists = [ServiceHelper doesTicketExist:[ticket ticketName]]; 
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in doesTicketExist.  Error: %@", [exception description]);
		
		solutionExists = NO;
	}
	@finally 
	{
		return solutionExists;
	}
}

- (BOOL) saveSolution:(Solution *) solution
{
	BOOL wasSuccessful = NO;
	
	@try 
	{
		if ([self doesSolutionExist:solution] == YES) 
		{
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ticket Exists" 
																message:@"The Ticket entry already exists" 
															   delegate:self 
													  cancelButtonTitle:@"Ok" 
													  otherButtonTitles:nil];
			
			[alertView show];
			
			return NO;
		}
		
		Solution *newSolution = [ServiceHelper addSolution:solution];
		
		if (newSolution != nil) 
		{
			wasSuccessful = YES;
		}
		else 
		{
			wasSuccessful = NO;
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in saveTicket.  Error: %@", [exception description]);
	}
	@finally 
	{    		
		return wasSuccessful;
	}
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) 
	{
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
		
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
	
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


@end
