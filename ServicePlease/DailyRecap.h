//
//  DailyRecap.h
//  ServiceTech
//
//  Created by ColanInfotech on 01/11/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YAJLiOS/YAJL.h>
#import <Foundation/Foundation.h>
#import "Utility.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"
#import	"JSONRepresentation.h"

@interface DailyRecap : NSObject

@property (nonatomic ,retain) NSString *recapSettingId;
@property (nonatomic ,retain) NSString *name;
@property (nonatomic ,retain) NSString *broadcastTime;
@property (nonatomic ,retain) NSString *recapSettingDay;
@property (nonatomic ,retain) NSString *startTime;
@property (nonatomic ,retain) NSString *endTime;
@property (nonatomic ,retain) NSString *recapMail;
@property (nonatomic ,retain) NSString *recapSettingLocation;
@property (nonatomic ,retain) NSString *active;

+ (NSString *)toJsonString:(DailyRecap *)DailyRecap indent:(BOOL)indent;
+ (NSString *)arrayToJsonString:(NSMutableArray *)dailyRecapList;
+ (id)fromJsonString:(NSString *)jsonString;

@end
