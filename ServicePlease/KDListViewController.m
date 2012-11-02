//
//  KDListViewController.m
//  ServiceTech
//
//  Created by Bala Subramaniyan on 19/09/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.


#import "KDListViewController.h"
#import "ProblemSolutionViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "KDListCell.h"
#import "Solution.h"
#import "LikeUnlike.h"

@implementation KDListViewController

@synthesize DoneBtn=_DoneBtn;

@synthesize custom_KD_popoverView = _custom_KD_popoverView;

@synthesize listofSolutionView;

@synthesize selectedTextView;

@synthesize appDelegate;

@synthesize locationLbl;

@synthesize CategoryLbl;

@synthesize keyWordLbl;


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
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self.appDelegate setCurrentKDListVc:self];
    
    listofSolutionArray=[[NSMutableArray alloc] init];
    predictKDSolutionArray=[[NSMutableArray alloc]init];
    selectedTextView.editable=NO;
    popoverClass     = [WEPopoverController class];
    tableDataArray=[[NSMutableArray alloc] initWithObjects:@"help",@"prob",@"help",@"prob",@"help", nil];
    
    //selectedTextView.layer.cornerRadius=10.0f;
    selectedTextView.layer.borderWidth=5;
    selectedTextView.layer.borderColor=[[UIColor blueColor] CGColor];
    
    //listofSolutionView.layer.cornerRadius=10.0f;
    listofSolutionView.layer.borderWidth=5;
    listofSolutionView.layer.borderColor=[[UIColor greenColor] CGColor];
    
    iPad =YES;
    
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    
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
    
    if (iPad) {
        
        transparentView=[[UIControl alloc]initWithFrame:CGRectMake(0,0, 768, 960)];
        
    }else {
        
        transparentView=[[UIControl alloc]initWithFrame:CGRectMake(0,0, 320, 416)];
    }
    
    [transparentView setAlpha:0.1f];
    [transparentView addTarget:self action:@selector(transparentViewtouched:)   forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:transparentView];
    transparentView.hidden = YES;
    
    [AppDelegate activeIndicatorStartAnimating:self.view];

    [super viewDidLoad];
	
    // Do any additional setup after loading the view.*
}

-(void)KD_location:(NSString *)location KD_category:(NSString *)category KD_description:(NSString *)description KDsolutionList:(NSMutableArray *)KDsolutionList
{
    NSString *searchString   = nil;
    NSString *locationString = nil;
    NSString *categoryString = nil;
    
    if (iPad) {
        locationString    = [NSString stringWithString:([location length] >= 20) ? [location substringToIndex:18]:location];
        categoryString    = [NSString stringWithString:([category length] >= 20) ? [category substringToIndex:18]:category];
    }else{
        locationString    = [NSString stringWithString:([location length] >= 7) ? [location substringToIndex:6]:location];
        categoryString    = [NSString stringWithString:([category length] >= 7) ? [category substringToIndex:6]:category];
    }
    
    if ([location isEqualToString:@"ALL"]&&[category isEqualToString:@"ALL"])
        searchString =[NSString stringWithFormat:@"/ %@ / %@ / %@",locationString,categoryString,description];
    if ([location isEqualToString:@"ALL"]&& ![category isEqualToString:@"ALL"])
        searchString =[NSString stringWithFormat:@"/ %@ / %@../ %@",locationString,categoryString,description];
    if (![location isEqualToString:@"ALL"]&&[category isEqualToString:@"ALL"])
        searchString =[NSString stringWithFormat:@"/ %@../ %@ / %@",locationString,categoryString,description];
    if (![location isEqualToString:@"ALL"]&& ![category isEqualToString:@"ALL"])
        searchString =[NSString stringWithFormat:@"/ %@../ %@../ %@",locationString,categoryString,description];
    
    locationLbl.text=searchString;
    [activityIndicator startAnimating];
    descString = description;
    
    self.appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self.appDelegate.currentServiceHelper setAsynchUrlDelegate:self];
    
}

-(IBAction)DoneBtnPressed:(id)sender
{
    NSUserDefaults * userdefaluts=[NSUserDefaults standardUserDefaults];
    bool NoMatchesFound=NO;
    [userdefaluts setBool:NoMatchesFound forKey:@"NoMatchesFound"];
    [userdefaluts synchronize];
    [self dismissModalViewControllerAnimated:NO];
}

