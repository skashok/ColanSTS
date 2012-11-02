//
//  SnoozeReason.m
//  ServiceTech
//
//  Created by colan on 15/10/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "SnoozeReason.h"

@implementation SnoozeReason

@synthesize reasonId = _reasonId;
@synthesize name = _name;
@synthesize createDate = _createDate;
@synthesize editDate = _editDate;

+ (NSString *)toJsonString:(SnoozeReason *)snoozeReason indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"ReasonId\":\"%@\", \n", [snoozeReason reasonId]];
			[jsonStringBuilder appendFormat:@"\t     \"Name\":\"%@\", \n", [snoozeReason name]];
			[jsonStringBuilder appendFormat:@"\t     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[snoozeReason createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[snoozeReason editDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"ReasonId\":\"%@\", \n", [snoozeReason reasonId]];
			[jsonStringBuilder appendFormat:@"     \"Name\":\"%@\", \n", [snoozeReason name]];
			[jsonStringBuilder appendFormat:@"     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[snoozeReason createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[snoozeReason editDate] timeIntervalSince1970] * 1000];
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

+ (NSString *)arrayToJsonString:(NSMutableArray *)_snoozeReasonList
{
	NSMutableString *jsonStringBuilder = nil;
    
	NSString *jsonString = @"";
	
	@try
	{
		if(jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		NSEnumerator *enumerator = [_snoozeReasonList objectEnumerator];
		
		SnoozeReason *snoozeReasonList = nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (snoozeReasonList = [enumerator nextObject])
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [SnoozeReason toJsonString:snoozeReasonList indent:YES]];
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
	SnoozeReason *deserializedSnoozeReason = nil;
    
	NSMutableArray *snoozeReasonList = nil;
	
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
			if(snoozeReasonList == nil)
			{
				snoozeReasonList = [[NSMutableArray alloc] init];
			}
			
			for (int i = 0; i < [theObject count]; i++)
			{
				id currentIntervalType = [theObject objectAtIndex:i];
				
				if(deserializedSnoozeReason == nil)
				{
					deserializedSnoozeReason = [[SnoozeReason alloc] init];
				}
				
				[deserializedSnoozeReason setReasonId:[currentIntervalType valueForKey:@"ReasonId"]];
				[deserializedSnoozeReason setName:[[currentIntervalType valueForKey:@"Name"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentIntervalType valueForKey:@"Name"] : @""];
				[deserializedSnoozeReason setCreateDate:[Utility getDateFromJSONDate:[currentIntervalType valueForKey:@"CreateDate"]]];
				[deserializedSnoozeReason setEditDate:[Utility getDateFromJSONDate:[currentIntervalType valueForKey:@"EditDate"]]];
				
				[snoozeReasonList addObject:deserializedSnoozeReason];
				
				deserializedSnoozeReason = nil;
			}
		}
		else
		{
			if(deserializedSnoozeReason == nil)
			{
				deserializedSnoozeReason = [[SnoozeReason alloc] init];
			}
			
			[deserializedSnoozeReason setReasonId:[theObject valueForKey:@"ReasonId"]];
			[deserializedSnoozeReason setName:[[theObject valueForKey:@"Name"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"Name"] : @""];
			[deserializedSnoozeReason setCreateDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"CreateDate"]]];
			[deserializedSnoozeReason setEditDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"EditDate"]]];
		}
	}
	@catch (NSException *exception)
	{
		//NSLog(@"Error in ServiceHelper.fromJsonString - Error: %@", [exception description]);
		
		theObject = nil;
		deserializedSnoozeReason = nil;
		snoozeReasonList = nil;
	}
	@finally
	{
		if (workingWithArray == YES)
		{
			return snoozeReasonList;
		}
		else
		{
			return deserializedSnoozeReason;
		}
	}
}

@end
