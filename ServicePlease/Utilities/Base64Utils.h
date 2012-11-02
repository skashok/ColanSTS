//
//  Base64Utils.h
//  TestServiceTech
//
//  Created by Ed Elliott on 8/9/12.
//  Copyright (c) 2012 Ed Elliott. All rights reserved.
//

#import <Foundation/Foundation.h>

void *NewBase64Decode(const char *inputBuffer,
					  size_t length,
					  size_t *outputLength);

char *NewBase64Encode(const void *inputBuffer,
					  size_t length,
					  bool separateLines,
					  size_t *outputLength);

@interface Base64Utils : NSObject

+ (NSData *)dataFromBase64String:(NSString *)aString;
+ (NSString *)base64EncodedString:(NSData *)data;

@end
