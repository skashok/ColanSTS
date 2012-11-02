//
//  SnoozeReasonListViewController.m
//  ServiceTech
//
//  Created by colan on 15/10/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "SettingsManipulationViewController.h"
#import "SnoozeReason.h"
#import "ServiceHelper.h"
#import "Category.h"
#import "IntervalType.h"
#import "ApplicationType.h"

@interface SettingsManipulationViewController ()

@end

@implementation SettingsManipulationViewController

@synthesize delegate;

@synthesize listtableView;

@synthesize addNewView;

@synthesize addNewTextField;

@synthesize addNewButton;

@dynamic addUpdateButton;

@synthesize BgView;

@synthesize generateRecapTextField;

@synthesize startTimeTextField;

@synthesize endTimeTextField;

@synthesize recapEmailTextField;

@synthesize generateRecapView;

@synthesize recapSaveButton;

@synthesize recapCancelButton;

@synthesize addNew;

@synthesize deleteexist;

@synthesize update;

@synthesize selectAll;

@synthesize appDelegate;

@synthesize dropwDownCustomTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)arrayList
{
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];

    lists = [[NSMutableArray alloc] init];
    
    objectLists = [[NSMutableArray alloc] init];
            
    if (appDelegate.selectedIndexInSettingsPage == 0)
    {
        self.navigationItem.title = @"List of Tech's";
        
        [objectLists addObjectsFromArray:[ServiceHelper getUsers]];

        for(int i=0;i<[objectLists count]; i++)
        {
            User *user = [objectLists objectAtIndex:i];
            
            [lists addObject:user.userName];
        }
    }
    else if (appDelegate.selectedIndexInSettingsPage == 1)
    {
        self.navigationItem.title = @"Snooze/Reasons list";

        [objectLists addObjectsFromArray:[ServiceHelper getAllSnoozeReasons]];

        for(int i=0;i<[objectLists count]; i++)
        {
            SnoozeReason *snoozeReason = [objectLists objectAtIndex:i];
            
            [lists addObject:snoozeReason.name];
        }
    }
    else if (appDelegate.selectedIndexInSettingsPage == 2)
    {
        self.navigationItem.title = @"Snooze/Interval type";

        [objectLists addObjectsFromArray:[ServiceHelper getAllIntervalTypes]];

        for(int i=0;i<[objectLists count]; i++)
        {
            IntervalType *intervalType = [objectLists objectAtIndex:i];
            
            [lists addObject:intervalType.name];
        }
    }
    else if (appDelegate.selectedIndexInSettingsPage == 3)
    {
        self.navigationItem.title = @"Category";

        [objectLists addObjectsFromArray:[ServiceHelper getAllCategories]];

        for(int i=0;i<[objectLists count]; i++)
        {
            Category *category1 = [objectLists objectAtIndex:i];
            
            [lists addObject:category1.categoryName];
        }
    }
    else if (appDelegate.selectedIndexInSettingsPage == 6)
    {
        self.navigationItem.title = @"Application Type";
                
        [objectLists addObjectsFromArray:[ServiceHelper getAllApplicationTypes]];
        
        for(int i=0;i<[objectLists count]; i++)
        {
            ApplicationType *applicationType = [objectLists objectAtIndex:i];
            
            [lists addObject:applicationType.applicationName];
        }
    }

    
    selectedValueIndexPath = [[NSMutableArray alloc] init];
        
    addNewTextField.text = @"";
    
    [listtableView reloadData];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
        
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
   
    timeZones =[[NSMutableArray alloc]initWithObjects:@"SELECT ALL",@"GMT",@"UTC",
                @"EST",@"EDT",
                @"PST",@"PDT",@"DST ",nil];
    selectedIndexes = [[NSMutableArray alloc]init];

    listtableView.layer.cornerRadius = 10;
    listtableView.layer.borderWidth = 1;
    listtableView.layer.borderColor = [UIColor blackColor].CGColor;
  
    self.dailyRecapList.layer.cornerRadius = 10;
    self.dailyRecapList.layer.borderWidth = 1;
    self.dailyRecapList.layer.borderColor = [UIColor blackColor].CGColor;
    
    addNewView.layer.cornerRadius = 10;
    addNewView.layer.borderWidth = 2;
    addNewView.layer.borderColor = [UIColor blackColor].CGColor;
    recapEmailTextField.text = @"support@servicetrackingsystems.net";
    BgView.hidden = YES;
    
    
    if (appDelegate.selectedIndexInSettingsPage == 5)
    {
        [dailyRecapScrollView setContentSize:CGSizeMake(320,500)];
        dailyRecapScrollView.hidden = NO;
        generateRecapView.hidden = NO;
        mondayBtn.selected     = NO;
        tuesdayBtn.selected    = NO;
        wednesdayBtn.selected  = NO;
        thursday.selected      = NO;
        friday.selected        = NO;
        deleteexist.hidden=YES;
        listtableView.hidden = YES;
        update.hidden = YES;
        addNew.hidden=YES;
        [self.dailyRecapList setHidden:YES];
       
        
        self.navigationItem.title = @"Daily Recap";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                  target:self action:@selector(dailRecapSaveBtnPressed:)];
        
        
        NSUserDefaults *defaluts=[NSUserDefaults standardUserDefaults];
        
        if ([defaluts boolForKey:@"DeailyRecapIsActvie"])
        {
            NSUserDefaults *defalults=[NSUserDefaults standardUserDefaults];
            NSDate *generateRecapeDate=[defalults objectForKey:@"generateRecapTime"];
            NSDate *startTime=[defalults objectForKey:@"startTime"];
            NSDate *endTime=[defalults objectForKey:@"endTime"];
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"hh:mm a"];
            generateRecapTextField.text=[formatter stringFromDate:generateRecapeDate];
            startTimeTextField.text=[formatter stringFromDate:startTime];
            endTimeTextField.text=[formatter stringFromDate:endTime];
            recapEmailTextField.text=[defalults objectForKey:@"Recapemail"];
        }
    }
    else{
        
        [self.dailyRecapList setHidden:YES];
        generateRecapView.hidden = YES;
        dailyRecapScrollView.hidden = YES;
    }
    NSLog(@"appDelegate.selectedIndexInSettingsPage = %d",appDelegate.selectedIndexInSettingsPage);

