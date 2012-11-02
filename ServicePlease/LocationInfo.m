//
//  LocationInfo.m
//  ServicePlease
//
//  Created by Ed Elliott on 2/9/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "LocationInfo.h"

@implementation LocationInfo

@synthesize locationInfoId = _locationInfoId;
@synthesize address1 = _address1;
@synthesize address2 = _address2;
@synthesize city = _city;
@synthesize state = _state;
@synthesize postalCode = _postalCode;
@synthesize country = _country;
@synthesize businessPhone = _businessPhone;
@synthesize fax = _fax;
@synthesize mobilePhone = _mobilePhone;
@synthesize homePhone = _homePhone;
@synthesize email1 = _email1;
@synthesize email2 = _email2;
@synthesize website = _website;
@synthesize createDate = _createDate;
@synthesize editDate = _editDate;

+ (NSString *)toJsonString:(LocationInfo *)locationInfo indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"LocationInfoId\":\"%@\", \n", [locationInfo locationInfoId]];
			[jsonStringBuilder appendFormat:@"\t     \"Address1\":\"%@\", \n", [locationInfo address1]];
			[jsonStringBuilder appendFormat:@"\t     \"Address2\":\"%@\", \n", [locationInfo address2]];
			[jsonStringBuilder appendFormat:@"\t     \"City\":\"%@\", \n", [locationInfo city]];
			[jsonStringBuilder appendFormat:@"\t     \"State\":\"%@\", \n", [locationInfo state]];
			[jsonStringBuilder appendFormat:@"\t     \"PostalCode\":\"%@\", \n", [locationInfo postalCode]];
			[jsonStringBuilder appendFormat:@"\t     \"Country\":\"%@\", \n", [locationInfo country]];
			[jsonStringBuilder appendFormat:@"\t     \"BusinessPhone\":\"%@\", \n", [locationInfo businessPhone]];
			[jsonStringBuilder appendFormat:@"\t     \"Fax\":\"%@\", \n", [locationInfo fax]];
			[jsonStringBuilder appendFormat:@"\t     \"MobilePhone\":\"%@\", \n", [locationInfo mobilePhone]];
			[jsonStringBuilder appendFormat:@"\t     \"HomePhone\":\"%@\", \n", [locationInfo homePhone]];
			[jsonStringBuilder appendFormat:@"\t     \"Email1\":\"%@\", \n", [locationInfo email1]];
			[jsonStringBuilder appendFormat:@"\t     \"Email2\":\"%@\", \n", [locationInfo email2]];
			[jsonStringBuilder appendFormat:@"\t     \"Website\":\"%@\", \n", [locationInfo website]];
			[jsonStringBuilder appendFormat:@"\t     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[locationInfo createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[locationInfo editDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"LocationInfoId\":\"%@\", \n", [locationInfo locationInfoId]];
			[jsonStringBuilder appendFormat:@"     \"Address1\":\"%@\", \n", [locationInfo address1]];
			[jsonStringBuilder appendFormat:@"     \"Address2\":\"%@\", \n", [locationInfo address2]];
			[jsonStringBuilder appendFormat:@"     \"City\":\"%@\", \n", [locationInfo city]];
			[jsonStringBuilder appendFormat:@"     \"State\":\"%@\", \n", [locationInfo state]];
			[jsonStringBuilder appendFormat:@"     \"PostalCode\":\"%@\", \n", [locationInfo postalCode]];
			[jsonStringBuilder appendFormat:@"     \"Country\":\"%@\", \n", [locationInfo country]];
			[jsonStringBuilder appendFormat:@"     \"BusinessPhone\":\"%@\", \n", [locationInfo businessPhone]];
			[jsonStringBuilder appendFormat:@"     \"Fax\":\"%@\", \n", [locationInfo fax]];
			[jsonStringBuilder appendFormat:@"     \"MobilePhone\":\"%@\", \n", [locationInfo mobilePhone]];
			[jsonStringBuilder appendFormat:@"     \"HomePhone\":\"%@\", \n", [locationInfo homePhone]];
			[jsonStringBuilder appendFormat:@"     \"Email1\":\"%@\", \n", [locationInfo email1]];
			[jsonStringBuilder appendFormat:@"     \"Email2\":\"%@\", \n", [locationInfo email2]];
			[jsonStringBuilder appendFormat:@"     \"Website\":\"%@\", \n", [locationInfo website]];
			[jsonStringBuilder appendFormat:@"     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[locationInfo createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[locationInfo editDate] timeIntervalSince1970] * 1000];
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

+ (NSString *)arrayToJsonString:(NSMutableArray *)locationInfoList
{
	NSMutableString *jsonStringBuilder = nil;
	NSString *jsonString = @"";
	
	@try 
	{
		if(jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		NSEnumerator *enumerator = [locationInfoList objectEnumerator];
		
		LocationInfo *currentLocationInfo = nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (currentLocationInfo = [enumerator nextObject]) 
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [LocationInfo toJsonString:currentLocationInfo indent:YES]];
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
	LocationInfo *deserializedLocationInfo = nil;
	NSMutableArray *locationInfoList = nil;
	
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
			if(locationInfoList == nil)
			{
				locationInfoList = [[NSMutableArray alloc] init];
			}
			
			for (int i = 0; i < [theObject count]; i++) 
			{
				id currentLocationInfo = [theObject objectAtIndex:i];
				
				if(deserializedLocationInfo == nil)
				{
					deserializedLocationInfo = [[LocationInfo alloc] init];
				}
				
				[deserializedLocationInfo setLocationInfoId:[[currentLocationInfo valueForKey:@"LocationInfoId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentLocationInfo valueForKey:@"LocationInfoId"] : @""];
				[deserializedLocationInfo setLocationInfoId:[currentLocationInfo valueForKey:@"Address1"]];
				[deserializedLocationInfo setLocationInfoId:[currentLocationInfo valueForKey:@"Address2"]];
				[deserializedLocationInfo setLocationInfoId:[currentLocationInfo valueForKey:@"City"]];
				[deserializedLocationInfo setLocationInfoId:[currentLocationInfo valueForKey:@"State"]];
				[deserializedLocationInfo setLocationInfoId:[currentLocationInfo valueForKey:@"PostalCode"]]; 
				[deserializedLocationInfo setLocationInfoId:[currentLocationInfo valueForKey:@"Country"]];
				[deserializedLocationInfo setLocationInfoId:[currentLocationInfo valueForKey:@"BusinessPhone"]];
				[deserializedLocationInfo setLocationInfoId:[currentLocationInfo valueForKey:@"Fax"]];
				[deserializedLocationInfo setLocationInfoId:[currentLocationInfo valueForKey:@"MobilePhone"]];
				[deserializedLocationInfo setLocationInfoId:[currentLocationInfo valueForKey:@"HomePhone"]];
				[deserializedLocationInfo setLocationInfoId:[currentLocationInfo valueForKey:@"Email1"]];
				[deserializedLocationInfo setLocationInfoId:[currentLocationInfo valueForKey:@"Email2"]];
				[deserializedLocationInfo setLocationInfoId:[currentLocationInfo valueForKey:@"Website"]];
				[deserializedLocationInfo setCreateDate:[Utility getDateFromJSONDate:[currentLocationInfo valueForKey:@"CreateDate"]]];
				[deserializedLocationInfo setEditDate:[Utility getDateFromJSONDate:[currentLocationInfo valueForKey:@"EditDate"]]];
				
				[locationInfoList addObject:deserializedLocationInfo];
				
				deserializedLocationInfo = nil;
			}
		}
		else
		{
			if(deserializedLocationInfo == nil)
			{
				deserializedLocationInfo = [[LocationInfo alloc] init];
			}
			
			[deserializedLocationInfo setLocationInfoId:[[theObject valueForKey:@"LocationInfoId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"LocationInfoId"] : @""];
			[deserializedLocationInfo setLocationInfoId:[theObject valueForKey:@"Address1"]];
			[deserializedLocationInfo setLocationInfoId:[theObject valueForKey:@"Address2"]];
			[deserializedLocationInfo setLocationInfoId:[theObject valueForKey:@"City"]];
			[deserializedLocationInfo setLocationInfoId:[theObject valueForKey:@"State"]];
			[deserializedLocationInfo setLocationInfoId:[theObject valueForKey:@"PostalCode"]]; 
			[deserializedLocationInfo setLocationInfoId:[theObject valueForKey:@"Country"]];
			[deserializedLocationInfo setLocationInfoId:[theObject valueForKey:@"BusinessPhone"]];
			[deserializedLocationInfo setLocationInfoId:[theObject valueForKey:@"Fax"]];
			[deserializedLocationInfo setLocationInfoId:[theObject valueForKey:@"MobilePhone"]];
			[deserializedLocationInfo setLocationInfoId:[theObject valueForKey:@"HomePhone"]];
			[deserializedLocationInfo setLocationInfoId:[theObject valueForKey:@"Email1"]];
			[deserializedLocationInfo setLocationInfoId:[theObject valueForKey:@"Email2"]];
			[deserializedLocationInfo setLocationInfoId:[theObject valueForKey:@"Website"]];
			[deserializedLocationInfo setCreateDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"CreateDate"]]];
			[deserializedLocationInfo setEditDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"EditDate"]]];
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in ServiceHelper.fromJsonString - Error: %@", [exception description]);
		
		theObject = nil;
		deserializedLocationInfo = nil;
		locationInfoList = nil;
	}
	@finally 
	{
		if (workingWithArray == YES) 
		{
			return locationInfoList;
		}
		else
		{
			return deserializedLocationInfo;
		}
	}
}

@end
