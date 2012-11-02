//
//  TicketMonitorViewController.h
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 12/06/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FilterPopupView.h"
#import "ServiceTechConstants.h"
#import "WEPopoverController.h"
#import "custom_KD_PopOverViewController.h"
#import "DropDownView.h"
#import "UserSettingsViewController.h"
#import "SnoozeListsViewController.h"

@class custom_KD_PopOverViewController;

@class WEPopoverController;

@interface TicketMonitorViewController : UIViewController <TMFilterResponseDelegate,TechResponseDelegate,WEPopoverControllerDelegate,UIGestureRecognizerDelegate,snoozeDelegate,UITextFieldDelegate>
{
    WEPopoverController      *custom_KD_popoverView;
    custom_KD_PopOverViewController *custom_KD_PopOverVC;
    NSInteger currentPopoverCellIndex;
	Class popoverClass;
   
    int tapCount;
    NSIndexPath *tableSelection;

    UIPopoverController *popoverController;

    NSMutableArray *filteredTicketMonitorList;
    
    NSMutableArray *allLocationList;
    
    IBOutlet UIButton *locationFilterBtn,*contactFilterBtn,*timeElapsedFilterBtn;
    
    IBOutlet UIButton *categoryFilterBtn,*techFilterBtn,*statusFilterBrn,*servicePlanFilterBtn;
    
    IBOutlet UIButton *ticketNumberFilterBtn;
    
    IBOutlet UIScrollView *moniterScrollView;
   
    __weak IBOutlet UIControl *transparentView;
    
    //IBOutlet UIBarButtonItem *showAll;
 
    FilterPopupView *filterPopupView;
    
    NSMutableArray *currentListofTMRows;

    BOOL locationToggle,contactToggle,sinceToggle,ticketToggle,categorynToggle,techToggle,statusToggle,serviceplanToggle;
    
    TicketMonitorSortingElement currentSortingElement;
    
    NSMutableArray *nestedFilteredTMList;

    UIView *view;
    
    Tech *tech;
    
    NSString *userRollid;
    
    UIAlertView *alert;
    
    BOOL alertShowing;
    
    BOOL iPad;
    
    UIStoryboard *mainStoryboard;

    DropDownView *_dropwDownCustomTableView;
    
    NSMutableArray *reasonListarray;
    
    UIButton *reasonListButton;
        
    UIButton *DICheckBox;
    
    BOOL isCheckedDate;
    
    UILabel *startDate , *endDate , *startTime, *endTime;
    
    UITextField *startTextFieldRounded , *endTextFieldRounded ,  *startTimeTextField, *endTimeTextField;
    
    UIButton *QSCheckBox;
    
    BOOL isCheckedQuickShare;
    
    UIView *snoozeOptionView;
    
    UILabel *hours , *minutes;
    
    UITextField *hoursTextField , *minuteTextField;
    
    UIButton *refButton;
    
    UIDatePicker *datePicker;
    
    UIView *datePickerView;
    
    UIView *snoozeTransparentView;
    
    UIView *snoozeContainerView;
    
    UIView *snoozeNewOptionView;
    
    UserSettingsViewController *UserSettingsVC;
    
    BOOL filtering;
    
    int lastIndexPath;
    
    UILabel *snoozeInterval;

    BOOL snoozeCompleted;
    
    UIActivityIndicatorView *activityIndicator;

    UIView *loadingView;
    
    NSDate *selectedStartDate, *selectedEndDate;

    NSDate *selectedStartTime, *selectedEndTime;

    NSMutableArray *listOfSnoozeReasons;

    UIBarButtonItem *rightBtnItem;

    NSMutableArray *soonzeList;

}

-(void)parseTheTicketMonitorResult;

- (IBAction)actionButtonWasPressed:(id)sender;
- (IBAction)problemSolutionButtonWasPressed:(id)sender;
- (IBAction)filterButtonWasPressed:(id)sender;

- (IBAction)LocationButtonFiltered:(id)sender;
- (IBAction)ContactButtonFiltered:(id)sender;
- (IBAction)TimeElapsedButtonFiltered:(id)sender;
- (IBAction)CategoryButtonFiltered:(id)sender;
- (IBAction)TechButtonFiltered:(id)sender;
- (IBAction)StatusButtonFiltered:(id)sender;
- (IBAction)ServicePlanButtonFiltered:(id)sender;
- (IBAction)showAll:(id)sender;
- (IBAction)KD_BtnPressed:(id)sender;

- (IBAction)locationSorting:(id)sender;
- (IBAction)contactSorting:(id)sender;
- (IBAction)sinceSorting:(id)sender;
- (IBAction)ticketSorting:(id)sender;
- (IBAction)categorySorting:(id)sender;
- (IBAction)techSorting:(id)sender;
- (IBAction)statusSorting:(id)sender;
- (IBAction)serviceplanSorting:(id)sender;

- (IBAction)infoAction:(id)sender;
- (IBAction)settingsAction:(id)sender;


NSComparisonResult customIntegerCompare(NSArray* first, NSArray* second, void* context);
NSComparisonResult customCompareFunction(NSArray* first, NSArray* second, void* context);

// Sorting Locations
-(IBAction)locationSorting:(id)sender;
-(UIView *)animationDidStart;

-(void)dismissPopover;

-(NSMutableArray *)sortingArray:(NSMutableArray *)unsoretedArray;

- (void)presentCustomize_KD_PopOverVC_WithSize_Ipad:(CGSize *)IpadSize Iphone:(CGSize *)IphoneSize;

- (void)KD_PopOverCancelBtnPressed;

- (void)KD_PopOverCancelBtnPressedWith_location:(NSString *)location category:(NSString *)category describtion:(NSString *)describtion KDsolutionList:(NSMutableArray *)KDsolutionList;

- (void)popOverTextViewIsEditng ;

- (void)popOverTextViewIsendEditing;

@property (nonatomic, retain) WEPopoverController *custom_KD_popoverView;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, assign) BOOL searching;

@property (nonatomic, assign) BOOL letUserSelectRow;

@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) IBOutlet UITableView *monitorTableView;

@property (strong, nonatomic) IBOutlet UIView *actionPopView;

@property (strong, nonatomic) NSMutableArray *allTicketsMonitorList;

@property (strong, nonatomic) NSMutableArray *filteredTicketMonitorList;

@property (strong, nonatomic) NSMutableArray *filteredTicketList;

@property (strong, nonatomic) NSMutableArray *currentListofTMRows;

@property (strong, nonatomic) IBOutlet UIScrollView *moniterScrollView;

@property (strong, nonatomic) NSMutableArray *allLocationList;

@property (nonatomic,assign)TicketMonitorSortingElement currentSortingElement;

@property (strong, nonatomic) NSMutableArray *nestedFilteredTMList;

@property (nonatomic,assign) BOOL isCheckedDate;

@property (nonatomic,assign) BOOL isCheckedQuickShare;

@property(nonatomic,retain) UIDatePicker *datePicker;

@property (nonatomic, assign) BOOL filtering;


-(IBAction) checkBoxClicked;
-(IBAction) QScheckBoxClicked;

- (IBAction)actionReasonListButtonWasPressed:(id)sender;
- (IBAction)actionSnoozeListButtonWasPressed:(id)sender;

- (void)LabelChange:(id)sender;
- (void)done:(id)sender;
- (IBAction)transparentViewTouched:(id)sender;

@end
