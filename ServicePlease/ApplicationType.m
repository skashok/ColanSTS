//
//  ApplicationType.m
//  ServiceTech
//
//  Created by ColanInfotech on 15/10/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "ApplicationType.h"

@implementation ApplicationType

@synthesize applicationName = _applicationName;
@synthesize applicationTypeId = _applicationTypeId;
@synthesize createDate = _createDate;
@synthesize editDate = _editDate;

+ (NSString *)toJsonString:(ApplicationType *)ApplicationType indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"ApplicationTypeId\":\"%@\", \n", [[ApplicationType applicationTypeId] lowercaseString]];
			[jsonStringBuilder appendFormat:@"\t     \"Name\":\"%@\", \n", [ApplicationType applicationName]];
			[jsonStringBuilder appendFormat:@"\t     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[ApplicationType createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t     \"EditDate\":\"\\/Date(%.0f)\\/\", \n", [[ApplicationType editDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"ApplicationTypeId\":\"%@\", \n", [[ApplicationType applicationTypeId] lowercaseString]];
			[jsonStringBuilder appendFormat:@"     \"Name\":\"%@\", \n", [ApplicationType applicationName]];
			[jsonStringBuilder appendFormat:@"     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[ApplicationType createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"     \"EditDate\":\"\\/Date(%.0f)\\/\", \n", [[ApplicationType editDate] timeIntervalSince1970] * 1000];
						[jsonStringBuilder appendFormat:@"}"];
		}
		
		[jsonStringBuilder replaceOccurrencesOfString:@"\"CategoryIcon\":\"(null)\""
										   withString:@"\"CategoryIcon\":null"
											  options:NSCaseInsensitiveSearch
												range:NSMakeRange(0, [jsonStringBuilder length])];
		
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

+ (NSString *)arrayToJsonString:(NSMutableArray *)applicationList
{
	NSMutableString *jsonStringBuilder = nil;
	NSString *jsonString = @"";
	
	@try
	{
		if(jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		NSEnumerator *enumerator = [applicationList objectEnumerator];
		
		ApplicationType *currentApplicationType = nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (currentApplicationType = [enumerator nextObject])
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [ApplicationType toJsonString:currentApplicationType indent:YES]];
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
	ApplicationType *deserializedApplicationType = nil;
	
    NSMutableArray *aplicationlist = nil;
	
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
			if(aplicationlist == nil)
			{
				aplicationlist = [[NSMutableArray alloc] init];
			}
			
			for (int i = 0; i < [theObject count]; i++)
			{
				id currentApplicationType = [theObject objectAtIndex:i];
				
				if(deserializedApplicationType == nil)
				{
					deserializedApplicationType = [[ApplicationType alloc] init];
				}
				
				[deserializedApplicationType setApplicationTypeId:[currentApplicationType valueForKey:@"ApplicationTypeId"]];
				[deserializedApplicationType setApplicationName:[currentApplicationType valueForKey:@"Name"]];
				[deserializedApplicationType setCreateDate:[Utility getDateFromJSONDate:[currentApplicationType valueForKey:@"CreateDate"]]];
				[deserializedApplicationType setEditDate:[Utility getDateFromJSONDate:[currentApplicationType valueForKey:@"EditDate"]]];
				[aplicationlist addObject:deserializedApplicationType];
				
				deserializedApplicationType = nil;
			}
		}
		else
		{
			if(deserializedApplicationType == nil)
			{
				deserializedApplicationType = [[ApplicationType alloc] init];
			}
			
			[deserializedApplicationType setApplicationTypeId:[theObject valueForKey:@"ApplicationTypeId"]];
			[deserializedApplicationType setApplicationName:[theObject valueForKey:@"Name"]];
			[deserializedApplicationType setCreateDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"CreateDate"]]];
			[deserializedApplicationType setEditDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"EditDate"]]];
		}
	}
	@catch (NSException *exception)
	{
		//NSLog(@"Error in ServiceHelper.fromJsonString - Error: %@", [exception description]);
		
		theObject = nil;
		deserializedApplicationType = nil;
		aplicationlist = nil;
	}
	@finally
	{
		if (workingWithArray == YES)
		{
			return aplicationlist;
		}
		else
		{
			return deserializedApplicationType;
		}
	}
}

@end
