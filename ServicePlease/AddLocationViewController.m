//
//  AddLocationViewController.m
//  ServicePlease
//
//  Created by Edward Elliott on 3/7/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "AddLocationViewController.h"
#import "ServicePleaseValidation.h"

@implementation AddLocationViewController

@synthesize appDelegate = _appDelegate;

@synthesize currentTextField = _currentTextField;

@synthesize location = _location;
@synthesize locationInfo = _locationInfo;

@synthesize scrollView = _scrollView;

@synthesize contentView = _contentView;

@synthesize locationNameField = _locationNameField;
@synthesize address1Field = _address1Field;
@synthesize address2Field = _address2Field;
@synthesize cityField = _cityField;
@synthesize stateField = _stateField;
@synthesize postalCodeField = _postalCodeField;
@synthesize countryField = _countryField;
@synthesize businessPhoneField = _businessPhoneField;
@synthesize faxField = _faxField;
@synthesize mobilePhoneField = _mobilePhoneField;
@synthesize homePhoneField = _homePhoneField;
@synthesize email1Field = _email1Field;
@synthesize email2Field = _email2Field;
@synthesize websiteField = _websiteField;
@synthesize emailNotification = _emailNotification;
//@synthesize locationAddedAlert;


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

// Call to the Voice Recognition Engine
// EKE - 05/05/2011
//    if(sender != nil && [sender class] == [ArrivalButton class])
//    {
//        if(((ArrivalButton *)sender).buttonTextField != nil)
//        {
//            UITextField *currentTextField = ((ArrivalButton *)sender).buttonTextField;
//
//            [self recordVoiceEntry:currentTextField];
//			bDropIt = YES;
//        }
//    }

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



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
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
    
    
    // add observer for the respective notifications (depending on the os version)
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardDidShow:)
                                                         name:UIKeyboardDidShowNotification
                                                       object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillShow:)
                                                         name:UIKeyboardWillShowNotification
                                                       object:nil];
        }
    }
}

