//
//  ServicePleaseValitator.h
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 14/06/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServicePleaseValidation : NSObject


// Basic Validators
+ (BOOL) validateAlpha: (NSString *) candidate;
+ (BOOL) validateAlphaSpaces: (NSString *) candidate;
+ (BOOL) validateAlphanumeric: (NSString *) candidate;
+ (BOOL) validateNumeric: (NSString *) candidate;
+ (BOOL) validateAlphanumericDash: (NSString *) candidate;
+ (BOOL) validateStringInCharacterSet: (NSString *) string characterSet: (NSMutableCharacterSet *) characterSet;
+ (BOOL) validateNotEmpty: (NSString *) candidate;
+ (BOOL) validateEmail: (NSString *) candidate;
+ (BOOL) validateUrl: (NSString *) candidate;
@end
