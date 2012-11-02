//
//  SolutionListingViewCell.m
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 19/06/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "SolutionListingViewCell.h"

@implementation SolutionListingViewCell

@synthesize solutionTitleLbl = _solutionTitleLbl;
@synthesize solutionDescriptionLbl = _solutionDescriptionLbl;


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
