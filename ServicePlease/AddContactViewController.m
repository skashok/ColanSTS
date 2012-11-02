//
//  AddContactViewController.m
//  ServicePlease
//
//  Created by Edward Elliott on 3/7/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "AddContactViewController.h"
#import "ServicePleaseValidation.h"

@implementation AddContactViewController

@synthesize appDelegate = _appDelegate;

@synthesize currentTextField = _currentTextField;

@synthesize contact = _contact;

@synthesize scrollView = _scrollView;

@synthesize contentView = _contentView;

@synthesize contactNameField = _contactNameField;
@synthesize firstNameField = _firstNameField;
@synthesize middleNameField = _middleNameField;
@synthesize lastNameField = _lastNameField;
@synthesize emailField = _emailField;
@synthesize phoneField = _phoneField;
@synthesize callBackNumField = _callBackNumField;
@synthesize Ext1Field = _Ext1Field;
@synthesize Ext2Field = _Ext2Field;

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
	[self recordVoiceEntry:[self currentTextField]];
	
	// [self performSelector:@selector(showMessage) withObject:nil afterDelay:0.0];
}

- (void)showMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"How are you?"
												   delegate:nil
										  cancelButtonTitle:@"I'm awesome."
										  otherButtonTitles:nil];
	
    [alert show];
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[_scrollView setContentOffset:CGPointMake(0,0)];
    [UIView commitAnimations];
	return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	// Keep track of what text field we were in.
	[self setCurrentTextField:textField];
	
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if([textField isEqual:_emailField])
    {
        [_scrollView setContentOffset:CGPointMake(0,60)];
    }
    if([textField isEqual:_phoneField])
    {
        [_scrollView setContentOffset:CGPointMake(0,100)];
    }
    if([textField isEqual:_callBackNumField])
    {
        [_scrollView setContentOffset:CGPointMake(0,140)];
    }
    if([textField isEqual:_Ext1Field])
    {
        [_scrollView setContentOffset:CGPointMake(0,100)];
    }
    if([textField isEqual:_Ext2Field])
    {
        [_scrollView setContentOffset:CGPointMake(0,140)];
    }
    
    [UIView commitAnimations];
	return YES;
}

- (IBAction)saveButtonWasPressed:(id)sender
{
    
    if (([ServicePleaseValidation validateNotEmpty:[[self contactNameField] text]]) &&
        ([ServicePleaseValidation validateNotEmpty:[[self firstNameField] text]]) &&
        ([ServicePleaseValidation validateNotEmpty:[[self lastNameField] text]]) &&
        ([ServicePleaseValidation validateNotEmpty:[[self phoneField] text]])    &&
        ([ServicePleaseValidation validateNotEmpty:[[self emailField] text]]) )
    {
        
        if (([ServicePleaseValidation validateAlphaSpaces:[[self contactNameField] text]]) &&
            ([ServicePleaseValidation validateAlphaSpaces:[[self firstNameField] text]]) &&
            ([ServicePleaseValidation validateAlphaSpaces:[[self lastNameField] text]]) &&
            ([ServicePleaseValidation validateNumeric:[[self phoneField] text]])    &&
            ([ServicePleaseValidation validateEmail:[[self emailField] text]]) )
        {
            [AppDelegate activeIndicatorStartAnimating:self.view];
            [self  performSelector:@selector(saveContact) withObject:nil afterDelay:0.2];
        }
        else
        {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Field Format"
                                                                message:@"Please check the fields are entered in appropriate format"
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            
            [alertView show];
        }
    }
    else
    {
        
        NSMutableString *errorMessage = [[NSMutableString alloc] initWithString:@"Please enter "];
        
        
        if ([self contactNameField].text.length  == 0 )
        {
            [errorMessage appendString:@"contactName"];
        }
        if ([[self firstNameField] text].length  == 0 )
        {
            if ([errorMessage length] < 15)
                [errorMessage appendString:@"firstName"];
            else
                [errorMessage appendString:@", firstName"];
        }
        if ([[self lastNameField] text].length  == 0 )
        {
            if ([errorMessage length] < 15)
                [errorMessage appendString:@"lastName"];
            else
                [errorMessage appendString:@", lastName"];
        }
        if ([[self phoneField] text].length  == 0 )
        {
            if ([errorMessage length] < 15)
                [errorMessage appendString:@"phone no"];
            else
                [errorMessage appendString:@", phone no"];
        }
        if ([[self emailField] text].length  == 0 )
        {
            if ([errorMessage length] < 15)
                [errorMessage appendString:@"email"];
            else
                [errorMessage appendString:@", email"];
        }
        [errorMessage appendString:@" field correctly."];
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:errorMessage
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
    }
}

