//
//  Problem.h
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

@interface Problem : NSObject

@property (strong, nonatomic) NSString *problemId;
@property (strong, nonatomic) NSString *ticketId;
@property (strong, nonatomic) NSString *problemShortDesc;
@property (strong, nonatomic) NSString *problemText;
@property (strong, nonatomic) NSDate *createDate;
@property (strong, nonatomic) NSDate *editDate;

+ (NSString *)toJsonString:(Problem *)category indent:(BOOL)indent;
+ (NSString *)arrayToJsonString:(NSMutableArray *)categoryList;
+ (id)fromJsonString:(NSString *)jsonString;

@end
