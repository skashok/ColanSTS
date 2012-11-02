//
//  ViewController.m
//  PopUpView
//
//  Created by Apple on 03/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "ProblemSolutionViewController.h"
#import "AddProblemViewController.h"
#import "AddSolutionViewController.h"
#import "ServicePleaseValidation.h"
#import "ServiceHelper.h"
#import "Blob.h"
#import "Problem.h"
#import "Solution.h"
#import "AppDelegate.h"
#import "TicketEmailNotification.h"
#import "Tech.h"
#import "User.h"
#import "KDListViewController.h"

@interface ProblemSolutionViewController ()

@end

@implementation ProblemSolutionViewController

@synthesize currentCreationOfTicketOBJ;
@synthesize probSolAlertView;
@synthesize popoverController;
@synthesize toolBar;
@synthesize tableViewOBJ;
@synthesize problemView;
@synthesize solutionView;
@synthesize bottomToolBarView;
@synthesize addProblem;
@synthesize solutionButton;
@synthesize proSolFrwardBtn;
@synthesize proSolBackwardBtn;
@synthesize addSolImageButton;
@synthesize addProbImageButton;
@synthesize audioPath;
@synthesize problemList;
@synthesize solutionList;
@synthesize saveBtn;
@synthesize cancelBtn;
@synthesize textViewTittle;
@synthesize audioTimer;
@synthesize audioBtn;
@synthesize imageBtn;
@synthesize proSoluBtn;
@synthesize KD_Btn;
@synthesize TM_Btn;
@synthesize appDelegate;
@synthesize currentTextView;
@synthesize filteredListofProblem;
@synthesize filteredListofSolution;
@synthesize locationList;
@synthesize contactList;
@synthesize search_Bar;
@synthesize addProblemOrSolutionView;
@synthesize addProblemOrSolutionTextView;
@synthesize listofKD,filterlistofKD;
@synthesize helpDocSwitch;

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.navigationItem.rightBarButtonItem=nil;
    self.helpDocSwitch.onText=@"YES";
    self.helpDocSwitch.offText=@"NO";
    self.helpDocSwitch.onTintColor=[UIColor colorWithRed:87.05f/255.0f green:84.05f/255.0f blue:84.05f/255.0f alpha:1.0f];
    [self.helpDocSwitch addTarget:self action:@selector(helpDocSwitchToggled:) forControlEvents:UIControlEventValueChanged];
   
    iPad =YES;
    
    iPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    
    if (iPad) {
        
        mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle: nil];
        
    }else {
        
        mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle: nil];
    }
    
    if (appDelegate == nil) {
  		
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    if (appDelegate.newTicketCreationProcess) {
        
        search_Bar.hidden=YES; 
        [textViewTittle setText:@"Ticket Text View"];
        addProblemOrSolutionView.layer.borderWidth=5.0f;
        addProblemOrSolutionView.layer.borderColor=[[UIColor orangeColor]CGColor];
        problemViewIsDoubleClicked=YES; 
        
        [self customizeNewFrameFor_SolView_Ipad:CGRectMake(0,0,0,0) Iphone_frame:CGRectMake(0,0,0,0) ProbView_Ipad:CGRectMake(0,0,0,0) Iphone_frame:CGRectMake(0,0,0,0) addProbOrSolView_Ipad:CGRectMake(0,0,768,916.0) Iphone_frame:CGRectMake(0,0,320,376.0) bottomToolBarView_Ipad:CGRectMake(0,915,768,45) Iphone_frame:CGRectMake(0,376,320,40)];
      
        if (iPad) {
            
            audioTimer.frame=CGRectMake(340, 880, 57, 17);
            
        }else {
            
            audioTimer.frame=CGRectMake(131, 352, 57, 17); 
        }
        self.helpDocSwitch.hidden = NO;
        heplDoc.hidden = NO;
   
    }else {
         
        [self customizeNewFrameFor_SolView_Ipad:CGRectMake(0,450,768,465) Iphone_frame:CGRectMake(0,211,320,165) ProbView_Ipad:CGRectMake(0,44,768,450) Iphone_frame:CGRectMake(0,44,320,165) addProbOrSolView_Ipad:CGRectMake(0,-100,0,0) Iphone_frame:CGRectMake(0,-50,0,0) bottomToolBarView_Ipad:CGRectMake(0,915,768,45) Iphone_frame:CGRectMake(0,376,320,40)];
  
        if (iPad) {
            
            audioTimer.frame=CGRectMake(340, 325, 57, 17);
            
        }else {
            
            audioTimer.frame=CGRectMake(131, 130, 57, 17); 
        }
        audioTimer.hidden = YES;
        self.helpDocSwitch.hidden = YES;
        heplDoc.hidden = YES;
    }
    
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
	[addProblemOrSolutionTextView addGestureRecognizer:tapRecognizer];
	[tapRecognizer setCancelsTouchesInView:NO];
	[tapRecognizer setNumberOfTapsRequired:2];
	[tapRecognizer setNumberOfTouchesRequired:1];
	[tapRecognizer setDelegate:self];
	
    UITapGestureRecognizer *singletapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
	[addProblemOrSolutionTextView addGestureRecognizer:singletapRecognizer];
	[singletapRecognizer setCancelsTouchesInView:NO];
	[singletapRecognizer setNumberOfTapsRequired:1];
	[singletapRecognizer setNumberOfTouchesRequired:1];
	[singletapRecognizer setDelegate:self];
    [singletapRecognizer requireGestureRecognizerToFail :tapRecognizer];
    
    
    
    if (iPad) {
        
        transparentView=[[UIControl alloc]initWithFrame:CGRectMake(0,0, 768, 960)];
        
    }else {
        
        transparentView=[[UIControl alloc]initWithFrame:CGRectMake(0,0, 320, 416)];
    }

    [transparentView setAlpha:0.1f];
    [transparentView addTarget:self action:@selector(transparentViewtouched:)   forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:transparentView];
    transparentView.hidden = YES;

    filteredListofProblem  = [[NSMutableArray alloc] init];
    filteredListofSolution = [[NSMutableArray alloc] init];
    currentImagesList      = [[NSMutableArray alloc] init];
    listofProblems         = [[NSMutableArray alloc] init];
    listofSolutions  = [[NSMutableArray alloc] init];
    listofKD         = [[NSMutableArray alloc] init];
    KDheaderView   = [[UIView alloc]  init];
    KDtableView    = [[UITableView alloc] init];
    headingLabel   = [[UILabel alloc]init];
    authorLabel    = [[UILabel alloc]init];
    rateLabel      = [[UILabel alloc]init];
    self.audioPath = [[NSString alloc]init];
	
    if(totalRecords==0)
        totalRecords=1;
    
    prosolnToggle = NO;
    isKDVisible   = NO;
    
    NSUserDefaults * userdefaluts=[NSUserDefaults standardUserDefaults];
    [userdefaluts setBool:NO forKey:@"NoMatchesFound"];
    [userdefaluts synchronize];
    
     [self createLoadingView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if ( solutionViewIsDoubleClicked||problemViewIsDoubleClicked) {
        
        [self replacingBottomToolBarViewItems_MeansHide_KD_ProSol_AND_TM_Btns:YES];
  
    }else {
        
        [self replacingBottomToolBarViewItems_MeansHide_KD_ProSol_AND_TM_Btns:NO];
    } 
    solutionView.hidden   = NO;
    solutionButton.hidden = NO;
    addProblem.hidden     = NO;
    keyboardIsInFront     = NO;
    prosolnToggle = 0;
    
    self.navigationItem.title = [[[[self appDelegate] selectedEntities] contact] contactName];
    
    popoverClass     = [WEPopoverController class];
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    [self.appDelegate setCurprobSoluVC:self];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWasShown:)  name: UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWasHidden:) name: UIKeyboardWillHideNotification object:nil];
    
    problemViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleProblemViewDoubleTapGestureRecognizer:)];
    [problemViewTapGestureRecognizer setNumberOfTapsRequired:2];
    problemViewTapGestureRecognizer.delegate = self;
    [problemView addGestureRecognizer:problemViewTapGestureRecognizer];
    
    solutionViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSolutionViewDoubleTapGestureRecognizer:)];
    [solutionViewTapGestureRecognizer setNumberOfTapsRequired:2];
    solutionViewTapGestureRecognizer.delegate = self;
    [solutionView addGestureRecognizer:solutionViewTapGestureRecognizer];
    
    problemView.layer.borderWidth = 5.0f;
    problemView.layer.borderColor = [[UIColor orangeColor] CGColor];   
    solutionView.layer.borderWidth = 5.0f;
    solutionView.layer.borderColor = [[UIColor greenColor] CGColor];   
    
    if (!appDelegate.newTicketCreationProcess)  {
        
        filteredListofProblem = [ServiceHelper getAllProblems];
        
        [listofProblems removeAllObjects];
        
        TicketMoniter *currentTicket = [[[self appDelegate] selectedEntities] ticketMonitor] ;
        
        for (int loop = 0; loop < [filteredListofProblem count]; loop ++) {
            
            Problem *problemObj = [filteredListofProblem objectAtIndex:loop];
            
            if ([currentTicket.ticketTicketId isEqualToString:problemObj.ticketId]) {
                
                [listofProblems addObject:[filteredListofProblem objectAtIndex:loop]];
            }
        }
        
        filteredListofSolution = [ServiceHelper getAllSolutions];
        
        [listofSolutions removeAllObjects];
        
        for (int loop = 0; loop < [filteredListofSolution count]; loop ++) {
            
            Solution *solutionObj = [filteredListofSolution objectAtIndex:loop];
            
            if ([currentTicket.ticketTicketId isEqualToString:solutionObj.ticketId]) {
                
                [listofSolutions addObject:solutionObj];
            }
        }
    }
    
    NSUserDefaults * userdefaluts=[NSUserDefaults standardUserDefaults];
    bool NoMatchesFound =[userdefaluts boolForKey:@"NoMatchesFound"];
    
    if (!NoMatchesFound) {
        
        if (self.popoverController) {
            
            [self.popoverController dismissPopoverAnimated:YES];
        }
        transparentView.hidden = YES; 
        [userdefaluts setBool:NO forKey:@"NoMatchesFound"];
        [userdefaluts synchronize];
        
    }else {
        //transparentView.hidden = NO;  
    }
    
    [problemList reloadData];
    [solutionList reloadData];

}

