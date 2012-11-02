//
//  TicketListingViewCell.m
//  ServicePlease
//
//  Created by Edward Elliott on 2/15/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "TicketListingViewCell.h"

@implementation TicketListingViewCell

@synthesize categoryLbl = _categoryLbl;
@synthesize dateTimeLbl = _dateTimeLbl;
@synthesize openCloseLbl = _openCloseLbl;
@synthesize techLbl = _techLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
	if (self) 
	{
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
