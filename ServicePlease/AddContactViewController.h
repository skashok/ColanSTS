//
//  AddContactViewController.h
//  ServicePlease
//
//  Created by Edward Elliott on 3/7/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServiceHelper.h"

#import	"AppDelegate.h"
#import "Contact.h"

enum ContactFields
{
	ContactName = 2001,
	FirstName,
	MiddleName,
	LastName,
	Email,
	Phone
};

@interface AddContactViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate,  UIGestureRecognizerDelegate>

@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) UITextField *currentTextField;

@property (strong, nonatomic) Contact *contact;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UITextField *contactNameField;
@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *middleNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *phoneField;
@property (strong, nonatomic) IBOutlet UITextField *callBackNumField;

@property (strong, nonatomic) IBOutlet UITextField *Ext1Field;
@property (strong, nonatomic) IBOutlet UITextField *Ext2Field;


- (IBAction)saveButtonWasPressed:(id)sender;
- (IBAction)cancelButtonWasPressed:(id)sender;

- (IBAction) pushVoiceSubviewForButton: (id) sender;
- (void) recordVoiceEntry: (id) sender;

- (Contact *) createContactInstance;

- (BOOL) doesContactExist:(Contact *) contact;

- (BOOL) saveContact:(Contact *) contact;

@end
