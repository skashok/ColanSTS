//
//  LikeUnlike.m
//  ServiceTech
//
//  Created by colan on 01/11/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "LikeUnlike.h"

@implementation LikeUnlike


@synthesize likeUnlikeId = _likeUnlikeId;
@synthesize solutionId = _solutionId;
@synthesize like = _like;
@synthesize unlike = _unlike;
@synthesize userId = _userId;
@synthesize createDate = _createDate;
@synthesize editDate = _editDate;



+ (NSString *)toJsonString:(LikeUnlike *)likeUnlike indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"LikeUnlikeId\":\"%@\", \n", [[likeUnlike likeUnlikeId] lowercaseString]];
			[jsonStringBuilder appendFormat:@"\t     \"SolutionId\":\"%@\", \n", [likeUnlike solutionId]];
            [jsonStringBuilder appendFormat:@"\t     \"Like\":%d, \n", [likeUnlike like]];
			[jsonStringBuilder appendFormat:@"\t     \"Unlike\":%@, \n",  ([[likeUnlike unlike]boolValue]) ? @"true" : @"false"];
            [jsonStringBuilder appendFormat:@"\t     \"UserId\":\"%@\", \n", [likeUnlike userId]];
			[jsonStringBuilder appendFormat:@"\t     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[likeUnlike createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t     \"EditDate\":\"\\/Date(%.0f)\\/\", \n", [[likeUnlike editDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"LikeUnlikeId\":\"%@\", \n", [[likeUnlike likeUnlikeId] lowercaseString]];
			[jsonStringBuilder appendFormat:@"     \"SolutionId\":\"%@\", \n", [likeUnlike solutionId]];
            [jsonStringBuilder appendFormat:@"     \"Like\":%d, \n", [likeUnlike like]];
			[jsonStringBuilder appendFormat:@"     \"Unlike\":%@, \n", ([[likeUnlike unlike]boolValue]) ? @"true" : @"false"];
            [jsonStringBuilder appendFormat:@"     \"UserId\":\"%@\", \n", [likeUnlike userId]];
			[jsonStringBuilder appendFormat:@"     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[likeUnlike createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"     \"EditDate\":\"\\/Date(%.0f)\\/\", \n", [[likeUnlike editDate] timeIntervalSince1970] * 1000];
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

+ (NSString *)arrayToJsonString:(NSMutableArray *)likeUnlikeList
{
	NSMutableString *jsonStringBuilder = nil;
	NSString *jsonString = @"";
	
	@try
	{
		if(jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		NSEnumerator *enumerator = [likeUnlikeList objectEnumerator];
		
		LikeUnlike *currentLikeUnlike = nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (currentLikeUnlike = [enumerator nextObject])
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [LikeUnlike toJsonString:currentLikeUnlike indent:YES]];
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
	LikeUnlike *deserializedLikeUnlike = nil;
	
    NSMutableArray *likeUnlikelist = nil;
	
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
			if(likeUnlikelist == nil)
			{
				likeUnlikelist = [[NSMutableArray alloc] init];
			}
			
			for (int i = 0; i < [theObject count]; i++)
			{
				id currentLikeUnlike = [theObject objectAtIndex:i];
				
				if(deserializedLikeUnlike == nil)
				{
					deserializedLikeUnlike = [[LikeUnlike alloc] init];
				}
				
				[deserializedLikeUnlike setLikeUnlikeId:[currentLikeUnlike valueForKey:@"LikeUnlikeId"]];
				[deserializedLikeUnlike setSolutionId:[currentLikeUnlike valueForKey:@"SolutionId"]];
                [deserializedLikeUnlike setLike:[[currentLikeUnlike valueForKey:@"Like"] intValue]];
				[deserializedLikeUnlike setUnlike:[currentLikeUnlike valueForKey:@"Unlike"]];
                [deserializedLikeUnlike setUserId:[currentLikeUnlike valueForKey:@"UserId"]];
				[deserializedLikeUnlike setCreateDate:[Utility getDateFromJSONDate:[currentLikeUnlike valueForKey:@"CreateDate"]]];
				[deserializedLikeUnlike setEditDate:[Utility getDateFromJSONDate:[currentLikeUnlike valueForKey:@"EditDate"]]];
				[likeUnlikelist addObject:deserializedLikeUnlike];
				
				deserializedLikeUnlike = nil;
			}
		}
		else
		{
			if(deserializedLikeUnlike == nil)
			{
				deserializedLikeUnlike = [[LikeUnlike alloc] init];
			}
			
			[deserializedLikeUnlike setLikeUnlikeId:[theObject valueForKey:@"LikeUnlikeId"]];
			[deserializedLikeUnlike setSolutionId:[theObject valueForKey:@"SolutionId"]];
            [deserializedLikeUnlike setLike:[[theObject valueForKey:@"Like"] intValue]];
			[deserializedLikeUnlike setUnlike:[theObject valueForKey:@"Unlike"]];
            [deserializedLikeUnlike setUserId:[theObject valueForKey:@"UserId"]];
			[deserializedLikeUnlike setCreateDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"CreateDate"]]];
			[deserializedLikeUnlike setEditDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"EditDate"]]];
		}
	}
	@catch (NSException *exception)
	{
		//NSLog(@"Error in ServiceHelper.fromJsonString - Error: %@", [exception description]);
		
		theObject = nil;
		deserializedLikeUnlike = nil;
		likeUnlikelist = nil;
	}
	@finally
	{
		if (workingWithArray == YES)
		{
			return likeUnlikelist;
		}
		else
		{
			return deserializedLikeUnlike;
		}
	}
}

@end
