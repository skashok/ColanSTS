/*
 DBHelper.h
 
 
 DBHelper is the Helper class for creating and mainpulating the Database.
 
 It has Methods for Insertion, Deletion and updatio.
 
 Methods will accepts different set of parameters according to the context.
 
 
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "DailyRecapDB.h"
#import "AppDelegate.h"

@interface DBHelper : NSObject {
	
    NSMutableArray	   *listOfItems;
	NSString           *file;
	sqlite3            *database;
	NSMutableString	   *dataBasePath;
	DailyRecapDB       *dailyRecapOBJ;
}

@property (nonatomic, retain) AppDelegate      *appDelegate;
@property (nonatomic, retain) NSMutableArray   *listOfItems;
@property (nonatomic, retain) NSString		   *file;

- (NSInteger)insertIntoDatabase:(NSString *)action onObject:(NSString *)object valueForObject:(NSString *)value;

- (NSMutableArray *)loadData;

- (void) deleteFromDatabase;

-(BOOL)checkAndCreateDatabase:(NSString*)dataBaseName;

- (void)insertDailyRecapIntoDatabase:(NSString *)action onObject:(NSString *)object valueForObject:(NSString *)value;

@end
