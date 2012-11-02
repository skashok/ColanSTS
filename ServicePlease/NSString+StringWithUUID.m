//
//  NSString+StringWithUUID.m
//  ServicePlease
//
//  Created by Ed Elliott on 2/9/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "NSString+StringWithUUID.h"

@implementation NSString (StringWithUUID)

+ (NSString *) stringWithUUID 
{
	CFUUIDRef	uuidObj = CFUUIDCreate(nil);   //create a new UUID
											   //get the string representation of the UUID

	NSString	*uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
	
	CFRelease(uuidObj);
	
	return uuidString;
}


@end
