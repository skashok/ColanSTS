//
//  ProblemBlobPacket.m
//  TestServiceTech
//
//  Created by Edward Elliott on 8/5/12.
//  Copyright (c) 2012 Ed Elliott. All rights reserved.
//

#import "ProblemBlobPacket.h"
#import <objc/runtime.h>

@implementation ProblemBlobPacket

@synthesize problemBlobId = _problemBlobId;
@synthesize problemId = _problemId;
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
	
	jsonString = [jsonString stringByReplacingOccurrencesOfString:@"problemBlobId" withString:@"ProblemBlobId"];
	jsonString = [jsonString stringByReplacingOccurrencesOfString:@"problemId" withString:@"ProblemId"];
	jsonString = [jsonString stringByReplacingOccurrencesOfString:@"blobEntryId" withString:@"BlobEntryId"];
	jsonString = [jsonString stringByReplacingOccurrencesOfString:@"blobTypeId" withString:@"BlobTypeId"];
	jsonString = [jsonString stringByReplacingOccurrencesOfString:@"blobBytes" withString:@"BlobBytes"];
	
	return jsonString;
}

+ (NSMutableArray *)createFromJSONString:(NSString *)jsonString
{
	NSMutableArray *problemBlobPackets = [[NSMutableArray alloc] init];
	
	// With options and out error
	NSError *error = nil;
	
	NSArray *arrayFromString = [jsonString yajl_JSONWithOptions:YAJLParserOptionsNone error:&error];

	if	([arrayFromString count] > 0)
	{
		for(int i = 0; i < [arrayFromString count]; i++)
		{
			ProblemBlobPacket *problemBlobPacket = [[ProblemBlobPacket alloc] init];
			
			[problemBlobPacket setProblemBlobId:[[arrayFromString objectAtIndex:i] valueForKey:@"ProblemBlobId"]];
			[problemBlobPacket setProblemId:[[arrayFromString objectAtIndex:i] valueForKey:@"ProblemId"]];
			[problemBlobPacket setBlobEntryId:[[arrayFromString objectAtIndex:i] valueForKey:@"BlobEntryId"]];
			[problemBlobPacket setBlobTypeId:[[arrayFromString objectAtIndex:i] valueForKey:@"BlobTypeId"]];
			[problemBlobPacket setBlobBytes:[[arrayFromString objectAtIndex:i] valueForKey:@"BlobBytes"]];
			
			
			NSData *blobData = [[[arrayFromString objectAtIndex:i] valueForKey:@"BlobBytes"]
								dataUsingEncoding:NSUTF8StringEncoding
								allowLossyConversion:YES];
			
			[problemBlobPacket setBlobData:blobData];
			
			[problemBlobPackets addObject:problemBlobPacket];
		}
	}
	
	return problemBlobPackets;
}

@end
