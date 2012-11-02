//
//  Utility.m
//  NYStateSnowmobiling
//
//  Created by Ed Elliott on 12/4/11.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (NSDate *)getDateFromJSONDate:(NSString *)jsonDate
{
	/*
	 * This will convert DateTime (.NET) object serialized as JSON by WCF to a NSDate object.
	 */
	NSDate *date = nil;
	
	@try 
	{
		// Input string is something like: "/Date(1292851800000+0100)/" where
		// 1292851800000 is milliseconds since 1970 and +0100 is the timezone
		NSString *inputString = jsonDate;
		
		// This will tell number of seconds to add according to your default timezone
		// Note: if you don't care about timezone changes, just delete/comment it out
		// NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
		
		NSInteger milliseconds = [[inputString substringWithRange:NSMakeRange(16, 3)] intValue];

		// NSInteger offsetWithMillis = offset + milliseconds;
		
		// A range of NSMakeRange(6, 10) will generate "1292851800" from "/Date(1292851800000+0100)/"
		// as in example above. We crop additional three zeros, because "dateWithTimeIntervalSince1970:"
		// wants seconds, not milliseconds; since 1 second is equal to 1000 milliseconds, this will work.
		// Note: if you don't care about timezone changes, just chop out "dateByAddingTimeInterval:offset" part
		date = [[NSDate dateWithTimeIntervalSince1970:
						 [[inputString substringWithRange:NSMakeRange(6, 10)] intValue]]
						dateByAddingTimeInterval:milliseconds / 1000];
				
		// You can just stop here if all you care is a NSDate object from inputString,
		// or see below on how to get a nice string representation from that date:
		
		// static is nice if you will use same formatter again and again (for example in table cells)
		static NSDateFormatter *dateFormatter = nil;
		
		if (dateFormatter == nil) 
		{
			dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateStyle:NSDateFormatterShortStyle];
			[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
			
			// If you're okay with the default NSDateFormatterShortStyle then comment out two lines below
			// or if you want four digit year, then this will do it:
			NSString *fourDigitYearFormat = [[dateFormatter dateFormat]
											 stringByReplacingOccurrencesOfString:@"yy"
											 withString:@"yyyy"];
			
			[dateFormatter setDateFormat:fourDigitYearFormat];
		}
		
		// There you have it:
		// NSString *outputString = [dateFormatter stringFromDate:date];
		
		// //NSLog(@"Converted Date: %@", outputString);
	}
	@catch (NSException *exception) 
	{
		date = nil;
		
		//NSLog(@"Error converting JSON Date to Date");
	}
	@finally 
	{
		return date;
	}
}

void double2Ints(double f, int p, long long *i, long long *d)
{ 
	// f = float, p=decimal precision, i=integer, d=decimal
	long long   li; 
	int   prec=1;
	
	for(int x=p;x>0;x--) 
	{
		prec*=10;
	};  // same as power(10,p)
	
	li = (long long) f;              // get integer part
	*d = (int) ((f-li)*prec);  // get decimal part
	*i = li;
}

+ (NSString *)convertDateToDateString:(NSDate *)date
{
	NSString *convertedDate = nil;
	
	@try 
	{
		// Break the Date up into its constituent parts and convert to string.
		NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];

		NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) 
													   fromDate:date];
		
		NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) 
													   fromDate:date];
		
		double milliseconds = 0.00f;
		
		milliseconds = [date timeIntervalSinceReferenceDate] * 1000;
		
		long long integerPart;
		long long decimalPart;
		
		double2Ints(milliseconds, 3, &integerPart, &decimalPart);
		
		
		convertedDate = [NSString stringWithFormat:@"%d%02d%02d%02d%02d%02d%03lld",
						 [dateComponents year],
						 [dateComponents month],
						 [dateComponents day],
						 [timeComponents hour],
						 [timeComponents minute],
						 [timeComponents second],
						 decimalPart];
		
		//NSLog(@"Converted Date = %@", convertedDate);
	}
	@catch (NSException *exception) 
	{
		convertedDate = nil;
		
		//NSLog(@"Error in Utility.convertDateToDateString.  Error: %@", [exception description]);
	}
	@finally 
	{
		return convertedDate;
	}
}

@end
