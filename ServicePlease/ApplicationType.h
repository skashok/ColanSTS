//
//  ApplicationType.h
//  ServiceTech
//
//  Created by ColanInfotech on 15/10/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YAJLiOS/YAJL.h>
#import <Foundation/Foundation.h>
#import "Utility.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"
#import	"JSONRepresentation.h"

@interface ApplicationType : NSObject

@property (nonatomic,strong) NSString *applicationTypeId;
@property (nonatomic,strong) NSString *applicationName;
@property (nonatomic,strong) NSDate *createDate;
@property (nonatomic,strong) NSDate *editDate;

+ (NSString *)toJsonString:(ApplicationType *)ApplicationType indent:(BOOL)indent;
+ (NSString *)arrayToJsonString:(NSMutableArray *)applicationList;
+ (id)fromJsonString:(NSString *)jsonString;

@end
