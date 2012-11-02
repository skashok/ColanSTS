//
//  Tech.m
//  ServiceTech
//
//  Created by Apple on 25/07/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "Tech.h"

@implementation Tech

@synthesize userId = _userId;
@synthesize userName = _userName;
@synthesize hashedPassword = _hashedPassword;
@synthesize firstName = _firstName;
@synthesize middleName = _middleName;
@synthesize lastName = _lastName;
@synthesize email = _email;
@synthesize phone = _phone;
@synthesize locationId = _locationId;
@synthesize createDate = _createDate;
@synthesize editDate = _editDate;

+ (NSString *)toJsonString:(Tech *)tech indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"UserId\":\"%@\", \n", [[tech userId] lowercaseString]];
			[jsonStringBuilder appendFormat:@"\t     \"UserName\":\"%@\", \n", [[tech userName] lowercaseString]];
			[jsonStringBuilder appendFormat:@"\t     \"HashedPassword\":\"%@\", \n", [tech hashedPassword]];
			[jsonStringBuilder appendFormat:@"\t     \"FirstName\":\"%@\", \n", [tech firstName]];
			[jsonStringBuilder appendFormat:@"\t     \"MiddleName\":\"%@\", \n", [tech middleName]];
			[jsonStringBuilder appendFormat:@"\t     \"LastName\":\"%@\", \n", [tech lastName]];
			[jsonStringBuilder appendFormat:@"\t     \"Email\":\"%@\", \n", [tech email]];
			[jsonStringBuilder appendFormat:@"\t     \"Phone\":\"%@\", \n", [tech phone]];
			[jsonStringBuilder appendFormat:@"\t     \"LocationId\":\"%@\", \n", [[tech locationId] lowercaseString]];
			[jsonStringBuilder appendFormat:@"\t     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[tech createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t     \"EditDate\":\"\\/Date(%.0f)\\/\", \n", [[tech editDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"UserId\":\"%@\", \n", [[tech userId] lowercaseString]];
			[jsonStringBuilder appendFormat:@"     \"UserName\":\"%@\", \n", [[tech userName] lowercaseString]];
			[jsonStringBuilder appendFormat:@"     \"HashedPassword\":\"%@\", \n", [tech hashedPassword]];
			[jsonStringBuilder appendFormat:@"     \"FirstName\":\"%@\", \n", [tech firstName]];
			[jsonStringBuilder appendFormat:@"     \"MiddleName\":\"%@\", \n", [tech middleName]];
			[jsonStringBuilder appendFormat:@"     \"LastName\":\"%@\", \n", [tech lastName]];
			[jsonStringBuilder appendFormat:@"     \"Email\":\"%@\", \n", [tech email]];
			[jsonStringBuilder appendFormat:@"     \"Phone\":\"%@\", \n", [tech phone]];
			[jsonStringBuilder appendFormat:@"     \"LocationId\":\"%@\", \n", [[tech locationId] lowercaseString]];
			[jsonStringBuilder appendFormat:@"     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[tech createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"     \"EditDate\":\"\\/Date(%.0f)\\/\", \n", [[tech editDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"}"];
		}
        
		[jsonStringBuilder replaceOccurrencesOfString:@"(null)" withString:@"" 
											  options:NSCaseInsensitiveSearch 
												range:NSMakeRange(0, [jsonStringBuilder length])];
        
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

+ (NSString *)arrayToJsonString:(NSMutableArray *)techList
{
	NSMutableString *jsonStringBuilder = nil;
	NSString *jsonString = @"";
	
	@try 
	{
		if(jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		NSEnumerator *enumerator = [techList objectEnumerator];
		
		Tech *currentTech = nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (currentTech = [enumerator nextObject]) 
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [Tech toJsonString:currentTech indent:YES]];
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
	Tech *deserializedTech = nil;
	NSMutableArray *techList = nil;
	
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
			if(techList == nil)
			{
				techList = [[NSMutableArray alloc] init];
			}
			
			for (int i = 0; i < [theObject count]; i++) 
			{
				id currenttech = [theObject objectAtIndex:i];
				
				if(deserializedTech == nil)
				{
					deserializedTech = [[Tech alloc] init];
				}
				
                [deserializedTech setUserId:[[currenttech valueForKey:@"UserId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currenttech valueForKey:@"UserId"] : @""];
				[deserializedTech setUserName:[[currenttech valueForKey:@"UserName"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currenttech valueForKey:@"UserName"] : @""];
				[deserializedTech setHashedPassword:[currenttech valueForKey:@"HashedPassword"]];
				[deserializedTech setFirstName:[currenttech valueForKey:@"FirstName"]];
				[deserializedTech setMiddleName:[currenttech valueForKey:@"MiddleName"]];
				[deserializedTech setLastName:[currenttech valueForKey:@"LastName"]];
				[deserializedTech setEmail:[currenttech valueForKey:@"Email"]];
				[deserializedTech setPhone:[currenttech valueForKey:@"Phone"]];
				[deserializedTech setLocationId:[[currenttech valueForKey:@"LocationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currenttech valueForKey:@"LocationId"] : @""];
				[deserializedTech setCreateDate:[Utility getDateFromJSONDate:[currenttech valueForKey:@"CreateDate"]]];
				[deserializedTech setEditDate:[Utility getDateFromJSONDate:[currenttech valueForKey:@"EditDate"]]];
				
				deserializedTech = nil;
			}
		}
		else
		{
			if(deserializedTech == nil)
			{
				deserializedTech = [[Tech alloc] init];
			}
			
			[deserializedTech setUserId:[[theObject valueForKey:@"UserId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"UserId"] : @""];
			[deserializedTech setUserName:[[theObject valueForKey:@"UserName"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"UserName"] : @""];
			[deserializedTech setHashedPassword:[theObject valueForKey:@"HashedPassword"]];
			[deserializedTech setFirstName:[theObject valueForKey:@"FirstName"]];
			[deserializedTech setMiddleName:[theObject valueForKey:@"MiddleName"]];
			[deserializedTech setLastName:[theObject valueForKey:@"LastName"]];
			[deserializedTech setEmail:[theObject valueForKey:@"Email"]];
			[deserializedTech setPhone:[theObject valueForKey:@"Phone"]];
			[deserializedTech setLocationId:[[theObject valueForKey:@"LocationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"LocationId"] : @""];
			[deserializedTech setCreateDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"CreateDate"]]];
			[deserializedTech setEditDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"EditDate"]]];

            
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in ServiceHelper.fromJsonString - Error: %@", [exception description]);
		
		theObject = nil;
		deserializedTech = nil;
		techList = nil;
	}
	@finally 
	{
		if (workingWithArray == YES) 
		{
			return techList;
		}
		else
		{
			return deserializedTech;
		}
	}
}

@end

