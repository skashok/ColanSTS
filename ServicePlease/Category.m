//
//  Category.m
//  ServicePlease
//
//  Created by Ed Elliott on 2/9/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "Category.h"

@implementation Category

@synthesize categoryId = _categoryId;
@synthesize organizationId = _organizationId;
@synthesize categoryName = _categoryName;
@synthesize categoryIcon = _categoryIcon;
@synthesize createDate = _createDate;
@synthesize editDate = _editDate;

+ (NSString *)toJsonString:(Category *)category indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"CategoryId\":\"%@\", \n", [[category categoryId] lowercaseString]];
			[jsonStringBuilder appendFormat:@"\t     \"CategoryIcon\":\"%@\", \n", [category categoryIcon]];
			[jsonStringBuilder appendFormat:@"\t     \"CategoryName\":\"%@\", \n", [category categoryName]];
			[jsonStringBuilder appendFormat:@"\t     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[category createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t     \"EditDate\":\"\\/Date(%.0f)\\/\", \n", [[category editDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t     \"OrganizationId\":\"%@\" \n", [[category organizationId] lowercaseString]];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"CategoryId\":\"%@\", \n", [[category categoryId] lowercaseString]];
			[jsonStringBuilder appendFormat:@"     \"CategoryIcon\":\"%@\", \n", [category categoryIcon]];
			[jsonStringBuilder appendFormat:@"     \"CategoryName\":\"%@\", \n", [category categoryName]];
			[jsonStringBuilder appendFormat:@"     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[category createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"     \"EditDate\":\"\\/Date(%.0f)\\/\", \n", [[category editDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"     \"OrganizationId\":\"%@\" \n", [[category organizationId] lowercaseString]];
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

+ (NSString *)arrayToJsonString:(NSMutableArray *)categoryList
{
	NSMutableString *jsonStringBuilder = nil;
	NSString *jsonString = @"";
	
	@try 
	{
		if(jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		NSEnumerator *enumerator = [categoryList objectEnumerator];
		
		Category *currentCategory = nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (currentCategory = [enumerator nextObject]) 
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [Category toJsonString:currentCategory indent:YES]];
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
	Category *deserializedCategory = nil;
	NSMutableArray *categoryList = nil;
	
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
			if(categoryList == nil)
			{
				categoryList = [[NSMutableArray alloc] init];
			}
			
			for (int i = 0; i < [theObject count]; i++) 
			{
				id currentCategory = [theObject objectAtIndex:i];
				
				if(deserializedCategory == nil)
				{
					deserializedCategory = [[Category alloc] init];
				}
				
				[deserializedCategory setCategoryId:[currentCategory valueForKey:@"CategoryId"]];
				[deserializedCategory setCategoryIcon:[[currentCategory valueForKey:@"CategoryIcon"] compare:@"<null>" options:NSCaseInsensitiveSearch] != 0 ? [currentCategory valueForKey:@"CategoryIcon"] : @""];
				[deserializedCategory setCategoryName:[currentCategory valueForKey:@"CategoryName"]];
				[deserializedCategory setCreateDate:[Utility getDateFromJSONDate:[currentCategory valueForKey:@"CreateDate"]]];
				[deserializedCategory setEditDate:[Utility getDateFromJSONDate:[currentCategory valueForKey:@"EditDate"]]];
				[deserializedCategory setOrganizationId:[[currentCategory valueForKey:@"OrganizationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentCategory valueForKey:@"OrganizationId"] : @""];
				
				[categoryList addObject:deserializedCategory];
				
				deserializedCategory = nil;
			}
		}
		else
		{
			if(deserializedCategory == nil)
			{
				deserializedCategory = [[Category alloc] init];
			}
			
			[deserializedCategory setCategoryId:[theObject valueForKey:@"CategoryId"]];
			[deserializedCategory setCategoryIcon:[[theObject valueForKey:@"CategoryIcon"] compare:@"<null>" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"CategoryIcon"] : @""];
			[deserializedCategory setCategoryName:[theObject valueForKey:@"CategoryName"]];
			[deserializedCategory setCreateDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"CreateDate"]]];
			[deserializedCategory setEditDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"EditDate"]]];
			[deserializedCategory setOrganizationId:[[theObject valueForKey:@"OrganizationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"OrganizationId"] : @""];
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in ServiceHelper.fromJsonString - Error: %@", [exception description]);
		
		theObject = nil;
		deserializedCategory = nil;
		categoryList = nil;
	}
	@finally 
	{
		if (workingWithArray == YES) 
		{
			return categoryList;
		}
		else
		{
			return deserializedCategory;
		}
	}
}

@end
