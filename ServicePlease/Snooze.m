//
//  Snooze.m
//  ServiceTech
//
//  Created by Apple on 28/09/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "Snooze.h"

@implementation Snooze

@synthesize snoozeId = _snoozeId;
@synthesize ticketId = _ticketId;
@synthesize reasonId = _reasonId;
@synthesize isCompleted = _isCompleted;
@synthesize completedDate = _completedDate;
@synthesize isDateInterval = _isDateInterval;
@synthesize isQuickShare = _isQuickShare;
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize snoozeInterval = _snoozeInterval;
@synthesize intervalTypeId = _intervalTypeId;
@synthesize createDate = _createDate;
@synthesize editDate = _editDate;

+ (NSString *)toJsonString:(Snooze *)snooze indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"SnoozeId\":\"%@\", \n", [snooze snoozeId]];
			[jsonStringBuilder appendFormat:@"\t     \"TicketId\":\"%@\", \n", [snooze ticketId]];
			[jsonStringBuilder appendFormat:@"\t     \"ReasonId\":\"%@\", \n", [snooze reasonId]];
			[jsonStringBuilder appendFormat:@"\t     \"IsCompleted\":%@, \n", ([[snooze isCompleted] boolValue]) ? @"true" : @"false"];
            [jsonStringBuilder appendFormat:@"\t     \"CompletedDate\":\"\\/Date(%@)\\/\", \n", [snooze completedDate]];
			[jsonStringBuilder appendFormat:@"\t     \"IsDateInterval\":%@, \n", ([[snooze isDateInterval]boolValue]) ? @"true" : @"false"];
			[jsonStringBuilder appendFormat:@"\t     \"IsQuickShare\":%@, \n",([[snooze isQuickShare]boolValue]) ? @"true" : @"false"];
			[jsonStringBuilder appendFormat:@"\t     \"StartDate\":\"\\/Date(%@)\\/\", \n", [snooze startDate]];
			[jsonStringBuilder appendFormat:@"\t     \"EndDate\":\"\\/Date(%@)\\/\", \n", [snooze endDate]];
			[jsonStringBuilder appendFormat:@"\t     \"SnoozeInterval\":%d, \n", [snooze snoozeInterval]];
			[jsonStringBuilder appendFormat:@"\t     \"IntervalTypeId\":\"%@\", \n", [snooze intervalTypeId]];
			[jsonStringBuilder appendFormat:@"\t     \"CreateDate\":\"\\/Date(%@)\\/\", \n", [snooze createDate]];
			[jsonStringBuilder appendFormat:@"\t     \"EditDate\":\"\\/Date(%@)\\/\" \n", [snooze editDate]];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"  \"SnoozeId\": \"%@\",\n", [snooze snoozeId]];
			[jsonStringBuilder appendFormat:@"  \"TicketId\": \"%@\",\n", [snooze ticketId]];
			[jsonStringBuilder appendFormat:@"  \"ReasonId\": \"%@\",\n", [snooze reasonId]];
			[jsonStringBuilder appendFormat:@"  \"IsCompleted\": %@,\n", ([[snooze isCompleted] boolValue]) ? @"true" : @"false"];
            [jsonStringBuilder appendFormat:@"  \"CompletedDate\": \"\\/Date(%@)\\/\",\n", [snooze completedDate] ];
			[jsonStringBuilder appendFormat:@"  \"IsDateInterval\": %@,\n", ([[snooze isDateInterval]boolValue]) ? @"true" : @"false"];
			[jsonStringBuilder appendFormat:@"  \"IsQuickShare\": %@,\n", ([[snooze isQuickShare]boolValue]) ? @"true" : @"false"];
			[jsonStringBuilder appendFormat:@"  \"StartDate\": \"\\/Date(%@)\\/\",\n", [snooze startDate] ];
			[jsonStringBuilder appendFormat:@"  \"EndDate\": \"\\/Date(%@)\\/\",\n", [snooze endDate] ];
			[jsonStringBuilder appendFormat:@"  \"SnoozeInterval\": %d,\n", [snooze snoozeInterval]];
			[jsonStringBuilder appendFormat:@"  \"IntervalTypeId\": \"%@\",\n", [snooze intervalTypeId]];
			[jsonStringBuilder appendFormat:@"  \"CreateDate\": \"\\/Date(%@)\\/\",\n", [snooze createDate] ];
			[jsonStringBuilder appendFormat:@"  \"EditDate\": \"\\/Date(%@)\\/\"\n", [snooze editDate]];
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

