    //
//  InfoSettingsVC.m
//  LexisNexisLawSchool
//
//  Created by Administator on 05/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InfoSettingsVC.h"
#import "LexisNexisLawSchoolAppDelegate.h"
#import "USerStatisticsVC.h"
#import "CustomInformationVC.h"
#import "LexisNexisLawSchoolViewController.h"

@implementation InfoSettingsVC


@synthesize parent_view,settingsView,infoView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor clearColor]];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}


// Settings Action

-(IBAction)infoHelpBtnAction
{
	CustomInformationVC *cusInfoVC = [[CustomInformationVC alloc]initWithNibName:@"CustomInformationVC" bundle:nil];
	
	[self.view addSubview:cusInfoVC.view];
	
}
-(IBAction)infoAboutUsBtnAction
{
	CustomInformationVC *cusInfoVC = [[CustomInformationVC alloc]initWithNibName:@"CustomInformationVC" bundle:nil];
	
	[self.view addSubview:cusInfoVC.view];
	
}
-(IBAction)settingsPreferenceBtnAction
{
	CustomInformationVC *cusInfoVC = [[CustomInformationVC alloc]initWithNibName:@"CustomInformationVC" bundle:nil];
	
	[self.view addSubview:cusInfoVC.view];
	
}
-(IBAction)settingsManageAccountBtnAction
{
	CustomInformationVC *cusInfoVC = [[CustomInformationVC alloc]initWithNibName:@"CustomInformationVC" bundle:nil];
	
	[self.view addSubview:cusInfoVC.view];
	
}
-(IBAction)settingsLogoutBtnAction
{
	LexisNexisLawSchoolViewController *loginView = [[LexisNexisLawSchoolViewController alloc] initWithNibName:@"LexisNexisLawSchoolViewController" bundle:nil];
	[self.parent_view.navigationController pushViewController:loginView animated:NO];
	
}

-(IBAction)infoUserStatBtnAction
{
	USerStatisticsVC *userSatVC = [[USerStatisticsVC alloc]initWithNibName:@"USerStatisticsVC" bundle:nil];
	
	
	UINavigationController *navController = [[UINavigationController alloc]
											 
											 initWithRootViewController:userSatVC];
	
	// show the navigation controller modally
	
	[navController.navigationBar setHidden:YES];
	
	UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
	
	navController.navigationItem.rightBarButtonItem = doneButton;
	
	[navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	
	navController.modalPresentationStyle = UIModalPresentationFormSheet;
	
	[self.view removeFromSuperview];
	
	[self.parent_view presentModalViewController:navController animated:YES];
	
}

-(void)doneClicked
{
		 
	[self.parent_view dismissModalViewControllerAnimated:YES];
 
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self.view];

	if (CGRectContainsPoint(CGRectMake(425.0,41.0,260.0,210), point)) {
		
	}else {

		[self.view removeFromSuperview];
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

- (void)dealloc {
    [super dealloc];
}



@end
