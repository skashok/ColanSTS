//
//  DailyRecapDB.h
//  ServiceTech
//
//  Created by ColanInfotech on 22/10/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyRecapDB : NSObject

@property(strong,nonatomic) NSString *tech;
@property(strong,nonatomic) NSString *action;
@property(strong,nonatomic) NSString *object;
@property(strong,nonatomic) NSString *value;
@property(strong,nonatomic) NSString *timeStamp;

@end
