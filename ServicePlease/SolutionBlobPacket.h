//
//  SolutionBlobPacket.h
//  TestServiceTech
//
//  Created by Edward Elliott on 8/5/12.
//  Copyright (c) 2012 Ed Elliott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YAJLiOS/YAJL.h>

@interface SolutionBlobPacket : NSObject

@property (strong, nonatomic) NSString *solutionBlobId;

@property (strong, nonatomic) NSString *solutionId;

@property (strong, nonatomic) NSString *blobEntryId;

@property (strong, nonatomic) NSString *blobTypeId;

@property (strong, nonatomic) NSString *blobBytes;

@property (strong, nonatomic) NSData *blobData;

- (NSString *)getJSONString;
+ (NSMutableArray *)createFromJSONString:(NSString *)jsonString;

@end
