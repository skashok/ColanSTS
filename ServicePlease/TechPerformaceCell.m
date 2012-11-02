//
//  TechPerformaceCell.m
//  ServiceTech
//
//  Created by Ashokkumar Kandaswamy on 23/08/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "TechPerformaceCell.h"

@implementation TechPerformaceCell

@synthesize techLbl,TTCLbl,TTOLbl,ARTLbl,ATOLbl,FBLbl,contLbl;

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
