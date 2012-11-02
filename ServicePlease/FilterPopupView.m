//
//  MyPopOverView.m
//  iPadTutorial
//
//  Created by Jannis Nikoy on 4/3/10.
//  Copyright 2010 Jannis Nikoy. All rights reserved.
//

#import "FilterPopupView.h"
#import "Location.h"
#import "Contact.h"
#import "SPTypes.h"
#import "Category.h"
#import "Tech.h"
#import "UserRolls.h"

#define kCellImageViewTag           1000

@implementation FilterPopupView

@synthesize selectedIndexes;
@synthesize tableView;
@synthesize rootPopUpViewController;
@synthesize appDelegate;
@synthesize popupView;
@synthesize tableViewContainer;
@synthesize filterDelegate;
@synthesize CatDelegate;
@synthesize done;
@synthesize titleLabel;
@synthesize titleView = _titleView;
@synthesize TechDelegate;

-(void)awakeFromNib {
    
    // NSLog(@"awakeFromNib ... ");
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    // NSLog(@"self.appDelegate.currentTMFilter ... %d",self.appDelegate.currentTMFilter);
    
    switch (self.appDelegate.currentTMFilter) 
    {
        case LOCATION_FILTER:
        {
            listArray = [[NSMutableArray alloc] initWithArray:self.appDelegate.filterListOfLocations];
        }
            break;
        case CONTACT_FILTER:
        {
            listArray = [[NSMutableArray alloc] initWithArray:self.appDelegate.filterListOfContacts];
        }
            break;
        case SINCE_FILTER:
        {
            listArray = [[NSMutableArray alloc] initWithArray:self.appDelegate.filterListOfSinceTypes];
            
        }
            break;
        case TICKET_FILTER:
        {
            
        }
            break;
        case CATEGORY_FILTER:
        {
            listArray = [[NSMutableArray alloc] initWithArray:self.appDelegate.filterListOfCategories];
        }
            break;
        case TECH_FILTER:
        {
            listArray = [[NSMutableArray alloc] initWithArray:self.appDelegate.filterListOfTechs];
        }
            break;
        case STATUS_FILTER:
        {
            listArray = [[NSMutableArray alloc] initWithArray:self.appDelegate.filterListOfStatus];
        }
            break;
        case SERVICEPLAN_FILTER:
        {
            listArray = [[NSMutableArray alloc] initWithArray:self.appDelegate.filterListOfSPTypes];
        }
            break;
            
            
        default:
            break;
    }
    
    [super awakeFromNib];
    
}


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  array:(NSMutableArray *)list{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
        // listArray = [[NSMutableArray alloc] initWithArray:list copyItems:YES];
    }
    return self;
}

