//
//  TicketMonitorViewController.m
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 12/06/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "TicketMonitorViewController.h"
#import "TicketMonitorViewCell.h"
#import "LocationListingViewController.h"
#import "FilterPopupView.h"
#import "ServiceTechConstants.h"
#import "ProblemSolutionViewController.h"
#import "TicketMoniter.h"
#import "UserRolls.h"
#import "KDListViewController.h"

#import "UserSettingsViewController.h"
#import "Snooze.h"

@implementation TicketMonitorViewController

@synthesize appDelegate = _appDelegate;
@synthesize monitorTableView = _monitorTableView;
@synthesize filteredTicketMonitorList = _filteredTicketMonitorList;
@synthesize actionPopView = _actionPopView;
@synthesize allTicketsMonitorList = _allTicketsMonitorList;
@synthesize filteredTicketList = _filteredTicketList;
@synthesize searchBar = _searchBar;
@synthesize searching = _searching;
@synthesize letUserSelectRow = _letUserSelectRow;
@synthesize moniterScrollView = _moniterScrollView;
@synthesize allLocationList = _allLocationList;
@synthesize currentListofTMRows = _currentListofTMRows;
//@synthesize showAll = _showAll;
@synthesize currentSortingElement = _currentSortingElement;
@synthesize nestedFilteredTMList = _nestedFilteredTMList;
@synthesize custom_KD_popoverView= _custom_KD_popoverView;

@synthesize isCheckedDate;
@synthesize isCheckedQuickShare;
@synthesize datePicker;

@synthesize filtering = _filtering;

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
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        CGRect Scrollframe = _moniterScrollView.frame;
        
        Scrollframe.size.width = 320;
        
        _moniterScrollView.frame  = Scrollframe;
        
        _moniterScrollView.contentSize = CGSizeMake(320 , _moniterScrollView.frame.size.height);
    }
    else 
    {
        
    }
    
    locationToggle = YES;contactToggle = YES;sinceToggle = YES;ticketToggle = YES;
    categorynToggle = YES;techToggle = YES;statusToggle = YES;serviceplanToggle = YES;

    self.nestedFilteredTMList = [[NSMutableArray alloc] init];

    self.moniterScrollView.bounces = NO;
    
    popoverClass     = [WEPopoverController class];
   
    NSUserDefaults * userdefaluts=[NSUserDefaults standardUserDefaults];
    [userdefaluts setBool:NO forKey:@"NoMatchesFound"];
    [userdefaluts synchronize];

}

- (void)viewWillAppear:(BOOL)animated;    // Called when the view is about to made visible. Default does nothing
{
    mainStoryboard = nil;
    iPad = NO;
    
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
        
        UIImage *rightBtnImage=[UIImage imageNamed:@"Settings.png"];
        UIButton *rightNavBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        rightNavBtn.bounds=CGRectMake(0,0,44,44);
        [rightNavBtn setImage:rightBtnImage forState:UIControlStateNormal]; 
        [rightNavBtn addTarget:self action:@selector(settingsAction:) forControlEvents:UIControlEventTouchUpInside];
        rightBtnItem=[[UIBarButtonItem alloc]initWithCustomView:rightNavBtn];
        self.navigationItem.rightBarButtonItem=rightBtnItem;
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
        
        
        UIImage *rightBtnImage=[UIImage imageNamed:@"Settings.png"];
        UIButton *rightNavBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        rightNavBtn.bounds=CGRectMake(0,0,44,44);
        [rightNavBtn setImage:rightBtnImage forState:UIControlStateNormal];
        [rightNavBtn addTarget:self action:@selector(settingsAction:) forControlEvents:UIControlEventTouchUpInside];
        rightBtnItem=[[UIBarButtonItem alloc]initWithCustomView:rightNavBtn];
        self.navigationItem.rightBarButtonItem=rightBtnItem;

        
    }
    
    if (self.actionPopView)
        [self.actionPopView removeFromSuperview];
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    appDelegate.monitorActionButtonState = NO;
    
    [appDelegate setCurTicketMonitorVC:self];
    
    self.allTicketsMonitorList = [[NSMutableArray alloc] init];
    
    self.currentListofTMRows = [[NSMutableArray alloc] init];
    
    [self setFiltering:NO];
    
    [self setCurrentListofTMRows:[self sortingArray:[ServiceHelper getTicketMonitorRows]]];

    if (_filteredTicketList == nil) 
	{
		_filteredTicketList = [[NSMutableArray alloc] init];
	}

    [[self monitorTableView] reloadData];
    
    userRollid=[[[appDelegate selectedEntities]user]userRollId];
    
    alertShowing = NO;

    transparentView.hidden = YES;
    
    NSUserDefaults * userdefaluts=[NSUserDefaults standardUserDefaults];
    bool NoMatchesFound =[userdefaluts boolForKey:@"NoMatchesFound"];
    
    if (!NoMatchesFound) {
        
        if (self.custom_KD_popoverView) {
            
            [self.custom_KD_popoverView dismissPopoverAnimated:YES];
        }
        transparentView.hidden = YES; 
        [userdefaluts setBool:NO forKey:@"NoMatchesFound"];
        [userdefaluts synchronize];
        
    }else {
        transparentView.hidden = NO;  
    }
    soonzeList = [[NSMutableArray alloc] init];
    
    soonzeList = [ServiceHelper getAllSnooze];

    [self techName];
}

-(void)techName
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [appDelegate.techNameList removeAllObjects];
    
    for (int i = 0; i < [self.currentListofTMRows count]; i++)
    {
        TicketMoniter *curTicket = [self.currentListofTMRows objectAtIndex:i];
        
        for (int j = 0; j < [soonzeList count]; j++)
        {
            Snooze *snooze = [soonzeList objectAtIndex:j];
            
            if ([snooze.ticketId isEqualToString:curTicket.ticketTicketId])
            {
                NSLog(@"techName = %@",curTicket.ticketTech);
                
                [appDelegate.techNameList addObject:curTicket.ticketTech];
            }
        }
    }
}

-(void)leftNavBtnPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)showAll:(id)sender
{
    //NSLog(@"showAll");
    
    if (self.actionPopView)
        [self.actionPopView removeFromSuperview];
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    appDelegate.monitorActionButtonState = NO;
    
    self.allTicketsMonitorList = [[NSMutableArray alloc] init];
    
    self.currentListofTMRows = [[NSMutableArray alloc] init];
    
    [self setNestedFilteredTMList:self.currentListofTMRows];
    
    [self setFiltering:NO];

    [self setCurrentListofTMRows:[self sortingArray:[ServiceHelper getTicketMonitorRows]]];
    
    if (_filteredTicketList == nil) 
	{
		_filteredTicketList = [[NSMutableArray alloc] init];
	}
    
    [[self monitorTableView] reloadData];
}

-(void)parseTheTicketMonitorResult
{
    
    
}

- (void)viewDidUnload
{
    transparentView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


-(void)createActionPopView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        self.actionPopView = [[UIView alloc] initWithFrame:CGRectMake(40, 148, 100, 217)];
    }
    else
    {
        self.actionPopView = [[UIView alloc] initWithFrame:CGRectMake(205, 696, 100, 217)];
    }

    UIImage *buttonBG = [UIImage imageNamed:@"btn-blue-off.png"];
    
    UIButton *new = [UIButton buttonWithType:UIButtonTypeCustom];
    [new addTarget:self  action:@selector(actionNewButtonWasPressed:) forControlEvents:UIControlEventTouchDown];
    [new setBackgroundImage:buttonBG forState:UIControlStateNormal];
    [new setTitle:@"New" forState:UIControlStateNormal];
    new.frame = CGRectMake(0, 0, 100.0, 37);
    [self.actionPopView addSubview:new];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close addTarget:self  action:@selector(actionCloseButtonWasPressed:) forControlEvents:UIControlEventTouchDown];
    [close setTitle:@"Close" forState:UIControlStateNormal];
    [close setBackgroundImage:buttonBG forState:UIControlStateNormal];
    close.frame = CGRectMake(0, 38, 100.0, 37);
    [self.actionPopView addSubview:close];
    
    UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
    [edit addTarget:self  action:@selector(actionEditButtonWasPressed:) forControlEvents:UIControlEventTouchDown];
    [edit setTitle:@"Edit" forState:UIControlStateNormal];
    [edit setBackgroundImage:buttonBG forState:UIControlStateNormal];
    edit.frame = CGRectMake(0, 75, 100.0, 37);;
    [self.actionPopView addSubview:edit];
    
    UIButton *append = [UIButton buttonWithType:UIButtonTypeCustom];
    [append addTarget:self  action:@selector(actionAppendButtonWasPressed:) forControlEvents:UIControlEventTouchDown];
    [append setTitle:@"Append" forState:UIControlStateNormal];
    [append setBackgroundImage:buttonBG forState:UIControlStateNormal];
    append.frame = CGRectMake(0, 112, 100.0, 37);
    [self.actionPopView addSubview:append];
    
    UIButton *assign = [UIButton buttonWithType:UIButtonTypeCustom];
    [assign addTarget:self  action:@selector(actionAssignButtonWasPressed:) forControlEvents:UIControlEventTouchDown];
    [assign setTitle:@"Assign" forState:UIControlStateNormal];
    [assign setBackgroundImage:buttonBG forState:UIControlStateNormal];
    assign.frame = CGRectMake(0, 149, 100.0, 37);
    [self.actionPopView addSubview:assign];
    
    UIButton *snooze = [UIButton buttonWithType:UIButtonTypeCustom];
    [snooze addTarget:self  action:@selector(actionSnoozeButtonWasPressed:) forControlEvents:UIControlEventTouchDown];
    [snooze setTitle:@"Snooze" forState:UIControlStateNormal];
    [snooze setBackgroundImage:buttonBG forState:UIControlStateNormal];
    snooze.frame = CGRectMake(0, 186, 100.0, 37);
    [self.actionPopView addSubview:snooze];
    
    
    
    if([_monitorTableView indexPathForSelectedRow] == nil)
    {
        new.userInteractionEnabled = YES;
        [close setEnabled:FALSE];
        [edit setEnabled:FALSE];
        [append setEnabled:FALSE];
        [assign setEnabled:FALSE];
        [snooze setEnabled:FALSE];
    }
    else
    {
        new.userInteractionEnabled = YES;
        close.userInteractionEnabled = YES;
        edit.userInteractionEnabled = YES;
        append.userInteractionEnabled = YES;
        assign.userInteractionEnabled = YES;
        snooze.userInteractionEnabled = YES;
        
        TicketMoniter *curTicket;
        
        if ([self searching]) // if selected row while in searching
        {
            int count = [self.filteredTicketList count];
            
            if (count > 0)
            {
                curTicket =  [self.filteredTicketList objectAtIndex:self.appDelegate.currentTicketMonitorSelected];
            }
        }
        else
        {
            int count = [self.currentListofTMRows count];
            
            if (count > 0)
            {
                
                curTicket =  [self.currentListofTMRows objectAtIndex:self.appDelegate.currentTicketMonitorSelected];
            }
            
        }
        
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
        NSLog(@"userid = %@",[[appDelegate selectedEntities] user].userId);
        
        NSString *userResponseRollid=[ServiceHelper getUserRollid:[[appDelegate selectedEntities] user].userId];
        
        if ([ST_User_Role_TECH isEqualToString:userResponseRollid] || [ST_User_Role_TECH_SUPER isEqualToString:userResponseRollid])
        {
            [assign setEnabled:FALSE];
        }
        else if([curTicket.ticketTech isEqualToString:@"No Tech/Blank"])
        {
            [assign setEnabled:TRUE];
        }
        else 
        {
            [assign setEnabled:FALSE];
        }
    }
}


- (IBAction)actionButtonWasPressed:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if (!appDelegate.monitorActionButtonState) {
        
        appDelegate.monitorActionButtonState = YES;
        
        [self createActionPopView];

        CATransition *animation = [CATransition animation];
        [animation setDuration:0.5];
        [animation setType:kCATransitionMoveIn];
        [animation setSubtype:kCATransitionFromTop];
        
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.actionPopView.layer addAnimation:animation forKey:@"flipping view"];
        
        [self.view addSubview:self.actionPopView];
        
        appDelegate.monitorActionPopupView = self.actionPopView;
        
        [UIView commitAnimations];

    }else {

        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
        appDelegate.monitorActionButtonState = NO;

        [appDelegate.monitorActionPopupView removeFromSuperview];
        if (snoozeOptionView != nil)
        {
            [snoozeOptionView removeFromSuperview];
            snoozeOptionView = nil;
        }
    }
}

- (IBAction)problemSolutionButtonWasPressed:(id)sender
{
    if(![self.monitorTableView indexPathForSelectedRow])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select a row from the list and then click it." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }else 
    {
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
        
        appDelegate.filterPro_SolTicket = YES;
        [appDelegate setNewTicketCreationProcess:NO];
        [appDelegate setIfticketRowselectedAndnewBtnPressed:NO];
        
        ProblemSolutionViewController *problemSolutionViewController = (ProblemSolutionViewController*)[mainStoryboard 
                                                                                                        instantiateViewControllerWithIdentifier:@"ProblemSolutionViewController"];
        
        [[self navigationController] pushViewController:problemSolutionViewController animated:YES]; 
        
    }
}

- (IBAction)filterButtonWasPressed:(id)sender
{
 
}

- (IBAction)actionNewButtonWasPressed:(id)sender
{
    
    TicketMoniter *curTMObj;
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];

    
    if([_monitorTableView indexPathForSelectedRow] != nil) 
    {
        if ([self.currentListofTMRows count] > 0) {
            
            curTMObj = [self.currentListofTMRows objectAtIndex:[_monitorTableView indexPathForSelectedRow].row];
          
            [[[self appDelegate] selectedEntities] setTicketMonitor:curTMObj];
            
            Location *loc = (Location *)[ServiceHelper getLocation:curTMObj.ticketLocationId];
            
            [[[self appDelegate] selectedEntities] setLocation:loc];
            
            Contact *contact =  (Contact *)[ServiceHelper getContact:curTMObj.ticketContactId];
            
            [[[self appDelegate] selectedEntities] setContact:contact];
        }
        
        [appDelegate setNewTicketCreationProcess:YES];
        [appDelegate setIfticketRowselectedAndnewBtnPressed:YES];
        
        ProblemSolutionViewController *problemSolutionViewController = (ProblemSolutionViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"ProblemSolutionViewController"];
        
        [[self navigationController] pushViewController:problemSolutionViewController animated:YES]; 
    }
    else 
    {
        if ([self.currentListofTMRows count] > 0) {
            
            curTMObj = [self.currentListofTMRows objectAtIndex:[_monitorTableView indexPathForSelectedRow].row];
        }
        [appDelegate setNewTicketCreationProcess:YES];
        [appDelegate setIfticketRowselectedAndnewBtnPressed:NO];
        
        LocationListingViewController *locationListingViewController = (LocationListingViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"LocationListingController"];
        
        [[self navigationController] pushViewController:locationListingViewController animated:YES];
    }   
}
- (IBAction)actionCloseButtonWasPressed:(id)sender
{
    
   
}
- (IBAction)actionEditButtonWasPressed:(id)sender
{
    
	
}
- (IBAction)actionAppendButtonWasPressed:(id)sender
{
    
}

