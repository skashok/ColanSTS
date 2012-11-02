//
//  LocationInfo.h
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

@interface LocationInfo : NSObject

@property(strong, nonatomic) NSString *locationInfoId;
@property(strong, nonatomic) NSString *address1;
@property(strong, nonatomic) NSString *address2;
@property(strong, nonatomic) NSString *city;
@property(strong, nonatomic) NSString *state;
@property(strong, nonatomic) NSString *postalCode;
@property(strong, nonatomic) NSString *country;
@property(strong, nonatomic) NSString *businessPhone;
@property(strong, nonatomic) NSString *fax;
@property(strong, nonatomic) NSString *mobilePhone;
@property(strong, nonatomic) NSString *homePhone;
@property(strong, nonatomic) NSString *email1;
@property(strong, nonatomic) NSString *email2;
@property(strong, nonatomic) NSString *website;
@property(strong, nonatomic) NSDate *createDate;
@property(strong, nonatomic) NSDate *editDate;

+ (NSString *)toJsonString:(LocationInfo *)category indent:(BOOL)indent;
+ (NSString *)arrayToJsonString:(NSMutableArray *)categoryList;
+ (id)fromJsonString:(NSString *)jsonString;

@end
