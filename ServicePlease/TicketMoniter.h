//
//  TicketMoniter.h
//  ServicePlease
//
//  Created by Apple on 06/07/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Utility.h"

#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

#import	"JSONRepresentation.h"

@interface TicketMoniter : NSObject


@property (strong, nonatomic) NSString *ticketCategory;
@property (strong, nonatomic) NSString *ticketTicketNumber;
@property (strong, nonatomic) NSString *ticketCategoryId;
@property (strong, nonatomic) NSString *ticketContact;
@property (strong, nonatomic) NSString *ticketContactId;
@property (strong, nonatomic) NSString *ticketDescription;
@property (strong, nonatomic) NSString *ticketElapsed;
@property (strong, nonatomic) NSString *ticketLocation;
@property (strong, nonatomic) NSString *ticketLocationId;
@property (strong, nonatomic) NSString *ticketOrganizationId;
@property (strong, nonatomic) NSString *ticketServicePlan;
@property (strong, nonatomic) NSString *ticketStatus;
@property (strong, nonatomic) NSString *ticketTech;
@property (strong, nonatomic) NSString *ticketTicketId;
@property (strong, nonatomic) NSDate *ticketTime;
@property (strong, nonatomic) NSString *ticketUserId;


+ (NSString *)toJsonString:(TicketMoniter *)ticketMoniter indent:(BOOL)indent;
+ (NSString *)arrayToJsonString:(NSMutableArray *)categoryList;
+ (id)fromJsonString:(NSString *)jsonString;

@end


