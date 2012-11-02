//
//  ServicePleaseValitator.m
//  ServicePlease
//
//  Created by Ashok Kumar (Colan) on 14/06/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import "ServicePleaseValidation.h"

@implementation ServicePleaseValidation


// ======================
// = Validation Methods =
// ======================


+ (BOOL) validateAlpha: (NSString *) candidate {
    return [self validateStringInCharacterSet:candidate characterSet:[NSCharacterSet letterCharacterSet]];
}

+ (BOOL) validateAlphaSpaces: (NSString *) candidate {
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet letterCharacterSet];
    [characterSet addCharactersInString:@" "];
    return [self validateStringInCharacterSet:candidate characterSet:characterSet];
}

+ (BOOL) validateAlphanumeric: (NSString *) candidate {
    return [self validateStringInCharacterSet:candidate characterSet:[NSCharacterSet alphanumericCharacterSet]];
}

+ (BOOL) validateAlphanumericDash: (NSString *) candidate {
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [characterSet addCharactersInString:@"-_."];
    return [self validateStringInCharacterSet:candidate characterSet:characterSet];
}

+ (BOOL) validateName: (NSString *) candidate {
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [characterSet addCharactersInString:@"'- "];
    return [self validateStringInCharacterSet:candidate characterSet:characterSet];
}

+ (BOOL) validateStringInCharacterSet: (NSString *) string characterSet: (NSMutableCharacterSet *) characterSet {
    // Since we invert the character set if it is == NSNotFound then it is in the character set.
    return ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) ? NO : YES;
}

+ (BOOL) validateNumeric: (NSString *) candidate
{
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    BOOL isDecimal = [nf numberFromString:candidate] != nil;

    return isDecimal;
}

+ (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx]; 
    return [urlTest evaluateWithObject:candidate];
}


+ (BOOL) validateNotEmpty: (NSString *) candidate {
    return ([candidate length] == 0) ? NO : YES;
}

+ (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
    return [emailTest evaluateWithObject:candidate];
}

@end
