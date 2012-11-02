//
//  EditSolutionViewController.m
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 19/06/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "EditSolutionViewController.h"

#import "Solution.h"

#import "ServiceHelper.h"

#import "AppDelegate.h"

@interface EditSolutionViewController ()

@end

@implementation EditSolutionViewController

@synthesize currentSolution,currentTextView,scrollView,contentView,appDelegate,shortDescriptionTextView;

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
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    //    //NSLog(@"APP DELEAGTE: %@",[self appDelegate]);
    //    
    //    //NSLog(@"SELECTED ENTITIES: %@",[[self appDelegate] selectedEntities]);
    //    
    //    //NSLog(@"TICKET : %@",[[[self appDelegate] selectedEntities] ticket]);
    
    self.currentSolution = [[[self appDelegate] selectedEntities] solution];
    
    //    //NSLog(@"Edited Ticket Name: %@",self.currentTicket.ticketName);
    
    self.currentTextView.delegate = self;
    
    [self.shortDescriptionTextView setText:self.currentSolution.solutionShortDesc];
    
    [self.currentTextView setText:self.currentSolution.solutionText];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (IBAction)saveButtonWasPressed:(id)sender
{
	Solution *solution = [self createSolutionInstance];
	
	if ([self saveTheEditedSolution:solution] == YES) 
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Solution updated" 
															message:@"The Solution entry was updated successfully" 
														   delegate:self 
												  cancelButtonTitle:@"Ok" 
												  otherButtonTitles:nil];
		
		[alertView show];
	}
	else
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Problem Saving Solution" 
															message:@"The Solution entry was not updated successfully" 
														   delegate:self 
												  cancelButtonTitle:@"Ok" 
												  otherButtonTitles:nil];
		
		[alertView show];
		
		return;
	}
	
	[[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)deleteButtonWasPressed:(id)sender
{
	[[self navigationController] popViewControllerAnimated:YES];	
}

- (Solution *) createSolutionInstance
{
	Solution *solution = nil;
	
	@try 
	{
		if (solution == nil) 
		{
			solution = [[Solution alloc] init];
		}
		
		[solution setSolutionId:self.currentSolution.solutionId];		
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

- (BOOL) doesSolutiontExist:(Solution *) solution
{
	BOOL ticketExists = NO;
	
	@try 
	{
		// ticketExists = [ServiceHelper doesTicketExist:[ticket ticketName]]; 
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in doesTicketExist.  Error: %@", [exception description]);
		
		ticketExists = NO;
	}
	@finally 
	{
		return ticketExists;
	}
}

- (BOOL) saveTheEditedSolution:(Solution *) solution
{
	BOOL wasSuccessful = NO;
	
    Solution *newSolution = nil;
    
	@try 
	{
        newSolution  = [ServiceHelper updateSolution:solution];
		
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

- (BOOL) deleteTheTicket:(Solution *) solution
{
	BOOL wasSuccessful = NO;
    
	@try 
	{
        [ServiceHelper deleteSolution:solution.ticketId];
        
        wasSuccessful = YES;
		
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


- (void)textViewDidBeginEditing:(UITextView *)textView
{
	[[self appDelegate] setCurrentTextView:textView];
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

- (IBAction) pushVoiceSubviewForButton: (id) sender
{
    
}
- (void) recordVoiceEntry: (id) sender
{
    
}


@end
