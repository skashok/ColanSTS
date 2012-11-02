//
//  InfoSettingsVC.h
//  LexisNexisLawSchool
//
//  Created by Administator on 05/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoSettingsVC : UIViewController {

	UIViewController *parent_view;
	
	IBOutlet UIView *settingsView;
	IBOutlet UIView *infoView;
	
	// Buttons
	
	IBOutlet UIButton *infoHelpBtn,*infoAboutUsBtn;
	IBOutlet UIButton *settingsPreferenceBtn,*settingsManageAccountBtn,*settingsLogoutBtn;
	
}

@property (nonatomic, retain) UIViewController *parent_view;
@property (nonatomic, retain) IBOutlet UIView *settingsView;
@property (nonatomic, retain) IBOutlet UIView *infoView;

-(void)doneClicked;

// Settings Action

-(IBAction)infoHelpBtnAction;
-(IBAction)infoAboutUsBtnAction;
-(IBAction)infoUserStatBtnAction;

-(IBAction)settingsPreferenceBtnAction;
-(IBAction)settingsManageAccountBtnAction;
-(IBAction)settingsLogoutBtnAction;

@end
