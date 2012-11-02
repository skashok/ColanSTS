//
//  ServicePlanTypes.h
//  ServicePlease
//
//  Created by Apple on 04/07/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Utility.h"

#import "NSString+StringWithUUID.h"

#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

#import	"JSONRepresentation.h"

@interface SPTypes : NSObject

@property (strong, nonatomic) NSString *servicePlanTypeId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *createDate;
@property (strong, nonatomic) NSDate *editDate;

+ (NSString *)toJsonString:(SPTypes *)ServicePlanTypes indent:(BOOL)indent;
+ (NSString *)arrayToJsonString:(NSMutableArray *)categoryList;
+ (id)fromJsonString:(NSString *)jsonString;


@end
