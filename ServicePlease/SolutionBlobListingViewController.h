//
//  FlipsideViewController.h
//  TestServiceTech
//
//  Created by Ed Elliott on 8/3/12.
//  Copyright (c) 2012 Ed Elliott. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomTableViewCell.h"
#import "ServiceHelper.h"
#import "AppDelegate.h"
#import "BlobEntity.h"
#import "SolutionBlobPacket.h"
#import "ProblemBlobPacket.h"

@class AppDelegate;

@class ServiceUtility;
@class SolutionBlobListingViewController;


@interface SolutionBlobListingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *solutionBlobs;

- (IBAction)done:(id)sender;

@end
