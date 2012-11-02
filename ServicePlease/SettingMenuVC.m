//
//  SettingMenuVC.m
//  ServiceTech
//
//  Created by ASHOKKUMAR on 26/09/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "SettingMenuVC.h"

@interface SettingMenuVC ()

@end

@implementation SettingMenuVC

@synthesize parent_view,settingsView;//,infoView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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


-(IBAction)settingsPreferenceBtnAction
{
    
}
-(IBAction)settingsHelpBtnAction
{
    
}
-(IBAction)settingsLogoutBtnAction
{
    
}
// Settings Action

//-(IBAction)settingsPreferenceBtnAction
//{
//	CustomInformationVC *cusInfoVC = [[CustomInformationVC alloc]initWithNibName:@"CustomInformationVC" bundle:nil];
//	
//	[self.view addSubview:cusInfoVC.view];
//	
//}
//-(IBAction)settingsHelpBtnAction
//{
//	CustomInformationVC *cusInfoVC = [[CustomInformationVC alloc]initWithNibName:@"CustomInformationVC" bundle:nil];
//	
//	[self.view addSubview:cusInfoVC.view];
//	
//}
//-(IBAction)settingsLogoutBtnAction
//{
//	LexisNexisLawSchoolViewController *loginView = [[LexisNexisLawSchoolViewController alloc] initWithNibName:@"LexisNexisLawSchoolViewController" bundle:nil];
//	[self.parent_view.navigationController pushViewController:loginView animated:NO];
//	
//}


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


@end