-(void)saveContact
{
    Contact *contact = [self createContactInstance];
  
    if ([self saveContact:contact] == YES)
    {
        [self.appDelegate.dBHelper insertDailyRecapIntoDatabase:@"Created" onObject:@"Contact"  valueForObject:self.contactNameField.text];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Contact Saved"
                                                            message:@"The Contact entry was saved successfully"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Problem Saving Contact"
                                                            message:@"The Contact entry was not saved successfully"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    
    [[self navigationController] popViewControllerAnimated:YES];
    
    
}

- (IBAction)cancelButtonWasPressed:(id)sender
{
	[[self navigationController] popViewControllerAnimated:YES];
}

- (Contact *) createContactInstance
{
	Contact *contact = nil;
	
	@try
	{
		if (contact == nil)
		{
			contact = [[Contact alloc] init];
		}
		
		[contact setContactId:[NSString stringWithUUID]];
		[contact setLocationId:[[[[self appDelegate] selectedEntities] location] locationId]];
		[contact setOrganizationId:[[[[self appDelegate] selectedEntities] organization] organizationId]];
		[contact setContactName:[[self contactNameField] text]];
		[contact setFirstName:[[self firstNameField] text]];
		[contact setMiddleName:[[self middleNameField] text]];
		[contact setLastName:[[self lastNameField] text]];
		[contact setEmail:[[self emailField] text]];
		[contact setPhone:[[self phoneField] text]];
		[contact setCreateDate:[NSDate date]];
		[contact setEditDate:[NSDate date]];
        [contact setCallBackNum:[[self callBackNumField] text]];
        
	}
	@catch (NSException *exception)
	{
		//NSLog(@"Error in createContactInstance.  Error: %@", [exception description]);
	}
	@finally
	{
		return contact;
	}
}

- (BOOL) doesContactExist:(Contact *) contact
{
	BOOL contactExists = NO;
	
	@try
	{
		contactExists = [ServiceHelper doesContactExist:[contact contactName]
                                              firstName:[contact firstName]
                                             middleName:[contact middleName]
											   lastName:[contact lastName]];
	}
	@catch (NSException *exception)
	{
		//NSLog(@"Error in doesLocationInfoExist.  Error: %@", [exception description]);
		
		contactExists = NO;
	}
	@finally
	{
		return contactExists;
	}
}

- (BOOL) saveContact:(Contact *) contact
{
	BOOL wasSuccessful = NO;
	
  
	@try
	{
		if ([self doesContactExist:contact] == YES)
		{
           [AppDelegate activeIndicatorStopAnimating];
           
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Contact Exists"
																message:@"The Contact entry already exists"
															   delegate:self
													  cancelButtonTitle:@"Ok"
													  otherButtonTitles:nil];
			
			[alertView show];
			
			return NO;
		}
		
		Contact *newContact = [ServiceHelper addContact:contact];
        
        [AppDelegate activeIndicatorStopAnimating];
		
        if (newContact != nil)
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
		//NSLog(@"Error in saveContact.  Error: %@", [exception description]);
	}
	@finally
	{
		return wasSuccessful;
	}
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
