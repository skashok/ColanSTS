//
//  AddTicketViewController.m
//  ServicePlease
//
//  Created by Ed Elliott on 3/18/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "AddTicketViewController.h"
#import "ServicePleaseValidation.h"
#import "TicketEmailNotification.h"
#import "FilterPopupView.h"

@implementation AddTicketViewController

@synthesize appDelegate = _appDelegate;

@synthesize scrollView = _scrollView;

@synthesize contentView = _contentView;

@synthesize currentTextView = _currentTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
	if (self) 
	{
        // Custom initialization
    }
    
	return self;
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
		
	if (_appDelegate == nil) 
	{
		_appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	}
	
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
	
	[_scrollView setContentSize:[_contentView frame].size];
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



-(void) handleTapGesture:(UIGestureRecognizer *) sender 
{
	[self recordVoiceEntry:[self currentTextView]];
}

- (void)showMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"How are you?" 
												   delegate:nil 
										  cancelButtonTitle:@"I'm awesome." 
										  otherButtonTitles:nil];
	
    [alert show];
}

- (void)handleNotification:(NSNotification *) notification
{
    if([[self appDelegate] currentTextView] != nil)
    {
		NSString		*theText = [[self appDelegate] currentRecoResult];
		UITextView		*theTextView = [[self appDelegate] currentTextView];
		
		// Store the speech text.
		[theTextView setText: theText];
		
		[theTextView resignFirstResponder];
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

-(BOOL)generateAndSendEmailtoContact:(Ticket *)ticket
{
        
    NSMutableString *subjectText = [[NSMutableString alloc]init];
    
    NSMutableString *bodyText = [[NSMutableString alloc]init];
    
    if ([ticket.ticketNumber length] >0) {
        
        Contact *curContact = [ServiceHelper getContact:ticket.contactId];
        
        [subjectText setString:@"Subject: STS Support ticket # "];
        [subjectText appendString:ticket.ticketNumber];
        
        [bodyText setString:@"Dear "];
        [bodyText appendFormat:@"%@,",curContact.contactName];
        [bodyText appendFormat:@"Thank you for contacting our support department. We have opened a ticket # 000001 with the description as outlined below and will be in touch shortly to resolve it for you."];
        
        BOOL adminAlertSuccess = NO;
        
        @try 
        {
            /// Do code to send POST request.
            
            NSString *jsonString = [TicketEmailNotification JsonContentofEmailWithIndent:NO toAddress:curContact.email withBodyContent:bodyText SubjectContent:subjectText];
            
            
            adminAlertSuccess = [ServiceHelper sendTicketNotificationEmail:jsonString];
            
            //NSLog(@"DO CODE TO SEND THE POST REQUEST");
        }
        @catch (NSException *exception) 
        {
            //NSLog(@"Error in doesLocationInfoExist.  Error: %@", [exception description]);
            
            adminAlertSuccess = NO;
        }
        @finally 
        {
            return adminAlertSuccess;
        }

    }else {
        
        return NO;
    }
    

}


- (IBAction)saveButtonWasPressed:(id)sender
{
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSMutableArray *listOfCats = [ServiceHelper getAllCategories];
    
    [self.appDelegate setFilterListOfCategories:listOfCats];
    
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
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [self.appDelegate setCurrentTMFilter:CATEGORY_FILTER];
    
   
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        filterPopupView = (FilterPopupView*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FilterPopupView"];
        
        [filterPopupView setCatDelegate:self];
                        
        [self.appDelegate.curprobSoluVC.view addSubview:filterPopupView.view];

        //[self.view addSubview:filterPopupView.view];
        
       // [[self navigationController] pushViewController:filterPopupView animated:YES];
    }
    else 
    {
       
        
        if(![popoverController isPopoverVisible])
        {
            filterPopupView = (FilterPopupView*)[mainStoryboard 
                                                 instantiateViewControllerWithIdentifier:@"FilterPopupView"];
            
            [filterPopupView setCatDelegate:self];

            popoverController = [[UIPopoverController alloc] initWithContentViewController:filterPopupView] ;
                        
            [filterPopupView setRootPopUpViewController:popoverController];
            
            [popoverController setPopoverContentSize:CGSizeMake(300, 400)];
            
            CGRect frameSize = CGRectMake(140, 0, 500, 250);
            
            [popoverController presentPopoverFromRect:frameSize inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
        }else{
            
            [popoverController dismissPopoverAnimated:YES];
        }
    }

    
}

-(void)CatsSelected:(NSString *)catId
{
    //[self saveTicketwithCatId];
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSMutableArray *listOfTechs = [ServiceHelper getUsers];
    
    [self.appDelegate setFilterListOfTechs:listOfTechs];
    
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
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [self.appDelegate setCurrentTMFilter:TECH_FILTER];
    
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        filterPopupView = (FilterPopupView*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FilterPopupView"];
        
        [filterPopupView setCatDelegate:self];
        
        [self.appDelegate.curprobSoluVC.view addSubview:filterPopupView.view];

        //[self.view addSubview:filterPopupView.view];
        
        // [[self navigationController] pushViewController:filterPopupView animated:YES];
    }
    else 
    {
        
        
        if(![popoverController isPopoverVisible])
        {
            filterPopupView = (FilterPopupView*)[mainStoryboard 
                                                 instantiateViewControllerWithIdentifier:@"FilterPopupView"];
            
            [filterPopupView setCatDelegate:self];

            popoverController = [[UIPopoverController alloc] initWithContentViewController:filterPopupView] ;
                        
            [filterPopupView setRootPopUpViewController:popoverController];
            
            [popoverController setPopoverContentSize:CGSizeMake(300, 400)];
            
            CGRect frameSize = CGRectMake(140, 0, 500, 250);
            
            [popoverController presentPopoverFromRect:frameSize inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
        }else{
            
            [popoverController dismissPopoverAnimated:YES];
        }
    }
}

-(void)TechSelected:(NSString *)TechId
{
    [self saveTicketwithCatandTechId];
}


-(void)saveTicketwithCatandTechId
{
  //  if (([ServicePleaseValidation validateNotEmpty:[[self currentTextView] text]]))
    if (([ServicePleaseValidation validateNotEmpty:[self.appDelegate.curprobSoluVC.addProblemOrSolutionTextView text]]))

    {
        Ticket *ticket = [self createTicketInstance];
        
        ticket = [self saveTicket:ticket];
        
        if (ticket) 
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ticket Saved" 
                                                                message:@"The Ticket entry was saved successfully" 
                                                               delegate:self 
                                                      cancelButtonTitle:@"Ok" 
                                                      otherButtonTitles:nil];
            
            [alertView show];
            
            [self generateAndSendEmailtoContact:ticket];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Problem Saving Ticket" 
                                                                message:@"The Ticket entry was not saved successfully" 
                                                               delegate:self 
                                                      cancelButtonTitle:@"Ok" 
                                                      otherButtonTitles:nil];
            
            [alertView show];
            
            return;
        }
        [[self navigationController] popViewControllerAnimated:YES];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"TicketInfo Empty" 
                                                            message:@"The TicketInfo should not be empty" 
                                                           delegate:self 
                                                  cancelButtonTitle:@"Ok" 
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    self.appDelegate.curprobSoluVC.addProblemOrSolutionTextView.text = @"";

}

- (IBAction)cancelButtonWasPressed:(id)sender
{
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
        
        //NSLog(@"CONTACT FROM APP DELEGATE :%@",[[[[self appDelegate] selectedEntities] contact] contactId]);
        
        //NSLog(@"CONTACT FROM APP DELEGATE :%@",[[[[self appDelegate] selectedEntities] location] locationId]);
		
		[ticket setTicketId:[NSString stringWithUUID]];		
		[ticket setContactId:[[[[self appDelegate] selectedEntities] contact] contactId]];
		[ticket setCategoryId:[[[[self appDelegate] selectedEntities] category] categoryId]];
		[ticket setLocationId:[[[[self appDelegate] selectedEntities] location] locationId]];
		[ticket setOrganizationId:[[[[self appDelegate] selectedEntities] organization] organizationId]];
		[ticket setTicketName:[self.appDelegate.curprobSoluVC.addProblemOrSolutionTextView text]];
        [ticket setTicketStatus:@"L"];
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

- (Ticket *) saveTicket:(Ticket *) ticket
{
	BOOL wasSuccessful = NO;
    
    Ticket *newTicket;
	
	@try 
	{
		if ([self doesTicketExist:ticket] == YES) 
		{
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ticket Exists" 
																message:@"The Ticket entry already exists" 
															   delegate:self 
													  cancelButtonTitle:@"Ok" 
													  otherButtonTitles:nil];
			
			[alertView show];
			
			return nil;
		}
		
		newTicket = [ServiceHelper addTicket:ticket];
		
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
		return newTicket;
	}
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