- (void) viewWillDisappear: (BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name: UIKeyboardWillShowNotification object:nil];
    [nc removeObserver:self name: UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidUnload {
    
    [self setHelpDocSwitch:nil];
    [self setProblemList:nil];
    [self setSolutionList:nil];
    [self setImageBtn:nil];
    [self setProSoluBtn:nil];
    [self setKD_Btn:nil];
    [self setTM_Btn:nil];
    [self setBottomToolBarView:nil];
    search_Bar = nil;
    self.popoverController = nil;
    addProblemOrSolutionView = nil;
    addProblemOrSolutionTextView = nil;
    [self.popoverController dismissPopoverAnimated:NO];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
} 

#pragma mark - HelpDoc Methods

- (void)helpDocSwitchToggled:(id)sender {
    
    if ([self.helpDocSwitch isOn]) {
        
    } else {
        
    }
}

#pragma mark - Voice Recognition Methods

// Voice Recognition - EKE - 04/26/2011

- (void) recordVoiceEntry: (id) sender {   
    
    [[self appDelegate] recordButtonAction:sender languageType:0];
}
- (void)handleNotification:(NSNotification *) notification {
    
    if([[self appDelegate] currentTextField] != nil) {
        
		NSString		*theText = [[self appDelegate] currentRecoResult];
		UITextField		*theTextField = [[self appDelegate] currentTextField];
        UITextView		*theTextView = [[self appDelegate] currentTextView];
        
		// Store the speech text.
		[theTextField setText: theText];
        
        [theTextView setText: theText];
		
		[theTextField resignFirstResponder];
        
        [theTextView resignFirstResponder];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	
    return YES;
}

// End of Voice Recognition

#pragma mark - Keyboard Notification Methods

- (void)keyboardWasShown:(id)sender {
    
    keyboardIsInFront = YES;
}

- (void)keyboardWasHidden:(id)sender {
    
    keyboardIsInFront = NO;
}

#pragma mark - UITextView Delegate Methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])  {
        
        [textView resignFirstResponder];
        addProblemOrSolutionTextView.editable=false;
        
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    [self setCurrentTextView:textView];
    
    if (appDelegate.newTicketCreationProcess) {
        
        [self customizeNewFrameFor_SolView_Ipad:CGRectMake(0,0,0,0) Iphone_frame:CGRectMake(0,0,0,0) ProbView_Ipad:CGRectMake(0,0,0,0) Iphone_frame:CGRectMake(0,0,0,0) addProbOrSolView_Ipad:CGRectMake(0,0,768,650.5) Iphone_frame:CGRectMake(0,0,320,161) bottomToolBarView_Ipad:CGRectMake(0,650.5,768,45) Iphone_frame:CGRectMake(0,161,320,40)];
      
        if (iPad) {
          
            audioTimer.frame=CGRectMake(340, 615, 57, 17);
       
        }else {
           
            audioTimer.frame=CGRectMake(131, 136, 57, 17); 
        }
       
   
    }else {
        
        if (problemViewIsDoubleClicked) {
            
            [self customizeNewFrameFor_SolView_Ipad:CGRectMake(0,0,0,0) Iphone_frame:CGRectMake(0,0,0,0) ProbView_Ipad:CGRectMake(0,-250,768,826) Iphone_frame:CGRectMake(0,-20,320,125) addProbOrSolView_Ipad:CGRectMake(0,350,768,300) Iphone_frame:CGRectMake(0,44,320,115) bottomToolBarView_Ipad:CGRectMake(0,650,768,45) Iphone_frame:CGRectMake(0,159,320,40)];
         }else {
            
            [self customizeNewFrameFor_SolView_Ipad:CGRectMake(0,-250,768,826) Iphone_frame:CGRectMake(0,-20,320,125) ProbView_Ipad:CGRectMake(0,0,0,0) Iphone_frame:CGRectMake(0,0,0,0) addProbOrSolView_Ipad:CGRectMake(0,350,768,300) Iphone_frame:CGRectMake(0,44,320,115) bottomToolBarView_Ipad:CGRectMake(0,650,768,45) Iphone_frame:CGRectMake(0,159,320,40)];
        }
   
        if (iPad) {
            
            audioTimer.frame=CGRectMake(340, 265, 57, 17);
            
        }else {
            
            audioTimer.frame=CGRectMake(131, 92, 57, 17); 
        }

    }  
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    if (appDelegate.newTicketCreationProcess) {
        
        [self customizeNewFrameFor_SolView_Ipad:CGRectMake(0,0,0,0) Iphone_frame:CGRectMake(0,0,0,0) ProbView_Ipad:CGRectMake(0,0,0,0) Iphone_frame:CGRectMake(0,0,0,0) addProbOrSolView_Ipad:CGRectMake(0,0,768,916) Iphone_frame:CGRectMake(0,0,320,376) bottomToolBarView_Ipad:CGRectMake(0,915,768,45) Iphone_frame:CGRectMake(0,376,320,40)];
       
        if (iPad) {
            
            audioTimer.frame=CGRectMake(340, 880, 57, 17);
            
        }else {
            
            audioTimer.frame=CGRectMake(131, 352, 57, 17); 
        }

    
    }else {
        
        if (problemViewIsDoubleClicked) {
            
            [self customizeNewFrameFor_SolView_Ipad:CGRectMake(0,0,0,0) Iphone_frame:CGRectMake(0,0,0,0) ProbView_Ipad:CGRectMake(0,44,768,871) Iphone_frame:CGRectMake(0,44,320,250) addProbOrSolView_Ipad:CGRectMake(0,552,768,360) Iphone_frame:CGRectMake(0,221.0,320,155) bottomToolBarView_Ipad:CGRectMake(0,915,768,45) Iphone_frame:CGRectMake(0,376,320,40)];
        }else {
            
            [self customizeNewFrameFor_SolView_Ipad:CGRectMake(0,44,768,871) Iphone_frame:CGRectMake(0,44,320,250) ProbView_Ipad:CGRectMake(0,0,0,0) Iphone_frame:CGRectMake(0,0,0,0) addProbOrSolView_Ipad:CGRectMake(0,552,768,360) Iphone_frame:CGRectMake(0,221.0,320,155) bottomToolBarView_Ipad:CGRectMake(0,915,768,45) Iphone_frame:CGRectMake(0,376,320,40)];
        }
       
        if (iPad)
        {
            audioTimer.frame=CGRectMake(340, 325, 57, 17);
        }
        else
        {
            audioTimer.frame=CGRectMake(131, 130, 57, 17); 
        }
    }  
    [addProblemOrSolutionTextView resignFirstResponder];
   
    return YES; 
}

#pragma mark - UISearchBar Delegate Methods

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar 
{	
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                              target:self action:@selector(doneSearching_Clicked:)];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length] == 0) {
        
        [searchBar performSelector: @selector(resignFirstResponder) 
                        withObject: nil 
                        afterDelay: 0.1];
        [self performSelector:@selector(searchBarCancelButtonClicked:) withObject:nil afterDelay: 0.1];
    }
    
    for (UIView *view in searchBar.subviews){
        
        if ([view isKindOfClass: [UITextField class]]) {
            UITextField *tf = (UITextField *)view;
            tf.delegate = self;
            break;
        }
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
 
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
  
    [self performSelector:@selector(searchBarCancelButtonClicked:) withObject:nil afterDelay: 0.1];
    
    return YES;
}

-(void)searchProcessControllingSection:(NSString *)searchString {
    
}

- (void) doneSearching_Clicked:(id)sender {	
   
    [search_Bar resignFirstResponder];
    self.navigationItem.rightBarButtonItems=nil;
}

#pragma mark - UIInterfaceOrientation Delegate Methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Methods used for adding New problem and solution

- (IBAction)CameraBtnPressed {
    
    //[ImageList removeAllObjects];
    
    if ([ImageList count]>=4)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil
                                                     message:@"You have already added 4 images. Do you want to replace it ?"
                                                    delegate:self 
                                           cancelButtonTitle:@"YES"
                                           otherButtonTitles:@"NO",nil];
        alert.tag=300;
        [alert show];
        
     }
    else 
    {
        cameraAlertView =[[UIAlertView alloc]initWithTitle:nil
                                                   message:nil
                                                  delegate:self 
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Take Photo",@"Choose From Library",nil];
        [cameraAlertView show];
    }
}

- (IBAction)audioBtnPressed {
    
    if ([audioRecorder isRecording]) {
        //[self managingAudioRecordingMode];
        [audioRecorder stop];
        [audioBtn setImage:[UIImage imageNamed:@"mike.png"] forState:UIControlStateNormal];
        audioTimer.text=@"";
        
        if (recordTime!=nil) {
            [recordTime invalidate];
            recordTime=nil;
            appDelegate.curAddprobVC.audioTimer.text=@"";
        }
    }else {
      
        [self audioRecording];         
    }
}

- (IBAction)SaveBtnPressed {
    
    [addProblemOrSolutionTextView resignFirstResponder];
   //  audioTimer.hidden = YES;
    
    if ([audioRecorder isRecording]) {
        
       UIAlertView *alert=[[UIAlertView alloc]initWithTitle: @"Alert"
                                                  message: @"Please stop audio recording then continue"
                                                 delegate: nil 
                                        cancelButtonTitle: @"OK"
                                        otherButtonTitles: nil];
       [alert show];
        
    }else {
        
        if ([addProblemOrSolutionTextView.text length] > 0){
          
            if (problemViewIsDoubleClicked) {
           
                [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
               
                if (appDelegate.newTicketCreationProcess) {
                   
                    if (appDelegate.ifticketRowselectedAndnewBtnPressed)
                    {
                        [self saveByExistingLocAndCat];
                    }
                    else
                    {
                        [self saveButtonWasPressed:nil];
                    }
                }else {
                    
                    [self addingProblem];
                    [self replacingBottomToolBarViewItems_MeansHide_KD_ProSol_AND_TM_Btns:NO];
                    problemViewIsDoubleClicked=NO;
                    [problemViewTapGestureRecognizer setEnabled:YES];
                    
                    [self customizeNewFrameFor_SolView_Ipad:CGRectMake(0,465,768,450) Iphone_frame:CGRectMake(0,211,320,165) ProbView_Ipad:CGRectMake(0,44,768,420) Iphone_frame:CGRectMake(0,44,320,165) addProbOrSolView_Ipad:CGRectMake(0,0,0,916) Iphone_frame:CGRectMake(0,-50,320,0) bottomToolBarView_Ipad:CGRectMake(0,915,768,45) Iphone_frame:CGRectMake(0,376,320,40)];  
                }

            }else {
               
                [self addingSolution];
                [self replacingBottomToolBarViewItems_MeansHide_KD_ProSol_AND_TM_Btns:NO]; 
                solutionViewIsDoubleClicked=NO;
                [solutionViewTapGestureRecognizer setEnabled:YES];
                
                [self customizeNewFrameFor_SolView_Ipad:CGRectMake(0,465,768,450) Iphone_frame:CGRectMake(0,211,320,165) ProbView_Ipad:CGRectMake(0,44,768,420) Iphone_frame:CGRectMake(0,44,320,165) addProbOrSolView_Ipad:CGRectMake(0,0,0,916) Iphone_frame:CGRectMake(0,480,320,0) bottomToolBarView_Ipad:CGRectMake(0,915,768,45) Iphone_frame:CGRectMake(0,376,320,40)];  
            }
        }else {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@""
                                                         message:@"Problem Text field should not be empty"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles: nil];
            
            [alert show];
        }
    }   
 }

-(void)addingProblem
{
    Problem *curProblem = [self createProblemInstance];
    
    if (curProblem !=nil) {
        
        [self saveProblem:curProblem];
        
        [[self appDelegate] setLastProblemBlobID:curProblem.problemId];
        
        if ([self retriveAudioFile] != nil) 
        {
            NSString *folderName = @"Images";
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *curfilename = [NSString stringWithFormat:@"%@/%@",documentsDirectory,folderName];
            
            NSArray *directoryContent  = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:curfilename error:nil];
            
            int filesCount = [directoryContent  count];
            
            NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.txt'"];
            NSArray *onlyTXTs = [directoryContent filteredArrayUsingPredicate:fltr];
            
            filesCount = [onlyTXTs  count];
            
            NSMutableDictionary *blobDictionary = [NSMutableDictionary dictionary];
            [blobDictionary setObject:@"problem" forKey:@"type"];
            [blobDictionary setObject:curProblem.problemId forKey:@"Id"];
            [blobDictionary setObject:[self retriveAudioFile] forKey:@"BlobBytes"];
            [blobDictionary setObject:ST_AUDIO_BlobTypeId forKey:@"BlobTypeId"];
                        
            NSMutableData *data = [[NSMutableData alloc]init];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
            [archiver encodeObject:blobDictionary forKey:[NSString stringWithFormat:@"blobDetails%d",filesCount]];
            [archiver finishEncoding];
            
            [data writeToFile:[NSString stringWithFormat:@"%@/ProblemBlob%d.txt",curfilename,filesCount] atomically:YES];
            
      //      [ServiceHelper createProblemBlob:curProblem.problemId blobBytes:[self retriveAudioFile] blobTypeId:ST_AUDIO_BlobTypeId];
        }
        
        if ([ImageList count]>0) 
        {
            for (int loop = 0; loop < [ImageList count]; loop++) 
            {
                NSString *folderName = @"Images";
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *curfilename = [NSString stringWithFormat:@"%@/%@",documentsDirectory,folderName];
                
                NSArray *directoryContent  = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:curfilename error:nil];
                
                int filesCount = [directoryContent  count];
                
                NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.txt'"];
                NSArray *onlyTXTs = [directoryContent filteredArrayUsingPredicate:fltr];
                
                filesCount = [onlyTXTs  count];
                
                NSMutableDictionary *blobDictionary = [NSMutableDictionary dictionary];
                [blobDictionary setObject:@"problem" forKey:@"type"];
                [blobDictionary setObject:curProblem.problemId forKey:@"Id"];
                [blobDictionary setObject:[ImageList objectAtIndex:loop] forKey:@"BlobBytes"];
                [blobDictionary setObject:ST_IMAGE_BlobTypeId forKey:@"BlobTypeId"];
                
                NSMutableData *data = [[NSMutableData alloc]init];
                NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                [archiver encodeObject:blobDictionary forKey:[NSString stringWithFormat:@"blobDetails%d",filesCount]];
                [archiver finishEncoding];
                
                [data writeToFile:[NSString stringWithFormat:@"%@/ProblemBlob%d.txt",curfilename,filesCount] atomically:YES];
                
             //   [ServiceHelper createProblemBlob:curProblem.problemId blobBytes:[ImageList objectAtIndex:loop] blobTypeId:ST_IMAGE_BlobTypeId];
            }
        }
  
        filteredListofProblem = [ServiceHelper getAllProblems];
        
        [listofProblems removeAllObjects];
        
        if (currentCreationOfTicketOBJ != nil) {
            
            for (int loop = 0; loop < [filteredListofProblem count]; loop ++) 
            {
                Problem *problemObj = [filteredListofProblem objectAtIndex:loop];
                
                if ([currentCreationOfTicketOBJ.ticketId isEqualToString:problemObj.ticketId])
                {
                    [listofProblems addObject:[filteredListofProblem objectAtIndex:loop]];
                }
            }
            
        }else {
            
            TicketMoniter *currentTicket = [[[self appDelegate] selectedEntities] ticketMonitor] ;
            
            for (int loop = 0; loop < [filteredListofProblem count]; loop ++) 
            {
                Problem *problemObj = [filteredListofProblem objectAtIndex:loop];
                
                if ([currentTicket.ticketTicketId isEqualToString:problemObj.ticketId]) 
                {
                    [listofProblems addObject:[filteredListofProblem objectAtIndex:loop]];
                }
            }
            
        }
        [problemList reloadData];
    }
    
    [appDelegate setNewTicketCreationProcess:NO];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.wav",totalRecords]]; 
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:fullPath] == YES) {
        
        [fileManager removeItemAtPath:fullPath error:NULL];
    }
    
    addProblemOrSolutionTextView.text=@"";
    
    [NSThread detachNewThreadSelector:@selector(threadStopAnimating:) toTarget:self withObject:nil];
    
}

