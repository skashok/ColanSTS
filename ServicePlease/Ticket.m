//
//  Ticket.m
//  ServicePlease
//
//  Created by Ed Elliott on 2/9/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "Ticket.h"

@implementation Ticket

@synthesize ticketId = _ticketId;
@synthesize ticketNum = _ticketNum;
@synthesize ticketNumber = _ticketNumber;
@synthesize ticketName = _ticketName;
@synthesize categoryId = _categoryId;
@synthesize contactId = _contactId;
@synthesize locationId = _locationId;
@synthesize organizationId = _organizationId;
@synthesize openClose = _openClose;
@synthesize userId = _userId;
@synthesize closeDate = _closeDate;
@synthesize createDate = _createDate;
@synthesize editDate = _editDate;
@synthesize ticketStatus = _ticketStatus;
@synthesize tech = _tech;
@synthesize ticketServicePlan = _ticketServicePlan;
@synthesize IsHelpDoc = _IsHelpDoc;


+ (NSString *)toJsonString:(Ticket *)ticket indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"TicketId\":\"%@\", \n", [ticket ticketId]];
			[jsonStringBuilder appendFormat:@"\t     \"TicketName\":\"%@\", \n", [ticket ticketName]];
			[jsonStringBuilder appendFormat:@"\t     \"CategoryId\":\"%@\", \n", [ticket categoryId]];
			[jsonStringBuilder appendFormat:@"\t     \"ContactId\":\"%@\", \n", [ticket contactId]];
			[jsonStringBuilder appendFormat:@"\t     \"LocationId\":\"%@\", \n", [ticket locationId]];
			[jsonStringBuilder appendFormat:@"\t     \"OrganizationId\":\"%@\", \n", [ticket organizationId]];
			[jsonStringBuilder appendFormat:@"\t     \"OpenClose\":\"%@\", \n", [ticket openClose]];
            [jsonStringBuilder appendFormat:@"\t     \"Status\":\"%@\", \n", [ticket ticketStatus]];
            [jsonStringBuilder appendFormat:@"\t     \"ServicePlan\":\"%@\", \n", [ticket ticketServicePlan]];
			[jsonStringBuilder appendFormat:@"\t     \"UserId\":\"%@\", \n", [ticket userId]];
            [jsonStringBuilder appendFormat:@"\t     \"Tech\":\"%@\", \n", [ticket tech]];
            [jsonStringBuilder appendFormat:@"\t     \"IsHelpDoc\":\"%@\", \n", ([[ticket IsHelpDoc]boolValue]) ? @"true" : @"false"];

			if ([ticket closeDate] == nil) 
			{
				[jsonStringBuilder appendFormat:@"\t     \"CloseDate\":null, \n"];
			}
			else 
			{
				[jsonStringBuilder appendFormat:@"\t     \"CloseDate\":\"Date(%.0f)\", \n", [[ticket closeDate] timeIntervalSince1970] * 1000];
			}

			[jsonStringBuilder appendFormat:@"\t     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[ticket createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[ticket editDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"TicketId\":\"%@\", \n", [ticket ticketId]];
			[jsonStringBuilder appendFormat:@"     \"TicketName\":\"%@\", \n", [ticket ticketName]];
			[jsonStringBuilder appendFormat:@"     \"CategoryId\":\"%@\", \n", [ticket categoryId]];
			[jsonStringBuilder appendFormat:@"     \"ContactId\":\"%@\", \n", [ticket contactId]];
			[jsonStringBuilder appendFormat:@"     \"LocationId\":\"%@\", \n", [ticket locationId]];
			[jsonStringBuilder appendFormat:@"     \"OrganizationId\":\"%@\", \n", [ticket organizationId]];
			[jsonStringBuilder appendFormat:@"     \"OpenClose\":\"%@\", \n", [ticket openClose]];
            [jsonStringBuilder appendFormat:@"     \"Status\":\"%@\", \n", [ticket ticketStatus]];
            [jsonStringBuilder appendFormat:@"     \"ServicePlan\":\"%@\", \n", [ticket ticketServicePlan]];
			[jsonStringBuilder appendFormat:@"     \"UserId\":\"%@\", \n", [ticket userId]];
			[jsonStringBuilder appendFormat:@"     \"Tech\":\"%@\", \n", [ticket tech]];
            [jsonStringBuilder appendFormat:@"     \"IsHelpDoc\":\"%@\", \n", ([[ticket IsHelpDoc]boolValue]) ? @"true" : @"false"];

			if ([ticket closeDate] == nil) 
			{
				[jsonStringBuilder appendFormat:@"\t     \"CloseDate\":null, \n"];
			}
			else 
			{
				[jsonStringBuilder appendFormat:@"\t     \"CloseDate\":\"Date(%.0f)\", \n", [[ticket closeDate] timeIntervalSince1970] * 1000];
			}
			
			[jsonStringBuilder appendFormat:@"     \"CreateDate\":\"\\/Date(%.0f)\\/\", \n", [[ticket createDate] timeIntervalSince1970] * 1000];
			[jsonStringBuilder appendFormat:@"     \"EditDate\":\"\\/Date(%.0f)\\/\" \n", [[ticket editDate] timeIntervalSince1970] * 1000];
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

