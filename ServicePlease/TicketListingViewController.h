//
//  TicketListingViewController.h
//  ServicePlease
//
//  Created by Edward Elliott on 2/14/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "ServiceHelper.h"
#import "Category.h"
#import "Contact.h"
#import "User.h"
#import "TicketListingViewCell.h"

@interface TicketListingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) BOOL searching;
@property (nonatomic, assign) BOOL letUserSelectRow;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *ticketList;
@property (strong, nonatomic) NSMutableArray *filteredTicketList;

@property (strong, nonatomic) Category *selectedCategory;

- (IBAction)addTicketButtonWasPressed:(id)sender;
- (IBAction)actionButtonWasPressed:(id)sender;
- (IBAction)problemSolutionButtonWasPressed:(id)sender;
- (IBAction)filterButtonWasPressed:(id)sender;

- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;

@end
