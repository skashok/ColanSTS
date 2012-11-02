//
//  EmailNotification.h
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 04/06/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "LocationInfo.h"

@interface EmailNotification : NSObject

+ (NSString *)JsonContentofEmailWithIndent:(BOOL)indent withLocation:(Location *)loc withLoacationInfoDetail:(LocationInfo *)locationInfo;


@end
