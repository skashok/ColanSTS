//
//  UserOrganization.h
//  ServicePlease
//
//  Created by Edward Elliott on 2/21/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Utility.h"

#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

#import	"JSONRepresentation.h"

@interface UserOrganization : NSObject

@property (strong, nonatomic) NSString *userOrganizationId;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *organizationId;
@property (strong, nonatomic) NSDate *createDate;
@property (strong, nonatomic) NSDate *editDate;

+ (NSString *)toJsonString:(UserOrganization *)category indent:(BOOL)indent;
+ (NSString *)arrayToJsonString:(NSMutableArray *)categoryList;
+ (id)fromJsonString:(NSString *)jsonString;

@end
