//
//  DownloadUrlOperation.h
//  OperationsDemo
//
//  Created by Ankit Gupta on 6/6/11.
//  Copyright 2011 Pulse News. All rights reserved.
//

#import <Foundation/Foundation.h>

//@protocol uploadManagerDelegate <NSObject>
//@required
//-(void)uploadServicedFinished:(NSData *)data;
//-(void)uploadServicedFailedWithError:(NSError *)error message:(NSString *)message;
//@end

@interface FTURLOperation : NSOperation {
    // In concurrent operations, we have to manage the operation's state
    BOOL executing_;
    BOOL finished_;
    
    // The actual NSURLConnection management
    NSURL*    connectionURL_;
    NSURLConnection*  connection_;
    NSMutableData*    data_;
    NSURLConnection    *urlconnection;
	NSMutableData      *recivedData;
    
    NSString *BlobId;
    NSData *blobBytes;
    NSString *blobTypeId;
    NSString *Type;
}

//@property(nonatomic,assign) id <uploadManagerDelegate> uploadserviceDelegate;
@property (nonatomic,readonly) NSString *jsonString;
@property (nonatomic,readonly) NSError* error;
@property (nonatomic,readonly) NSMutableData *data;
@property (nonatomic,readonly) NSURL *connectionURL;

@property (nonatomic,readonly) NSString *Type;
@property (nonatomic,readonly) NSString *BlobId;
@property (nonatomic,readonly) NSData *blobBytes;
@property (nonatomic,readonly) NSString *blobTypeId;
@property (nonatomic,readonly) NSString *currentFileUrl;

- (id)initWithJSON:(NSString *)type solutionId:(NSString *)solutionBlobIdString blobBytes:(NSData *)blobBytesData blobTypeId:(NSString *)blobTypeIdString currentFileUrl:(NSString *)currentFileUrl;

@end
