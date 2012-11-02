//
//  ProblemBlob.h
//  TestServiceTech
//
//  Created by Ed Elliott on 8/3/12.
//  Copyright (c) 2012 Ed Elliott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProblemBlob : NSObject

@property(strong, nonatomic) NSString *problemBlobId;
@property(strong, nonatomic) NSString *problemId;
@property(strong, nonatomic) NSString *blobId;
@property(strong, nonatomic) NSDate *createDate;
@property(strong, nonatomic) NSDate *editDate;

@end
