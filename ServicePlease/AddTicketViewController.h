//
//  AddTicketViewController.h
//  ServicePlease
//
//  Created by Ed Elliott on 3/18/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

#import "ServiceHelper.h"

#import "Ticket.h"

#import "FilterPopupView.h"

@interface AddTicketViewController : UIViewController <UIScrollViewDelegate, UITextViewDelegate,  UIGestureRecognizerDelegate , CatsResponseDelegate>
{
     FilterPopupView *filterPopupView;
    
     UIPopoverController *popoverController;
}
@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UITextView *currentTextView;

- (IBAction)saveButtonWasPressed:(id)sender;

- (IBAction)cancelButtonWasPressed:(id)sender;

- (IBAction) pushVoiceSubviewForButton: (id) sender;

- (void) recordVoiceEntry: (id) sender;

- (Ticket *) createTicketInstance;

- (BOOL) doesTicketExist:(Ticket *) ticket;

- (Ticket *) saveTicket:(Ticket *) ticket;

-(BOOL)generateAndSendEmailtoContact:(Ticket *)ticket;

-(void)saveTicketwithCatandTechId;

@end
