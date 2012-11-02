//
//  EditTicketViewController.m
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 11/06/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "EditTicketViewController.h"
#import "ServiceHelper.h"
#import "AppDelegate.h"

@implementation EditTicketViewController

@synthesize appDelegate,currentTextView,scrollView,contentView,currentTicket;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
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
    
    if (iPad) 
    {
        UIImage *leftBtnImage=[UIImage imageNamed:@"left.png"];
        UIButton *leftnavBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        leftnavBtn.bounds=CGRectMake(0,0,26,26); 
        [leftnavBtn setImage:leftBtnImage forState:UIControlStateNormal]; 
        [leftnavBtn addTarget:self action:@selector(leftNavBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftnavBtn];
        self.navigationItem.leftBarButtonItem=leftBtnItem;
        
//        UIImage *rightBtnImage=[UIImage imageNamed:@"right.png"];
//        UIButton *rightNavBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        rightNavBtn.bounds=CGRectMake(0,0,26,26); 
//        [rightNavBtn setImage:rightBtnImage forState:UIControlStateNormal]; 
//        [rightNavBtn addTarget:self action:@selector(rightNavBtnPressed) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *rightBtnItem=[[UIBarButtonItem alloc]initWithCustomView:rightNavBtn];
//        self.navigationItem.rightBarButtonItem=rightBtnItem;
    }
    else 
    {
        UIImage *leftBtnImage=[UIImage imageNamed:@"left.png"];
        UIButton *leftnavBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        leftnavBtn.bounds=CGRectMake(0,0,50,25); 
        [leftnavBtn setImage:leftBtnImage forState:UIControlStateNormal]; 
        [leftnavBtn addTarget:self action:@selector(leftNavBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftnavBtn];
        self.navigationItem.leftBarButtonItem=leftBtnItem;
        
        
    }
}

-(void)leftNavBtnPressed
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    self.currentTicket = [[[self appDelegate] selectedEntities] ticket];
    
//    //NSLog(@"Edited Ticket Name: %@",self.currentTicket.ticketName);
    
    self.currentTextView.delegate = self;
    
    [self.currentTextView setText:self.currentTicket.ticketName];
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


- (IBAction)saveButtonWasPressed:(id)sender
{
	Ticket *ticket = [self createTicketInstance];
	
	if ([self saveTheEditedTicket:ticket] == YES) 
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ticket updated" 
															message:@"The Ticket entry was updated successfully" 
														   delegate:self 
												  cancelButtonTitle:@"Ok" 
												  otherButtonTitles:nil];
		
		[alertView show];
	}
	else
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Problem Saving Ticket" 
															message:@"The Ticket entry was not updated successfully" 
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
    [self deleteTheTicket:self.currentTicket];
    
	[[self navigationController] popViewControllerAnimated:YES];	
}

- (Ticket *) createTicketInstance
{
	Ticket *ticket = nil;
	
	@try 
	{
		if (ticket == nil) 
		{
			ticket = [[Ticket alloc] init];
		}
		
		[ticket setTicketId:self.currentTicket.ticketId];		
		[ticket setContactId:[[[[self appDelegate] selectedEntities] contact] contactId]];
		[ticket setCategoryId:[[[[self appDelegate] selectedEntities] category] categoryId]];
		[ticket setLocationId:[[[[self appDelegate] selectedEntities] location] locationId]];
		[ticket setOrganizationId:[[[[self appDelegate] selectedEntities] organization] organizationId]];
		[ticket setTicketName:[[self currentTextView] text]];
		[ticket setOpenClose:[NSNumber numberWithBool:NO]];
		[ticket setCloseDate:nil];
		[ticket setUserId:[[[[self appDelegate] selectedEntities] user] userId]];
		[ticket setCreateDate:[NSDate date]];
		[ticket setEditDate:[NSDate date]];
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in createTicketInstance.  Error: %@", [exception description]);
	}
	@finally 
	{    		
		return ticket;
	}	
}

- (BOOL) doesTicketExist:(Ticket *) ticket
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

- (BOOL) saveTheEditedTicket:(Ticket *) ticket
{
	BOOL wasSuccessful = NO;
	
    Ticket *newTicket= nil;
    
	@try 
	{
        newTicket  = [ServiceHelper updateTicket:ticket];
		
		if (newTicket != nil) 
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

- (BOOL) deleteTheTicket:(Ticket *) ticket
{
	BOOL wasSuccessful = NO;
    
	@try 
	{
       [ServiceHelper deleteTicket:ticket.ticketId];
        
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
