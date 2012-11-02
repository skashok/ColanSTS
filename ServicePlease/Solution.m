//
//  Solution.m
//  ServicePlease
//
//  Created by Ed Elliott on 2/9/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "Solution.h"

@implementation Solution

@synthesize solutionId = _solutionId;
@synthesize ticketId = _ticketId;
@synthesize solutionShortDesc = _solutionShortDesc;
@synthesize solutionText = _solutionText;
@synthesize likeCount = _likeCount;
@synthesize unlikeCount = _unlikeCount;
@synthesize createDate = _createDate;
@synthesize editDate = _editDate;

+ (NSString *)toJsonString:(Solution *)solution indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"SolutionId\":\"%@\", \n", [solution solutionId]];
			[jsonStringBuilder appendFormat:@"\t     \"TicketId\":\"%@\", \n", [solution ticketId]];
			[jsonStringBuilder appendFormat:@"\t     \"SolutionShortDesc\":\"%@\", \n", [solution solutionShortDesc]];
			[jsonStringBuilder appendFormat:@"\t     \"LikeCount\":%d, \n", [solution likeCount]];
            [jsonStringBuilder appendFormat:@"\t     \"UnlikeCount\":%d, \n", [solution unlikeCount]];
			[jsonStringBuilder appendFormat:@"\t     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[solution createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[solution editDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"SolutionId\":\"%@\", \n", [solution solutionId]];
			[jsonStringBuilder appendFormat:@"     \"TicketId\":\"%@\", \n", [solution ticketId]];
			[jsonStringBuilder appendFormat:@"     \"SolutionShortDesc\":\"%@\", \n", [solution solutionShortDesc]];
			[jsonStringBuilder appendFormat:@"     \"SolutionText\":\"%@\", \n", [solution solutionText]];
            [jsonStringBuilder appendFormat:@"     \"LikeCount\":%d, \n", [solution likeCount]];
			[jsonStringBuilder appendFormat:@"     \"UnlikeCount\":%d, \n", [solution unlikeCount]];
			[jsonStringBuilder appendFormat:@"     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[solution createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[solution editDate] timeIntervalSince1970] * 1000];
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

+ (NSString *)arrayToJsonString:(NSMutableArray *)solutionList
{
	NSMutableString *jsonStringBuilder = nil;
	NSString *jsonString = @"";
	
	@try 
	{
		if(jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		NSEnumerator *enumerator = [solutionList objectEnumerator];
		
		Solution *currentSolution = nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (currentSolution = [enumerator nextObject]) 
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [Solution toJsonString:currentSolution indent:YES]];
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
	Solution *deserializedSolution = nil;
	NSMutableArray *solutionList = nil;
	
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
			if(solutionList == nil)
			{
				solutionList = [[NSMutableArray alloc] init];
			}
			
			for (int i = 0; i < [theObject count]; i++) 
			{
				id currentSolution = [theObject objectAtIndex:i];
				
				if(deserializedSolution == nil)
				{
					deserializedSolution = [[Solution alloc] init];
				}
				
				[deserializedSolution setSolutionId:[currentSolution valueForKey:@"SolutionId"]];
				[deserializedSolution setTicketId:[[currentSolution valueForKey:@"TicketId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentSolution valueForKey:@"TicketId"] : @""];
				[deserializedSolution setSolutionShortDesc:[[currentSolution valueForKey:@"SolutionShortDesc"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentSolution valueForKey:@"SolutionShortDesc"] : @""];
				[deserializedSolution setSolutionText:[[currentSolution valueForKey:@"SolutionText"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentSolution valueForKey:@"SolutionText"] : @""];
                [deserializedSolution setLikeCount:[[currentSolution valueForKey:@"LikeCount"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [[currentSolution valueForKey:@"LikeCount"] intValue] : 0];
				[deserializedSolution setUnlikeCount:[[currentSolution valueForKey:@"SolutionText"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [[currentSolution valueForKey:@"SolutionText"] intValue] : 0];
				[deserializedSolution setCreateDate:[Utility getDateFromJSONDate:[currentSolution valueForKey:@"CreateDate"]]];
				[deserializedSolution setEditDate:[Utility getDateFromJSONDate:[currentSolution valueForKey:@"EditDate"]]];
				
				[solutionList addObject:deserializedSolution];
				
				deserializedSolution = nil;
			}
		}
		else
		{
			if(deserializedSolution == nil)
			{
				deserializedSolution = [[Solution alloc] init];
			}
						
			[deserializedSolution setSolutionId:[theObject valueForKey:@"SolutionId"]];
			[deserializedSolution setTicketId:[[theObject valueForKey:@"TicketId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"TicketId"] : @""];
			[deserializedSolution setSolutionShortDesc:[[theObject valueForKey:@"SolutionShortDesc"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"SolutionShortDesc"] : @""];
			[deserializedSolution setSolutionText:[[theObject valueForKey:@"SolutionText"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"SolutionText"] : @""];
            [deserializedSolution setLikeCount:[[theObject valueForKey:@"LikeCount"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [[theObject valueForKey:@"LikeCount"] intValue] : 0];
			[deserializedSolution setUnlikeCount:[[theObject valueForKey:@"UnlikeCount"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [[theObject valueForKey:@"UnlikeCount"] intValue] : 0];
			[deserializedSolution setCreateDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"CreateDate"]]];
			[deserializedSolution setEditDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"EditDate"]]];
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in ServiceHelper.fromJsonString - Error: %@", [exception description]);
		
		theObject = nil;
		deserializedSolution = nil;
		solutionList = nil;
	}
	@finally 
	{
		if (workingWithArray == YES) 
		{
			return solutionList;
		}
		else
		{
			return deserializedSolution;
		}
	}
}

@end
