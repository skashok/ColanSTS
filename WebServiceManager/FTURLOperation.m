//
//  DownloadUrlOperation.m
//  OperationsDemo
//
//  Created by Ankit Gupta on 6/6/11.
//  Copyright 2011 Pulse News. All rights reserved.
//

#import "FTURLOperation.h"
#import "BlobEntity.h"
#import "Base64Utils.h"

@implementation FTURLOperation

@synthesize error = error_, data = data_;
@synthesize connectionURL = connectionURL_;

@synthesize Type;
@synthesize blobBytes;
@synthesize blobTypeId;
@synthesize BlobId;
@synthesize currentFileUrl;

#pragma mark -
#pragma mark Initialization & Memory Management


- (id)initWithJSON:(NSString *)type solutionId:(NSString *)BlobIdString blobBytes:(NSData *)blobBytesData blobTypeId:(NSString *)blobTypeIdString currentFileUrl:(NSString *)currentFileUrlString
{
    if( (self = [super init]) )
    {
        Type = type;
        BlobId = BlobIdString;
        blobBytes = blobBytesData;
        blobTypeId = blobTypeIdString;
        currentFileUrl = currentFileUrlString;
        
//        NSLog(@"type = %@",Type);
//        NSLog(@"BlobId = %@",BlobId);
//        NSLog(@"blobBytes = %@",blobBytes);
//        NSLog(@"blobTypeId = %@",blobTypeId);

    }
    return self;
}

- (void)dealloc
{
    data_ = nil;
    
    error_ = nil;
}

#pragma mark -
#pragma mark Start & Utility Methods

- (void)done
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    executing_ = NO;
    finished_  = YES;
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
}
-(void)canceled
{
    error_ = [[NSError alloc] initWithDomain:@"DownloadUrlOperation"
                                        code:123
                                    userInfo:nil];
	
    [self done];
	
}
- (void)start
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(start)
                               withObject:nil waitUntilDone:NO];
        return;
    }
    
    NSString *_rootUrl = @"http://sts-03.servicetrackingsystems.com/ServiceTechService";

    if( finished_ || [self isCancelled] ) { [self done]; return; }
    
    [self willChangeValueForKey:@"isExecuting"];
    executing_ = YES;
    [self didChangeValueForKey:@"isExecuting"];
        
    if(recivedData != nil)
	{
		recivedData = nil;		
	}
	    
	recivedData =[[NSMutableData alloc]init];
    
    if ((blobBytes != nil) && ([blobBytes length] > 0) )
    {
        BlobEntity *blobRequest = [[BlobEntity alloc] init];
        
        [blobRequest setBlobBytes:[Base64Utils base64EncodedString:blobBytes]];
        
        [blobRequest setBlobTypeId:blobTypeId];
        
        [blobRequest setEntityId:BlobId];
        
        NSString *jsonString = [blobRequest getJSONString];
        
        NSString *serviceOperationUrl;
        
        if ([Type isEqualToString:@"problem"])
        {
            serviceOperationUrl = [NSString stringWithFormat:@"%@/problemBlob", _rootUrl];
        }
        else if ([Type isEqualToString:@"solution"])
        {
            serviceOperationUrl = [NSString stringWithFormat:@"%@/solutionBlob", _rootUrl];
        }
        
        NSURL *serviceUrl = [[NSURL alloc] initWithString:serviceOperationUrl];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serviceUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
        
        [request setHTTPMethod:@"POST"];
        
        NSMutableData *postData = [NSMutableData data];
        
        [postData appendData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:postData];
        
        [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                        
        urlconnection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
    }
}

#pragma mark -
#pragma mark Overrides

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return executing_;
}

- (BOOL)isFinished
{
    return finished_;
}

#pragma mark -
#pragma mark Delegate Methods for NSURLConnection

// The connection failed
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    if([self isCancelled])
    {
        [self canceled];
		return;
    }
	else
    {
		data_ = nil;
		error_ =error ;
		[self done];
	}
	
	urlconnection = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if([self isCancelled])
    {
        [self canceled];
		return;
    }
    
    if(recivedData != nil)
	{
		[recivedData appendData:data];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *responseString = [[NSString alloc] initWithData:recivedData encoding:NSUTF8StringEncoding];

    NSLog(@"createSolutionBlob - Response String = %@", responseString);

    if(urlconnection != nil)
	{
		urlconnection = nil;
	}
    
    // Check if the operation has been cancelled
    if([self isCancelled])
    {
        [self canceled];
		return;
    }
	else {
		[self done];
	}
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

@end
