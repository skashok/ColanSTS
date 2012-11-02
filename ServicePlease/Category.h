//
//  Category.h
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

@interface Category : NSObject

@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *organizationId;
@property (strong, nonatomic) NSString *categoryName;
@property (strong, nonatomic) UIImage *categoryIcon;
@property (strong, nonatomic) NSDate *createDate;
@property (strong, nonatomic) NSDate *editDate;

+ (NSString *)toJsonString:(Category *)category indent:(BOOL)indent;
+ (NSString *)arrayToJsonString:(NSMutableArray *)categoryList;
+ (id)fromJsonString:(NSString *)jsonString;

@end
