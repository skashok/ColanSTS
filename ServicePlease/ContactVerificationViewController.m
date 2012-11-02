//
//  ContactVerificationViewController.m
//  ServicePlease
//
//  Created by Ashokkumar Kandaswamy on 10/07/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "ContactVerificationViewController.h"
#import "AppDelegate.h"
#import "ContactListingViewController.h"


@interface ContactVerificationViewController ()

@end

@implementation ContactVerificationViewController

@synthesize fieldContainer;
@synthesize editBtnPressed;
@synthesize popoverController;
@synthesize contactNameField;
@synthesize emailAddressField;
@synthesize telephoneField;
@synthesize callbackNumberField;
@synthesize appDelegate;


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
    
    contactNameField.enabled=NO;
    emailAddressField.enabled=NO;
    telephoneField.enabled=NO;
    callbackNumberField.enabled=NO;
    
    self.contentSizeForViewInPopover = CGSizeMake(250,280);  
    appDelegate =[[AppDelegate alloc]init];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    contactName = [appDelegate selectedEntities].contact.contactName;
    email       = [appDelegate selectedEntities].contact.email;
    telePhoneNo = [appDelegate selectedEntities].contact.phone;
    callBackNo  = [appDelegate selectedEntities].contact.callBackNum;
    
    contactNameField.text    = contactName;
    emailAddressField.text   = email;
    telephoneField.text      = telePhoneNo ;
    callbackNumberField.text = callBackNo;

}

