
//
//  TicketMoniter.m
//  ServicePlease
//
//  Created by Ed Elliott on 2/9/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "TicketMoniter.h"

@implementation TicketMoniter

@synthesize ticketCategory = _ticketCategory;
@synthesize ticketTicketNumber = _ticketTicketNumber;
@synthesize ticketCategoryId = _ticketCategoryId;
@synthesize ticketContact = _ticketContact;
@synthesize ticketContactId = _ticketContactId;
@synthesize ticketDescription = _ticketDescription;
@synthesize ticketElapsed = _ticketElapsed;
@synthesize ticketLocation = _ticketLocation;
@synthesize ticketLocationId = _ticketLocationId;
@synthesize ticketOrganizationId = _ticketOrganizationId;
@synthesize ticketServicePlan = _ticketServicePlan;
@synthesize ticketStatus = _ticketStatus;
@synthesize ticketTech = _ticketTech;
@synthesize ticketTicketId = _ticketTicketId;
@synthesize ticketTime = ticketTime;
@synthesize ticketUserId = _ticketUserId;


+ (NSString *)toJsonString:(TicketMoniter *)ticketMoniter indent:(BOOL)indent
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
			[jsonStringBuilder appendFormat:@"\t     \"Category\":\"%@\", \n", [ticketMoniter ticketCategory]];
            [jsonStringBuilder appendFormat:@"\t     \"TicketNumber\":\"%@\", \n", [ticketMoniter ticketTicketNumber]];
            [jsonStringBuilder appendFormat:@"\t     \"CategoryId\":\"%@\", \n", [ticketMoniter ticketCategoryId]];
			[jsonStringBuilder appendFormat:@"\t     \"Contact\":\"%@\", \n", [ticketMoniter ticketContact]];
            [jsonStringBuilder appendFormat:@"\t     \"ContactId\":\"%@\", \n", [ticketMoniter ticketContactId]];
			[jsonStringBuilder appendFormat:@"\t     \"Description\":\"%@\", \n", [ticketMoniter ticketDescription]];
			[jsonStringBuilder appendFormat:@"\t     \"Elapsed\":\"%@\", \n", [ticketMoniter ticketElapsed]];
			[jsonStringBuilder appendFormat:@"\t     \"Location\":\"%@\", \n", [ticketMoniter ticketLocation]];
            [jsonStringBuilder appendFormat:@"\t     \"LocationId\":\"%@\", \n", [ticketMoniter ticketLocationId]];
            [jsonStringBuilder appendFormat:@"\t     \"OrganizationId\":\"%@\", \n", [ticketMoniter ticketOrganizationId]];
			[jsonStringBuilder appendFormat:@"\t     \"ServicePlan\":\"%@\", \n", [ticketMoniter ticketServicePlan]];
			[jsonStringBuilder appendFormat:@"\t     \"Status\":\"%@\", \n", [ticketMoniter ticketStatus]];
			[jsonStringBuilder appendFormat:@"\t     \"Tech\":\"%@\", \n", [ticketMoniter ticketTech]];
            [jsonStringBuilder appendFormat:@"\t     \"TicketId\":\"%@\", \n", [ticketMoniter ticketTicketId]];
            [jsonStringBuilder appendFormat:@"\t     \"Time\":\"%@\", \n", [ticketMoniter ticketTime]];
            [jsonStringBuilder appendFormat:@"\t     \"UserId\":\"%@\", \n", [ticketMoniter ticketUserId]];
            
			[jsonStringBuilder appendFormat:@"\t}"];
            
		}
		else
		{
            [jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"Category\":\"%@\", \n", [ticketMoniter ticketCategory]];
            [jsonStringBuilder appendFormat:@"     \"TicketNumber\":\"%@\", \n", [ticketMoniter ticketTicketNumber]];
            [jsonStringBuilder appendFormat:@"     \"CategoryId\":\"%@\", \n", [ticketMoniter ticketCategoryId]];
			[jsonStringBuilder appendFormat:@"     \"Contact\":\"%@\", \n", [ticketMoniter ticketContact]];
            [jsonStringBuilder appendFormat:@"     \"ContactId\":\"%@\", \n", [ticketMoniter ticketContactId]];
			[jsonStringBuilder appendFormat:@"     \"Description\":\"%@\", \n", [ticketMoniter ticketDescription]];
			[jsonStringBuilder appendFormat:@"     \"Elapsed\":\"%@\", \n", [ticketMoniter ticketElapsed]];
			[jsonStringBuilder appendFormat:@"     \"Location\":\"%@\", \n", [ticketMoniter ticketLocation]];
            [jsonStringBuilder appendFormat:@"     \"LocationId\":\"%@\", \n", [ticketMoniter ticketLocationId]];
            [jsonStringBuilder appendFormat:@"     \"OrganizationId\":\"%@\", \n", [ticketMoniter ticketOrganizationId]];
			[jsonStringBuilder appendFormat:@"     \"ServicePlan\":\"%@\", \n", [ticketMoniter ticketServicePlan]];
			[jsonStringBuilder appendFormat:@"     \"Status\":\"%@\", \n", [ticketMoniter ticketStatus]];
			[jsonStringBuilder appendFormat:@"     \"Tech\":\"%@\", \n", [ticketMoniter ticketTech]];
            [jsonStringBuilder appendFormat:@"     \"TicketId\":\"%@\", \n", [ticketMoniter ticketTicketId]];
            [jsonStringBuilder appendFormat:@"     \"Time\":\"%@\", \n", [ticketMoniter ticketTime]];
            [jsonStringBuilder appendFormat:@"     \"UserId\":\"%@\", \n", [ticketMoniter ticketUserId]];
            
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

+ (NSString *)arrayToJsonString:(NSMutableArray *)ticketMoniterList
{
	NSMutableString *jsonStringBuilder = nil;
	NSString *jsonString = @"";
	
	@try 
	{
		if(jsonStringBuilder == nil)
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		NSEnumerator *enumerator = [ticketMoniterList objectEnumerator];
		
		TicketMoniter *currentTicketMoniter = nil;
		
		// Add the opening [
		[jsonStringBuilder appendString:@"[ \n"];
		
		while (currentTicketMoniter = [enumerator nextObject]) 
		{
			[jsonStringBuilder appendFormat:@"%@, \n", [TicketMoniter toJsonString:currentTicketMoniter indent:YES]];
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
	TicketMoniter *deserializedTicketMoniter = nil;
	NSMutableArray *ticketMoniterList = nil;
	
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
			if(ticketMoniterList == nil)
			{
				ticketMoniterList = [[NSMutableArray alloc] init];
			}
			
			for (int i = 0; i < [theObject count]; i++) 
			{
				id currentTicketMoniter = [theObject objectAtIndex:i];
				
				if(deserializedTicketMoniter == nil)
				{
					deserializedTicketMoniter = [[TicketMoniter alloc] init];
				}
				
                
				[deserializedTicketMoniter setTicketCategory:[currentTicketMoniter valueForKey:@"Category"]];
                [deserializedTicketMoniter setTicketCategoryId:[currentTicketMoniter valueForKey:@"CategoryId"]];
				[deserializedTicketMoniter setTicketContact:[currentTicketMoniter valueForKey:@"Contact"]];
				[deserializedTicketMoniter setTicketContactId:[currentTicketMoniter valueForKey:@"ContactId"]];
				[deserializedTicketMoniter setTicketDescription:[[currentTicketMoniter valueForKey:@"Description"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentTicketMoniter valueForKey:@"Description"] : @""];
                
				[deserializedTicketMoniter setTicketElapsed:[[currentTicketMoniter valueForKey:@"Elapsed"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentTicketMoniter valueForKey:@"Elapsed"] : @""];
				[deserializedTicketMoniter setTicketLocation:[[currentTicketMoniter valueForKey:@"Location"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentTicketMoniter valueForKey:@"Location"] : @""];
                [deserializedTicketMoniter setTicketLocationId:[[currentTicketMoniter valueForKey:@"LocationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentTicketMoniter valueForKey:@"LocationId"] : @""];
                
                [deserializedTicketMoniter setTicketOrganizationId:[[currentTicketMoniter valueForKey:@"OrganizationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentTicketMoniter valueForKey:@"OrganizationId"] : @""];
                
				[deserializedTicketMoniter setTicketServicePlan:[[currentTicketMoniter valueForKey:@"ServicePlan"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentTicketMoniter valueForKey:@"ServicePlan"] : @""];
                
				[deserializedTicketMoniter setTicketStatus:[[currentTicketMoniter valueForKey:@"Status"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentTicketMoniter valueForKey:@"Status"] : @""];
				[deserializedTicketMoniter setTicketTech:[[currentTicketMoniter valueForKey:@"Tech"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentTicketMoniter valueForKey:@"Tech"] : @""];
                [deserializedTicketMoniter setTicketTech:[[currentTicketMoniter valueForKey:@"TicketId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentTicketMoniter valueForKey:@"TicketId"] : @""];
                
                [deserializedTicketMoniter setTicketTech:[[currentTicketMoniter valueForKey:@"TicketNumber"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentTicketMoniter valueForKey:@"TicketNumber"] : @""];
                
				[deserializedTicketMoniter setTicketTime:[[currentTicketMoniter valueForKey:@"Time"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentTicketMoniter valueForKey:@"Time"] : @""];
                [deserializedTicketMoniter setTicketTime:[[currentTicketMoniter valueForKey:@"UserId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [currentTicketMoniter valueForKey:@"UserId"] : @""];
                
                
				[ticketMoniterList addObject:deserializedTicketMoniter];
				
				deserializedTicketMoniter = nil;
			}
		}
		else
		{
			if(deserializedTicketMoniter == nil)
			{
				deserializedTicketMoniter = [[TicketMoniter alloc] init];
			}
			
			[deserializedTicketMoniter setTicketCategory:[theObject valueForKey:@"Category"]];
            [deserializedTicketMoniter setTicketCategoryId:[theObject valueForKey:@"CategoryId"]];
			[deserializedTicketMoniter setTicketContact:[theObject valueForKey:@"Contact"]];
            [deserializedTicketMoniter setTicketContactId:[theObject valueForKey:@"ContactId"]];
			[deserializedTicketMoniter setTicketDescription:[[theObject valueForKey:@"Description"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"Description"] : @""];
			[deserializedTicketMoniter setTicketElapsed:[[theObject valueForKey:@"Elapsed"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"Elapsed"] : @""];
			[deserializedTicketMoniter setTicketLocation:[[theObject valueForKey:@"Location"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"Location"] : @""];
            [deserializedTicketMoniter setTicketLocationId:[[theObject valueForKey:@"LocationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"LocationId"] : @""];
            [deserializedTicketMoniter setTicketOrganizationId:[[theObject valueForKey:@"OrganizationId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"OrganizationId"] : @""];
			[deserializedTicketMoniter setTicketServicePlan:[[theObject valueForKey:@"ServicePlan"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"ServicePlan"] : @""];
			[deserializedTicketMoniter setTicketStatus:[[theObject valueForKey:@"Status"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"Status"] : @""];
			[deserializedTicketMoniter setTicketTech:[[theObject valueForKey:@"Tech"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"Tech"] : @""];
            [deserializedTicketMoniter setTicketTicketId:[[theObject valueForKey:@"TicketId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"TicketId"] : @""];
            [deserializedTicketMoniter setTicketTicketNumber:[[theObject valueForKey:@"TicketNumber"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"TicketNumber"] : @""];
			[deserializedTicketMoniter setTicketTime:[[theObject valueForKey:@"Time"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"Time"] : @""];
            [deserializedTicketMoniter setTicketUserId:[[theObject valueForKey:@"UserId"] compare:@"(null)" options:NSCaseInsensitiveSearch] != 0 ? [theObject valueForKey:@"UserId"] : @""];
            
            
		}
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error in ServiceHelper.fromJsonString - Error: %@", [exception description]);
		
		theObject = nil;
		deserializedTicketMoniter = nil;
		ticketMoniterList = nil;
	}
	@finally 
	{
		if (workingWithArray == YES) 
		{
			return ticketMoniterList;
		}
		else
		{
			return deserializedTicketMoniter;
		}
	}
}

@end
