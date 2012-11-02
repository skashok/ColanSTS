//
//  BlobEntity.h
//  TestServiceTech
//
//  Created by Ed Elliott on 8/3/12.
//  Copyright (c) 2012 Ed Elliott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YAJLiOS/YAJL.h>

@interface BlobEntity : NSObject

@property(strong, nonatomic) NSString *blobBytes;
@property(strong, nonatomic) NSString *blobTypeId;
@property(strong, nonatomic) NSString *entityId;

- (NSString *)getJSONString;
+ (NSMutableArray *)createFromJSONString:(NSString *)jsonString;

@end
