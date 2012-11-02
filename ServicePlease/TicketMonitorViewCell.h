//
//  TicketMonitorViewCell.h
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 12/06/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketMonitorViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *locationLbl;
@property (strong, nonatomic) IBOutlet UILabel *contactLbl;
@property (strong, nonatomic) IBOutlet UILabel *timeElapsedLbl;
@property (strong, nonatomic) IBOutlet UILabel *ticketNumberLbl;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (strong, nonatomic) IBOutlet UILabel *categoryLbl;
@property (strong, nonatomic) IBOutlet UILabel *techAssignedLbl;
@property (strong, nonatomic) IBOutlet UILabel *statusLbl;
@property (strong, nonatomic) IBOutlet UILabel *servicePlanLbl;


@end
