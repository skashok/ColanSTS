//
//  LocationListingViewController.h
//  ServicePlease
//
//  Created by Edward Elliott on 2/14/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "ServiceHelper.h"
#import "Category.h"
#import "ContactListingViewController.h"

@interface LocationListingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    IBOutlet UIButton *addnewLocationBtn;
}

@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UIButton *addnewLocationBtn;

@property (nonatomic, assign) BOOL searching;
@property (nonatomic, assign) BOOL letUserSelectRow;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *locationList;
@property (strong, nonatomic) NSMutableArray *filteredLocationList;

@property (strong, nonatomic) Category *selectedCategory;

- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;

@end
