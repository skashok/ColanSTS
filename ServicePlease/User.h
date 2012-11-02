//
//  User.h
//  ServicePlease
//
//  Created by Ed Elliott on 2/12/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Utility.h"

#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

#import	"JSONRepresentation.h"

@interface User : NSObject

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *hashedPassword;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *middleName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *locationId;
@property (strong, nonatomic) NSDate   *createDate;
@property (strong, nonatomic) NSDate   *editDate;
@property (strong, nonatomic) NSString *userRollId;

+ (NSString *)toJsonString:(User *)category indent:(BOOL)indent;
+ (NSString *)arrayToJsonString:(NSMutableArray *)categoryList;
+ (id)fromJsonString:(NSString *)jsonString;

@end