- (void) viewWillDisappear: (BOOL)animated
{
    [self stop];
}
-(void)stop
{
    if((CatDelegate != nil) && ([selectedIndexes count] == 0) && (!donePressed))
    {
        [self.appDelegate.curprobSoluVC performSelector:@selector(threadStopAnimating:) withObject:nil afterDelay:0.1];
    }
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
    {
        self.titleView.frame = CGRectMake(0, 0, 300, 42);
        titleLabel.frame = self.titleView.bounds;
    }
    if(filterDelegate != nil)
	{
        [listArray insertObject:@"Show all" atIndex:0];
    }
    
    switch (self.appDelegate.currentTMFilter)
    {
            [titleLabel setText:@"Locations"];
            [titleLabel setTextColor:[UIColor whiteColor]];
        case LOCATION_FILTER:
            [titleLabel setText:@"Locations"];
            break;
        case CONTACT_FILTER:
            [titleLabel setText:@"Contacts"];
            break;
        case SINCE_FILTER:
            [titleLabel setText:@"Time Elapsed"];
            break;
        case TICKET_FILTER:
            [titleLabel setText:@"Tickets"];
            break;
        case CATEGORY_FILTER:
            [titleLabel setText:@"Categories"];
            break;
        case TECH_FILTER:
            [titleLabel setText:@"Tech"];
            break;
        case STATUS_FILTER:
            [titleLabel setText:@"Status"];
            break;
        case SERVICEPLAN_FILTER:
            [titleLabel setText:@"Service Plan"];
            break;
        default:
            break;
    }
    tableView.allowsMultipleSelection = YES;
    
    if((TechDelegate != nil) || (CatDelegate != nil))
    {
        tableView.allowsMultipleSelection = NO;
    }
    
    
    if(TechDelegate != nil)
    {
        roleType = [self UserRole];
        
        if (roleType == 2)
        {
            NSString *userName=[[[[self appDelegate]selectedEntities]user]userName];
            
            for (int i = 0; i < [listArray count] ; i++)
            {
                Tech *tech = [listArray objectAtIndex:i];
                
                if ([tech.userName isEqualToString:userName])
                {
                    position = i;
                    NSIndexPath *ip=[NSIndexPath indexPathForRow:i inSection:0];
                    [tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
                }
            }
        }
    }
    
    selectedIndexes = [[NSMutableArray alloc] init];
    donePressed = NO;
    
}

-(int)UserRole
{
    int value = 0;
    NSString *userRollid=[[[[self appDelegate]selectedEntities]user]userRollId];
    
    if ([ST_User_Role_ADMIN isEqualToString:userRollid] || [ST_User_Role_BACK_OFFICE isEqualToString:userRollid]) 
    {
        value = 1;
    }
    else if ([ST_User_Role_TECH isEqualToString:userRollid] || [ST_User_Role_TECH_SUPER isEqualToString:userRollid]) 
    {
        value = 2;
    }
    return value;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(TechDelegate != nil)
    {
        if (roleType == 2) 
            return false;
        else 
            return indexPath;
    }
    else 
    {
        return indexPath;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listArray count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return  1;
}

-(UITableViewCell *)tableView:(UITableView *)tableViewObj cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableViewObj dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier] ;
    }
    
    if(TechDelegate != nil)
    {
        if ((roleType == 2) && (position != indexPath.row))
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        else {
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
    
    
    NSUInteger row = [indexPath row];
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    switch (self.appDelegate.currentTMFilter)
    {
        case LOCATION_FILTER:
        {
            if (row == 0) 
                cell.textLabel.text = @"Show all";
            else 
            {
                Location *curLocation = [listArray objectAtIndex:row];
                cell.textLabel.text = [curLocation locationName];
            }
        }
            break;
        case CONTACT_FILTER:
        {
            tableView.allowsMultipleSelection = NO;
            if (row == 0)
                cell.textLabel.text = @"Show all";
            else 
            {
                Contact *curcontact = [listArray objectAtIndex:row];
                cell.textLabel.text = [curcontact contactName];
            }
        }
            break;
        case SINCE_FILTER:
        {
            cell.textLabel.text = [listArray objectAtIndex:row];
        }
            break;
        case TICKET_FILTER:
        {
        }
            break;
        case CATEGORY_FILTER:
        {
            if (row == 0) 
            {
                if(filterDelegate != nil)
                    cell.textLabel.text = @"Show all";
                else if(CatDelegate != nil)
                {
                    Category *curCategory = [listArray objectAtIndex:row];
                    cell.textLabel.text = [curCategory categoryName];
                }
            }
            else 
            {
                Category *curCategory = [listArray objectAtIndex:row];
                cell.textLabel.text = [curCategory categoryName];
            }
        }
            break;
        case TECH_FILTER:
        {
            if (row == 0) 
            {
                if(filterDelegate != nil)
                    cell.textLabel.text = @"Show all";
                else if((CatDelegate != nil) || (TechDelegate != nil))
                {
                    Tech *curTech = [listArray objectAtIndex:row];
                    cell.textLabel.text = [curTech userName];
                }
            }
            else 
            {
                Tech *curTech = [listArray objectAtIndex:row];
                cell.textLabel.text = [curTech userName];
            }
        }
            break;
        case STATUS_FILTER:
        {
            if (row == 0) 
                cell.textLabel.text = @"Show all";
            else 
            {
                tableView.allowsMultipleSelection = NO;
                cell.textLabel.text = [listArray objectAtIndex:row];
            }
        }
            break;
        case SERVICEPLAN_FILTER:
        {
            if (row == 0) 
                cell.textLabel.text = @"Show all";
            else 
            {
                SPTypes *curSPTypes = [listArray objectAtIndex:row];
                cell.textLabel.text = [curSPTypes name];
            }
        }
            break;
            
            
        default:
            break;
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableViewObj didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(filterDelegate != nil)
	{
        if (indexPath.row == 0)
        {
            for (int loop = 0; loop < [selectedIndexes count]; loop ++)
            {
                NSLog(@"[selectedIndexes objectAtIndex:loop] = %d",[[selectedIndexes objectAtIndex:loop] intValue]);
                
                [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:[[selectedIndexes objectAtIndex:loop] intValue] inSection:0] animated:YES];
            }
            [selectedIndexes removeAllObjects];
            [selectedIndexes addObject:[NSNumber numberWithInt:indexPath.row]];
        }
        else 
        {
            if ((lastIndexpath == 0) && ([selectedIndexes count] > 0))
            {
                [selectedIndexes removeAllObjects];
            }
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
            [selectedIndexes addObject:[NSNumber numberWithInt:indexPath.row]];
        }
        lastIndexpath = indexPath.row;
    }
    else {
        [selectedIndexes addObject:[NSNumber numberWithInt:indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableViewObj didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [selectedIndexes removeObject:[NSNumber numberWithInt:indexPath.row]];
}
- (IBAction)done:(id)sender
{
    donePressed = YES;
    if(TechDelegate != nil)
	{
        if (([tableView indexPathForSelectedRow] != nil) && (roleType == 2))
        {
            [selectedIndexes addObject:[NSNumber numberWithInt:[tableView indexPathForSelectedRow].row]];
        }
        if([selectedIndexes count] == 0)
        {
            self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            
            [TechDelegate TechSelected:nil];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"please select a Tech from the list." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    if(filterDelegate != nil)
	{
        self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
        [self.appDelegate.curprobSoluVC dismissPopover];
        
        if([selectedIndexes count] == 0)
        {
            [self.appDelegate.curprobSoluVC threadStartAnimating:nil];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"please select a Category from the list." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    if(CatDelegate != nil)
	{
        if([selectedIndexes count] == 0)
        {
            donePressed = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"please select a Tech from the list." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    // NSLog(@"selectedIndexes = %@",selectedIndexes);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //  [selectedIndexes removeAllObjects];
        if (tableView !=nil) 
            [tableView reloadData];
        [self.view removeFromSuperview];  
    }
    else 
    {
        //  [selectedIndexes removeAllObjects];
        if (tableView !=nil) 
            [tableView reloadData];
        [self.rootPopUpViewController dismissPopoverAnimated:YES];
    }
    if(filterDelegate != nil)
	{
        self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        switch (self.appDelegate.currentTMFilter) 
        {
            case LOCATION_FILTER:
            {
                
                NSMutableString *selectedLocationIds = [[NSMutableString alloc] init];
                
                if (([selectedIndexes count] == 1) && ([[selectedIndexes objectAtIndex:0] intValue] == 0))
                {
                    /* for (int k=1 ; k<[listArray count] ; k++) 
                     {
                     Location *curLocation = [listArray objectAtIndex:k];
                     
                     if(k == 1)
                     {
                     [selectedLocationIds appendString:@"[\""] ;
                     [selectedLocationIds appendFormat:curLocation.locationId];
                     if(k == [listArray count] - 1)
                     [selectedLocationIds appendString:@"\"]"];
                     else 
                     [selectedLocationIds appendString:@"\",\""];
                     }
                     else if(k == [listArray count] - 1)
                     {
                     [selectedLocationIds appendFormat:curLocation.locationId];
                     [selectedLocationIds appendString:@"\"]"];
                     }
                     else 
                     {
                     [selectedLocationIds appendFormat:curLocation.locationId];
                     [selectedLocationIds appendString:@"\",\""];
                     }
                     }
                     
                     NSLog(@"[selectedLocationIds] = %@",selectedLocationIds);
                     
                     [filterDelegate showallFilterServiceFinished:selectedLocationIds]; */
                    
                    [filterDelegate filterServiceFinished:nil];
                }
                else 
                {
                    for (int k=0 ; k<[selectedIndexes count] ; k++) 
                    {
                        
                        Location *curLocation = [listArray objectAtIndex:[[selectedIndexes objectAtIndex:k] intValue]];
                        
                        if(k == 0)
                        {
                            [selectedLocationIds appendString:@"[\""]; 
                            [selectedLocationIds appendFormat:@"%@",curLocation.locationId];
                            if(k == [selectedIndexes count] - 1)
                                [selectedLocationIds appendString:@"\"]"];
                            else 
                                [selectedLocationIds appendString:@"\",\""];
                        }
                        else if(k == [selectedIndexes count] - 1)
                        {
                            [selectedLocationIds appendFormat:@"%@",curLocation.locationId];
                            [selectedLocationIds appendString:@"\"]"];
                        }
                        else 
                        {
                            [selectedLocationIds appendFormat:@"%@",curLocation.locationId];
                            [selectedLocationIds appendString:@"\",\""];
                        }
                        // ["6c3a6c98-5e73-49d1-a3f8-934b63a7a9d9","a8f867da-d706-4b60-aced-8c911d3a9a4f"]
                    }
                    [filterDelegate filterServiceFinished:selectedLocationIds]; 
                }
            }
                break;
            case CONTACT_FILTER:
            {
                NSMutableString *combineContactLocationId = [[NSMutableString alloc] init];
                
                if (([selectedIndexes count] == 1) && ([[selectedIndexes objectAtIndex:0] intValue] == 0))
                {
                    /* for (int k=1 ; k<[listArray count] ; k++) 
                     {
                     Contact *curContact = [listArray objectAtIndex:k];
                     
                     if(k == 1)
                     {
                     [combineContactLocationId appendString:@"[\""] ;
                     [combineContactLocationId appendFormat:curContact.contactId];
                     if(k == [listArray count] - 1)
                     [combineContactLocationId appendString:@"\"]"];
                     else 
                     [combineContactLocationId appendString:@"\",\""];
                     }
                     else if(k == [listArray count] - 1)
                     {
                     [combineContactLocationId appendFormat:curContact.contactId];
                     [combineContactLocationId appendString:@"\"]"];
                     }
                     else 
                     {
                     [combineContactLocationId appendFormat:curContact.contactId];
                     [combineContactLocationId appendString:@"\",\""];
                     }
                     }
                     
                     NSLog(@"[combineContactLocationId] = %@",combineContactLocationId);
                     
                     [filterDelegate showallFilterServiceFinished:combineContactLocationId]; */
                    
                    [filterDelegate filterServiceFinished:nil];
                    
                }
                else 
                {
                    if([selectedIndexes count] > 0)
                    {
                        Contact *curContact = [listArray objectAtIndex:[[selectedIndexes objectAtIndex:0] intValue]];
                        
                        [combineContactLocationId appendString:@"[\""] ;
                        [combineContactLocationId appendString:curContact.contactId];
                        [combineContactLocationId appendString:@"\"]"];
                        
                        [filterDelegate filterServiceFinished:combineContactLocationId]; 
                    }
                }
            }
                break;
            case SINCE_FILTER:
            {
                if (([selectedIndexes count] == 1) && ([[selectedIndexes objectAtIndex:0] intValue] == 0))
                {                    
                    //[filterDelegate showallFilterServiceFinished:@"[Oldest,Newest]"]; 
                    
                    [filterDelegate filterServiceFinished:nil];
                    
                }
                else 
                {
                    
                    if ([self.selectedIndexes count] > 0) {
                        
                        if([[listArray objectAtIndex:[[self.selectedIndexes objectAtIndex:0] intValue]] isEqualToString:@"Oldest"])
                        {
                            [filterDelegate filterServiceFinished:@"Oldest"];   
                        }
                        else if([[listArray objectAtIndex:[[self.selectedIndexes objectAtIndex:0] intValue]] isEqualToString:@"Newest"])
                        {
                            [filterDelegate filterServiceFinished:@"Newest"]; 
                        }
                    }
                }
            }
                break;
            case TICKET_FILTER:
            {
                
            }
                break;
            case CATEGORY_FILTER:
            {
                NSMutableString *selectedCategoryIds = [[NSMutableString alloc] init];
                
                if (([selectedIndexes count] == 1) && ([[selectedIndexes objectAtIndex:0] intValue] == 0))
                {
                    /*  for (int k=1 ; k<[listArray count] ; k++) 
                     {
                     Category *curCategory = [listArray objectAtIndex:k];
                     
                     if(k == 1)
                     {
                     [selectedCategoryIds appendString:@"[\""] ;
                     [selectedCategoryIds appendFormat:curCategory.categoryId];
                     if(k == [listArray count] - 1)
                     [selectedCategoryIds appendString:@"\"]"];
                     else 
                     [selectedCategoryIds appendString:@"\",\""];
                     }
                     else if(k == [listArray count] - 1)
                     {
                     [selectedCategoryIds appendFormat:curCategory.categoryId];
                     [selectedCategoryIds appendString:@"\"]"];
                     }
                     else 
                     {
                     [selectedCategoryIds appendFormat:curCategory.categoryId];
                     [selectedCategoryIds appendString:@"\",\""];
                     }
                     }
                     
                     NSLog(@"[selectedCategoryIds] = %@",selectedCategoryIds);
                     
                     [filterDelegate showallFilterServiceFinished:selectedCategoryIds]; */
                    
                    [filterDelegate filterServiceFinished:nil];
                    
                }
                else 
                {                    
                    for (int k=0 ; k<[selectedIndexes count] ; k++) 
                    {
                        
                        Category *curCategory = [listArray objectAtIndex:[[selectedIndexes objectAtIndex:k] intValue]];
                        
                        if(k == 0)
                        {
                            [selectedCategoryIds appendString:@"[\""] ;
                            [selectedCategoryIds appendFormat:@"%@",curCategory.categoryId];
                            if(k == [selectedIndexes count] - 1)
                                [selectedCategoryIds appendString:@"\"]"];
                            else 
                                [selectedCategoryIds appendString:@"\",\""];
                        }
                        else if(k == [selectedIndexes count] - 1)
                        {
                            [selectedCategoryIds appendFormat:@"%@",curCategory.categoryId];
                            [selectedCategoryIds appendString:@"\"]"];
                        }
                        else 
                        {
                            [selectedCategoryIds appendFormat:@"%@",curCategory.categoryId];
                            [selectedCategoryIds appendString:@"\",\""];
                        }
                    }
                    [filterDelegate filterServiceFinished:selectedCategoryIds];
                }
            }
                break;
            case TECH_FILTER:
            {
                NSMutableString *selectedTechIds = [[NSMutableString alloc] init];
                
                if (([selectedIndexes count] == 1) && ([[selectedIndexes objectAtIndex:0] intValue] == 0))
                {
                    /*  for (int k=1 ; k<[listArray count] ; k++) 
                     {
                     Tech *curTech = [listArray objectAtIndex:k];
                     
                     if(k == 1)
                     {
                     [selectedTechIds appendString:@"[\""] ;
                     [selectedTechIds appendFormat:curTech.userId];
                     if(k == [listArray count] - 1)
                     [selectedTechIds appendString:@"\"]"];
                     else 
                     [selectedTechIds appendString:@"\",\""];
                     }
                     else if(k == [listArray count] - 1)
                     {
                     [selectedTechIds appendFormat:curTech.userId];
                     [selectedTechIds appendString:@"\"]"];
                     }
                     else 
                     {
                     [selectedTechIds appendFormat:curTech.userId];
                     [selectedTechIds appendString:@"\",\""];
                     }
                     }
                     
                     NSLog(@"[selectedTechIds] = %@",selectedTechIds);
                     
                     [filterDelegate showallFilterServiceFinished:selectedTechIds]; */
                    
                    [filterDelegate filterServiceFinished:nil];
                    
                }
                else 
                {
                    for (int k=0 ; k<[selectedIndexes count] ; k++) 
                    {
                        Tech *curTech = [listArray objectAtIndex:[[selectedIndexes objectAtIndex:k] intValue]];
                        if(k == 0)
                        {
                            [selectedTechIds appendString:@"[\""] ;
                            [selectedTechIds appendFormat:@"%@",curTech.userId];
                            if(k == [selectedIndexes count] - 1)
                                [selectedTechIds appendString:@"\"]"];
                            else 
                                [selectedTechIds appendString:@"\",\""];
                        }
                        else if(k == [selectedIndexes count] - 1)
                        {
                            [selectedTechIds appendFormat:@"%@",curTech.userId];
                            [selectedTechIds appendString:@"\"]"];
                        }
                        else 
                        {
                            [selectedTechIds appendFormat:@"%@",curTech.userId];
                            [selectedTechIds appendString:@"\",\""];
                        }
                    }
                    [filterDelegate filterServiceFinished:selectedTechIds];   
                }
            }
                break;
            case STATUS_FILTER:
            {
                if (([selectedIndexes count] == 1) && ([[selectedIndexes objectAtIndex:0] intValue] == 0))
                {
                    //   [filterDelegate showallFilterServiceFinished];
                    
                    [filterDelegate filterServiceFinished:nil];
                    
                }
                else 
                {
                    if ([self.selectedIndexes count] > 0) {
                        
                        if([[listArray objectAtIndex:[[self.selectedIndexes objectAtIndex:0] intValue]] isEqualToString:@"High"])
                        {
                            [filterDelegate filterServiceFinished:@"High"];   
                        }
                        else if([[listArray objectAtIndex:[[self.selectedIndexes objectAtIndex:0] intValue]] isEqualToString:@"Medium"])
                        {
                            [filterDelegate filterServiceFinished:@"Medium"]; 
                            
                        }else if([[listArray objectAtIndex:[[self.selectedIndexes objectAtIndex:0] intValue]] isEqualToString:@"Low"])
                        {
                            [filterDelegate filterServiceFinished:@"Low"];   
                        }
                        else if([[listArray objectAtIndex:[[self.selectedIndexes objectAtIndex:0] intValue]] isEqualToString:@"Pending"])
                        {
                            [filterDelegate filterServiceFinished:@"Pending"];   
                        }else 
                        {
                            [filterDelegate filterServiceFinished:@"Closed"];   
                        }
                    }
                }
            }
                break;
            case SERVICEPLAN_FILTER:
            {
                NSMutableString *selectedSPTypes = [[NSMutableString alloc] init];
                
                if (([selectedIndexes count] == 1) && ([[selectedIndexes objectAtIndex:0] intValue] == 0))
                {
                    /* for (int k=1 ; k<[listArray count] ; k++) 
                     {
                     SPTypes *curSPTypes = [listArray objectAtIndex:k];
                     
                     if(k == 1)
                     {
                     [selectedSPTypes appendString:@"[\""] ;
                     [selectedSPTypes appendFormat:curSPTypes.servicePlanTypeId];
                     if(k == [listArray count] - 1)
                     [selectedSPTypes appendString:@"\"]"];
                     else 
                     [selectedSPTypes appendString:@"\",\""];
                     }
                     else if(k == [listArray count] - 1)
                     {
                     [selectedSPTypes appendFormat:curSPTypes.servicePlanTypeId];
                     [selectedSPTypes appendString:@"\"]"];
                     }
                     else 
                     {
                     [selectedSPTypes appendFormat:curSPTypes.servicePlanTypeId];
                     [selectedSPTypes appendString:@"\",\""];
                     }
                     }
                     
                     NSLog(@"[selectedTechIds] = %@",selectedSPTypes);
                     
                     [filterDelegate showallFilterServiceFinished:selectedSPTypes]; */
                    
                    [filterDelegate filterServiceFinished:nil];
                    
                }
                else 
                {
                    for (int k=0 ; k<[selectedIndexes count] ; k++) 
                    {
                        SPTypes *curSPTypes = [listArray objectAtIndex:[[selectedIndexes objectAtIndex:k] intValue]];
                        if(k == 0)
                        {
                            [selectedSPTypes appendString:@"[\""] ;
                            [selectedSPTypes appendFormat:@"%@",curSPTypes.servicePlanTypeId];
                            if(k == [selectedIndexes count] - 1)
                                [selectedSPTypes appendString:@"\"]"];
                            else 
                                [selectedSPTypes appendString:@"\",\""];
                        }
                        else if(k == [selectedIndexes count] - 1)
                        {
                            [selectedSPTypes appendFormat:@"%@",curSPTypes.servicePlanTypeId];
                            [selectedSPTypes appendString:@"\"]"];
                        }
                        else 
                        {
                            [selectedSPTypes appendFormat:@"%@",curSPTypes.servicePlanTypeId];
                            [selectedSPTypes appendString:@"\",\""];
                        }
                    }
                    [filterDelegate filterServiceFinished:selectedSPTypes]; 
                }
            }
                break;
                
                
            default:
                break;
        }
    }
    
    
    if(CatDelegate != nil)
	{
        self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
        [self.appDelegate.curprobSoluVC dismissPopover];
        
        switch (self.appDelegate.currentTMFilter) 
        {
            case CATEGORY_FILTER:
            {
                if([selectedIndexes count] > 0)
                {
                    Category *curCategory = [listArray objectAtIndex:[[selectedIndexes objectAtIndex:0] intValue]];
                    
                    [self.appDelegate.selectedEntities setCategory:curCategory];
                    
                    [self.appDelegate.curprobSoluVC performSelector:@selector(CatsSelected:) withObject:curCategory.categoryId afterDelay:0.1];
                }
            }
                break;
            case TECH_FILTER:
            {
                if([selectedIndexes count] > 0)
                {
                    Tech *curTech = [listArray objectAtIndex:[[selectedIndexes objectAtIndex:0] intValue]];
                    
                    //  [CatDelegate TechSelected:curTech.userName andTechID:curTech.userId];
                    
                    [self.appDelegate.curprobSoluVC performSelector:@selector(TechSelected:) withObject:curTech afterDelay:0.1];
                    
                }
            }
                break;
                
            default:
                break;
        }
    }
    if(TechDelegate != nil)
	{            
        if([selectedIndexes count] > 0)
        {
            Tech *curTech = [listArray objectAtIndex:[[selectedIndexes objectAtIndex:0] intValue]];
            
            [TechDelegate TechSelected:curTech];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
