//
//  HPResponseParser.h
//  HTMLPostSample
//
//  Created by Shogo on 2013/01/26.
//  Copyright (c) 2013年 oropon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    HPNetworkStateNotConnected,
    HPNetworkStateInProgress,
    HPNetworkStateError,
    HPNetworkStateCancel,
    HPNetworkStateFinished,
} HPNetworkState;

@interface HPResponseParser : NSObject<NSURLConnectionDataDelegate>

// Proprety
@property (nonatomic) id delegate;
@property (nonatomic) int networkState;
@property (nonatomic, retain) NSString* requestURLString;
@property (readonly) NSString* response;
@property (nonatomic, readonly) NSMutableData* downloadedData;
@property (nonatomic, readonly) NSError* error;

// Parse
- (void)parse;

// Cancel
- (void)cancel;

@end

// Delegate
@interface NSObject (HPResporseParserDelegate)

- (void)parser:(HPResponseParser*)parser didReceiveResponse:(NSURLResponse*)response;
- (void)parser:(HPResponseParser*)parser didReceiveData:(NSData*)data;
- (void)parserDidFinishLoading:(HPResponseParser*)parser;
- (void)parser:(HPResponseParser*)parser didFailWithError:(NSError*)error;
- (void)parserDidCancel:(HPResponseParser*)parser;
- (void)parser:(HPResponseParser*)parser didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;

@end
