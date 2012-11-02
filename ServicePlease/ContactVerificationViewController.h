//
//  ContactVerificationViewController.h
//  ServicePlease
//
//  Created by Ashokkumar Kandaswamy on 10/07/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEPopoverController.h"
#import "AppDelegate.h"
#import "ServicePleaseValidation.h"

@interface ContactVerificationViewController : UIViewController<UITextFieldDelegate,UIPopoverControllerDelegate>
{
    IBOutlet UIView *fieldContainer;
    WEPopoverController *popoverController;
    UIAlertView *successfulContactUpdateAlert;
  
    NSString *contactName;
    NSString *email; 
    NSString *telePhoneNo;   
    NSString *callBackNo;
}

@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) IBOutlet UIButton *editBtnPressed;

@property (nonatomic, retain) WEPopoverController *popoverController;

@property(nonatomic,retain) IBOutlet UIView *fieldContainer;

@property(strong, nonatomic) IBOutlet UITextField *contactNameField;

@property(strong, nonatomic) IBOutlet UITextField *emailAddressField;

@property(strong, nonatomic) IBOutlet UITextField *telephoneField;

@property(strong, nonatomic) IBOutlet UITextField *callbackNumberField;

-(IBAction)doneBtnPressed:(id)sender;

- (IBAction)editBtnPressed:(id)sender;

- (IBAction)callBtnPressed:(id)sender;

- (Contact *) creatContactInstance;

- (BOOL) updateContact:(Contact *)contact;

@end
