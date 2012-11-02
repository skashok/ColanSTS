//
//  LikeUnlike.h
//  ServiceTech
//
//  Created by colan on 01/11/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YAJLiOS/YAJL.h>
#import <Foundation/Foundation.h>
#import "Utility.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"
#import	"JSONRepresentation.h"

@interface LikeUnlike : NSObject
{
    
}

@property (nonatomic,strong) NSString *likeUnlikeId;
@property (nonatomic,strong) NSString *solutionId;
@property int like;
@property (nonatomic,strong) NSString *unlike;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSDate *createDate;
@property (nonatomic,strong) NSDate *editDate;

+ (NSString *)toJsonString:(LikeUnlike *)likeUnlike indent:(BOOL)indent;
+ (NSString *)arrayToJsonString:(NSMutableArray *)applicationList;
+ (id)fromJsonString:(NSString *)jsonString;

@end
