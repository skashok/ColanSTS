//
//  EditTicketViewController.h
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 11/06/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Ticket.h"

@interface EditTicketViewController : UIViewController <UITextViewDelegate>
{
    
    Ticket *currentTicket;
    
}

@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UITextView *currentTextView;

@property (strong, nonatomic) Ticket *currentTicket;


- (IBAction)saveButtonWasPressed:(id)sender;
- (IBAction)deleteButtonWasPressed:(id)sender;

- (IBAction) pushVoiceSubviewForButton: (id) sender;
- (void) recordVoiceEntry: (id) sender;

- (Ticket *) createTicketInstance;

- (BOOL) doesTicketExist:(Ticket *) ticket;

- (BOOL) saveTheEditedTicket:(Ticket *) ticket;


@end
