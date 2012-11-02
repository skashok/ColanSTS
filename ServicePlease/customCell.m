//
//  customCell.m
//  ServiceTech
//
//  Created by Ashokkumar Kandaswamy on 08/08/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//
#import "customCell.h"

@implementation customCell

@synthesize tittleLabel,detailLabel,CellBtn,cellDelegate;

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
-(IBAction)CellBtnPressed:(id)sender{
    
    if (cellDelegate !=nil && [cellDelegate conformsToProtocol:@protocol(customProblemTabelViewCellDelegate)]) 
    {
        
        if ([cellDelegate respondsToSelector:@selector(problemcustomCellBtnPressed:cell:)]) 
        {
            [cellDelegate problemcustomCellBtnPressed:sender cell:self];
        }
    }
    
}
@end

