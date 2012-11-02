//
//  Problem.m
//  ServicePlease
//
//  Created by Ed Elliott on 2/9/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "Problem.h"

@implementation Problem

@synthesize problemId = _problemId;
@synthesize ticketId = _ticketId;
@synthesize problemShortDesc = _problemShortDesc;
@synthesize problemText = _problemText;
@synthesize createDate = _createDate;
@synthesize editDate = _editDate;

+ (NSString *)toJsonString:(Problem *)problem indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"ProblemId\":\"%@\", \n", [problem problemId]];
			[jsonStringBuilder appendFormat:@"\t     \"TicketId\":\"%@\", \n", [problem ticketId]];
			[jsonStringBuilder appendFormat:@"\t     \"ProblemShortDesc\":\"%@\", \n", [problem problemShortDesc]];
			[jsonStringBuilder appendFormat:@"\t     \"ProblemText\":\"%@\", \n", [problem problemText]];
			[jsonStringBuilder appendFormat:@"\t     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[problem createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[problem editDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"ProblemId\":\"%@\", \n", [problem problemId]];
			[jsonStringBuilder appendFormat:@"     \"TicketId\":\"%@\", \n", [problem ticketId]];
			[jsonStringBuilder appendFormat:@"     \"ProblemShortDesc\":\"%@\", \n", [problem problemShortDesc]];
			[jsonStringBuilder appendFormat:@"     \"ProblemText\":\"%@\", \n", [problem problemText]];
			[jsonStringBuilder appendFormat:@"     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[problem createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[problem editDate] timeIntervalSince1970] * 1000];
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

+ (NSString *)arrayToJsonString:(NSMutableArray *)problemList
{
	NSMutableString *jsonStringBuilder = nil;
	NSString *jsonString = @"";
	
	@try 
	{
		if(jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		NSEnumerator *enumerator = [problemList objectEnumerator];
		
		Problem *currentProblem = nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (currentProblem = [enumerator nextObject]) 
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [Problem toJsonString:currentProblem indent:YES]];
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
	Problem *deserializedProblem = nil;
	NSMutableArray *problemList = nil;
	
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
			if(problemList == nil)
			{
				problemList = [[NSMutableArray alloc] init];
			}
			
			for (int i = 0; i < [theObject count]; i++) 
			{
				id currentProblem = [theObject objectAtIndex:i];
				
				if(deserializedProblem == nil)
				{
					deserializedProblem = [[Problem alloc] init];
				}
				
				[deserializedProblem setProblemId:[currentProblem valueForKey:@"ProblemId"]];
				[deserializedProblem setTicketId:[[currentProblem valueForKey:@"TicketId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentProblem valueForKey:@"TicketId"] : @""];
				[deserializedProblem setProblemShortDesc:[currentProblem valueForKey:@"ProblemShortDesc"]];
				[deserializedProblem setProblemText:[currentProblem valueForKey:@"ProblemText"]];
				[deserializedProblem setCreateDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"CreateDate"]]];
				[deserializedProblem setEditDate:[Utility getDateFromJSONDate:[currentProblem valueForKey:@"EditDate"]]];
				
				[problemList addObject:deserializedProblem];
				
				deserializedProblem = nil;
			}
		}
		else
		{
			if(deserializedProblem == nil)
			{
				deserializedProblem = [[Problem alloc] init];
			}
			
			[deserializedProblem setProblemId:[theObject valueForKey:@"ProblemId"]];
			[deserializedProblem setTicketId:[[theObject valueForKey:@"TicketId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"TicketId"] : @""];
			[deserializedProblem setProblemShortDesc:[theObject valueForKey:@"ProblemShortDesc"]];
			[deserializedProblem setProblemText:[theObject valueForKey:@"ProblemText"]];
			[deserializedProblem setCreateDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"CreateDate"]]];
			[deserializedProblem setEditDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"EditDate"]]];
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in ServiceHelper.fromJsonString - Error: %@", [exception description]);
		
		theObject = nil;
		deserializedProblem = nil;
		problemList = nil;
	}
	@finally 
	{
		if (workingWithArray == YES) 
		{
			return problemList;
		}
		else
		{
			return deserializedProblem;
		}
	}
}

@end