+ (NSString *)arrayToJsonString:(NSMutableArray *)snoozeList
{
	NSMutableString *jsonStringBuilder = nil;
	NSString *jsonString = @"";
	
	@try 
	{
		if(jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		NSEnumerator *enumerator = [snoozeList objectEnumerator];
		
		Snooze  *currentSnooze = nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (currentSnooze = [enumerator nextObject]) 
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [Snooze toJsonString:currentSnooze indent:YES]];
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
	Snooze *deserializedSnooze = nil;
    
	NSMutableArray *snoozeList = nil;
	
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
			if(snoozeList == nil)
			{
				snoozeList = [[NSMutableArray alloc] init];
			}
			
			for (int i = 0; i < [theObject count]; i++) 
			{
				id currentProblem = [theObject objectAtIndex:i];
				
				if(deserializedSnooze == nil)
				{
					deserializedSnooze = [[Snooze alloc] init];
				}
				
				[deserializedSnooze setSnoozeId:[currentProblem valueForKey:@"SnoozeId"]];
				[deserializedSnooze setTicketId:[[currentProblem valueForKey:@"TicketId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentProblem valueForKey:@"TicketId"] : @""];
				[deserializedSnooze setReasonId:[currentProblem valueForKey:@"ReasonId"]];
				[deserializedSnooze setIsCompleted:[currentProblem valueForKey:@"IsCompleted"] ];
                [deserializedSnooze setCompletedDate:[currentProblem valueForKey:@"CompletedDate"]];
				[deserializedSnooze setIsDateInterval:[currentProblem valueForKey:@"IsDateInterval"]];
				[deserializedSnooze setIsQuickShare:[currentProblem valueForKey:@"IsQuickShare"]];
				[deserializedSnooze setStartDate:[currentProblem valueForKey:@"StartDate"]];
				[deserializedSnooze setEndDate:[currentProblem valueForKey:@"EditDate"]];
				[deserializedSnooze setSnoozeInterval:[[currentProblem valueForKey:@"SnoozeInterval"] intValue]];
				[deserializedSnooze setIntervalTypeId:[currentProblem valueForKey:@"IntervalTypeId"]];
                
				[deserializedSnooze setCreateDate:[currentProblem valueForKey:@"CreateDate"]];
				[deserializedSnooze setEditDate:[currentProblem valueForKey:@"EndDate"]];
				
				[snoozeList addObject:deserializedSnooze];
				
				deserializedSnooze = nil;
			}
		}
		else
		{
			if(deserializedSnooze == nil)
			{
				deserializedSnooze = [[Snooze alloc] init];
			}
			
			[deserializedSnooze setSnoozeId:[theObject valueForKey:@"SnoozeId"]];
			[deserializedSnooze setTicketId:[[theObject valueForKey:@"TicketId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"TicketId"] : @""];
			[deserializedSnooze setReasonId:[theObject valueForKey:@"ReasonId"]];
			[deserializedSnooze setIsCompleted:[theObject valueForKey:@"IsCompleted"]];
            [deserializedSnooze setCompletedDate:[theObject valueForKey:@"CompletedDate"]];
			[deserializedSnooze setIsDateInterval:[theObject valueForKey:@"IsDateInterval"]];
			[deserializedSnooze setIsQuickShare:[theObject valueForKey:@"IsQuickShare"]];
			[deserializedSnooze setStartDate:[theObject valueForKey:@"StartDate"]];
			[deserializedSnooze setEndDate:[theObject valueForKey:@"EndDate"]];
			[deserializedSnooze setSnoozeInterval:[[theObject valueForKey:@"SnoozeInterval"] intValue]];
			[deserializedSnooze setIntervalTypeId:[theObject valueForKey:@"IntervalTypeId"]];
			[deserializedSnooze setCreateDate:[theObject valueForKey:@"CreateDate"]];
			[deserializedSnooze setEditDate:[theObject valueForKey:@"EditDate"]];
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in ServiceHelper.fromJsonString - Error: %@", [exception description]);
		
		theObject = nil;
		deserializedSnooze = nil;
		snoozeList = nil;
	}
	@finally 
	{
		if (workingWithArray == YES) 
		{
			return snoozeList;
		}
		else
		{
			return deserializedSnooze;
		}
	}
}


+ (NSString *)updateJsonString:(Snooze *)snooze indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"SnoozeId\":\"%@\", \n", [snooze snoozeId]];
			[jsonStringBuilder appendFormat:@"\t     \"TicketId\":\"%@\", \n", [snooze ticketId]];
			[jsonStringBuilder appendFormat:@"\t     \"ReasonId\":\"%@\", \n", [snooze reasonId]];
			[jsonStringBuilder appendFormat:@"\t     \"IsCompleted\":%@, \n", ([[snooze isCompleted] boolValue]) ? @"true" : @"false"];
            [jsonStringBuilder appendFormat:@"\t     \"CompletedDate\":\"%@\", \n", [snooze completedDate]];
			[jsonStringBuilder appendFormat:@"\t     \"IsDateInterval\":%@, \n", ([[snooze isDateInterval]boolValue]) ? @"true" : @"false"];
			[jsonStringBuilder appendFormat:@"\t     \"IsQuickShare\":%@, \n",([[snooze isQuickShare]boolValue]) ? @"true" : @"false"];
			[jsonStringBuilder appendFormat:@"\t     \"StartDate\":\"%@\", \n", [snooze startDate]];
			[jsonStringBuilder appendFormat:@"\t     \"EndDate\":\"%@\", \n", [snooze endDate]];
			[jsonStringBuilder appendFormat:@"\t     \"SnoozeInterval\":%d, \n", [snooze snoozeInterval]];
			[jsonStringBuilder appendFormat:@"\t     \"IntervalTypeId\":\"%@\", \n", [snooze intervalTypeId]];
			[jsonStringBuilder appendFormat:@"\t     \"CreateDate\":\"%@\", \n", [snooze createDate]];
			[jsonStringBuilder appendFormat:@"\t     \"EditDate\":\"%@\" \n", [snooze editDate]];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"  \"SnoozeId\": \"%@\",\n", [snooze snoozeId]];
			[jsonStringBuilder appendFormat:@"  \"TicketId\": \"%@\",\n", [snooze ticketId]];
			[jsonStringBuilder appendFormat:@"  \"ReasonId\": \"%@\",\n", [snooze reasonId]];
			[jsonStringBuilder appendFormat:@"  \"IsCompleted\": %@,\n", ([[snooze isCompleted] boolValue]) ? @"true" : @"false"];
            [jsonStringBuilder appendFormat:@"  \"CompletedDate\": \"%@\",\n", [snooze completedDate] ];
			[jsonStringBuilder appendFormat:@"  \"IsDateInterval\": %@,\n", ([[snooze isDateInterval]boolValue]) ? @"true" : @"false"];
			[jsonStringBuilder appendFormat:@"  \"IsQuickShare\": %@,\n", ([[snooze isQuickShare]boolValue]) ? @"true" : @"false"];
			[jsonStringBuilder appendFormat:@"  \"StartDate\": \"%@\",\n", [snooze startDate] ];
			[jsonStringBuilder appendFormat:@"  \"EndDate\": \"%@\",\n", [snooze endDate] ];
			[jsonStringBuilder appendFormat:@"  \"SnoozeInterval\": %d,\n", [snooze snoozeInterval]];
			[jsonStringBuilder appendFormat:@"  \"IntervalTypeId\": \"%@\",\n", [snooze intervalTypeId]];
			[jsonStringBuilder appendFormat:@"  \"CreateDate\": \"%@\",\n", [snooze createDate] ];
			[jsonStringBuilder appendFormat:@"  \"EditDate\": \"%@\"\n", [snooze editDate]];
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

@end
