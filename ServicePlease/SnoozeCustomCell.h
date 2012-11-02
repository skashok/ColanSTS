//
//  SnoozeCustomCell.h
//  ServiceTech
//
//  Created by karthik keyan on 28/09/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnoozeCustomCell : UITableViewCell

@property (nonatomic,strong) IBOutlet  UILabel *date;
@property (nonatomic,strong) IBOutlet  UILabel *time;
@property (nonatomic,strong) IBOutlet  UILabel *snoozeReason;
@property (nonatomic,strong) IBOutlet  UILabel *expiryDate;
@property (nonatomic,strong) IBOutlet  UIImageView *De_SelectImage;
@property (strong, nonatomic) IBOutlet UILabel *techName;

@end
