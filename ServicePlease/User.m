//
//  User.m
//  ServicePlease
//
//  Created by Ed Elliott on 2/12/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "User.h"

@implementation User

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
@synthesize userRollId = _userRollId;

+ (NSString *)toJsonString:(User *)user indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"UserId\":\"%@\", \n", [user userId]];
			[jsonStringBuilder appendFormat:@"\t     \"UserName\":\"%@\", \n", [user userName]];
			[jsonStringBuilder appendFormat:@"\t     \"HashedPassword\":\"%@\", \n", [user hashedPassword]];
			[jsonStringBuilder appendFormat:@"\t     \"FirstName\":\"%@\", \n", [user firstName]];
			[jsonStringBuilder appendFormat:@"\t     \"MiddleName\":\"%@\", \n", [user middleName]];
			[jsonStringBuilder appendFormat:@"\t     \"LastName\":\"%@\", \n", [user lastName]];
			[jsonStringBuilder appendFormat:@"\t     \"Email\":\"%@\", \n", [user email]];
			[jsonStringBuilder appendFormat:@"\t     \"Phone\":\"%@\", \n", [user phone]];
			[jsonStringBuilder appendFormat:@"\t     \"LocationId\":\"%@\", \n", [user locationId]];
			[jsonStringBuilder appendFormat:@"\t     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[user createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[user editDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"UserId\":\"%@\", \n", [user userId]];
			[jsonStringBuilder appendFormat:@"     \"UserName\":\"%@\", \n", [user userName]];
			[jsonStringBuilder appendFormat:@"     \"HashedPassword\":\"%@\", \n", [user hashedPassword]];
			[jsonStringBuilder appendFormat:@"     \"FirstName\":\"%@\", \n", [user firstName]];
			[jsonStringBuilder appendFormat:@"     \"MiddleName\":\"%@\", \n", [user middleName]];
			[jsonStringBuilder appendFormat:@"     \"LastName\":\"%@\", \n", [user lastName]];
			[jsonStringBuilder appendFormat:@"     \"Email\":\"%@\", \n", [user email]];
			[jsonStringBuilder appendFormat:@"     \"Phone\":\"%@\", \n", [user phone]];
			[jsonStringBuilder appendFormat:@"     \"LocationId\":\"%@\", \n", [user locationId]];
			[jsonStringBuilder appendFormat:@"     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[user createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[user editDate] timeIntervalSince1970] * 1000];
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

+ (NSString *)arrayToJsonString:(NSMutableArray *)userList
{
	NSMutableString *jsonStringBuilder = nil;
	NSString *jsonString = @"";
	
	@try 
	{
		if(jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		NSEnumerator *enumerator = [userList objectEnumerator];
		
		User *currentUser = nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (currentUser = [enumerator nextObject]) 
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [User toJsonString:currentUser indent:YES]];
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
	User *deserializedUser = nil;
	NSMutableArray *userList = nil;
	
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
			if(userList == nil)
			{
				userList = [[NSMutableArray alloc] init];
			}
			
			for (int i = 0; i < [theObject count]; i++) 
			{
				id currentUser = [theObject objectAtIndex:i];
				
				if(deserializedUser == nil)
				{
					deserializedUser = [[User alloc] init];
				}
				
				[deserializedUser setUserId:[[currentUser valueForKey:@"UserId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentUser valueForKey:@"UserId"] : @""];
				[deserializedUser setUserName:[currentUser valueForKey:@"UserName"]];
				[deserializedUser setHashedPassword:[currentUser valueForKey:@"HashedPassword"]];
				[deserializedUser setFirstName:[currentUser valueForKey:@"FirstName"]];
				[deserializedUser setMiddleName:[currentUser valueForKey:@"MiddleName"]];
				[deserializedUser setLastName:[currentUser valueForKey:@"LastName"]];
				[deserializedUser setEmail:[currentUser valueForKey:@"Email"]];
				[deserializedUser setPhone:[currentUser valueForKey:@"Phone"]];
				[deserializedUser setLocationId:[[currentUser valueForKey:@"LocationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentUser valueForKey:@"LocationId"] : @""];
				[deserializedUser setCreateDate:[Utility getDateFromJSONDate:[currentUser valueForKey:@"CreateDate"]]];
				[deserializedUser setEditDate:[Utility getDateFromJSONDate:[currentUser valueForKey:@"EditDate"]]];
				
				[userList addObject:deserializedUser];
				
				deserializedUser = nil;
			}
		}
		else
		{
			if(deserializedUser == nil)
			{
				deserializedUser = [[User alloc] init];
			}
			
			[deserializedUser setUserId:[[theObject valueForKey:@"UserId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"UserId"] : @""];
			[deserializedUser setUserName:[theObject valueForKey:@"UserName"]];
			[deserializedUser setHashedPassword:[theObject valueForKey:@"HashedPassword"]];
			[deserializedUser setFirstName:[theObject valueForKey:@"FirstName"]];
			[deserializedUser setMiddleName:[theObject valueForKey:@"MiddleName"]];
			[deserializedUser setLastName:[theObject valueForKey:@"LastName"]];
			[deserializedUser setEmail:[theObject valueForKey:@"Email"]];
			[deserializedUser setPhone:[theObject valueForKey:@"Phone"]];
			[deserializedUser setLocationId:[[theObject valueForKey:@"LocationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"LocationId"] : @""];
			[deserializedUser setCreateDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"CreateDate"]]];
			[deserializedUser setEditDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"EditDate"]]];
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in ServiceHelper.fromJsonString - Error: %@", [exception description]);
		
		theObject = nil;
		deserializedUser = nil;
		userList = nil;
	}
	@finally 
	{
		if (workingWithArray == YES) 
		{
			return userList;
		}
		else
		{
			return deserializedUser;
		}
	}
}

@end
