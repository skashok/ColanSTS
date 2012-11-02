//
//  SnoozeListViewController.h
//  ServiceTech
//
//  Created by karthik keyan on 28/09/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnoozeCustomCell.h"
#import "UpdateSnoozeViewController.h"
#import "AppDelegate.h"

#define kCellImageViewTag		1000

@interface SnoozeListsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UpdateSnoozeResponseDelegate>
{
    UIPopoverController *popoverController;
    
    UpdateSnoozeViewController *updateSnoozeView;
    
    NSMutableArray *soonzeList;
    NSMutableArray *soonzeReasonList;
    NSMutableDictionary *SnoozeReasonsDictionary;
    UIImage *selectedImage;
	UIImage *unselectedImage;
    BOOL inPseudoEditMode;
    NSMutableArray *selectedArray;
    NSMutableArray *listOfManipulation;
    
    IBOutlet UITableView *soonzeListTableView;
    
    IBOutlet UITableView *manipulationTableView;
    
    NSMutableArray *selectedManipulationIndexPath;
    
    NSMutableArray *selectedSnoozeIndexPath;
    
    UIBarButtonItem *editButton;
    
    IBOutlet UIView *loadingView;
    
    AppDelegate *appDelegate;
}
@property (strong, nonatomic) IBOutlet UITableView *soonzeListTableView;

@property (strong, nonatomic) IBOutlet UIView *loadingView;

@property (strong, nonatomic) IBOutlet UITableView *manipulationTableView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIImage *unselectedImage;
@property (nonatomic, retain) NSMutableArray *selectedArray;

@property BOOL inPseudoEditMode;



- (void)populateSelectedArray;
- (IBAction)doneBtnPressed:(id)sender;
-(IBAction)doDelete;


@end
