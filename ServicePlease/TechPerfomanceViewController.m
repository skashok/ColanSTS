//
//  TechPerformaceViewController.m
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 22/05/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "TechPerfomanceViewController.h"
#import "ApplicationListViewController.h"
#import "TechPerformaceCell.h"
#import "TicketMonitorViewController.h"
#import "ApplicationListViewController.h"

@implementation TechPerfomanceViewController

@synthesize appDelegate = _appDelegate ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    iPad = NO;
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    
    if (iPad)
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle: nil];
        [self cretateCustomNavBarBtnItems:CGRectMake(0,0,50,26) imageName:@"left.png" method:@"leftNavBtnPressed"];
        [self cretateCustomNavBarBtnItems:CGRectMake(0,0,50,26) imageName:@"right.png" method:@"rightNavBtnPressed"];
    }
    else
    {
        // iPhone/iPod specific code here
        mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle: nil];
        [self cretateCustomNavBarBtnItems:CGRectMake(0,0,26,26) imageName:@"left.png" method:@"leftNavBtnPressed"];
        [self cretateCustomNavBarBtnItems:CGRectMake(0,0,26,26) imageName:@"right.png" method:@"rightNavBtnPressed"];
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.view.userInteractionEnabled=NO;
    
    [AppDelegate  activeIndicatorStartAnimating:self.view];
    
    [self performSelectorInBackground:@selector(processinBackgroun) withObject:nil];
    
    [super viewDidLoad];
    
    techMetrics = [[TechMetrics alloc]init];
    techMetricsOBJ = [[NSMutableArray alloc]init];
    
    ascendingSortting_Tech = YES ;
    ascendingSortting_TTO  = YES ;
    ascendingSortting_TTC  = YES ;
    ascendingSortting_ATO  = YES ;
    ascendingSortting_ART  = YES ;
    ascendingSortting_FB  = YES ;
    
}

