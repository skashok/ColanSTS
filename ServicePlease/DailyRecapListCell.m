//
//  DailyRecapListCell.m
//  ServiceTech
//
//  Created by ColanInfotech on 01/11/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "DailyRecapListCell.h"

@implementation DailyRecapListCell

@synthesize recapEndTime,recapStarTime,recapTimeZone,recapName,recapLocation,broadcastDay,broadcastTime,status;

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
