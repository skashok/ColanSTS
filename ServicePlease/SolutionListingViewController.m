//
//  SolutionListingViewController.m
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 19/06/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "SolutionListingViewController.h"
#import "AppDelegate.h"
#import "ServiceHelper.h"
#import "EditSolutionViewController.h"

#import "SolutionListingViewCell.h"

@implementation SolutionListingViewController

@synthesize appDelegate = _appDelegate;

@synthesize letUserSelectRow = _letUserSelectRow;

@synthesize solutionList = _solutionList;

@synthesize selectedCategory = _selectedCategory;

@synthesize solutionTableView = _solutionTableView;

@synthesize filteredSolutionList = _filteredSolutionList;

@synthesize searchBar = _searchBar;

@synthesize searching = _searching;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (_appDelegate == nil) 
	{
		_appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	}
	
	if (_filteredSolutionList == nil) 
	{
		_filteredSolutionList = [[NSMutableArray alloc] init];
	}
	
	[[self solutionTableView] setDelegate:self];
	[[self solutionTableView] setDataSource:self];
	
	[[self searchBar] setDelegate:self];
	
	// [[self tableView] setTableHeaderView:[self searchBar]];
	[[self searchBar] setAutocorrectionType:UITextAutocorrectionTypeNo];
	
	[self setSearching:NO];
	[self setLetUserSelectRow:YES];
}

- (void)viewWillAppear:(BOOL)animated
{	
	[self setSolutionList:[ServiceHelper getSolutionByTicket:@""]];
	
	[[self solutionTableView] reloadData];
}


- (void) doneSearching_Clicked:(id)sender 
{	
	/*[[self searchBar] setText:@""];
	[[self searchBar] resignFirstResponder];
	
	[self setLetUserSelectRow:YES];
	[self setSearching:NO];
	
	self.navigationItem.rightBarButtonItem = nil;
	self.solutionTableView.scrollEnabled = YES;
	
	[self.tableView reloadData];*/
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar 
{	
	/*[self setSearching:YES];
	[self setLetUserSelectRow:NO];
	
	self.tableView.scrollEnabled = NO;
	
	//Add the done button.
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
											  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
											  target:self action:@selector(doneSearching_Clicked:)];*/
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText 
{	
	//Remove all objects first.
	/*[[self filteredTicketList] removeAllObjects];
	
	if([searchText length] > 0) 
	{
		[self setSearching:YES];
		[self setLetUserSelectRow:YES];
		
		self.tableView.scrollEnabled = YES;
		
		[self searchTableView];
	}
	else 
	{
		[self setSearching:NO];
		[self setLetUserSelectRow:NO];
		
		self.tableView.scrollEnabled = NO;
	}
	
	[self.tableView reloadData];*/
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar 
{	
   /* [[self filteredTicketList] removeAllObjects];
    
	[self searchTableView];*/
}

- (void) searchTableView 
{	
	/*NSString *searchText = [[self searchBar] text];
	
	for (Ticket *ticket in [self ticketList])
	{
		//if ([[ticket ticketName] hasPrefix:searchText])
		//{
        
        NSRange searchResultsRange = [[ticket ticketName] rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (searchResultsRange.length > 0)
        {
            
			[[self filteredTicketList] addObject:ticket];
            
        }
		//}
	}
	
	if ([[self filteredTicketList] count] > 0) 
	{		
		[self.tableView reloadData];
	}*/
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	/*if ([self searching]) 
	{
		return [[self filteredTicketList] count];
	}
	else 
	{
		return [[self ticketList] count];
	}*/
    
  
    return [[self solutionList] count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"solutionListingViewCell";
    
    SolutionListingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) 
   {
        cell = [[SolutionListingViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    //NSLog(@"Cell : %@",cell);

    //NSLog(@"solutionList :%@",[self solutionList]);
    
    //NSLog(@"[[cell solutionTitleLbl] : %@",[cell solutionTitleLbl]);
    
    Solution *sol = (Solution *) [[self solutionList] objectAtIndex:[indexPath row]];
    
    //NSLog(@"Solution *sol : %@",sol);
    
    //NSLog(@"Solution solutionShortDesc: %@",[sol solutionShortDesc]);
	
    NSString *solutionTitle = [NSString stringWithFormat:@"%@: %@",@"Title",[sol solutionShortDesc]];
    
    UIView *myView = [[UIView alloc] init];
    myView.backgroundColor = [UIColor colorWithRed:186/255.f green:221/255.f blue:241/255.f alpha:1.0];;
    cell.backgroundView = myView;
    
    [[cell solutionTitleLbl] setText: solutionTitle];
    
    [[cell solutionDescriptionLbl] setText:[sol solutionText]];
	
    [tableView setSeparatorColor:[UIColor colorWithRed:186/255.f green:221/255.f blue:241/255.f alpha:1.0]];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    
//    if ([self searching]) 
//	{
//		//NSLog(@"You picked the location: %@", [[[self filteredTicketList] objectAtIndex:[indexPath row]] valueForKey:@"ticketName"]);
//		
//		[[[self appDelegate] selectedEntities] setTicket:[[self filteredTicketList] objectAtIndex:[indexPath row]]];
//	}
//	else 
//	{
//		//NSLog(@"You picked the location: %@", [[[self ticketList] objectAtIndex:[indexPath row]] valueForKey:@"ticketName"]);
//		
//		[[[self appDelegate] selectedEntities] setTicket:[[self ticketList] objectAtIndex:[indexPath row]]];
//        
//        //NSLog(@"Ticket send to APP DELEGATE: %@",[[[self appDelegate] selectedEntities] ticket]);
//        
//	}
    
    [[[self appDelegate] selectedEntities] setSolution:[[self solutionList] objectAtIndex:[indexPath row]]];
           
    //NSLog(@"Solution send to APP DELEGATE: %@",[[[self appDelegate] selectedEntities] solution]);

    
    BOOL iPad = NO;
	
	UIStoryboard *mainStoryboard = nil;
	
#ifdef UI_USER_INTERFACE_IDIOM
	iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
	if (iPad) 
	{
		// iPad specific code here
		mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle: nil];
	} 
	else 
	{
		// iPhone/iPod specific code here
		mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle: nil];
	}
    
    //NSLog(@"SELECTED SOLUTION DETAILS: %@",[[self solutionList] objectAtIndex:[indexPath row]]);
    
	EditSolutionViewController *editSolutionViewController = (EditSolutionViewController*)[mainStoryboard 
                                                                                     instantiateViewControllerWithIdentifier: @"EditSolutionViewController"];
	
	[[self navigationController] pushViewController:editSolutionViewController animated:YES];
    
    
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	if([self letUserSelectRow])
	{
		return indexPath;
	}
	else
	{
		return nil;
	}
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
