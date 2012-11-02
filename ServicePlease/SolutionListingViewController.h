//
//  SolutionListingViewController.h
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 19/06/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

@interface SolutionListingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>


@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) BOOL searching;
@property (nonatomic, assign) BOOL letUserSelectRow;

@property (strong, nonatomic) IBOutlet UITableView *solutionTableView;

@property (strong, nonatomic) NSMutableArray *solutionList;
@property (strong, nonatomic) NSMutableArray *filteredSolutionList;

@property (strong, nonatomic) Category *selectedCategory;

- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;

@end