- (IBAction)actionAssignButtonWasPressed:(id)sender
{    
    if (self.actionPopView)
        [self.actionPopView removeFromSuperview];
    
    if (snoozeOptionView != nil)
    {
        [snoozeOptionView removeFromSuperview];
        snoozeOptionView = nil;
    }


    NSMutableArray *listOfContacts = [ServiceHelper getUsers];
    
    [self.appDelegate setFilterListOfTechs:listOfContacts];
    
       
    [self.appDelegate setCurrentTMFilter:TECH_FILTER];
        
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        filterPopupView = (FilterPopupView*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FilterPopupView"];
        
        [filterPopupView setTechDelegate:self];
        
        CGRect frame = filterPopupView.view.frame;
        
        frame.origin.y = 0;
        
        filterPopupView.view.frame = frame;

        [self.view addSubview:filterPopupView.view];
    }
    else 
    {
        if(![popoverController isPopoverVisible]){
            
            filterPopupView = (FilterPopupView*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FilterPopupView"];
            
            [filterPopupView setTechDelegate:self];

            popoverController = [[UIPopoverController alloc] initWithContentViewController:filterPopupView] ;
                        
            [filterPopupView setRootPopUpViewController:popoverController];
            
            [popoverController setPopoverContentSize:CGSizeMake(300.0f, 400.0f)];

            CGRect frameSize = CGRectMake(140, 0, 500, 250);

            [popoverController presentPopoverFromRect:frameSize inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
        }else{
            
            [popoverController dismissPopoverAnimated:YES];
        }
    }
}
-(void)dismissPopover
{
    [popoverController dismissPopoverAnimated:YES];
    popoverController = nil;   
}


-(void)TechSelected:(Tech *)techOhj 
{     
    if (techOhj != nil) 
    {
        tech = techOhj;
    }
    
    if ([self.currentListofTMRows count] > 0) {
        
        TicketMoniter *curTicket = [self.currentListofTMRows objectAtIndex:(int)[self.monitorTableView indexPathForSelectedRow].row];
        
        if ([curTicket.ticketUserId isEqualToString:@"deb4fcaf-63b9-402e-9fb0-f2a0df76aafc"])  // no tech userid
        {
            [ServiceHelper assignTicket:curTicket.ticketTicketId andTechid:tech.userId];
            [self showAll:nil];
            
            //If an un-assigned ticket that has been sitting in the ticket monitor and finally gets assigned to a tech by customer service, a text notification shall go out to that tech only.
            
            NSString *userResponseRollid=[ServiceHelper getUserRollid:[tech userId]];
            
            AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            
            if (userResponseRollid!=nil) 
            {
                
                if ([ST_User_Role_TECH isEqualToString:userResponseRollid] || [ST_User_Role_TECH_SUPER isEqualToString:userResponseRollid]) 
                {
                    // Assigned to tech... send notification  // point 3   
                    
                    NSMutableString *message = [[NSMutableString alloc] initWithString:@""];
                    [message appendString:@"Location:"];
                    [message appendFormat:@"%@",[[appDelegate selectedEntities] location].locationName];
                    [message appendString:@",Contact:"];
                    [message appendFormat:@"%@",[[appDelegate selectedEntities] contact].contactName];
                    [message appendString:@",CallbackNum:"];
                    [message appendFormat:@"%@",[[appDelegate selectedEntities] contact].callBackNum];
                    
                    NSLog(@"message = %@",message);
                    
                    NSString *response = [ServiceHelper sendTextNotificationPhoneDestination:@"17077877855" Message:message CustomerNickname:@"VALET" Username:@"valetplease" Password:@"vp0209"];
                    
                    NSLog(@"response=%@",response);
                    
                    
                }
            }  
        }
        
        if (self.actionPopView)
        {
            [UIView animateWithDuration:1.0 animations:^{
                self.actionPopView.alpha = 1.0; self.actionPopView.alpha = 0.0;
            } completion:^(BOOL success) {
                if (success) {
                    [self.actionPopView removeFromSuperview];
                }
            }];
            
        }
    }
}


-(void)showallFilterServiceFinished:(NSString *)Ids
{
    NSMutableArray *currentFilteredArray = [[NSMutableArray alloc]init];
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    switch (self.appDelegate.currentTMFilter) {
            
        case LOCATION_FILTER:
        {
            NSMutableArray *filterLocationsTM = [ServiceHelper getTicketMonitorRowsByLocations:Ids];
            currentFilteredArray = filterLocationsTM;
        }
            break;
        case CONTACT_FILTER:
        {
            NSMutableArray *filterContactsTM = [ServiceHelper getticketMonitorRowsByContactId:Ids];
            currentFilteredArray = filterContactsTM;
        }
            break;
        case CATEGORY_FILTER:
        {
            NSMutableArray *filterCategoriesTM = [ServiceHelper getticketMonitorRowsByCategory:Ids];
            currentFilteredArray = filterCategoriesTM;
        }
            break;
        case TECH_FILTER:
        {
            NSMutableArray *filterTechTM = [ServiceHelper getticketMonitorRowsByUserId:Ids];
            currentFilteredArray = filterTechTM;
        }
            break;
        case STATUS_FILTER:
        {
            NSMutableArray *filterstatusTM = [ServiceHelper getTicketMonitorRowsByStatus:Ids];
            currentFilteredArray = filterstatusTM;
        }
            break;
        case SINCE_FILTER:
        {
            NSMutableArray *filterstatusTM = [ServiceHelper getTicketMonitorRowsByTE:Ids];
            currentFilteredArray = filterstatusTM;
        }
            break;
        case SERVICEPLAN_FILTER:
        {
            NSMutableArray *filterServicePlanTM = [ServiceHelper getticketMonitorRowsByServicePlanTypeIds:Ids];
            currentFilteredArray = filterServicePlanTM;
        }
            break;
            
        default:
            break;
    }    
    
    if ([currentFilteredArray count]>0) 
    {
        [self setCurrentListofTMRows:[self sortingArray:currentFilteredArray]];
        
        [self setNestedFilteredTMList:currentFilteredArray];
        
        [[self monitorTableView] reloadData];
        
    }
    else 
    {
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"Alert" message:ST_TM_No_Rows delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertV show];
    }
}

-(void)filterServiceFinished:(NSString *)Ids
{
    if (Ids == nil)
    {
        int tempCount = [self.nestedFilteredTMList count];
      
        if (tempCount > 0) {
            
            [self setCurrentListofTMRows:[self sortingArray:self.nestedFilteredTMList]];
            
            [[self monitorTableView] reloadData];
        }
        return;
    }
    NSMutableArray *currentFilteredArray = [[NSMutableArray alloc]init];
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    switch (self.appDelegate.currentTMFilter) {
            
        case LOCATION_FILTER:
        {
            NSMutableArray *filterLocationsTM = [ServiceHelper getTicketMonitorRowsByLocations:Ids];
            currentFilteredArray = filterLocationsTM;
        }
            break;
        case CONTACT_FILTER:
        {
            NSMutableArray *filterContactsTM = [ServiceHelper getticketMonitorRowsByContactId:Ids];
            currentFilteredArray = filterContactsTM;
        }
            break;
        case CATEGORY_FILTER:
        {
            NSMutableArray *filterCategoriesTM = [ServiceHelper getticketMonitorRowsByCategory:Ids];
            currentFilteredArray = filterCategoriesTM;
        }
            break;
        case TECH_FILTER:
        {
            NSMutableArray *filterTechTM = [ServiceHelper getticketMonitorRowsByUserId:Ids];
            currentFilteredArray = filterTechTM;
        }
            break;
            
        case STATUS_FILTER:
        {
            NSMutableArray *filterstatusTM = [ServiceHelper getTicketMonitorRowsByStatus:Ids];
            currentFilteredArray = filterstatusTM;
        }
            break;
        case SINCE_FILTER:
        {
            NSMutableArray *filterstatusTM = [ServiceHelper getTicketMonitorRowsByTE:Ids];
            currentFilteredArray = filterstatusTM;
        }
            break;
        case SERVICEPLAN_FILTER:
        {
            NSMutableArray *filterServicePlanTM = [ServiceHelper getticketMonitorRowsByServicePlanTypeIds:Ids];
            currentFilteredArray = filterServicePlanTM;
        }
            break;
            
        default:
            break;
    }    
    
    if ([currentFilteredArray count]>0) {
        
        if([self.nestedFilteredTMList count] > 0)
        {            
            NSMutableArray *tempNestedArray = [[NSMutableArray alloc] init];
            
            NSMutableArray *duplicatesremoved = [[NSMutableArray alloc] init];
            
            NSMutableArray *currentFilteredElements = [[NSMutableArray alloc] init];
            
            switch (self.appDelegate.currentTMFilter)
            {
                case LOCATION_FILTER:
                {
                    for (int k = 0;k < [currentFilteredArray count] ; k++) 
                    {
                        [currentFilteredElements addObject:[(TicketMoniter *)[currentFilteredArray objectAtIndex:k] ticketLocation]];
                    }
                    [duplicatesremoved addObjectsFromArray:[[NSSet setWithArray:currentFilteredElements] allObjects]];
                    
                    for (int k = 0;k < [duplicatesremoved count] ; k++) 
                    {
                        for(TicketMoniter *ticketMoniter in self.nestedFilteredTMList)
                        {
                            if ([[duplicatesremoved objectAtIndex:k] isEqual:[ticketMoniter ticketLocation]])
                            {
                                [tempNestedArray addObject:ticketMoniter];
                            }
                        }
                    }
                }
                    break;
                case CONTACT_FILTER:
                {
                    for (int k = 0;k < [currentFilteredArray count] ; k++) 
                    {
                        [currentFilteredElements addObject:[(TicketMoniter *)[currentFilteredArray objectAtIndex:k] ticketContact]];
                    }
                    [duplicatesremoved addObjectsFromArray:[[NSSet setWithArray:currentFilteredElements] allObjects]];
                    
                    for (int k = 0;k < [duplicatesremoved count] ; k++) 
                    {
                        for(TicketMoniter *ticketMoniter in self.nestedFilteredTMList)
                        {
                            if ([[duplicatesremoved objectAtIndex:k] isEqual:[ticketMoniter ticketContact]])
                            {
                                [tempNestedArray addObject:ticketMoniter];
                            }
                        }
                    }
                }
                    break;
                case SINCE_FILTER:
                {
                    for (int k = 0;k < [currentFilteredArray count] ; k++) 
                    {
                        [currentFilteredElements addObject:[(TicketMoniter *)[currentFilteredArray objectAtIndex:k] ticketElapsed]];
                    }
                    [duplicatesremoved addObjectsFromArray:[[NSSet setWithArray:currentFilteredElements] allObjects]];
                    
                    for (int k = 0;k < [duplicatesremoved count] ; k++) 
                    {
                        for(TicketMoniter *ticketMoniter in self.nestedFilteredTMList)
                        {
                            if ([[duplicatesremoved objectAtIndex:k] isEqual:[ticketMoniter ticketElapsed]])
                            {
                                [tempNestedArray addObject:ticketMoniter];
                            }
                        }
                    }
                }
                    break;
                case TICKET_FILTER:
                {
                    for (int k = 0;k < [currentFilteredArray count] ; k++) 
                    {
                        [currentFilteredElements addObject:[(TicketMoniter *)[currentFilteredArray objectAtIndex:k] ticketTicketNumber]];
                    }
                    [duplicatesremoved addObjectsFromArray:[[NSSet setWithArray:currentFilteredElements] allObjects]];
                    
                    for (int k = 0;k < [duplicatesremoved count] ; k++) 
                    {
                        for(TicketMoniter *ticketMoniter in self.nestedFilteredTMList)
                        {
                            if ([[duplicatesremoved objectAtIndex:k] isEqual:[ticketMoniter ticketTicketNumber]])
                            {
                                [tempNestedArray addObject:ticketMoniter];
                            }
                        }
                    }
                }
                    break;
                case CATEGORY_FILTER:
                {
                    for (int k = 0;k < [currentFilteredArray count] ; k++) 
                    {
                        [currentFilteredElements addObject:[(TicketMoniter *)[currentFilteredArray objectAtIndex:k] ticketCategory]];
                    }
                    [duplicatesremoved addObjectsFromArray:[[NSSet setWithArray:currentFilteredElements] allObjects]];
                    
                    for (int k = 0;k < [duplicatesremoved count] ; k++) 
                    {
                        for(TicketMoniter *ticketMoniter in self.nestedFilteredTMList)
                        {
                            if ([[duplicatesremoved objectAtIndex:k] isEqual:[ticketMoniter ticketCategory]])
                            {
                                [tempNestedArray addObject:ticketMoniter];
                            }
                        }
                    }
                }
                    break;
                case TECH_FILTER:
                {
                    for (int k = 0;k < [currentFilteredArray count] ; k++) 
                    {
                        [currentFilteredElements addObject:[(TicketMoniter *)[currentFilteredArray objectAtIndex:k] ticketTech]];
                    }
                    [duplicatesremoved addObjectsFromArray:[[NSSet setWithArray:currentFilteredElements] allObjects]];
                    
                    for (int k = 0;k < [duplicatesremoved count] ; k++) 
                    {
                        for(TicketMoniter *ticketMoniter in self.nestedFilteredTMList)
                        {
                            if ([[duplicatesremoved objectAtIndex:k] isEqual:[ticketMoniter ticketTech]])
                            {
                                [tempNestedArray addObject:ticketMoniter];
                            }
                        }
                    }
                }
                    break;
                case STATUS_FILTER:
                {
                    for (int k = 0;k < [currentFilteredArray count] ; k++) 
                    {
                        [currentFilteredElements addObject:[(TicketMoniter *)[currentFilteredArray objectAtIndex:k] ticketStatus]];
                    }
                    [duplicatesremoved addObjectsFromArray:[[NSSet setWithArray:currentFilteredElements] allObjects]];
                    
                    for (int k = 0;k < [duplicatesremoved count] ; k++) 
                    {
                        for(TicketMoniter *ticketMoniter in self.nestedFilteredTMList)
                        {
                            if ([[duplicatesremoved objectAtIndex:k] isEqual:[ticketMoniter ticketStatus]])
                            {
                                [tempNestedArray addObject:ticketMoniter];
                            }
                        }
                    }
                }
                    break;
                case SERVICEPLAN_FILTER:
                {
                    for (int k = 0;k < [currentFilteredArray count] ; k++) 
                    {
                        [currentFilteredElements addObject:[(TicketMoniter *)[currentFilteredArray objectAtIndex:k] ticketServicePlan]];
                    }
                    [duplicatesremoved addObjectsFromArray:[[NSSet setWithArray:currentFilteredElements] allObjects]];
                    
                    for (int k = 0;k < [duplicatesremoved count] ; k++) 
                    {
                        for(TicketMoniter *ticketMoniter in self.nestedFilteredTMList)
                        {
                            if ([[duplicatesremoved objectAtIndex:k] isEqual:[ticketMoniter ticketServicePlan]])
                            {
                                [tempNestedArray addObject:ticketMoniter];
                            }
                        }
                    }
                }
                    break;
                    
                default:
                    break;
            }
            if ([tempNestedArray count] == 0)
            {
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"Alert" message:ST_TM_No_Rows delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertV show];
            }
            if ([tempNestedArray count] > 0)
            {
                [self setNestedFilteredTMList:tempNestedArray];
                
                [self setCurrentListofTMRows:[self sortingArray:self.nestedFilteredTMList]];  
            }
            
            [self setFiltering:YES];
        }
        else 
        {     
            if (!self.filtering) 
            {
                [self setCurrentListofTMRows:[self sortingArray:currentFilteredArray]];
                
                [self setNestedFilteredTMList:currentFilteredArray];
            }
            
            [self setFiltering:YES];
        }
        
    [[self monitorTableView] reloadData];
        
    }else {
        
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"Alert" message:ST_TM_No_Rows delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertV show];
    }
}

