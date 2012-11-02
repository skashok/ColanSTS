//
//  UserSettingsViewController.h
//  ServiceTech
//
//  Created by Apple on 26/09/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownView.h"
#import "Category.h"
#import "SnoozeReason.h"

@interface UserSettingsViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{    
    DropDownView *_dropwDownCustomTableView;

    NSMutableArray *selectedAssignIndexPath;

    NSMutableArray *selectedSnoozeIndexPath;
    
    NSMutableArray *selectedCategoryIndexPath;
    
    NSMutableArray *selectedContactIndexPath;
    
    NSMutableArray *selectedTicketIndexPath;

    NSMutableArray *selectedRecapIndexPath;
    
    NSMutableArray *selectedAppTypeIndexPath;
    
    IBOutlet UITextField *snoozeIntervalTextField;
    
    IBOutlet UIButton *snoozeListButton;

    UIButton *refButton;

    NSMutableArray *listOfIntervalTypes;
    
    NSMutableArray *intervalTypeName;
    
    NSMutableArray *selectedIntervalIndexPath;

    NSMutableArray *selectedIntervalTypeIndexPath;
    
    IBOutlet UIView *snoozeIntervalPopUpView;

    IBOutlet UIView *snoozeIntervalPopUpBGView;
    
    IBOutlet UIView *snoozeIntervalTypeBgView;

    NSString *intervalTypeValue;
    
    NSString *intervalValue;
}
@property (nonatomic,strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) IBOutlet UITableView *assignTableView;

@property (nonatomic,strong) IBOutlet UITableView *snoozeTableView;

@property (nonatomic,strong) IBOutlet UITableView *categoryTableView;

@property (nonatomic,strong) IBOutlet UITableView *dailyRecapTableView;

@property (nonatomic,strong) IBOutlet UITableView *appTypeTableView;

@property (nonatomic,strong) IBOutlet UITableView *snoozeIntervalTableView;

@property (nonatomic,strong) IBOutlet UITableView *snoozeIntervalTypeTableView;

@property (nonatomic , retain)IBOutlet UIView *snoozeIntervalPopUpBGView;

@property (nonatomic , retain)IBOutlet UIView *snoozeIntervalPopUpView;

-(void)doneClicked;

-(void)switchView:(NSIndexPath *)indexPath;

#pragma mark Snooze Interval PopUp

-(void)showIntervalTypeListView;

-(IBAction)closeButtonIntervalTypeListView:(id)sender;

-(void)closeIntervalTypeListView:(NSIndexPath *)indexPath;

-(void)closeIntervalTypeListView:(NSIndexPath *)indexPath;


#pragma mark snoozeIntervalPopUpBGView delegate

-(void)showIntervalPopUpView;

-(IBAction)okBuutonWasPressed:(id)sender;

-(IBAction)closeIntervalButtonWasPressed:(id)sender;

@end
