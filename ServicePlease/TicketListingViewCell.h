//
//  TicketListingViewCell.h
//  ServicePlease
//
//  Created by Edward Elliott on 2/15/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketListingViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *categoryLbl;
@property (strong, nonatomic) IBOutlet UILabel *dateTimeLbl;
@property (strong, nonatomic) IBOutlet UILabel *openCloseLbl;
@property (strong, nonatomic) IBOutlet UILabel *techLbl;

@end