- (IBAction)TM_BtnPressed:(id)sender
{
    NSUserDefaults * userdefaluts=[NSUserDefaults standardUserDefaults];
    bool NoMatchesFound=NO;
    [userdefaluts setBool:NoMatchesFound forKey:@"NoMatchesFound"];
    [userdefaluts synchronize];
    
    self.appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (self.appDelegate.currentKDpopPresentVC == TICKETMONITER_VC)
    {
        [self dismissModalViewControllerAnimated:YES];
        
    }else if (self.appDelegate.currentKDpopPresentVC == PROBLEMSOLUTION_VC)
    {
        [self dismissModalViewControllerAnimated:YES];
        [self.appDelegate.curprobSoluVC TM_BtnPressed:nil];
        
    }else if (self.appDelegate.currentKDpopPresentVC == KDLIST_VC)
    {
        if ([[appDelegate.curTicketMonitorVC.navigationController.viewControllers lastObject] isEqual:self.appDelegate.curTicketMonitorVC])
        {
            [self dismissModalViewControllerAnimated:YES];
        }
        else if ([[appDelegate.curTicketMonitorVC.navigationController.viewControllers lastObject] isEqual:self.appDelegate.curprobSoluVC])
        {
            [self dismissModalViewControllerAnimated:YES];
            [self.appDelegate.curprobSoluVC TM_BtnPressed:nil];
        }
    }
}
- (IBAction)KDBtnPressed:(id)sender
{
    CGSize ipadSize   = CGSizeMake(500,450);
    CGSize iphoneSize = CGSizeMake(350,330);
    transparentView.hidden=NO;
    self.appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self.appDelegate setCurrentKDpopPresentVC:KDLIST_VC];
    [self presentCustomize_KD_PopOverVC_WithSize_Ipad:&ipadSize Iphone:&iphoneSize];
}
-(void)transparentViewtouched:(UIControl *)sender {
    
    if (self.custom_KD_popoverView)
    {
        [self.custom_KD_popoverView dismissPopoverAnimated:YES];
        self.custom_KD_popoverView=nil;
        transparentView.hidden=YES;
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
    NSLog(@"[predictKDSolutionArray count] = %d",[predictKDSolutionArray count]);
    
    return [predictKDSolutionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"KDListCell";
    
    KDListCell *cell = (KDListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
	{
        cell.backgroundView=nil;
        cell = [[KDListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    NSLog(@"descString =  %@",descString);
    
    if (cell.solutionTextLbl == nil)
    {
        cell = [cell initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSLog(@"cell.solutionTextLbl =  %@",cell.solutionTextLbl);
    
    cell.descriptionString = descString;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    if (indexPath.row <[predictKDSolutionArray count])
    {
        solution = [predictKDSolutionArray objectAtIndex:indexPath.row];
        
        NSString *countString = [NSString stringWithFormat:@"%d/%d",solution.likeCount,solution.unlikeCount];
        
        [[cell tittleLbl] setText: [self getSolutionTitleString:solution]];
        //[[cell solutionTextLbl] setText:solution.solutionText];
        cell.solutionText = solution.solutionText;
        cell.likeDisLikeLbl.layer.cornerRadius=3.0;
        cell.likeDisLikeLbl.text = countString;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    solution = [predictKDSolutionArray objectAtIndex:indexPath.row];
    selectedTextView.text=solution.solutionText;
}

- (void)viewDidUnload
{
    [self setKeyWordLbl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/*
 Alert View delegate to handle ok, cancle action
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10)
    {
        
        if (self.appDelegate.currentKDpopPresentVC != KDLIST_VC)
        {
            NSUserDefaults * userdefaluts=[NSUserDefaults standardUserDefaults];
            [userdefaluts setBool:YES forKey:@"NoMatchesFound"];
            [userdefaluts synchronize];
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}

-(NSString *)getSolutionTitleString:(Solution *)curSolution
{
    NSString *strticketTech;
    
    Solution *solutoinObj = curSolution;
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    User *currentUser = [[[self appDelegate] selectedEntities]user];
    
    TicketMoniter *ticketMonitorObj = [[[self appDelegate] selectedEntities]ticketMonitor];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yy/HH:mm"];
    NSString *DateString=[formatter stringFromDate:solutoinObj.createDate];
    
    NSString *substring=[DateString substringWithRange:NSMakeRange(9, 2)];
    float f=[substring floatValue];
    
    if (f<12.0)
    {
        DateString=[DateString stringByAppendingString:@"a"];
    }else
    {
        DateString=[DateString stringByAppendingString:@"p"];
    }
    
    if (ticketMonitorObj !=nil)
    {
        strticketTech = ticketMonitorObj.ticketTech;
    }
    else if ([strticketTech isEqualToString:@""] || [strticketTech isEqualToString:NULL]|| strticketTech==nil)
    {
        strticketTech= currentUser.userName;
    }
    
    NSString *displaystring=[NSString stringWithFormat:@"%@/%@",DateString,strticketTech];
    
    return displaystring;
}


- (void)presentCustomize_KD_PopOverVC_WithSize_Ipad:(CGSize *)IpadSize Iphone:(CGSize *)IphoneSize
{
    custom_KD_PopOverViewController *custom_KD_PopOverVC = (custom_KD_PopOverViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"custom_KD_PopOverViewController"];
    
    self.custom_KD_popoverView = [[popoverClass alloc] initWithContentViewController:custom_KD_PopOverVC] ;
    
    if ([self.custom_KD_popoverView respondsToSelector:@selector(setContainerViewProperties:)])
    {
        [self.custom_KD_popoverView setContainerViewProperties:[self improvedContainerViewProperties]];
    }
    
    self.custom_KD_popoverView.delegate = self;
    self.custom_KD_popoverView.passthroughViews = [NSArray arrayWithObject:self.view];
    
    if (iPad)
    {
        [self.custom_KD_popoverView presentPopoverFromRect:CGRectMake(380,240,0,0)
                                                    inView:self.view
                                  permittedArrowDirections:UIPopoverArrowDirectionUp
                                                  animated:YES size:IpadSize];
        
    }
    else
    {
        [self.custom_KD_popoverView presentPopoverFromRect:CGRectMake(125,55,0,0)
                                                    inView:self.view
                                  permittedArrowDirections:UIPopoverArrowDirectionUp
                                                  animated:YES size:IphoneSize];
    }
}

-(void)KD_PopOverCancelBtnPressed
{
    transparentView.hidden = YES;
    
    if (self.custom_KD_popoverView)
    {
        [self.custom_KD_popoverView dismissPopoverAnimated:YES];
    }
}

-(void)KD_PopOverCancelBtnPressedWith_location:(NSString *)location category:(NSString *)category describtion:(NSString *)describtion KDsolutionList:(NSMutableArray *)KDsolutionList
{
    NSString *searchString   = nil;
    NSString *locationString = nil;
    NSString *categoryString = nil;
    
    if (iPad) {
        locationString    = [NSString stringWithString:([location length] >= 20) ? [location substringToIndex:18]:location];
        categoryString    = [NSString stringWithString:([category length] >= 20) ? [category substringToIndex:18]:category];
    }else{
        locationString    = [NSString stringWithString:([location length] >= 7) ? [location substringToIndex:6]:location];
        categoryString    = [NSString stringWithString:([category length] >= 7) ? [category substringToIndex:6]:category];
    }
    
    if ([location isEqualToString:@"ALL"]&&[category isEqualToString:@"ALL"])
        searchString =[NSString stringWithFormat:@"/ %@ / %@ / %@",locationString,categoryString,describtion];
    if ([location isEqualToString:@"ALL"]&& ![category isEqualToString:@"ALL"])
        searchString =[NSString stringWithFormat:@"/ %@ / %@../ %@",locationString,categoryString,describtion];
    if (![location isEqualToString:@"ALL"]&&[category isEqualToString:@"ALL"])
        searchString =[NSString stringWithFormat:@"/ %@../ %@ / %@",locationString,categoryString,describtion];
    if (![location isEqualToString:@"ALL"]&& ![category isEqualToString:@"ALL"])
        searchString =[NSString stringWithFormat:@"/ %@../ %@../ %@",locationString,categoryString,describtion];
    
    locationLbl.text=searchString;
    [AppDelegate activeIndicatorStartAnimating:self.view];
     selectedTextView.text=@"";
    self.appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self.appDelegate.currentServiceHelper setAsynchUrlDelegate:self];
    
    transparentView.hidden = NO;
    
    if (self.custom_KD_popoverView)
    {
        [self.custom_KD_popoverView dismissPopoverAnimated:YES];
    }
    
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

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
	//Safe to release the popover here
	self.custom_KD_popoverView = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//The popover is automatically dismissed if you click outside it, unless you return NO here
    return YES;
}
#pragma mark - PopOver Methods for changing position(x,y)-Moving up and down while editing

- (void)popOverTextViewIsEditng {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if (!iPad)
    {
        self.custom_KD_popoverView.view.frame=CGRectMake(0,20,321, 330);
    }
    [UIView commitAnimations];
}

- (void)popOverTextViewIsendEditing
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if (!iPad){
        
        self.custom_KD_popoverView.view.frame=CGRectMake(0,40,321, 330);
    }
    [UIView commitAnimations];
}

#pragma mark - AsynchronousUrlDelegateMethods

-(void)ASYNCConnectionDidFinished:(id)receivedData
{
    
    NSMutableArray *allSolutionListing = nil;
    if(receivedData != nil && [receivedData count] > 0)
    {
        id currentProblem = nil;
        
        NSEnumerator *enumerator = [receivedData objectEnumerator];
        
        if(allSolutionListing == nil)
        {
            allSolutionListing = [[NSMutableArray alloc] init];
        }
        
        while (currentProblem = [enumerator nextObject])
        {
            Solution *solutionOBJ = [[Solution alloc] init];
            
            [solutionOBJ setTicketId:[currentProblem objectForKey:@"TicketId"]];
            [solutionOBJ setSolutionId:[currentProblem objectForKey:@"SolutionId"]];
            [solutionOBJ setSolutionShortDesc:[currentProblem objectForKey:@"SolutionShortDesc"]];
            [solutionOBJ setSolutionText:[currentProblem objectForKey:@"SolutionText"]];
            [solutionOBJ setLikeCount:[[currentProblem objectForKey:@"LikeCount"] intValue]];
            [solutionOBJ setUnlikeCount:[[currentProblem objectForKey:@"UnlikeCount"] intValue]];

            if ([currentProblem valueForKey:@"CreateDate"] != nil)
            {
                [solutionOBJ setCreateDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"CreateDate"]]];
            }
            
            if ([currentProblem valueForKey:@"EditDate"] != nil)
            {
                [solutionOBJ setEditDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"EditDate"]]];
            }
            
            [allSolutionListing addObject:solutionOBJ];
        }
    }
    if (listofSolutionArray !=nil) {
        
        [listofSolutionArray removeAllObjects];
    }
    
    [listofSolutionArray addObjectsFromArray:allSolutionListing];
    
    if ([predictKDSolutionArray count]>0)
    {
        [predictKDSolutionArray removeAllObjects];
    }
    
    for (solution in  listofSolutionArray)
    {
        [predictKDSolutionArray addObject:solution];
    }
    
    if ([predictKDSolutionArray count]==0)
    {
        UIAlertView *NoResultFoundAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There is no result found. Please try again with different search criteria." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [NoResultFoundAlert setTag:10];
        [NoResultFoundAlert show];
    }
    
    [listofSolutionView reloadData];
    [activityIndicator stopAnimating];
    transparentView.hidden =YES;
    
    selectedTextView.text = @"";
    [AppDelegate activeIndicatorStopAnimating];
}

-(void)ASYNCConnectionDidFailedWithError:(NSString *)errorMessage
{
    selectedTextView.text = @"";
    [AppDelegate activeIndicatorStopAnimating];
}


#pragma mark - LikeUnlike

- (IBAction)likeBtnPressed:(id)sender
{
//    NSDate *editedDate = solution.editDate;
//    
//    NSDate *currentDate = [NSDate date];
//    
//    double timeInterval = [currentDate timeIntervalSinceDate:editedDate];
//    
//    NSLog(@"timeInterval=%f",timeInterval/(60*60));

    if([listofSolutionView indexPathForSelectedRow] != nil)
    {
        [AppDelegate activeIndicatorStartAnimating:self.view];
        
        [self performSelector:@selector(solutionLikeIsinProgress) withObject:nil afterDelay:0.1];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select a solution and then try to like it" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

-(void)solutionLikeIsinProgress
{
    unlike = false;
    
    LikeUnlike *likeUnlike = [ServiceHelper addLikeUnlike:[self createLikeUnlikeInstance]];
    
    NSLog(@"likeUnlike = %@",likeUnlike);
    
    [self.appDelegate.currentServiceHelper solutionKnowledgeSearch:self.appDelegate.solutionQueryString];
    
}
- (IBAction)unlikeBtnPressed:(id)sender
{
    if([listofSolutionView indexPathForSelectedRow] != nil)
    {
        [AppDelegate activeIndicatorStartAnimating:self.view];
        
        [self performSelector:@selector(solutionUnlikeIsinProgress) withObject:nil afterDelay:0.1];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select a solution and then try to unlike it" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

-(void)solutionUnlikeIsinProgress
{
    unlike = true;
    
    LikeUnlike *likeUnlike = [ServiceHelper addLikeUnlike:[self createLikeUnlikeInstance]];
    
    NSLog(@"likeUnlike = %@",likeUnlike);
    
    [self.appDelegate.currentServiceHelper solutionKnowledgeSearch:self.appDelegate.solutionQueryString];
    
}

- (LikeUnlike *) createLikeUnlikeInstance
{
	LikeUnlike *likeUnlike = nil;
	    
	@try
	{
		if (likeUnlike == nil)
		{
			likeUnlike = [[LikeUnlike alloc] init];
		}
        // BOOL IsHelpDoc = false;
        
        [likeUnlike setLikeUnlikeId:[NSString stringWithUUID]];
		[likeUnlike setSolutionId:solution.solutionId];
		[likeUnlike setLike:1];
		[likeUnlike setUnlike:[NSString stringWithFormat:@"%d",unlike]];
        [likeUnlike setUserId:[[[[self appDelegate] selectedEntities] user] userId]];
		[likeUnlike setCreateDate:[NSDate date]];
		[likeUnlike setEditDate:[NSDate date]];
        
   	}
	@catch (NSException *exception)
	{
		NSLog(@"Error in createTicketInstance.  Error: %@", [exception description]);
	}
	@finally
	{
		return likeUnlike;
	}
}

@end
