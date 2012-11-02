//
//  SnoozeReasonListViewController.h
//  ServiceTech
//
//  Created by colan on 15/10/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ServicePleaseValidation.h"
#import "DropDownView.h"
#import "ServiceHelper.h"
#import "DailyRecapListCell.h"

@protocol ApplicationTypeDelegate <NSObject>
@required
-(void)applicationTypeFinished;
@end

@interface SettingsManipulationViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate,DailyRecapDelegate>
{
    int locationSelectBtnToggle;
    int timeZoneSelectBtnToggle;

    AppDelegate *appDelegate;
    DropDownView *dropwDownCustomTableView;
  
    NSMutableArray *lists;
    
    NSMutableArray *objectLists;
    
    NSMutableArray *selectedValueIndexPath;

    NSMutableArray *locationOBJS;
    
    NSMutableArray *locationNames;
    
    NSMutableArray *selectedIndexes;
    
    NSMutableArray *timeZones;
    
    NSMutableArray *dailyRecapOBJS;

    IBOutlet UIView *addNewView;
    
    IBOutlet UIView *BgView;

    IBOutlet UITextField *addNewTextField;

    IBOutlet UIButton *addNewButton;

    IBOutlet UIButton *addUpdateButton;
    
    IBOutlet UITextField *generateRecapTextField;

    IBOutlet UITextField *startTimeTextField;

    IBOutlet UITextField *endTimeTextField;

    IBOutlet UITextField *recapEmailTextField;

    IBOutlet UIView *generateRecapView;
    
    IBOutlet UIButton *recapSaveButton;
    
    IBOutlet UIButton *recapCancelButton;

    UIDatePicker *datePicker;
    
    UIView *datePickerView;

    IBOutlet UIButton *addNew;
    
    IBOutlet UIButton *deleteexist;
    
    IBOutlet UIButton *update;
    
    IBOutlet UIButton *selectAll;
    
    id<ApplicationTypeDelegate> delegate;
 
    IBOutlet UITextField *dialyRecapName_TextField;
    
    IBOutlet UIButton *mondayBtn;
    
    IBOutlet UIButton *tuesdayBtn;
    
    IBOutlet UIButton *wednesdayBtn;
    
    IBOutlet UIButton *thursday;
    
    IBOutlet UIButton *friday;
    
    IBOutlet UIButton *locationSelectBtn;
    
    IBOutlet UIScrollView *dailyRecapScrollView;
    
    IBOutlet UIButton *timeZoneSelectBtn;
    
    UIStoryboard *mainStoryboard;
    
    BOOL iPad ;
}

@property (nonatomic ,retain) DropDownView *dropwDownCustomTableView;

@property (nonatomic,retain)  AppDelegate *appDelegate;

@property (nonatomic,strong) IBOutlet UITableView *listtableView;

@property (nonatomic,strong) IBOutlet UIView *addNewView;

@property (nonatomic,strong) IBOutlet UIView *BgView;

@property (nonatomic,strong) IBOutlet UITextField *addNewTextField;

@property (nonatomic,strong) IBOutlet UIButton *addNewButton;

@property (nonatomic,strong) IBOutlet UIButton *addUpdateButton;

@property (nonatomic,strong) IBOutlet UITextField *generateRecapTextField;

@property (nonatomic,strong) IBOutlet UITextField *startTimeTextField;

@property (nonatomic,strong) IBOutlet UITextField *endTimeTextField;

@property (nonatomic,strong) IBOutlet UITextField *recapEmailTextField;

@property (nonatomic,strong) IBOutlet UIView *generateRecapView;

@property (nonatomic,strong) IBOutlet UIButton *recapSaveButton;

@property (nonatomic,strong) IBOutlet UIButton *recapCancelButton;

@property (nonatomic,strong) IBOutlet UIButton *addNew;

@property (nonatomic,strong) IBOutlet UIButton *deleteexist;

@property (nonatomic,strong) IBOutlet UIButton *update;

@property (nonatomic,strong) IBOutlet UIButton *selectAll;

@property (strong, nonatomic) IBOutlet UITextField *locationNameTextField;

@property (strong, nonatomic) IBOutlet UITextField *timeZoneTextField;

@property (strong, nonatomic) IBOutlet UITableView *dailyRecapList;


@property (nonatomic,strong) id<ApplicationTypeDelegate> delegate;


-(void)arrayList;

-(IBAction)selectAllButtonWasPressed:(id)sender;

-(IBAction)addNewButtonWasPressed:(id)sender;

-(IBAction)updateButtonWasPressed:(id)sender;

-(IBAction)addNewPopUpButtonWasPressed:(id)sender;

-(IBAction)updatePopUpButtonWasPressed:(id)sender;

-(IBAction)recapSaveButtonWasPressed:(id)sender;

-(IBAction)recapCancelButtonWasPressed:(id)sender;

-(void)alertMessage:(NSString *)message;

-(IBAction)daysBtnPressed:(UIButton *)sender;

-(IBAction)actvationBtnPressed:(id)sender;

- (IBAction)locationSelectBtnPressed:(id)sender;

- (IBAction)timezoneSelectBtnPressed:(id)sender;

@end