-(void)selectRowAndPressTitle
{    
    [self setNestedFilteredTMList:self.currentListofTMRows];
    
    NSLog(@"currentListofTMRows =  %d",[self.currentListofTMRows count]);
    
    if ([self.nestedFilteredTMList count] > 0)
    {
        NSMutableArray *tempNestedArray = [[NSMutableArray alloc] init];
        
        TicketMoniter *ticketMoniterRow = [self.currentListofTMRows objectAtIndex:[self.monitorTableView indexPathForSelectedRow].row];
        
        switch (self.currentSortingElement)
        {
            case LOCATION_ELEMENT:
            {                
                for(TicketMoniter *ticketMoniter in self.nestedFilteredTMList)
                {
                    if ([ticketMoniterRow.ticketLocation isEqual:[ticketMoniter ticketLocation]])
                    {
                        [tempNestedArray addObject:ticketMoniter];
                    }
                }
            }
                break;
            case CONTACT_ELEMENT:
            {
                for(TicketMoniter *ticketMoniter in self.nestedFilteredTMList)
                {
                    if ([ticketMoniterRow.ticketContact isEqual:[ticketMoniter ticketContact]])
                    {
                        [tempNestedArray addObject:ticketMoniter];
                    }
                }
            }
                break;
            case SINCE_ELEMENT:
            {
                for(TicketMoniter *ticketMoniter in self.nestedFilteredTMList)
                {
                    if ([ticketMoniterRow.ticketElapsed isEqual:[ticketMoniter ticketElapsed]])
                    {
                        [tempNestedArray addObject:ticketMoniter];
                    }
                }
            }
                break;
            case TICKET_ELEMENT:
            {
                for(TicketMoniter *ticketMoniter in self.nestedFilteredTMList)
                {
                    if ([ticketMoniterRow.ticketTicketNumber isEqual:[ticketMoniter ticketTicketNumber]])
                    {
                        [tempNestedArray addObject:ticketMoniter];
                    }
                }
            }
                break;
            case CATEGORY_ELEMENT:
            {
                for(TicketMoniter *ticketMoniter in self.nestedFilteredTMList)
                {
                    if ([ticketMoniterRow.ticketCategory isEqual:[ticketMoniter ticketCategory]])
                    {
                        [tempNestedArray addObject:ticketMoniter];
                    }
                }
            }
                break;
            case TECH_ELEMENT:
            {
                for(TicketMoniter *ticketMoniter in self.nestedFilteredTMList)
                {
                    if ([ticketMoniterRow.ticketTech isEqual:[ticketMoniter ticketTech]])
                    {
                        [tempNestedArray addObject:ticketMoniter];
                    }
                }
            }
                break;
            case STATUS_ELEMENT:
            {
                for(TicketMoniter *ticketMoniter in self.nestedFilteredTMList)
                {
                    if ([ticketMoniterRow.ticketStatus isEqual:[ticketMoniter ticketStatus]])
                    {
                        [tempNestedArray addObject:ticketMoniter];
                    }
                }
            }
                break;
            case SERVICEPLAN_ELEMENT:
            {
                for(TicketMoniter *ticketMoniter in self.nestedFilteredTMList)
                {
                    if ([ticketMoniterRow.ticketServicePlan isEqual:[ticketMoniter ticketServicePlan]])
                    {
                        [tempNestedArray addObject:ticketMoniter];
                    }
                }
            }
                break;
                
            default:
                break;
        }
        [self setNestedFilteredTMList:tempNestedArray];
        [self setCurrentListofTMRows:[self sortingArray:self.nestedFilteredTMList]];
        NSLog(@"currentListofTMRows =  %d",[self.currentListofTMRows count]);
        
        [[self monitorTableView] reloadData];
    }
}


#pragma mark Button UIControl Actions
- (IBAction) touchDown:(id)sender
{
    if ([sender tag] == 1) 
    {
        [self performSelector:@selector(locationSorting:) withObject:sender afterDelay:0.2];
    }
    else if ([sender tag] == 2) 
    {
        [self performSelector:@selector(contactSorting:) withObject:sender afterDelay:0.2];
    }
    else if ([sender tag] == 3) 
    {
        [self performSelector:@selector(sinceSorting:) withObject:sender afterDelay:0.2];
    }
    else if ([sender tag] == 4) 
    {
        [self performSelector:@selector(ticketSorting:) withObject:sender afterDelay:0.2];
    }
    else if ([sender tag] == 5) 
    {
        [self performSelector:@selector(categorySorting:) withObject:sender afterDelay:0.2];
    }
    else if ([sender tag] == 6) 
    {
        [self performSelector:@selector(techSorting:) withObject:sender afterDelay:0.2];
    }
    else if ([sender tag] == 7) 
    {
        [self performSelector:@selector(statusSorting:) withObject:sender afterDelay:0.2];
    }
    else if ([sender tag] == 8) 
    {
        [self performSelector:@selector(serviceplanSorting:) withObject:sender afterDelay:0.2];
    }
}

- (IBAction) touchDownRepeat:(id)sender
{
    //NSLog(@"Touch Down Repeat");
    
    if ([sender tag] == 1) 
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(locationSorting:) object:sender];
        [self LocationButtonFiltered:sender];
    }
    else if ([sender tag] == 2) 
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(contactSorting:) object:sender];
        [self ContactButtonFiltered:sender];
    }
    else if ([sender tag] == 3) 
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sinceSorting:) object:sender];
        [self TimeElapsedButtonFiltered:sender];
    }
    else if ([sender tag] == 4) 
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(ticketSorting:) object:sender];
    }
    else if ([sender tag] == 5) 
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(categorySorting:) object:sender];
        [self CategoryButtonFiltered:sender];
    }
    else if ([sender tag] == 6) 
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(techSorting:) object:sender];
    	[self TechButtonFiltered:sender];
    }
    else if ([sender tag] == 7) 
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(statusSorting:) object:sender];
        [self StatusButtonFiltered:sender];
    }
    else if ([sender tag] == 8) 
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(serviceplanSorting:) object:sender];
        [self ServicePlanButtonFiltered:sender];
    }
}


