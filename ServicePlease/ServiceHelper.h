//
//  ServiceHelper.h
//  NYStateSnowmobiling
//
//  Created by Edward Elliott on 4/11/11.
//  Copyright 2012 Service Tracking Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

#import "Utility.h"

#import "Organization.h"
#import "Category.h"
#import "Contact.h"
#import "Location.h"
#import "LocationInfo.h"
#import "Ticket.h"
#import "Problem.h"
#import "Solution.h"
#import "User.h"
#import "UserOrganization.h"
#import "SPTypes.h"
#import "TicketMoniter.h"
#import "Blob.h"
#import "Snooze.h"
#import "SnoozeReason.h"
#import "IntervalType.h"
#import "ApplicationType.h"
#import "DailyRecap.h"
#import "LikeUnlike.h"

@class ServiceHelper;

@protocol ASYNCServiceDelegate <NSObject>

@required

-(void)ASYNCConnectionDidFinished:(id)receivedData;
-(void)ASYNCConnectionDidFailedWithError:(NSString *)errorMessage;

@end

@interface ServiceHelper : NSObject<NSURLConnectionDelegate>
{
    NSMutableData *receivedData;
    NSURLConnection *connection;
    id currentReceivedData;
    id <ASYNCServiceDelegate>__unsafe_unretained asynchUrlDelegate;
}

@property (nonatomic,assign)id <ASYNCServiceDelegate> asynchUrlDelegate;

+ (NSString *)stringWithUrl:(NSURL *)url postData:(NSData *)postData httpMethod:(NSString *)method;
+ (id) objectWithUrl:(NSURL *)url postData:(NSData *)postData httpMethod:(NSString *)method;
+ (BOOL) connectedToInternet;

#pragma mark Category
+ (BOOL) doescategoryExist:(NSString *)categoryName;
+ (NSMutableArray *) getAllCategories;
+ (NSMutableArray *) getCategoriesByOrganization:(NSString *)organizationId;
+ (Category *) getCategory:(NSString *)categoryId;
+ (Category *) addCategory:(Category *)category;
+ (Category *) updateCategory:(Category *)category;
+ (NSString *) deleteCategory:(NSString *)categoryId;

#pragma mark Contact
+ (NSMutableArray *) getContacts;
+ (NSMutableArray *) getContactsByLocation:(NSString *)locationId;
+ (Contact *) getContact:(NSString *)contactId;

+ (BOOL) doesContactExist:(NSString *)contactName 
				firstName:(NSString *)firstName 
			   middleName:(NSString *)middleName
				 lastName:(NSString *)lastName;

+ (Contact *) addContact:(Contact *)contact;
+ (Contact *) updateContact:(Contact *)contact contactId:(NSString *)contactId;
+ (NSString *) deleteContact:(NSString *)contactId;
+ (NSString *)getUserRollid:(NSString *)userId;
+ (NSMutableArray *)getRolls;

#pragma mark ServicePlanTypes
+ (NSMutableArray *) getServicePlanTypes;

#pragma mark Organization
+ (Organization *) getOrganizationByUserId:(NSString *)userId;

#pragma mark User
+ (NSNumber *) validateUser:(NSString *)userName password:(NSString *)password;
+ (NSMutableArray *)getUsers;
+ (User *) getUserByUserName:(NSString *)userName;
+ (User *) getUserByUserId:(NSString *)userId;

#pragma mark Location
+ (NSMutableArray *) getLocations;
+ (NSMutableArray *) getLocationsByOrganization:(NSString *)organizationId;
+ (BOOL) doesLocationExist:(NSString *)locationName;
+ (Location *) addLocation:(Location *)location;
+ (Location *) updateLocation:(Location *)location;
+ (Location *) getLocation:(NSString *)locationId;
+ (NSString *) deleteLocation:(NSString *)locationId;
+ (NSString *) getLocationByLocationId:(NSString *)locationId;