-(void)addingSolution
{
    Solution *curSolution = [self createSolutionInstance];
    
    if (curSolution !=nil)
    {
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
        
        [self saveSolution:curSolution];
        
        [[self appDelegate] setLastSolutionBlobID:curSolution.solutionId];
        
        
        if ([self retriveAudioFile] != nil) 
        {
            NSString *folderName = @"Images";

            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *curfilename = [NSString stringWithFormat:@"%@/%@",documentsDirectory,folderName];
            
            NSArray *directoryContent  = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:curfilename error:nil];
            
            int filesCount = [directoryContent  count];
            
            NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.txt'"];
            NSArray *onlyTXTs = [directoryContent filteredArrayUsingPredicate:fltr];
            
            filesCount = [onlyTXTs  count];
            
            NSMutableDictionary *blobDictionary = [NSMutableDictionary dictionary];
            [blobDictionary setObject:@"problem" forKey:@"type"];
            [blobDictionary setObject:curSolution.solutionId forKey:@"Id"];
            [blobDictionary setObject:[self retriveAudioFile] forKey:@"BlobBytes"];
            [blobDictionary setObject:ST_AUDIO_BlobTypeId forKey:@"BlobTypeId"];
            
            NSMutableData *data = [[NSMutableData alloc]init];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
            [archiver encodeObject:blobDictionary forKey:[NSString stringWithFormat:@"blobDetails%d",filesCount]];
            [archiver finishEncoding];
            
            [data writeToFile:[NSString stringWithFormat:@"%@/ProblemBlob%d.txt",curfilename,filesCount] atomically:YES];
            
        //    [ServiceHelper createSolutionBlob:curSolution.solutionId blobBytes:[self retriveAudioFile] blobTypeId:ST_AUDIO_BlobTypeId];
        }
        
        if ([ImageList count]>0) 
        {
            for (int loop = 0; loop < [ImageList count]; loop++) 
            {
                NSString *folderName = @"Images";
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *curfilename = [NSString stringWithFormat:@"%@/%@",documentsDirectory,folderName];
                
                NSArray *directoryContent  = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:curfilename error:nil];
                
                int filesCount = [directoryContent  count];
                
                NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.txt'"];
                NSArray *onlyTXTs = [directoryContent filteredArrayUsingPredicate:fltr];
                
                filesCount = [onlyTXTs  count];
                
                NSMutableDictionary *blobDictionary = [NSMutableDictionary dictionary];
                [blobDictionary setObject:@"solution" forKey:@"type"];
                [blobDictionary setObject:curSolution.solutionId forKey:@"Id"];
                [blobDictionary setObject:[ImageList objectAtIndex:loop] forKey:@"BlobBytes"];
                [blobDictionary setObject:ST_IMAGE_BlobTypeId forKey:@"BlobTypeId"];
                
                NSMutableData *data = [[NSMutableData alloc]init];
                NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                [archiver encodeObject:blobDictionary forKey:[NSString stringWithFormat:@"blobDetails%d",filesCount]];
                [archiver finishEncoding];
                
                [data writeToFile:[NSString stringWithFormat:@"%@/SolutionBlob%d.txt",curfilename,filesCount] atomically:YES];

           //       [ServiceHelper createSolutionBlob:curSolution.solutionId blobBytes:[ImageList objectAtIndex:loop] blobTypeId:ST_IMAGE_BlobTypeId];
            }
        }
        
        [filteredListofSolution removeAllObjects];
        
        filteredListofSolution = [ServiceHelper getAllSolutions];
        
        
        [listofSolutions removeAllObjects];
        
        if (currentCreationOfTicketOBJ != nil) {
            
            for (int loop = 0; loop < [filteredListofSolution count]; loop ++) 
            {
                Solution *solutionObj = [filteredListofSolution objectAtIndex:loop];
                
                if ([currentCreationOfTicketOBJ.ticketId isEqualToString:solutionObj.ticketId])
                {
                    [listofSolutions addObject:[filteredListofSolution objectAtIndex:loop]];
                }
            }
        }else
        {
            for (int loop = 0; loop < [filteredListofSolution count]; loop ++) 
            {
                Solution *solutionObj = [filteredListofSolution objectAtIndex:loop];
                
                TicketMoniter *currentTicket = [[[self appDelegate] selectedEntities] ticketMonitor] ;
                
                if ([currentTicket.ticketTicketId isEqualToString:solutionObj.ticketId]) 
                {
                    [listofSolutions addObject:solutionObj];
                }
            }
        }
        
        [solutionList reloadData];
  }
    
    [appDelegate setNewTicketCreationProcess:NO];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.wav",totalRecords]]; 
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:fullPath] == YES) {
        
        [fileManager removeItemAtPath:fullPath error:NULL];
    }
    addProblemOrSolutionTextView.text=@"";
    
    [NSThread detachNewThreadSelector:@selector(threadStopAnimating:) toTarget:self withObject:nil];
    
}

- (IBAction)cancelBtnPressed:(id)sender {
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self managingAudioRecordingMode];

    if (appDelegate.newTicketCreationProcess) {
    
        for (UIViewController *VC in self.navigationController.viewControllers) {
            
            if ([VC isKindOfClass:[TicketMonitorViewController class]]) {
                
                [self.navigationController popToViewController:VC animated:YES];
            }
        }
    }else {
        
        [addProblemOrSolutionTextView resignFirstResponder];
         audioTimer.hidden = YES;
        
        [self replacingBottomToolBarViewItems_MeansHide_KD_ProSol_AND_TM_Btns:NO];
        
        if (problemViewIsDoubleClicked) {

            problemViewIsDoubleClicked=NO;
            [problemViewTapGestureRecognizer setEnabled:YES];
           
            [self customizeNewFrameFor_SolView_Ipad:CGRectMake(0,465,768,450) Iphone_frame:CGRectMake(0,211,320,165) ProbView_Ipad:CGRectMake(0,44,768,420) Iphone_frame:CGRectMake(0,44,320,165) addProbOrSolView_Ipad:CGRectMake(0,-100,0,0) Iphone_frame:CGRectMake(0,-50,0,0) bottomToolBarView_Ipad:CGRectMake(0,915,768,45) Iphone_frame:CGRectMake(0,376,320,40)];
         
        }else {
            
            solutionViewIsDoubleClicked=NO;
            [solutionViewTapGestureRecognizer setEnabled:YES];
          
            [self customizeNewFrameFor_SolView_Ipad:CGRectMake(0,465,768,450) Iphone_frame:CGRectMake(0,211,320,165) ProbView_Ipad:CGRectMake(0,44,768,420) Iphone_frame:CGRectMake(0,44,320,165) addProbOrSolView_Ipad:CGRectMake(0,-100,0,0) Iphone_frame:CGRectMake(0,-50,0,0) bottomToolBarView_Ipad:CGRectMake(0,915,768,45) Iphone_frame:CGRectMake(0,376,320,40)];
        } 
    }
}

- (IBAction)proSoluBtnPressed:(id)sender forEvent:(UIEvent*)event
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [self.view bringSubviewToFront:search_Bar];
    
    if (prosolnToggle == 0)
    {
        prosolnToggle++;
        if (iPad) 
        {
            solutionView.frame = CGRectMake(solutionView.frame.origin.x,44, solutionView.frame.size.width, 871);
            problemView.frame = CGRectMake(problemView.frame.origin.x, -450.0, problemView.frame.size.width, 330);
            
        }
        else 
        {
            solutionView.frame = CGRectMake(solutionView.frame.origin.x, 44, solutionView.frame.size.width, 330);
            problemView.frame = CGRectMake(problemView.frame.origin.x, -350.0, problemView.frame.size.width, 330);
        }
    }
    else if (prosolnToggle == 1)
    {
        prosolnToggle++;
        if (iPad) 
        {
            solutionView.frame = CGRectMake(solutionView.frame.origin.x,900, solutionView.frame.size.width, 871);
            problemView.frame = CGRectMake(problemView.frame.origin.x, 44.0, problemView.frame.size.width, 871);
            
        }
        else 
        {
            solutionView.frame = CGRectMake(solutionView.frame.origin.x, 380, solutionView.frame.size.width, 330);
            problemView.frame = CGRectMake(problemView.frame.origin.x, 44.0, problemView.frame.size.width, 330);
        }
    }
    else if (prosolnToggle == 2)
    {
        prosolnToggle = 0;
        if (iPad) 
        {
            problemView.frame = CGRectMake(0, 44,problemView.frame.size.width, 435);
            solutionView.frame= CGRectMake(solutionView.frame.origin.x,478 , solutionView.frame.size.width,435);            
        }
        else
        {
            problemView.frame = CGRectMake(0, 44,problemView.frame.size.width, 165);
            solutionView.frame= CGRectMake(solutionView.frame.origin.x,211.0 , solutionView.frame.size.width,165); 
        } 
    }
    [UIView commitAnimations];   
}

- (IBAction)TM_BtnPressed:(id)sender 
{
    if (self.popoverController) {
        
        [self.popoverController dismissPopoverAnimated:YES];
    }
   
    for (UIViewController *VC in self.navigationController.viewControllers) {
        
        if ([VC isKindOfClass:[TicketMonitorViewController class]]) {
            
            [self.navigationController popToViewController:VC animated:YES];
        }
    }
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag==200)
    {
        if (buttonIndex==0)
        {
            [self addImages:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }
    
    else if(alertView.tag==300)
    {
        if (buttonIndex==0) 
        {
            
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self 
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Take Photo",@"Choose From Library",nil];
        alert.tag=400;
        [alert show];
        }
        
    }
    else if(alertView.tag==400)
    {
        if (buttonIndex==1) 
        {
            [ImageList removeAllObjects];
            [self addImages:UIImagePickerControllerSourceTypeCamera];
            
        }
        else if(buttonIndex==2) 
        {
            [ImageList removeAllObjects];          
            [self addImages:UIImagePickerControllerSourceTypePhotoLibrary];         
        }
    } 
    
    else if (alertView == cameraAlertView) 
    {
        if (buttonIndex==1) 
        {
            [self addImages:UIImagePickerControllerSourceTypeCamera];
            
        }else if(buttonIndex==2) {
            
            [self addImages:UIImagePickerControllerSourceTypePhotoLibrary];         
        }
        
    }else if (alertView == imageCountAlretView) {
        
        if (buttonIndex==0) {
    
            cameraAlertView =[[UIAlertView alloc]initWithTitle:nil
                                                       message:nil
                                                      delegate:self 
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"Take Photo",@"Choose From Library",nil];
            [cameraAlertView show];
            
        }
    }else if (alertView ==audioAlret){
        
        if (buttonIndex==1) 
        {
            [self AudioisRecording];
            NSLog(@"Still not completed");  
        } 
    }else if (alertView ==saveTicketAlert) {
       
        self.helpDocSwitch.hidden=YES;
        heplDoc.hidden=YES;
        search_Bar.hidden =  NO;
        [self replacingBottomToolBarViewItems_MeansHide_KD_ProSol_AND_TM_Btns:NO];
        [self customizeNewFrameFor_SolView_Ipad:CGRectMake(0,465,768,450) Iphone_frame:CGRectMake(0,211,320,165) ProbView_Ipad:CGRectMake(0,44,768,450) Iphone_frame:CGRectMake(0,44,320,165) addProbOrSolView_Ipad:CGRectMake(0,0,0,916) Iphone_frame:CGRectMake(0,-100,320,0) bottomToolBarView_Ipad:CGRectMake(0,915,768,45) Iphone_frame:CGRectMake(0,376,320,40)];  
    }
}

#pragma mark - UIImagePickerController Delegate methods


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSUserDefaults * userdefaluts=[NSUserDefaults standardUserDefaults];
    [userdefaluts setBool:YES forKey:@"NoMatchesFound"];
    [userdefaluts synchronize];
    [self dismissModalViewControllerAnimated:YES];
    [popOver dismissPopoverAnimated:YES];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissModalViewControllerAnimated:YES];
    [popOver dismissPopoverAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSMutableData *imageData=[NSMutableData dataWithData: UIImageJPEGRepresentation(image, 1.0)];  
    [self addImagesToImageList:imageData];
    imageData=nil;
    NSString *string;
    
    if ([ImageList count]==1) {
        
        string=[NSString stringWithFormat:@"You have added %i image successfully,Do you want to add another image ?",[ImageList count]];
    } 
    if ([ImageList count] >=4) {
        
        string=[NSString stringWithFormat:@"You can add only %i images.",[ImageList count]];
        imageCountAlretView=[[UIAlertView alloc]initWithTitle:nil
                                                      message:string
                                                     delegate:nil 
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"OK",nil];
        [imageCountAlretView show];
    }else {
        
        string=[NSString stringWithFormat:@"You have added %i images successfully,Do you want to add another image ?",[ImageList count]];
        
        if ([ImageList count]!=0) {
            
            imageCountAlretView=[[UIAlertView alloc]initWithTitle:nil
                                                          message:string
                                                         delegate:self 
                                                cancelButtonTitle:nil
                                                otherButtonTitles:@"YES",@"NO",nil];
            
            
            [imageCountAlretView show];
        }
    }
}