- (IBAction)LocationButtonFiltered:(id)sender
{
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSMutableArray *listOfLocations = [ServiceHelper getLocations];
    
    [self.appDelegate setFilterListOfLocations:listOfLocations];
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [self.appDelegate setCurrentTMFilter:LOCATION_FILTER];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        filterPopupView = (FilterPopupView*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FilterPopupView"];
        
        [filterPopupView setFilterDelegate:self];
        
        CGRect frame = filterPopupView.view.frame;
        
        frame.origin.y = 0;
        
        filterPopupView.view.frame = frame;

        [self.view addSubview:filterPopupView.view];
    }
    else 
    {
        if(![popoverController isPopoverVisible]){
            
            filterPopupView = (FilterPopupView*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FilterPopupView"];
            
            [filterPopupView setFilterDelegate:self];

            popoverController = [[UIPopoverController alloc] initWithContentViewController:filterPopupView] ;
            
            [filterPopupView setRootPopUpViewController:popoverController];
            [popoverController setPopoverContentSize:CGSizeMake(300.0f, 400.0f)];
            [popoverController presentPopoverFromRect:locationFilterBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
        }else{
            
            [popoverController dismissPopoverAnimated:YES];
        }
    }
}

- (IBAction)ContactButtonFiltered:(id)sender
{
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSMutableArray *listOfContacts = [ServiceHelper getContacts];
    
    [self.appDelegate setFilterListOfContacts:listOfContacts];
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [self.appDelegate setCurrentTMFilter:CONTACT_FILTER];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        filterPopupView = (FilterPopupView*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FilterPopupView"];
        
        [filterPopupView setFilterDelegate:self];
        
        CGRect frame = filterPopupView.view.frame;
        
        frame.origin.y = 0;
        
        filterPopupView.view.frame = frame;

        [self.view addSubview:filterPopupView.view];
    }
    else 
    {
        if(![popoverController isPopoverVisible]){
            
            filterPopupView = (FilterPopupView*)[mainStoryboard 
                                                 instantiateViewControllerWithIdentifier:@"FilterPopupView"];
            
            [filterPopupView setFilterDelegate:self];

            popoverController = [[UIPopoverController alloc] initWithContentViewController:filterPopupView] ;
            
            [filterPopupView setRootPopUpViewController:popoverController];
            [popoverController setPopoverContentSize:CGSizeMake(300.0f, 400.0f)];
            [popoverController presentPopoverFromRect:contactFilterBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
        }else{
            
            [popoverController dismissPopoverAnimated:YES];
        }
    }

}
- (IBAction)TimeElapsedButtonFiltered:(id)sender
{
    NSLog(@"nestedFilteredTMList =  %d",[self.nestedFilteredTMList count]);
    
    if ([self.nestedFilteredTMList count] == 0)
    {
        self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
        [self.appDelegate setCurrentTMFilter:SINCE_FILTER];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            filterPopupView = (FilterPopupView*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FilterPopupView"];
            
            [filterPopupView setFilterDelegate:self];
            
            CGRect frame = filterPopupView.view.frame;
            
            frame.origin.y = 0;
            
            filterPopupView.view.frame = frame;
            
            [self.view addSubview:filterPopupView.view];
        }
        else
        {
            if(![popoverController isPopoverVisible]){
                
                filterPopupView = (FilterPopupView*)[mainStoryboard
                                                     instantiateViewControllerWithIdentifier:@"FilterPopupView"];
                
                [filterPopupView setFilterDelegate:self];
                
                popoverController = [[UIPopoverController alloc] initWithContentViewController:filterPopupView] ;
                
                [filterPopupView setRootPopUpViewController:popoverController];
                [popoverController setPopoverContentSize:CGSizeMake(300.0f, 400.0f)];
                
                [popoverController presentPopoverFromRect:timeElapsedFilterBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
                
            }else{
                
                [popoverController dismissPopoverAnimated:YES];
            }
        }

    }
    
}
- (IBAction)CategoryButtonFiltered:(id)sender
{
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
    NSMutableArray *listOfCats = [ServiceHelper getAllCategories];
        
    [self.appDelegate setFilterListOfCategories:listOfCats];

    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [self.appDelegate setCurrentTMFilter:CATEGORY_FILTER];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        filterPopupView = (FilterPopupView*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FilterPopupView"];
        
        [filterPopupView setFilterDelegate:self];
        
        CGRect frame = filterPopupView.view.frame;
        
        frame.origin.y = 0;
        
        filterPopupView.view.frame = frame;

        [self.view addSubview:filterPopupView.view];
    }
    else 
    {
        if(![popoverController isPopoverVisible]){
            
            filterPopupView = (FilterPopupView*)[mainStoryboard 
                                                 instantiateViewControllerWithIdentifier:@"FilterPopupView"];
            
            [filterPopupView setFilterDelegate:self];

            popoverController = [[UIPopoverController alloc] initWithContentViewController:filterPopupView] ;
            
            [filterPopupView setRootPopUpViewController:popoverController];
            [popoverController setPopoverContentSize:CGSizeMake(300.0f, 400.0f)];
            
            [popoverController presentPopoverFromRect:categoryFilterBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
        }else{
            
            [popoverController dismissPopoverAnimated:YES];
        }
    }
}
- (IBAction)TechButtonFiltered:(id)sender
{
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSMutableArray *listOfContacts = [ServiceHelper getUsers];
    
    [self.appDelegate setFilterListOfTechs:listOfContacts];
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [self.appDelegate setCurrentTMFilter:TECH_FILTER];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        filterPopupView = (FilterPopupView*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FilterPopupView"];
        
        [filterPopupView setFilterDelegate:self];
        
        CGRect frame = filterPopupView.view.frame;
        
        frame.origin.y = 0;
        
        filterPopupView.view.frame = frame;

        [self.view addSubview:filterPopupView.view];
    }
    else 
    {
        if(![popoverController isPopoverVisible]){
            
            filterPopupView = (FilterPopupView*)[mainStoryboard 
                                                 instantiateViewControllerWithIdentifier:@"FilterPopupView"];
            
            [filterPopupView setFilterDelegate:self];

            popoverController = [[UIPopoverController alloc] initWithContentViewController:filterPopupView] ;
                        
            [filterPopupView setRootPopUpViewController:popoverController];
            [popoverController setPopoverContentSize:CGSizeMake(300.0f, 400.0f)];
            
            // Or use the following line to display it from a given rectangle
            //CGRectMake(0, 60, 10, 10)
            [popoverController presentPopoverFromRect:techFilterBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
        }else{
            
            [popoverController dismissPopoverAnimated:YES];
        }
    }
 
}
- (IBAction)StatusButtonFiltered:(id)sender
{
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [self.appDelegate setCurrentTMFilter:STATUS_FILTER];
        
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        filterPopupView = (FilterPopupView*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FilterPopupView"];
        
        [filterPopupView setFilterDelegate:self];
        
        CGRect frame = filterPopupView.view.frame;
        
        frame.origin.y = 0;
        
        filterPopupView.view.frame = frame;

        [self.view addSubview:filterPopupView.view];
    }
    else 
    {
        if(![popoverController isPopoverVisible]){
            
            filterPopupView = (FilterPopupView*)[mainStoryboard 
                                                 instantiateViewControllerWithIdentifier:@"FilterPopupView"];
            
            [filterPopupView setFilterDelegate:self];

            popoverController = [[UIPopoverController alloc] initWithContentViewController:filterPopupView] ;
            
            [filterPopupView setRootPopUpViewController:popoverController];
            [popoverController setPopoverContentSize:CGSizeMake(300.0f, 400.0f)];
            
            // Or use the following line to display it from a given rectangle
            //CGRectMake(0, 60, 10, 10)
            [popoverController presentPopoverFromRect:statusFilterBrn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
        }else{
            
            [popoverController dismissPopoverAnimated:YES];
        }
    }

}
- (IBAction)ServicePlanButtonFiltered:(id)sender
{
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSMutableArray *listOfSPTypes = [ServiceHelper getServicePlanTypes];
    
    [self.appDelegate setFilterListOfSPTypes:listOfSPTypes];
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [self.appDelegate setCurrentTMFilter:SERVICEPLAN_FILTER];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        filterPopupView = (FilterPopupView*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FilterPopupView"];
        
        [filterPopupView setFilterDelegate:self];
        
        CGRect frame = filterPopupView.view.frame;
        
        frame.origin.y = 0;
        
        filterPopupView.view.frame = frame;

        [self.view addSubview:filterPopupView.view];
    }
    else 
    {
        if(![popoverController isPopoverVisible]){
            
            filterPopupView = (FilterPopupView*)[mainStoryboard 
                                                 instantiateViewControllerWithIdentifier:@"FilterPopupView"];
            
            [filterPopupView setFilterDelegate:self];

            popoverController = [[UIPopoverController alloc] initWithContentViewController:filterPopupView] ;
            
            [filterPopupView setRootPopUpViewController:popoverController];
            [popoverController setPopoverContentSize:CGSizeMake(300.0f, 400.0f)];
            [popoverController presentPopoverFromRect:servicePlanFilterBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
        }else{
            
            [popoverController dismissPopoverAnimated:YES];
        }
    }
}
- (IBAction)TicketButtonFiltered:(id)sender
{
    
}


- (void) doneSearching_Clicked:(id)sender 
{	
	[[self searchBar] setText:@""];
	[[self searchBar] resignFirstResponder];
	
	[self setLetUserSelectRow:YES];
	[self setSearching:NO];
	
	self.navigationItem.rightBarButtonItem = rightBtnItem;
	self.monitorTableView.scrollEnabled = YES;
	
	[self.monitorTableView reloadData];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar 
{	
	[self setSearching:YES];
	[self setLetUserSelectRow:NO];
	
	self.monitorTableView.scrollEnabled = NO;
	
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
		
		self.monitorTableView.scrollEnabled = YES;
		
		[self searchTableView];
	}
	else 
	{
		[self setSearching:NO];
		[self setLetUserSelectRow:NO];
		
		self.monitorTableView.scrollEnabled = NO;
	}
	
	[self.monitorTableView reloadData];
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar 
{	
    if ([[self filteredTicketList] count ] > 0) {
        [[self filteredTicketList] removeAllObjects];
    }
	[self searchTableView];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar                     // called when text ends editing
{
    [[self searchBar] setText:@""];
	[[self searchBar] resignFirstResponder];
	
	[self setLetUserSelectRow:YES];
	[self setSearching:NO];
	
	self.navigationItem.rightBarButtonItem = rightBtnItem;
	self.monitorTableView.scrollEnabled = YES;
	
	[self.monitorTableView reloadData];

}
- (void) searchTableView 
{	
	NSString *searchText = [[self searchBar] text];
	
	for (TicketMoniter *ticket in [self currentListofTMRows])
	{
        NSRange searchResultsRange = [[ticket ticketDescription] rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (searchResultsRange.length > 0)
        {
			[[self filteredTicketList] addObject:ticket];
        }
	}
	
	if ([[self filteredTicketList] count] > 0) 
	{		
		[self.monitorTableView reloadData];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(UIView *)animationDidStart
{
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 42)];
    [view setBackgroundColor:[UIColor blueColor]];
    
    [UIView animateWithDuration:4 
                          delay:0 
                        options:UIViewAnimationCurveEaseOut                
                     animations:^
    {
        //view.backgroundColor = [UIColor redColor];
        view.frame = CGRectMake(0, 0, 160, 21);
        view.center = [view superview].center;
    }
                     completion:^(BOOL finished)
                    {
                         [self animationDidStart];
                     } 
     ];
    return view;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count;
    
    if ([self searching]) 
    {
        count = [self.filteredTicketList count];
    }else {
        count = [self.currentListofTMRows count];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"TicketMonitorViewCell";
    
    TicketMonitorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) 
	{
        cell = [[TicketMonitorViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	
    tableView.allowsMultipleSelection = NO;
    
    if (iPad) 
    {
        // iPad specific code here
        if ([self searching]) 
        {
            int count = [self.filteredTicketList count];
            
            if (count > 0) {
                
                TicketMoniter *curTicket = [self.filteredTicketList objectAtIndex:indexPath.row];
                
                [[cell locationLbl] setText:[curTicket ticketLocation]];
                
                [[cell contactLbl] setText:[curTicket ticketContact]];
                
                [[cell descriptionLbl] setText:[curTicket ticketDescription]];
                
                [[cell timeElapsedLbl] setText:([[curTicket ticketElapsed] length] >= 7) ? [[curTicket ticketElapsed] substringToIndex:4]:[curTicket ticketElapsed]];
                
                [[cell ticketNumberLbl] setText:[curTicket ticketTicketNumber]];
                
                [[cell categoryLbl] setText:[curTicket ticketCategory]];
                
                [[cell techAssignedLbl] setText:[curTicket ticketTech]];
                
                [[cell servicePlanLbl] setText:[curTicket ticketServicePlan]];
                
                [[cell statusLbl] setText:[curTicket ticketStatus]];
            }
        }
        else 
        {
            int count = [self.currentListofTMRows count];
            
            if (count > 0) {

                TicketMoniter *curTicket = [self.currentListofTMRows objectAtIndex:indexPath.row];
                
                [[cell locationLbl] setText:[curTicket ticketLocation]];
                
                [[cell contactLbl] setText:[curTicket ticketContact]];
                
                [[cell descriptionLbl] setText:[curTicket ticketDescription]];
                
                [[cell timeElapsedLbl] setText:([[curTicket ticketElapsed] length] >= 7) ? [[curTicket ticketElapsed] substringToIndex:4]:[curTicket ticketElapsed]];           
               
                [[cell ticketNumberLbl] setText:[curTicket ticketTicketNumber]];
                
                [[cell categoryLbl] setText:[curTicket ticketCategory]];
                
                [[cell techAssignedLbl] setText:[curTicket ticketTech]];
                
                [[cell servicePlanLbl] setText:[curTicket ticketServicePlan]];
                
                [[cell statusLbl] setText:[curTicket ticketStatus]];
            }
        }
    } 
    else 
    {
        // iPhone specific code here
        if ([self searching]) 
        {
            int count = [self.filteredTicketList count];
            
            if (count > 0) {
                
                TicketMoniter *curTicket = [self.filteredTicketList objectAtIndex:indexPath.row];
                
                [[cell locationLbl] setText:([[curTicket ticketLocation] length] >= 8) ? [[curTicket ticketLocation] substringToIndex:8]:[curTicket ticketLocation]];
                
                [[cell contactLbl] setText:([[curTicket ticketContact] length] >= 8) ? [[curTicket ticketContact] substringToIndex:8]:[curTicket ticketContact]];
                
                [[cell descriptionLbl] setText:([[curTicket ticketDescription] length] >= 40) ? [[curTicket ticketDescription] substringToIndex:40]:[curTicket ticketDescription]];
                
                [[cell timeElapsedLbl] setText:([[curTicket ticketElapsed] length] >= 4) ? [[curTicket ticketElapsed] substringToIndex:4]:[curTicket ticketElapsed]];
                
                [[cell ticketNumberLbl] setText:([[curTicket ticketTicketNumber] length] >= 6) ? [[curTicket ticketTicketNumber] substringToIndex:6]:[curTicket ticketTicketNumber]];
                
                [[cell categoryLbl] setText:([[curTicket ticketCategory] length] >= 3) ? [[curTicket ticketCategory] substringToIndex:3]:[curTicket ticketCategory]];
                
                [[cell techAssignedLbl] setText:([[curTicket ticketTech] length] >= 4) ? [[curTicket ticketTech] substringToIndex:4]:[curTicket ticketTech]];
                
                [[cell servicePlanLbl] setText:([[curTicket ticketServicePlan] length] >= 4) ? [[curTicket ticketServicePlan] substringToIndex:43]:[curTicket ticketServicePlan]];
                
                [[cell statusLbl] setText:([[curTicket ticketStatus] length] >= 4) ? [[curTicket ticketStatus] substringToIndex:4]:[curTicket ticketStatus]];
            }
        }
        else 
        {
            
            int count = [self.currentListofTMRows count];
            
            if (count > 0) {
                
                TicketMoniter *curTicket = [self.currentListofTMRows objectAtIndex:indexPath.row];
                
                [[cell locationLbl] setText:([[curTicket ticketLocation] length] >= 8) ? [[curTicket ticketLocation] substringToIndex:8]:[curTicket ticketLocation]];
                
                [[cell contactLbl] setText:([[curTicket ticketContact] length] >= 8) ? [[curTicket ticketContact] substringToIndex:8]:[curTicket ticketContact]];
                
                [[cell descriptionLbl] setText:([[curTicket ticketDescription] length] >= 40) ? [[curTicket ticketDescription] substringToIndex:40]:[curTicket ticketDescription]];
                
                [[cell timeElapsedLbl] setText:([[curTicket ticketElapsed] length] >= 4) ? [[curTicket ticketElapsed] substringToIndex:4]:[curTicket ticketElapsed]];
                
                [[cell ticketNumberLbl] setText:([[curTicket ticketTicketNumber] length] >= 6) ? [[curTicket ticketTicketNumber] substringToIndex:6]:[curTicket ticketTicketNumber]];

                [[cell categoryLbl] setText:([[curTicket ticketCategory] length] >= 3) ? [[curTicket ticketCategory] substringToIndex:3]:[curTicket ticketCategory]];
                
                [[cell techAssignedLbl] setText:([[curTicket ticketTech] length] >= 4) ? [[curTicket ticketTech] substringToIndex:4]:[curTicket ticketTech]];
                
                [[cell servicePlanLbl] setText:([[curTicket ticketServicePlan] length] >= 4) ? [[curTicket ticketServicePlan] substringToIndex:43]:[curTicket ticketServicePlan]];
                
                [[cell statusLbl] setText:([[curTicket ticketStatus] length] >= 4) ? [[curTicket ticketStatus] substringToIndex:4]:[curTicket ticketStatus]];
            }
        }
    }
    
    cell.contentView.tag = [indexPath row];
    return cell;
}

- (IBAction)longPressDetected:(UIGestureRecognizer *)gestureRecognizer 
{
    NSLog(@"Long Press");
    
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*) gestureRecognizer;
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    self.appDelegate.currentTicketMonitorSelected = recognizer.view.tag;
    
    NSLog(@"appDelegate.currentTicketMonitorSelected = %d",self.appDelegate.currentTicketMonitorSelected);
    
    TicketMoniter *curTicket;
    
    if ([self searching]) // if selected row while in searching
    {
        int count = [self.filteredTicketList count];
        
        if (count > 0)
        {
            curTicket =  [self.filteredTicketList objectAtIndex:self.appDelegate.currentTicketMonitorSelected];
        }
    }
    else 
    {
        int count = [self.currentListofTMRows count];
        
        if (count > 0)
        {
            
            curTicket =  [self.currentListofTMRows objectAtIndex:self.appDelegate.currentTicketMonitorSelected];
        }
        
    }
    
    [[[self appDelegate] selectedEntities] setTicketMonitor:curTicket];
    
    Location *loc = (Location *)[ServiceHelper getLocation:curTicket.ticketLocationId];
    
    [[[self appDelegate] selectedEntities] setLocation:loc];
    
    Contact *contact =  (Contact *)[ServiceHelper getContact:curTicket.ticketContactId];
    
    [[[self appDelegate] selectedEntities] setContact:contact];
    
    Category *category= (Category *)[ServiceHelper getCategory:curTicket.ticketCategoryId];
    
    [[[self appDelegate] selectedEntities] setCategory:category];


    if (!alertShowing) 
    {
        alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to assign the tech to you?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alertShowing = YES;
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    alertShowing = NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    if (buttonIndex == 0)
    {
        tech = nil;
    }
    else  if (buttonIndex == 1)
    {
        NSLog(@"appDelegate.currentTicketMonitorSelected = %d",appDelegate.currentTicketMonitorSelected);
        
        TicketMoniter *curTicket = [self.currentListofTMRows objectAtIndex:appDelegate.currentTicketMonitorSelected];
        
        NSLog(@"[curTicket ticketUserId] = %@",[curTicket ticketUserId]);
        
        if ([curTicket.ticketUserId isEqualToString:@"deb4fcaf-63b9-402e-9fb0-f2a0df76aafc"])
        {
            [ServiceHelper assignTicket:curTicket.ticketTicketId andTechid:[[[appDelegate selectedEntities] user] userId]];
            [self showAll:nil];
            
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"" message:@"Ticket assigned successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert1 show];

            
        }
        if (self.actionPopView)
            [self.actionPopView removeFromSuperview];
        tech = nil;
    }
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (id subviews in [[cell contentView] subviews])
    {
        UILabel *lbl = (UILabel *)subviews;
        
        if ((([lbl.text isEqualToString:@"No T"]) || ([lbl.text isEqualToString:@"No Tech/Blank"])) && (lbl.tag == 16))
        {
            [cell setBackgroundColor:[UIColor colorWithRed:219.0/255.0 green:185.0/255.0 blue:244.0/255.0 alpha:1]];
            
            if ([ST_User_Role_TECH isEqualToString:userRollid] || [ST_User_Role_TECH_SUPER isEqualToString:userRollid])
            {
                UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDetected:)];
                longPressRecognizer.minimumPressDuration = 1.5;
                longPressRecognizer.numberOfTouchesRequired = 1;
                longPressRecognizer.delegate = self;
                [cell.contentView addGestureRecognizer:longPressRecognizer];
            }
            
        }
        else if(lbl.tag == 16)
        {
            BOOL exist = NO;
            
            if ([self searching])
            {
                int count = [self.filteredTicketList count];
                
                if (count > 0)
                {
                    TicketMoniter *curTicket = [self.filteredTicketList objectAtIndex:indexPath.row];
                    
                    for (int i = 0; i < [soonzeList count]; i++)
                    {
                        Snooze *snooze = [soonzeList objectAtIndex:i];
                        
                        if ([snooze.ticketId isEqualToString:curTicket.ticketTicketId])
                        {
                            exist = YES;
                        }
                    }
                }
            }
            else
            {
                int count = [self.currentListofTMRows count];
                
                if (count > 0)
                {
                    TicketMoniter *curTicket = [self.currentListofTMRows objectAtIndex:indexPath.row];
                    
                    for (int i = 0; i < [soonzeList count]; i++)
                    {
                        Snooze *snooze = [soonzeList objectAtIndex:i];
                        
                        if ([snooze.ticketId isEqualToString:curTicket.ticketTicketId])
                        {
                            exist = YES;
                        }
                    }
                }
            }
            if (exist)
            {
                [cell setBackgroundColor:[UIColor colorWithRed:249.0/255.0 green:237.0/255.0 blue:189.0/255.0 alpha:1]];
            }
            else
            {
                [cell setBackgroundColor:[UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1]];
            }
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    self.appDelegate.currentTicketMonitorSelected = [indexPath row];
    
    NSLog(@"appDelegate.currentTicketMonitorSelected = %d",self.appDelegate.currentTicketMonitorSelected);

    TicketMoniter *curTicket;
    
    if ([self searching]) // if selected row while in searching
    {
        int count = [self.filteredTicketList count];
        
        if (count > 0)
        {
            curTicket =  [self.filteredTicketList objectAtIndex:self.appDelegate.currentTicketMonitorSelected];
        }
    }
    else 
    {
        int count = [self.currentListofTMRows count];
        
        if (count > 0)
        {
            
            curTicket =  [self.currentListofTMRows objectAtIndex:self.appDelegate.currentTicketMonitorSelected];
        }

    }

    [[[self appDelegate] selectedEntities] setTicketMonitor:curTicket];

    Location *loc = (Location *)[ServiceHelper getLocation:curTicket.ticketLocationId];
    
    [[[self appDelegate] selectedEntities] setLocation:loc];

    Contact *contact =  (Contact *)[ServiceHelper getContact:curTicket.ticketContactId];
    
    [[[self appDelegate] selectedEntities] setContact:contact];
    
    Category *category= (Category *)[ServiceHelper getCategory:curTicket.ticketCategoryId];
    
    [[[self appDelegate] selectedEntities] setCategory:category];

    tableSelection = indexPath;
    
    tapCount++;
    
    switch (tapCount) {
        case 1: //single tap
            [self performSelector:@selector(singleTap) withObject: nil afterDelay: .2];
            break;
        case 2: //double tap
            if (lastIndexPath == indexPath.row) 
            {
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTap) object:nil];
                
              [AppDelegate  activeIndicatorStartAnimating:self.view];
                
              [self performSelector:@selector(doubleTap) withObject: nil afterDelay:0.1];


            }
            break;
        default:
            break;
    }
       
    lastIndexPath = indexPath.row;
}

- (void)singleTap 
{
    tapCount = 0;
}

- (void)doubleTap 
{
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    self.appDelegate.filterPro_SolTicket = YES;
   
    [[self searchBar] setText:@""];
	[[self searchBar] resignFirstResponder];
	
	[self setLetUserSelectRow:YES];
	[self setSearching:NO];
    
    
    if ([self.currentListofTMRows count] > 0) {
      
        TicketMoniter *curSelectedTM =  [self.currentListofTMRows objectAtIndex:self.appDelegate.currentTicketMonitorSelected];
        
        NSString *ticketStatus = [curSelectedTM ticketStatus];
        
        if ([ticketStatus isEqualToString:@"C"]) {
            
            self.appDelegate.isProblemSoutionView = YES;
            
        }else if ([ticketStatus isEqualToString:@"O"]) {
            
            self.appDelegate.isProblemSoutionView = NO;
        }
    }
	    
    [self.appDelegate setNewTicketCreationProcess:NO];
    [self.appDelegate setIfticketRowselectedAndnewBtnPressed:NO];
    
	ProblemSolutionViewController *problemSolutionViewController = (ProblemSolutionViewController*)[mainStoryboard 
                                                                                                    instantiateViewControllerWithIdentifier:@"ProblemSolutionViewController"];
    
    NSArray *viewControllersList = [self navigationController].viewControllers;
    
    if ([viewControllersList count] > 0) {
       
        if (![[viewControllersList objectAtIndex:[viewControllersList count] - 1] isKindOfClass:[ProblemSolutionViewController class]]) 
        {
            [[self navigationController] pushViewController:problemSolutionViewController animated:YES];
        }    
    }
    tapCount = 0;
        
    [AppDelegate activeIndicatorStopAnimating];
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
    return indexPath;
}

#pragma mark - Single Tap filter Methods

-(IBAction)locationSorting:(id)sender
{
    [self setCurrentSortingElement:LOCATION_ELEMENT];
   
    if ([self.monitorTableView indexPathForSelectedRow] != nil)
    {
        [self selectRowAndPressTitle];
    }
    else
    {
        [self sortTicketMoniter:self.currentListofTMRows andToggle:locationToggle];
       
        if (locationToggle) 
          
            locationToggle = NO;
        else
           
            locationToggle = YES;
    }
}

-(IBAction)contactSorting:(id)sender
{
    [self setCurrentSortingElement:CONTACT_ELEMENT];
   
    if ([self.monitorTableView indexPathForSelectedRow] != nil)
    {
        [self selectRowAndPressTitle];
    }
    else
    {
        [self sortTicketMoniter:self.currentListofTMRows andToggle:contactToggle];
        
        if (contactToggle) 
         
            contactToggle = NO;
        else
           
            contactToggle = YES;
    }
}

-(IBAction)sinceSorting:(id)sender
{
    [self setCurrentSortingElement:SINCE_ELEMENT];
        
    [self sortTicketMoniter:self.currentListofTMRows andToggle:sinceToggle];
       
    if (sinceToggle) 
    
        sinceToggle = NO;
    else
        sinceToggle = YES;
}

-(IBAction)ticketSorting:(id)sender
{
    [self setCurrentSortingElement:TICKET_ELEMENT];
  
    [self sortTicketMoniter:self.currentListofTMRows andToggle:ticketToggle];
    
    if (ticketToggle) 
    
        ticketToggle = NO;
   
    else
        ticketToggle = YES;
}

-(IBAction)categorySorting:(id)sender
{
    [self setCurrentSortingElement:CATEGORY_ELEMENT];
    if ([self.monitorTableView indexPathForSelectedRow] != nil)
    {
        [self selectRowAndPressTitle];
    }
    else
    {
        [self sortTicketMoniter:self.currentListofTMRows andToggle:categorynToggle];
        if (categorynToggle) 
            categorynToggle = NO;
        else
            categorynToggle = YES;
    }
}

-(IBAction)techSorting:(id)sender
{
    [self setCurrentSortingElement:TECH_ELEMENT];
   
    if ([self.monitorTableView indexPathForSelectedRow] != nil)
    {
        [self selectRowAndPressTitle];
    }
    else
    {
        [self sortTicketMoniter:self.currentListofTMRows andToggle:techToggle];
      
        if (techToggle) 
        
            techToggle = NO;
        
        else
            techToggle = YES;
    }
}

-(IBAction)statusSorting:(id)sender
{
    [self setCurrentSortingElement:STATUS_ELEMENT];
  
    if ([self.monitorTableView indexPathForSelectedRow] != nil)
    {
        [self selectRowAndPressTitle];
    }
    else
    {
        [self sortTicketMoniter:self.currentListofTMRows andToggle:statusToggle];
       
        if (statusToggle) 
        
            statusToggle = NO;
        else
            statusToggle = YES;
    }
}

-(IBAction)serviceplanSorting:(id)sender
{
    [self setCurrentSortingElement:SERVICEPLAN_ELEMENT];
   
    if ([self.monitorTableView indexPathForSelectedRow] != nil)
    {
        [self selectRowAndPressTitle];
    }
    else
    {
        [self sortTicketMoniter:self.currentListofTMRows andToggle:serviceplanToggle];
       
        if (serviceplanToggle) 
         
            serviceplanToggle = NO;
        else
            serviceplanToggle = YES;
    }
}


- (NSMutableArray *)sortTicketMoniter:(NSMutableArray *)listofTMRows andToggle:(int)toggle
{
    NSMutableArray *tempSortArray = [[NSMutableArray alloc]init];
    
    NSMutableArray *reorderobjectArray = [[NSMutableArray alloc] init];
    
    NSString *elementName;
    
    int count = [listofTMRows count];
    
    if (count > 0) {
        
        for (int k = 0;k < count ; k++) {
            
            TicketMoniter *tmObj = (TicketMoniter *)[listofTMRows objectAtIndex:k];
            
            switch (self.currentSortingElement) {
                case LOCATION_ELEMENT:
                {
                    elementName = [tmObj ticketLocation];
                }
                    break;
                case CONTACT_ELEMENT:
                {
                    elementName = [tmObj ticketContact];
                }
                    break;
                case SINCE_ELEMENT:
                {
                    elementName = [tmObj ticketElapsed];          
                }
                    break;
                case TICKET_ELEMENT:
                {
                    elementName = [tmObj ticketTicketNumber];
                }
                    break;
                case CATEGORY_ELEMENT:
                {
                    elementName = [tmObj ticketCategory];
                }
                    break;
                case TECH_ELEMENT:
                {
                    elementName = [tmObj ticketTech];
                }
                    break;
                case STATUS_ELEMENT:
                {
                    elementName = [tmObj ticketStatus];
                }
                    break;
                case SERVICEPLAN_ELEMENT:
                {
                    elementName = [tmObj ticketServicePlan];
                }
                    break;
                    
                default:
                    break;
            }
            if((self.currentSortingElement == SINCE_ELEMENT) || (self.currentSortingElement == TICKET_ELEMENT)) // Number array
                
                [tempSortArray addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:[elementName floatValue]], [NSNumber numberWithInt:k], nil]];
            
            else  
                
                [tempSortArray addObject:[NSArray arrayWithObjects:elementName, [NSNumber numberWithInt:k], nil]]; // String array
        }
        NSArray* sortedArray;
        
        if((self.currentSortingElement == SINCE_ELEMENT) || (self.currentSortingElement == TICKET_ELEMENT))
            
            sortedArray = [tempSortArray sortedArrayUsingFunction:customIntegerCompare context:NULL]; // Comparing String array
        
        else 
            
            sortedArray = [tempSortArray sortedArrayUsingFunction:customCompareFunction context:NULL]; // Comparing String array
        
        if (toggle) 
        {
            for (int loop = 0; loop < [sortedArray count]  ; loop++) 
            {
                [reorderobjectArray addObject:[self.currentListofTMRows objectAtIndex:[[[sortedArray objectAtIndex:loop] objectAtIndex:1] intValue]]];
            }
        }
        else
        {
            for (int loop = [sortedArray count] - 1; loop >= 0  ; loop--) 
            {
                [reorderobjectArray addObject:[self.currentListofTMRows objectAtIndex:[[[sortedArray objectAtIndex:loop] objectAtIndex:1] intValue]]];
            }
        }
    }
    [self.currentListofTMRows removeAllObjects];
    [self setCurrentListofTMRows:reorderobjectArray];
    [[self monitorTableView] reloadData];
    
    return nil;
}

NSComparisonResult customIntegerCompare(NSArray* first, NSArray* second, void* context)
{
    id firstValue = [first objectAtIndex:0];
    id secondValue = [second objectAtIndex:0];
    
    if ([firstValue floatValue] > [secondValue floatValue]) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    if ([firstValue floatValue] < [secondValue floatValue]) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
}
NSComparisonResult customCompareFunction(NSArray* first, NSArray* second, void* context)
{
    id firstValue = [first objectAtIndex:0];
    id secondValue = [second objectAtIndex:0];
    return [[firstValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] localizedCaseInsensitiveCompare:[secondValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.view];
        
        if (CGRectContainsPoint(CGRectMake(100,100,100,100), point)) {
            
        }else {
            
            [filterPopupView.view removeFromSuperview];
        }
    }
    else 
    {
        
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

-(NSMutableArray *)sortingArray:(NSMutableArray *)unsoretedArray {
    
    NSMutableArray *sortedArray; 
    
    NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"ticketElapsed" ascending:YES comparator:^(id obj1, id obj2) {
        
        if ([obj1 floatValue] > [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    sortedArray = [NSMutableArray arrayWithArray:[unsoretedArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]]];
    
    return sortedArray;
}

#pragma mark - custom_KD_Popover methods called from custom_KD_PopOverViewController.m

- (IBAction)KD_BtnPressed:(id)sender {
    
    if(![self.monitorTableView indexPathForSelectedRow]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" 
                                                            message:@"Please select a row from the list and then click it."delegate:self 
                                                  cancelButtonTitle:@"Ok" 
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
        
    }else {
        
        CGSize ipadSize   = CGSizeMake(500,450);
        CGSize iphoneSize = CGSizeMake(350,330);
        transparentView.hidden = NO;
        self.appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [self.appDelegate setCurrentKDpopPresentVC:TICKETMONITER_VC];
        [self presentCustomize_KD_PopOverVC_WithSize_Ipad:&ipadSize Iphone:&iphoneSize];    }
}

-(void)presentCustomize_KD_PopOverVC_WithSize_Ipad:(CGSize *)IpadSize Iphone:(CGSize *)IphoneSize{
    
    custom_KD_PopOverVC = (custom_KD_PopOverViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"custom_KD_PopOverViewController"];
    
    self.custom_KD_popoverView = [[popoverClass alloc] initWithContentViewController:custom_KD_PopOverVC] ;
    
    if ([self.custom_KD_popoverView respondsToSelector:@selector(setContainerViewProperties:)]) {
        
        [self.custom_KD_popoverView setContainerViewProperties:[self improvedContainerViewProperties]];
    }
    
    self.custom_KD_popoverView.delegate = self;
    self.custom_KD_popoverView.passthroughViews = [NSArray arrayWithObject:self.view];
    
    if (iPad) {
        
        [self.custom_KD_popoverView presentPopoverFromRect:CGRectMake(380,240,0,0)
                                                inView:self.view
                              permittedArrowDirections:UIPopoverArrowDirectionUp
                                              animated:YES size:IpadSize];
        
        /*UINavigationController *navController = [[UINavigationController alloc]
                                                 
                                                 initWithRootViewController:custom_KD_PopOverVC];
        
        // show the navigation controller modally
        
        [navController.navigationBar setHidden:YES];
        
//        UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
//        
//        navController.navigationItem.rightBarButtonItem = doneButton;
        
        [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        custom_KD_PopOverVC.view.superview.frame = CGRectMake(120,120,512,400);
        [self presentModalViewController:navController animated:YES];*/
        
    }else {
        
        [self.custom_KD_popoverView presentPopoverFromRect:CGRectMake(125,55,0,0) 
                                                inView:self.view
                              permittedArrowDirections:UIPopoverArrowDirectionUp
                                              animated:YES size:IphoneSize];
    }
}

-(void)KD_PopOverCancelBtnPressed {
   
    transparentView.hidden = YES;
    
    if (self.custom_KD_popoverView) {
        
        [self.custom_KD_popoverView dismissPopoverAnimated:YES];
    }
}
-(void)KD_PopOverCancelBtnPressedWith_location:(NSString *)location category:(NSString *)category describtion:(NSString *)describtion KDsolutionList:(NSMutableArray *)KDsolutionList{

    KDListViewController *kdlistViewController=(KDListViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"KDListViewController"];

    [self presentModalViewController:kdlistViewController animated:YES];
    [kdlistViewController KD_location:location KD_category:category KD_description:describtion KDsolutionList:(NSMutableArray *)KDsolutionList];

}

#pragma mark - custom_KD_Popover Delegate  Methods

- (WEPopoverContainerViewProperties *)improvedContainerViewProperties {
	
	WEPopoverContainerViewProperties *props = [WEPopoverContainerViewProperties alloc] ;
	NSString *bgImageName = nil;
	CGFloat bgMargin = 0.0;
	CGFloat bgCapSize = 0.0;
	CGFloat contentMargin = 4.0;
    bgImageName = @"popoverBg.png";
	bgMargin = 13;
    bgCapSize = 31; 	
	props.leftBgMargin = bgMargin;
	props.rightBgMargin = bgMargin;
	props.topBgMargin = bgMargin;
	props.bottomBgMargin = bgMargin;
	props.leftBgCapSize = bgCapSize;
	props.topBgCapSize = bgCapSize;
	props.bgImageName = bgImageName;
	props.leftContentMargin = contentMargin;
	props.rightContentMargin = contentMargin - 1; 
	props.topContentMargin = contentMargin; 
	props.bottomContentMargin = contentMargin;
	props.arrowMargin = 4.0;
	props.upArrowImageName = @"popoverArrowUp.png";
	props.downArrowImageName = @"popoverArrowDown.png";
	props.leftArrowImageName = @"popoverArrowLeft.png";
	props.rightArrowImageName = @"popoverArrowRight.png";
	return props;	
}

#pragma mark - WEPopoverControllerDelegate implementation

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
	//Safe to release the popover here
	self.custom_KD_popoverView = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//The popover is automatically dismissed if you click outside it, unless you return NO here
    transparentView.hidden = YES;
    return YES;
}
#pragma mark - PopOver Methods for changing position(x,y)-Moving up and down while editing

- (void)popOverTextViewIsEditng {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if (!iPad){
        
        self.custom_KD_popoverView.view.frame=CGRectMake(0,20,321, 330);   
    }
    [UIView commitAnimations];
}

- (void)popOverTextViewIsendEditing {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if (!iPad){
        
        self.custom_KD_popoverView.view.frame=CGRectMake(0,110,321, 330);    
    }
    [UIView commitAnimations];
}


#pragma mark - Snooze

- (IBAction)actionSnoozeButtonWasPressed:(id)sender
{
    NSLog(@"snoozeOptionView = %@",snoozeOptionView);
    if (snoozeOptionView != nil)
    {
        [snoozeOptionView removeFromSuperview];
        snoozeOptionView = nil;
    }
    else
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            snoozeOptionView = [[UIView alloc] initWithFrame:CGRectMake(140, 296, 100, 74)];
        }
        else
        {
            snoozeOptionView = [[UIView alloc] initWithFrame:CGRectMake(305, 844, 100, 74)];
        }
        
        UIImage *buttonBG = [UIImage imageNamed:@"btn-blue-off.png"];
        
        UIButton *new = [UIButton buttonWithType:UIButtonTypeCustom];
        [new addTarget:self  action:@selector(actionSnoozeNewButtonWasPressed:) forControlEvents:UIControlEventTouchDown];
        [new setBackgroundImage:buttonBG forState:UIControlStateNormal];
        [new setTitle:@"New" forState:UIControlStateNormal];
        new.frame = CGRectMake(0, 0, 100.0, 37);
        [snoozeOptionView addSubview:new];
        
        UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
        [close addTarget:self  action:@selector(actionSnoozeListButtonWasPressed:) forControlEvents:UIControlEventTouchDown];
        [close setTitle:@"Snooze List" forState:UIControlStateNormal];
        [close setBackgroundImage:buttonBG forState:UIControlStateNormal];
        close.frame = CGRectMake(0, 38, 100.0, 37);
        [snoozeOptionView addSubview:close];
        
        [self.view addSubview:snoozeOptionView];
        
    }
    
    
}

- (IBAction)actionSnoozeNewButtonWasPressed:(id)sender
{
    
    UILabel *quickShareOption;
    UILabel *dateInterval;
    
    if (self.actionPopView)
        [self.actionPopView removeFromSuperview];
    
    if (snoozeOptionView)
    {
        [snoozeOptionView removeFromSuperview];
        snoozeOptionView = nil;
    }
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        snoozeContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        snoozeTransparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        snoozeNewOptionView = [[UIView alloc] initWithFrame:CGRectMake(18, 45, 285, 325)];
        snoozeNewOptionView.layer.borderWidth = 5;
    }
    else
    {
        snoozeContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
        snoozeTransparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
        snoozeNewOptionView = [[UIView alloc] initWithFrame:CGRectMake(145, 200, 478, 476)];
        snoozeNewOptionView.layer.borderWidth = 10;
    }
    
    snoozeContainerView.backgroundColor = [UIColor clearColor];
    snoozeTransparentView.alpha = 0.4;
    snoozeTransparentView.backgroundColor = [UIColor blackColor];
    snoozeNewOptionView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    snoozeNewOptionView.layer.cornerRadius = 6;
    snoozeNewOptionView.layer.borderColor = ([[UIColor blackColor]CGColor]);
    
    
    UILabel *reason = [[UILabel alloc] init];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        reason.frame = CGRectMake(10,20, 600, 25);
    else
        reason.frame = CGRectMake(30,55, 600, 25);
    reason.lineBreakMode = UILineBreakModeWordWrap;
    reason.numberOfLines = 0;//Dynamic
    reason.backgroundColor = [UIColor clearColor];
    reason.text = @"Reason";
    [snoozeNewOptionView addSubview:reason];
    
    UIImage *buttonBG = [UIImage imageNamed:@"button_back.png"];
    
    reasonListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reasonListButton addTarget:self  action:@selector(actionReasonListButtonWasPressed:) forControlEvents:UIControlEventTouchDown];
    [reasonListButton setBackgroundImage:buttonBG forState:UIControlStateNormal];
    reasonListButton.tag = 100;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        reasonListButton.frame = CGRectMake(90, 20, 180.0, 25);
    else
        reasonListButton.frame = CGRectMake(190, 55, 250.0, 25);
    
    [reasonListButton setTitle:@"" forState:UIControlStateNormal];
    
    [snoozeNewOptionView addSubview:reasonListButton];
    
    
    //first set
    DICheckBox = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        DICheckBox.frame = CGRectMake(10, 60, 20, 20);
    else
        DICheckBox.frame = CGRectMake(30, 110, 20, 20);
    DICheckBox.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentLeft;
    [DICheckBox setImage:[UIImage imageNamed:@"checkbox_not_ticked.png"] forState:UIControlStateNormal];
    [DICheckBox addTarget:self action:@selector(checkBoxClicked) forControlEvents:UIControlEventTouchUpInside];
    [snoozeNewOptionView addSubview:DICheckBox];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        dateInterval = [[UILabel alloc] initWithFrame:CGRectMake(40,60, 100, 20)];
        
        startDate = [[UILabel alloc] initWithFrame:CGRectMake(30,95, 80, 20)];
        endDate = [[UILabel alloc] initWithFrame:CGRectMake(30,130, 80, 20)];
        
        startTime = [[UILabel alloc] initWithFrame:CGRectMake(200,95, 10, 20)];
        endTime = [[UILabel alloc] initWithFrame:CGRectMake(200,130, 10, 20)];
        
        startTextFieldRounded = [[UITextField alloc] initWithFrame:CGRectMake(110, 95, 90, 21)];
        endTextFieldRounded = [[UITextField alloc] initWithFrame:CGRectMake(110, 130, 90, 21)];
        
        startTimeTextField = [[UITextField alloc] initWithFrame:CGRectMake(212, 95, 65, 21)];
        endTimeTextField = [[UITextField alloc] initWithFrame:CGRectMake(212, 130, 65, 21)];
        
        quickShareOption = [[UILabel alloc] initWithFrame:CGRectMake(40,170, 220, 20)];
        
        hours = [[UILabel alloc] initWithFrame:CGRectMake(40,200, 100, 20)];
        minutes = [[UILabel alloc] initWithFrame:CGRectMake(40,230, 100, 20)];
        hoursTextField = [[UITextField alloc] initWithFrame:CGRectMake(160, 200, 90, 21)];
        minuteTextField = [[UITextField alloc] initWithFrame:CGRectMake(160, 230, 90, 21)];
        
    }
    else
    {
        dateInterval = [[UILabel alloc] initWithFrame:CGRectMake(60,110, 100, 20)];
        
        startDate = [[UILabel alloc] initWithFrame:CGRectMake(60,155, 100, 20)];
        endDate = [[UILabel alloc] initWithFrame:CGRectMake(60,190, 100, 20)];
        
        startTime = [[UILabel alloc] initWithFrame:CGRectMake(300,155, 40, 20)];
        endTime = [[UILabel alloc] initWithFrame:CGRectMake(300,190, 40, 20)];
        
        startTextFieldRounded = [[UITextField alloc] initWithFrame:CGRectMake(140, 155, 130, 21)];
        endTextFieldRounded = [[UITextField alloc] initWithFrame:CGRectMake(140, 190, 130, 21)];
        
        startTimeTextField = [[UITextField alloc] initWithFrame:CGRectMake(342, 155, 90, 21)];
        endTimeTextField = [[UITextField alloc] initWithFrame:CGRectMake(342, 190, 90, 21)];
        
        quickShareOption = [[UILabel alloc] initWithFrame:CGRectMake(60,235, 380, 20)];
        
        hours = [[UILabel alloc] initWithFrame:CGRectMake(60,280, 100, 20)];
        minutes = [[UILabel alloc] initWithFrame:CGRectMake(60,315, 100, 20)];
        hoursTextField = [[UITextField alloc] initWithFrame:CGRectMake(270, 280, 90, 21)];
        minuteTextField = [[UITextField alloc] initWithFrame:CGRectMake(270, 315, 90, 21)];
    }
    
    dateInterval.lineBreakMode = UILineBreakModeWordWrap;
    dateInterval.numberOfLines = 0;//Dynamic
    dateInterval.backgroundColor = [UIColor clearColor];
    dateInterval.text = @"Date Interval";
    [snoozeNewOptionView addSubview:dateInterval];
    
    startDate.lineBreakMode = UILineBreakModeWordWrap;
    startDate.numberOfLines = 0;//Dynamic
    startDate.backgroundColor = [UIColor clearColor];
    startDate.text = @"Start Date";
    [snoozeNewOptionView addSubview:startDate];
    
    endDate.lineBreakMode = UILineBreakModeWordWrap;
    endDate.numberOfLines = 0;//Dynamic
    endDate.backgroundColor = [UIColor clearColor];
    endDate.text = @"End Date";
    [snoozeNewOptionView addSubview:endDate];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    selectedStartDate = today;
    startTextFieldRounded.text = dateString;
    startTextFieldRounded.textAlignment = UITextAlignmentCenter;
    startTextFieldRounded.delegate = self;
    [startTextFieldRounded.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [startTextFieldRounded.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [startTextFieldRounded.layer setBorderWidth: 1.5];
    [startTextFieldRounded.layer setCornerRadius:3.0f];
    // [startTextFieldRounded.layer setMasksToBounds:YES];
    [snoozeNewOptionView addSubview:startTextFieldRounded];
    
    selectedEndDate = today;
    endTextFieldRounded.text = dateString;
    endTextFieldRounded.textAlignment = UITextAlignmentCenter;
    endTextFieldRounded.delegate = self;
    [endTextFieldRounded.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [endTextFieldRounded.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [endTextFieldRounded.layer setBorderWidth: 1.5];
    [endTextFieldRounded.layer setCornerRadius:3.0f];
    [endTextFieldRounded.layer setMasksToBounds:YES];
    [snoozeNewOptionView addSubview:endTextFieldRounded];
    
    
    startTime.lineBreakMode = UILineBreakModeWordWrap;
    startTime.numberOfLines = 0;//Dynamic
    startTime.backgroundColor = [UIColor clearColor];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        startTime.text = @"T";
    else
        startTime.text = @"Time";
    [snoozeNewOptionView addSubview:startTime];
    
    endTime.lineBreakMode = UILineBreakModeWordWrap;
    endTime.numberOfLines = 0;//Dynamic
    endTime.backgroundColor = [UIColor clearColor];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        endTime.text = @"T";
    else
        endTime.text = @"Time";
    [snoozeNewOptionView addSubview:endTime];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    NSLog(@"User's current time in their preference format:%@",currentTime);
    
    selectedStartTime = today;
    startTimeTextField.text = currentTime;
    startTimeTextField.textAlignment = UITextAlignmentCenter;
    startTimeTextField.delegate = self;
    [startTimeTextField.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [startTimeTextField.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [startTimeTextField.layer setBorderWidth: 1.5];
    [startTimeTextField.layer setCornerRadius:3.0f];
    [startTimeTextField.layer setMasksToBounds:YES];
    [snoozeNewOptionView addSubview:startTimeTextField];
    
    selectedEndTime = today;
    endTimeTextField.text = currentTime;
    endTimeTextField.textAlignment = UITextAlignmentCenter;
    endTimeTextField.delegate = self;
    [endTimeTextField.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [endTimeTextField.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [endTimeTextField.layer setBorderWidth: 1.5];
    [endTimeTextField.layer setCornerRadius:3.0f];
    [endTimeTextField.layer setMasksToBounds:YES];
    [snoozeNewOptionView addSubview:endTimeTextField];
    
    //second set
    QSCheckBox = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        QSCheckBox.frame = CGRectMake(10, 170, 20, 20);
    else
        QSCheckBox.frame = CGRectMake(30, 235, 20, 20);
    QSCheckBox.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentLeft;
    [QSCheckBox setImage:[UIImage imageNamed:@"checkbox_not_ticked.png"] forState:UIControlStateNormal];
    [QSCheckBox addTarget:self action:@selector(QScheckBoxClicked) forControlEvents:UIControlEventTouchUpInside];
    [snoozeNewOptionView addSubview:QSCheckBox];
    
    quickShareOption.lineBreakMode = UILineBreakModeWordWrap;
    quickShareOption.numberOfLines = 0;//Dynamic
    quickShareOption.backgroundColor = [UIColor clearColor];
    quickShareOption.text = @"Quick Snooze Option";
    [snoozeNewOptionView addSubview:quickShareOption];
    
    
    hours.lineBreakMode = UILineBreakModeWordWrap;
    hours.numberOfLines = 0;//Dynamic
    hours.backgroundColor = [UIColor clearColor];
    hours.text = @"hours";
    [snoozeNewOptionView addSubview:hours];
    
    
    minutes.lineBreakMode = UILineBreakModeWordWrap;
    minutes.numberOfLines = 0;//Dynamic
    minutes.backgroundColor = [UIColor clearColor];
    minutes.text = @"Minutes";
    [snoozeNewOptionView addSubview:minutes];
    
    
    hoursTextField.text = @"10";
    hoursTextField.delegate = self;
    hoursTextField.textAlignment = UITextAlignmentCenter;
    [hoursTextField.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [hoursTextField.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [hoursTextField.layer setBorderWidth: 1.0];
    [hoursTextField.layer setCornerRadius:3.0f];
    [hoursTextField.layer setMasksToBounds:YES];
    [snoozeNewOptionView addSubview:hoursTextField];
    
    
    minuteTextField.text = @"49";
    minuteTextField.delegate = self;
    minuteTextField.textAlignment = UITextAlignmentCenter;
    [minuteTextField.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [minuteTextField.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [minuteTextField.layer setBorderWidth: 1.0];
    [minuteTextField.layer setCornerRadius:3.0f];
    [minuteTextField.layer setMasksToBounds:YES];
    [snoozeNewOptionView addSubview:minuteTextField];
    
    //    //Snooze Interval
    //    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    //        snoozeInterval = [[UILabel alloc] initWithFrame:CGRectMake(10,240, 200, 25)];
    //    else
    //        snoozeInterval = [[UILabel alloc] initWithFrame:CGRectMake(30,330, 200, 25)];
    //
    //    snoozeInterval.lineBreakMode = UILineBreakModeWordWrap;
    //    snoozeInterval.numberOfLines = 0;//Dynamic
    //    snoozeInterval.backgroundColor = [UIColor clearColor];
    //    snoozeInterval.text = @"Snooze Interval";
    //    [snoozeNewOptionView addSubview:snoozeInterval];
    
    //    snoozeListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [snoozeListButton addTarget:self  action:@selector(actionSnoozeTimeListButtonWasPressed:) forControlEvents:UIControlEventTouchDown];
    //    [snoozeListButton setBackgroundImage:buttonBG forState:UIControlStateNormal];
    //    snoozeListButton.tag = 101;
    //    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    //        snoozeListButton.frame = CGRectMake(160, 240, 80.0, 25);
    //    else
    //        snoozeListButton.frame = CGRectMake(240, 330, 120.0, 25);
    //
    //    [snoozeListButton setTitle:@"" forState:UIControlStateNormal];
    //
    //    [snoozeNewOptionView addSubview:snoozeListButton];
    
    UIButton *saveSnooze = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        saveSnooze.frame = CGRectMake(150, 270, 72, 37);
    else
        saveSnooze.frame = CGRectMake(280, 385, 72, 37);
    
    [saveSnooze setBackgroundImage:[UIImage imageNamed:@"keyboard-01-done-down.png"] forState:UIControlStateNormal];
    [saveSnooze setTitle:@"Save" forState:UIControlStateNormal];
    [saveSnooze addTarget:self action:@selector(saveSnoozeClicked) forControlEvents:UIControlEventTouchUpInside];
    [snoozeNewOptionView addSubview:saveSnooze];
    
    UIButton *cancelSnooze = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        cancelSnooze.frame = CGRectMake(50, 270, 72, 37);
    else
        cancelSnooze.frame = CGRectMake(120, 385, 72, 37);
    
    [cancelSnooze setBackgroundImage:[UIImage imageNamed:@"keyboard-01-done-down.png"] forState:UIControlStateNormal];
    [cancelSnooze setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelSnooze addTarget:self action:@selector(cancelSnoozeClicked) forControlEvents:UIControlEventTouchUpInside];
    [snoozeNewOptionView addSubview:cancelSnooze];
    
    [snoozeContainerView addSubview:snoozeTransparentView];
    [snoozeContainerView addSubview:snoozeNewOptionView];
    [self.view addSubview:snoozeContainerView];
    
    
    isCheckedDate =NO;
    isCheckedQuickShare =NO;
    
    /* UIViewController *testVC = [[UIViewController alloc]init];
     [testVC.view addSubview:snoozeContainerView];
     
     UINavigationController *navController = [[UINavigationController alloc]
     
     initWithRootViewController:testVC];
     
     // show the navigation controller modally
     
     [navController.navigationBar setHidden:YES];
     
     UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
     
     navController.navigationItem.rightBarButtonItem = doneButton;
     
     [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
     
     navController.modalPresentationStyle = UIModalPresentationFormSheet;
     
     [self presentModalViewController:navController animated:YES]; */
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    textField.keyboardType = UIKeyboardTypeDefault;
    
    if (datePickerView != Nil)
        [datePickerView removeFromSuperview];
    
    if([textField isEqual:startTextFieldRounded])
    {
        [textField resignFirstResponder];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 115, 320, 260)];
        else
            datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 668, 768,250)];
        
        [datePickerView setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:39.0/255.0 blue:59.0/255.0 alpha:255.0/255.0]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Done" forState:UIControlStateNormal];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            button.frame = CGRectMake(248, 0, 72, 37);
        else
            button.frame = CGRectMake(696, 0, 72, 37);
        
        [button setBackgroundImage:[UIImage imageNamed:@"keyboard-01-done-down.png"] forState:UIControlStateNormal];
        button.tag = 2;
        [button addTarget:self  action:@selector(done:) forControlEvents:UIControlEventTouchDown];
        [datePickerView addSubview:button];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            cancel.frame = CGRectMake(10, 0, 72, 37);
        else
            cancel.frame = CGRectMake(10, 0, 72, 37);
        
        [cancel setBackgroundImage:[UIImage imageNamed:@"keyboard-01-done-down.png"] forState:UIControlStateNormal];
        [cancel addTarget:self  action:@selector(cancel:) forControlEvents:UIControlEventTouchDown];
        [datePickerView addSubview:cancel];

        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 38, 320, 300)];
        else
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 38, 768, 300)];
        
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.hidden = NO;
        datePicker.date = [NSDate date];
        [datePicker addTarget:self action:@selector(LabelChange:) forControlEvents:UIControlEventValueChanged];
        [datePickerView addSubview:datePicker];
        
        [self.view addSubview:datePickerView];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            snoozeNewOptionView.frame = CGRectMake(snoozeNewOptionView.frame.origin.x, -10, snoozeNewOptionView.frame.size.width, snoozeNewOptionView.frame.size.height);
        
        datePicker.tag = 1;
        selectedStartDate = datePicker.date;
    }
    else if([textField isEqual:endTextFieldRounded])
    {
        [textField resignFirstResponder];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 115, 320, 260)];
        else
            datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 668, 768,250)];
        
        [datePickerView setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:39.0/255.0 blue:59.0/255.0 alpha:255.0/255.0]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Done" forState:UIControlStateNormal];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            button.frame = CGRectMake(248, 0, 72, 37);
        else
            button.frame = CGRectMake(696, 0, 72, 37);
        
        [button setBackgroundImage:[UIImage imageNamed:@"keyboard-01-done-down.png"] forState:UIControlStateNormal];
        button.tag = 2;
        [button addTarget:self  action:@selector(done:) forControlEvents:UIControlEventTouchDown];
        [datePickerView addSubview:button];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            cancel.frame = CGRectMake(10, 0, 72, 37);
        else
            cancel.frame = CGRectMake(10, 0, 72, 37);
        
        [cancel setBackgroundImage:[UIImage imageNamed:@"keyboard-01-done-down.png"] forState:UIControlStateNormal];
        [cancel addTarget:self  action:@selector(cancel:) forControlEvents:UIControlEventTouchDown];
        [datePickerView addSubview:cancel];

        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 38, 320, 300)];
        else
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 38, 768, 300)];
        
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.hidden = NO;
        datePicker.date = [NSDate date];
        [datePicker addTarget:self action:@selector(LabelChange:) forControlEvents:UIControlEventValueChanged];
        [datePickerView addSubview:datePicker];
        
        [self.view addSubview:datePickerView];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            snoozeNewOptionView.frame = CGRectMake(snoozeNewOptionView.frame.origin.x, -40, snoozeNewOptionView.frame.size.width, snoozeNewOptionView.frame.size.height);
        
        datePicker.tag = 2;
        selectedEndDate = datePicker.date;
        
    }
    else if([textField isEqual:startTimeTextField])
    {
        [textField resignFirstResponder];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 115, 320, 260)];
        else
            datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 668, 768,250)];
        
        [datePickerView setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:39.0/255.0 blue:59.0/255.0 alpha:255.0/255.0]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Done" forState:UIControlStateNormal];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            button.frame = CGRectMake(248, 0, 72, 37);
        else
            button.frame = CGRectMake(696, 0, 72, 37);
        
        [button setBackgroundImage:[UIImage imageNamed:@"keyboard-01-done-down.png"] forState:UIControlStateNormal];
        button.tag = 3;
        [button addTarget:self  action:@selector(done:) forControlEvents:UIControlEventTouchDown];
        [datePickerView addSubview:button];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            cancel.frame = CGRectMake(10, 0, 72, 37);
        else
            cancel.frame = CGRectMake(10, 0, 72, 37);
        
        [cancel setBackgroundImage:[UIImage imageNamed:@"keyboard-01-done-down.png"] forState:UIControlStateNormal];
        [cancel addTarget:self  action:@selector(cancel:) forControlEvents:UIControlEventTouchDown];
        [datePickerView addSubview:cancel];

        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 38, 320, 300)];
        else
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 38, 768, 300)];
        
        datePicker.datePickerMode = UIDatePickerModeTime;
        datePicker.hidden = NO;
        datePicker.date = [NSDate date];
        [datePicker addTarget:self action:@selector(LabelChange:) forControlEvents:UIControlEventValueChanged];
        [datePickerView addSubview:datePicker];
        
        [self.view addSubview:datePickerView];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            snoozeNewOptionView.frame = CGRectMake(snoozeNewOptionView.frame.origin.x, -40, snoozeNewOptionView.frame.size.width, snoozeNewOptionView.frame.size.height);
        
        datePicker.tag = 3;
        
        selectedStartTime = datePicker.date;
    }
    else if([textField isEqual:endTimeTextField])
    {
        [textField resignFirstResponder];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 115, 320, 260)];
        else
            datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 668, 768,250)];
        
        [datePickerView setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:39.0/255.0 blue:59.0/255.0 alpha:255.0/255.0]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Done" forState:UIControlStateNormal];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            button.frame = CGRectMake(248, 0, 72, 37);
        else
            button.frame = CGRectMake(696, 0, 72, 37);
        
        [button setBackgroundImage:[UIImage imageNamed:@"keyboard-01-done-down.png"] forState:UIControlStateNormal];
        button.tag = 4;
        [button addTarget:self  action:@selector(done:) forControlEvents:UIControlEventTouchDown];
        [datePickerView addSubview:button];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            cancel.frame = CGRectMake(10, 0, 72, 37);
        else
            cancel.frame = CGRectMake(10, 0, 72, 37);
        
        [cancel setBackgroundImage:[UIImage imageNamed:@"keyboard-01-done-down.png"] forState:UIControlStateNormal];
        [cancel addTarget:self  action:@selector(cancel:) forControlEvents:UIControlEventTouchDown];
        [datePickerView addSubview:cancel];

        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 38, 320, 300)];
        else
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 38, 768, 300)];
        
        datePicker.datePickerMode = UIDatePickerModeTime;
        datePicker.hidden = NO;
        datePicker.date = [NSDate date];
        [datePicker addTarget:self action:@selector(LabelChange:) forControlEvents:UIControlEventValueChanged];
        [datePickerView addSubview:datePicker];
        
        [self.view addSubview:datePickerView];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            snoozeNewOptionView.frame = CGRectMake(snoozeNewOptionView.frame.origin.x, -40, snoozeNewOptionView.frame.size.width, snoozeNewOptionView.frame.size.height);
        
        datePicker.tag = 4;
        selectedEndTime = datePicker.date;
        
    }
    
    else if(([textField isEqual:hoursTextField]) && ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone))
    {
        snoozeNewOptionView.frame = CGRectMake(snoozeNewOptionView.frame.origin.x, -30, snoozeNewOptionView.frame.size.width, snoozeNewOptionView.frame.size.height);
    }
    else if(([textField isEqual:minuteTextField]) && ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone))
    {
        snoozeNewOptionView.frame = CGRectMake(snoozeNewOptionView.frame.origin.x, -60, snoozeNewOptionView.frame.size.width, snoozeNewOptionView.frame.size.height);
    }
    
    
    [UIView commitAnimations];
}

