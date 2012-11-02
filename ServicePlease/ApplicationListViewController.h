//
//  CategoryViewController.h
//  ServicePlease
//
//  Created by Ed Elliott on 2/8/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

#import "NSString+StringWithUUID.h"
#import "ServiceHelper.h"
#import "Utility.h"
#import "Category.h"
#import "LocationListingViewController.h"
#import "TicketListingViewController.h"
#import "ApplicationType.h"
#import "SettingsManipulationViewController.h"

@interface ApplicationListViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource,ApplicationTypeDelegate>

@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) IBOutlet UIPickerView *categoryPickerView;

- (IBAction) recordVoiceEntry: (id) sender;
-(IBAction)applicationTypeView:(id)sender;

@end
