//
//  ContactListingViewController.m
//  ServicePlease
//
//  Created by Edward Elliott on 2/14/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "ContactListingViewController.h"
#import "ContactVerificationViewController.h"
#import "UIBarButtonItem+WEPopover.h"
#import "popViewController.h"
#import "ServicePleaseValidation.h"

@implementation ContactListingViewController

@synthesize appDelegate = _appDelegate;
@synthesize popoverController;
@synthesize searchBar = _searchBar;
@synthesize searching = _searching;
@synthesize letUserSelectRow = _letUserSelectRow;

@synthesize tableView = _tableView;

@synthesize contactList = _contactList;
@synthesize filteredContactList = _filteredContactList;

@synthesize selectedContact = _selectedContact;

@synthesize addnewContactBtn;

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
- (WEPopoverContainerViewProperties *)improvedContainerViewProperties {
	
	WEPopoverContainerViewProperties *props = [WEPopoverContainerViewProperties alloc] ;
	NSString *bgImageName = nil;
	CGFloat bgMargin = 0.0;
	CGFloat bgCapSize = 0.0;
	CGFloat contentMargin = 4.0;
	
	bgImageName = @"popoverBg.png";
	
	// These constants are determined by the popoverBg.png image file and are image dependent
	bgMargin = 13; // margin width of 13 pixels on all sides popoverBg.png (62 pixels wide - 36 pixel background) / 2 == 26 / 2 == 13 
	bgCapSize = 31; // ImageSize/2  == 62 / 2 == 31 pixels
	
	props.leftBgMargin = bgMargin;
	props.rightBgMargin = bgMargin;
	props.topBgMargin = bgMargin;
	props.bottomBgMargin = bgMargin;
	props.leftBgCapSize = bgCapSize;
	props.topBgCapSize = bgCapSize;
	props.bgImageName = bgImageName;
	props.leftContentMargin = contentMargin;
	props.rightContentMargin = contentMargin - 1; // Need to shift one pixel for border to look correct
	props.topContentMargin = contentMargin; 
	props.bottomContentMargin = contentMargin;
	
	props.arrowMargin = 4.0;
	
	props.upArrowImageName = @"popoverArrowUp.png";
	props.downArrowImageName = @"popoverArrowDown.png";
	props.leftArrowImageName = @"popoverArrowLeft.png";
	props.rightArrowImageName = @"popoverArrowRight.png";
	return props;	
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText 
{	
	//Remove all objects first.
	[[self filteredContactList] removeAllObjects];
	
	if([searchText length] > 0) 
	{
        addnewContactBtn.hidden=YES;
		[self setSearching:YES];
		[self setLetUserSelectRow:YES];
		
		self.tableView.scrollEnabled = YES;
		
		[self searchTableView];
	}
	else 
	{
        addnewContactBtn.hidden=NO;
		[self setSearching:NO];
		[self setLetUserSelectRow:NO];
		
		self.tableView.scrollEnabled = NO;
	}
	
	[self.tableView reloadData];
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar 
{	
    [[self filteredContactList] removeAllObjects];
    
	[self searchTableView];
}

- (IBAction)addContactBtnPressed:(id)sender {
    
    if (self.popoverController) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
        currentPopoverCellIndex = -1;
    } 
}

- (void) searchTableView 
{	
	NSString *searchText = [[self searchBar] text];
	
	for (Contact *contact in [self contactList])
	{
		//if ([[contact contactName] hasPrefix:searchText])
		//{
        
        NSRange searchResultsRange = [[contact contactName] rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (searchResultsRange.length > 0)
        {
            [[self filteredContactList] addObject:contact];
        }
		//}
	}
	
	if ([[self filteredContactList] count] > 0) 
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
		return [[self filteredContactList] count];
	}
	else 
	{
		return [[self contactList] count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"contactListingViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) 
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
	if ([self searching]) 
	{
        int count = [self.filteredContactList count];
        
        if (count > 0) {
            
            [[cell textLabel] setText:[[[self filteredContactList] objectAtIndex:[indexPath row]] valueForKey:@"contactName"]];
        }
	}
	else 
	{
        int count = [self.contactList count];
        
        if (count > 0) {
            
            [[cell textLabel] setText:[[[self contactList] objectAtIndex:[indexPath row]] valueForKey:@"contactName"]];
        }
	}	
	
    return cell;
}

-(void)textfieldIsEditing:(NSString  *)textField{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if ([textField isEqualToString:@"Name"]) {
        
        self.popoverController.view.frame=CGRectMake(19,60,280, 280);
        
    }else if([textField isEqualToString:@"Email"]){
        
        self.popoverController.view.frame=CGRectMake(19,40,280, 280);
        
    }else if([textField isEqualToString:@"TelePhone"]){
        
        self.popoverController.view.frame=CGRectMake(19,10,280, 280);
        
    }else if([textField isEqualToString:@"CallBack"]){
        
        self.popoverController.view.frame=CGRectMake(19,-10,280, 280);  
    }
   
    [UIView commitAnimations];   
}
-(void)textfieldIsEndEditing{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    self.popoverController.view.frame=CGRectMake(19,125,280, 280);
    
    [UIView commitAnimations];
}

- (void) popDoneButtonPressed
{
    
    [self.popoverController dismissPopoverAnimated:YES];
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];

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
    
    ProblemSolutionViewController *problemSolutionViewController = (ProblemSolutionViewController*)[mainStoryboard 
                                                                                                    instantiateViewControllerWithIdentifier:@"ProblemSolutionViewController"];
    
	
    [[self navigationController] pushViewController:problemSolutionViewController animated:YES];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     if ([self searching]) 
     {
     
     [[[self appDelegate] selectedEntities] setContact:[[self filteredContactList] objectAtIndex:[indexPath row]]];
     }
     else 
     {
     
     [[[self appDelegate] selectedEntities] setContact:[[self contactList] objectAtIndex:[indexPath row]]];
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
	
    if (iPad) 
	{
        if (self.popoverController) {
            
            [self.popoverController dismissPopoverAnimated:YES];
            self.popoverController = nil;
            currentPopoverCellIndex = -1;
        } 
        UIViewController *contactVC=[[ContactVerificationViewController alloc]init];
        
        contactVC = (ContactVerificationViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"ContactVerificationViewController"];
        
        self.popoverController = [[popoverClass alloc] initWithContentViewController:contactVC] ;
        
        if ([self.popoverController respondsToSelector:@selector(setContainerViewProperties:)]) 
        {
            [self.popoverController setContainerViewProperties:[self improvedContainerViewProperties]];
        }
        
        self.popoverController.delegate = self;
        self.popoverController.passthroughViews = [NSArray arrayWithObject:self.view];
        CGSize size=CGSizeMake(400,340);
        
        [self.popoverController presentPopoverFromRect:CGRectMake(370,200,0, 0) 
                                                inView:self.view
                              permittedArrowDirections:UIPopoverArrowDirectionUp
                                              animated:YES size:&size];
  }else {
        
        if (self.popoverController) {
            
            [self.popoverController dismissPopoverAnimated:YES];
            self.popoverController = nil;
            currentPopoverCellIndex = -1;
        } 
        UIViewController *contactVC=[[ContactVerificationViewController alloc]init];
        
        contactVC = (ContactVerificationViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"ContactVerificationViewController"];
        
        self.popoverController = [[popoverClass alloc] initWithContentViewController:contactVC] ;
        
        if ([self.popoverController respondsToSelector:@selector(setContainerViewProperties:)]) 
        {
            [self.popoverController setContainerViewProperties:[self improvedContainerViewProperties]];
            
        }
        
        self.popoverController.delegate = self;
        self.popoverController.passthroughViews = [NSArray arrayWithObject:self.view];
        CGSize size=CGSizeMake(280,280);
        
        [self.popoverController presentPopoverFromRect:CGRectMake(160,80,0, 0) 
                                                inView:self.view
                              permittedArrowDirections:UIPopoverArrowDirectionUp
                                              animated:YES size:&size];
        
    }
}
#pragma mark -
#pragma mark WEPopoverControllerDelegate implementation

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
	//Safe to release the popover here
	self.popoverController = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//The popover is automatically dismissed if you click outside it, unless you return NO here
	return YES;
}


-(void)doneBtnPressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
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
    popoverClass = [WEPopoverController class];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	// [self setTitle:@"ServicePlease"];
	// [[self navigationItem] setTitle:@"ServicePlease"];
	
	if (_appDelegate == nil) 
	{
		_appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	}
	
	if (_filteredContactList == nil) 
	{
		_filteredContactList = [[NSMutableArray alloc] init];
	}
	
	[[self tableView] setDelegate:self];
	[[self tableView] setDataSource:self];
	
	[[self searchBar] setDelegate:self];
	
	// [[self tableView] setTableHeaderView:[self searchBar]];
	[[self searchBar] setAutocorrectionType:UITextAutocorrectionTypeNo];
	
	[self setSearching:NO];
	[self setLetUserSelectRow:YES];
}

-(void)dismissPop
{
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
}

-(void)dismissViewController
{
    [[self navigationController] popViewControllerAnimated:YES];	
}

- (void)viewDidUnload
{
    [self.popoverController dismissPopoverAnimated:NO];
	self.popoverController = nil;
    
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
    
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    [appDelegate setCurContactListingVC:self];
    
    [self setContactList:[ServiceHelper getContactsByLocation:[[[[self appDelegate] selectedEntities] location] locationId]]];
	
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