//    if (appDelegate.selectedIndexInSettingsPage == 5)
//    {
//        addNew.hidden = YES;
//        deleteexist.frame = addNew.frame;
//    }
    
    selectAll.hidden = YES;
    
    if(appDelegate.selectedIndexInSettingsPage == 0)
    {
        CGRect frame = listtableView.frame;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            frame.origin.y = 60;
            listtableView.frame = frame;
        }
        else
        {
            frame.origin.y = 120;
            listtableView.frame = frame;
        }
        addNew.hidden = YES;
        selectAll.hidden = NO;
        deleteexist.hidden  =YES;
        update.hidden = YES;
    }
    [self arrayList];
}

-(void)doneClicked
{
    [AppDelegate activityIndicatorStopAnimating];

    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
        [delegate applicationTypeFinished];

	[self dismissModalViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
   mainStoryboard = nil;
   iPad = NO;
    
#ifdef UI_USER_INTERFACE_IDIOM
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#endif
    
    if (iPad)
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle: nil];
    }
    else
    {
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
    if (appDelegate.selectedIndexInSettingsPage == 6)
    {
        UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
        
        self.navigationItem.rightBarButtonItem = doneButton;
        
        self.navigationItem.leftBarButtonItem = nil;
    }

}
-(void)leftNavBtnPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.dailyRecapList])
        //return [dailyRecapOBJS count];
       return 6;
    else
       return [lists count];

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  [cell setBackgroundColor:[UIColor whiteColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableViewObj cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellToReturn;
    
    if ([tableViewObj isEqual:self.dailyRecapList])
    {
        static NSString *CellIdentifier=@"DailyRecapListCell";
        DailyRecapListCell *cell =[tableViewObj dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil )
        {
            cell =[[DailyRecapListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
      
        [cell.broadcastTime setText:@"03:00 AM"];
        [cell.broadcastDay setText:@"FRI"];
        [cell.recapStarTime setText:@"09:00 PM"];
        [cell.recapEndTime setText:@"02:00 AM"];
        [cell.recapLocation setText:@"Andolinishiya"];
        [cell.recapTimeZone setText:@"GMT"];
     
        if (indexPath.row == 1 || indexPath.row == 4 || indexPath.row ==5)
        {
            [cell.recapName setText:@"DAY TIME"];
          [cell.status setText:@"INACTIVE"];
          [cell.status setTextColor:[UIColor redColor]];
        }
        else
        {
          [cell.recapName setText:@"MIDNIGHT"];
          [cell.status setText:@"ACTIVE"];
          [cell.status setTextColor:[UIColor colorWithRed:54.0/255 green:127.0/255 blue:36.0/255 alpha:1]];
        }
         [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        cellToReturn = cell;
    }
    else
    {
        UIFont *sampleFont = [UIFont fontWithName:@"System" size:14.0];
        
        static NSString *CellIdentifier = @"ListCell";
        
        UITableViewCell *cell = [tableViewObj dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = [lists objectAtIndex:indexPath.row];
        
        cell.textLabel.font = sampleFont;
        
        if ([selectedValueIndexPath containsObject:indexPath])
            [cell setAccessoryType :UITableViewCellAccessoryCheckmark];
        else
            [cell setAccessoryType :UITableViewCellAccessoryNone];
        
        cellToReturn = cell;
  
    }
    return cellToReturn;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableViewObj didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath.row = %d",indexPath.row);
    
    if (appDelegate.selectedIndexInSettingsPage != 0)
    {
        for (int i = 0; i< [selectedValueIndexPath count]; i++)
        {
            NSIndexPath *selectedIndexPath = [selectedValueIndexPath objectAtIndex:i];
            if (![selectedIndexPath isEqual:indexPath])
            {
                [selectedValueIndexPath removeAllObjects];
            }
        }
    }

    [tableViewObj deselectRowAtIndexPath:indexPath animated:YES];
    
    if(![selectedValueIndexPath containsObject:indexPath])
        [selectedValueIndexPath addObject:indexPath];
    else
        [selectedValueIndexPath removeObject:indexPath];
    
    [tableViewObj reloadData];
}

-(IBAction)selectAllButtonWasPressed:(id)sender
{
    if ([lists count] == [selectedValueIndexPath count])
    {
        [selectedValueIndexPath removeAllObjects];
    }
    else
    {
        for (int i = 0; i < [listtableView numberOfSections]; i++)
        {
            for (int j = 0; j < [listtableView numberOfRowsInSection:i]; j++)
            {
                NSUInteger ints[2] = {i,j};
                NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:ints length:2];
                [selectedValueIndexPath addObject:indexPath];
            }
        }
    }
    [listtableView reloadData];
}
-(IBAction)addNewButtonWasPressed:(id)sender
{
        if (appDelegate.selectedIndexInSettingsPage == 1)
            addNewTextField.placeholder = @"Add new Snooze reason";
        else if (appDelegate.selectedIndexInSettingsPage == 2)
            addNewTextField.placeholder = @"Add new Interval type";
        else if (appDelegate.selectedIndexInSettingsPage == 3)
            addNewTextField.placeholder = @"Add new Category";
        else if (appDelegate.selectedIndexInSettingsPage == 6)
            addNewTextField.placeholder = @"Add new Application Type";
        else if (appDelegate.selectedIndexInSettingsPage == 5)
        {
            dailyRecapScrollView.hidden=NO;
            generateRecapView.hidden=NO;
            [self.dailyRecapList setHidden:YES];
            addNew.hidden=YES;
            deleteexist.hidden=YES;
            update.hidden = YES;
            self.navigationItem.title = @"Daily Recap";
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                     initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                     target:self action:@selector(dailRecapSaveBtnPressed:)];
        }
        else
        {
            BgView.hidden = NO;
            addNewView.hidden = NO;
            addUpdateButton.hidden = YES;
            addNewButton.hidden = NO;
            [UIView animateWithDuration:1.0 animations:^{
                addNewView.alpha = 0.0; addNewView.alpha = 1.0;
            } completion:^(BOOL success)
             {
                 
                 if (success)
                 {
                     
                 }
             }];
            //  [self arrayList];
  
        }
}


-(IBAction)deleteButtonWasPressed:(id)sender
{
    if ([selectedValueIndexPath count] == 0)
    {
        [self alertMessage:@"Please select a row and then try to delete."];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure you want to delete the selected row." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alert.tag = 100;
        [alert show];
    }
}

-(IBAction)updateButtonWasPressed:(id)sender
{
    if ([selectedValueIndexPath count] == 0)
    {
        [self alertMessage:@"Please select a row and then try to update."];
    }
    else
    {
        if (appDelegate.selectedIndexInSettingsPage == 1)
            addNewTextField.placeholder = @"Update Snooze reason";
        else if (appDelegate.selectedIndexInSettingsPage == 2)
            addNewTextField.placeholder = @"Update Interval type";
        else if (appDelegate.selectedIndexInSettingsPage == 3)
            addNewTextField.placeholder = @"Update Category";
        else if (appDelegate.selectedIndexInSettingsPage == 6)
            addNewTextField.placeholder = @"Update Application type";

        if (appDelegate.selectedIndexInSettingsPage == 1)
        {
            for (int i = 0; i < [selectedValueIndexPath count] ; i++)
            {
                NSIndexPath *selectedIndexPath = [selectedValueIndexPath objectAtIndex:i];
                
                SnoozeReason *snoozeReason = [objectLists objectAtIndex:selectedIndexPath.row];
                
                addNewTextField.text = snoozeReason.name;
            }
        }
        else  if (appDelegate.selectedIndexInSettingsPage == 2)
        {
            for (int i = 0; i < [selectedValueIndexPath count] ; i++)
            {
                NSIndexPath *selectedIndexPath = [selectedValueIndexPath objectAtIndex:i];
                
                IntervalType *intervalType = [objectLists objectAtIndex:selectedIndexPath.row];
                
                addNewTextField.text = intervalType.name;
            }
        }
        else  if (appDelegate.selectedIndexInSettingsPage == 3)
        {
            for (int i = 0; i < [selectedValueIndexPath count] ; i++)
            {
                NSIndexPath *selectedIndexPath = [selectedValueIndexPath objectAtIndex:i];
                
                Category *category = [objectLists objectAtIndex:selectedIndexPath.row];
                
                addNewTextField.text = category.categoryName;
            }
        }
        else  if (appDelegate.selectedIndexInSettingsPage == 6)
        {
            for (int i = 0; i < [selectedValueIndexPath count] ; i++)
            {
                NSIndexPath *selectedIndexPath = [selectedValueIndexPath objectAtIndex:i];
                
                ApplicationType *applicationType = [objectLists objectAtIndex:selectedIndexPath.row];
                
                addNewTextField.text = applicationType.applicationName;
            }
        }
        
        BgView.hidden = NO;
        addNewView.hidden = NO;
        addUpdateButton.hidden = NO;
        addNewButton.hidden = YES;
        [UIView animateWithDuration:1.0 animations:^{
            addNewView.alpha = 0.0; addNewView.alpha = 1.0;
        } completion:^(BOOL success) {
            if (success) {
            }
        }];
    }
}

-(IBAction)addNewPopUpButtonWasPressed:(id)sender
{
    [addNewTextField resignFirstResponder];
    
    if (![addNewTextField.text isEqualToString:@""])
    {
        [UIView animateWithDuration:1.0 animations:^{
            addNewView.alpha = 1.0; addNewView.alpha = 0.0;
        } completion:^(BOOL success) {
            if (success) {
                addNewView.hidden = YES;
                BgView.hidden = YES;
            }
        }];
        
        if (appDelegate.selectedIndexInSettingsPage == 1)
        {
            if ([ServiceHelper doesSnoozeReasonExist:addNewTextField.text])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"SnoozeReason already exists." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else
            {
                SnoozeReason *snoozeReason = [self createSnoozeReasonInstance:addNewTextField.text];
                
                SnoozeReason *snoozeReasonObj = [ServiceHelper addSnoozeReason:snoozeReason];
              
                if (snoozeReasonObj!=nil)
                {
                    [self.appDelegate.dBHelper insertDailyRecapIntoDatabase:@"Created" onObject:@"SnoozeReason"  valueForObject:snoozeReason.name];
                   [self alertMessage:@"New snooze reason added successfully."];
                }
            }
        }
        else  if (appDelegate.selectedIndexInSettingsPage == 2)
        {
            if ([ServiceHelper doesIntervalTypeExist:addNewTextField.text])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Interval type already exists." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else
            {
                IntervalType *intervalType = [self createIntervalTypeInstance:addNewTextField.text];
                
                IntervalType *intervalTypeObj = [ServiceHelper addIntervalType:intervalType];
                
                if (intervalTypeObj!=nil)
                {
                    [self.appDelegate.dBHelper insertDailyRecapIntoDatabase:@"Created" onObject:@"IntervalType"  valueForObject:intervalTypeObj.name];
                    [self alertMessage:@"New interval type added successfully."];
                }
            }
        }
        else  if (appDelegate.selectedIndexInSettingsPage == 3)
        {
            if ([ServiceHelper doescategoryExist:addNewTextField.text])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Category already exists." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else
            {
                Category *category = [self createCategoryInstance:addNewTextField.text];
                
                Category *categoryObj = [ServiceHelper addCategory:category];
                
                NSLog(@"categoryObj = %@",categoryObj);
              
                if (categoryObj!=nil)
                {
                    [self.appDelegate.dBHelper insertDailyRecapIntoDatabase:@"Created" onObject:@"Category"  valueForObject:categoryObj.categoryName];
                    [self alertMessage:@"New category added successfully."];
                }
           }
        }
        else if(appDelegate.selectedIndexInSettingsPage == 6)
        {
            if ([ServiceHelper doesApplicationTypeExist:addNewTextField.text])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Application type already exists." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                ApplicationType *applicationType = [self createApplicationTypeInstance:addNewTextField.text];
                
                ApplicationType *applicationTypeObj = [ServiceHelper addApplicationType:applicationType];
                
                NSLog(@"applicationTypeObj = %@",applicationTypeObj);
                
                [self alertMessage:@"New application type added successfully."];
            }
        }

        [self arrayList];
    }
    else
    {
        [self alertMessage:@"Please enter the field and then try to add."];

    }
  }


-(IBAction)updatePopUpButtonWasPressed:(id)sender
{
    [addNewTextField resignFirstResponder];
    
        if (![addNewTextField.text isEqualToString:@""])
        {
            [UIView animateWithDuration:1.0 animations:^{
                addNewView.alpha = 1.0; addNewView.alpha = 0.0;
            } completion:^(BOOL success) {
                if (success) {
                    addNewView.hidden = YES;
                    BgView.hidden = YES;
                }
            }];
            
            if (appDelegate.selectedIndexInSettingsPage == 1)
            {
                if ([ServiceHelper doesSnoozeReasonExist:addNewTextField.text])
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Snooze reason already exists." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
                else
                {
                    for (int i = 0; i < [selectedValueIndexPath count] ; i++)
                    {
                        NSIndexPath *selectedIndexPath = [selectedValueIndexPath objectAtIndex:i];
                        
                        SnoozeReason *snoozeReason = [objectLists objectAtIndex:selectedIndexPath.row];
                        
                        snoozeReason.name = addNewTextField.text;
                        snoozeReason.createDate = [NSDate date];
                        snoozeReason.editDate = [NSDate date];
                        
                        SnoozeReason *snoozeReasonObj = [ServiceHelper updateSnoozeReason:snoozeReason];
                       
                        if (snoozeReasonObj!=nil)
                        {
                            [self.appDelegate.dBHelper insertDailyRecapIntoDatabase:@"Updated" onObject:@"SnoozeReason"  valueForObject:snoozeReason.name];
                            [self alertMessage:@"Snooze reason updated successfully."];
                        }
                    }
                }
            }
            else  if (appDelegate.selectedIndexInSettingsPage == 2)
            {
                if ([ServiceHelper doesIntervalTypeExist:addNewTextField.text])
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Interval type already exists." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
                else
                {
                    for (int i = 0; i < [selectedValueIndexPath count] ; i++)
                    {
                        NSIndexPath *selectedIndexPath = [selectedValueIndexPath objectAtIndex:i];

                        IntervalType *intervalType = [objectLists objectAtIndex:selectedIndexPath.row];
                        
                        intervalType.name = addNewTextField.text;
                        intervalType.createDate = [NSDate date];
                        intervalType.editDate = [NSDate date];
                        
                        IntervalType *intervalTypeObj = [ServiceHelper updateIntervalType:intervalType];
                        
                        if (intervalTypeObj!=nil)
                        {
                            [self.appDelegate.dBHelper insertDailyRecapIntoDatabase:@"Updated" onObject:@"IntervalType"  valueForObject:intervalTypeObj.name];
                            [self alertMessage:@"Interval type updated successfully."];
                        }
                    }
                }
            }
            else  if (appDelegate.selectedIndexInSettingsPage == 3)
            {
                if ([ServiceHelper doescategoryExist:addNewTextField.text])
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Category already exists." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
                else
                {
                    for (int i = 0; i < [selectedValueIndexPath count] ; i++)
                    {
                        NSIndexPath *selectedIndexPath = [selectedValueIndexPath objectAtIndex:i];
                        
                        Category *category = [objectLists objectAtIndex:selectedIndexPath.row];
                        
                        category.categoryName = addNewTextField.text;
                        category.createDate = [NSDate date];
                        category.editDate = [NSDate date];
                        
                        Category *categoryObj = [ServiceHelper updateCategory:category];
                      
                        if (categoryObj!=nil)
                        {
                            [self.appDelegate.dBHelper insertDailyRecapIntoDatabase:@"Updated" onObject:@"Category"  valueForObject:categoryObj.categoryName];
                            [self alertMessage:@"Category updated successfully."];

                        }
                   }
                }
            }
            else  if (appDelegate.selectedIndexInSettingsPage == 6)
            {
                if ([ServiceHelper doesApplicationTypeExist:addNewTextField.text])
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Application type already exists." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
                else
                {
                    for (int i = 0; i < [selectedValueIndexPath count] ; i++)
                    {
                        NSIndexPath *selectedIndexPath = [selectedValueIndexPath objectAtIndex:i];
                        
                        ApplicationType *applicationType = [objectLists objectAtIndex:selectedIndexPath.row];
                        
                        applicationType.applicationName = addNewTextField.text;
                        applicationType.createDate = [NSDate date];
                        applicationType.editDate = [NSDate date];
                        
                        ApplicationType *applicationTypeObj = [ServiceHelper updateApplicationType:applicationType applicationTypeId:applicationType.applicationTypeId];
                        
                        if (applicationTypeObj!=nil)
                        {
                            [self.appDelegate.dBHelper insertDailyRecapIntoDatabase:@"Updated" onObject:@"ApplicationType"  valueForObject:applicationTypeObj.applicationName];
                            [self alertMessage:@"Application type updated successfully."];
                        }
                    }
                }
            }
            [self arrayList];
        }
    else
    {
        [self alertMessage:@"Please enter the field and then try to update."];
    }
}

-(IBAction)cancelButtonWasPressed:(id)sender
{
    [addNewTextField resignFirstResponder];
    
    [UIView animateWithDuration:1.0 animations:^{
        addNewView.alpha = 1.0; addNewView.alpha = 0.0;
    } completion:^(BOOL success) {
        if (success) {
            addNewView.hidden = YES;
            BgView.hidden = YES;
        }
    }];
    selectedValueIndexPath = [[NSMutableArray alloc] init];
        
    addNewTextField.text = @"";
    
    [listtableView reloadData];
}
-(void)alertMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Generate Recap

-(IBAction)recapSaveButtonWasPressed:(id)sender
{
    
    if ([generateRecapTextField.text length]!=0 && [startTimeTextField.text length]!=0 && [endTimeTextField.text length]!=0 && [recapEmailTextField.text length]!=0)
    {
        if ([ServicePleaseValidation validateEmail:recapEmailTextField.text])
        {
            NSUserDefaults *defaluts=[NSUserDefaults standardUserDefaults];
            [defaluts setObject:recapEmailTextField.text forKey:@"Recapemail"];
            [defaluts setBool:YES forKey:@"DeailyRecapIsActvie"];
            [defaluts synchronize];
            
            NSMutableString *JSONstring=[[NSMutableString alloc]initWithString:@"\n{\n"];
            [JSONstring appendFormat:@"\"RecapGenrateTime\" : \"%@\", \n",generateRecapTextField.text];
            [JSONstring appendFormat:@"\"StarTime\"         : \"%@\", \n",startTimeTextField.text];
            [JSONstring appendFormat:@"\"endTimeTime\"      : \"%@\", \n ",endTimeTextField.text];
            [JSONstring appendFormat:@"\"RecapMail\"       : \"%@\" \n",recapEmailTextField.text];
            [JSONstring appendString:@"}\n"];
          
            //NSLog(@"JSONstring= %@ ",JSONstring);
            
            NSString *successMsg=[NSString stringWithFormat:@"DailyRecap activated successfully.you will recive the mail daily at %@",self.generateRecapTextField.text];
             NSString *DailyRecapMsg=[NSString stringWithFormat:@"Generated recap email Time : %@ ,Starttime : %@ ,Endtime : %@",self.generateRecapTextField.text,self.startTimeTextField.text,self.endTimeTextField.text];
           
             [self.appDelegate.dBHelper insertDailyRecapIntoDatabase:@"Activation" onObject:@"DailyRecap"  valueForObject:DailyRecapMsg];
           
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:successMsg
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
          
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please check the recapemail feild in appropriate format"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else
    {
        NSMutableString *alertString=[[NSMutableString alloc]initWithFormat:@"Please select the "];
        
        if ([generateRecapTextField.text length]==0)
        {
            [alertString appendString:@"GeneraterecapTime "];
        }
        if ([startTimeTextField.text length]==0) {
            if([alertString length]>25)
                [alertString appendString:@",StartTime "];
            else
                [alertString appendString:@"StartTime"];
        }
        if ([endTimeTextField.text length]==0) {
            if([alertString length]>25)
                [alertString appendString:@"& EndTime"];
            else
                [alertString appendString:@"EndTime"];
        }
        if ([recapEmailTextField.text length]==0)
        {
            if([alertString length]>25)
                [alertString appendString:@",RecapEmail"];
            else
                alertString =[NSString stringWithFormat:@"Please Enter the RecapEmail"];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:alertString
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

-(IBAction)recapCancelButtonWasPressed:(id)sender
{
    NSUserDefaults *defaluts=[NSUserDefaults standardUserDefaults];
    if ([defaluts boolForKey:@"DeailyRecapIsActvie"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"If you deactivate dailyRecap the dailyrecap mail no more recive from the server.Do you want to deactivate ?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        [alert show];
        alert.tag=1;
    }
}


-(IBAction)daysBtnPressed:(UIButton *)sender
{
    
    switch (sender.tag) {
            
        case 1:
            if ([mondayBtn isSelected]){
                mondayBtn.selected  = NO;
            }else{
                mondayBtn.selected  = YES;
            }
            break;
        case 2:
            if ([tuesdayBtn isSelected]){
                tuesdayBtn.selected  = NO;
            }else{
                tuesdayBtn.selected  = YES;
            }
            
            break;
            
        case 3:
            if ([wednesdayBtn isSelected]){
                wednesdayBtn.selected = NO;
            }else{
                wednesdayBtn.selected = YES;
            }
            
            break;
            
        case 4:
            if ([thursday isSelected]){
                thursday.selected  = NO;
            }else{
                thursday.selected = YES;
            }
            break;
            
        case 5:
            if ([friday isSelected]){
                friday.selected = NO;
            }else{
                friday.selected = YES;
            }
            
            break;
            
        default:
            break;
    }
}

-(void)dailRecapSaveBtnPressed:(id)sender
{
    dailyRecapScrollView.hidden=YES;
    generateRecapView.hidden=YES;
    [self.dailyRecapList setHidden:NO];
    addNew.hidden=NO;
    deleteexist.hidden=NO;
    update.hidden = NO;
    self.navigationItem.title = @"Daily Recap List";
    self.navigationItem.rightBarButtonItem = nil;
    [deleteexist setEnabled:NO];
    [update setEnabled:NO];
}

-(IBAction)actvationBtnPressed:(UIButton *)sender {
    
    recapCancelButton.selected = NO ;
    recapSaveButton.selected   = NO;
    
    switch (sender.tag)
    {
        case 6:
            recapSaveButton.selected = YES;
            break;
            
        case 7:
            recapCancelButton.selected =YES;
            break;
            
        default:
            break;
    }
}

- (IBAction)locationSelectBtnPressed:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if (locationSelectBtnToggle == 0)
    {
        locationSelectBtnToggle++;
        locationOBJS = [ServiceHelper getLocations];
        locationNames = [[NSMutableArray alloc]init];
        [recapEmailTextField setUserInteractionEnabled:NO];
        [startTimeTextField setUserInteractionEnabled:NO];
        [endTimeTextField setUserInteractionEnabled:NO];
        [timeZoneSelectBtn setUserInteractionEnabled:NO];
        [selectedIndexes removeAllObjects];
        for (int i = 0 ; i < [locationOBJS count]; i++ )
        {
            Location *location = [locationOBJS objectAtIndex:i];
            [locationNames addObject:location.locationName];
        }
        [dailyRecapScrollView setContentOffset:CGPointMake(0,96)];
        [locationNames insertObject:@"Select All" atIndex:0];
       
        if (iPad)
        {
           dropwDownCustomTableView = [[DropDownView alloc] initWithArrayData:locationNames cellHeight:30 heightTableView:160 paddingTop:-17 paddingLeft:-1 paddingRight:-2 refView:self.locationNameTextField animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2];
        }
        else
        {
           dropwDownCustomTableView = [[DropDownView alloc] initWithArrayData:locationNames cellHeight:30 heightTableView:160 paddingTop:-6 paddingLeft:12 paddingRight:-2 refView:self.endTimeTextField animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2];
        }
        dropwDownCustomTableView.dailyRecapDelegate = self;
        [dailyRecapScrollView setScrollEnabled:NO];
        [self.view addSubview:dropwDownCustomTableView.view];
        [dropwDownCustomTableView openAnimation];
        [locationSelectBtn setTitle:@"done" forState:UIControlStateNormal];
    }
    else
    {
        locationSelectBtnToggle=0;
        [locationSelectBtn setTitle:@"select" forState:UIControlStateNormal];
        [dropwDownCustomTableView closeAnimation];
        [dailyRecapScrollView setContentOffset:CGPointMake(0,0)];
        [dailyRecapScrollView setScrollEnabled:YES];
        [recapEmailTextField setUserInteractionEnabled:YES];
        [startTimeTextField setUserInteractionEnabled:YES];
        [endTimeTextField setUserInteractionEnabled:YES];
        [timeZoneSelectBtn setUserInteractionEnabled:YES];
        
        if ([selectedIndexes count] == [locationNames count])
        {
            [self.locationNameTextField setText:@"ALL"];
        }
        else
        {
            NSMutableString *locationText=[[NSMutableString alloc]init];
            
            for (int i=0; i <[selectedIndexes count]; i++ )
            {
                if (i==[selectedIndexes count]-1)
                    [locationText appendFormat:@"%@",[locationNames objectAtIndex:[[selectedIndexes objectAtIndex:i]integerValue]]];
                else
                    [locationText appendFormat:@"%@ ,",[locationNames objectAtIndex:[[selectedIndexes objectAtIndex:i]integerValue]]];
            }
            [self.locationNameTextField setText:locationText];
            
            NSLog(@"locationText = %@",locationText);
        }
    }
    
    [UIView commitAnimations];
}

- (IBAction)timezoneSelectBtnPressed:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if (timeZoneSelectBtnToggle == 0)
    {
        timeZoneSelectBtnToggle++;
        [dropwDownCustomTableView closeAnimation];
        [dailyRecapScrollView setContentOffset:CGPointMake(0,141)];
       
        if (iPad)
        {
          dropwDownCustomTableView = [[DropDownView alloc] initWithArrayData:timeZones cellHeight:30 heightTableView:160 paddingTop:-17 paddingLeft:-1 paddingRight:0 refView:self.timeZoneTextField animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2];

        }
        else
        {
          dropwDownCustomTableView = [[DropDownView alloc] initWithArrayData:timeZones cellHeight:30 heightTableView:160 paddingTop:-6 paddingLeft:12 paddingRight:-2 refView:self.endTimeTextField animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2];

        }
        dropwDownCustomTableView.dailyRecapDelegate = self;
        [dailyRecapScrollView setScrollEnabled:NO];
        [self.view addSubview:dropwDownCustomTableView.view];
        [dropwDownCustomTableView openAnimation];
        [timeZoneSelectBtn setTitle:@"done" forState:UIControlStateNormal];
        [recapEmailTextField setUserInteractionEnabled:NO];
        [startTimeTextField setUserInteractionEnabled:NO];
        [endTimeTextField setUserInteractionEnabled:NO];
        [locationSelectBtn setUserInteractionEnabled:NO];
        [selectedIndexes removeAllObjects];
    }
    else
    {
        timeZoneSelectBtnToggle=0;
        [timeZoneSelectBtn setTitle:@"select" forState:UIControlStateNormal];
        [dropwDownCustomTableView closeAnimation];
        [dailyRecapScrollView setContentOffset:CGPointMake(0,0)];
        [dailyRecapScrollView setScrollEnabled:YES];
        [recapEmailTextField setUserInteractionEnabled:YES];
        [startTimeTextField setUserInteractionEnabled:YES];
        [endTimeTextField setUserInteractionEnabled:YES];
        [locationSelectBtn setUserInteractionEnabled:YES];
        
        if ([selectedIndexes count] == [timeZones count])
        {
            [self.timeZoneTextField setText:@"ALL"];
        }
        else
        {
            NSMutableString *timeZoneText=[[NSMutableString alloc]init];
            
            for (int i=0; i <[selectedIndexes count]; i++ )
            {
                if (i==[selectedIndexes count]-1)
                    [timeZoneText appendFormat:@"%@",[timeZones objectAtIndex:[[selectedIndexes objectAtIndex:i]integerValue]]];
                else
                    [timeZoneText appendFormat:@"%@ ,",[timeZones objectAtIndex:[[selectedIndexes objectAtIndex:i]integerValue]]];
            }
            [self.timeZoneTextField setText:timeZoneText];
            
            NSLog(@"locationText = %@",timeZoneText);
        }    
    }
    [UIView commitAnimations];
}

#pragma mark createInstance

- (Category *) createCategoryInstance:(NSString *)categoryName
{
	Category *category = nil;
    
	@try
	{
		if (category == nil)
		{
			category = [[Category alloc] init];
		}
        
        [category setCategoryId:[NSString stringWithUUID]];
		[category setCategoryIcon:NULL];
		[category setOrganizationId:[[[appDelegate selectedEntities] organization] organizationId]];
		[category setCategoryName:categoryName];;
		[category setCreateDate:[NSDate date]];
		[category setEditDate:[NSDate date]];
        
   	}
	@catch (NSException *exception)
	{
		NSLog(@"Error in createTicketInstance.  Error: %@", [exception description]);
	}
	@finally
	{
		return category;
	}
}

- (SnoozeReason *) createSnoozeReasonInstance:(NSString *)snoozeReasonName
{
	SnoozeReason *snoozeReason = nil;
    
	@try
	{
		if (snoozeReason == nil)
		{
			snoozeReason = [[SnoozeReason alloc] init];
		}
        
        [snoozeReason setReasonId:[NSString stringWithUUID]];
		[snoozeReason setName:snoozeReasonName];
		[snoozeReason setCreateDate:[NSDate date]];
		[snoozeReason setEditDate:[NSDate date]];
        
   	}
	@catch (NSException *exception)
	{
		NSLog(@"Error in createTicketInstance.  Error: %@", [exception description]);
	}
	@finally
	{
		return snoozeReason;
	}
}

- (IntervalType *) createIntervalTypeInstance:(NSString *)intervalTypeName
{
	IntervalType *intervalType = nil;
    
	@try
	{
		if (intervalType == nil)
		{
			intervalType = [[IntervalType alloc] init];
		}
        
        [intervalType setIntervalTypeId:[NSString stringWithUUID]];
		[intervalType setName:intervalTypeName];
		[intervalType setCreateDate:[NSDate date]];
		[intervalType setEditDate:[NSDate date]];
        
   	}
	@catch (NSException *exception)
	{
		NSLog(@"Error in createTicketInstance.  Error: %@", [exception description]);
	}
	@finally
	{
		return intervalType;
	}
}

- (ApplicationType *)createApplicationTypeInstance:(NSString *)applicationTypeName {
    
    ApplicationType *applicationType= nil;
    
    @try
    {
        if(applicationType ==nil)
        {
            applicationType = [[ApplicationType alloc]init];
        }
        
        [applicationType setApplicationName:applicationTypeName];
        [applicationType setApplicationTypeId:[NSString stringWithUUID]];
        [applicationType setCreateDate:[NSDate date]];
        [applicationType setEditDate:[NSDate date]];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error in createTicketInstance.  Error: %@", [exception description]);
    }
    @finally
    {
        return applicationType;
    }
}
#pragma mark textFieldDelegete

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    textField.keyboardType = UIKeyboardTypeDefault;
    [dropwDownCustomTableView closeAnimation];
    
    if ([textField isEqual:generateRecapTextField]|| [textField isEqual:startTimeTextField]||[textField isEqual:endTimeTextField])
    {
        [dialyRecapName_TextField resignFirstResponder];
        [recapEmailTextField resignFirstResponder];
        [textField resignFirstResponder];
    }
    
    if([textField isEqual:addNewTextField])
    {
        [addNewView setFrame:CGRectMake(30, 40, addNewView.frame.size.width, addNewView.frame.size.height)];
    }
    else
    {
        if (datePickerView != Nil)
            [datePickerView removeFromSuperview];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 157, 320, 260)];
        else
            datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 325, 540,250)];
        
        [datePickerView setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:39.0/255.0 blue:59.0/255.0 alpha:255.0/255.0]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Done" forState:UIControlStateNormal];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            button.frame = CGRectMake(248, 0, 72, 37);
        else
            button.frame = CGRectMake(468, 0, 72, 37);
        
        [button setBackgroundImage:[UIImage imageNamed:@"keyboard-01-done-down.png"] forState:UIControlStateNormal];
        [button addTarget:self  action:@selector(done:) forControlEvents:UIControlEventTouchDown];
        [datePickerView addSubview:button];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            cancel.frame = CGRectMake(0, 0, 72, 37);
        else
            cancel.frame = CGRectMake(0, 0, 72, 37);
        
        [cancel setBackgroundImage:[UIImage imageNamed:@"keyboard-01-done-down.png"] forState:UIControlStateNormal];
        [cancel addTarget:self  action:@selector(cancel:) forControlEvents:UIControlEventTouchDown];
        [datePickerView addSubview:cancel];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 38, 320, 300)];
        else
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 38, 540, 300)];
        
        datePicker.datePickerMode = UIDatePickerModeTime;
        datePicker.hidden = NO;
        datePicker.date = [NSDate date];
        datePicker.alpha = 1.0;
        [datePicker addTarget:self action:@selector(LabelChange:) forControlEvents:UIControlEventValueChanged];
        [datePickerView addSubview:datePicker];
        
        [self.view addSubview:datePickerView];
        
        if([textField isEqual:generateRecapTextField])
        {
            [textField resignFirstResponder];
            [dailyRecapScrollView setContentOffset:CGPointMake(0,0)];
            datePicker.tag = 0;
        }
        else if([textField isEqual:startTimeTextField])
        {
            [textField resignFirstResponder];
            
            datePicker.tag = 1;
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                
                [dailyRecapScrollView setContentOffset:CGPointMake(0,100)];
        }
        else if([textField isEqual:endTimeTextField])
        {
            [textField resignFirstResponder];
            
            datePicker.tag = 2;
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                [dailyRecapScrollView setContentOffset:CGPointMake(0,120)];
        }
        else if([textField isEqual:recapEmailTextField])
        {
            datePicker.tag = 3;
            
            if (datePickerView != Nil)
                [datePickerView removeFromSuperview];
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                [dailyRecapScrollView setContentOffset:CGPointMake(0,150)];
        }
        else if([textField isEqual:dialyRecapName_TextField])
        {
            [generateRecapTextField resignFirstResponder];
            
            if (datePickerView != Nil)
                [datePickerView removeFromSuperview];
        }
    }
    
    [UIView commitAnimations];
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:generateRecapTextField]|| [textField isEqual:startTimeTextField]||[textField isEqual:endTimeTextField])
    {
        [dialyRecapName_TextField resignFirstResponder];
        [recapEmailTextField resignFirstResponder];
        [textField resignFirstResponder];
    }
}

