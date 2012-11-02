//
//  UserOrganization.m
//  ServicePlease
//
//  Created by Edward Elliott on 2/21/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "UserOrganization.h"

@implementation UserOrganization

@synthesize userOrganizationId = _userOrganizationId;
@synthesize userId = _userId;
@synthesize organizationId = _organizationId;
@synthesize createDate = _createDate;
@synthesize editDate = _editDate;

+ (NSString *)toJsonString:(UserOrganization *)userOrganization indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"UserOrganizationId\":\"%@\", \n", [userOrganization userOrganizationId]];
			[jsonStringBuilder appendFormat:@"\t     \"UserId\":\"%@\", \n", [userOrganization userId]];
			[jsonStringBuilder appendFormat:@"\t     \"OrganizationId\":\"%@\", \n", [userOrganization organizationId]];
			[jsonStringBuilder appendFormat:@"\t     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[userOrganization createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[userOrganization editDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"UserOrganizationId\":\"%@\", \n", [userOrganization userOrganizationId]];
			[jsonStringBuilder appendFormat:@"     \"UserId\":\"%@\", \n", [userOrganization userId]];
			[jsonStringBuilder appendFormat:@"     \"OrganizationId\":\"%@\", \n", [userOrganization organizationId]];
			[jsonStringBuilder appendFormat:@"     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[userOrganization createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[userOrganization editDate] timeIntervalSince1970] * 1000];
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

+ (NSString *)arrayToJsonString:(NSMutableArray *)userOrganizationList
{
	NSMutableString *jsonStringBuilder = nil;
	NSString *jsonString = @"";
	
	@try 
	{
		if(jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		NSEnumerator *enumerator = [userOrganizationList objectEnumerator];
		
		UserOrganization *currentUserOrganization = nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (currentUserOrganization = [enumerator nextObject]) 
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [UserOrganization toJsonString:currentUserOrganization indent:YES]];
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
	UserOrganization *deserializedUserOrganization = nil;
	NSMutableArray *userOrganizationList = nil;
	
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
			if(userOrganizationList == nil)
			{
				userOrganizationList = [[NSMutableArray alloc] init];
			}
			
			for (int i = 0; i < [theObject count]; i++) 
			{
				id currentUserOrganization = [theObject objectAtIndex:i];
				
				if(deserializedUserOrganization == nil)
				{
					deserializedUserOrganization = [[UserOrganization alloc] init];
				}
				
				[deserializedUserOrganization setUserOrganizationId:[currentUserOrganization valueForKey:@"UserOrganizationId"]];
				[deserializedUserOrganization setUserId:[[currentUserOrganization valueForKey:@"UserId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentUserOrganization valueForKey:@"UserId"] : @""];
				[deserializedUserOrganization setOrganizationId:[[currentUserOrganization valueForKey:@"OrganizationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentUserOrganization valueForKey:@"OrganizationId"] : @""];
				[deserializedUserOrganization setCreateDate:[Utility getDateFromJSONDate:[currentUserOrganization valueForKey:@"CreateDate"]]];
				[deserializedUserOrganization setEditDate:[Utility getDateFromJSONDate:[currentUserOrganization valueForKey:@"EditDate"]]];
				
				[userOrganizationList addObject:deserializedUserOrganization];
				
				deserializedUserOrganization = nil;
			}
		}
		else
		{
			if(deserializedUserOrganization == nil)
			{
				deserializedUserOrganization = [[UserOrganization alloc] init];
			}
			
			[deserializedUserOrganization setUserOrganizationId:[deserializedUserOrganization valueForKey:@"UserOrganizationId"]];
			[deserializedUserOrganization setUserId:[[deserializedUserOrganization valueForKey:@"UserId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [deserializedUserOrganization valueForKey:@"UserId"] : @""];
			[deserializedUserOrganization setOrganizationId:[[deserializedUserOrganization valueForKey:@"OrganizationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [deserializedUserOrganization valueForKey:@"OrganizationId"] : @""];
			[deserializedUserOrganization setCreateDate:[Utility getDateFromJSONDate:[deserializedUserOrganization valueForKey:@"CreateDate"]]];
			[deserializedUserOrganization setEditDate:[Utility getDateFromJSONDate:[deserializedUserOrganization valueForKey:@"EditDate"]]];
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in ServiceHelper.fromJsonString - Error: %@", [exception description]);
		
		theObject = nil;
		deserializedUserOrganization = nil;
		userOrganizationList = nil;
	}
	@finally 
	{
		if (workingWithArray == YES) 
		{
			return userOrganizationList;
		}
		else
		{
			return deserializedUserOrganization;
		}
	}
}

@end
