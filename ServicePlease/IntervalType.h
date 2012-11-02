//
//  intervalType.h
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

@interface IntervalType : NSObject

@property(strong, nonatomic) NSString *intervalTypeId;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSDate *createDate;
@property(strong, nonatomic) NSDate *editDate;

+ (NSString *)toJsonString:(IntervalType *)intervalType indent:(BOOL)indent;
+ (NSString *)arrayToJsonString:(NSMutableArray *)intervalTypeList;
+ (id)fromJsonString:(NSString *)jsonString;
@end
