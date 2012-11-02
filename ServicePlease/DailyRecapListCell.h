//
//  DailyRecapListCell.h
//  ServiceTech
//
//  Created by ColanInfotech on 01/11/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyRecapListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *recapName;
@property (strong, nonatomic) IBOutlet UILabel *broadcastTime;
@property (strong, nonatomic) IBOutlet UILabel *broadcastDay;
@property (strong, nonatomic) IBOutlet UILabel *recapLocation;
@property (strong, nonatomic) IBOutlet UILabel *recapTimeZone;
@property (strong, nonatomic) IBOutlet UILabel *recapStarTime;
@property (strong, nonatomic) IBOutlet UILabel *recapEndTime;
@property (strong, nonatomic) IBOutlet UILabel *status;

@end
