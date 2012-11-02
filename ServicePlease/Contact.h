//
//  Contact.h
//  ServicePlease
//
//  Created by Edward Elliott on 2/21/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Utility.h"

#import "NSString+StringWithUUID.h"

#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

#import	"JSONRepresentation.h"

@interface Contact : NSObject

@property (strong, nonatomic) NSString *contactId;
@property (strong, nonatomic) NSString *organizationId;
@property (strong, nonatomic) NSString *contactName;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *middleName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *locationId;
@property (strong, nonatomic) NSDate *createDate;
@property (strong, nonatomic) NSDate *editDate;
@property (strong, nonatomic) NSString *callBackNum;

+ (NSString *)toJsonString:(Contact *)category indent:(BOOL)indent;
+ (NSString *)arrayToJsonString:(NSMutableArray *)categoryList;
+ (id)fromJsonString:(NSString *)jsonString;

@end