-(void)cretateCustomNavBarBtnItems:(CGRect )size imageName:(NSString *)image method:(NSString*)selector
{
    if  ([selector isEqualToString:@"rightNavBtnPressed"])
    {
        UIImage *BtnImage=[UIImage imageNamed:image];
        UIButton *navBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        navBtn.bounds=(size);
        [navBtn setImage:BtnImage forState:UIControlStateNormal];
        [navBtn addTarget:self action:@selector(rightNavBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *BtnItem=[[UIBarButtonItem alloc]initWithCustomView:navBtn];
        self.navigationItem.rightBarButtonItem=BtnItem;
    }
    else if ([selector isEqualToString:@"leftNavBtnPressed"])
    {
        UIImage *BtnImage=[UIImage imageNamed:image];
        UIButton *navBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        navBtn.bounds=(size);
        [navBtn setImage:BtnImage forState:UIControlStateNormal];
        [navBtn addTarget:self action:@selector(leftNavBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *BtnItem=[[UIBarButtonItem alloc]initWithCustomView:navBtn];
        self.navigationItem.leftBarButtonItem=BtnItem;
        
    }
}

-(void)leftNavBtnPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavBtnPressed
{
    [self moveForwardToTMScreen:nil tableView:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)processinBackgroun
{
    NSMutableArray *listOfContacts = [ServiceHelper getUsers];
    
    NSMutableArray *passUserIdArray=[[NSMutableArray alloc]init];
    
    if (techNameArray!=nil)
    {
        techNameArray=nil;
    }
    techNameArray=[[NSMutableArray alloc] init];
    
    for (int loop=0; loop<[listOfContacts count]; loop++)
    {
        User *useObj=[listOfContacts objectAtIndex:loop];
        NSString *strPassId=useObj.userId;
        [passUserIdArray addObject:strPassId];
        
        [techNameArray addObject:useObj.userName];
    }
    
    if (TotalOpenTicketAvailabeArray!=nil)
    {
        TotalOpenTicketAvailabeArray=nil;
    }
    TotalOpenTicketAvailabeArray=[[NSMutableArray alloc]init];
    
    if (TotalCloseTicketArray!=nil)
    {
        TotalCloseTicketArray=nil;
    }
    
    if(avgTimeCloseTechPerfomId!=nil)
    {
        avgTimeCloseTechPerfomId=nil;
    }
    
    avgTimeCloseTechPerfomId=[[NSMutableArray alloc]init];
    
    TotalCloseTicketArray=[[NSMutableArray alloc] init];
    
    NSDate *currentDate=[NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    NSString *strCurDate=[dateFormatter stringFromDate:currentDate];
    //NSLog(@"strCurDate==>%@",strCurDate);
    
    NSArray *arraySeperator=[strCurDate componentsSeparatedByString:@"-"];
    NSString *month=[arraySeperator objectAtIndex:1];
    NSString *date=[arraySeperator objectAtIndex:2];
    NSString *year=[arraySeperator objectAtIndex:0];
    
    int findDate1=[date intValue];
    int findMonth=[month intValue];
    int findYear=[year intValue];
    
    if (findMonth>3)
    {
        findMonth=findMonth-3;
    }
    else {
        if (findMonth==1)
        {
            findMonth=12-2;
        }
        else if(findMonth==2)
        {
            findMonth=findMonth-1;
        }
        findYear=findYear-1;
    }
    
    NSString *startDate=[[NSString alloc] initWithFormat:@"%d-%d-%d",findYear,findMonth,findDate1];
    NSLog(@"startDate==>%@",startDate);
    
    TotalOpenTicketAvailabeArray=[ServiceHelper getTotalticketopen:passUserIdArray startDate:startDate endDate:strCurDate];
    
    TotalCloseTicketArray=[ServiceHelper getTicketclose:passUserIdArray startDate:startDate endDate:strCurDate];
    
    avgTimeCloseTechPerfomId=[ServiceHelper averageTimeToCloseByTech:passUserIdArray startDate:startDate endDate:strCurDate];
    
    if (avgResponseTimeArray!=nil)
    {
        avgResponseTimeArray=[[NSMutableArray alloc]init];
    }
    
    avgResponseTimeArray = [ServiceHelper averageResponseTime:passUserIdArray startDate:
                            startDate endDate:strCurDate];
    
    for (int i=0;i<[techNameArray count] ; i++)
    {
        
        TechMetrics *tech=[[TechMetrics alloc]init];
        
        tech.techName = [techNameArray objectAtIndex:i];
        tech.TTO = [[TotalOpenTicketAvailabeArray objectAtIndex:i]floatValue];
        tech.TTC = [[TotalCloseTicketArray objectAtIndex:i]floatValue];
        tech.ATO = [[avgTimeCloseTechPerfomId objectAtIndex:i]floatValue];
        tech.ART = [[avgResponseTimeArray objectAtIndex:i]floatValue];
        tech.FB  = 2.0;
        
        [techMetricsOBJ addObject:tech];
    }
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    id object;
    int RemoveObjectIndex;
    
    for (int i=0; i<[techMetricsOBJ count];i++ )
    {
        techMetrics=[techMetricsOBJ objectAtIndex:i];
        
        if ([([[[self.appDelegate selectedEntities] user]userName]) isEqualToString:techMetrics.techName ])
        {
            object=[techMetricsOBJ objectAtIndex:i];
            RemoveObjectIndex=i;
        }
    }
    
    [techMetricsOBJ removeObjectAtIndex:RemoveObjectIndex];
    [techMetricsOBJ insertObject:object atIndex:0];
  
    NSString *userRollid=[[[[self appDelegate] selectedEntities]user]userRollId];
   
    if (![ST_User_Role_ADMIN isEqualToString:userRollid])
    {
        for (int i=1; i<[techMetricsOBJ count];i++ )
        {
            techMetrics=[techMetricsOBJ objectAtIndex:i];
            [techMetrics setTechName:[NSString stringWithFormat:@"Tech %i",i+1]];
        }
    }
   
    [techPerformaceTblView reloadData];
    
    [AppDelegate  activeIndicatorStopAnimating];
    
    self.view.userInteractionEnabled=YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	
    return [techMetricsOBJ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"TechPerformaceCell";
    
    TechPerformaceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
	{
        cell = [[TechPerformaceCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    techMetrics=[techMetricsOBJ objectAtIndex:indexPath.row];
    int TTC=(int)[techMetrics TTC];
    int TTO=(int)[techMetrics TTO];
  
    [[cell techLbl] setText:([[techMetrics techName] length] >= 7) ? [[techMetrics techName] substringToIndex:7]:[techMetrics techName]];

    cell.TTOLbl.text=[NSString stringWithFormat:@"%d",TTO];
    cell.TTCLbl.text=[NSString stringWithFormat:@"%d",TTC];
    
    float f =[techMetrics ATO];
    int result=(int)roundf(f);
    
    if (result>=24)
    {
        float fresult1=(float)result/24;
        NSString *substing=[NSString stringWithFormat:@"%f",fresult1];
        NSArray *array=[substing componentsSeparatedByString:@"."];
        NSString *day=[array objectAtIndex:0];
        NSString *hour=[array objectAtIndex:1];
        hour=[NSString stringWithFormat:@"0.%@",hour] ;
        float f=[hour floatValue];
        int findHour=(float)f*24;
        
        if (findHour>0)
        {
            cell.ATOLbl.text=[NSString stringWithFormat:@"%@d %dh",day,findHour];
        }
        else
        {
            cell.ATOLbl.text=[NSString stringWithFormat:@"%@d",day];
        }
    }
    else
    {
        cell.ATOLbl.text=[NSString stringWithFormat:@"%dh",result];
    }
    
    float fART=[techMetrics ART];
    int resultART=(int)roundf(fART);
    
    if (resultART>=60)
    {
        float fresult=(float)resultART/60;
        NSString *substing=[NSString stringWithFormat:@"%f",fresult];
        NSArray *array=[substing componentsSeparatedByString:@"."];
        NSString *Hour=[array objectAtIndex:0];
        
        NSString *Minutes=[array objectAtIndex:1];
        Minutes=[NSString stringWithFormat:@"0.%@",Minutes] ;
        float f=[Minutes floatValue];
        int findMinutes=(float)f*60;
        if (findMinutes>0)
        {
            cell.ARTLbl.text=[NSString stringWithFormat:@"%@h %dm",Hour,findMinutes];
        }
        else
        {
            cell.ARTLbl.text=[NSString stringWithFormat:@"%@h",Hour];
        }
    }
    else if(resultART>=0 && resultART<=59)
    {
        cell.ARTLbl.text=[NSString stringWithFormat:@"%d m",resultART];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self moveForwardToTMScreen:indexPath tableView:tableView];
}


#pragma mark - Table view delegate
- (void)moveForwardToTMScreen:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TicketMonitorViewController *ticketMonitorController = (TicketMonitorViewController*)[mainStoryboard
                                                                                          instantiateViewControllerWithIdentifier:@"TicketMonitorViewController"];
    
    [[self navigationController] pushViewController:ticketMonitorController animated:YES];
}

#pragma mark - Single Tap filter Methods

-(IBAction)singleTabSorting:(UIButton *)sender
{
    switch (sender.tag) {
            
        case 1:
        {
            if (ascendingSortting_Tech)
            {
                techMetricsOBJ=[[self sortingArrayWithString:techMetricsOBJ sortDescriptorKEy:@"techName" ascending:YES]mutableCopy];
                ascendingSortting_Tech = NO;
            }
            else
            {
                techMetricsOBJ=[[self sortingArrayWithString:techMetricsOBJ sortDescriptorKEy:@"techName" ascending:NO]mutableCopy];
                ascendingSortting_Tech = YES;
            }
        }
            break;
            
        case 2:
        {
            if (ascendingSortting_TTO)
            {
                techMetricsOBJ=[self sortingArray:techMetricsOBJ sortDescriptorKEy:@"TTO" ascending:YES];
                ascendingSortting_TTO = NO;
            }
            else
            {
                techMetricsOBJ=[self sortingArray:techMetricsOBJ sortDescriptorKEy:@"TTO" ascending:NO];
                ascendingSortting_TTO = YES;
            }
        }
            break;
            
        case 3:
        {
            if (ascendingSortting_TTC)
            {
                techMetricsOBJ=[self sortingArray:techMetricsOBJ sortDescriptorKEy:@"TTC" ascending:YES];
                ascendingSortting_TTC = NO;
            }
            else
            {
                techMetricsOBJ=[self sortingArray:techMetricsOBJ sortDescriptorKEy:@"TTC" ascending:NO];
                ascendingSortting_TTC = YES;
            }
        }
            break;
            
        case 4:
        {
            if (ascendingSortting_ATO)
            {
                techMetricsOBJ=[self sortingArray:techMetricsOBJ sortDescriptorKEy:@"ATO" ascending:YES];
                ascendingSortting_ATO = NO;
            }
            else
            {
                techMetricsOBJ=[self sortingArray:techMetricsOBJ sortDescriptorKEy:@"ATO" ascending:NO];
                ascendingSortting_ATO = YES;
            }
        }
            break;
            
        case 5:
        {
            if (ascendingSortting_ART)
            {
                techMetricsOBJ=[self sortingArray:techMetricsOBJ sortDescriptorKEy:@"ART" ascending:YES];
                ascendingSortting_ART = NO;
            }
            else
            {
                techMetricsOBJ=[self sortingArray:techMetricsOBJ sortDescriptorKEy:@"ART" ascending:NO];
                ascendingSortting_ART = YES;
            }
        }
            break;
        case 6:
        {
            if (ascendingSortting_FB)
            {
                techMetricsOBJ=[self sortingArray:techMetricsOBJ sortDescriptorKEy:@"FB" ascending:YES];
                ascendingSortting_FB = NO;
            }
            else
            {
                techMetricsOBJ=[self sortingArray:techMetricsOBJ sortDescriptorKEy:@"FB" ascending:NO];
                ascendingSortting_FB = YES;
            }
        }
            break;
            
        default:
            break;
            
    }
    [techPerformaceTblView reloadData];
}

-(NSMutableArray *)sortingArray:(NSMutableArray *)unsoretedArray sortDescriptorKEy:(NSString *)descriptionKey ascending:(BOOL)boolValue
{
    NSMutableArray *sortedArray;
    
    NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:descriptionKey ascending:boolValue comparator:^(id obj1, id obj2) {
        
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


-(NSArray *)sortingArrayWithString:(NSMutableArray *)unsoretedArray sortDescriptorKEy:(NSString *)descriptionKey ascending:(BOOL)boolValue  {
    
    NSArray *sortedArray;
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:descriptionKey
                                                 ascending:boolValue] ;
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    sortedArray = [unsoretedArray sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
}

@end
