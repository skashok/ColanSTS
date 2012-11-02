//
//  SnoozeCustomCell.m
//  ServiceTech
//
//  Created by karthik keyan on 28/09/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "SnoozeCustomCell.h"

@implementation SnoozeCustomCell

@synthesize time,date,snoozeReason,expiryDate,De_SelectImage;

@synthesize techName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
