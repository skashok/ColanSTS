//
//  Utility.h
//  NYStateSnowmobiling
//
//  Created by Ed Elliott on 12/4/11.
//  Copyright (c) 2012 Service Tracking System, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (NSDate *)getDateFromJSONDate:(NSString *)jsonDate;
+ (NSString *)convertDateToDateString:(NSDate *)date;

@end
