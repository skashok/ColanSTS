//
//  TechPerformaceViewController.h
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 22/05/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TechMetrics.h"

@interface TechPerfomanceViewController : UIViewController
{
    IBOutlet UITableView *techPerformaceTblView;
    
    NSMutableArray *avgTimeCloseTechPerfomId;
    NSMutableArray *TotalOpenTicketAvailabeArray;
    NSMutableArray *TotalCloseTicketArray;
    NSMutableArray *techNameArray;
    NSMutableArray *avgResponseTimeArray;
    NSMutableArray *techMetricsOBJ;
    NSArray *techMetricsSortedOBJS;
    
    UIActivityIndicatorView *activityIndicator;
    UIView *loadingView;
    TechMetrics *techMetrics;
    BOOL iPad;
    UIStoryboard *mainStoryboard;
    BOOL  ascendingSortting_Tech,ascendingSortting_TTO,ascendingSortting_TTC,ascendingSortting_ATO,ascendingSortting_ART,ascendingSortting_FB;
    
}

@property (nonatomic ,retain) AppDelegate *appDelegate;

-(IBAction)singleTabSorting:(UIButton *)sender;

@end
