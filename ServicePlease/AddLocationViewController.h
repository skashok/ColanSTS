//
//  AddLocationViewController.h
//  ServicePlease
//
//  Created by Edward Elliott on 3/7/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSString+StringWithUUID.h"

#import "ServiceHelper.h"

#import	"AppDelegate.h"
#import "Location.h"
#import "LocationInfo.h"
#import "Organization.h"
#import "EmailNotification.h"

enum LocationFields
{
	LocationName = 1001,
	Addr1,
	Addr2,
	City,
	State,
	Zip,
	Country,
	BusPhone,
	Fax,
	MobilePhone,
	HomePhone,
	Email1,
	Email2,
	Website
};

@interface AddLocationViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate,  UIGestureRecognizerDelegate>
{
    UIButton *doneButton;
    UIView *loadingView;
    UIActivityIndicatorView *activityIndicator;
}

//@property (nonatomic, retain) UIAlertView *locationAddedAlert;

@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) UITextField *currentTextField;

@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) LocationInfo *locationInfo;

@property (strong, nonatomic) EmailNotification *emailNotification;


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property(strong, nonatomic) IBOutlet UITextField *locationNameField;
@property(strong, nonatomic) IBOutlet UITextField *address1Field;
@property(strong, nonatomic) IBOutlet UITextField *address2Field;
@property(strong, nonatomic) IBOutlet UITextField *cityField;
@property(strong, nonatomic) IBOutlet UITextField *stateField;
@property(strong, nonatomic) IBOutlet UITextField *postalCodeField;
@property(strong, nonatomic) IBOutlet UITextField *countryField;
@property(strong, nonatomic) IBOutlet UITextField *businessPhoneField;
@property(strong, nonatomic) IBOutlet UITextField *faxField;
@property(strong, nonatomic) IBOutlet UITextField *mobilePhoneField;
@property(strong, nonatomic) IBOutlet UITextField *homePhoneField;
@property(strong, nonatomic) IBOutlet UITextField *email1Field;
@property(strong, nonatomic) IBOutlet UITextField *email2Field;
@property(strong, nonatomic) IBOutlet UITextField *websiteField;

- (IBAction)saveButtonWasPressed:(id)sender;
- (IBAction)cancelButtonWasPressed:(id)sender;

- (IBAction) pushVoiceSubviewForButton: (id) sender;
- (void) recordVoiceEntry: (id) sender;

- (Location *) createLocationInstance:(NSString *)locationInfo;
- (LocationInfo *) createLocationInfoInstance;

- (BOOL) doesLocationInfoExist:(LocationInfo *) locationInfo;
- (BOOL) doesLocationExist:(Location *) location;

- (BOOL) saveLocationInfo:(LocationInfo *) locationInfo;
- (BOOL) saveLocation:(Location *) location;
- (BOOL) sendEmailNotificationToAdmin:(Location *) location emailLocatonInfoDetail:(LocationInfo *)locationinfo;

@end