#pragma mark LocationInfo
+ (NSMutableArray *) getLocationInfoList;
+ (LocationInfo *) getLocationInfoById:(NSString *)locationInfoId;
+ (BOOL) doesLocationInfoExist:(NSString *)address1 city:(NSString *)city state:(NSString *)state;
+ (LocationInfo *) addLocationInfo:(LocationInfo *)locationInfo;
+ (LocationInfo *) updateLocationInfo:(LocationInfo *)locationInfo;
+ (NSNumber *) deleteLocationInfo:(NSString *)locationInfoId;

#pragma mark Ticket
+ (NSMutableArray *) getAllTickets;
+ (NSMutableArray *) getTicketsByCategory:(NSString *)categoryId;
+ (Ticket *) addTicket:(Ticket *)ticket;
+ (Ticket *) updateTicket:(Ticket *)ticket;
+ (NSString *) deleteTicket:(NSString *)ticketId;

#pragma mark Problem
+ (NSMutableArray *) getAllProblems;
+ (NSMutableArray *) getProblemByTicket:(NSString *)ticketId;
+ (Problem *) addProblem:(Problem *)problem;
+ (Problem *) updateProblem:(Problem *)problem;
+ (NSNumber *) deleteProblem:(NSString *)problemId;
+ (NSMutableArray *) searchProblem:(NSString *)problemString;

#pragma mark Solution
+ (NSMutableArray *) getAllSolutions;
+ (NSMutableArray *) getSolutionByTicket:(NSString *)ticketId;
+ (Solution *) addSolution:(Solution *)solution;
+ (Solution *) updateSolution:(Solution *)solution;
+ (NSNumber *) deleteSolution:(NSString *)solutionId;
+ (NSMutableArray *) searchSolution:(NSString *)solutionString;

#pragma mark SendEmailNotification
+ (BOOL ) sendNotificationEmail:(Location *)location emaillocationInfoDetail:(LocationInfo *)locationinfo;
+ (BOOL ) sendTicketNotificationEmail:(NSString *)jsonString;
+ (NSString *) sendTextNotificationPhoneDestination:(NSString *)phoneDestination Message:(NSString *)message CustomerNickname:(NSString *) customerNickname Username:(NSString *)username Password:(NSString *)password;


#pragma mark TicketMonitor
+ (NSMutableArray *) getTicketMonitorRows;
+ (NSMutableArray *) getTicketMonitorRowsByLocations:(NSString *)locationIds;
+ (NSMutableArray *) getTicketMonitorRowsByStatus:(NSString *)statusIds;
+ (NSMutableArray *) getticketMonitorRowsByCategory:(NSString *)categoryIds;
+ (NSMutableArray *) getticketMonitorRowsByContactId:(NSString *)ContactIds;
+ (NSMutableArray *) getticketMonitorRowsByUserId:(NSString *)userId;
+ (NSMutableArray *) getticketMonitorRowsByServicePlanTypeIds:(NSString *)
servicePlanName;
+ (NSMutableArray *) getTicketMonitorRowsByTE:(NSString *)statusIds;
+ (NSMutableArray *) assignTicket:(NSString *)ticketId andTechid:(NSString *)techID;

#pragma mark Blob
+ (void) createSolutionBlob:(NSString *)solutionBlobId blobBytes:(NSData *)blobBytes blobTypeId:(NSString *)blobTypeId;
+ (void) createProblemBlob:(NSString *)problemBlobId blobBytes:(NSData *)blobBytes blobTypeId:(NSString *)blobTypeId;

+ (NSMutableArray *)getSolutionBlobs:(NSString *)solutionId;
+ (NSMutableArray *)getProblemBlobs:(NSString *)problemId;

#pragma mark Techservice

+ (NSMutableArray *)getTotalticketopen:(NSMutableArray *)receivedTechIdArray startDate:(NSString *)receiveStartDate endDate:(NSString *)receiveendDate;

