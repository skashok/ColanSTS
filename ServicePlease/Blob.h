//
//  Blob.h
//  ServiceTech
//
//  Created by Ashokkumar Kandaswamy on 01/08/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Utility.h"

#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

#import	"JSONRepresentation.h"

@interface Blob : NSObject

@property (strong, nonatomic) NSString *EntityId;
@property (strong, nonatomic) NSString *BlobTypeId;
@property (strong, nonatomic) NSArray *BlobBytes;

+ (NSString *)toJsonString:(Blob *)category indent:(BOOL)indent;
+ (NSString *)arrayToJsonString:(NSMutableArray *)categoryList;
+ (id)fromJsonString:(NSString *)jsonString;

@end