- (void)viewDidUnload
{
    [self setEditBtnPressed:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(IBAction)doneBtnPressed:(id)sender
{
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    if (([[[self contactNameField]text] isEqualToString: contactName])&&([[[self emailAddressField]text] isEqualToString: email])&&([[[self telephoneField]text]isEqualToString:telePhoneNo])&&([[[self callbackNumberField]text] isEqualToString: callBackNo]))
    {
        
        if (appDelegate.newTicketCreationProcess)
        {
            [appDelegate.curContactListingVC popDoneButtonPressed];
        }
        else
        {
            [appDelegate.curContactListingVC dismissPop];
            
            [appDelegate.curContactListingVC dismissViewController];
        }
        
    }else {
        
        if (([ServicePleaseValidation validateNotEmpty:[[self contactNameField] text]]) &&
            ([ServicePleaseValidation validateNotEmpty:[[self emailAddressField] text]]) &&
            ([ServicePleaseValidation validateNotEmpty:[[self telephoneField] text]]) &&
            ([ServicePleaseValidation validateNotEmpty:[[self callbackNumberField] text]]) )
        {
            
            if (([ServicePleaseValidation validateAlphaSpaces:[[self contactNameField] text]]) &&
                ([ServicePleaseValidation validateNumeric:[[self telephoneField] text]]) &&
                ([ServicePleaseValidation validateNumeric:[[self callbackNumberField] text]])    &&
                ([ServicePleaseValidation validateEmail:[[self emailAddressField] text]]) )
            {
                Contact *contact = [self creatContactInstance];
                
                if ([self updateContact:contact] == YES)
                {
                    
                    successfulContactUpdateAlert = [[UIAlertView alloc] initWithTitle:@"Contact Saved"
                                                                              message:@"The Contact entry was updated successfully"
                                                                             delegate:self
                                                                    cancelButtonTitle:@"Ok"
                                                                    otherButtonTitles:nil];
                    
                    [successfulContactUpdateAlert show];
                }
                
            }else {
                
                NSMutableString *errorMessage = [[NSMutableString alloc] initWithString:@"Please enter "];
                
                if (![ServicePleaseValidation validateAlphaSpaces:[[self contactNameField] text]])
                {
                    [errorMessage appendString:@"contactName"];
                }
                
                if (![ServicePleaseValidation validateEmail:[[self emailAddressField] text]])
                {
                    if ([errorMessage length] < 15)
                        [errorMessage appendString:@"email"];
                    else
                        [errorMessage appendString:@", email"];
                }
                
                if (![ServicePleaseValidation validateNumeric:[[self telephoneField] text]] )
                {
                    if ([errorMessage length] < 15)
                        [errorMessage appendString:@"telephone no"];
                    else
                        [errorMessage appendString:@", telephone no"];
                    
                }
                if (![ServicePleaseValidation validateNumeric:[[self callbackNumberField] text]] )
                {
                    if ([errorMessage length] < 15)
                        [errorMessage appendString:@"callback no"];
                    else
                        [errorMessage appendString:@", callback no"];
                }
                
                [errorMessage appendString:@" field correctly."];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:errorMessage
                                                                   delegate:self
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                
                [alertView show];
                
            }
            
        } else {
            
            NSMutableString *errorMessage = [[NSMutableString alloc] initWithString:@"Please enter "];
            
            if ([self contactNameField].text.length  == 0 )
            {
                [errorMessage appendString:@"contactName"];
            }
            
            if ([[self telephoneField] text].length  == 0 )
            {
                if ([errorMessage length] < 15)
                    [errorMessage appendString:@"telephone no"];
                else
                    [errorMessage appendString:@", telephone no"];
            }
            if ([[self callbackNumberField] text].length  == 0 )
            {
                if ([errorMessage length] < 15)
                    [errorMessage appendString:@"callback no"];
                else
                    [errorMessage appendString:@", callback no"];
            }
            
            if ([[self emailAddressField] text].length  == 0 )
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
}

- (IBAction)editBtnPressed:(id)sender {
    
    contactNameField.enabled=YES;
    emailAddressField.enabled=YES;
    telephoneField.enabled=YES;
    callbackNumberField.enabled=YES;
}

- (IBAction)callBtnPressed:(id)sender {
    
    if ( [callbackNumberField.text length]!=0) 
    {
        NSString *phoneNumber = [@"telprompt://" stringByAppendingString:  callbackNumberField.text];
        
        UIDevice *device = [UIDevice currentDevice];
        
        if ([[device model] isEqualToString:@"iPhone"] ) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
            
        } else {
            
            UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [Notpermitted show];
        }
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    if ( textField==contactNameField) {
        
        [appDelegate.curContactListingVC textfieldIsEditing:@"Name"];
        
    }else if ( textField==emailAddressField) {
        
        [appDelegate.curContactListingVC textfieldIsEditing:@"Email"];
        
    }else if (textField==telephoneField){
        
        [appDelegate.curContactListingVC textfieldIsEditing:@"TelePhone"];
        
    }else if (textField==callbackNumberField){
        
        [appDelegate.curContactListingVC textfieldIsEditing:@"CallBack"];    
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
   
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    [appDelegate.curContactListingVC textfieldIsEndEditing];

    if ( textField==contactNameField) {
        
        [contactNameField resignFirstResponder];        
        
    }else if ( textField==emailAddressField) {
        
        [emailAddressField resignFirstResponder];
        
    }else if (textField==telephoneField){
        
        [telephoneField resignFirstResponder];
        
    }else if (textField==callbackNumberField){
        
        [callbackNumberField resignFirstResponder];
        
    }
    return YES;   
}

#pragma mark - UdateContact Methods

- (Contact *) creatContactInstance{
    
    Contact *contact = nil;
	
	@try 
	{
		if (contact == nil) 
		{
			contact = [[Contact alloc] init];
		}
		
		[contact setContactId:[[[[self appDelegate]selectedEntities]contact]contactId]];
		[contact setLocationId:[[[[self appDelegate] selectedEntities] location] locationId]];
		[contact setOrganizationId:[[[[self appDelegate] selectedEntities] organization] organizationId]];
		[contact setContactName:[[self contactNameField] text]];
		[contact setFirstName:[[[[self appDelegate]selectedEntities]contact]firstName]];
		[contact setMiddleName:[[[[self appDelegate]selectedEntities]contact]middleName]];
		[contact setLastName:[[[[self appDelegate]selectedEntities]contact]lastName]];
		[contact setEmail:[[self emailAddressField]text]];
		[contact setPhone:[[self telephoneField]text]];
		[contact setCreateDate:[NSDate date]];
		[contact setEditDate:[NSDate date]];
        [contact setCallBackNum:[[self callbackNumberField] text]];
        
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

- (BOOL) updateContact:(Contact *)contact {
    
    BOOL wasSuccessful = NO;
	
	@try
	{
        Contact *newContact = [ServiceHelper updateContact:contact contactId:[[[[self appDelegate]selectedEntities]contact]contactId]];
        [[[self appDelegate] selectedEntities] setContact:contact];
        
		
		if (newContact != nil)
		{
			wasSuccessful = YES;
		}
		else
		{
			wasSuccessful = NO;
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Problem In Updating Contact"
                                                                message:@"The Contact update was not saved successfully"
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            
            [alertView show];
            
		}
	}
	@catch (NSException *exception)
	{
		//NSLog(@"Error in updateContact.  Error: %@", [exception description]);
	}
	@finally
	{
		return wasSuccessful;
	}
    
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView==successfulContactUpdateAlert) {
        
        if (appDelegate.newTicketCreationProcess)
        {
            [appDelegate.curContactListingVC popDoneButtonPressed];
        }
        else 
        {
            [appDelegate.curContactListingVC dismissPop];
            [appDelegate.curContactListingVC dismissViewController];
        }
    }
}

@end