- (void)LabelChange:(id)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    if ([sender tag] == 1)
    {
        startTextFieldRounded.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    }
    else if ([sender tag] == 2)
    {
        endTextFieldRounded.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    }
}
- (void)done:(id)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    if ([sender tag] == 1)
    {
        startTextFieldRounded.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    }
    else if ([sender tag] == 2)
    {
        endTextFieldRounded.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    }
    else if ([sender tag] == 3)
    {
        [df setTimeStyle:NSDateFormatterShortStyle];
        startTimeTextField.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    }
    else if ([sender tag] == 4)
    {
        [df setTimeStyle:NSDateFormatterShortStyle];
        endTimeTextField.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    }
    
    [datePickerView removeFromSuperview];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        snoozeNewOptionView.frame = CGRectMake(snoozeNewOptionView.frame.origin.x, 45, snoozeNewOptionView.frame.size.width, snoozeNewOptionView.frame.size.height);
        [UIView commitAnimations];
    }
    
}

- (void)cancel:(id)sender
{
    if (datePickerView != Nil)
    {
        [UIView animateWithDuration:0.1 animations:^{
            datePickerView.alpha = 1.0; datePickerView.alpha = 0.0;
        } completion:^(BOOL success) {
            if (success) {
                [datePickerView removeFromSuperview];
            }
        }];
    }
    
    BOOL iPhone = NO;
	
#ifdef UI_USER_INTERFACE_IDIOM
	iPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
#endif
	if (iPhone)
	{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        snoozeNewOptionView.frame = CGRectMake(snoozeNewOptionView.frame.origin.x, 45, snoozeNewOptionView.frame.size.width, snoozeNewOptionView.frame.size.height);
        [UIView commitAnimations];
    }
}