- (void)LabelChange:(id)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"hh:mm a"];
    
    if ([sender tag] == 0)
    {
        generateRecapTextField.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    }
    else if ([sender tag] == 1)
    {
        startTimeTextField.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    }
    else if ([sender tag] == 2)
    {
        endTimeTextField.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    }
}


- (void)done:(id)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@" h:mm a"];
    
    if (datePicker.tag == 0)
    {
        generateRecapTextField.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
        NSUserDefaults *defaluts=[NSUserDefaults  standardUserDefaults];
        [defaluts setObject:datePicker.date forKey:@"generateRecapTime"];
        [defaluts synchronize];
    }
    else if (datePicker.tag == 1)
    {
        NSUserDefaults *defaluts=[NSUserDefaults  standardUserDefaults];
        [defaluts setObject:datePicker.date forKey:@"startTime"];
        [defaluts synchronize];
        startTimeTextField.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    }
    else if (datePicker.tag == 2)
    {
        NSUserDefaults *defaluts=[NSUserDefaults  standardUserDefaults];
        [defaluts setObject:datePicker.date forKey:@"endTime"];
        [defaluts synchronize];
        endTimeTextField.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    }
    
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
        generateRecapView.frame = CGRectMake(generateRecapView.frame.origin.x, 0, generateRecapView.frame.size.width, generateRecapView.frame.size.height);
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
        generateRecapView.frame = CGRectMake(generateRecapView.frame.origin.x, 0, generateRecapView.frame.size.width, generateRecapView.frame.size.height);
        [UIView commitAnimations];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL iPhone = NO;
	