+ (NSString *)arrayToJsonString:(NSMutableArray *)ticketList
{
	NSMutableString *jsonStringBuilder = nil;
	NSString *jsonString = @"";
	
	@try 
	{
		if(jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		NSEnumerator *enumerator = [ticketList objectEnumerator];
		
		Ticket *currentTicket = nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (currentTicket = [enumerator nextObject]) 
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [Ticket toJsonString:currentTicket indent:YES]];
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
	Ticket *deserializedTicket = nil;
	NSMutableArray *ticketList = nil;
	
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
			if(ticketList == nil)
			{
				ticketList = [[NSMutableArray alloc] init];
			}
			
			for (int i = 0; i < [theObject count]; i++) 
			{
				id currentTicket = [theObject objectAtIndex:i];
				
				if(deserializedTicket == nil)
				{
					deserializedTicket = [[Ticket alloc] init];
				}
				
				[deserializedTicket setTicketId:[currentTicket valueForKey:@"TicketId"]];
				[deserializedTicket setTicketName:[currentTicket valueForKey:@"TicketName"]];
				[deserializedTicket setCategoryId:[[currentTicket valueForKey:@"CategoryId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentTicket valueForKey:@"CategoryId"] : @""];
				[deserializedTicket setContactId:[[currentTicket valueForKey:@"ContactId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentTicket valueForKey:@"ContactId"] : @""];
				[deserializedTicket setLocationId:[[currentTicket valueForKey:@"LocationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentTicket valueForKey:@"LocationId"] : @""];
				[deserializedTicket setOrganizationId:[[currentTicket valueForKey:@"OrganizationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentTicket valueForKey:@"OrganizationId"] : @""];
				[deserializedTicket setOpenClose:[[currentTicket valueForKey:@"OpenClose"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentTicket valueForKey:@"OpenClose"] : @""];
				[deserializedTicket setUserId:[[currentTicket valueForKey:@"UserId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentTicket valueForKey:@"UserId"] : @""];
				[deserializedTicket setTech:[[currentTicket valueForKey:@"Tech"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentTicket valueForKey:@"Tech"] : @""];
				[deserializedTicket setIsHelpDoc:[[currentTicket valueForKey:@"IsHelpDoc"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentTicket valueForKey:@"IsHelpDoc"] : @""];

				[deserializedTicket setCloseDate:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"CloseDate"]]];
				[deserializedTicket setCreateDate:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"CreateDate"]]];
				[deserializedTicket setEditDate:[Utility getDateFromJSONDate:[currentTicket valueForKey:@"EditDate"]]];
				
				[ticketList addObject:deserializedTicket];
				
				deserializedTicket = nil;
			}
		}
		else
		{
			if(deserializedTicket == nil)
			{
				deserializedTicket = [[Ticket alloc] init];
			}
			
			[deserializedTicket setTicketId:[theObject valueForKey:@"TicketId"]];
			[deserializedTicket setTicketName:[theObject valueForKey:@"TicketName"]];
			[deserializedTicket setCategoryId:[[theObject valueForKey:@"CategoryId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"CategoryId"] : @""];
			[deserializedTicket setContactId:[[theObject valueForKey:@"ContactId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"ContactId"] : @""];
			[deserializedTicket setLocationId:[[theObject valueForKey:@"LocationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"LocationId"] : @""];
			[deserializedTicket setOrganizationId:[[theObject valueForKey:@"OrganizationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"OrganizationId"] : @""];
			[deserializedTicket setOpenClose:[[theObject valueForKey:@"OpenClose"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"OpenClose"] : @""];
			[deserializedTicket setUserId:[[theObject valueForKey:@"UserId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"UserId"] : @""];
            [deserializedTicket setTech:[[theObject valueForKey:@"Tech"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"Tech"] : @""];
            [deserializedTicket setIsHelpDoc:[[theObject valueForKey:@"IsHelpDoc"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"IsHelpDoc"] : @""];

			[deserializedTicket setCloseDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"CloseDate"]]];
			[deserializedTicket setCreateDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"CreateDate"]]];
			[deserializedTicket setEditDate:[Utility getDateFromJSONDate:[theObject valueForKey:@"EditDate"]]];
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in ServiceHelper.fromJsonString - Error: %@", [exception description]);
		
		theObject = nil;
		deserializedTicket = nil;
		ticketList = nil;
	}
	@finally 
	{
		if (workingWithArray == YES) 
		{
			return ticketList;
		}
		else
		{
			return deserializedTicket;
		}
	}
}

@end