- (IBAction)transparentViewTouched:(id)sender {
    
    if (self.custom_KD_popoverView) {
        
        [self.custom_KD_popoverView dismissPopoverAnimated:YES];
    }
    transparentView.hidden=YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        textField.keyboardType = UIKeyboardTypeDefault;
        snoozeNewOptionView.frame = CGRectMake(snoozeNewOptionView.frame.origin.x, 45, snoozeNewOptionView.frame.size.width, snoozeNewOptionView.frame.size.height);
        [UIView commitAnimations];
    }
}

-(IBAction) checkBoxClicked
{
	if(isCheckedDate ==NO){
		isCheckedDate =YES;
        
        startDate.enabled = TRUE;
        endDate.enabled = TRUE;
        startTextFieldRounded.enabled = YES;
        endTextFieldRounded.enabled = YES;
        
        hours.enabled = FALSE;
        minutes.enabled = FALSE;
        hoursTextField.enabled = NO;
        minuteTextField.enabled = NO;
        
		[DICheckBox setImage:[UIImage imageNamed:@"checkbox_ticked.png"] forState:UIControlStateNormal];
        [QSCheckBox setImage:[UIImage imageNamed:@"checkbox_not_ticked.png"] forState:UIControlStateNormal];
        
        isCheckedQuickShare =YES;
        [self QScheckBoxClicked];
		
	}
    else
    {
		isCheckedDate =NO;
        
        startDate.enabled = FALSE;
        endDate.enabled = FALSE;
        startTextFieldRounded.enabled = NO;
        endTextFieldRounded.enabled = NO;
        
        hours.enabled = TRUE;
        minutes.enabled = TRUE;
        hoursTextField.enabled = YES;
        minuteTextField.enabled = YES;
        
		[QSCheckBox setImage:[UIImage imageNamed:@"checkbox_ticked.png"] forState:UIControlStateNormal];
		[DICheckBox setImage:[UIImage imageNamed:@"checkbox_not_ticked.png"] forState:UIControlStateNormal];
	}
    
}

