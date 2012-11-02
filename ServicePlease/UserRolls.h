//
//  Rolls.h
//  ServiceTech
//
//  Created by Bala Subramaniyan on 07/09/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utility.h"

#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

#import	"JSONRepresentation.h"

@interface UserRolls : NSObject

@property (strong, nonatomic) NSString *RoleID;
@property (strong, nonatomic) NSString *Name;
@property (strong, nonatomic) NSDate *CreateDate;
@property (strong, nonatomic) NSDate *EditDate;


+ (NSString *)toJsonString:(UserRolls *)category indent:(BOOL)indent;
+ (NSString *)arrayToJsonString:(NSMutableArray *)categoryList;
+ (id)fromJsonString:(NSString *)jsonString;

@end
