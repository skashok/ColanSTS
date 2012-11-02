//
//  TicketListingViewController.m
//  ServicePlease
//
//  Created by Edward Elliott on 2/14/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "TicketListingViewController.h"
#import "EditTicketViewController.h"
#import "TicketMonitorViewController.h"

@implementation TicketListingViewController

@synthesize appDelegate = _appDelegate;

@synthesize searchBar = _searchBar;
@synthesize searching = _searching;
@synthesize letUserSelectRow = _letUserSelectRow;

@synthesize tableView = _tableView;

@synthesize ticketList = _ticketList;
@synthesize filteredTicketList = _filteredTicketList;

@synthesize selectedCategory = _selectedCategory;

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

- (IBAction)addTicketButtonWasPressed:(id)sender
{
	
}

- (IBAction)actionButtonWasPressed:(id)sender
{
	
}

- (IBAction)problemSolutionButtonWasPressed:(id)sender
{
}

- (IBAction)filterButtonWasPressed:(id)sender
{
	
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
	[[self filteredTicketList] removeAllObjects];
	
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
	
	[self.tableView reloadData];
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar 
{	
    [[self filteredTicketList] removeAllObjects];

	[self searchTableView];
}

- (void) searchTableView 
{	
	NSString *searchText = [[self searchBar] text];
	
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
	}
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
	if ([self searching]) 
	{
		return [[self filteredTicketList] count];
	}
	else 
	{
		return [[self ticketList] count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ticketListingViewCell";
    
    TicketListingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) 
	{
        cell = [[TicketListingViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	
	if ([self searching]) 
	{
        int count = [self.ticketList count];
        
        if (count > 0) {
            
		NSString *dateString = [formatter stringFromDate:[[[self filteredTicketList] objectAtIndex:[indexPath row]] valueForKey:@"createDate"]];
		
		[[cell dateTimeLbl] setText:dateString];
		
        Ticket *tic = (Ticket *) [[self ticketList] objectAtIndex:[indexPath row]];
		
        
        [[cell openCloseLbl] setText:([[tic ticketStatus] length] >= 4) ? [[tic ticketStatus] substringToIndex:4]:[tic ticketStatus]];
		
		User *user = [ServiceHelper getUserByUserId:[[[self filteredTicketList] objectAtIndex:[indexPath row]] valueForKey:@"userId"]];
		
		[[cell techLbl] setText:[user userName]];
		
		[[cell categoryLbl] setText:[[[self filteredTicketList] objectAtIndex:[indexPath row]] valueForKey:@"ticketName"]];
        }
	}
	else 
	{
        int count = [self.ticketList count];
        
        if (count > 0) {
            
		NSString *dateString = [formatter stringFromDate:[[[self ticketList] objectAtIndex:[indexPath row]] valueForKey:@"createDate"]];

		[[cell dateTimeLbl] setText:dateString];
        
        Ticket *tic = (Ticket *) [[self ticketList] objectAtIndex:[indexPath row]];
		        
        [[cell openCloseLbl] setText:([[tic ticketStatus] length] >= 4) ? [[tic ticketStatus] substringToIndex:4]:[tic ticketStatus]];

        
		User *user = [ServiceHelper getUserByUserId:[[[self ticketList] objectAtIndex:[indexPath row]] valueForKey:@"userId"]];
		
		[[cell techLbl] setText:[user userName]];

		[[cell categoryLbl] setText:[[[self ticketList] objectAtIndex:[indexPath row]] valueForKey:@"ticketName"]];
        }
	}	
	
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self searching]) 
	{
		//NSLog(@"You picked the location: %@", [[[self filteredTicketList] objectAtIndex:[indexPath row]] valueForKey:@"ticketName"]);
		
		[[[self appDelegate] selectedEntities] setTicket:[[self filteredTicketList] objectAtIndex:[indexPath row]]];
	}
	else 
	{
		//NSLog(@"You picked the location: %@", [[[self ticketList] objectAtIndex:[indexPath row]] valueForKey:@"ticketName"]);
		
		[[[self appDelegate] selectedEntities] setTicket:[[self ticketList] objectAtIndex:[indexPath row]]];
        
        //NSLog(@"Ticket send to APP DELEGATE: %@",[[[self appDelegate] selectedEntities] ticket]);

	}
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
    
    //NSLog(@"SELECTED TICKET DETAILS: %@",[[self ticketList] objectAtIndex:[indexPath row]]);
    
	EditTicketViewController *editTicketViewController = (EditTicketViewController*)[mainStoryboard 
                                                                                                 instantiateViewControllerWithIdentifier: @"EditTicketController"];
	
	[[self navigationController] pushViewController:editTicketViewController animated:YES];

    
    
    
  /*  BOOL iPad = NO;
	
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
    
    
	TicketMonitorViewController *ticketMViewController = (TicketMonitorViewController*)[mainStoryboard 
                                                                                     instantiateViewControllerWithIdentifier: @"TicketMonitorViewController"];
	
	[[self navigationController] pushViewController:ticketMViewController animated:YES];*/

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
	
	//[self setTitle:@"ServicePlease"];
	//[[self navigationItem] setTitle:@"ServicePlease"];
	
	if (_appDelegate == nil) 
	{
		_appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	}
	
	if (_filteredTicketList == nil) 
	{
		_filteredTicketList = [[NSMutableArray alloc] init];
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
        
//        UIImage *rightBtnImage=[UIImage imageNamed:@"right.png"];
//        UIButton *rightNavBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        rightNavBtn.bounds=CGRectMake(0,0,26,26); 
//        [rightNavBtn setImage:rightBtnImage forState:UIControlStateNormal]; 
//        [rightNavBtn addTarget:self action:@selector(rightNavBtnPressed) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *rightBtnItem=[[UIBarButtonItem alloc]initWithCustomView:rightNavBtn];
//        self.navigationItem.rightBarButtonItem=rightBtnItem;
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
        
    
    if (_appDelegate == nil) 
	{
		_appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	}

        
    NSMutableString *title = [[NSMutableString alloc] init];
    [title appendFormat:@"%@",[[[[self appDelegate] selectedEntities] location] locationName]];
    [title appendString:@" / "];
    [title appendFormat:@"%@",[[[[self appDelegate] selectedEntities] contact] contactName]];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-50, 0, 768, 45)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    // here's where you can customize the font size
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:title];
    [titleLabel setNumberOfLines:0.0];
    [titleLabel setLineBreakMode:UILineBreakModeWordWrap];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [titleLabel setCenter:[self.navigationItem.titleView center]];
    [self.navigationItem setTitleView:titleLabel];
    
	[self setTicketList:[ServiceHelper getTicketsByCategory:[[[[self appDelegate] selectedEntities] category] categoryId]]];
	
	[[self tableView] reloadData];
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
