//
//  UpdateSnoozeViewController.h
//  ServiceTech
//
//  Created by colan on 22/10/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Snooze.h"

@protocol UpdateSnoozeResponseDelegate <NSObject>
@required
-(void)UpdateSnoozeServiceFinished;
@end

@interface UpdateSnoozeViewController : UIViewController
{
    UIPopoverController *rootPopUpViewController;

    id <UpdateSnoozeResponseDelegate> delegate;
    
    IBOutlet UITableView *snoozeReasonTableView;
    
    IBOutlet UIView *snoozeView;
    
    IBOutlet UIScrollView *snoozeScrollView;
    
    NSMutableArray *selectedSnoozeIndexPath;

    IBOutlet UITableView *snoozeReasonListTableView;

    IBOutlet UIView *snoozeReasonListView;
    
    NSMutableArray *selectedSnoozeReasonIndexPath;

    NSMutableArray *listOfSnoozeReasons;

    NSMutableArray *reasonListarray;
    
    NSString *reasonValue;

    IBOutlet UITableView *snoozeDateTimeTableView;
    
    NSMutableArray *selectedSnoozeDateTimeIndexPath;

    UIDatePicker *datePicker;
    
    UIView *datePickerView;
    
    NSString *dateValue;

    NSString *timeValue;

    IBOutlet UITableView *snoozeIntervalTableView;
    
    NSMutableArray *selectedSnoozeIntervalIndexPath;

    NSString *intervalValue;
    
    NSString *intervalTypeId;

    NSString *intervalTypeValue;
    
    NSMutableArray *intervalTypeName;

    IBOutlet UITableView *snoozIntervalTypeListTableView;

    NSMutableArray *listOfIntervalTypes;
    
    IBOutlet UIView *snoozeIntervalTypeView;
    
    NSMutableArray *selectedIntervalTypeIndexPath;
    
    IBOutlet UIView *snoozeIntervalPopUpBGView;

    IBOutlet UIView *snoozeIntervalPopUpView;

    IBOutlet UITextField *snoozeIntervalTextField;
    
    Snooze *snooze;
    
    NSDate *selectedExpiryDate,*selectedExpiryTime;

    
}

@property(nonatomic,retain) UIPopoverController *rootPopUpViewController;

@property(nonatomic,retain) id <UpdateSnoozeResponseDelegate> delegate;

@property (nonatomic , retain)IBOutlet UITableView *snoozeReasonTableView;

@property (nonatomic , retain)IBOutlet UIView *snoozeView;

@property (nonatomic , retain)IBOutlet UIScrollView *snoozeScrollView;

@property (nonatomic , retain)IBOutlet UITableView *snoozeReasonListTableView;

@property (nonatomic , retain)IBOutlet UITableView *snoozeDateTimeTableView;

@property (nonatomic , retain)IBOutlet UIView *snoozeReasonListBgView;

@property (nonatomic , retain)IBOutlet UIView *snoozeReasonListView;

@property (nonatomic , retain)IBOutlet UITableView *snoozeIntervalTableView;

@property (nonatomic , retain)IBOutlet UITableView *snoozIntervalTypeListTableView;

@property (nonatomic , retain)IBOutlet UIView *snoozeIntervalTypeBgView;

@property (nonatomic , retain)IBOutlet UIView *snoozeIntervalTypeView;

@property (nonatomic , retain)IBOutlet UIView *snoozeIntervalPopUpBGView;

@property (nonatomic , retain)IBOutlet UIView *snoozeIntervalPopUpView;

@property (nonatomic , retain)IBOutlet UITextField *snoozeIntervalTextField;

-(IBAction)okBuutonWasPressed:(id)sender;

-(IBAction)saveButtonWasPressed:(id)sender;

-(IBAction)cancelButtonWasPressed:(id)sender;

-(IBAction)closeSnoozeReasonListView:(id)sender;

-(IBAction)closeButtonIntervalTypeListView:(id)sender;

-(IBAction)closeIntervalButtonWasPressed:(id)sender;

-(void)snoozeToUpdate:(Snooze *)snoozeObj reason:(NSString *)reason exprirationDate:(NSString *)date expirationTime:(NSString *)time interval:(NSString *)interval intervalType:(NSString *)intervalType;
@end