#ifdef UI_USER_INTERFACE_IDIOM
	iPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
#endif
	if (iPhone)
	{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        if(([textField isEqual:generateRecapTextField]) || ([textField isEqual:startTimeTextField]) || ([textField isEqual:endTimeTextField]) || ([textField isEqual:recapEmailTextField]))
        {
            generateRecapView.frame = CGRectMake(generateRecapView.frame.origin.x, 0, generateRecapView.frame.size.width, generateRecapView.frame.size.height);
        }
        else if([textField isEqual:addNewTextField])
        {
            [addNewView setFrame:CGRectMake(30, 75, addNewView.frame.size.width, addNewView.frame.size.height)];
        }
        [UIView commitAnimations];
    }
    [textField resignFirstResponder];
    return NO;
}

#pragma mark touchevent Delegete

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [addNewTextField resignFirstResponder];
    
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self.view];
    if (!CGRectContainsPoint(addNewView.frame, location))
    {
        [UIView animateWithDuration:1.0 animations:^{
            addNewView.alpha = 1.0; addNewView.alpha = 0.0;
        } completion:^(BOOL success) {
            if (success) {
                addNewView.hidden = YES;
                BgView.hidden = YES;
            }
        }];
        selectedValueIndexPath = [[NSMutableArray alloc] init];
                
        addNewTextField.text = @"";
        
        [listtableView reloadData];
    }
}

