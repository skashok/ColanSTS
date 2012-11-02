//
//  Contact.m
//  ServicePlease
//
//  Created by Edward Elliott on 2/21/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "Contact.h"

@implementation Contact

@synthesize contactId = _contactId;
@synthesize organizationId = _organizationId;
@synthesize contactName = _contactName;
@synthesize firstName = _firstName;
@synthesize middleName = _middleName;
@synthesize lastName = _lastName;
@synthesize email = _email;
@synthesize phone = _phone;
@synthesize locationId = _locationId;
@synthesize createDate = _createDate;
@synthesize editDate = _editDate;
@synthesize callBackNum = _callBackNum;

+ (NSString *)toJsonString:(Contact *)contact indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"ContactId\":\"%@\", \n", [[contact contactId] lowercaseString]];
			[jsonStringBuilder appendFormat:@"\t     \"OrganizationId\":\"%@\", \n", [[contact organizationId] lowercaseString]];
			[jsonStringBuilder appendFormat:@"\t     \"ContactName\":\"%@\", \n", [contact contactName]];
			[jsonStringBuilder appendFormat:@"\t     \"FirstName\":\"%@\", \n", [contact firstName]];
			[jsonStringBuilder appendFormat:@"\t     \"MiddleName\":\"%@\", \n", [contact middleName]];
			[jsonStringBuilder appendFormat:@"\t     \"LastName\":\"%@\", \n", [contact lastName]];
			[jsonStringBuilder appendFormat:@"\t     \"Email\":\"%@\", \n", [contact email]];
			[jsonStringBuilder appendFormat:@"\t     \"Phone\":\"%@\", \n", [contact phone]];
			[jsonStringBuilder appendFormat:@"\t     \"LocationId\":\"%@\", \n", [[contact locationId] lowercaseString]];
			[jsonStringBuilder appendFormat:@"\t     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[contact createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t     \"EditDate\":\"\\/Date(%.0f)\\/\", \n", [[contact editDate] timeIntervalSince1970] * 1000];
            [jsonStringBuilder appendFormat:@"\t     \"CallbackNumber\":\"%@\" \n", [contact callBackNum]];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"ContactId\":\"%@\", \n", [[contact contactId] lowercaseString]];
			[jsonStringBuilder appendFormat:@"     \"OrganizationId\":\"%@\", \n", [[contact organizationId] lowercaseString]];
			[jsonStringBuilder appendFormat:@"     \"ContactName\":\"%@\", \n", [contact contactName]];
			[jsonStringBuilder appendFormat:@"     \"FirstName\":\"%@\", \n", [contact firstName]];
			[jsonStringBuilder appendFormat:@"     \"MiddleName\":\"%@\", \n", [contact middleName]];
			[jsonStringBuilder appendFormat:@"     \"LastName\":\"%@\", \n", [contact lastName]];
			[jsonStringBuilder appendFormat:@"     \"Email\":\"%@\", \n", [contact email]];
			[jsonStringBuilder appendFormat:@"     \"Phone\":\"%@\", \n", [contact phone]];
			[jsonStringBuilder appendFormat:@"     \"LocationId\":\"%@\", \n", [[contact locationId] lowercaseString]];
			[jsonStringBuilder appendFormat:@"     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[contact createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"     \"EditDate\":\"\\/Date(%.0f)\\/\", \n", [[contact editDate] timeIntervalSince1970] * 1000];
            [jsonStringBuilder appendFormat:@"     \"CallbackNumber\":\"%@\" \n", [contact callBackNum]];
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

+ (NSString *)arrayToJsonString:(NSMutableArray *)contactList
{
	NSMutableString *jsonStringBuilder = nil;
	NSString *jsonString = @"";
	
	@try 
	{
		if(jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		NSEnumerator *enumerator = [contactList objectEnumerator];
		
		Contact *currentContact = nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (currentContact = [enumerator nextObject]) 
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [Contact toJsonString:currentContact indent:YES]];
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
	Contact *deserializedContact = nil;
	NSMutableArray *contactList = nil;
	
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
			if(contactList == nil)
			{
				contactList = [[NSMutableArray alloc] init];
			}
			
			for (int i = 0; i < [theObject count]; i++) 
			{
				id currentContact = [theObject objectAtIndex:i];
				
				if(deserializedContact == nil)
				{
					deserializedContact = [[Contact alloc] init];
				}
				
				[deserializedContact setContactId:[[currentContact valueForKey:@"ContactId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentContact valueForKey:@"ContactId"] : @""];
				[deserializedContact setOrganizationId:[[currentContact valueForKey:@"OrganizationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentContact valueForKey:@"OrganizationId"] : @""];
				[deserializedContact setContactName:[currentContact valueForKey:@"ContactName"]];
				[deserializedContact setFirstName:[currentContact valueForKey:@"FirstName"]];
				[deserializedContact setMiddleName:[currentContact valueForKey:@"MiddleName"]];
				[deserializedContact setLastName:[currentContact valueForKey:@"LastName"]];
				[deserializedContact setEmail:[currentContact valueForKey:@"Email"]];
				[deserializedContact setPhone:[currentContact valueForKey:@"Phone"]];
				[deserializedContact setLocationId:[[currentContact valueForKey:@"LocationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentContact valueForKey:@"LocationId"] : @""];
				[deserializedContact setCreateDate:[Utility getDateFromJSONDate:[currentContact valueForKey:@"CreateDate"]]];
				[deserializedContact setEditDate:[Utility getDateFromJSONDate:[currentContact valueForKey:@"EditDate"]]];
                [deserializedContact setCallBackNum:[currentContact valueForKey:@"CallbackNumber"]];
                
				[contactList addObject:deserializedContact];
				
				deserializedContact = nil;
			}
		}
		else
		{
			if(deserializedContact == nil)
			{
				deserializedContact = [[Contact alloc] init];
			}
			
			[deserializedContact setContactId:[[theObject valueForKey:@"ContactId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"ContactId"] : @""];
			[deserializedContact setOrganizationId:[[theObject valueForKey:@"OrganizationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"OrganizationId"] : @""];
			[deserializedContact setContactName:[theObject valueForKey:@"ContactName"]];
			[deserializedContact setFirstName:[theObject valueForKey:@"FirstName"]];
			[deserializedContact setMiddleName:[theObject valueForKey:@"MiddleName"]];
			[deserializedContact setLastName:[theObject valueForKey:@"LastName"]];
			[deserializedContact setEmail:[theObject valueForKey:@"Email"]];
			[deserializedContact setPhone:[theObject valueForKey:@"Phone"]];
			[deserializedContact setLocationId:[[theObject valueForKey:@"LocationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"LocationId"] : @""];
			[deserializedContact setCreateDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"CreateDate"]]];
			[deserializedContact setEditDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"EditDate"]]];
            [deserializedContact setCallBackNum:[theObject valueForKey:@"CallbackNumber"]];
            
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in ServiceHelper.fromJsonString - Error: %@", [exception description]);
		
		theObject = nil;
		deserializedContact = nil;
		contactList = nil;
	}
	@finally 
	{
		if (workingWithArray == YES) 
		{
			return contactList;
		}
		else
		{
			return deserializedContact;
		}
	}
}

@end
