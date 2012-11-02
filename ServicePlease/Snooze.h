

#import <Foundation/Foundation.h>

#import "Utility.h"

#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

#import	"JSONRepresentation.h"

@interface Snooze : NSObject

@property (strong, nonatomic) NSString *snoozeId;
@property (strong, nonatomic) NSString *ticketId;
@property (strong, nonatomic) NSString *reasonId;
@property (strong, nonatomic) NSString * isCompleted;
@property (strong, nonatomic) NSString *completedDate;
@property (strong, nonatomic) NSString * isDateInterval;
@property (strong, nonatomic) NSString * isQuickShare;
@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;
@property int snoozeInterval;
@property (strong, nonatomic) NSString *intervalTypeId;
@property (strong, nonatomic) NSString *createDate;
@property (strong, nonatomic) NSString *editDate;

+ (NSString *)toJsonString:(Snooze *)snooze indent:(BOOL)indent;
+ (NSString *)arrayToJsonString:(NSMutableArray *)snoozeList;
+ (id)fromJsonString:(NSString *)jsonString;
+ (NSString *)updateJsonString:(Snooze *)snooze indent:(BOOL)indent;

@end
