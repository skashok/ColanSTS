//
//  SelectedEntities.h
//  ServicePlease
//
//  Created by Ed Elliott on 2/12/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Utility.h"

#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

#import	"JSONRepresentation.h"

#import "User.h"
#import "Category.h"
#import "Contact.h"
#import "Location.h"
#import "LocationInfo.h"
#import "Organization.h"
#import "Ticket.h"
#import "Solution.h"
#import "TicketMoniter.h"
#import "ApplicationType.h"

@interface SelectedEntities : NSObject

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) Category *category;
@property (strong, nonatomic) Contact *contact;
@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) LocationInfo *locationInfo;
@property (strong, nonatomic) Organization *organization;
@property (strong, nonatomic) Ticket *ticket;
@property (strong, nonatomic) Solution *solution;
@property (strong, nonatomic) TicketMoniter *ticketMonitor;
@property (strong, nonatomic) ApplicationType *applicationType;

@end
