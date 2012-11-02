//
//  SnoozeReason.h
//  ServiceTech
//
//  Created by colan on 15/10/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Utility.h"

#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

#import	"JSONRepresentation.h"

@interface SnoozeReason : NSObject

@property(strong, nonatomic) NSString *reasonId;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSDate *createDate;
@property(strong, nonatomic) NSDate *editDate;

+ (NSString *)toJsonString:(SnoozeReason *)snoozeReason indent:(BOOL)indent;
+ (NSString *)arrayToJsonString:(NSMutableArray *)intervalTypeList;
+ (id)fromJsonString:(NSString *)jsonString;

@end
