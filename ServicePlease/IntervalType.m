//
//  intervalType.m
//  ServiceTech
//
//  Created by colan on 15/10/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "IntervalType.h"

@implementation IntervalType

@synthesize intervalTypeId = _intervalTypeId;
@synthesize name = _name;
@synthesize createDate = _createDate;
@synthesize editDate = _editDate;

+ (NSString *)toJsonString:(IntervalType *)intervalType indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"IntervalTypeId\":\"%@\", \n", [intervalType intervalTypeId]];
			[jsonStringBuilder appendFormat:@"\t     \"Name\":\"%@\", \n", [intervalType name]];
			[jsonStringBuilder appendFormat:@"\t     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[intervalType createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[intervalType editDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"IntervalTypeId\":\"%@\", \n", [intervalType intervalTypeId]];
			[jsonStringBuilder appendFormat:@"     \"Name\":\"%@\", \n", [intervalType name]];
			[jsonStringBuilder appendFormat:@"     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[intervalType createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[intervalType editDate] timeIntervalSince1970] * 1000];
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

+ (NSString *)arrayToJsonString:(NSMutableArray *)_intervalTypeList
{
	NSMutableString *jsonStringBuilder = nil;
    
	NSString *jsonString = @"";
	
	@try
	{
		if(jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		NSEnumerator *enumerator = [_intervalTypeList objectEnumerator];
		
		IntervalType *intervalTypeList = nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (intervalTypeList = [enumerator nextObject])
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [IntervalType toJsonString:intervalTypeList indent:YES]];
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
	IntervalType *deserializedIntervalType = nil;
    
	NSMutableArray *intervalTypeList = nil;
	
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
			if(intervalTypeList == nil)
			{
				intervalTypeList = [[NSMutableArray alloc] init];
			}
			
			for (int i = 0; i < [theObject count]; i++)
			{
				id currentIntervalType = [theObject objectAtIndex:i];
				
				if(deserializedIntervalType == nil)
				{
					deserializedIntervalType = [[IntervalType alloc] init];
				}
				
				[deserializedIntervalType setIntervalTypeId:[currentIntervalType valueForKey:@"IntervalTypeId"]];
				[deserializedIntervalType setName:[[currentIntervalType valueForKey:@"Name"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentIntervalType valueForKey:@"Name"] : @""];
				[deserializedIntervalType setCreateDate:[Utility getDateFromJSONDate:[currentIntervalType valueForKey:@"CreateDate"]]];
				[deserializedIntervalType setEditDate:[Utility getDateFromJSONDate:[currentIntervalType valueForKey:@"EditDate"]]];
				
				[intervalTypeList addObject:deserializedIntervalType];
				
				deserializedIntervalType = nil;
			}
		}
		else
		{
			if(deserializedIntervalType == nil)
			{
				deserializedIntervalType = [[IntervalType alloc] init];
			}
			
			[deserializedIntervalType setIntervalTypeId:[theObject valueForKey:@"IntervalTypeId"]];
			[deserializedIntervalType setName:[[theObject valueForKey:@"Name"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"Name"] : @""];
			[deserializedIntervalType setCreateDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"CreateDate"]]];
			[deserializedIntervalType setEditDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"EditDate"]]];
		}
	}
	@catch (NSException *exception)
	{
		//NSLog(@"Error in ServiceHelper.fromJsonString - Error: %@", [exception description]);
		
		theObject = nil;
		deserializedIntervalType = nil;
		intervalTypeList = nil;
	}
	@finally
	{
		if (workingWithArray == YES)
		{
			return intervalTypeList;
		}
		else
		{
			return deserializedIntervalType;
		}
	}
}

@end
