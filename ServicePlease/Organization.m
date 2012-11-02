//
//  Organization.m
//  ServicePlease
//
//  Created by Ed Elliott on 2/9/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "Organization.h"

@implementation Organization

@synthesize organizationId = _organizationId;
@synthesize organizationName = _organizationName;
@synthesize locationId = _locationId;
@synthesize createDate = _createDate;
@synthesize editDate = _editDate;

+ (NSString *)toJsonString:(Organization *)organization indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"OrganizationId\":\"%@\", \n", [organization organizationId]];
			[jsonStringBuilder appendFormat:@"\t     \"OrganizationName\":\"%@\", \n", [organization organizationName]];
			[jsonStringBuilder appendFormat:@"\t     \"LocationId\":\"%@\", \n", [organization locationId]];
			[jsonStringBuilder appendFormat:@"\t     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[organization createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[organization editDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"OrganizationId\":\"%@\", \n", [organization organizationId]];
			[jsonStringBuilder appendFormat:@"     \"OrganizationName\":\"%@\", \n", [organization organizationName]];
			[jsonStringBuilder appendFormat:@"     \"LocationId\":\"%@\", \n", [organization locationId]];
			[jsonStringBuilder appendFormat:@"     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[organization createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[organization editDate] timeIntervalSince1970] * 1000];
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

+ (NSString *)arrayToJsonString:(NSMutableArray *)organizationList
{
	NSMutableString *jsonStringBuilder = nil;
	NSString *jsonString = @"";
	
	@try 
	{
		if(jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		NSEnumerator *enumerator = [organizationList objectEnumerator];
		
		Organization *currentOrganization = nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (currentOrganization = [enumerator nextObject]) 
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [Organization toJsonString:currentOrganization indent:YES]];
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
	Organization *deserializedOrganization = nil;
	NSMutableArray *organizationList = nil;
	
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
			if(organizationList == nil)
			{
				organizationList = [[NSMutableArray alloc] init];
			}
			
			for (int i = 0; i < [theObject count]; i++) 
			{
				id currentOrganization = [theObject objectAtIndex:i];
				
				if(deserializedOrganization == nil)
				{
					deserializedOrganization = [[Organization alloc] init];
				}
				
				[deserializedOrganization setOrganizationId:[[currentOrganization valueForKey:@"OrganizationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentOrganization valueForKey:@"OrganizationId"] : @""];
				[deserializedOrganization setOrganizationName:[currentOrganization valueForKey:@"OrganizationName"]];
				[deserializedOrganization setLocationId:[[currentOrganization valueForKey:@"LocationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentOrganization valueForKey:@"LocationId"] : @""];
				[deserializedOrganization setCreateDate:[Utility getDateFromJSONDate:[currentOrganization valueForKey:@"CreateDate"]]];
				[deserializedOrganization setEditDate:[Utility getDateFromJSONDate:[currentOrganization valueForKey:@"EditDate"]]];
				
				[organizationList addObject:deserializedOrganization];
				
				deserializedOrganization = nil;
			}
		}
		else
		{
			if(deserializedOrganization == nil)
			{
				deserializedOrganization = [[Organization alloc] init];
			}
			
			[deserializedOrganization setOrganizationId:[[theObject valueForKey:@"OrganizationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"OrganizationId"] : @""];
			[deserializedOrganization setOrganizationName:[theObject valueForKey:@"OrganizationName"]];
			[deserializedOrganization setLocationId:[[theObject valueForKey:@"LocationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"LocationId"] : @""];
			[deserializedOrganization setCreateDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"CreateDate"]]];
			[deserializedOrganization setEditDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"EditDate"]]];
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in ServiceHelper.fromJsonString - Error: %@", [exception description]);
		
		theObject = nil;
		deserializedOrganization = nil;
		organizationList = nil;
	}
	@finally 
	{
		if (workingWithArray == YES) 
		{
			return organizationList;
		}
		else
		{
			return deserializedOrganization;
		}
	}
}

@end
