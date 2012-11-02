//
//  SettingMenuVC.h
//  ServiceTech
//
//  Created by ASHOKKUMAR on 26/09/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingMenuVC : UIViewController
{ 
	UIViewController *parent_view;
	
	IBOutlet UIView *settingsView;
	
	// Buttons
	
	IBOutlet UIButton *settingsPreferenceBtn,*settingsManageAccountBtn,*settingsLogoutBtn;
	
}

@property (nonatomic, retain) UIViewController *parent_view;
@property (nonatomic, retain) IBOutlet UIView *settingsView;

-(void)doneClicked;

// Settings Action

-(IBAction)settingsPreferenceBtnAction;
-(IBAction)settingsHelpBtnAction;
-(IBAction)settingsLogoutBtnAction;

@end
