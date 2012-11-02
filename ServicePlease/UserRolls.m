//

#import "UserRolls.h"

@implementation UserRolls

@synthesize RoleID=RoleID;
@synthesize Name=_Name;
@synthesize CreateDate=_CreateDate;
@synthesize EditDate=_EditDate;


+ (NSString *)toJsonString:(UserRolls *)rollid indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"RoleID\":\"%@\", \n", [rollid RoleID]];
			[jsonStringBuilder appendFormat:@"\t     \"UserName\":\"%@\", \n", [rollid Name]];
			
            [jsonStringBuilder appendFormat:@"\t     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[rollid CreateDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[rollid EditDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
            [jsonStringBuilder appendFormat:@"\t{ \n"];
			[jsonStringBuilder appendFormat:@"\t     \"RoleID\":\"%@\", \n", [rollid RoleID]];
			[jsonStringBuilder appendFormat:@"\t     \"UserName\":\"%@\", \n", [rollid Name]];
            
            [jsonStringBuilder appendFormat:@"     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[rollid CreateDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[rollid EditDate] timeIntervalSince1970] * 1000];
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


+ (NSString *)arrayToJsonString:(NSMutableArray *)RollIdList
{
	NSMutableString *jsonStringBuilder = nil;
	NSString *jsonString = @"";
	
	@try 
	{
		if(jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		NSEnumerator *enumerator = [RollIdList objectEnumerator];
        
        UserRolls *currenRollId=nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (currenRollId = [enumerator nextObject]) 
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [UserRolls toJsonString:currenRollId indent:YES]];
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
	UserRolls *deserializedUser = nil;
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
					deserializedUser = [[UserRolls alloc] init];
				}
				
				[deserializedUser setRoleID:[[currentUser valueForKey:@"RoleId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentUser valueForKey:@"RoleId"] : @""];
				
                [deserializedUser setName:[currentUser valueForKey:@"Name"]];
				
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
				deserializedUser = [[UserRolls alloc] init];
			}
			
			[deserializedUser setRoleID:[[theObject valueForKey:@"RoleId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"UserId"] : @""];
			[deserializedUser setName:[theObject valueForKey:@"UserName"]];
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