- (void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (error) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}


- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection 
{
    [self dismissModalViewControllerAnimated: YES];
    MPMediaItem *item = [[mediaItemCollection items] objectAtIndex:0];
    audioFilePath = [item valueForProperty:MPMediaItemPropertyAssetURL];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFilePath error:nil];
    player.volume = 1; 
    player.delegate=self;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil]; 
    [player play]; 
    playTime=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playBtnProgressView) userInfo:nil repeats:YES];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker 
{   
    [self dismissModalViewControllerAnimated: YES]; 
}

-(NSString *)getProblemTitleString:(Problem *)curProblem isIntialEnrty:(BOOL)isFirstEnrty
{
    NSString *strticketTech;
    NSString *contactname;
    NSString *callbackno;
    NSString *displaystring;
    
    Problem *problemObjx = curProblem;
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    Contact *contact = [[[self appDelegate] selectedEntities]contact];
    
    User *currentUser = [[[self appDelegate] selectedEntities]user];
    
    TicketMoniter *ticketMonitorObj = [[[self appDelegate] selectedEntities]ticketMonitor];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yy/HH:mm"];
    
    NSString *DateString = [formatter stringFromDate:problemObjx.createDate];
    NSString *substring = [DateString substringWithRange:NSMakeRange(9, 2)];
    
    float f = [substring floatValue];
    
    if (f<12.0) 
    {
        DateString=[DateString stringByAppendingString:@"a"];
    }else 
    {
        DateString=[DateString stringByAppendingString:@"p"];
    }
    
    if (contact !=nil) 
    {
        if ([contactname isEqualToString:@""] || [contactname isEqualToString:NULL] ||contactname==nil)
        {
            contactname = currentUser.userName;
        }
        else 
        {
            contactname = contact.contactName;
        }
        if ([callbackno isEqualToString:@""] || [callbackno length]==0|| callbackno==nil)
        {
            callbackno = @"12345";
        }
        else 
        {
            callbackno = contact.callBackNum;
        }
    }
    
    if (ticketMonitorObj !=nil) 
    {
        strticketTech = ticketMonitorObj.ticketTech;
    }
    else if ([strticketTech isEqualToString:@""] || [strticketTech isEqualToString:NULL]|| strticketTech==nil) 
    {
        strticketTech= currentUser.userName;
    } 
  
    if(isFirstEnrty)
    {
        displaystring = [NSString stringWithFormat:@"%@/%@/%@/%@",DateString,contactname,callbackno,strticketTech];
    }else {
        
        displaystring=[NSString stringWithFormat:@"%@/%@",DateString,strticketTech];
    }
    
    return displaystring;
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


#pragma mark - Methods used for adding Images for uploading

-(void)addImages:(UIImagePickerControllerSourceType)sourceType {
    
    if (sourceType ==UIImagePickerControllerSourceTypeCamera ) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = 
            UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = NO;
            [self presentModalViewController:imagePicker animated:YES];
        }
     } else {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            
            UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
            imagePicker.sourceType = 
            UIImagePickerControllerSourceTypePhotoLibrary;
            
            imagePicker.allowsEditing = NO;
            imagePicker.delegate = self;
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
               
                [self presentModalViewController:imagePicker animated:YES];         
            }
            else {
              
                popOver=[[UIPopoverController alloc]initWithContentViewController:imagePicker];
                [popOver presentPopoverFromRect:CGRectMake(380.0, 300.0, 00.0, 00.0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            }
        }
    }
}

- (void)addImagesToImageList:(NSData *)imageData {
    
    if (ImageList ==nil) {
        
        ImageList =[[NSMutableArray alloc]init];
    }
    [ImageList addObject:imageData];
}

#pragma mark - Methods used for recording , displaying audio recording progress

- (void)audioRecording {
    
    if ([audioRecorder isRecording])
    {
        [audioRecorder stop];
        [audioBtn setImage:[UIImage imageNamed:@"mike.png"] forState:UIControlStateNormal];
        audioTimer.text=@"";
        [appDelegate.curAddprobVC.playBtn setEnabled:YES];
        
        if (recordTime!=nil)
        {
            [recordTime invalidate];
            recordTime=nil;
            appDelegate.curAddprobVC.audioTimer.text=@"";
        }
        
        for (id obj in [addProblemVC.view subviews])
        {
            if ([obj tag] == 2)
            {
                [(UIButton *)obj setTitle:@"RECORD" forState:UIControlStateNormal];
            }
        }
        
    }
    else
    {
        if (isAudoPlaying)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@""
                                  message:@"Stop Playing to  Record"
                                  delegate:nil
                                  cancelButtonTitle: @"OK"
                                  otherButtonTitles:nil];
            [alert show];
            
        }
        else
        {
            
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
            NSString *dir = [paths objectAtIndex:0];
            self.audioPath = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.wav",totalRecords]];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            if ([fileManager fileExistsAtPath:self.audioPath] == YES)
            {
                
                audioAlret=[[UIAlertView alloc]initWithTitle:@""
                                                     message:@"Do you want replace the old audio file ?"
                                                    delegate:self
                                           cancelButtonTitle:@"NO"
                                           otherButtonTitles:@"YES", nil ];
                [audioAlret show];
            }
            else
            {
                [appDelegate.curAddprobVC.playBtn setEnabled:NO];
                [self AudioisRecording];
            }
        }
    }
}

-(void)AudioisRecording
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    
    [settings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [settings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [settings setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    [settings setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:self.audioPath]
                                                settings:settings error:nil];
    [audioRecorder prepareToRecord];
    [audioRecorder record];
    audioRecorder.delegate=self;
    
    [audioBtn setImage:[UIImage imageNamed:@"stopRecord.png"] forState:UIControlStateNormal];
    recordTime=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(displayRecordtime) userInfo:nil repeats:YES];
    
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.curAddprobVC.playingprogress.hidden=YES;
    appDelegate.curAddprobVC.playingprogress.progress=0.0;
    
    for (id obj in [addProblemVC.view subviews]) {
        
        if ([obj tag] == 2) {
            
            [(UIButton *)obj setTitle:@" STOP" forState:UIControlStateNormal];
        }
    }
}
- (void)displayRecordtime {
	
    NSTimeInterval interval =[audioRecorder currentTime];
    long min = (long)interval / 60;
    long sec = (long)interval % 60;
    NSString* timerValue = [[NSString alloc] initWithFormat:@"%02ld:%02ld", min, sec];
    
    audioTimer.text=timerValue;
    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.curAddprobVC.audioTimer.text=timerValue;
}

- (NSData *)retriveAudioFile {
    
    NSString *fileName =[NSString stringWithFormat:@"%d.wav",totalRecords];
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														  NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSData   *data;
    if([fileManager fileExistsAtPath:path] == YES)
	{
        data = [NSData dataWithContentsOfFile:path];
        
        if (data !=nil) {
            
            NSLog(@"test");
        }
    }
    return data;
}

#pragma mark - AVAudioRecorder Delegate Methods

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
	NSLog (@"audioRecorderDidFinishRecording:successfully:");
	
}

#pragma mark - Creating Problem and Solution Instance

- (Problem *) createProblemInstance
{
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    Problem *prob = nil;
    
    if ([addProblemOrSolutionTextView.text length] > 0) {
        
        @try 
        {
            if (prob == nil) 
            {
                prob = [[Problem alloc] init];
            }
            NSLog(@"Ticket send to APP DELEGATE: %@",[[[self appDelegate] selectedEntities] ticketMonitor]);
            
            NSLog(@"ticketObjForAdding: %@",currentCreationOfTicketOBJ);
            
            NSLog(@"Ticket send to APP DELEGATE: %@",([[[[self appDelegate] selectedEntities] ticketMonitor] ticketTicketId]));
            
            if (currentCreationOfTicketOBJ != nil) 
            {
                [prob setTicketId:currentCreationOfTicketOBJ.ticketId];		
            }
            else 
            {
                [prob setTicketId:[[[[self appDelegate] selectedEntities] ticketMonitor] ticketTicketId]];		
            }
            [prob setProblemId:[NSString stringWithUUID]];
            [prob setProblemShortDesc:@""];
            [prob setProblemText:addProblemOrSolutionTextView.text];
            [prob setCreateDate:[NSDate date]];
            [prob setEditDate:[NSDate date]];
        }
        @catch (NSException *exception) 
        {
            NSLog(@"Error in createTicketInstance.  Error: %@", [exception description]);
        }
        @finally 
        {    		
            return prob;
        }	
    }else {
        return prob;
    }
}

- (Solution *) createSolutionInstance
{
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
	
    Solution *sol = nil;
	
	@try 
	{
		if (sol == nil) 
		{
			sol = [[Solution alloc] init];
		}
        NSLog(@"Ticket send to APP DELEGATE: %@",[[[self appDelegate] selectedEntities] ticketMonitor]);
        
        NSLog(@"ticketObjForAdding: %@",currentCreationOfTicketOBJ);
        
        if (currentCreationOfTicketOBJ != nil) 
        {
            [sol setTicketId:currentCreationOfTicketOBJ.ticketId];		
        }
        else 
        {
            [sol setTicketId:[[[[self appDelegate] selectedEntities] ticketMonitor] ticketTicketId]];		
        }
        
		[sol setSolutionId:[NSString stringWithUUID]];
		[sol setSolutionShortDesc:@""];
		[sol setSolutionText:addProblemOrSolutionTextView.text];
		[sol setCreateDate:[NSDate date]];
		[sol setEditDate:[NSDate date]];
	}
	@catch (NSException *exception) 
	{
		NSLog(@"Error in createTicketInstance.  Error: %@", [exception description]);
	}
	@finally 
	{    		
		return sol;
	}	
}

- (BOOL) saveSolution:(Solution *) sol
{
	BOOL wasSuccessful = NO;
	
	@try 
	{
		if ([self doesSolutionExist:solution] == YES) 
		{
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ticket Exists" 
																message:@"The Ticket entry already exists" 
															   delegate:self 
													  cancelButtonTitle:@"Ok" 
													  otherButtonTitles:nil];
			
			[alertView show];
			
			return NO;
		}
		
		Solution *newSolution = [ServiceHelper addSolution:sol];
		
		if (newSolution != nil) 
		{
			wasSuccessful = YES;
		}
		else 
		{
			wasSuccessful = NO;
		}
	}
	@catch (NSException *exception) 
	{
		NSLog(@"Error in saveTicket.  Error: %@", [exception description]);
	}
	@finally 
	{    		
		return wasSuccessful;
	}
}

- (BOOL) doesSolutionExist:(Solution *) solution
{
	BOOL solutionExists = NO;
	
	@try 
	{
		// ticketExists = [ServiceHelper doesTicketExist:[ticket ticketName]]; 
	}
	@catch (NSException *exception) 
	{
		NSLog(@"Error in doesTicketExist.  Error: %@", [exception description]);
		
		solutionExists = NO;
	}
	@finally 
	{
		return solutionExists;
	}
}

- (BOOL) saveProblem:(Problem *) prob
{
	BOOL wasSuccessful = NO;
	
	@try 
	{
		if ([self doesProblemExist:prob] == YES) 
		{
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ticket Exists" 
																message:@"The Ticket entry already exists" 
															   delegate:self 
													  cancelButtonTitle:@"Ok" 
													  otherButtonTitles:nil];
			
			[alertView show];
			
			return NO;
		}
		
		Problem *newProblem = [ServiceHelper addProblem:prob];
		
		if (newProblem != nil) 
		{
			wasSuccessful = YES;
		}
		else 
		{
			wasSuccessful = NO;
		}
	}
	@catch (NSException *exception) 
	{
		NSLog(@"Error in saveTicket.  Error: %@", [exception description]);
	}
	@finally 
	{    		
		return wasSuccessful;
	}
}

- (BOOL) doesProblemExist:(Problem *) solution
{
	BOOL problemExists = NO;
	
	@try 
	{
		// ticketExists = [ServiceHelper doesTicketExist:[ticket ticketName]]; 
	}
	@catch (NSException *exception) 
	{
		NSLog(@"Error in doesTicketExist.  Error: %@", [exception description]);
		
		problemExists = NO;
	}
	@finally 
	{
		return problemExists;
	}
}

- (IBAction)KD_BtnPressed:(id)sender {
    
    CGSize ipadSize   = CGSizeMake(500,450);
    CGSize iphoneSize = CGSizeMake(350,330);
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self.appDelegate setCurrentKDpopPresentVC:PROBLEMSOLUTION_VC];
    [self presentCustomize_KD_PopOverVC_WithSize_Ipad:&ipadSize Iphone:&iphoneSize];
}

