//
//  AddSolutionViewController.h
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 15/06/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Solution.h"

#import "AppDelegate.h"

@interface AddSolutionViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate>


@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UITextField *shortDescriptionTextView;

@property (strong, nonatomic) IBOutlet UITextView *currentTextView;

- (IBAction)saveButtonWasPressed:(id)sender;
- (IBAction)cancelButtonWasPressed:(id)sender;

- (IBAction) pushVoiceSubviewForButton: (id) sender;
- (void) recordVoiceEntry: (id) sender;

- (Solution *) createSolutionInstance;

- (BOOL) doesSolutionExist:(Solution *) ticket;

- (BOOL) saveSolution:(Solution *) ticket;
@end