-(void)leftNavBtnPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleNotification:(NSNotification *) notification
{
    if([[self appDelegate] currentTextField] != nil)
    {
		NSString		*theText = [[self appDelegate] currentRecoResult];
		UITextField		*theTextField = [[self appDelegate] currentTextField];
        UITextView		*theTextView = [[self appDelegate] currentTextView];
        
		
		// Store the speech text.
		[theTextField setText: theText];
        
        [theTextView setText: theText];
		
		[theTextField resignFirstResponder];
        
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
	
	return YES;
}

- (IBAction)saveButtonWasPressed:(id)sender
{
    /// VALIDATING THE FIELDS /////
    
    if (([ServicePleaseValidation validateNotEmpty:[[self locationNameField] text]]) &&
        ([ServicePleaseValidation validateNotEmpty:[[self cityField] text]])     &&
        ([ServicePleaseValidation validateNotEmpty:[[self stateField] text]])    &&
        ([ServicePleaseValidation validateNotEmpty:[[self countryField] text]]) )
    {
        if (
            ([ServicePleaseValidation validateAlphaSpaces:[[self locationNameField] text]])     &&
            ([ServicePleaseValidation validateAlphaSpaces:[[self cityField] text]])     &&
            ([ServicePleaseValidation validateAlphaSpaces:[[self stateField] text]])    &&
            ([ServicePleaseValidation validateAlphaSpaces:[[self countryField] text]]))
        {
            [self performSelectorInBackground:@selector(loadingIndicator) withObject:nil];
            LocationInfo *locationInfo = [self createLocationInfoInstance];
            
            Location *location = [self createLocationInstance:[locationInfo locationInfoId]];
            
            if ([self doesLocationInfoExist:locationInfo] == YES)
            {
                [activityIndicator stopAnimating];
                [loadingView removeFromSuperview];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"LocationInfo Exists"
                                                                    message:@"The LocationInfo entry already exists"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                
                [alertView show];
            }else if ([self saveLocationInfo:locationInfo] == YES)
            {
                if ([self doesLocationExist:location] == YES)
                {
                    [activityIndicator stopAnimating];
                    [loadingView removeFromSuperview];
                   
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Exists"
                                                                        message:@"The Location entry already exists"
                                                                       delegate:self
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    
                    [alertView show];
                    
                }else if ([self saveLocation:location] == NO)
                {
                    [activityIndicator stopAnimating];
                    [loadingView removeFromSuperview];
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Problem Saving Location"
                                                                        message:@"The Location entry was not saved successfully"
                                                                       delegate:self
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    
                    [alertView show];
                    
                    return;
                }
                else
                {
                    [activityIndicator stopAnimating];
                    [loadingView removeFromSuperview];
                    [self.appDelegate.dBHelper insertDailyRecapIntoDatabase:@"Created" onObject:@"Location"  valueForObject:self.locationNameField.text];
                    [self sendEmailNotificationToAdmin:location emailLocatonInfoDetail:locationInfo];
                    UIAlertView *locationAddedAlert = [[UIAlertView alloc] initWithTitle:@"Location Saved"
                                                                                 message:@"The Location entry was saved successfully"
                                                                                delegate:self
                                                                       cancelButtonTitle:@"Ok"
                                                                       otherButtonTitles:nil];
                    [locationAddedAlert show];
                    
                    [[self navigationController] popViewControllerAnimated:YES];
                }
            }
            else
            {
                [activityIndicator stopAnimating];
                [loadingView removeFromSuperview];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Problem Saving LocationInfo"
                                                                    message:@"The LocationInfo entry was not saved successfully"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                
                [alertView show];
                
                return;
            }
        }else {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"LocationInfo Format"
                                                                message:@"Please check the fields are entered in appropriate format"
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            
            [alertView show];
            
        }
    }
    else {
        
        
        NSMutableString *errorMessage = [[NSMutableString alloc] initWithString:@"Please enter "];
        
        if ([self locationNameField].text.length  == 0 )
        {
            [errorMessage appendString:@"Location Name"];
        }
        if ([[self cityField] text].length  == 0 )
        {
            if ([errorMessage length] < 15)
                [errorMessage appendString:@"City"];
            else
                [errorMessage appendString:@", City"];
        }
        if ([[self stateField] text].length  == 0 )
        {
            if ([errorMessage length] < 15)
                [errorMessage appendString:@"State"];
            else
                [errorMessage appendString:@", State"];
        }
        if ([[self countryField] text].length  == 0 )
        {
            if ([errorMessage length] < 15)
                [errorMessage appendString:@"Country"];
            else
                [errorMessage appendString:@", Country"];
        }
        [errorMessage appendString:@" field correctly."];
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Validation"
                                                            message:errorMessage
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        
        [alertView show];
    }
}

-(void)loadingIndicator
{
    
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 90)];
    loadingView.backgroundColor = [UIColor blackColor];
    loadingView.layer.cornerRadius = 10;
    loadingView.layer.borderWidth = 1;
    loadingView.layer.borderColor = [UIColor whiteColor].CGColor;
    loadingView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.view addSubview:loadingView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 120, 20)];
    textLabel.text =@"Loading..";
    textLabel.textAlignment = UITextAlignmentCenter;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.backgroundColor = [UIColor clearColor];
    [loadingView addSubview:textLabel];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.frame = CGRectMake(0, 0,40, 40);;
    [loadingView addSubview:activityIndicator];
    activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, 70/2);
    [activityIndicator startAnimating];
    
}