-(void)transparentViewtouched:(UIControl *)sender {
    
    if (self.popoverController) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController=nil;
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
    // Return the number of rows in the section.
    
    if (tableView == self.problemList) 
    {
        if ([listofProblems count]!=0) 
        {
            NSArray *sortlistofProblems=[[listofProblems reverseObjectEnumerator] allObjects]; //sort
            [listofProblems removeAllObjects];
            listofProblems=[NSMutableArray arrayWithArray:sortlistofProblems];
        }
        return [ listofProblems count];
    } 
    else if (tableView == self.solutionList) 
    {
        if ([listofSolutions count]!=0)
        {
            NSArray *sortlistofSolutions = [[listofSolutions reverseObjectEnumerator] allObjects];
            [listofSolutions removeAllObjects];
            listofSolutions = [NSMutableArray arrayWithArray:sortlistofSolutions];
        }
        return [ listofSolutions count];
    } 
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCell";
    if (tableView == self.problemList) 
    {
        customCell    *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        problem = [listofProblems objectAtIndex:indexPath.row];
        
        if (indexPath.row == 0) {
            cell.tittleLabel.text = [self getProblemTitleString:problem isIntialEnrty:YES];
        }else {
            cell.tittleLabel.text = [self getProblemTitleString:problem isIntialEnrty:NO];
        }
        
        cell.detailLabel.text=problem.problemText;
        return cell;
    } 
    else if (tableView == self.solutionList) 
    {
        static NSString *CellIdentifier = @"SolutionCell";
        customSolutionTabellCell *soluCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        soluCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        solution = [listofSolutions objectAtIndex:indexPath.row];
        
        soluCell.tittleLabel.text= [self getSolutionTitleString:solution];
        soluCell.detailLabel.text=solution.solutionText;
        
        return soluCell;
    } 
    return nil;
}
#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - CustomTableCellDelegate Methods 

-(void)problemcustomCellBtnPressed:(id)sender cell:(customCell *)cell{
   
    if (!problemViewIsDoubleClicked) {
      
        NSIndexPath *currentcellpath=[self.problemList indexPathForCell:cell];
        problem =[listofProblems objectAtIndex:currentcellpath.row];
        
        [self managingAudioRecordingMode];
        
        [currentImagesList removeAllObjects];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"saved.wav"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:appFile])
        { 
            [fileManager removeItemAtPath:appFile error:nil];
        }
        
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
        
        NSMutableArray *solutionBlobs = [ServiceHelper getProblemBlobs:problem.problemId];
        
        NSLog(@"solutionBlobs :%d",[solutionBlobs count]);
        
        problemViewPopoverIsInFront = YES;   
        
        if([solutionBlobs count] > 0)
        {
            
            for (int loop = 0; loop < [solutionBlobs count]; loop ++) 
            {
                SolutionBlobPacket *solutionBlobPacket = [solutionBlobs objectAtIndex:loop];
                
                if ([solutionBlobPacket.blobTypeId caseInsensitiveCompare:ST_IMAGE_BlobTypeId] == NSOrderedSame) 
                {
                    [currentImagesList addObject:[UIImage imageWithData:[Base64Utils dataFromBase64String:solutionBlobPacket.blobBytes]]];
                    
                }
                else if ([solutionBlobPacket.blobTypeId caseInsensitiveCompare:ST_AUDIO_BlobTypeId] == NSOrderedSame) 
                {
                    NSData *data = [Base64Utils dataFromBase64String:solutionBlobPacket.blobBytes];
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    
                    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"saved.wav"];
                    
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    
                    if ([fileManager fileExistsAtPath:appFile])
                    { 
                        [fileManager removeItemAtPath:appFile error:nil];
                    }
                    
                    [data writeToFile:appFile atomically:YES];
                }
            }
        }
        
        CGSize ipadSize   = CGSizeMake(500,270);
        CGSize iphoneSize = CGSizeMake(280,210);
        [self presentCustomizePopOverWithSize_Ipad:&ipadSize Iphone:&iphoneSize textViewText:problem.problemText textViewTittle:@"Problem Text View"];
        
        [NSThread detachNewThreadSelector:@selector(threadStopAnimating:) toTarget:self withObject:nil];

    }
}

-(void)customSolutionTabelCellBtnPressed:(id)sender cell:(customSolutionTabellCell *)cell{
  
    if (!solutionViewIsDoubleClicked) {
      
        NSIndexPath *currentCellPath=[self.solutionList indexPathForCell:cell];
        solution=[listofSolutions objectAtIndex:currentCellPath.row];
        
        [self managingAudioRecordingMode];
        [currentImagesList removeAllObjects];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"saved.wav"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:appFile])
        { 
            [fileManager removeItemAtPath:appFile error:nil];
        }
        
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
        
        NSMutableArray *solutionBlobs = [ServiceHelper getSolutionBlobs:solution.solutionId];
        
        NSLog(@"solutionBlobs :%d",[solutionBlobs count]);
        
        problemViewPopoverIsInFront = NO;   
        
        if([solutionBlobs count] > 0)
        {
            for (int loop = 0; loop < [solutionBlobs count]; loop ++) 
            {
                SolutionBlobPacket *solutionBlobPacket = [solutionBlobs objectAtIndex:loop];
                
                if ([solutionBlobPacket.blobTypeId caseInsensitiveCompare:ST_IMAGE_BlobTypeId] == NSOrderedSame) 
                {
                    [currentImagesList addObject:[UIImage imageWithData:[Base64Utils dataFromBase64String:solutionBlobPacket.blobBytes]]];
                }
                else if ([solutionBlobPacket.blobTypeId caseInsensitiveCompare:ST_AUDIO_BlobTypeId] == NSOrderedSame) 
                {
                    NSData *data = [Base64Utils dataFromBase64String:solutionBlobPacket.blobBytes];
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    
                    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"saved.wav"];
                    
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    
                    if ([fileManager fileExistsAtPath:appFile])
                    { 
                        [fileManager removeItemAtPath:appFile error:nil];
                    }
                    
                    [data writeToFile:appFile atomically:YES];
                }
            }
        }
        
        CGSize ipadSize   = CGSizeMake(500,270);
        CGSize iphoneSize = CGSizeMake(280,210);
        [self presentCustomizePopOverWithSize_Ipad:&ipadSize Iphone:&iphoneSize textViewText:solution.solutionText textViewTittle:@"Solution Text View"];
        
        [NSThread detachNewThreadSelector:@selector(threadStopAnimating:) toTarget:self withObject:nil];

    }
  }

#pragma mark - UITapGestureRecognizer Methods 

-(void)handleProblemViewDoubleTapGestureRecognizer:(UIGestureRecognizer *) sender {
   
    [self managingAudioRecordingMode];
    [self replacingBottomToolBarViewItems_MeansHide_KD_ProSol_AND_TM_Btns:YES];
   
    if ((ImageList!=nil) || ([ImageList count]>0)) {
        
        [ImageList removeAllObjects];
    }
   
    addProblemOrSolutionTextView.text=@"";
    problemViewIsDoubleClicked=YES;
    textViewTittle.text=@"Problem Text View";
    [problemViewTapGestureRecognizer setEnabled:NO];
    addProblemOrSolutionTextView.frame=CGRectMake(10,20,298,10);
    audioTimer.hidden = NO;

    [self customizeNewFrameFor_SolView_Ipad:CGRectMake(0,960,768,0) Iphone_frame:CGRectMake(0,430,320,0) ProbView_Ipad:CGRectMake(0,44,768,871) Iphone_frame:CGRectMake(0,44,320,330) addProbOrSolView_Ipad:CGRectMake(0,552,768,360) Iphone_frame:CGRectMake(0,221,320,155) bottomToolBarView_Ipad:CGRectMake(0,915,768,45) Iphone_frame:CGRectMake(0,376,320,40)];
   
    if (iPad) {
        
        addProblemOrSolutionTextView.frame=CGRectMake(10,38,743,280);
    }else {
        addProblemOrSolutionTextView.frame=CGRectMake(10,25,298,110);
    }

    addProblemOrSolutionView.layer.borderWidth=5.0f;
    addProblemOrSolutionView.layer.borderColor=[[UIColor orangeColor]CGColor];
}

-(void)handleSolutionViewDoubleTapGestureRecognizer:(UIGestureRecognizer *) sender {
    
    [self managingAudioRecordingMode];
    [self replacingBottomToolBarViewItems_MeansHide_KD_ProSol_AND_TM_Btns:YES];
    
    if ((ImageList!=nil) || ([ImageList count]>0)) {
        
        [ImageList removeAllObjects];
    }
    textViewTittle.text=@"Solution Text View";
    addProblemOrSolutionTextView.text=@"";
    solutionViewIsDoubleClicked=YES;
    problemViewIsDoubleClicked=NO;
    [solutionViewTapGestureRecognizer setEnabled:NO];
    audioTimer.hidden = NO;
    
    [self customizeNewFrameFor_SolView_Ipad:CGRectMake(0,44,768,871) Iphone_frame:CGRectMake(0,44,320,330) ProbView_Ipad:CGRectMake(0,44,768,0) Iphone_frame:CGRectMake(0,44,320,0) addProbOrSolView_Ipad:CGRectMake(0,552,768,360) Iphone_frame:CGRectMake(0,221,320,155) bottomToolBarView_Ipad:CGRectMake(0,915,768,45) Iphone_frame:CGRectMake(0,376,320,40)];
    
    if (iPad) {
      
        addProblemOrSolutionTextView.frame=CGRectMake(10,38,743,280);
    }else {
        addProblemOrSolutionTextView.frame=CGRectMake(10,25,298,110);
    }
   
    addProblemOrSolutionView.layer.borderWidth=5.0f;
    addProblemOrSolutionView.layer.borderColor=[[UIColor greenColor]CGColor];
    [UIView commitAnimations];
}

-(void) handleSingleTapGesture:(UIGestureRecognizer *) sender {
    
   // addProblemOrSolutionTextView.editable= true;
   //[addProblemOrSolutionTextView becomeFirstResponder];
}

-(void) handleDoubleTapGesture:(UIGestureRecognizer *) sender 
{
    [addProblemOrSolutionTextView resignFirstResponder];
    addProblemOrSolutionTextView.editable= true;
    
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    
    [self performSelector:@selector(performOnSeparateMethod) withObject:nil afterDelay:0.1];
    
    //    CGPoint tapPoint = [sender locationInView:[self view]];
    //    
    //    int tapX = (int) tapPoint.x;
    //    int tapY = (int) tapPoint.y;
    //    
    //	NSLog(@"TAPPED X:%d Y:%d", tapX, tapY);
    //    
    //	NSLog(@"Text Field: %d", [[self currentTextView] tag]);
    //	
    //	[self recordVoiceEntry:[self currentTextView]];
	
	// [self performSelector:@selector(showMessage) withObject:nil afterDelay:0.0];
}

-(void)performOnSeparateMethod
{
    
    NSLog(@"Locaiton listing: %d",[[ServiceHelper getLocationsByOrganization:[[[[self appDelegate] selectedEntities] organization] organizationId]] count]);
    
	[self setLocationList:[ServiceHelper getLocationsByOrganization:[[[[self appDelegate] selectedEntities] organization] organizationId]]];
    
    [self setContactList:[ServiceHelper getContactsByLocation:[[[[self appDelegate] selectedEntities] location] locationId]]];
    
   	
	ContactListingViewController *contactListingController = (ContactListingViewController*)[mainStoryboard 
                                                                                             instantiateViewControllerWithIdentifier:@"ContactListingController"];
	
	[[self navigationController] pushViewController:contactListingController animated:YES];
    
    [NSThread detachNewThreadSelector:@selector(threadStopAnimating:) toTarget:self withObject:nil];
}

#pragma mark - UIActivityIndicatorView Methods

-(void)createLoadingView
{
loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 90)];
loadingView.backgroundColor = [UIColor blackColor];
loadingView.layer.cornerRadius = 10;
loadingView.layer.borderWidth = 1;
loadingView.layer.borderColor = [UIColor whiteColor].CGColor;
loadingView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 3);
[self.view addSubview:loadingView];
loadingView.hidden = YES;

activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
activityIndicator.frame = CGRectMake(0, 0,40, 40);;
[loadingView addSubview:activityIndicator];
activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, 70 / 2);
[activityIndicator startAnimating];

UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 120, 20)];
textLabel.text =@"Loading..";
textLabel.textAlignment = UITextAlignmentCenter;
textLabel.textColor = [UIColor whiteColor];
textLabel.backgroundColor = [UIColor clearColor];
[loadingView addSubview:textLabel];

}
-(void)threadStartAnimating:(id)data 
{
    [loadingView setHidden:NO];
    [activityIndicator startAnimating]; 
}

-(void)threadStopAnimating:(id)data
{
    [loadingView setHidden:YES];
    [activityIndicator stopAnimating]; 
}

