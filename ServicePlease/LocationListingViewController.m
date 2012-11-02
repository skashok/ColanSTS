//
//  LocationListingViewController.m
//  ServicePlease
//
//  Created by Edward Elliott on 2/14/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "LocationListingViewController.h"

@implementation LocationListingViewController

@synthesize appDelegate = _appDelegate;

@synthesize searchBar = _searchBar;
@synthesize searching = _searching;
@synthesize letUserSelectRow = _letUserSelectRow;

@synthesize tableView = _tableView;

@synthesize locationList = _locationList;
@synthesize filteredLocationList = _filteredLocationList;

@synthesize selectedCategory = _selectedCategory;

@synthesize addnewLocationBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self) 
	{
        // Custom initialization
    }
	
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) doneSearching_Clicked:(id)sender 
{	
	[[self searchBar] setText:@""];
	[[self searchBar] resignFirstResponder];
	
	[self setLetUserSelectRow:YES];
	[self setSearching:NO];
	
	self.navigationItem.rightBarButtonItem = nil;
	self.tableView.scrollEnabled = YES;
	
	[self.tableView reloadData];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar 
{	
	[self setSearching:YES];
	[self setLetUserSelectRow:NO];
	
	self.tableView.scrollEnabled = NO;
	
	//Add the done button.
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
											   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
											   target:self action:@selector(doneSearching_Clicked:)];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText 
{	
	//Remove all objects first.
	[[self filteredLocationList] removeAllObjects];
	
	if([searchText length] > 0) 
	{
        addnewLocationBtn.hidden=YES;
		[self setSearching:YES];
		[self setLetUserSelectRow:YES];
		
		self.tableView.scrollEnabled = YES;
		
		[self searchTableView];
	}
	else 
	{
        addnewLocationBtn.hidden=NO;
		[self setSearching:NO];
		[self setLetUserSelectRow:YES];
		
		self.tableView.scrollEnabled = NO;
	}
	
	[self.tableView reloadData];
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar 
{	
    [[self filteredLocationList] removeAllObjects];

	[self searchTableView];
}

- (void) searchTableView 
{	
	NSString *searchText = [[self searchBar] text];
	
	for (Location *location in [self locationList])
	{
//		if ([[location locationName] hasPrefix:searchText])
//            
//		{
            NSRange searchResultsRange = [[location locationName] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (searchResultsRange.length > 0)
            {
                [[self filteredLocationList] addObject:location];
            }
//		}
	}
	
	if ([[self filteredLocationList] count] > 0) 
	{		
		[self.tableView reloadData];
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	if ([self searching]) 
	{
		return [[self filteredLocationList] count];
	}
	else 
	{
		return [[self locationList] count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"locationListingViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) 
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
	if ([self searching]) 
	{
        int count = [self.filteredLocationList count];
        
        if (count > 0) {
            
		[[cell textLabel] setText:[[[self filteredLocationList] objectAtIndex:[indexPath row]] valueForKey:@"locationName"]];
        }
	}
	else 
	{
        int count = [self.locationList count];
        
        if (count > 0) {
            
		[[cell textLabel] setText:[[[self locationList] objectAtIndex:[indexPath row]] valueForKey:@"locationName"]];
            
        }
	}	
	
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([self searching]) 
	{
		//NSLog(@"You picked the location: %@", [[[self filteredLocationList] objectAtIndex:[indexPath row]] valueForKey:@"locationName"]);
		
		[[[self appDelegate] selectedEntities] setLocation:[[self filteredLocationList] objectAtIndex:[indexPath row]]];
	}
	else 
	{
		//NSLog(@"You picked the location: %@", [[[self locationList] objectAtIndex:[indexPath row]] valueForKey:@"locationName"]);
		
		[[[self appDelegate] selectedEntities] setLocation:[[self locationList] objectAtIndex:[indexPath row]]];
	}
	
	UIStoryboard *mainStoryboard = nil;
	
	BOOL iPad = NO;
	
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
	
	ContactListingViewController *contactListingController = (ContactListingViewController*)[mainStoryboard 
																		instantiateViewControllerWithIdentifier:@"ContactListingController"];
	
	[[self navigationController] pushViewController:contactListingController animated:YES];
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	// [self setTitle:@"ServicePlease"];
	// [[self navigationItem] setTitle:@"ServicePlease"];
	
	if (_appDelegate == nil) 
	{
		_appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	}
	
	if (_filteredLocationList == nil) 
	{
		_filteredLocationList = [[NSMutableArray alloc] init];
	}
	
	[[self tableView] setDelegate:self];
	[[self tableView] setDataSource:self];
	
	[[self searchBar] setDelegate:self];
	
	// [[self tableView] setTableHeaderView:[self searchBar]];
	[[self searchBar] setAutocorrectionType:UITextAutocorrectionTypeNo];
	
	[self setSearching:NO];
	[self setLetUserSelectRow:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{	
    UIStoryboard *mainStoryboard = nil;
    BOOL iPad = NO;
    
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
    
    if (iPad) 
    {
        UIImage *leftBtnImage=[UIImage imageNamed:@"left.png"];
        UIButton *leftnavBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        leftnavBtn.bounds=CGRectMake(0,0,26,26); 
        [leftnavBtn setImage:leftBtnImage forState:UIControlStateNormal]; 
        [leftnavBtn addTarget:self action:@selector(leftNavBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftnavBtn];
        self.navigationItem.leftBarButtonItem=leftBtnItem;
        
    }
    else 
    {
        UIImage *leftBtnImage=[UIImage imageNamed:@"left.png"];
        UIButton *leftnavBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        leftnavBtn.bounds=CGRectMake(0,0,50,25); 
        [leftnavBtn setImage:leftBtnImage forState:UIControlStateNormal]; 
        [leftnavBtn addTarget:self action:@selector(leftNavBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:leftnavBtn];
        self.navigationItem.leftBarButtonItem=leftBtnItem;
    }
    
    NSLog(@"Locaiton listing: %d",[[ServiceHelper getLocationsByOrganization:[[[[self appDelegate] selectedEntities] organization] organizationId]] count]);
    
	[self setLocationList:[ServiceHelper getLocationsByOrganization:[[[[self appDelegate] selectedEntities] organization] organizationId]]];
	
	[[self tableView] reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self doneSearching_Clicked:nil];
}

-(void)leftNavBtnPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
