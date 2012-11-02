//
//  Blob.m
//  ServiceTech
//
//  Created by Ashokkumar Kandaswamy on 01/08/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "Blob.h"

@implementation Blob

@synthesize EntityId = _EntityId;
@synthesize BlobTypeId = _BlobTypeId;
@synthesize BlobBytes = _BlobBytes;

+ (NSString *)toJsonString:(Blob *)blob indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"BlobBytes\":%@, \n", [blob BlobBytes]];
			[jsonStringBuilder appendFormat:@"\t     \"BlobTypeId\":\"%@\", \n", [blob BlobTypeId]];
			[jsonStringBuilder appendFormat:@"\t     \"EntityId\":\"%@\", \n", [blob EntityId]];
            [jsonStringBuilder appendFormat:@"}"];

		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"BlobBytes\":%@, \n", [blob BlobBytes]];
			[jsonStringBuilder appendFormat:@"     \"BlobTypeId\":\"%@\", \n", [blob BlobTypeId]];
			[jsonStringBuilder appendFormat:@"     \"EntityId\":\"%@\", \n", [blob EntityId]];
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
		
		Blob *currentBlob = nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (currentBlob = [enumerator nextObject]) 
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [Blob toJsonString:currentBlob indent:YES]];
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
	Blob *deserializedBlob = nil;
	NSMutableArray *blobList = nil;
	
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
			if(blobList == nil)
			{
				blobList = [[NSMutableArray alloc] init];
			}
			
			for (int i = 0; i < [theObject count]; i++) 
			{
				id currentBlob = [theObject objectAtIndex:i];
				
				if(deserializedBlob == nil)
				{
					deserializedBlob = [[Blob alloc] init];
				}

				[deserializedBlob setBlobBytes:[currentBlob valueForKey:@"BlobBytes"]];
				[deserializedBlob setBlobTypeId:[currentBlob valueForKey:@"BlobTypeId"]];
				[deserializedBlob setEntityId:[currentBlob valueForKey:@"EntityId"]];
				
				[blobList addObject:deserializedBlob];
				
				deserializedBlob = nil;
			}
		}
		else
		{
			if(deserializedBlob == nil)
			{
				deserializedBlob = [[Blob alloc] init];
			}
			
            [deserializedBlob setBlobBytes:[deserializedBlob valueForKey:@"BlobBytes"]];
            [deserializedBlob setBlobTypeId:[deserializedBlob valueForKey:@"BlobTypeId"]];
            [deserializedBlob setEntityId:[deserializedBlob valueForKey:@"EntityId"]];

		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in ServiceHelper.fromJsonString - Error: %@", [exception description]);
		
		theObject = nil;
		deserializedBlob = nil;
		blobList = nil;
	}
	@finally 
	{
		if (workingWithArray == YES) 
		{
			return blobList;
		}
		else
		{
			return deserializedBlob;
		}
	}
}

@end