- (BOOL) sendEmailNotificationToAdmin:(Location *) location emailLocatonInfoDetail:(LocationInfo *)locationinfo
{
    BOOL adminAlertSuccess = NO;
	
	@try
	{
        /// Do code to send POST request.
        
        adminAlertSuccess = [ServiceHelper sendNotificationEmail:location emaillocationInfoDetail:locationinfo];
        
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
}

- (Location*) createLocationInstance:(NSString *)locationInfoId
{
	Location *location = nil;
	
	@try
	{
		if (location == nil)
		{
			location = [[Location alloc] init];
		}
        
		[location setLocationId:[NSString stringWithUUID]];
		[location setOrganizationId:[[[[self appDelegate] selectedEntities] organization] organizationId]];
		[location setLocationName:[[self locationNameField] text]];
		[location setLocationInfoId:locationInfoId];
		[location setCreateDate:[NSDate date]];
		[location setEditDate:[NSDate date]];
	}
	@catch (NSException *exception)
	{
		//NSLog(@"Error in createLocationInstance.  Error: %@", [exception description]);
	}
	@finally
	{
		return location;
	}
}

- (LocationInfo *) createLocationInfoInstance
{
	LocationInfo *locationInfo = nil;
	
	@try
	{
		if (locationInfo == nil)
		{
			locationInfo = [[LocationInfo alloc] init];
		}
        
        [locationInfo setLocationInfoId:[NSString stringWithUUID]];
        [locationInfo setAddress1:[[self address1Field] text]];
        [locationInfo setAddress2:[[self address2Field] text]];
        [locationInfo setCity:[[self cityField] text]];
        [locationInfo setState:[[self stateField] text]];
        [locationInfo setPostalCode:[[self postalCodeField] text]];
        [locationInfo setCountry:[[self countryField] text]];
        [locationInfo setBusinessPhone:[[self businessPhoneField] text]];
        [locationInfo setFax:[[self faxField] text]];
        [locationInfo setMobilePhone:[[self mobilePhoneField] text]];
        [locationInfo setHomePhone:[[self homePhoneField] text]];
        [locationInfo setEmail1:[[self email1Field] text]];
        [locationInfo setEmail2:[[self email2Field] text]];
        [locationInfo setWebsite:[[self websiteField] text]];
        [locationInfo setCreateDate:[NSDate date]];
        [locationInfo setEditDate:[NSDate date]];
        
	}
	@catch (NSException *exception)
	{
		//NSLog(@"Error in createLocationInfoInstance.  Error: %@", [exception description]);
	}
	@finally
	{
		return locationInfo;
	}
}

- (BOOL) doesLocationInfoExist:(LocationInfo *) locationInfo
{
	BOOL locationInfoExists = NO;
	
	@try
	{
		locationInfoExists = [ServiceHelper doesLocationInfoExist:[locationInfo address1]
															 city:[locationInfo city]
															state:[locationInfo state]];
	}
	@catch (NSException *exception)
	{
		//NSLog(@"Error in doesLocationInfoExist.  Error: %@", [exception description]);
		
		locationInfoExists = NO;
	}
	@finally
	{
		return locationInfoExists;
	}
}

- (BOOL) doesLocationExist:(Location *) location
{
	BOOL locationExists = NO;
	
	@try
	{
		locationExists = [ServiceHelper doesLocationExist:[location locationName]];
	}
	@catch (NSException *exception)
	{
		//NSLog(@"Error in doesLocationExist.  Error: %@", [exception description]);
		
		locationExists = NO;
	}
	@finally
	{
		return locationExists;
	}
}

- (BOOL) saveLocationInfo:(LocationInfo *) locationInfo
{
	BOOL wasSuccessful = NO;
	
	@try
	{
		LocationInfo *newLocationInfo = [ServiceHelper addLocationInfo:locationInfo];
		
		if (newLocationInfo != nil)
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
		//NSLog(@"Error in saveLocationInfo.  Error: %@", [exception description]);
	}
	@finally
	{
		return wasSuccessful;
	}
}

- (BOOL) saveLocation:(Location *) location
{
	BOOL wasSuccessful = NO;
	
	@try
	{
		Location *newLocation = [ServiceHelper addLocation:location];
		
		if (newLocation != nil)
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
		//NSLog(@"Error in saveLocation.  Error: %@", [exception description]);
	}
	@finally
	{
		return wasSuccessful;
	}
}

- (IBAction)cancelButtonWasPressed:(id)sender
{
	[[self navigationController] popViewControllerAnimated:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    textField.keyboardType = UIKeyboardTypeDefault;
    
    if([textField isEqual:_cityField])
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)doneButton.hidden = YES;
        [_scrollView setContentOffset:CGPointMake(0,20)];
    }
    if([textField isEqual:_stateField])
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)doneButton.hidden = YES;
        [_scrollView setContentOffset:CGPointMake(0,60)];
    }
    if([textField isEqual:_countryField])
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)doneButton.hidden = YES;
        [_scrollView setContentOffset:CGPointMake(0,140)];
    }
    if([textField isEqual:_postalCodeField])
    {
        _postalCodeField.keyboardType = UIKeyboardTypeNumberPad;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            doneButton.hidden = YES;
            [self addButtonToKeyboard];
        }
        [_scrollView setContentOffset:CGPointMake(0,100)];
    }
    if([textField isEqual:_businessPhoneField])
    {
        _businessPhoneField.keyboardType = UIKeyboardTypeNumberPad;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            doneButton.hidden = YES;
            [self addButtonToKeyboard];
        }
        [_scrollView setContentOffset:CGPointMake(0,180)];
    }
    if([textField isEqual:_faxField])
    {
        _faxField.keyboardType = UIKeyboardTypeNumberPad;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            doneButton.hidden = YES;
            [self addButtonToKeyboard];
        }
        [_scrollView setContentOffset:CGPointMake(0,220)];
    }
    if([textField isEqual:_mobilePhoneField])
    {
        _mobilePhoneField.keyboardType = UIKeyboardTypeNumberPad;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            doneButton.hidden = YES;
            [self addButtonToKeyboard];
        }
        [_scrollView setContentOffset:CGPointMake(0,260)];
    }
    if([textField isEqual:_homePhoneField])
    {
        _homePhoneField.keyboardType = UIKeyboardTypeNumberPad;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            doneButton.hidden = YES;
            [self addButtonToKeyboard];
        }
        [_scrollView setContentOffset:CGPointMake(0,300)];
    }
    if([textField isEqual:_email1Field])
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)doneButton.hidden = YES;
        [_scrollView setContentOffset:CGPointMake(0,340)];
    }
    if([textField isEqual:_email2Field])
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)doneButton.hidden = YES;
        [_scrollView setContentOffset:CGPointMake(0,380)];
    }
    if([textField isEqual:_websiteField])
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)doneButton.hidden = YES;
        [_scrollView setContentOffset:CGPointMake(0,380)];
    }
    if([textField isEqual:_emailNotification])
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)doneButton.hidden = YES;
        [_scrollView setContentOffset:CGPointMake(0,420)];
    }
    [UIView commitAnimations];
}