#pragma mark - Popover Methods

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
	self.popoverController = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//The popover is automatically dismissed if you click outside it, unless you return NO here
  
    [self managingAudioRecordingMode];
  
    transparentView.hidden=YES;
    return YES;
}

#pragma mark - Left and Right UINavigationBar Button Methods

-(IBAction)leftNavBtnPressed
{
    if (self.popoverController) 
    {
        [self.popoverController dismissPopoverAnimated:YES];
    }
    [self.navigationController popToViewController:appDelegate.curTicketMonitorVC animated:YES];
}

-(IBAction)rightNavBtnPressed
{
    NSLog(@"right Btn Pressed");
}

#pragma mark - PopOver Methods

- (void)doneBtnPressed
{
    if ([audioRecorder isRecording])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@""
                                                     message:@"Please stop Audio Recording "
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        if (self.popoverController)
        {
            [self.popoverController dismissPopoverAnimated:YES];
            self.popoverController = nil;
            
            [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
            
            [self performSelector:@selector(doneBtnProcess) withObject:nil afterDelay:0.1];
        }
  
    }
}

-(void)doneBtnProcess
{       
        for (id obj in [addProblemVC.view subviews])
        {
            if ([obj tag] == 1)
            {
                UITextView *textView = (UITextView *)obj;
                addProblemOrSolutionTextView.text = textView.text;
            }
        }
        
        if (problemViewPopoverIsInFront) {
            
            if ([addProblemOrSolutionTextView.text length] > 0){
                
                problem.problemText = addProblemOrSolutionTextView.text;
                
                Problem *updateProblem = [ServiceHelper updateProblem:problem];
                
                NSLog(@"updateProblem = %@",updateProblem);
                
                [[self appDelegate] setLastProblemBlobID:problem.problemId];
                
                if ([self retriveAudioFile] != nil)
                {
                    NSString *folderName = @"Images";
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *curfilename = [NSString stringWithFormat:@"%@/%@",documentsDirectory,folderName];
                    
                    NSArray *directoryContent  = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:curfilename error:nil];
                    
                    int filesCount = [directoryContent  count];
                    
                    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.txt'"];
                    NSArray *onlyTXTs = [directoryContent filteredArrayUsingPredicate:fltr];
                    
                    filesCount = [onlyTXTs  count];
                    
                    NSMutableDictionary *blobDictionary = [NSMutableDictionary dictionary];
                    [blobDictionary setObject:@"problem" forKey:@"type"];
                    [blobDictionary setObject:problem.problemId forKey:@"Id"];
                    [blobDictionary setObject:[self retriveAudioFile] forKey:@"BlobBytes"];
                    [blobDictionary setObject:ST_AUDIO_BlobTypeId forKey:@"BlobTypeId"];
                    
                    NSMutableData *data = [[NSMutableData alloc]init];
                    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                    [archiver encodeObject:blobDictionary forKey:[NSString stringWithFormat:@"blobDetails%d",filesCount]];
                    [archiver finishEncoding];
                    
                    [data writeToFile:[NSString stringWithFormat:@"%@/ProblemBlob%d.txt",curfilename,filesCount] atomically:YES];

                   // [ServiceHelper createProblemBlob:problem.problemId blobBytes:[self retriveAudioFile] blobTypeId:ST_AUDIO_BlobTypeId];
                }
                
                if ([ImageList count]>0)
                {
                    for (int loop = 0; loop < [ImageList count]; loop++)
                    {
                        NSString *folderName = @"Images";
                        
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectory = [paths objectAtIndex:0];
                        NSString *curfilename = [NSString stringWithFormat:@"%@/%@",documentsDirectory,folderName];
                        
                        NSArray *directoryContent  = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:curfilename error:nil];
                        
                        int filesCount = [directoryContent  count];
                        
                        NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.txt'"];
                        NSArray *onlyTXTs = [directoryContent filteredArrayUsingPredicate:fltr];
                        
                        filesCount = [onlyTXTs  count];
                        
                        NSMutableDictionary *blobDictionary = [NSMutableDictionary dictionary];
                        [blobDictionary setObject:@"problem" forKey:@"type"];
                        [blobDictionary setObject:problem.problemId forKey:@"Id"];
                        [blobDictionary setObject:[ImageList objectAtIndex:loop] forKey:@"BlobBytes"];
                        [blobDictionary setObject:ST_IMAGE_BlobTypeId forKey:@"BlobTypeId"];
                        
                        NSMutableData *data = [[NSMutableData alloc]init];
                        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                        [archiver encodeObject:blobDictionary forKey:[NSString stringWithFormat:@"blobDetails%d",filesCount]];
                        [archiver finishEncoding];
                        
                        [data writeToFile:[NSString stringWithFormat:@"%@/ProblemBlob%d.txt",curfilename,filesCount] atomically:YES];

                      //  [ServiceHelper createProblemBlob:problem.problemId blobBytes:[ImageList objectAtIndex:loop] blobTypeId:ST_IMAGE_BlobTypeId];
                    }
                }
                filteredListofProblem = [ServiceHelper getAllProblems];
                
                [listofProblems removeAllObjects];
                
                if (currentCreationOfTicketOBJ != nil) {
                    
                    for (int loop = 0; loop < [filteredListofProblem count]; loop ++)
                    {
                        Problem *problemObj = [filteredListofProblem objectAtIndex:loop];
                        
                        if ([currentCreationOfTicketOBJ.ticketId isEqualToString:problemObj.ticketId])
                        {
                            [listofProblems addObject:[filteredListofProblem objectAtIndex:loop]];
                        }
                    }
                    
                }else {
                    
                    TicketMoniter *currentTicket = [[[self appDelegate] selectedEntities] ticketMonitor] ;
                    
                    for (int loop = 0; loop < [filteredListofProblem count]; loop ++)
                    {
                        Problem *problemObj = [filteredListofProblem objectAtIndex:loop];
                        
                        if ([currentTicket.ticketTicketId isEqualToString:problemObj.ticketId])
                        {
                            [listofProblems addObject:[filteredListofProblem objectAtIndex:loop]];
                        }
                    }
                }
                [problemList reloadData];
                addProblemOrSolutionTextView.text=@"";
                
            }else {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@""
                                                             message:@"Problem Text field should not be empty"
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles: nil];
                
                [alert show];
            }
            
        }else {
            
            if ([addProblemOrSolutionTextView.text length] > 0){
                
                solution.solutionText = addProblemOrSolutionTextView.text;
                
                Solution *updatedSolution = [ServiceHelper updateSolution:solution];
                
                NSLog(@"updatedSolution = %@",updatedSolution);

                [[self appDelegate] setLastSolutionBlobID:solution.solutionId];
                
                
                if ([self retriveAudioFile] != nil)
                {
                    NSString *folderName = @"Images";
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *curfilename = [NSString stringWithFormat:@"%@/%@",documentsDirectory,folderName];
                    
                    NSArray *directoryContent  = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:curfilename error:nil];
                    
                    int filesCount = [directoryContent  count];
                    
                    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.txt'"];
                    NSArray *onlyTXTs = [directoryContent filteredArrayUsingPredicate:fltr];
                    
                    filesCount = [onlyTXTs  count];
                    
                    NSMutableDictionary *blobDictionary = [NSMutableDictionary dictionary];
                    [blobDictionary setObject:@"problem" forKey:@"type"];
                    [blobDictionary setObject:solution.solutionId forKey:@"Id"];
                    [blobDictionary setObject:[self retriveAudioFile] forKey:@"BlobBytes"];
                    [blobDictionary setObject:ST_AUDIO_BlobTypeId forKey:@"BlobTypeId"];
                    
                    NSMutableData *data = [[NSMutableData alloc]init];
                    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                    [archiver encodeObject:blobDictionary forKey:[NSString stringWithFormat:@"blobDetails%d",filesCount]];
                    [archiver finishEncoding];
                    
                    [data writeToFile:[NSString stringWithFormat:@"%@/ProblemBlob%d.txt",curfilename,filesCount] atomically:YES];

                   // [ServiceHelper createSolutionBlob:solution.solutionId blobBytes:[self retriveAudioFile] blobTypeId:ST_AUDIO_BlobTypeId];
                }
                
                if ([ImageList count]>0)
                {
                    for (int loop = 0; loop < [ImageList count]; loop++)
                    {
                        NSString *folderName = @"Images";
                        
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectory = [paths objectAtIndex:0];
                        NSString *curfilename = [NSString stringWithFormat:@"%@/%@",documentsDirectory,folderName];
                        
                        NSArray *directoryContent  = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:curfilename error:nil];
                        
                        int filesCount = [directoryContent  count];
                        
                        NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.txt'"];
                        NSArray *onlyTXTs = [directoryContent filteredArrayUsingPredicate:fltr];
                        
                        filesCount = [onlyTXTs  count];
                        
                        NSMutableDictionary *blobDictionary = [NSMutableDictionary dictionary];
                        [blobDictionary setObject:@"solution" forKey:@"type"];
                        [blobDictionary setObject:solution.solutionId forKey:@"Id"];
                        [blobDictionary setObject:[ImageList objectAtIndex:loop] forKey:@"BlobBytes"];
                        [blobDictionary setObject:ST_IMAGE_BlobTypeId forKey:@"BlobTypeId"];
                        
                        NSMutableData *data = [[NSMutableData alloc]init];
                        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                        [archiver encodeObject:blobDictionary forKey:[NSString stringWithFormat:@"blobDetails%d",filesCount]];
                        [archiver finishEncoding];
                        
                        [data writeToFile:[NSString stringWithFormat:@"%@/SolutionBlob%d.txt",curfilename,filesCount] atomically:YES];

                     //   [ServiceHelper createSolutionBlob:solution.solutionId blobBytes:[ImageList objectAtIndex:loop] blobTypeId:ST_IMAGE_BlobTypeId];
                        
                    }
                }
                addProblemOrSolutionTextView.text=@"";
                filteredListofSolution = [ServiceHelper getAllSolutions];
                
                [listofSolutions removeAllObjects];
                
                if (currentCreationOfTicketOBJ != nil) {
                    
                    for (int loop = 0; loop < [filteredListofSolution count]; loop ++)
                    {
                        Solution *solutionObj = [filteredListofSolution objectAtIndex:loop];
                        
                        if ([currentCreationOfTicketOBJ.ticketId isEqualToString:solutionObj.ticketId])
                        {
                            [listofSolutions addObject:[filteredListofSolution objectAtIndex:loop]];
                        }
                    }
                    
                }else
                {
                    for (int loop = 0; loop < [filteredListofSolution count]; loop ++)
                    {
                        Solution *solutionObj = [filteredListofSolution objectAtIndex:loop];
                        
                        TicketMoniter *currentTicket = [[[self appDelegate] selectedEntities] ticketMonitor] ;
                        
                        if ([currentTicket.ticketTicketId isEqualToString:solutionObj.ticketId])
                        {
                            [listofSolutions addObject:solutionObj];
                        }
                    }
                }
                [solutionList reloadData];
                
            }else {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@""
                                                             message:@"Solution Text field should not be empty"
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles: nil];
                
                [alert show];
                
            }
        }
        
        [NSThread detachNewThreadSelector:@selector(threadStopAnimating:) toTarget:self withObject:nil];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.wav",totalRecords]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:fullPath] == YES) {
            
            [fileManager removeItemAtPath:fullPath error:NULL];
        }
        transparentView.hidden = YES;
 }


-(void)playBtnPressed {
    
    if ([audioRecorder isRecording])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@""
                              message:@"Stop Recording to Play"
                              delegate:nil
                              cancelButtonTitle: @"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if (isAudoPlaying)
        {
            [player pause];
            isAudoPlaying=NO;
            playerPaused=YES;
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            appDelegate.curAddprobVC.playingprogress.progress =auidioPlayerTime;
            
            for (id obj in [addProblemVC.view subviews])
            {
                if ([obj tag] == 3)
                {
                    [(UIButton *)obj setTitle:@" PLAY" forState:UIControlStateNormal];
                }
            }
        }
        else
        {
            if (playerPaused)
            {
                isAudoPlaying=YES;
                [player play];
                playTime=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(playBtnProgressView) userInfo:nil repeats:YES];
                
                for (id obj in [addProblemVC.view subviews])
                {
                    if ([obj tag] == 3)
                    {
                        [(UIButton *)obj setTitle:@" STOP" forState:UIControlStateNormal];
                    }
                }
            }
            else
            {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"saved.wav"]];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                if ([fileManager fileExistsAtPath:fullPath] == YES)
                {
                    if(!isAudoPlaying)
                    {
                        isAudoPlaying=YES;
                        NSURL *url = [NSURL URLWithString:fullPath];
                        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                        player.volume = 1;
                        player.delegate=self;
                        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                        [player play];
                        appDelegate.curAddprobVC.playingprogress.hidden=NO;
                        appDelegate.curAddprobVC.playingprogress.progress=0.0;
                        playTime=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(playBtnProgressView) userInfo:nil repeats:YES];
                        
                        for (id obj in [addProblemVC.view subviews])
                        {
                            if ([obj tag] == 3)
                            {
                                [(UIButton *)obj setTitle:@" STOP" forState:UIControlStateNormal];
                            }
                        }
                    }
                    
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@""
                                          message:@"No Audio File Found"
                                          delegate:nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                }
            }
        }
     }
}

