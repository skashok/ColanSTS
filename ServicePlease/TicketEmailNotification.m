//
//  TicketEmailNotification.m
//  ServicePlease
//
//  Created by Ashokkumar Kandaswamy on 11/07/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "TicketEmailNotification.h"

#define kEmailFromAddress @"servicetech@servicetrackingsystems.net"

@implementation TicketEmailNotification

+ (NSString *)JsonContentofEmailWithIndent:(BOOL)indent toAddress:(NSString *)toAddress withBodyContent:(NSString *)bodyText SubjectContent:(NSString *)subjectText
{
    
    NSMutableString *jsonStringBuilder = nil;
	
	NSString *jsonString = @"";
    
    NSMutableString *toEmailAdresses = [[NSMutableString alloc]init];
    [toEmailAdresses setString:@"[\""];
    [toEmailAdresses appendFormat:@"%@",toAddress];
    [toEmailAdresses appendFormat:@"\""];
    [toEmailAdresses appendString:@"]"];
    
    
    NSMutableString *ccEmailAdresses = [[NSMutableString alloc]init];
    [ccEmailAdresses setString:@"[\""];
    [ccEmailAdresses appendString:@"mohammed.imran@colanonline.com"];
    
    [ccEmailAdresses appendFormat:@"\",\""];
    [ccEmailAdresses appendString:@"Kai@servicetrackingsystems.net"];
    [ccEmailAdresses appendFormat:@"\",\""];
    
    [ccEmailAdresses appendString:@"Michelle@servicetrackingsystems.net"];
    [ccEmailAdresses appendFormat:@"\",\""];
    
    [ccEmailAdresses appendString:@"edelliott@nc.rr.com"];
    [ccEmailAdresses appendFormat:@"\",\""];
    
    [ccEmailAdresses appendString:@"evan@servicetrackingsystems.net"];
    [ccEmailAdresses appendFormat:@"\",\""];
    
    [ccEmailAdresses appendString:@"sarah@servicetrackingsystems.net"];
    [ccEmailAdresses appendFormat:@"\",\""];
    
    [ccEmailAdresses appendString:@"ashok@colanonline.com"];
    [ccEmailAdresses appendFormat:@"\",\""];
    
    [ccEmailAdresses appendString:@"poomalai@colanonline.com"];
    [ccEmailAdresses appendFormat:@"\",\""];
    
    [ccEmailAdresses appendString:@"pushpalatha.prakash@colanonline.com"];
    [ccEmailAdresses appendFormat:@"\""];
    
    [ccEmailAdresses appendString:@"]"];
    
	@try 
	{
		if (jsonStringBuilder == nil) 
		{
			jsonStringBuilder = [[NSMutableString alloc] init];
		}
		
		if (indent == YES) 
		{
			[jsonStringBuilder appendFormat:@"\t{ \n"];
			[jsonStringBuilder appendFormat:@"\t     \"FromAddress\":\"%@\", \n",kEmailFromAddress];
			[jsonStringBuilder appendFormat:@"\t     \"ToAddresses\":%@, \n",toEmailAdresses];
            [jsonStringBuilder appendFormat:@"\t     \"CCAddresses\":%@, \n",ccEmailAdresses];
            [jsonStringBuilder appendFormat:@"\t     \"SubjectText\":\"%@\", \n",subjectText];
			[jsonStringBuilder appendFormat:@"\t     \"BodyText\":\"%@\" \n",bodyText];
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"FromAddress\":\"%@\", \n",kEmailFromAddress];
            [jsonStringBuilder appendFormat:@"     \"CCAddresses\":%@, \n",ccEmailAdresses];
			[jsonStringBuilder appendFormat:@"     \"ToAddresses\":%@, \n",toEmailAdresses];
			[jsonStringBuilder appendFormat:@"     \"SubjectText\":\"%@\", \n",subjectText];
			[jsonStringBuilder appendFormat:@"     \"BodyText\":\"%@\" \n",bodyText];
            
			[jsonStringBuilder appendFormat:@"}"];
		}
		jsonString = jsonStringBuilder;
	}
	@catch (NSException *exception) 
	{
		//NSLog(@"Error occurred in JsonContentofEmail.  Error: %@", [exception description]);
		
		jsonString = @"";
	}
	@finally 
	{		
		return jsonString;
	}
}

@end
