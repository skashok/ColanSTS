//
//  Solution.h
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

@interface Solution : NSObject

@property (strong, nonatomic) NSString *solutionId;
@property (strong, nonatomic) NSString *ticketId;
@property (strong, nonatomic) NSString *solutionShortDesc;
@property (strong, nonatomic) NSString *solutionText;
@property int likeCount;
@property int unlikeCount;
@property (strong, nonatomic) NSDate *createDate;
@property (strong, nonatomic) NSDate *editDate;

+ (NSString *)toJsonString:(Solution *)category indent:(BOOL)indent;
+ (NSString *)arrayToJsonString:(NSMutableArray *)categoryList;
+ (id)fromJsonString:(NSString *)jsonString;

@end
