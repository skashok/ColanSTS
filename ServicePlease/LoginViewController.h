//
//  LoginViewController.h
//  ServicePlease
//
//  Created by Ed Elliott on 2/12/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServiceHelper.h"
#import "AppDelegate.h"
#import "SelectedEntities.h"
#import "ApplicationListViewController.h"

@interface LoginViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UITextField *currentTextField;
}
@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) IBOutlet UITextField *userNameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) UITextField *currentTextField;

- (IBAction)loginButtonWasPressed:(id)sender;

@end
