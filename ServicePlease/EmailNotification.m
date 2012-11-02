//
//  EmailNotification.m
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 04/06/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "EmailNotification.h"
#import "Location.h"

#define kEmailFromAddress @"servicetech@servicetrackingsystems.net"
#define kEmailToAddresses @""
#define kEmailCCAddresses @""
#define kEmailSubjectText @"STS - ServiceTech - New Location added"

@implementation EmailNotification

+ (NSString *)JsonContentofEmailWithIndent:(BOOL)indent withLocation:(Location *)loc withLoacationInfoDetail:(LocationInfo *)locationInfo
{
	NSMutableString *jsonStringBuilder = nil;
	
	NSString *jsonString = @"";
    
    NSMutableString *toEmailAdresses = [[NSMutableString alloc]init];
    [toEmailAdresses setString:@"[\""];
    
    [toEmailAdresses appendString:@"Kai@servicetrackingsystems.net"];
    [toEmailAdresses appendFormat:@"\",\""];
    
    [toEmailAdresses appendString:@"Michelle@servicetrackingsystems.net"];
    [toEmailAdresses appendFormat:@"\",\""];
    
    [toEmailAdresses appendString:@"edelliott@nc.rr.com"];
    [toEmailAdresses appendFormat:@"\",\""];
    
    [toEmailAdresses appendString:@"evan@servicetrackingsystems.net"];
    [toEmailAdresses appendFormat:@"\",\""];
    
    [toEmailAdresses appendString:@"sarah@servicetrackingsystems.net"];
    [toEmailAdresses appendFormat:@"\",\""];
    
    [toEmailAdresses appendString:@"ashok@colanonline.com"];
    [toEmailAdresses appendFormat:@"\",\""];
    
    [toEmailAdresses appendString:@"poomalai@colanonline.com"];
    [toEmailAdresses appendFormat:@"\""];
    
    [toEmailAdresses appendString:@"]"];
    
    NSMutableString *ccEmailAdresses = [[NSMutableString alloc]init];
    [ccEmailAdresses setString:@"[\""];
    [ccEmailAdresses appendString:@"mohammed.imran@colanonline.com"];
    [ccEmailAdresses appendFormat:@"\",\""];
    [ccEmailAdresses appendString:@"pushpalatha.prakash@colanonline.com"];
    [ccEmailAdresses appendFormat:@"\""];
    [ccEmailAdresses appendString:@"]"];
    
	@try 
	{
        
        NSString *locationName=loc.locationName;
        NSString *city=locationInfo.city;
        NSString *state=locationInfo.state;
        NSString *address=locationInfo.address1;
        if ([locationName isEqualToString:@""] ||locationName==nil || [locationName isEqualToString:NULL]) 
        {
            locationName=@"tempLoaction"; 
        }
        if ([city isEqualToString:@""]|| city==nil || [city isEqualToString:NULL]) 
        {
            city=@"tempCity";
        }
        if ([state isEqualToString:@""]|| state==nil || [state isEqualToString:NULL]) 
        {
            state=@"tempState";
        }
        if ([address isEqualToString:@""] || address==nil || [address isEqualToString:NULL]) 
        {
            address =@"tempAddress";
        }
        
        NSString *htmlstring=[[NSString alloc]initWithFormat:@"<html><body>New Location has been added into the System<br><br>location :&nbsp;%@<br><br> address1 :&nbsp;%@<br><br>City &nbsp;:&nbsp;%@<br><br>State &nbsp;:&nbsp;%@</body></html>",locationName,address,city,state];
        
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
			[jsonStringBuilder appendFormat:@"\t     \"SubjectText\":\"%@\", \n",kEmailSubjectText];
            [jsonStringBuilder appendFormat:@"\t     \"BodyText\":\"%@\" \n",htmlstring];
            
			[jsonStringBuilder appendFormat:@"\t}"];
		}
		else
		{
			[jsonStringBuilder appendFormat:@"{ \n"];
			[jsonStringBuilder appendFormat:@"     \"FromAddress\":\"%@\", \n",kEmailFromAddress];
			[jsonStringBuilder appendFormat:@"     \"ToAddresses\":%@, \n",toEmailAdresses];
			[jsonStringBuilder appendFormat:@"     \"CCAddresses\":%@, \n",ccEmailAdresses];
			[jsonStringBuilder appendFormat:@"     \"SubjectText\":\"%@\", \n",kEmailSubjectText];
			[jsonStringBuilder appendFormat:@"     \"BodyText\":\"%@\" \n",htmlstring];
            
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