#pragma - mark UIAlertViiew Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        if (buttonIndex==0)
        {
            NSString *DailyRecapMsg=[NSString stringWithFormat:@"Generated recap email Time : %@ ,Starttime : %@ ,Endtime : %@",self.generateRecapTextField.text,self.startTimeTextField.text,self.endTimeTextField.text];
            
            [self.appDelegate.dBHelper insertDailyRecapIntoDatabase:@"Deactivation" onObject:@"DailyRecap"  valueForObject:DailyRecapMsg];
           
            NSUserDefaults *defaluts=[NSUserDefaults standardUserDefaults];
            [defaluts setBool:NO forKey:@"DeailyRecapIsActvie"];
            [defaluts synchronize];
            generateRecapTextField.text=nil;
            startTimeTextField.text=nil;
            endTimeTextField.text=nil;
        }
    }
    
    if (alertView.tag == 100)
    {
        if (buttonIndex == 1)
        {
            if (appDelegate.selectedIndexInSettingsPage == 1)
            {
                for (int i = 0; i < [selectedValueIndexPath count] ; i++)
                {
                    NSIndexPath *selectedIndexPath = [selectedValueIndexPath objectAtIndex:i];
                    
                    SnoozeReason *snoozeReason = [objectLists objectAtIndex:selectedIndexPath.row];
                    
                    NSString *snoozeResult = [ServiceHelper deleteSnoozeReason:snoozeReason.reasonId];
                  
                    if ([snoozeResult boolValue] == 1)
                    {
                        [self.appDelegate.dBHelper insertDailyRecapIntoDatabase:@"Deleted" onObject:@"SnoozeReason"  valueForObject:snoozeReason.name];
                        [self alertMessage:@"Selected Snooze Reasons Deleted Successfully."];
                    }
                }
            }
            else  if (appDelegate.selectedIndexInSettingsPage == 2)
            {
                for (int i = 0; i < [selectedValueIndexPath count] ; i++)
                {
                    NSIndexPath *selectedIndexPath = [selectedValueIndexPath objectAtIndex:i];
                    
                    IntervalType *intervalType = [objectLists objectAtIndex:selectedIndexPath.row];
                    
                    NSString *intervalTypeResult = [ServiceHelper deleteIntervalType:intervalType.intervalTypeId];
                    
                    if ([intervalTypeResult boolValue] == 1)
                    {
                       [self.appDelegate.dBHelper insertDailyRecapIntoDatabase:@"Deleted" onObject:@"IntervalType"  valueForObject:intervalType.name];
                        [self alertMessage:@"Selected Interval Type Deleted Successfully."];
                    }
                }
            }
            else  if (appDelegate.selectedIndexInSettingsPage == 3)
            {
                for (int i = 0; i < [selectedValueIndexPath count] ; i++)
                {
                    NSIndexPath *selectedIndexPath = [selectedValueIndexPath objectAtIndex:i];
                    
                    Category *category = [objectLists objectAtIndex:selectedIndexPath.row];
                    
                    NSString *categoryResult = [ServiceHelper deleteCategory:category.categoryId];
                    
                    if ([categoryResult boolValue] == 1)
                    {
                      [self.appDelegate.dBHelper insertDailyRecapIntoDatabase:@"Deleted" onObject:@"Category"  valueForObject:category.categoryName];
                       [self alertMessage:@"Selected Category Deleted Successfully."];
                    }
                }
            }
            else  if (appDelegate.selectedIndexInSettingsPage == 6)
            {
                for (int i = 0; i < [selectedValueIndexPath count] ; i++)
                {
                    NSIndexPath *selectedIndexPath = [selectedValueIndexPath objectAtIndex:i];
                    
                    ApplicationType *applicationType = [objectLists objectAtIndex:selectedIndexPath.row];
                    
                    NSString *applicationTypeResult = [ServiceHelper deleteApplicationType:applicationType.applicationTypeId];
                    
                    if ([applicationTypeResult boolValue] == 1)
                    {
                        [self.appDelegate.dBHelper insertDailyRecapIntoDatabase:@"Deleted" onObject:@"ApplicationType"  valueForObject:applicationType.applicationName];
                        [self alertMessage:@"selected application type deleted successfully."];
                    }
                }
            }
            else if (appDelegate.selectedIndexInSettingsPage == 5)
            {
               
                
            }
      }
        [self arrayList];
    }
}

