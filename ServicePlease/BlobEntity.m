//
//  BlobEntity.m
//  TestServiceTech
//
//  Created by Ed Elliott on 8/3/12.
//  Copyright (c) 2012 Ed Elliott. All rights reserved.
//

#import "BlobEntity.h"
#import "Base64Utils.h"
#import <objc/runtime.h>

@implementation BlobEntity

@synthesize blobBytes = _blobBytes;
@synthesize blobTypeId = _blobTypeId;
@synthesize entityId = _entityId;

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
		
	jsonString = [jsonString stringByReplacingOccurrencesOfString:@"blobTypeId" withString:@"BlobTypeId"];
	jsonString = [jsonString stringByReplacingOccurrencesOfString:@"blobBytes" withString:@"BlobBytes"];
	jsonString = [jsonString stringByReplacingOccurrencesOfString:@"entityId" withString:@"EntityId"];
	
	return jsonString;
}

+ (NSMutableArray *)createFromJSONString:(NSString *)jsonString
{
	NSMutableArray *blobEntities = [[NSMutableArray alloc] init];
	
	// With options and out error
	NSError *error = nil;
	
	NSArray *arrayFromString = [jsonString yajl_JSONWithOptions:YAJLParserOptionsNone error:&error];
	
	if	([arrayFromString count] > 0)
	{
		for(int i = 0; i < [arrayFromString count]; i++)
		{
			BlobEntity *blobEntity = [[BlobEntity alloc] init];
			
			[blobEntity setBlobTypeId:[[arrayFromString objectAtIndex:i] valueForKey:@"BlobTypeId"]];
			[blobEntity setEntityId:[[arrayFromString objectAtIndex:i] valueForKey:@"EntityId"]];
			
			NSData *blobData = [[[arrayFromString objectAtIndex:i] valueForKey:@"BlobBytes"]
										   dataUsingEncoding:NSUTF8StringEncoding
										allowLossyConversion:YES];
			
			[blobEntity setBlobBytes:[Base64Utils base64EncodedString:blobData]];
			
			[blobEntities addObject:blobEntity];
		}
	}
	
	return blobEntities;
}

@end
