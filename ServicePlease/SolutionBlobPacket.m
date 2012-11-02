//
//  SolutionBlobPacket.m
//  TestServiceTech
//
//  Created by Edward Elliott on 8/5/12.
//  Copyright (c) 2012 Ed Elliott. All rights reserved.
//

#import "SolutionBlobPacket.h"
#import <objc/runtime.h>

@implementation SolutionBlobPacket

@synthesize solutionBlobId = _solutionBlobId;
@synthesize solutionId = _solutionId;
@synthesize blobTypeId = _blobTypeId;
@synthesize blobEntryId = _blobEntryId;
@synthesize blobBytes = _blobBytes;
@synthesize blobData = _blobData;

- (NSString *)getJSONString
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	
    unsigned count;
	
    objc_property_t *properties = class_copyPropertyList([self class], &count);
	
    for (int i = 0; i < count; i++)
	{
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [dict setObject:[self valueForKey:key] forKey:key];
    }
	
    free(properties);
	
	NSString *jsonString = @"";
	
	jsonString = [dict yajl_JSONStringWithOptions:YAJLGenOptionsIncludeUnsupportedTypes | YAJLGenOptionsBeautify indentString:@"    "];
	
	jsonString = [jsonString stringByReplacingOccurrencesOfString:@"solutionBlobId" withString:@"SolutionBlobId"];
	jsonString = [jsonString stringByReplacingOccurrencesOfString:@"solutionId" withString:@"SolutionId"];
	jsonString = [jsonString stringByReplacingOccurrencesOfString:@"blobEntryId" withString:@"BlobEntryId"];
	jsonString = [jsonString stringByReplacingOccurrencesOfString:@"blobTypeId" withString:@"BlobTypeId"];
	jsonString = [jsonString stringByReplacingOccurrencesOfString:@"blobBytes" withString:@"BlobBytes"];
	
	return jsonString;
}

+ (NSMutableArray *)createFromJSONString:(NSString *)jsonString
{
	NSMutableArray *solutionBlobPackets = [[NSMutableArray alloc] init];
	
	// With options and out error
	NSError *error = nil;
	
	NSArray *arrayFromString = [jsonString yajl_JSONWithOptions:YAJLParserOptionsNone error:&error];
	
	if	([arrayFromString count] > 0)
	{
		for(int i = 0; i < [arrayFromString count]; i++)
		{
			SolutionBlobPacket *solutionBlobPacket = [[SolutionBlobPacket alloc] init];
			
			[solutionBlobPacket setSolutionBlobId:[[arrayFromString objectAtIndex:i] valueForKey:@"SolutionBlobId"]];
			[solutionBlobPacket setSolutionId:[[arrayFromString objectAtIndex:i] valueForKey:@"SolutionId"]];
			[solutionBlobPacket setBlobEntryId:[[arrayFromString objectAtIndex:i] valueForKey:@"BlobEntryId"]];
			[solutionBlobPacket setBlobTypeId:[[arrayFromString objectAtIndex:i] valueForKey:@"BlobTypeId"]];
			[solutionBlobPacket setBlobBytes:[[arrayFromString objectAtIndex:i] valueForKey:@"BlobBytes"]];
			
			
			NSData *blobData = [[[arrayFromString objectAtIndex:i] valueForKey:@"BlobBytes"]
								dataUsingEncoding:NSUTF8StringEncoding
								allowLossyConversion:NO];
			
			[solutionBlobPacket setBlobData:blobData];
			
			[solutionBlobPackets addObject:solutionBlobPacket];
		}
	}
	return solutionBlobPackets;
}

@end