- (void)viewDidUnload {
    
    mondayBtn = nil;
    tuesdayBtn = nil;
    wednesdayBtn = nil;
    thursday = nil;
    friday = nil;
    dailyRecapScrollView = nil;
    dialyRecapName_TextField = nil;
    [self setTimeZoneTextField:nil];
    locationSelectBtn = nil;
    timeZoneSelectBtn = nil;
    [self setLocationNameTextField:nil];
    [self setTimeZoneTextField:nil];
    [self setDailyRecapList:nil];
    [super viewDidUnload];
}

-(void)dailyRecapCellSelected:(NSInteger)returnIndex
{
    if (  locationSelectBtnToggle != 0)
    {
        if ( returnIndex == 0)
        {
            [selectedIndexes removeAllObjects];
            for (int i=0; i <[locationNames count]; i++ )
            {
                [selectedIndexes addObject:[NSNumber numberWithInt:i]];
            }
        }
        else
        {
            [selectedIndexes addObject:[NSNumber numberWithInt:returnIndex]];
        }
        
        for (int i=0; i <[selectedIndexes count]; i++ )
        {
            NSLog(@"selectedIndexes = %@",[locationNames objectAtIndex:[[selectedIndexes objectAtIndex:i]integerValue]]);
        }
        
    }
    else if (timeZoneSelectBtnToggle != 0)
    {
        if ( returnIndex == 0)
        {
            [selectedIndexes removeAllObjects];
            for (int i=0; i <[timeZones count]; i++ )
            {
                [selectedIndexes addObject:[NSNumber numberWithInt:i]];
            }
        }
        else
        {
            [selectedIndexes addObject:[NSNumber numberWithInt:returnIndex]];
        }
        
        for (int i=0; i <[selectedIndexes count]; i++ )
        {
            NSLog(@"selectedIndexes = %@",[timeZones objectAtIndex:[[selectedIndexes objectAtIndex:i]integerValue]]);
        }
    }
}

-(void)dailyRecapCellDselected:(NSInteger)returnIndex
{
    if (locationSelectBtnToggle != 0)
    {
        if ( returnIndex == 0)
        {
            [selectedIndexes removeAllObjects];
        }
        else
        {
            if ([selectedIndexes count]==[locationNames count])
                [selectedIndexes removeObject:[NSNumber numberWithInt:0]];
            
            [selectedIndexes removeObject:[NSNumber numberWithInt:returnIndex]];
        }
        
    }
    else if (timeZoneSelectBtnToggle != 0)
    {
        if ( returnIndex == 0)
        {
            [selectedIndexes removeAllObjects];
        }
        else
        {
            if ([selectedIndexes count]==[locationNames count])
                [selectedIndexes removeObject:[NSNumber numberWithInt:0]];
            
            [selectedIndexes removeObject:[NSNumber numberWithInt:returnIndex]];
        }
    }
}

@end