+(NSMutableArray *)getTicketclose:(NSMutableArray *)receivedTechIdArray startDate:(NSString *)receiveStartDate endDate:(NSString *)receiveendDate;

+ (NSMutableArray *)averageTimeToCloseByTech:(NSMutableArray *)receivedTechIdArray startDate:(NSString *)receiveStartDate endDate:(NSString *)receiveendDate;

+ (NSMutableArray *)averageResponseTime:(NSMutableArray *)receivedTechIdArray startDate:(NSString *)receiveStartDate endDate:(NSString *)receiveendDate;

#pragma mark - KD Search
+ (NSMutableArray *) problemKnowledgeSearch:(NSString *)problemString;
- (NSMutableArray *) solutionKnowledgeSearch:(NSString *)solutionString;
+ (NSMutableArray *) searchProblemsByLocations:(NSString *)problemString;
+ (NSMutableArray *) searchProblemsByCategories:(NSString *)problemString;
+ (NSMutableArray *) searchSolutionsByLocations:(NSString *)solutionString;
+ (NSMutableArray *) searchSolutionsByCategories:(NSString *)solutionString;

#pragma mark - SNOOZE
+ (Snooze *) addSnooze:(Snooze *)snoozeBody;
+ (NSString *) deleteSnooze:(NSString *)snoozeId;
+ (Snooze *) updateSnooze:(Snooze *)updatesnooze;
+ (Snooze *) getSnoozeBySnoozeId:(NSString *)snoozeId;
+ (NSMutableArray *) getAllSnooze;

#pragma mark - LikeUnlike

+ (LikeUnlike *) addLikeUnlike:(LikeUnlike *)likeUnlikeBody;
+ (NSMutableArray *) getAllLikeUnlikeByTechId:(NSString *)techId;

#pragma mark - IntervalTypes
+ (NSMutableArray *) getAllIntervalTypes;
+ (BOOL) doesIntervalTypeExist:(NSString *)intervalTypeName;
+ (IntervalType *) addIntervalType:(IntervalType *)intervalTypeBody;
+ (IntervalType *) updateIntervalType:(IntervalType *)intervalTypeBody;
+ (NSString *) deleteIntervalType:(NSString *)intervalTypeId;

#pragma mark - SnoozeReasons
+ (NSMutableArray *) getAllSnoozeReasons;
+ (BOOL) doesSnoozeReasonExist:(NSString *)snoozeReasonName;
+ (SnoozeReason *) addSnoozeReason:(SnoozeReason *)snoozeReasonBody;
+ (SnoozeReason *) updateSnoozeReason:(SnoozeReason *)snoozeReasonBody;
+ (NSString *) deleteSnoozeReason:(NSString *)snoozeReasonId;

#pragma mark ApplicationType

+ (BOOL) doesApplicationTypeExist:(NSString *)applicationName;
+ (NSMutableArray *) getAllApplicationTypes;
+ (ApplicationType *) getApplicationType:(NSString *)applicationTypeId;
+ (ApplicationType *) addApplicationType:(ApplicationType *)applicationType;
+ (ApplicationType *) updateApplicationType:(ApplicationType *)applicationType applicationTypeId:(NSString *)applicationTypeId;
+ (NSString *) deleteApplicationType:(NSString *)ApplicationTypeId;

#pragma mark - ASYNCConnectionDelegate Methods

-(void)stringWithUrl:(NSURL *)url postData:(NSData *)postData httpMethod:(NSString *)method;
-(void)cancelRequest;

#pragma mark - DailyRecap

+(NSString *)addDailyRecaplist:(NSString *)jsonString;
+ (DailyRecap *) getDailyRecap:(NSString *)dailyRecapSettingsId;
+ (DailyRecap *) addDailyRecap:(DailyRecap *)dailyRecap;
+ (DailyRecap *) updateDailyRecap:(DailyRecap *)dailyRecap dailyRecapId:(NSString *)dailyRecapId;
+ (NSString *) deleteDailyRecap:(NSString *)dailyRecapSettingsId;

@end
