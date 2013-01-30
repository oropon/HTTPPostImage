//
//  HPResponseParser.m
//  HTMLPostSample
//
//  Created by Shogo on 2013/01/26.
//  Copyright (c) 2013年 oropon. All rights reserved.
//

#import "HPResponseParser.h"

@implementation HPResponseParser
{
    NSURLConnection*    _connection;
}

- (void)parse
{
    // Create request
    NSMutableURLRequest*   request = nil;
    if (_requestURLString) {
        NSURL*  url;
        url = [NSURL URLWithString:_requestURLString];
        if (url) {
            request = [NSMutableURLRequest requestWithURL:url];
            
            NSData*     data;
            UIImage*    image;
            image = [UIImage imageNamed:@"test"];
            data = UIImagePNGRepresentation(image);
            
            [request setHTTPMethod:@"POST"];
            [request setHTTPShouldHandleCookies:NO];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
        }
    }
    
    if (!request) {
        return;
    }
    
    // Create data buffer
    _downloadedData = [NSMutableData data];
    
    // Create connection
    _connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    // Set network state
    self.networkState = HPNetworkStateInProgress;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Notify to delegate
    if ([_delegate respondsToSelector:@selector(parser:didReceiveResponse:)]) {
        [_delegate parser:self didReceiveResponse:response];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append data
    [_downloadedData appendData:data];
    
    // Notify to delegate
    if ([_delegate respondsToSelector:@selector(parser:didReceiveData:)]) {
        [_delegate parser:self didReceiveData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Parse data
    _response = [[NSString alloc] initWithData:_downloadedData encoding:NSUTF8StringEncoding];
    
    // Set network state
    self.networkState = HPNetworkStateFinished;
    
    // Notify to delegate
    if ([_delegate respondsToSelector:@selector(parserDidFinishLoading:)]) {
        [_delegate parserDidFinishLoading:self];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Set errro
    _error = error;
    
    // Set network state
    self.networkState = HPNetworkStateError;
    
    // Notify to delegate
    if ([_delegate respondsToSelector:@selector(parser:didFailWithError:)]) {
        [_delegate parser:self didFailWithError:error];
    }

    // Finish
    _connection = nil;
}


- (void)cancel
{
    // Cancel
    if (_connection) {
        [_connection cancel];
    }
    
    // Set network state
    self.networkState = HPNetworkStateCancel;
    
    // Notify to delegate
    if ([_delegate respondsToSelector:@selector(parserDidCancel:)]) {
        [_delegate parserDidCancel:self];
    }
    
    _connection = nil;
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    // Notify to delegate
    if ([_delegate respondsToSelector:@selector(parser:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:)]) {
        [_delegate parser:self
            didSendBodyData:bytesWritten
            totalBytesWritten:totalBytesWritten
            totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }        
}

@end
