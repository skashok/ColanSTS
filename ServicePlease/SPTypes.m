//
//  ServicePlanTypes.m
//  ServicePlease
//
//  Created by Apple on 04/07/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "SPTypes.h"

@implementation SPTypes

@synthesize servicePlanTypeId = _servicePlanTypeId;
@synthesize name = _name;
@synthesize createDate = _createDate;
@synthesize editDate = _editDate;

+ (NSString *)toJsonString:(SPTypes *)ServicePlanTypes indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"ServicePlanTypeId\":\"%@\", \n", [[ServicePlanTypes servicePlanTypeId] lowercaseString]];
			[jsonStringBuilder appendFormat:@"\t     \"Name\":\"%@\", \n", [[ServicePlanTypes name] lowercaseString]];
			[jsonStringBuilder appendFormat:@"\t     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[ServicePlanTypes createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[ServicePlanTypes editDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"ServicePlanTypeId\":\"%@\", \n", [[ServicePlanTypes servicePlanTypeId] lowercaseString]];
			[jsonStringBuilder appendFormat:@"     \"Name\":\"%@\", \n", [[ServicePlanTypes name] lowercaseString]];
			[jsonStringBuilder appendFormat:@"     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[ServicePlanTypes createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[ServicePlanTypes editDate] timeIntervalSince1970] * 1000];
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

+ (NSString *)arrayToJsonString:(NSMutableArray *)ServicePlanTypesList
{
	NSMutableString *jsonStringBuilder = nil;
	NSString *jsonString = @"";
	
	@try 
	{
		if(jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		NSEnumerator *enumerator = [ServicePlanTypesList objectEnumerator];
		
		SPTypes *currentServicePlanTypes = nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (currentServicePlanTypes = [enumerator nextObject]) 
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [SPTypes toJsonString:currentServicePlanTypes indent:YES]];
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
	SPTypes *deserializedServicePlanTypes = nil;
    
	NSMutableArray *ServicePlanTypesList = nil;
	
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
			if(ServicePlanTypesList == nil)
			{
				ServicePlanTypesList = [[NSMutableArray alloc] init];
			}
			
			for (int i = 0; i < [theObject count]; i++) 
			{
				id currentServicePlanType = [theObject objectAtIndex:i];
				
				if(deserializedServicePlanTypes == nil)
				{
					deserializedServicePlanTypes = [[SPTypes alloc] init];
				}
				
		
                [deserializedServicePlanTypes setServicePlanTypeId:[currentServicePlanType valueForKey:@"ServicePlanTypeId"]];
				[deserializedServicePlanTypes setName:[currentServicePlanType valueForKey:@"Name"]];
				[deserializedServicePlanTypes setCreateDate:[Utility getDateFromJSONDate:[currentServicePlanType valueForKey:@"CreateDate"]]];
				[deserializedServicePlanTypes setEditDate:[Utility getDateFromJSONDate:[currentServicePlanType valueForKey:@"EditDate"]]];
				
				[ServicePlanTypesList addObject:deserializedServicePlanTypes];
				
				deserializedServicePlanTypes = nil;
			}
		}
		else
		{
			if(deserializedServicePlanTypes == nil)
			{
				deserializedServicePlanTypes = [[SPTypes alloc] init];
			}
			
			[deserializedServicePlanTypes setServicePlanTypeId:[theObject valueForKey:@"ServicePlanTypeId"]];
			[deserializedServicePlanTypes setName:[theObject valueForKey:@"Name"]];
			[deserializedServicePlanTypes setCreateDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"CreateDate"]]];
			[deserializedServicePlanTypes setEditDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"EditDate"]]];
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in ServiceHelper.fromJsonString - Error: %@", [exception description]);
		
		theObject = nil;
		deserializedServicePlanTypes = nil;
		ServicePlanTypesList = nil;
	}
	@finally 
	{
		if (workingWithArray == YES) 
		{
			return ServicePlanTypesList;
		}
		else
		{
			return deserializedServicePlanTypes;
		}
	}
}

@end
