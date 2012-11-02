
//
//  custom_KD_PopOverViewController.m
//  ServiceTech
//
//  Created by karthik keyan on 19/09/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "custom_KD_PopOverViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Category.h"
#import "Location.h"

@interface custom_KD_PopOverViewController ()

@end

@implementation custom_KD_PopOverViewController

@synthesize appDelegate = _appDelegate;
@synthesize locationTextField;
@synthesize categoryTextField;
@synthesize locationSelectBtn;
@synthesize categorySelectBtn;
@synthesize describtionTextView;
@synthesize dropwDownCustomTableView = _dropwDownCustomTableView;
@synthesize helpDocYesBtn;
@synthesize helpDocNoBtn;
@synthesize helpDocOnlyBtn;
@synthesize serviceHelper= _serviceHelper;

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
    
	locationSelectBtnToggle = 0;
    CategorySelectBtnToggle = 0;
    describtionTextView.layer.cornerRadius=5.0;
    
    categoryarray     = [[NSMutableArray alloc] init];
    categoryNameList  = [[NSMutableArray alloc]init];
    locationarray     = [[NSMutableArray alloc]init];
    locationNameList  = [[NSMutableArray alloc]init];
    categoriesString  = [[NSMutableString alloc]init];
    locationString    = [[NSMutableString alloc]init];
    selectectedCategories = [[NSMutableArray alloc]init];
    selectectedLocationes = [[NSMutableArray alloc]init];
    
    self.appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [locationTextField setText:[[[[self appDelegate] selectedEntities] location] locationName]];
    [categoryTextField setText:[[[[self appDelegate]selectedEntities]category]categoryName]];
    
    locationIds = [[NSMutableArray alloc] init];
    categoryIds = [[NSMutableArray alloc] init];
    selectedLocationIds = [[NSMutableArray alloc] init];
    selectedCategoryIds = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    
}
- (void)viewDidUnload
{
    [self setLocationTextField:nil];
    [self setLocationSelectBtn:nil];
    [self setCategorySelectBtn:nil];
    [self setDescribtionTextView:nil];
    [self setHelpDocYesBtn:nil];
    [self setHelpDocNoBtn:nil];
    [self setHelpDocOnlyBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancelBtnPressed:(id)sender {
    
    self.appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (self.appDelegate.currentKDpopPresentVC == TICKETMONITER_VC)
    {
        [self.appDelegate.curTicketMonitorVC KD_PopOverCancelBtnPressed];
        
    }else if (self.appDelegate.currentKDpopPresentVC == PROBLEMSOLUTION_VC)
    {
        [self.appDelegate.curprobSoluVC KD_PopOverCancelBtnPressed];
        
    }else if(self.appDelegate.currentKDpopPresentVC == KDLIST_VC)
    {
        [self.appDelegate.currentKDListVc KD_PopOverCancelBtnPressed];
    }
}

- (IBAction)searchBtnPressed:(id)sender {
    
    if ([locationTextField.text length]!=0 &&[categoryTextField.text length]!=0 && helpDocValue!=0) {
        
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSMutableString *categoryIdsString = [[NSMutableString alloc] init];
        
        for (int i=0; i <[selectedCategoryIds count];i++)
        {
            if ([[selectectedCategories objectAtIndex:i] isEqualToString:[categoryNameList objectAtIndex:0]]) {
                
                for (int j=0; j <[categoryIds count];j++)
                {
                    if (j == 0)
                    {
                        [categoryIdsString appendString:@"[\""];
                    }
                    [categoryIdsString appendString:[categoryIds objectAtIndex:j]];
                    
                    if (j == [categoryIds count] -1)
                    {
                        [categoryIdsString appendString:@"\"]"];
                    }
                    
                    else
                    {
                        [categoryIdsString appendString:@"\",\""];
                    }
                }
            }
            else
            {
                if (i == 0)
                {
                    [categoryIdsString appendString:@"[\""];
                }
                [categoryIdsString appendString:[selectedCategoryIds objectAtIndex:i]];
                
                if (i == [selectedCategoryIds count] -1)
                {
                    [categoryIdsString appendString:@"\"]"];
                }
                
                else
                {
                    [categoryIdsString appendString:@"\",\""];
                }
            }
        }
        
        if ([selectedCategoryIds count] == 0)
        {
            [categoryIdsString appendFormat:@"[\"%@\"]",[[[[self appDelegate] selectedEntities] category] categoryId]];
        }
        
        NSMutableString *locationIdsString = [[NSMutableString alloc] init];
        
        for (int i=0; i <[selectectedLocationes count];i++)
        {
            if ([[selectectedLocationes objectAtIndex:i] isEqualToString:[locationNameList objectAtIndex:0]]) {
                
                for (int j=0; j <[locationIds count];j++)
                {
                    if (j == 0)
                    {
                        [locationIdsString appendString:@"[\""];
                    }
                    [locationIdsString appendString:[locationIds objectAtIndex:j]];
                    
                    if (j == [locationIds count] -1)
                    {
                        [locationIdsString appendString:@"\"]"];
                    }
                    else
                    {
                        [locationIdsString appendString:@"\",\""];
                    }
                }
            }
            else
            {
                if (i == 0)
                {
                    [locationIdsString appendString:@"[\""];
                }
                [locationIdsString appendString:[selectedLocationIds objectAtIndex:i]];
                
                if (i == [selectedLocationIds count] -1)
                {
                    [locationIdsString appendString:@"\"]"];
                }
                
                else
                {
                    [locationIdsString appendString:@"\",\""];
                }
            }
        }
        
        if ([selectedLocationIds count] == 0)
        {
            [locationIdsString appendFormat:@"[\"%@\"]",[[[[self appDelegate] selectedEntities] location] locationId]];
        }
        
        NSArray *SearchTerms = [describtionTextView.text componentsSeparatedByString:@","];
        
        NSMutableString *SearchTermsString = [[NSMutableString alloc] init];

        for (int j=0; j <[SearchTerms count];j++)
        {
            if (j == 0)
            {
                [SearchTermsString appendString:@"[\""];
            }
            [SearchTermsString appendString:[SearchTerms objectAtIndex:j]];
            
            if (j == [SearchTerms count] -1)
            {
                [SearchTermsString appendString:@"\"]"];
            }
            else
            {
                [SearchTermsString appendString:@"\",\""];
            }
        }

        NSString *solutionString = [NSString stringWithFormat:@"{\"HelpDocOption\": %d,\"CategoryIds\":%@,\"LocationIds\":%@,\"SearchTerms\": %@}",helpDocValue,categoryIdsString,locationIdsString,SearchTermsString];
              
        self.appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        self.appDelegate.solutionQueryString = solutionString;

        self.appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSMutableArray *KDsolutionList = [self.appDelegate.currentServiceHelper solutionKnowledgeSearch:solutionString];
        
        // NSLog(@"KDsolutionList = %@",KDsolutionList);
        
        self.appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        if (self.appDelegate.currentKDpopPresentVC == TICKETMONITER_VC)
        {
            [appDelegate.curTicketMonitorVC KD_PopOverCancelBtnPressedWith_location:locationTextField.text category:categoryTextField.text describtion:describtionTextView.text KDsolutionList:KDsolutionList];
        }
        else if (self.appDelegate.currentKDpopPresentVC == PROBLEMSOLUTION_VC)
        {
            [appDelegate.curprobSoluVC KD_PopOverCancelBtnPressedWith_location:locationTextField.text category:categoryTextField.text describtion:describtionTextView.text KDsolutionList:KDsolutionList];
            
        }else if (self.appDelegate.currentKDpopPresentVC == KDLIST_VC)
        {
            [appDelegate.currentKDListVc KD_PopOverCancelBtnPressedWith_location:locationTextField.text category:categoryTextField.text describtion:describtionTextView.text KDsolutionList:KDsolutionList];
        }
    }
    else
    {
        NSMutableString *alertString=[[NSMutableString alloc]initWithString:@"Please select "];
        
        if ([locationTextField.text length]==0)
        {
            [alertString appendString:@"Location"];
        }
        if ([categoryTextField.text length]==0)
        {
            if ([alertString length]<18)
                [alertString appendString:@"Category"];
            else
                [alertString appendString:@" ,Category"];
        }
        if (helpDocValue==0)
        {
            if ([alertString length]<18)
                [alertString appendString:@"Help-Doc's Value"];
            else
                [alertString appendString:@" ,Help-Doc's Value"];
        }
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@""
                                                     message:alertString
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)locationSelectButtonPressed:(id)sender {
    
    if (locationSelectBtnToggle==0)
    {
        locationSelectBtnToggle ++;
        [_dropwDownCustomTableView closeAnimation];
        
        [locationNameList removeAllObjects];
        [locationIds removeAllObjects];
        
        
        locationarray= [ServiceHelper getLocations];
        [locationNameList addObject:@"Select All"];
        
        for (int i=0;i<[locationarray count]; i ++)
        {
            Location *location=[locationarray objectAtIndex:i];
            [locationNameList addObject:location.locationName];
            [locationIds addObject:location.locationId];
        }
        
        _dropwDownCustomTableView = [[DropDownView alloc] initWithArrayData:locationNameList cellHeight:35 heightTableView:160 paddingTop:-6 paddingLeft:0 paddingRight:-2 refView:self.locationTextField animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2];
        
        _dropwDownCustomTableView.delegate = self;
        
        [self.view addSubview:_dropwDownCustomTableView.view];
        [_dropwDownCustomTableView openAnimation];
        
        [self.locationSelectBtn setTitle:@"done" forState:UIControlStateNormal];
        
        integervalueCheckDropDownSelection=0;
    }
    else
    {
        locationSelectBtnToggle=0;
        
        [_dropwDownCustomTableView closeAnimation];
        
        [self.locationSelectBtn setTitle:@"select" forState:UIControlStateNormal];
        
        if ([selectectedLocationes count]!=0)
        {
            locationString=nil;
            locationString =[[NSMutableString alloc]init];
            
            for (int i=0; i <[selectectedLocationes count];i++)
            {
                if ([[selectectedLocationes objectAtIndex:i] isEqualToString:[locationNameList objectAtIndex:0]])
                {
                    [locationTextField setText:@"ALL"];
                }
                else
                {
                    if (i==[selectectedLocationes count]-1)
                        [locationString appendFormat:@"%@", [selectectedLocationes objectAtIndex:i]];
                    else
                        [locationString appendFormat:@"%@ ,", [selectectedLocationes objectAtIndex:i]];
                    
                    [locationTextField setText:locationString];
                }
            }
        }
    }
}

- (IBAction)categorySelectedBtnPressed:(id)sender {
    
    if (CategorySelectBtnToggle==0) {
        
        CategorySelectBtnToggle ++;
        [_dropwDownCustomTableView closeAnimation];
        
        [categoryNameList removeAllObjects];
        [categoryIds removeAllObjects];
        
        categoryarray= [ServiceHelper getAllCategories];
        [categoryNameList addObject:@"Select All"];
        
        for (int i=0;i<[categoryarray count]; i ++)
        {
            Category *category=[categoryarray objectAtIndex:i];
            [categoryNameList addObject:category.categoryName];
            [categoryIds addObject:category.categoryId];
        }
        _dropwDownCustomTableView = [[DropDownView alloc] initWithArrayData:categoryNameList cellHeight:35 heightTableView:160 paddingTop:-6 paddingLeft:0 paddingRight:-2 refView:self.categoryTextField animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2];
        
	    _dropwDownCustomTableView.delegate = self;
        
	    [self.view addSubview:_dropwDownCustomTableView.view];
        [_dropwDownCustomTableView openAnimation];
        
        [self.categorySelectBtn setTitle:@"done" forState:UIControlStateNormal];
        
        integervalueCheckDropDownSelection=0;
    }
    else
    {
        CategorySelectBtnToggle=0;
        
        [_dropwDownCustomTableView closeAnimation];
        
        [self.categorySelectBtn setTitle:@"select" forState:UIControlStateNormal];
        
        if ([selectectedCategories count]!=0)
        {
            categoriesString=nil;
            categoriesString =[[NSMutableString alloc]init];
            
            for (int i=0; i <[selectectedCategories count];i++)
            {
                if ([[selectectedCategories objectAtIndex:i] isEqualToString:[categoryNameList objectAtIndex:0]])
                {
                    [categoryTextField setText:@"ALL"];
                }
                else
                {
                    if (i==[selectectedCategories count]-1)
                        [categoriesString appendFormat:@"%@", [selectectedCategories objectAtIndex:i]];
                    else
                        [categoriesString appendFormat:@"%@ ,", [selectectedCategories objectAtIndex:i]];
                    
                    [categoryTextField setText:categoriesString];
                }
            }
        }
    }
}

- (IBAction)helpDocCheckBoxBtnPressed:(id)sender
{
    if (sender==helpDocYesBtn)
    {
        helpDocValue = 3;
        helpDocYesBtn.selected  = YES;
        helpDocNoBtn.selected   = NO;
        helpDocOnlyBtn.selected = NO;
    }
    else if(sender==helpDocNoBtn)
    {
        helpDocValue = 2;
        helpDocYesBtn.selected  = NO;
        helpDocNoBtn.selected   = YES;
        helpDocOnlyBtn.selected = NO;
    }
    else if(sender == helpDocOnlyBtn)
    {
        helpDocValue = 1;
        helpDocYesBtn.selected  = NO;
        helpDocNoBtn.selected   = NO;
        helpDocOnlyBtn.selected = YES;
    }
}

- (IBAction)clearBtnPressed:(id)sender {
    
    helpDocValue = 0;
    helpDocYesBtn.selected  = NO;
    helpDocNoBtn.selected   = NO;
    helpDocOnlyBtn.selected = NO;
    [categoryTextField setText:@""];
    [locationTextField setText:@""];
    [describtionTextView setText:@""];
}

#pragma mark - DropwnDelegate methods

-(void)dropDownCellSelected:(NSInteger)returnIndex {
	
    if(CategorySelectBtnToggle==0)
    {
        if (integervalueCheckDropDownSelection==0) {
            
            [selectedLocationIds removeAllObjects];
            [selectectedLocationes removeAllObjects];
            integervalueCheckDropDownSelection++;
        }
        
        [selectectedLocationes addObject:[locationNameList objectAtIndex:returnIndex]];
        if (returnIndex == 0)
        {
            [selectedLocationIds addObject:@"select all"];
        }else {
            
            [selectedLocationIds addObject:[locationIds objectAtIndex:returnIndex-1]];
        }
        
    }
    else
    {
        if (integervalueCheckDropDownSelection==0) {
            
            [selectedCategoryIds removeAllObjects];
            [selectectedCategories removeAllObjects];
            integervalueCheckDropDownSelection++;
        }
        [selectectedCategories addObject:[categoryNameList objectAtIndex:returnIndex]];
        
        if (returnIndex == 0)
        {
            [selectedCategoryIds addObject:@"select all"];
        }
        else
        {
            [selectedCategoryIds addObject:[categoryIds objectAtIndex:returnIndex-1]];
        }
    }
}
-(void)dropDownCellDeselected:(NSInteger)returnIndex {
    
    if(CategorySelectBtnToggle==0)
    {
        if (returnIndex>=0 && returnIndex<=[locationNameList count])
        {
            [selectectedLocationes removeObject:[locationNameList objectAtIndex:returnIndex]];
            
            if (returnIndex ==0)
            {
                [selectedLocationIds removeObject:@"select all"];
            }
            else
            {
                [selectedLocationIds removeObject:[locationIds objectAtIndex:returnIndex-1]];
            }
        }
    }
    else
    {
        if (returnIndex>=0 && returnIndex<=[categoryNameList count])
        {
            [selectectedCategories removeObject:[categoryNameList objectAtIndex:returnIndex]];
            
            if (returnIndex ==0)
            {
                [selectedCategoryIds removeObject:@"select all"];
            }
            else
            {
                [selectedCategoryIds removeObject:[categoryIds objectAtIndex:returnIndex-1]];
            }
        }
    }
}

#pragma mark - UITextViewDelegate Methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])  {
        
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    self.appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (self.appDelegate.currentKDpopPresentVC == TICKETMONITER_VC)
    {
        [self.appDelegate.curTicketMonitorVC popOverTextViewIsEditng];
        
    }else if (self.appDelegate.currentKDpopPresentVC == PROBLEMSOLUTION_VC)
    {
        [self.appDelegate.curprobSoluVC KD_popOverTextViewIsEditng];
        
    }else if(self.appDelegate.currentKDpopPresentVC == KDLIST_VC)
    {
        [self.appDelegate.currentKDListVc popOverTextViewIsEditng];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    self.appDelegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (self.appDelegate.currentKDpopPresentVC == TICKETMONITER_VC)
    {
        [self.appDelegate.curTicketMonitorVC popOverTextViewIsendEditing];
        
    }else if (self.appDelegate.currentKDpopPresentVC == PROBLEMSOLUTION_VC)
    {
        [self.appDelegate.curprobSoluVC KD_popOverTextViewIsendEditing];
        
    }else if(self.appDelegate.currentKDpopPresentVC == KDLIST_VC)
    {
        [self.appDelegate.currentKDListVc popOverTextViewIsendEditing];
    }
    return YES;
}

@end