- (void)playBtnProgressView {
    
    float total=player.duration;
    auidioPlayerTime=player.currentTime / total;
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.curAddprobVC.playingprogress.progress =auidioPlayerTime;
    
    if(![player isPlaying])
    {
		isAudoPlaying=NO;
        
        for (id obj in [addProblemVC.view subviews]) 
        {
            if ([obj tag] == 3) 
            {
                
                [(UIButton *)obj setTitle:@" PLAY" forState:UIControlStateNormal];
                
            }
        }
        
		if(playTime!=nil)
        {
            [playTime invalidate];
			playTime=nil;
		}
	}
}

- (void)ImagesBtnPressed 
{
    if (iPad) 
    {
        UIViewController *popoverContent = [[UIViewController alloc] init];
        UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
        popoverView.backgroundColor = [UIColor whiteColor];
        popoverContent.view = popoverView;
        UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 768, 44)];
        UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Pro-Sol Images"];
        [navBar pushNavigationItem:navItem animated:NO];
        [navBar setTintColor:[UIColor blackColor]];    
        
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(CloseBtnPressed)];
        navItem.rightBarButtonItem = closeButton;
        [popoverContent.view addSubview:navBar];
        UIScrollView *imageScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 768, 960)];
        imageScrollview.delegate = self;
        
        imageScrollview.bounces = NO;
        imageScrollview.pagingEnabled = YES;
        CGFloat x=0;
        
        
        if ([currentImagesList count] == 0) {
          
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"There is no images to view. Would you like to add images" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
            
            alert.tag=200;
            [alert show];
            return;
        }
        else 
        {
        for (int loop = 0; loop < [currentImagesList count]; loop ++)
        {            
            UIImageView *imageview=[[UIImageView alloc]init];
            [imageview setFrame:CGRectMake(x, 0, 768,960)]; 
            
            UIImage *currentImages = [currentImagesList objectAtIndex:loop];
            
            if (currentImages != nil) 
            {
                [imageview setImage:currentImages];
            }
            else 
            {
                [imageview setBackgroundColor:[UIColor brownColor]];
            }
            [imageScrollview addSubview:imageview];
            
            x+=768;
        }
        
        [imageScrollview setContentSize:CGSizeMake(768*[currentImagesList count], 960)];
        [popoverContent.view addSubview:imageScrollview];
        [self presentModalViewController:popoverContent animated:YES];
 
        }
    }else {
        
        UIViewController *popoverContent = [[UIViewController alloc] init];
        UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 170)];
        popoverView.backgroundColor = [UIColor blackColor];
        popoverContent.view = popoverView;
        UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Pro-Sol Images"];
        [navBar pushNavigationItem:navItem animated:NO];
        [navBar setTintColor:[UIColor blackColor]];    
        
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(CloseBtnPressed)];
        navItem.rightBarButtonItem = closeButton;
        
        [popoverContent.view addSubview:navBar];
        UIScrollView *imageScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 436)];
        imageScrollview.delegate = self;
        
        imageScrollview.bounces = NO;
        imageScrollview.pagingEnabled = YES;
        CGFloat x=0;
        
        if ([currentImagesList count] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"There is no images to view. Would you like to add images" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
            
            alert.tag=200;
            [alert show];
        }
        else 
        {
        for (int loop = 0; loop < [currentImagesList count]; loop ++)
        {            
            UIImageView *imageview=[[UIImageView alloc]init];
            [imageview setFrame:CGRectMake(x, 0, 320,405)]; 
            
            UIImage *currentImages = [currentImagesList objectAtIndex:loop];
            
            if (currentImages != nil) 
            {
                [imageview setImage:currentImages];
            }
            else 
            {
                [imageview setBackgroundColor:[UIColor brownColor]];
            }
            [imageScrollview addSubview:imageview];
            
            x+=320;
        }
        
        [imageScrollview setContentSize:CGSizeMake(320*[currentImagesList count], 436)];
        [popoverContent.view addSubview:imageScrollview];
        [self presentModalViewController:popoverContent animated:YES];
        } 
    }
}

#pragma mark - Preview images addNew and cancel Methods

-(void)CloseBtnPressed {
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - PopOver Methods for changing position(x,y)-Moving up and down while editing

- (void)KD_popOverTextViewIsEditng {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if (!iPad){
        
        self.popoverController.view.frame=CGRectMake(0,20,321, 330);   
    }
    [UIView commitAnimations];
}

- (void)KD_popOverTextViewIsendEditing {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if (!iPad){
        
        self.popoverController.view.frame=CGRectMake(0,110,321, 330);    
    }
    [UIView commitAnimations];
}

- (void)popOverTextViewIsEditng
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if (!iPad){
        
        self.popoverController.view.frame=CGRectMake(19,110,280, 210);      
    }
    [UIView commitAnimations];
}

- (void)popOverTextViewIsendEditing{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if (!iPad){
        
        self.popoverController.view.frame=CGRectMake(19,160,280, 210);
    }
    [UIView commitAnimations];
}


#pragma mark - Add Ticket