- (void)addButtonToKeyboard {
	// create custom button
	doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	doneButton.frame = CGRectMake(0, 163, 106, 53);
	doneButton.adjustsImageWhenHighlighted = NO;
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.0) {
		[doneButton setImage:[UIImage imageNamed:@"DoneUp3.png"] forState:UIControlStateNormal];
		[doneButton setImage:[UIImage imageNamed:@"DoneDown3.png"] forState:UIControlStateHighlighted];
	} else {
		[doneButton setImage:[UIImage imageNamed:@"DoneUp3.png"] forState:UIControlStateNormal];
		[doneButton setImage:[UIImage imageNamed:@"DoneDown3.png"] forState:UIControlStateHighlighted];
	}
	[doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
	// locate keyboard view
	UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	UIView* keyboard;
	for(int i=0; i<[tempWindow.subviews count]; i++) {
		keyboard = [tempWindow.subviews objectAtIndex:i];
		// keyboard found, add the button
		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
			if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
				[keyboard addSubview:doneButton];
		} else {
			if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
				[keyboard addSubview:doneButton];
		}
	}
}
- (void)keyboardWillShow:(NSNotification *)note {
	// if clause is just an additional precaution, you could also dismiss it
	if ([[[UIDevice currentDevice] systemVersion] floatValue] < 3.2) {
        if(([_businessPhoneField isEditing]) || ([_homePhoneField isEditing]) || ([_faxField isEditing]) || ([_mobilePhoneField isEditing]) || ([_postalCodeField isEditing]))
            [self addButtonToKeyboard];
	}
}

- (void)keyboardDidShow:(NSNotification *)note {
	// if clause is just an additional precaution, you could also dismiss it
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
        if(([_businessPhoneField isEditing]) || ([_homePhoneField isEditing]) || ([_faxField isEditing]) || ([_mobilePhoneField isEditing]) || ([_postalCodeField isEditing]))
            [self addButtonToKeyboard];
    }
}


- (void)doneButton:(id)sender {
    [_businessPhoneField resignFirstResponder];
    [_faxField resignFirstResponder];
    [_mobilePhoneField resignFirstResponder];
    [_homePhoneField resignFirstResponder];
    [_postalCodeField resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[_scrollView setContentOffset:CGPointMake(0,0)];
    [UIView commitAnimations];
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
