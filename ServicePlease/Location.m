//
//  Location.m
//  ServicePlease
//
//  Created by Ed Elliott on 2/9/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "Location.h"

@implementation Location
@synthesize locationId = _locationId;
@synthesize organizationId = _organizationId;
@synthesize locationName = _locationName;
@synthesize locationInfoId = _locationInfoId;
@synthesize createDate = _createDate;
@synthesize editDate = _editDate;

+ (NSString *)toJsonString:(Location *)location indent:(BOOL)indent
{
	NSMutableString *jsonStringBuilder = nil;
	
	NSString *jsonString = @"";
	
	@try 
	{
		if (jsonStringBuilder == nil) 
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		if (indent == YES) 
		{
			[jsonStringBuilder appendFormat:@"\t{ \n"];
			[jsonStringBuilder appendFormat:@"\t     \"LocationId\":\"%@\", \n", [location locationId]];
			[jsonStringBuilder appendFormat:@"\t     \"OrganizationId\":\"%@\", \n", [location organizationId]];
			[jsonStringBuilder appendFormat:@"\t     \"LocationName\":\"%@\", \n", [location locationName]];
			[jsonStringBuilder appendFormat:@"\t     \"LocationInfoId\":\"%@\", \n", [location locationInfoId]];
			[jsonStringBuilder appendFormat:@"\t     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[location createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[location editDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"LocationId\":\"%@\", \n", [location locationId]];
			[jsonStringBuilder appendFormat:@"     \"OrganizationId\":\"%@\", \n", [location organizationId]];
			[jsonStringBuilder appendFormat:@"     \"LocationName\":\"%@\", \n", [location locationName]];
			[jsonStringBuilder appendFormat:@"     \"LocationInfoId\":\"%@\", \n", [location locationInfoId]];
			[jsonStringBuilder appendFormat:@"     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[location createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[location editDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"}"];
		}
		
		jsonString = jsonStringBuilder;
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error occurred in toJsonString.  Error: %@", [exception description]);
		
		jsonString = @"";
	}
	@finally 
	{		
		return jsonString;
	}
}

+ (NSString *)arrayToJsonString:(NSMutableArray *)locationList
{
	NSMutableString *jsonStringBuilder = nil;
	NSString *jsonString = @"";
	
	@try 
	{
		if(jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		NSEnumerator *enumerator = [locationList objectEnumerator];
		
		Location *currentLocation = nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (currentLocation = [enumerator nextObject]) 
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [Location toJsonString:currentLocation indent:YES]];
		}
		
		// Remove the last comma and add the closing ]
		jsonString = [NSString stringWithFormat:@"%@\n]", [jsonStringBuilder substringToIndex:[jsonStringBuilder length] - 3]];
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error occurred in toJsonString.  Error: %@", [exception description]);
		
		jsonString = @"";
	}
	@finally 
	{
		return jsonString;
	}
}

+ (id)fromJsonString:(NSString *)jsonString
{
	Location *deserializedLocation = nil;
	NSMutableArray *locationList = nil;
	
	id theObject = nil;
	
	BOOL workingWithArray = NO;
	
	@try 
	{
		NSRange range = [jsonString rangeOfString:@"["];
		
		if (range.length > 0) 
		{
			workingWithArray = YES;
		}
		
		// Converting jsonString to NSData
		NSData *theJSONData = [NSData dataWithBytes:[jsonString UTF8String] 
											 length:[jsonString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
		
		NSError *theError = nil;
		
		// Parse the JSON into an Object
		theObject = [[CJSONDeserializer deserializer] deserialize:theJSONData error:&theError];	
		
		if (workingWithArray == YES) 
		{
			if(locationList == nil)
			{
				locationList = [[NSMutableArray alloc] init];
			}
			
			for (int i = 0; i < [theObject count]; i++) 
			{
				id currentLocation = [theObject objectAtIndex:i];
				
				if(deserializedLocation == nil)
				{
					deserializedLocation = [[Location alloc] init];
				}
				
				[deserializedLocation setLocationId:[[currentLocation valueForKey:@"LocationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentLocation valueForKey:@"LocationId"] : @""];
				[deserializedLocation setOrganizationId:[[currentLocation valueForKey:@"OrganizationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentLocation valueForKey:@"OrganizationId"] : @""];
				[deserializedLocation setLocationName:[currentLocation valueForKey:@"LocationName"]];
				[deserializedLocation setLocationInfoId:[[currentLocation valueForKey:@"LocationInfoId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentLocation valueForKey:@"LocationInfoId"] : @""];
				[deserializedLocation setCreateDate:[Utility getDateFromJSONDate:[currentLocation valueForKey:@"CreateDate"]]];
				[deserializedLocation setEditDate:[Utility getDateFromJSONDate:[currentLocation valueForKey:@"EditDate"]]];
				
				[locationList addObject:deserializedLocation];
				
				deserializedLocation = nil;
			}
		}
		else
		{
			if(deserializedLocation == nil)
			{
				deserializedLocation = [[Location alloc] init];
			}
			
			[deserializedLocation setLocationId:[[theObject valueForKey:@"LocationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"LocationId"] : @""];
			[deserializedLocation setOrganizationId:[[theObject valueForKey:@"OrganizationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"OrganizationId"] : @""];
			[deserializedLocation setLocationName:[theObject valueForKey:@"LocationName"]];
			[deserializedLocation setLocationInfoId:[[theObject valueForKey:@"LocationInfoId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"LocationInfoId"] : @""];
			[deserializedLocation setCreateDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"CreateDate"]]];
			[deserializedLocation setEditDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"EditDate"]]];
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in ServiceHelper.fromJsonString - Error: %@", [exception description]);
		
		theObject = nil;
		deserializedLocation = nil;
		locationList = nil;
	}
	@finally 
	{
		if (workingWithArray == YES) 
		{
			return locationList;
		}
		else
		{
			return deserializedLocation;
		}
	}
}

@end