-(IBAction) QScheckBoxClicked
{
	if(isCheckedQuickShare ==NO)
    {
		isCheckedQuickShare =YES;
        
        hours.enabled = TRUE;
        minutes.enabled = TRUE;
        hoursTextField.enabled = YES;
        minuteTextField.enabled = YES;
        
        startDate.enabled = FALSE;
        endDate.enabled = FALSE;
        startTextFieldRounded.enabled = NO;
        endTextFieldRounded.enabled = NO;
        
        
		[QSCheckBox setImage:[UIImage imageNamed:@"checkbox_ticked.png"] forState:UIControlStateNormal];
        [DICheckBox setImage:[UIImage imageNamed:@"checkbox_not_ticked.png"] forState:UIControlStateNormal];
        
        isCheckedDate = YES;
        
        [self checkBoxClicked];
        
	}else
    {
		isCheckedQuickShare =NO;
        
        startDate.enabled = TRUE;
        endDate.enabled = TRUE;
        startTextFieldRounded.enabled = YES;
        endTextFieldRounded.enabled = YES;
        
        hours.enabled = FALSE;
        minutes.enabled = FALSE;
        hoursTextField.enabled = NO;
        minuteTextField.enabled = NO;
        
        [DICheckBox setImage:[UIImage imageNamed:@"checkbox_ticked.png"] forState:UIControlStateNormal];
		[QSCheckBox setImage:[UIImage imageNamed:@"checkbox_not_ticked.png"] forState:UIControlStateNormal];
        
	}
    
}

