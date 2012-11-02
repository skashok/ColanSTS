//
//  TechMetrics.h
//  ServiceTech
//
//  Created by ColanInfotech on 29/10/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TechMetrics : NSObject
    
@property (nonatomic,retain) NSString *techName;
@property float  TTO;
@property float  TTC;
@property float  ATO;
@property float  ART;
@property float  FB;

@end
