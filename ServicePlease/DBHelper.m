/*
 DBHelper.m
 
 DBHelper is the Helper class for creating and mainpulating the Database.
 
 It has Methods for Insertion, Deletion and updatio.
 
 Methods will accepts different set of parameters according to the context.
 
 */

#import "DBHelper.h"
#import "TicketMoniter.h"

//static sqlite3_stmt *update_statment = nil;

static sqlite3_stmt *delete_statment = nil;
static sqlite3_stmt *insert_statement = nil;

@implementation DBHelper

@synthesize  listOfItems, file;
@synthesize appDelegate;

- (NSInteger)insertIntoDatabase:(NSString *)action onObject:(NSString *)object valueForObject:(NSString *)value {
    
    self.appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *techName=[[[[self appDelegate ]selectedEntities]user]userName];
    NSDate *newDate;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:~ NSTimeZoneCalendarUnit fromDate:[NSDate date]];
    newDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
  
    NSString *currentTimeStamp=[NSString stringWithFormat:@"%@",newDate];
    
    static char *sql = "INSERT INTO DailyRecap (Tech,Action,Object,Value,TimeStamp) VALUES(?,?,?,?,?)";
    
    if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK)
    {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	sqlite3_bind_text(insert_statement, 1, [techName UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(insert_statement, 2, [action UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(insert_statement, 3, [object UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(insert_statement, 4, [value UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement, 5, [currentTimeStamp  UTF8String],-1, SQLITE_TRANSIENT);
    
	int success = sqlite3_step(insert_statement);
	
	sqlite3_finalize(insert_statement);
	
	if (success != SQLITE_ERROR)
    {
		return sqlite3_last_insert_rowid(database);
	}
    return -1;
}

- (NSMutableArray *)loadData {
	
	// Setup the SQL Statement and compile it for faster access
	const char *sqlStatement = "select * from DailyRecap";
	sqlite3_stmt *compiledStatement;
	
	if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
		listOfItems = [[NSMutableArray alloc] init];
		// Loop through the results and add them to the feeds array
		
		while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            // Read the data from the result row
			// Create a new BusStop object with the data from the database
			
            dailyRecapOBJ = [[DailyRecapDB alloc] init];
            
			if([NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)] != nil);
			dailyRecapOBJ.tech = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
			
			if([NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] != nil);
			dailyRecapOBJ.action = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)];
			
			if([NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)] != nil);
			dailyRecapOBJ.object = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,2)];
            
            if(sqlite3_column_text(compiledStatement,3)!= nil);
            dailyRecapOBJ.value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,3)];
            
			if(sqlite3_column_text(compiledStatement,4) != nil);
			dailyRecapOBJ.timeStamp = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,4)];
            
			[listOfItems addObject:dailyRecapOBJ];
        }
	}
	// Release the compiled statement from memory
	sqlite3_finalize(compiledStatement);
	
	return listOfItems;
}

- (void) deleteFromDatabase
{
    const char *sql = "DELETE FROM DailyRecap";
	
    if (sqlite3_prepare_v2(database, sql, -1, &delete_statment, NULL) != SQLITE_OK)
    {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	//sqlite3_bind_int(delete_statment, 1, [pk intValue]);
	int success = sqlite3_step(delete_statment);
	
	if (success != SQLITE_DONE)
    {
        NSAssert1(0, @"Error: failed to save priority with message '%s'.", sqlite3_errmsg(database));
	}
    
    sqlite3_finalize(delete_statment);
}

- (id) init
{
	self = [super init];
	
    if (self != nil)
    {
		[self checkAndCreateDatabase:@"ServiceTech.sqlite"];
        
		if (sqlite3_open([dataBasePath UTF8String], &database) == SQLITE_OK) {
			NSLog(@"Database Connectet");
		}else {
			// Even though the open failed, call close to properly clean up resources.
			sqlite3_close(database);
			NSLog(@"Database Disconnectet");
			NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
			// Additional error handling, as appropriate...
		}
	}
	
	return self;
}

-(BOOL)checkAndCreateDatabase:(NSString*)dataBaseName
{
	BOOL success = NO;
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [documentPaths objectAtIndex:0];
	NSString *fromDirectoryToDatabasePath = [documentsDirectory stringByAppendingPathComponent:dataBaseName];
	if(fromDirectoryToDatabasePath != nil)
	{
		if(dataBasePath != nil)
		{
            dataBasePath =  nil;
		}
		dataBasePath = [[NSMutableString alloc] init];
		[dataBasePath setString:fromDirectoryToDatabasePath];
	}
	else
	{
		NSLog(@"In Documents directory the database not available");
		return success;
	}
	if(dataBasePath != nil)
	{
		NSFileManager *fileManager = [NSFileManager defaultManager];
		success = [fileManager fileExistsAtPath:dataBasePath];
		if(success)
			return success;
		
		NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dataBaseName];
		success = [fileManager copyItemAtPath:databasePathFromApp toPath:dataBasePath error:nil];
	}
	return success;
}

- (void)insertDailyRecapIntoDatabase:(NSString *)action onObject:(NSString *)object valueForObject:(NSString *)value {
   
    self.appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSDate *currentdate=[[NSDate alloc]init];
    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"hh:mm a"];
    
    NSUserDefaults *defalults=[NSUserDefaults standardUserDefaults];
    NSDate *startTime=[defalults objectForKey:@"startTime"];
    NSDate *endTime=[defalults objectForKey:@"endTime"];
    //  NSString *currentTime=[formater stringFromDate:currentdate];
    //  NSLog(@"currentTime= %@",currentdate);
    //  NSLog(@"startTime= %@",startTime);
    //  NSLog(@"endTime= %@",endTime);
   
    if ([defalults boolForKey:@"DeailyRecapIsActvie"])
    {
        if ([formater stringFromDate:startTime]<[formater stringFromDate:currentdate]&&[formater stringFromDate:currentdate]>[formater stringFromDate:endTime])
        {
            [self insertIntoDatabase:action onObject:object valueForObject:value]; 
            
        }
    }
}

@end
