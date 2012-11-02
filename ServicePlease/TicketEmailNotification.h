//
//  TicketEmailNotification.h
//  ServicePlease
//
//  Created by Ashokkumar Kandaswamy on 11/07/12.
//  Copyright (c) 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ticket.h"

@interface TicketEmailNotification : NSObject

+ (NSString *)JsonContentofEmailWithIndent:(BOOL)indent toAddress:(NSString *)toAddress withBodyContent:(NSString *)bodyText SubjectContent:(NSString *)subjectText;

@end
