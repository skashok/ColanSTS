//
//  TicketMonitorViewCell.m
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 12/06/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "TicketMonitorViewCell.h"

@implementation TicketMonitorViewCell


@synthesize locationLbl = _locationLbl;
@synthesize contactLbl = _contactLbl;
@synthesize timeElapsedLbl = _timeElapsedLbl;
@synthesize ticketNumberLbl = _ticketNumberLbl;
@synthesize descriptionLbl = _descriptionLbl;
@synthesize categoryLbl = _categoryLbl;
@synthesize servicePlanLbl= _servicePlanLbl;
@synthesize techAssignedLbl = _techAssignedLbl;
@synthesize statusLbl = _statusLbl;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
    [self setBackgroundColor:[UIColor colorWithRed:(121.0/255.0) green:(121.0/255.0) blue:(121.0/255.0) alpha:1.0]];

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
