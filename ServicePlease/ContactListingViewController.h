//
//  ContactListingViewController.h
//  ServicePlease
//
//  Created by Edward Elliott on 2/14/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

#import "AppDelegate.h"
#import "ServiceHelper.h"
#import "Category.h"
#import "Contact.h"
#import "TicketListingViewController.h"
#import "WEPopoverController.h"
#import "ProblemSolutionViewController.h"
#import "ContactVerificationViewController.h"
#import "popViewController.h"
#import "AddProblemViewController.h"


@interface ContactListingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, WEPopoverControllerDelegate,UIPopoverControllerDelegate>{
    
    WEPopoverController *popoverController;
	NSInteger currentPopoverCellIndex;
	Class popoverClass;
    
    IBOutlet UIButton *addnewContactBtn;
   
}

@property (nonatomic, retain) WEPopoverController *popoverController;

@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong,nonatomic)  IBOutlet UIButton *addnewContactBtn;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, assign) BOOL searching;

@property (nonatomic, assign) BOOL letUserSelectRow;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *contactList;

@property (strong, nonatomic) NSMutableArray *filteredContactList;

@property (strong, nonatomic) Contact *selectedContact;

- (IBAction)addContactBtnPressed:(id)sender;
- (void) searchTableView;

- (void) doneSearching_Clicked:(id)sender;

- (void) doneBtnPressed:(id)sender;

- (void) popDoneButtonPressed;

-(void)textfieldIsEditing:(NSString *)integer;
-(void)textfieldIsEndEditing;

-(void)dismissPop;
-(void)dismissViewController;


@end