-(IBAction) saveSnoozeClicked
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    if (reasonListButton.titleLabel.text.length == 0)
    {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select snooze reason." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert1 show];
    }
    else  if ((isCheckedDate == 0) && (isCheckedQuickShare == 0))
    {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select Date interval or Quick Snooze option." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert1 show];
    }
    else  if ([appDelegate.snoozeIntervalValue objectForKey:@"intervalTypeTime"] == nil)
    {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select snooze interval from User Based Settings and then try to set snooze." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert1 show];
    }
    else
    {
        [AppDelegate activeIndicatorStartAnimating:self.view];
        
        [self performSelector:@selector(savingSnoozeProcess) withObject:nil afterDelay:0.1];
    }
    
    //    NSString *snooze = [ServiceHelper deleteSnooze:@"ea6cfdfa-d37b-4cd3-bc50-29f80b0c6734"];
    
    //    Snooze *snoozeObj = [ServiceHelper getSnoozeBySnoozeId:@"1FE7461E-1B64-47CB-ACE5-7BCAC925D226"];
    //
    //    snoozeObj.snoozeInterval = 18;
    //
    //    Snooze *snooze = [ServiceHelper updateSnooze:snoozeObj];
    
    //    NSMutableArray *array = [ServiceHelper getAllSnooze];
    //
    //    NSLog(@"array = %@",array);
    
}

-(void)savingSnoozeProcess
{
    if (snoozeContainerView != Nil)
        [snoozeContainerView removeFromSuperview];
    if (datePickerView != Nil)
        [datePickerView removeFromSuperview];
    
    
    Snooze *snoozeObj = [self createSnoozeInstance];
    
    Snooze *snooze = [ServiceHelper addSnooze:snoozeObj];
    
    NSLog(@"snooze = %@",snooze);
    
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"" message:@"Snooze saved successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert1 show];
    
    [AppDelegate activeIndicatorStopAnimating];
    
    [self viewWillAppear:NO];
}

-(IBAction) cancelSnoozeClicked
{
    if (snoozeContainerView != Nil)
        [snoozeContainerView removeFromSuperview];
    if (datePickerView != Nil)
        [datePickerView removeFromSuperview];
}


- (IBAction)actionReasonListButtonWasPressed:(id)sender
{
    if (_dropwDownCustomTableView == nil)
    {
        refButton = (UIButton *)sender;
        
        listOfSnoozeReasons = [[NSMutableArray alloc] init];
        
        reasonListarray = [[NSMutableArray alloc] init];
        
        listOfSnoozeReasons = [ServiceHelper getAllSnoozeReasons];
        
        for (int i = 0; i < [listOfSnoozeReasons count]; i++)
        {
            SnoozeReason *snoozeReason = [listOfSnoozeReasons objectAtIndex:i];
            
            [reasonListarray addObject:snoozeReason.name];
        }
        
        // reasonListarray = [[NSMutableArray alloc] initWithObjects:@"On a plane",@"On a conference/call",@"Out of cell-range",@"Tied up on an install",@"Other", nil];
        
        _dropwDownCustomTableView = [[DropDownView alloc] initWithArrayData:reasonListarray cellHeight:35 heightTableView:160 paddingTop:-6 paddingLeft:0 paddingRight:-2 refView:refButton animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2];
        _dropwDownCustomTableView.snoozedelegate = self;
        [snoozeNewOptionView addSubview:_dropwDownCustomTableView.view];
        [_dropwDownCustomTableView openAnimation];
    }
    else
    {
        [_dropwDownCustomTableView closeAnimation];
        _dropwDownCustomTableView = nil;
    }
    
}

//- (IBAction)actionSnoozeTimeListButtonWasPressed:(id)sender
//{
//    if (_dropwDownCustomTableView == nil)
//    {
//        refButton = (UIButton *)sender;
//
//        reasonListarray = [[NSMutableArray alloc] initWithObjects:@"5 mins",@"10 mins",@"15 mins", nil];
//
//        _dropwDownCustomTableView = [[DropDownView alloc] initWithArrayData:reasonListarray cellHeight:28 heightTableView:56 paddingTop:-6 paddingLeft:0 paddingRight:-2 refView:refButton animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2];
//
//        _dropwDownCustomTableView.snoozedelegate = self;
//        [snoozeNewOptionView addSubview:_dropwDownCustomTableView.view];
//        [_dropwDownCustomTableView openAnimation];
//
//    }
//    else
//    {
//        [_dropwDownCustomTableView closeAnimation];
//        _dropwDownCustomTableView = nil;
//    }
//
//}


-(void)snoozeCellSelected:(NSInteger)returnIndex
{
    [_dropwDownCustomTableView closeAnimation];
    
    _dropwDownCustomTableView = nil;
    
    NSString *buttonTitle = [reasonListarray objectAtIndex:returnIndex];
    
    if (refButton.tag == 100)
    {
        [reasonListButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [reasonListButton setTitle:buttonTitle forState:UIControlStateNormal];
        
    }
    //    else
    //    {
    //        [snoozeListButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //
    //        [snoozeListButton setTitle:buttonTitle forState:UIControlStateNormal];
    //
    //    }
}

- (IBAction)actionSnoozeListButtonWasPressed:(id)sender
{
    if (self.actionPopView)
        [self.actionPopView removeFromSuperview];
    
    if (snoozeOptionView)
    {
        [snoozeOptionView removeFromSuperview];
        snoozeOptionView = nil;
    }
    
    [AppDelegate activityIndicatorStartAnimating:self.view];
    
    [self performSelector:@selector(switchToSnoozeListsViewController) withObject:nil afterDelay:0.1];
}

-(void)switchToSnoozeListsViewController
{
    SnoozeListsViewController *soonzeListVc=(SnoozeListsViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"SnoozeListsViewController"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:soonzeListVc];
    
    navController.navigationBar.tintColor = [[UIColor alloc] initWithRed:4.0 / 255 green:4.0 / 255 blue:7.0 / 255 alpha:1.0];
    
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentModalViewController:navController animated:YES];
   
}
- (IBAction)infoAction:(id)sender
{
    
    
}

- (void)settingsAction:(id)sender
{
    
    if ([ST_User_Role_ADMIN isEqualToString:userRollid] || [ST_User_Role_BACK_OFFICE isEqualToString:userRollid])
    {
    
    iPad = NO;
    
    mainStoryboard = nil;
    
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
    
    UserSettingsVC = (UserSettingsViewController*)[mainStoryboard
                                                   instantiateViewControllerWithIdentifier: @"UserSettingsViewController"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:UserSettingsVC];
    
    navController.navigationBar.tintColor = [[UIColor alloc] initWithRed:4.0 / 255 green:4.0 / 255 blue:7.0 / 255 alpha:1.0];
    
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentModalViewController:navController animated:YES];
    
    //  [[self navigationController] pushViewController:UserSettingsVC animated:YES];
    
    }
    else
    {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"Privilege" message:@"Please check your login, For accessing Settings you should have Admin, Back office access." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertV show];
    }
}

-(void)doneClicked
{
	[self dismissModalViewControllerAnimated:YES];
}

- (Snooze *) createSnoozeInstance
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    NSLog(@"reasonListButton.titleLabel.text = %@",reasonListButton.titleLabel.text );
    
	Snooze *snooze = nil;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMdd"];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hhmmss"];
    
    NSDateFormatter *timeZone = [[NSDateFormatter alloc] init];
    [timeZone setDateFormat:@"ZZZ"];
    
    snoozeCompleted = NO;
    
    NSMutableDictionary *SnoozeReasonsDictionary = [[NSMutableDictionary alloc] init];
    [SnoozeReasonsDictionary setValue:@"989A5548-2728-4B2D-B87C-0163DAF021DC" forKey:@"On a plane"];
    [SnoozeReasonsDictionary setValue:@"B6AB5590-5367-409F-BBDA-D1C9BE29A76F" forKey:@"On a conference/call"];
    [SnoozeReasonsDictionary setValue:@"BD8626CB-60D0-41C7-89FB-75D70EBC777E" forKey:@"Out of cell-range"];
    [SnoozeReasonsDictionary setValue:@"24747D08-4283-4970-9C93-54B320A1490D" forKey:@"Tied up on an install"];
    [SnoozeReasonsDictionary setValue:@"690226E0-1406-4AD6-8BB4-3C8B84A04D5D" forKey:@"Other"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMddyyyyHHmmssZZZ"];
    
    NSDate *today = [NSDate date];
    
    NSString *reasonId;
    
    for (int i = 0; i < [listOfSnoozeReasons count]; i++)
    {
        SnoozeReason *snoozeReason = [listOfSnoozeReasons objectAtIndex:i];
        
        if([snoozeReason.name isEqualToString:reasonListButton.titleLabel.text])
        {
            reasonId = snoozeReason.reasonId;
        }
    }
    
    
    //    NSArray *components=[snoozeListButton.titleLabel.text componentsSeparatedByString:@" "];
    
    
	@try
	{
		if (snooze == nil)
		{
			snooze = [[Snooze alloc] init];
		}
        
        [snooze setSnoozeId:[NSString stringWithUUID]];
        [snooze setTicketId:[[[[self appDelegate] selectedEntities] ticketMonitor] ticketTicketId]];
		[snooze setReasonId:reasonId];
		[snooze setIsCompleted:[NSString stringWithFormat:@"%d",snoozeCompleted]];
        [snooze setCompletedDate:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:today]]];
		[snooze setIsDateInterval:[NSString stringWithFormat:@"%d",isCheckedDate]];
        [snooze setIsQuickShare:[NSString stringWithFormat:@"%d",isCheckedQuickShare]];
		[snooze setStartDate:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[self dateFormat:selectedStartDate anddate2:selectedStartTime andZone:selectedStartDate]]]];
        [snooze setEndDate:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[self dateFormat:selectedEndDate anddate2:selectedEndTime andZone:selectedEndDate]]]];
        
        if([appDelegate.snoozeIntervalValue objectForKey:@"intervalTypeTime"] != nil)
            [snooze setSnoozeInterval:[[appDelegate.snoozeIntervalValue objectForKey:@"intervalTypeTime"] intValue]];
        else
            [snooze setSnoozeInterval:5];
        
        IntervalType *intervalType = [appDelegate.snoozeIntervalValue objectForKey:@"intervalType"];
        
        if([appDelegate.snoozeIntervalValue objectForKey:@"intervalType"] != nil)
            [snooze setIntervalTypeId:intervalType.intervalTypeId];
        else
            [snooze setIntervalTypeId:@"257195b1-f76a-4f45-9534-42c8386237db"];
        
		[snooze setCreateDate:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:today]]];
		[snooze setEditDate:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:today]]];
        
   	}
	@catch (NSException *exception)
	{
		NSLog(@"Error in createTicketInstance.  Error: %@", [exception description]);
	}
	@finally
	{
		return snooze;
	}
}

-(NSDate *)dateFormat:(NSDate *)date1 anddate2:(NSDate *)date2 andZone:(NSDate *)zone
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date1];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    NSTimeZone *timezone = [components timeZone];
    
    components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit fromDate:date2];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:second];
    [comps setTimeZone:timezone];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *originalDate = [cal dateFromComponents:comps];
    
    return originalDate;
    
}
//- (Snooze *) createSnoozeInstance
//{
//	Snooze *snooze = nil;
//
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"MMdd"];
//
//    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
//    [timeFormat setDateFormat:@"hhmmss"];
//
//    NSDateFormatter *timeZone = [[NSDateFormatter alloc] init];
//    [timeZone setDateFormat:@"ZZZ"];
//
//    snoozeCompleted = NO;
//
//    NSMutableDictionary *SnoozeReasonsDictionary = [[NSMutableDictionary alloc] init];
//    [SnoozeReasonsDictionary setValue:@"989A5548-2728-4B2D-B87C-0163DAF021DC" forKey:@"On a plane"];
//    [SnoozeReasonsDictionary setValue:@"B6AB5590-5367-409F-BBDA-D1C9BE29A76F" forKey:@"On a conference/call"];
//    [SnoozeReasonsDictionary setValue:@"BD8626CB-60D0-41C7-89FB-75D70EBC777E" forKey:@"Out of cell-range"];
//    [SnoozeReasonsDictionary setValue:@"24747D08-4283-4970-9C93-54B320A1490D" forKey:@"Tied up on an install"];
//    [SnoozeReasonsDictionary setValue:@"690226E0-1406-4AD6-8BB4-3C8B84A04D5D" forKey:@"Other"];
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MMddyyyyhhmmssZZZ"];
//
//    NSDate *today = [NSDate date];
//
//    NSArray *components=[snoozeListButton.titleLabel.text componentsSeparatedByString:@" "];
//
//	@try
//	{
//		if (snooze == nil)
//		{
//			snooze = [[Snooze alloc] init];
//		}
//
//        [snooze setSnoozeId:[NSString stringWithUUID]];
//        [snooze setTicketId:[[[[self appDelegate] selectedEntities] ticketMonitor] ticketTicketId]];
//		[snooze setReasonId:[SnoozeReasonsDictionary objectForKey:reasonListButton.titleLabel.text]];
//		[snooze setIsCompleted:[NSString stringWithFormat:@"%d",snoozeCompleted]];
//		[snooze setCompletedDate:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:today]]];
//		[snooze setIsDateInterval:[NSString stringWithFormat:@"%d",isCheckedDate]];
//        [snooze setIsQuickShare:[NSString stringWithFormat:@"%d",isCheckedQuickShare]];
//
//        NSString *theDate = [dateFormat stringFromDate:selectedStartDate];
//        NSString *theTime = [timeFormat stringFromDate:selectedStartTime];
//        NSString *theZone = [timeZone stringFromDate:selectedStartDate];
//
//		[snooze setStartDate:[NSString stringWithFormat:@"\%@%@%@", theDate, theTime,theZone]];
//
//        theDate = [dateFormat stringFromDate:selectedEndDate];
//        theTime = [timeFormat stringFromDate:selectedEndTime];
//        theZone = [timeZone stringFromDate:selectedEndDate];
//
//		[snooze setEndDate:[NSString stringWithFormat:@"\%@%@%@", theDate, theTime,theZone]];
//        [snooze setSnoozeInterval:[[components objectAtIndex:0] intValue]];
//        [snooze setIntervalTypeId:@"257195b1-f76a-4f45-9534-42c8386237db"];
//		[snooze setCreateDate:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:today]]];
//		[snooze setEditDate:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:today]]];
//
//   	}
//	@catch (NSException *exception)
//	{
//		NSLog(@"Error in createTicketInstance.  Error: %@", [exception description]);
//	}
//	@finally 
//	{    		
//		return snooze;
//	}	
//}


@end