- (IBAction)saveButtonWasPressed:(id)sender
{
    
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSMutableArray *listOfCats = [ServiceHelper getAllCategories];
    
    [self.appDelegate setFilterListOfCategories:listOfCats];
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [self.appDelegate setCurrentTMFilter:CATEGORY_FILTER];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        filterPopupView = (FilterPopupView*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FilterPopupView"];
        
        [filterPopupView setCatDelegate:self];
        
        CGRect frame = filterPopupView.view.frame;
        
        frame.origin.y = 0;
        
        filterPopupView.view.frame = frame;

        [self.view addSubview:filterPopupView.view];
    }
    else 
    {
        if(![popoverController1 isPopoverVisible])
        {
            filterPopupView = (FilterPopupView*)[mainStoryboard 
                                                 instantiateViewControllerWithIdentifier:@"FilterPopupView"];
            
            [filterPopupView setCatDelegate:self];
            
            popoverController1 = [[UIPopoverController alloc] initWithContentViewController:filterPopupView] ;
            
            [filterPopupView setRootPopUpViewController:popoverController1];
            
            [popoverController1 setPopoverContentSize:CGSizeMake(300, 400)];
            
            CGRect frameSize = CGRectMake(140, 0, 500, 250);
            
            [popoverController1 presentPopoverFromRect:frameSize inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
        }else{
            
            [popoverController1 dismissPopoverAnimated:YES];
        }
    }
}

- (void)dismissPopoverAnimated:(BOOL)animated
{
    
}

-(void)dismissPopover
{
    [popoverController1 dismissPopoverAnimated:YES];
    popoverController1 = nil;   
}

-(void)CatsSelected:(NSString *)catId
{
    
    if ([catId length] > 0) 
    {
        categoryId = catId;
    }
 
    //If a tech adds a NEW ticket (meaning the app user is a tech), the ticket will automatically assign it to himself and NO text notification needs to be sent.
    self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    Tech *curTech=(Tech *)[[self.appDelegate selectedEntities]user];
    
    NSString *userRollId = [[[self.appDelegate selectedEntities]user] userRollId];
    
    if ([ST_User_Role_TECH isEqualToString:userRollId] || [ST_User_Role_TECH_SUPER isEqualToString:userRollId]) 
    {
        [self TechSelected:curTech];
    }
    else 
    {
        NSMutableArray *listOfTechs = [ServiceHelper getUsers];
        
        [self.appDelegate setFilterListOfTechs:listOfTechs];
        
        self.appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
        [self.appDelegate setCurrentTMFilter:TECH_FILTER];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            filterPopupView = (FilterPopupView*)[mainStoryboard instantiateViewControllerWithIdentifier:@"FilterPopupView"];
            
            [filterPopupView setCatDelegate:self];
            
            CGRect frame = filterPopupView.view.frame;
            
            frame.origin.y = 0;
            
            filterPopupView.view.frame = frame;

            [self.view addSubview:filterPopupView.view];
        }
        else 
        {
            if(![popoverController1 isPopoverVisible])
            {
                filterPopupView = (FilterPopupView*)[mainStoryboard 
                                                     instantiateViewControllerWithIdentifier:@"FilterPopupView"];
                
                [filterPopupView setCatDelegate:self];
                
                popoverController1 = [[UIPopoverController alloc] initWithContentViewController:filterPopupView] ;
                
                [filterPopupView setRootPopUpViewController:popoverController1];
                
                [popoverController1 setPopoverContentSize:CGSizeMake(300, 400)];
                
                CGRect frameSize = CGRectMake(140, 0, 500, 250);
                
                [popoverController1 presentPopoverFromRect:frameSize inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            }
            else
            {
                [popoverController1 dismissPopoverAnimated:YES];
            }
        }
    }
}

-(void)TechSelected:(Tech *)tech 
{
    if ([tech.userName length] > 0) 
    {
        techName = tech.userName;
    }
    if ([tech.userId length] > 0) 
    {
        userID = tech.userId;
    }
    
    
    //If a NEW ticket is created and assigned to a tech by customer service, a text notification shall be sent indicating 'location, contact, call-back # and problem description (as much as the text will allow).
    
    NSString *userRollId = [[[self.appDelegate selectedEntities]user] userRollId];
    
    NSLog(@"[[appDelegate selectedEntities] contact]=%@",[[appDelegate selectedEntities] contact]);
    
    if (userRollId!=nil)
    {
        if([ST_User_Role_Customer_Care isEqualToString:userRollId]) // customer service
        {
            NSString *selectedRollid=[ServiceHelper getUserRollid:[tech userId]];
            
            if (selectedRollid!=nil)
            {
                if ([ST_User_Role_TECH isEqualToString:selectedRollid] || [ST_User_Role_TECH_SUPER isEqualToString:selectedRollid])
                {
                    // Assigned to tech... send notification  // point 1
                    
                    NSMutableString *message = [[NSMutableString alloc] initWithString:@""];
                    [message appendString:@"Location:"];
                    [message appendFormat:@"%@",[[appDelegate selectedEntities] location].locationName];
                    [message appendString:@",Contact:"];
                    [message appendFormat:@"%@",[[appDelegate selectedEntities] contact].contactName];
                    [message appendString:@",CallbackNum:"];
                    [message appendFormat:@"%@",[[appDelegate selectedEntities] contact].callBackNum];
                    [message appendString:@",Problem Description:"];
                    [message appendFormat:@"%@",addProblemOrSolutionTextView.text];
                    
                    NSLog(@"message = %@",message);
                    
                    NSString *response = [ServiceHelper sendTextNotificationPhoneDestination:@"17077877855" Message:message CustomerNickname:@"VALET" Username:@"valetplease" Password:@"vp0209"];
                    
                    NSLog(@"response=%@",response);
                    
                }
            }
        }
    }
    
    userRollId = [[[self.appDelegate selectedEntities]user] userRollId];
    
    if (userRollId!=nil)
    {
        if([ST_User_Role_Customer_Care isEqualToString:userRollId]) // customer service
        {
            if ([tech.userName isEqualToString:@"No Tech/Blank"])
            {
                NSMutableArray *listOfTechs = [ServiceHelper getUsers];
                
                for (int loop = 0; loop < [listOfTechs count]; loop ++)
                {
                    Tech *tech = [listOfTechs objectAtIndex:loop];
                    
                    NSString *userRollid=[ServiceHelper getUserRollid:[tech userId]];
                    
                    if (userRollid!=nil)
                    {
                        if ([ST_User_Role_TECH isEqualToString:userRollid] || [ST_User_Role_TECH_SUPER isEqualToString:userRollid])
                        {
                            // Assigned to tech... send notification  // point 2
                            
                            NSMutableString *message = [[NSMutableString alloc] initWithString:@""];
                            [message appendString:@"Location:"];
                            [message appendFormat:@"%@",[[appDelegate selectedEntities] location].locationName];
                            [message appendString:@",Contact:"];
                            [message appendFormat:@"%@",[[appDelegate selectedEntities] contact].contactName];
                            [message appendString:@",CallbackNum:"];
                            [message appendFormat:@"%@",[[appDelegate selectedEntities] contact].callBackNum];
                            [message appendString:@",Problem Description:"];
                            [message appendFormat:@"%@",addProblemOrSolutionTextView.text];
                            
                            NSLog(@"message = %@",message);
                            
                            NSString *response = [ServiceHelper sendTextNotificationPhoneDestination:@"17077877855" Message:message CustomerNickname:@"VALET" Username:@"valetplease" Password:@"vp0209"];
                            
                            NSLog(@"response=%@",response);
                            
                        }
                    }
                    
                }
                
            }
        }
    }    

    [self saveTicketwithCatandTechId];
    
    problemViewIsDoubleClicked = YES;
    
    if (problemViewIsDoubleClicked) 
    {
        [self addingProblem];
        problemViewIsDoubleClicked=NO;
    }
    else {
        [self addingSolution];
        solutionViewIsDoubleClicked=NO;
    }
}

-(void)saveByExistingLocAndCat
{
    [self saveTicketwithCatandTechId];
    
    problemViewIsDoubleClicked = YES;
    
    if (problemViewIsDoubleClicked) 
    {
        [self addingProblem];
        problemViewIsDoubleClicked=NO;
    }
    else {
        [self addingSolution];
        solutionViewIsDoubleClicked=NO;
    }
}

-(void)saveTicketwithCatandTechId
{
    
    if (([ServicePleaseValidation validateNotEmpty:[self.appDelegate.curprobSoluVC.addProblemOrSolutionTextView text]]))
        
    {
        Ticket *ticketObj = [self createTicketInstance];
        
        ticketObj = [self saveTicket:ticketObj];
        
        self.currentCreationOfTicketOBJ = ticketObj;
        
        if (ticketObj) 
        {
            saveTicketAlert = [[UIAlertView alloc] initWithTitle:@"Ticket Saved" 
                                                         message:@"The Ticket entry was saved successfully" 
                                                        delegate:self 
                                               cancelButtonTitle:@"Ok" 
                                               otherButtonTitles:nil];
            
            [saveTicketAlert show];
            
            [self generateAndSendEmailtoContact:self.currentCreationOfTicketOBJ];
        }
        else
        {
            saveTicketAlert = [[UIAlertView alloc] initWithTitle:@"Problem Saving Ticket" 
                                                         message:@"The Ticket entry was not saved successfully" 
                                                        delegate:self 
                                               cancelButtonTitle:@"Ok" 
                                               otherButtonTitles:nil];
            
            [saveTicketAlert show];
            
            return;
        }
        
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"TicketInfo Empty" 
                                                            message:@"The TicketInfo should not be empty" 
                                                           delegate:self 
                                                  cancelButtonTitle:@"Ok" 
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (Ticket *) createTicketInstance
{
	ticket = nil;
	
	@try 
	{
		if (ticket == nil) 
		{
			ticket = [[Ticket alloc] init];
		}
       // BOOL IsHelpDoc = false;
        
        [ticket setTicketId:[NSString stringWithUUID]];		
		[ticket setContactId:[[[[self appDelegate] selectedEntities] contact] contactId]];
		[ticket setLocationId:[[[[self appDelegate] selectedEntities] location] locationId]];
		[ticket setOrganizationId:[[[[self appDelegate] selectedEntities] organization] organizationId]];
		[ticket setTicketName:[self.appDelegate.curprobSoluVC.addProblemOrSolutionTextView text]];
        [ticket setTicketStatus:@"L"];
		[ticket setOpenClose:[NSNumber numberWithBool:NO]];
		[ticket setCloseDate:nil];
        [ticket setTicketServicePlan:@"None"];
        [ticket setIsHelpDoc:[NSString stringWithFormat:@"%d",[self.helpDocSwitch isOn]]];

        if (appDelegate.newTicketCreationProcess)
        {
            if (!appDelegate.ifticketRowselectedAndnewBtnPressed) 
            {
                [ticket setUserId:userID];
                [ticket setTech:techName];
                [ticket setCategoryId:categoryId];
            }
            else 
            { 
                [ticket setUserId:[[[self appDelegate] selectedEntities] ticketMonitor].ticketUserId];
                [ticket setTech:[[[self appDelegate] selectedEntities] ticketMonitor].ticketTech];
                [ticket setCategoryId:[[[self appDelegate] selectedEntities] ticketMonitor].ticketCategoryId];
            }
        }
        
		[ticket setCreateDate:[NSDate date]];
		[ticket setEditDate:[NSDate date]];
        
   	}
	@catch (NSException *exception) 
	{
		NSLog(@"Error in createTicketInstance.  Error: %@", [exception description]);
	}
	@finally 
	{    		
		return ticket;
	}	
}

- (BOOL) doesTicketExist:(Ticket *) ticket
{
	BOOL ticketExists = NO;
	
	@try 
	{
		// ticketExists = [ServiceHelper doesTicketExist:[ticket ticketName]]; 
	}
	@catch (NSException *exception) 
	{
		NSLog(@"Error in doesTicketExist.  Error: %@", [exception description]);
		
		ticketExists = NO;
	}
	@finally 
	{
		return ticketExists;
	}
}

- (Ticket *) saveTicket:(Ticket *) ticketObj
{
	BOOL wasSuccessful = NO;
    
    Ticket *newTicket;
	
	@try 
	{
		if ([self doesTicketExist:ticketObj] == YES) 
		{
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ticket Exists" 
																message:@"The Ticket entry already exists" 
															   delegate:self 
													  cancelButtonTitle:@"Ok" 
													  otherButtonTitles:nil];
			
			[alertView show];
			
			return nil;
		}
		
		newTicket = [ServiceHelper addTicket:ticketObj];
		
		if (newTicket != nil) 
		{
			wasSuccessful = YES;
		}
		else 
		{
			wasSuccessful = NO;
		}
	}
	@catch (NSException *exception) 
	{
		NSLog(@"Error in saveTicket.  Error: %@", [exception description]);
	}
	@finally 
	{    		
		return newTicket;
	}
}

-(BOOL)generateAndSendEmailtoContact:(Ticket *)ticketObj
{
    
    NSMutableString *subjectText = [[NSMutableString alloc]init];
    
    NSMutableString *bodyText = [[NSMutableString alloc]init];
    
    if ([ticketObj.ticketNumber length] >0) {
        
        Contact *curContact = [ServiceHelper getContact:ticketObj.contactId];
        
        [subjectText setString:[NSString stringWithFormat:@"STS - ServiceTech - Support ticket #%@",ticketObj.ticketNumber]];
        
        NSString *htmlstring = [[NSString alloc]initWithFormat:@"<html><body>Dear %@,<br><br>&nbsp;Thank you for contacting our support department. We have opened a ticket with the reference #%@ and will be in touch shortly to resolve it for you.</body></html>",curContact.contactName,ticketObj.ticketNumber];
        
        [bodyText setString:htmlstring];
        
        BOOL adminAlertSuccess = NO;
        
        @try 
        {
            /// Do code to send POST request.
            
            NSString *jsonString = [TicketEmailNotification JsonContentofEmailWithIndent:NO toAddress:curContact.email withBodyContent:bodyText SubjectContent:subjectText];
            
            
            adminAlertSuccess = [ServiceHelper sendTicketNotificationEmail:jsonString];
            
            NSLog(@"DO CODE TO SEND THE POST REQUEST");
        }
        @catch (NSException *exception) 
        {
            NSLog(@"Error in doesLocationInfoExist.  Error: %@", [exception description]);
            
            adminAlertSuccess = NO;
        }
        @finally 
        {
            return adminAlertSuccess;
        }
        
    }else {
        
        return NO;
    }
}

-(void)getSolutionListfromKD {

    
}

-(void)customizeNewFrameFor_SolView_Ipad:(CGRect)x1 Iphone_frame:(CGRect)x2  ProbView_Ipad:(CGRect)y1 Iphone_frame:(CGRect)y2 addProbOrSolView_Ipad:(CGRect)z1 Iphone_frame:(CGRect)z2 bottomToolBarView_Ipad:(CGRect)a1 Iphone_frame:(CGRect)a2 {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if (iPad) {
        
        solutionView.frame = x1;
        problemView.frame  = y1;
        addProblemOrSolutionView.frame=z1;    
        bottomToolBarView.frame=a1;
        
    } else {
        
        solutionView.frame = x2;
        problemView.frame = y2;
        addProblemOrSolutionView.frame=z2;
        bottomToolBarView.frame=a2;
    }
    
    [UIView commitAnimations];  
}
-(void)replacingBottomToolBarViewItems_MeansHide_KD_ProSol_AND_TM_Btns:(BOOL)Hide_KD_ProSol_AND_TM_Btns {
    
    if (Hide_KD_ProSol_AND_TM_Btns) {
        
        saveBtn.hidden    = NO;
        cancelBtn.hidden  = NO;
        imageBtn.hidden   = NO;
        audioBtn.hidden   = NO;
        TM_Btn.hidden     = YES;
        KD_Btn.hidden     = YES;
        proSoluBtn.hidden = YES;  
        
    }else {
        
        saveBtn.hidden    = YES;
        cancelBtn.hidden  = YES;
        imageBtn.hidden   = YES;
        audioBtn.hidden   = YES;
        TM_Btn.hidden     = NO;
        KD_Btn.hidden     = NO;
        proSoluBtn.hidden = NO;
    }
}

-(void)managingAudioRecordingMode {
    
    if (self.popoverController)  {
        
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
        currentPopoverCellIndex = -1;
    }
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.wav",totalRecords]]; 
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:fullPath] == YES) {
            
            [fileManager removeItemAtPath:fullPath error:NULL];
        }
        
        if (isAudoPlaying || [player isPlaying] || playerPaused) {
            
            if(playTime!=nil) {
               
                [playTime invalidate];
                playTime=nil;
                appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
                appDelegate.curAddprobVC.playingprogress.progress =0.0;
            }
            playerPaused=NO;
            isAudoPlaying=NO;
            [player stop];
        }
        if ([audioRecorder isRecording]) {
            
            [audioRecorder stop];
            [audioBtn setImage:[UIImage imageNamed:@"mike.png"] forState:UIControlStateNormal];
            audioTimer.text=@"";
            
            if (recordTime!=nil) {
                [recordTime invalidate];
                recordTime=nil;
                appDelegate.curAddprobVC.audioTimer.text=@"";
            }
        }   
}

-(void)presentCustomizePopOverWithSize_Ipad:(CGSize *)IpadSize Iphone:(CGSize *)IphoneSize textViewText:(NSString *)text textViewTittle:(NSString *)tittleString {
   
    transparentView.hidden=NO;
   
    addProblemVC = (AddProblemViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"AddProblemViewController"];
    
    for (id obj in [addProblemVC.view subviews]) {

        if ([obj tag] == 1) {
            
            [(UITextView *)obj setText:text];
        }
    }
    addProblemVC.textViewTittle.text=tittleString;
   
    self.popoverController = [[popoverClass alloc] initWithContentViewController:addProblemVC] ;
    
    if ([self.popoverController respondsToSelector:@selector(setContainerViewProperties:)]) {
        
        [self.popoverController setContainerViewProperties:[self improvedContainerViewProperties]];
    }

    self.popoverController.delegate = self;
    self.popoverController.passthroughViews = [NSArray arrayWithObject:self.view];
   
    if (iPad) {
       
        [self.popoverController presentPopoverFromRect:CGRectMake(370,370,0, 0) 
                                                inView:self.view
                              permittedArrowDirections:UIPopoverArrowDirectionUp
                                              animated:YES size:IpadSize];
    }else {
       
        [self.popoverController presentPopoverFromRect:CGRectMake(157,117,0, 0) 
                                                inView:self.view
                              permittedArrowDirections:UIPopoverArrowDirectionUp
                                              animated:YES size:IphoneSize];
    }
}
 
-(void)presentCustomize_KD_PopOverVC_WithSize_Ipad:(CGSize *)IpadSize Iphone:(CGSize *)IphoneSize{
    
    transparentView.hidden=NO;
   
    custom_KD_PopOverVC = (custom_KD_PopOverViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"custom_KD_PopOverViewController"];
    
    self.popoverController = [[popoverClass alloc] initWithContentViewController:custom_KD_PopOverVC] ;
    
    if ([self.popoverController respondsToSelector:@selector(setContainerViewProperties:)]) {
        
        [self.popoverController setContainerViewProperties:[self improvedContainerViewProperties]];
    }
    
    self.popoverController.delegate = self;
    self.popoverController.passthroughViews = [NSArray arrayWithObject:self.view];
    
    if (iPad) {
        
        [self.popoverController presentPopoverFromRect:CGRectMake(380,240,0,0) 
                                                inView:self.view
                              permittedArrowDirections:UIPopoverArrowDirectionUp
                                              animated:YES size:IpadSize];
    }else {
        
        [self.popoverController presentPopoverFromRect:CGRectMake(125,55,0,0) 
                                                inView:self.view
                              permittedArrowDirections:UIPopoverArrowDirectionUp
                                              animated:YES size:IphoneSize];
    }
}

-(void)KD_PopOverCancelBtnPressed {
    
    transparentView.hidden = YES;
   
    if (self.popoverController) {
        
        [self.popoverController dismissPopoverAnimated:YES];
    }
}
-(void)KD_PopOverCancelBtnPressedWith_location:(NSString *)location category:(NSString *)category describtion:(NSString *)describtion KDsolutionList:(NSMutableArray *)KDsolutionList{
   
    KDListViewController *kdlistViewController=(KDListViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"KDListViewController"];
    
    
    [self presentModalViewController:kdlistViewController animated:YES];
    [kdlistViewController KD_location:location KD_category:category KD_description:describtion KDsolutionList:(NSMutableArray *)KDsolutionList];
}

@end
