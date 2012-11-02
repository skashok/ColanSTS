//
//  EditSolutionViewController.h
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 19/06/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Solution.h"

@interface EditSolutionViewController : UIViewController <UITextViewDelegate,UITextFieldDelegate>
{
}


@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UITextField *shortDescriptionTextView;

@property (strong, nonatomic) IBOutlet UITextView *currentTextView;


@property (strong, nonatomic) Solution *currentSolution;


- (IBAction)saveButtonWasPressed:(id)sender;
- (IBAction)deleteButtonWasPressed:(id)sender;

- (IBAction) pushVoiceSubviewForButton: (id) sender;
- (void) recordVoiceEntry: (id) sender;

- (Solution *) createSolutionInstance;

- (BOOL) doesSolutiontExist:(Solution *) solution;

- (BOOL) saveTheEditedSolution:(Solution *) solution;

@end
