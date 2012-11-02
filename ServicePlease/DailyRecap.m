//
//  DailyRecap.m
//  ServiceTech
//
//  Created by ColanInfotech on 01/11/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "DailyRecap.h"

@implementation DailyRecap



+ (NSString *)toJsonString:(DailyRecap *)DailyRecap indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"RecapSettingId\":\"%@\", \n", [[DailyRecap recapSettingId] lowercaseString]];
            [jsonStringBuilder appendFormat:@"\t     \"Name\":\"%@\", \n", [DailyRecap name]];
            [jsonStringBuilder appendFormat:@"\t     \"BroadcastTime\":\"%@\", \n", [DailyRecap broadcastTime]];
		    [jsonStringBuilder appendFormat:@"\t     \"RecapSettingDay\":\"%@\", \n", [DailyRecap recapSettingDay]];
		    [jsonStringBuilder appendFormat:@"\t     \"StartTime\":\"%@\", \n", [DailyRecap startTime]];
            [jsonStringBuilder appendFormat:@"\t     \"EndTime\":\"%@\", \n", [DailyRecap endTime]];
            [jsonStringBuilder appendFormat:@"\t     \"RecapMail\":\"%@\", \n", [DailyRecap recapMail]];
            [jsonStringBuilder appendFormat:@"\t     \"RecapSettingLocation\":\"%@\", \n", [DailyRecap recapSettingLocation]];
            [jsonStringBuilder appendFormat:@"\t     \"Active\":\"%@\", \n", [DailyRecap active]];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"RecapSettingId\":\"%@\", \n", [[DailyRecap recapSettingId] lowercaseString]];
			[jsonStringBuilder appendFormat:@"     \"Name\":\"%@\", \n", [DailyRecap name]];
         	[jsonStringBuilder appendFormat:@"     \"BroadcastTime\":\"%@\", \n", [DailyRecap broadcastTime]];
			[jsonStringBuilder appendFormat:@"     \"RecapSettingDay\":\"%@\", \n", [DailyRecap recapSettingDay]];
            [jsonStringBuilder appendFormat:@"     \"StartTime\":\"%@\", \n", [DailyRecap startTime]];
            [jsonStringBuilder appendFormat:@"     \"EndTime\":\"%@\", \n", [DailyRecap endTime]];
            [jsonStringBuilder appendFormat:@"     \"RecapMail\":\"%@\", \n", [DailyRecap recapMail]];
            [jsonStringBuilder appendFormat:@"     \"RecapSettingLocation\":\"%@\", \n", [DailyRecap recapSettingLocation]];
            [jsonStringBuilder appendFormat:@"     \"Active\":\"%@\", \n", [DailyRecap active]]; 
            [jsonStringBuilder appendFormat:@"}"];
		}
		
        [jsonStringBuilder replaceOccurrencesOfString:@"(null)"
										   withString:@""
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

+ (NSString *)arrayToJsonString:(NSMutableArray *)dailyRecapList
{
	NSMutableString *jsonStringBuilder = nil;
	NSString *jsonString = @"";
	
	@try
	{
		if(jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		NSEnumerator *enumerator = [dailyRecapList objectEnumerator];
		
		DailyRecap *currentDailyRecap = nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (currentDailyRecap = [enumerator nextObject])
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [DailyRecap toJsonString:currentDailyRecap indent:YES]];
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
	DailyRecap *deserializeddailyRecap = nil;
	
    NSMutableArray *dailRecaplist = nil;
	
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
			if(dailRecaplist == nil)
			{
				dailRecaplist = [[NSMutableArray alloc] init];
			}
			
			for (int i = 0; i < [theObject count]; i++)
			{
				id currentdailyRecap = [theObject objectAtIndex:i];
				
				if(deserializeddailyRecap == nil)
				{
					deserializeddailyRecap = [[DailyRecap alloc] init];
				}

                [deserializeddailyRecap setRecapSettingId:[currentdailyRecap valueForKey:@"RecapSettingId"]];
			   [deserializeddailyRecap setName:[currentdailyRecap valueForKey:@"Name"]];
               [deserializeddailyRecap setBroadcastTime:[currentdailyRecap valueForKey:@"BroadcastTime"]];
               [deserializeddailyRecap setRecapSettingDay:[currentdailyRecap valueForKey:@"RecapSettingDay"]];
			   [deserializeddailyRecap setStartTime:[currentdailyRecap valueForKey:@"StartTime"]];
               [deserializeddailyRecap setEndTime:[currentdailyRecap valueForKey:@"EndTime"]];
               [deserializeddailyRecap setRecapMail:[currentdailyRecap valueForKey:@"RecapMail"]];
               [deserializeddailyRecap setRecapSettingLocation:[currentdailyRecap valueForKey:@"RecapSettingLocation"]];
               [deserializeddailyRecap setActive:[currentdailyRecap valueForKey:@"Active"]];
               [dailRecaplist addObject:deserializeddailyRecap];
				
				deserializeddailyRecap = nil;
			}
		}
		else
		{
			if(deserializeddailyRecap == nil)
			{
				deserializeddailyRecap = [[DailyRecap alloc] init];
			}
			
			[deserializeddailyRecap setRecapSettingId:[theObject valueForKey:@"RecapSettingId"]];
            [deserializeddailyRecap setName:[theObject valueForKey:@"Name"]];
            [deserializeddailyRecap setBroadcastTime:[theObject valueForKey:@"BroadcastTime"]];
            [deserializeddailyRecap setRecapSettingDay:[theObject  valueForKey:@"RecapSettingDay"]];
            [deserializeddailyRecap setStartTime:[theObject  valueForKey:@"StartTime"]];
            [deserializeddailyRecap setEndTime:[theObject  valueForKey:@"EndTime"]];
            [deserializeddailyRecap setRecapMail:[theObject  valueForKey:@"RecapMail"]];
            [deserializeddailyRecap setRecapSettingLocation:[theObject valueForKey:@"RecapSettingLocation"]];
            [deserializeddailyRecap setActive:[theObject  valueForKey:@"Active"]];
		}
	}
	@catch (NSException *exception)
	{
		//NSLog(@"Error in ServiceHelper.fromJsonString - Error: %@", [exception description]);
		
		theObject = nil;
		deserializeddailyRecap = nil;
		dailRecaplist = nil;
	}
	@finally
	{
		if (workingWithArray == YES)
		{
			return dailRecaplist;
		}
		else
		{
			return deserializeddailyRecap;
		}
	}
}
@end
