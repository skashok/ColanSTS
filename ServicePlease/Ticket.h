//
//  Ticket.h
//  ServicePlease
//
//  Created by Ed Elliott on 2/9/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Utility.h"

#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

#import	"JSONRepresentation.h"

@interface Ticket : NSObject


@property (strong, nonatomic) NSString *ticketId;
@property (strong, nonatomic) NSString *ticketNum;
@property (strong, nonatomic) NSString *ticketNumber;
@property (strong, nonatomic) NSString *ticketName;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *contactId;
@property (strong, nonatomic) NSString *locationId;
@property (strong, nonatomic) NSString *organizationId;
@property (strong, nonatomic) NSString *ticketStatus;
@property (strong, nonatomic) NSString *ticketServicePlan;
@property (strong, nonatomic) NSNumber *openClose;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *tech;
@property (strong, nonatomic) NSDate *closeDate;
@property (strong, nonatomic) NSDate *createDate;
@property (strong, nonatomic) NSDate *editDate;
@property (strong , nonatomic) NSString *IsHelpDoc;

+ (NSString *)toJsonString:(Ticket *)category indent:(BOOL)indent;
+ (NSString *)arrayToJsonString:(NSMutableArray *)categoryList;
+ (id)fromJsonString:(NSString *)jsonString;

@end
